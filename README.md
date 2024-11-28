# ChipKIT Arduino Build System

A Docker-based build system for compiling and uploading Arduino sketches for ChipKIT boards. This project provides a containerized environment for building Arduino sketches, ensuring consistent compilation across different development machines. This gets around the issue that the pic32 compiler is only 32 bits and is not available on modern OSes. If Microchip would update the compiler this project would work in the standard way.

## Project Status

- Linux: Working for both compilation and uploading
- Windows: Needs testing
- macOS: Needs testing

## Prerequisites

- Docker
- Docker Compose
- Git
- USB access for board programming (Linux users may need to add themselves to the `dialout` group)

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

4. If you encounter permission issues, run:
   ```bash
   ./scripts/fix-permissions.sh
   ```

## Basic Workflow

1. List available boards:
   ```bash
   ./scripts/list-boards.sh
   ```

2. Build a sketch:
   ```bash
   BOARD="chipKIT:pic32:fubarino_mini" ./scripts/build-sketch.sh path/to/sketch/sketch.ino
   ```

3. Upload a sketch (make sure your board is connected via USB):
   ```bash
   BOARD="chipKIT:pic32:fubarino_mini" ./scripts/upload-sketch.sh -p /dev/ttyACM0 path/to/sketch/sketch.ino
   ```

4. Clean build artifacts:
   ```bash
   ./scripts/clean.sh
   ```

## Building and Uploading

### Building Sketches

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

### Uploading Sketches

The `upload-sketch.sh` script handles uploading compiled sketches to your board:

```bash
BOARD="chipKIT:pic32:fubarino_mini" ./scripts/upload-sketch.sh -p /dev/ttyACM0 path/to/sketch/sketch.ino
```

The script will:
1. Automatically detect available USB ports if none specified
2. Build the sketch before uploading
3. Verify successful upload

Options:
```bash
-p, --port <port>    Specify the upload port (e.g., /dev/ttyACM0)
-h, --help           Display help message
```

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
├── compose.upload.yaml       # Upload-specific Docker configuration
├── dist/                     # Build outputs directory
├── docker/                   # Docker configuration files
│   ├── arduino-cli/         # Arduino CLI container configuration
│   └── core-builder/        # Core builder container configuration
├── scripts/                  # Build and utility scripts
│   ├── build-core.sh        # Builds the ChipKIT core
│   ├── build-sketch.sh      # Compiles Arduino sketches
│   ├── clean.sh             # Cleans build artifacts
│   ├── fix-permissions.sh   # Fixes directory permissions
│   ├── fix-platform.sh      # Platform configuration utility
│   ├── list-boards.sh       # Lists available ChipKIT boards
│   └── upload-sketch.sh     # Uploads compiled sketches
├── sketches/                # Arduino sketch files
└── tmp/                     # Temporary build files
```

## Known Issues

1. USB Access on Linux:
   - Add your user to the dialout group:
     ```bash
     sudo usermod -a -G dialout $USER
     ```
   - Log out and back in for changes to take effect

2. Windows/macOS Testing:
   - USB device mapping may need adjustment
   - Path handling might need fixes
   - Please report issues on GitHub

## Troubleshooting

1. **Permission Issues**: 
   ```bash
   ./scripts/fix-permissions.sh
   ```

2. **Build Failures**: Check:
   - Correct board FQBN is specified
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

## Testing Needed

If you're using Windows or macOS, we'd appreciate help testing and reporting issues:

1. Document your OS version and setup
2. Try the basic workflow
3. Note any issues with:
   - USB device detection
   - File permissions
   - Path handling
   - Build or upload processes
4. Submit issues or pull requests with fixes

## License

[Apache 2.0]