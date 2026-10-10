# ReVanced builds — selected apps

This repository configuration builds only these app variants using the source project's existing build scripts:

- Instagram — Piko (ARM64)
- Twitter/X — Piko NewX
- YouTube — ReVanced Extended (Anddea)
- YouTube Music — ReVanced Extended (Anddea)

The daily workflow checks upstream patch updates at 09:00 UTC and can also be run manually. The manual build workflow lets you choose one app. The four `include-patches` lists are empty so all compatible patches are available by default; see the upstream patch projects for the current patch inventory.

## Downloads

After a successful build, APKs are published to the repository's `all` release: https://github.com/your-username/your-repository/releases/tag/all

YouTube and YouTube Music generally require a compatible GMS Core/MicroG installation when using non-root builds. Read the upstream project's setup notes before installing.

## Source and license

This configuration is based on [FiorenMas/Revanced-And-Revanced-Extended-Non-Root](https://github.com/FiorenMas/Revanced-And-Revanced-Extended-Non-Root). Keep its license and attribution files when creating your repository. This ZIP only contains configuration changes; it does not contain the full source tree.
