# ublue-os/lorax-compose: compose images using lorax for OSTree Native Container images

Hi! Are you creating your own flavor of Universal Blue? Do you want to make it feel like a "real OS" by providing an OS installer? Look no more! You are in the right place.

By making use of this action you will be able to quickly create ISO installers for your custom OS with just a few lines of code.

## Usage

To use this action, you will need to be using a Fedora based container image.  This is because lorax is more readily available in Fedora.
In order to publish ISOs as part of the release process you can add it to the end of your release-please action: 

Example:

```yaml
  release-please:
  id: release-please
  ... 
  build-iso:
    name: Generate and Release ISOs
    runs-on: ubuntu-latest
    needs: release-please
    if: needs.release-please.outputs.releases_created
    container: 
      image: fedora:38
      options: --privileged -v /dev/:/dev
    steps:
      - uses: actions/checkout@v3
      - name: Generate ISO  
        uses: ublue-os/lorax-compose@v1.0.0
        id: build
        with:
          ostree-oci-ref: ghcr.io/ublue-os/silverblue-main:38
          fedora-release: 38
      - name: install github CLI
        run: |
          sudo dnf install 'dnf-command(config-manager)' -y
          sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
          sudo dnf install gh -y
      - name: Upload ISO
        env:
          GITHUB_TOKEN: ${{ github.token }}
        run:
          gh release upload ${{ needs.release-please.outputs.tag }} ${{ steps.isogenerator.outputs.iso-path }} -R ublue-os/main --clobber
      - name: Upload SHA256SUM
        env:
          GITHUB_TOKEN: ${{ github.token }}
        run:
          gh release upload ${{ needs.release-please.outputs.tag }} ${{ steps.isogenerator.outputs.sha256sum-path }} -R ublue-os/main --clobber

```

This action expects the following inputs:
- `ostree-oci-ref`: points to the container image that will be embedded into the installer.
- `fedora-release`: sets the fedora release used for the installer environment (it does not affect the installed system)
- `output-dir`: It defaults to `${{ github.workspace }}` and it is directory where the build artifacts will be copied to
- `cpu-arch`: CPU architecture for the installer ISO. Optional, defaults to `x86_64`

This action will generate an ISO and output the path to the file.

## Why this method?

Previous approach of patching an existing Fedora ISO is error prone and does not allow to easily embed OCI images for offline installation.

## Upstream issues
