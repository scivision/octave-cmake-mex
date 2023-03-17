# GNU Octave CMake MEX

CMake and GNU Octave MEX producing complied code.

Build:

```sh
cmake -B build
cmake --build build

ctest --test-dir build
```

NOTE: On macOS, we have observed the need to use AppleClang with Homebrew-installed Octave.

---

[Matlab with CMake and MEX](https://github.com/scivision/matlab-cmake-mex)
