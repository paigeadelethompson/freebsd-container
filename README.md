# FreeBSD Container Images

This repository contains scripts and configurations for building FreeBSD container images using Podman. The images are based on official FreeBSD releases and include the package manager (pkg) pre-configured.

## Features

- Supports multiple FreeBSD versions (14.2-RELEASE, 14.1-RELEASE)
- Automatically tags the latest image based on host FreeBSD version
- Uses tcsh as the default shell
- Pre-configured with pkg package manager
- All packages updated to latest versions

## Prerequisites

- FreeBSD host system
- Podman installed
- Root privileges (for building images)

## Usage

### Building Images

To build all FreeBSD images:

```bash
sudo ./freebsd_images.sh
```

This will:
1. Download and import base FreeBSD images
2. Build updated images with pkg configured
3. Tag images appropriately
4. Clean up temporary and dangling images

### Available Images

Images are tagged as:
- `localhost/freebsd:14-2-release`
- `localhost/freebsd:14-1-release`
- `localhost/freebsd:latest` (matches host FreeBSD version)

### Running Containers

Example of running a container:

```bash
podman run -it localhost/freebsd:latest
```

## Image Structure

The images are built with:
- Base FreeBSD system
- pkg package manager configured
- tcsh as default shell
- All packages updated to latest versions

## License

This project is open source and available under the same license as FreeBSD. 