#!/bin/bash
# ReVanced Extended forked by Anddea: ARM64-only outputs.
source src/build/utils.sh

# Override the shared helper so the produced APK retains only arm64-v8a native libraries.
patch() {
    green_log "[+] Patching $1:"
    if [ -f "./download/$1.apk" ]; then
        echo "Patching with Morphe"
        unset CI GITHUB_ACTION GITHUB_ACTIONS GITHUB_ACTOR GITHUB_ENV GITHUB_EVENT_NAME GITHUB_EVENT_PATH GITHUB_HEAD_REF GITHUB_JOB GITHUB_REF GITHUB_REPOSITORY GITHUB_RUN_ID GITHUB_RUN_NUMBER GITHUB_SHA GITHUB_WORKFLOW GITHUB_WORKSPACE RUN_ID RUN_NUMBER
        eval java -jar morphe-desktop-*.jar patch -p *.mpp --options-file ./src/options/$2.json --striplibs arm64-v8a --out=./release/$1-$2.apk$excludePatches$includePatches --keystore=./src/keystore/morphe.keystore --force --continue-on-error ./download/$1.apk
        unset version lock_version excludePatches includePatches
    else
        red_log "[-] Not found $1.apk"
        exit 1
    fi
}

anddea_dl() {
    dl_gh "revanced-patches" "anddea" "latest"
    dl_gh "morphe-desktop" "MorpheApp" "latest"
}

build_youtube() {
    anddea_dl
    get_patches_key "youtube-rve-anddea"
    get_apk "com.google.android.youtube" "youtube-stable" "apk"
    # The shared split helper keeps only the architecture selected by archs[i].
    i=0
    split_arch "youtube-stable" "anddea"
}

build_youtube_music() {
    anddea_dl
    get_patches_key "youtube-music-rve-anddea"
    get_apk "com.google.android.apps.youtube.music" "youtube-music-stable-arm64-v8a" "apk" "arm64-v8a"
    patch "youtube-music-stable-arm64-v8a" "anddea"
}

case "${1:-1}" in
    1) build_youtube ;;
    2) build_youtube_music ;;
    *) echo "Use 1 for YouTube or 2 for YouTube Music." >&2; exit 2 ;;
esac
