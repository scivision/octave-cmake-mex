#ifndef OCTAVE_FILE_IO_H
#define OCTAVE_FILE_IO_H

#ifdef __cplusplus
extern "C" {
#endif

  int octave_load (const char* filename, double** data, int* numel);

#ifdef __cplusplus
}
#endif

#endif
