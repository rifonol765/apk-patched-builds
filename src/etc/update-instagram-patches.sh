#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
release_api="https://api.github.com/repos/crimera/piko/releases/latest"
tmp_release="$(mktemp)"
tmp_json="$(mktemp)"
tmp_include="$(mktemp)"
trap 'rm -f "$tmp_release" "$tmp_json" "$tmp_include"' EXIT

excluded='["Clone","Allow user network certificate","Unlock employee options"]'
include_file="$repo_root/src/patches/instagram-piko/include-patches"
exclude_file="$repo_root/src/patches/instagram-piko/exclude-patches"

# Match the patch list to the latest stable release, not unreleased commits on main.
curl --fail --silent --show-error --location "$release_api" --output "$tmp_release"
tag="$(jq -er '.tag_name | select(type == "string" and length > 0)' "$tmp_release")"
list_url="https://raw.githubusercontent.com/crimera/piko/${tag}/patches-list.json"
curl --fail --silent --show-error --location "$list_url" --output "$tmp_json"
jq -e '.patches | type == "array"' "$tmp_json" >/dev/null

jq -r --arg package "com.instagram.android" --argjson excluded "$excluded" '
  .patches[]
  | select(any(.compatiblePackages[]?; .packageName == $package))
  | select(.name as $name | ($excluded | index($name)) == null)
  | .name
' "$tmp_json" | sort -f > "$tmp_include"

# Fail instead of silently publishing a build that misses this specifically requested patch.
grep -Fxq 'View live anonymously' "$tmp_include" || {
  echo "ERROR: Upstream Piko patch list no longer includes the Instagram 'View live anonymously' patch." >&2
  exit 1
}

install -D -m 0644 "$tmp_include" "$include_file"
printf '%s\n' 'Clone' 'Allow user network certificate' 'Unlock employee options' > "$exclude_file"
version="$(jq -r '.version // "unknown"' "$tmp_json")"
echo "Synchronized $(wc -l < "$include_file") Instagram-compatible Piko patches from Piko ${version} (${tag}); excluded: ${excluded}"
