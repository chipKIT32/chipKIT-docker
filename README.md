# ChipKIT Arduino Build System

A Docker-based build system for compiling Arduino sketches for ChipKIT boards. This project provides a containerized environment for building Arduino sketches, ensuring consistent compilation across different development machines. This get's around the issue that the pic32 compiler is only 32 bits and is not available on modern OSes. If Microchip would update the compiler this project would work in the standard way.

## Project Structure

```
.
├── README.md
├── compose.yaml              # Docker Compose configuration
├── dist/                     # Build outputs directory
├── docker/                   # Docker configuration files
│   ├── arduino-cli/         # Arduino CLI container configuration
│   │   ├── Dockerfile
│   │   └── arduino-cli.yaml
│   └── core-builder/        # Core builder container configuration
│       └── Dockerfile
├── scripts/                  # Build and utility scripts
│   ├── build-core.sh        # Script for building the ChipKIT core
│   ├── build-sketch.sh      # Main sketch compilation script
│   ├── fix-platform.sh      # Platform configuration utility
│   └── list-boards.sh       # Lists available ChipKIT boards
├── sketches/                # Arduino sketch files
└── tmp/                     # Temporary build files
```

## Prerequisites

- Docker
- Docker Compose
- Git

## Setup

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd [repository-name]
   ```

2. Build the Docker images:
   ```bash
   docker compose build
   ```

## Usage

### Building Sketches

The main script for building sketches is `scripts/build-sketch.sh`. It supports building sketches for various ChipKIT boards.

Basic usage:
```bash
./scripts/build-sketch.sh path/to/sketch/sketch.ino
```

With specific board:
```bash
BOARD="chipKIT:pic32:chipkit_uc32" ./scripts/build-sketch.sh path/to/sketch/sketch.ino
```

Organizing build output in separate directories:
```bash
./scripts/build-sketch.sh --build-dir path/to/sketch/sketch.ino
```

### Supported Boards

The following ChipKIT boards are supported with their Fully Qualified Board Names (FQBN):

| Board Name | FQBN |
|------------|------|
| Fubarino SD | `chipKIT:pic32:fubarino_sd` |
| chipKIT DP32 | `chipKIT:pic32:chipkit_DP32` |
| chipKIT uC32 | `chipKIT:pic32:chipkit_uc32` |
| chipKIT WF32 | `chipKIT:pic32:chipkit_WF32` |
| chipKIT WiFire | `chipKIT:pic32:chipkit_WiFire` |
| chipKIT MAX32 | `chipKIT:pic32:mega_pic32` |
| chipKIT UNO32 | `chipKIT:pic32:uno_pic32` |

Additional supported boards:
- CUI32stem (`chipKIT:pic32:CUI32stem`)
- DataStation Mini (`chipKIT:pic32:dsmini`)
- Fubarino Mini (`chipKIT:pic32:fubarino_mini`)
- And more (use `./scripts/list-boards.sh` for complete list)

### Build Options

The `build-sketch.sh` script supports the following options:

- `--build-dir`: Creates a separate build directory in `dist/` named after the sketch
- Default board is chipKIT DP32 if not specified via `BOARD` environment variable

### Build Output

When using the `--build-dir` option, compiled files will be organized as follows:
```
dist/
└── [sketch-name]/
    ├── [sketch-name].ino.hex
    └── [sketch-name].ino.[board].hex
```

Without `--build-dir`, files will be placed in the default Arduino CLI build location.

## Docker Containers

The project uses two Docker containers:

1. **arduino-cli**: Main container for Arduino CLI operations
   - Handles sketch compilation
   - Configured via `arduino-cli.yaml`

2. **core-builder**: Builds the ChipKIT core files
   - Handles core-specific compilation
   - Used as a dependency for arduino-cli container

## Development

### Adding New Sketches

1. Create a new directory under `sketches/`
2. Add your `.ino` file with the same name as the directory
3. Build using `build-sketch.sh`

### Customizing the Build

The build process can be customized through:
- Environment variables in `compose.yaml`
- Arduino CLI configuration in `docker/arduino-cli/arduino-cli.yaml`
- Build script modifications

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Troubleshooting

Common issues and solutions:

1. **Permission Issues**: If encountering permission problems, ensure your user has the correct Docker permissions or use:
   ```bash
   sudo usermod -aG docker $USER
   ```

2. **Build Failures**: Check:
   - Correct board FQBN is specified
   - Sketch follows Arduino naming conventions
   - All required libraries are available

3. **Docker Issues**: Try:
   ```bash
   docker compose down
   docker compose build --no-cache
   ```

## License

[Specify your license here]