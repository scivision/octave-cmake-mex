# GNU Octave CMake MEX

[![CI](https://github.com/scivision/octave-cmake-mex/actions/workflows/ci.yml/badge.svg)](https://github.com/scivision/octave-cmake-mex/actions/workflows/ci.yml)

CMake and GNU Octave MEX examples of complied code.

## Usage

Build:

```sh
cmake -B build
cmake --build build
```

Test:

```sh
ctest --test-dir build -V
```

These examples work on any operating system Octave supports.

On **macOS**, we have observed the need to use AppleClang with
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

[Matlab with CMake and MEX](https://github.com/scivision/matlab-cmake-mex)
