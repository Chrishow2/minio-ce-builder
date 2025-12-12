# MinIO CE Builder

A project to build MinIO Community Edition (CE) Docker images from source and automatically push them to GitHub Container Registry (GHCR).

## Overview

This repository contains a custom Dockerfile and GitHub Actions workflow that:
- Clones the official MinIO source code from GitHub
- Builds MinIO CE from source using Go
- Creates a lightweight Alpine-based Docker image
- Automatically pushes the built image to GitHub Container Registry

## Prerequisites

### For Local Builds

- Docker installed and running
- Git (to clone MinIO source, if building manually)
- Make (installed automatically in the builder stage)

## Local Build Instructions

### 1. Clone MinIO Source

First, clone the MinIO source code into a `minio` directory:

```bash
git clone https://github.com/minio/minio.git minio
```

### 2. Build the Docker Image

Build the image using the Dockerfile:

```bash
docker build -t minio-ce:latest .
```

### 3. Run the Container

Run the built image:

```bash
docker run -p 9000:9000 -p 9001:9001 \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin \
  -v /path/to/data:/data \
  minio-ce:latest
```

Access the MinIO console at `http://localhost:9001` (default credentials: `minioadmin`/`minioadmin`).

## Dockerfile Details

The Dockerfile uses a multi-stage build:

1. **Builder Stage** (`golang:1.24`):
   - Installs build dependencies (make)
   - Copies MinIO source code
   - Compiles MinIO using `make build`

2. **Runtime Stage** (`alpine:3`):
   - Minimal Alpine Linux base image
   - Installs CA certificates for HTTPS support
   - Copies the compiled MinIO binary
   - Exposes ports 9000 (API) and 9001 (Console)
   - Sets default entrypoint and command

## Usage

### Pull the Image from GHCR

```bash
docker pull ghcr.io/chrishow2/minio-ce:latest
```

### Run with Docker Compose

Example `docker-compose.yml`:

```yaml
version: '3.8'

services:
  minio:
    image: ghcr.io/chrishow2/minio-ce:latest
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - minio-data:/data

volumes:
  minio-data:
```

## Ports

- **9000**: MinIO API endpoint
- **9001**: MinIO Console (Web UI)

## Environment Variables

- `MINIO_ROOT_USER`: Root user for MinIO (default: `minioadmin`)
- `MINIO_ROOT_PASSWORD`: Root password for MinIO (default: `minioadmin`)

For more MinIO configuration options, see the [official MinIO documentation](https://min.io/docs/minio/container/index.html).

## License

This project is provided as-is. MinIO itself is licensed under the AGPL-3.0 license.

**Note**: According to MinIO's license terms, production use of compiled-from-source binaries is at your own risk. For production deployments, MinIO recommends their enterprise offerings.

## References

- [MinIO Official Repository](https://github.com/minio/minio)
- [MinIO Documentation](https://min.io/docs/minio/)
- [MinIO Releases](https://github.com/minio/minio/releases)