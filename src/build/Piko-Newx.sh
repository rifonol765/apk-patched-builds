#!/bin/bash
# Piko NewX build, ARM64-only.
source src/build/utils.sh

# Override the shared helper so the produced APK retains only arm64-v8a native libraries.
patch_multi() {
    green_log "[+] Patching $1:"
    if [ -f "./download/$1.apk" ]; then
        echo "Patching with Morphe"
        local mpp_args=""
        for mpp_file in *.mpp; do
            [ -f "$mpp_file" ] || continue
            mpp_args="$mpp_args -p \"$mpp_file\"$excludePatches$includePatches"
        done
        eval java -jar morphe-desktop-*.jar patch $mpp_args --options-file ./src/options/$2.json --striplibs arm64-v8a --out=./release/$1-$2.apk --keystore=./src/keystore/morphe.keystore --force --continue-on-error ./download/$1.apk
        unset version lock_version excludePatches includePatches
    else
        red_log "[-] Not found $1.apk"
        exit 1
    fi
}

piko_shim_dl() {
    dl_gh "morphe-desktop" "MorpheApp" "latest"
    dl_gh "piko-newx" "crimera" "latest"
}

piko_shim_dl
get_patches_key "twitter-piko"
version="12.24.0-prod.02"
get_apk "com.twitter.android" "twitter" "bundle" "arm64-v8a"
patch_multi "twitter" "piko-newx"
