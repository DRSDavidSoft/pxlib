# pxlib - Paradox Database Library

[![Build](https://github.com/DRSDavidSoft/pxlib/actions/workflows/build.yml/badge.svg)](https://github.com/DRSDavidSoft/pxlib/actions/workflows/build.yml)
[![Release](https://github.com/DRSDavidSoft/pxlib/actions/workflows/release.yml/badge.svg)](https://github.com/DRSDavidSoft/pxlib/actions/workflows/release.yml)

## What is pxlib?

pxlib is a shared C library to read various Paradox files. Currently `.DB` files are best supported. pxlib provides a very simple API to read the header and the data records of Paradox files. It also provides functions to convert the data into the host's data format (little or big endian).

The complete API is well documented in a set of man pages, one for each function.

## Download

### Binary Releases

Pre-built binaries for Linux, Windows, and macOS are available on the [Releases page](https://github.com/DRSDavidSoft/pxlib/releases).

Each release includes:
- **Linux (GCC)**: Shared library compiled with GCC (`pxlib-linux-gcc.tar.gz`)
- **Linux (Clang)**: Shared library compiled with Clang (`pxlib-linux-clang.tar.gz`)
- **Windows**: DLL file (`pxlib-windows.zip`)
- **macOS**: Dynamic library (`pxlib-macos.tar.gz`)

### Source Code

- GitHub: https://github.com/DRSDavidSoft/pxlib
- SourceForge: http://pxlib.sourceforge.net

## Building from Source

### Prerequisites

- CMake 3.12 or later
- C compiler (GCC, Clang, or MSVC)

### Build Instructions

```bash
# Clone the repository
git clone https://github.com/DRSDavidSoft/pxlib.git
cd pxlib

# Configure
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build --config Release
```

The compiled library will be in the `build` directory.

## Installation

After building, you can install the library system-wide:

```bash
cd build
sudo make install
```

## Usage

Include the paradox header in your C code:

```c
#include <paradox.h>
```

Link against the pxlib library:

```bash
gcc -o myapp myapp.c -lpx
```

## Documentation

The complete API is documented in man pages. After installation, you can access them with:

```bash
man PX_new
man PX_open_file
# ... and so on for each function
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## Release Process

For maintainers: See [RELEASING.md](RELEASING.md) for instructions on creating a new release.

## License

See the [COPYING](COPYING) file for license information.

## Author

Uwe Steinmann <uwe@steinmann.cx>

## Links

- Documentation: Available as man pages after installation
- Bug Reports: https://github.com/DRSDavidSoft/pxlib/issues
- SourceForge Project: http://pxlib.sourceforge.net
