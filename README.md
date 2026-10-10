# ReVanced builds — selected apps (ARM64 only)

This template configuration publishes only these app variants, and only ARM64 (`arm64-v8a`) builds:

- Instagram — Piko (ARM64)
- Twitter/X — Piko NewX (ARM64)
- YouTube — ReVanced Extended (Anddea, ARM64)
- YouTube Music — ReVanced Extended (Anddea, ARM64)

The daily update checker runs at 09:00 UTC and can also be run manually. Manual builds let you choose one of the four apps. The daily checker compares the upstream patch bundle timestamps against the corresponding APK on the `all` release.

## Instagram patch selection

Before each Instagram build, `src/etc/update-instagram-patches.sh` reads the current stable patch list from [crimera/piko](https://github.com/crimera/piko), selects every patch compatible with Instagram, and writes the include list. The only intentionally excluded patches are:

- `Clone`
- `Allow user network certificate`
- `Unlock employee options`

This explicitly enables opt-in patches too, including **View live anonymously**, instead of relying on upstream defaults. The updater checks that `View live anonymously` is still present and compatible; it fails rather than silently omitting it if upstream removes or renames it.

The other three app variants keep the upstream default patch selection. The earlier request to enable every opt-in patch for all apps is not applied to those apps.

## AMOLED theme behavior

AMOLED-related controls differ by patch project; there is not one shared build-time switch across all four projects.

- **Instagram Piko:** `src/options/piko.json` sets the Piko `Theme` patch option `amoled=true`. Upstream documents this build option as applying to the fixed theme on Android 8–11. On Android 12+, Piko uses a runtime AMOLED control in Piko settings, which still needs to be enabled in the app.
- **Twitter/X Piko NewX:** the current `NewX: Theme` patch exposes no patch options. Its published description lists the original, Material You, high-contrast and Dim styles, but not an AMOLED enable flag. There is no supported upstream build-time option to force AMOLED for this build.
- **YouTube and YouTube Music Anddea:** the `Theme` patch's `darkThemeColor` option is set to pure black (`#FF000000`) for the custom dark theme/splash color. The patch repository does not expose an option that changes the app's runtime dark-theme selector default; the selector initially defaults to `stock` for YouTube and `modern_youtube` for YouTube Music. After installing, choose **Amoled Black** in each app's ReVanced Extended theme settings to make the runtime theme use the pure-black preset.

These runtime limitations are from the upstream patch options/source; the workflow does not falsify them by pretending a splash-color option enables the runtime AMOLED selector.

## Downloads

After a successful build, APKs are published to the repository's `all` release: `https://github.com/OWNER/REPOSITORY/releases/tag/all`.

Expected APKs:

- `instagram-arm64-v8a-piko.apk`
- `twitter-piko-newx.apk` (ARM64-only native libraries)
- `youtube-stable-arm64-v8a-anddea.apk`
- `youtube-music-stable-arm64-v8a-anddea.apk`

YouTube and YouTube Music generally require a compatible GMS Core/MicroG installation when using non-root builds. Read the upstream project's setup notes before installing.

## Apply this overlay

Create your own repository using GitHub's **Use this template → Create a new repository** option, then extract this ZIP and upload/replace the files at the repository root. This overlay does not include Git history or duplicate the entire source tree; it changes the build scripts, patch selection, app options, and workflows.

## Source and license

Based on [FiorenMas/Revanced-And-Revanced-Extended-Non-Root](https://github.com/FiorenMas/Revanced-And-Revanced-Extended-Non-Root). Keep its license and attribution files in the repository. See [crimera/piko](https://github.com/crimera/piko), [crimera/piko-newx](https://github.com/crimera/piko-newx), and [anddea/revanced-patches](https://github.com/anddea/revanced-patches) for the respective upstream patch definitions.
