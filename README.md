# ReVanced builds — selected apps, ARM64 only

This is a configuration overlay for a repository created with GitHub's **Use this template** option. It keeps only the requested app families and publishes ARM64 (`arm64-v8a`) builds where available:

- Instagram — Piko Stable and Piko Beta
- Twitter/X — Piko NewX (latest upstream release)
- YouTube — ReVanced Extended by Anddea Stable and Beta
- YouTube Music — ReVanced Extended by Anddea Stable and Beta

The manual **Build selected app** workflow offers all seven variants above. Beta choices use the upstream prerelease patch channel and, for Instagram, the upstream beta APK. The original project does not currently expose a separate prerelease track for Piko NewX, so that option stays on its latest upstream release. Check [Piko NewX releases](https://github.com/crimera/piko-newx/releases) for upstream availability.

The daily update checker runs at 09:00 UTC and can also be started manually. It checks stable and prerelease patch bundles for Instagram Piko and Anddea YouTube/YouTube Music, plus the regular Piko NewX releases. When an upstream patch bundle updates, the corresponding app variant is rebuilt and its artifact updated in the repository's `all` release.

## Instagram patch selection

Before each Instagram Stable or Beta build, `src/etc/update-instagram-patches.sh` reads that channel's patch list from [crimera/piko](https://github.com/crimera/piko), selects every patch compatible with Instagram, and writes the include list. The only intentionally excluded patches are:

- `Clone`
- `Allow user network certificate`
- `Unlock employee options`

This explicitly enables opt-in patches too, including **View live anonymously**, instead of relying on upstream defaults. The updater checks that `View live anonymously` is present and compatible; it fails rather than silently omitting it if upstream removes or renames it. Stable and Beta builds sync their respective patch channel independently.

YouTube and YouTube Music keep the upstream default patch-selection behavior. Twitter/X Piko NewX keeps the upstream defaults except that **NewX: Restore Twitter branding** is explicitly enabled, which restores the old Twitter name and icons instead of X branding.

## AMOLED theme behavior

AMOLED-related controls differ by patch project; there is not one shared build-time switch across all four projects.

- **Instagram Piko:** `src/options/piko.json` sets the Piko `Theme` patch option `amoled=true` in both Stable and Beta builds. Upstream documents this build option as applying to the fixed theme on Android 8–11. On Android 12+, Piko uses a runtime AMOLED control in Piko settings, which still needs to be enabled in the app.
- **Twitter/X Piko NewX:** `src/patches/twitter-piko/include-patches` explicitly enables `NewX: Restore Twitter branding`, an opt-in patch that restores the old Twitter name and icons instead of X branding. The current `NewX: Theme` patch exposes no patch options. Its published description lists the original, Material You, high-contrast and Dim styles, but not an AMOLED enable flag. There is no supported upstream build-time option to force AMOLED for this build.
- **YouTube and YouTube Music Anddea:** `src/options/anddea.json` sets the `Theme` patch's custom dark-theme color to pure black (`#FF000000`) for stable and beta patch builds. The patch repository does not expose an option that changes the app's runtime dark-theme selector default; after installing, choose **Amoled Black** in each app's ReVanced Extended theme settings to use the pure-black preset.

These runtime limitations are based on upstream patch options/source; the workflow does not misrepresent a splash-color option as enabling the runtime AMOLED selector.

## Published APKs

After a successful build, APKs are published to the repository's `all` release: `https://github.com/OWNER/REPOSITORY/releases/tag/all`.

Expected files:

- `instagram-arm64-v8a-piko.apk` — Instagram Piko Stable
- `instagram-beta-arm64-v8a-piko.apk` — Instagram Piko Beta
- `twitter-piko-newx.apk` — Twitter/X Piko NewX (ARM64 native libraries)
- `youtube-stable-arm64-v8a-anddea.apk` — YouTube Anddea Stable
- `youtube-beta-arm64-v8a-anddea.apk` — YouTube Anddea Beta
- `youtube-music-stable-arm64-v8a-anddea.apk` — YouTube Music Anddea Stable
- `youtube-music-beta-arm64-v8a-anddea.apk` — YouTube Music Anddea Beta

YouTube and YouTube Music generally require a compatible GMS Core/MicroG installation when using non-root builds. Read the upstream project setup notes before installing.

## Apply this overlay

Create your repository using GitHub's **Use this template → Create a new repository** option, then extract this ZIP and upload/replace the files at the repository root. This overlay does not include Git history or duplicate the entire source tree; it changes the build scripts, patch selection, app options, and workflows.

## Source and license

Based on [FiorenMas/Revanced-And-Revanced-Extended-Non-Root](https://github.com/FiorenMas/Revanced-And-Revanced-Extended-Non-Root). Keep its license and attribution files in the repository. See [crimera/piko](https://github.com/crimera/piko), [crimera/piko-newx](https://github.com/crimera/piko-newx), and [anddea/revanced-patches](https://github.com/anddea/revanced-patches) for the respective upstream patch definitions.
