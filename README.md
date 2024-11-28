# ChipKIT Arduino Build System

A Docker-based build system for compiling Arduino sketches for ChipKIT boards. This project provides a containerized environment for building Arduino sketches, ensuring consistent compilation across different development machines. This gets around the issue that the pic32 compiler is only 32 bits and is not available on modern OSes. If Microchip would update the compiler this project would work in the standard way.

## Prerequisites

- Docker
- Docker Compose
- Git

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/chipKIT32/chipKIT-docker.git
   cd chipKIT-docker
   ```

2. Build the Docker images:
   ```bash
   docker compose build
   ```

3. Build the ChipKIT core (required first time):
   ```bash
   ./scripts/build-core.sh
   ```

## Basic Workflow

1. List available boards:
   ```bash
   ./scripts/list-boards.sh
   ```

2. Build a sketch:
   ```bash
   ./scripts/build-sketch.sh path/to/sketch/sketch.ino
   ```

3. Upload a sketch:
   ```bash
   BOARD="chipKIT:pic32:fubarino_mini" ./scripts/upload-sketch.sh path/to/sketch/sketch.ino
   ```

4. Clean build artifacts:
   ```bash
   ./scripts/clean.sh
   ```

## Building Sketches

The `build-sketch.sh` script is your main tool for building sketches. The default board is the Fubarino Mini.

Basic usage:
```bash
./scripts/build-sketch.sh path/to/sketch/sketch.ino
```

With specific board:
```bash
BOARD="chipKIT:pic32:chipkit_uc32" ./scripts/build-sketch.sh path/to/sketch/sketch.ino
```

Using separate build directory:
```bash
./scripts/build-sketch.sh --build-dir path/to/sketch/sketch.ino
```

## Uploading Sketches

The `upload-sketch.sh` script handles uploading compiled sketches to your board:

```bash
BOARD="chipKIT:pic32:fubarino_mini" ./scripts/upload-sketch.sh path/to/sketch/sketch.ino
```

Note: Make sure your board is connected via USB before uploading.

## Supported Boards

Use `./scripts/list-boards.sh` to see all available boards. Common boards include:

| Board Name | FQBN |
|------------|------|
| Fubarino Mini | `chipKIT:pic32:fubarino_mini` |
| Fubarino SD | `chipKIT:pic32:fubarino_sd` |
| chipKIT DP32 | `chipKIT:pic32:chipkit_DP32` |
| chipKIT uC32 | `chipKIT:pic32:chipkit_uc32` |
| chipKIT WF32 | `chipKIT:pic32:chipkit_WF32` |
| chipKIT WiFire | `chipKIT:pic32:chipkit_WiFire` |
| chipKIT MAX32 | `chipKIT:pic32:mega_pic32` |
| chipKIT UNO32 | `chipKIT:pic32:uno_pic32` |

## Project Structure

```
.
├── README.md
├── compose.yaml              # Docker Compose configuration
├── dist/                     # Build outputs directory
├── docker/                   # Docker configuration files
│   ├── arduino-cli/         # Arduino CLI container configuration
│   └── core-builder/        # Core builder container configuration
├── scripts/                  # Build and utility scripts
│   ├── build-core.sh        # Builds the ChipKIT core
│   ├── build-sketch.sh      # Compiles Arduino sketches
│   ├── clean.sh             # Cleans build artifacts
│   ├── fix-platform.sh      # Platform configuration utility
│   ├── list-boards.sh       # Lists available ChipKIT boards
│   └── upload-sketch.sh     # Uploads compiled sketches
├── sketches/                # Arduino sketch files
└── tmp/                     # Temporary build files
```

## Build Output

When using the `--build-dir` option, compiled files will be organized as follows:
```
dist/
└── [sketch-name]/
    ├── [sketch-name].ino.hex
    └── [sketch-name].ino.[board].hex
```

Without `--build-dir`, files will be placed in the default Arduino CLI build location.

## Troubleshooting

Common issues and solutions:

1. **Permission Issues**: 
   - Ensure your user has Docker permissions:
     ```bash
     sudo usermod -aG docker $USER
     ```
   - Log out and back in for changes to take effect

2. **Build Failures**: Check:
   - Correct board FQBN is specified
   - Sketch follows Arduino naming conventions
   - Core is built (`./scripts/build-core.sh`)
   - All required libraries are available

3. **Upload Issues**:
   - Check USB connection
   - Verify correct port permissions
   - Ensure correct BOARD is specified

4. **Docker Issues**: Try:
   ```bash
   ./scripts/clean.sh
   docker compose build --no-cache
   ./scripts/build-core.sh
   ```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

[Apache 2.0]