# GNU Octave CMake with C, C++ and Fortran

[![CI](https://github.com/scivision/octave-cmake-mex/actions/workflows/ci.yml/badge.svg)](https://github.com/scivision/octave-cmake-mex/actions/workflows/ci.yml)

CMake and GNU Octave with C, C++ and Fortran code using
[mkoctfile](https://octave.sourceforge.io/octave/function/mkoctfile.html)
akin to Matlab "mex" command.
Octfiles are easier and better to use with GNU Octave.

For Linux package managers, typically the "octave-dev" or "Octave-devel" or similar package is required to get the development libraries and headers needed to build Octave extensions.

## Usage

Build:

```sh
cmake -B build
cmake --build build
```

If on macOS with Homebrew-installed Octave and build/link failures occur due to not finding "lgfortran" try the toolchain file "homebrew.cmake" which adds the Homebrew prefix to the library search path:

```sh
cmake -B build --toolchain homebrew.cmake
cmake --build build
```

Test:

```sh
ctest --test-dir build -V
```

These examples work on any operating system Octave supports.

On **macOS** use AppleClang with
[Homebrew](https://brew.sh)-installed
Octave.

If
[Octave was installed via Flatpak](https://www.scivision.dev/octave-install/)
on **Linux**,
it can be convenient to first
[open a sandboxed shell](https://docs.flatpak.org/en/latest/debugging.html)
in the Octave Flatpak sandbox:

```sh
flatpak run --command=sh org.octave.Octave
```

The **Windows** default
[installation](https://octave.org/download)
includes development libraries used in these examples.
On Windows, use GCC MinGW / MSYS2 as Visual Studio is not compatible with the Octave libraries.
Cygwin or WSL can also be used for Octave on Windows.

---

Matlab: [C, C++, Fortran with MEX](https://github.com/scivision/matlab-cmake-mex)
