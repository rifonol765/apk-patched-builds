#!/bin/bash
# Piko Instagram build. This repository publishes Instagram Piko, not classic Twitter Piko.
source src/build/utils.sh

# Override the shared helper so the produced APK retains only arm64-v8a native libraries.
patch() {
    green_log "[+] Patching $1:"
    if [ -f "./download/$1.apk" ]; then
        unset CI GITHUB_ACTION GITHUB_ACTIONS GITHUB_ACTOR GITHUB_ENV GITHUB_EVENT_NAME GITHUB_EVENT_PATH GITHUB_HEAD_REF GITHUB_JOB GITHUB_REF GITHUB_REPOSITORY GITHUB_RUN_ID GITHUB_RUN_NUMBER GITHUB_SHA GITHUB_WORKFLOW GITHUB_WORKSPACE RUN_ID RUN_NUMBER
        eval java -jar morphe-desktop-*.jar patch -p *.mpp --options-file ./src/options/$2.json --striplibs arm64-v8a --out=./release/$1-$2.apk$excludePatches$includePatches --keystore=./src/keystore/morphe.keystore --force --continue-on-error ./download/$1.apk
        unset version lock_version excludePatches includePatches
    else
        red_log "[-] Not found $1.apk"
        exit 1
    fi
}

piko_dl() {
    dl_gh "morphe-desktop" "MorpheApp" "latest"
    dl_gh "piko" "crimera" "latest"
}

build_instagram() {
    piko_dl
    get_patches_key "instagram-piko"
    get_apk "com.instagram.android" "instagram-arm64-v8a" "bundle" "arm64-v8a" "120-640dpi" "Android 9.0+"
    patch "instagram-arm64-v8a" "piko"
}

# Run 2 builds Instagram. Classic Twitter Piko (run 1) is intentionally omitted.
case "${1:-2}" in
    2) build_instagram ;;
    *) echo "Only Instagram Piko (run 2) is retained in this build configuration." >&2; exit 2 ;;
esac
