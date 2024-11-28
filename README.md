# ChipKIT Docker Development Environment

This project provides a Docker-based development environment for ChipKIT, enabling the use of the 32-bit ChipKIT compiler with the Arduino CLI on modern 64-bit systems.

## Prerequisites

- Docker
- Git

## Setup

1. Build the Docker images:
   ```bash
   docker compose build
   ```

2. Build the ChipKIT core:
   ```bash
   ./scripts/build-core.sh
   ```

3. Compile a sketch:
   ```bash
   ./scripts/build-sketch.sh path/to/sketch
   ```

## Project Structure

- `docker/core-builder/`: ChipKIT core builder Dockerfile
- `docker/arduino-cli/`: Arduino CLI Dockerfile
- `scripts/`: Helper scripts for building and compilation
- `sketches/`: Place your Arduino sketches here
- `dist/`: Build artifacts directory
