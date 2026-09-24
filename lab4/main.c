#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#ifndef _WIN32
extern int sum(void* rdi, void* rsi);
#else
/**
@param rdi array address
@param rsi array length
@return the sum, and its stored in eax
*/
int sum(void* rdi, void* rsi) {
  return -1;
}
#endif

int main(int c, char** v) {
  FILE* file = fopen(v[1], "r");
  int16_t total = 0;
  fscanf(file, "%hd ", &total);
  printf("Total: %hd\n", total);

  int16_t* numbers = (int16_t*) calloc(total, sizeof(int16_t));
  size_t sauce = sizeof numbers;
  for (int i = 0; i < total; i++) {
    fscanf(file, "%hd ", &numbers[i]);
  }

  int result = sum(numbers, &total);
  printf("Sum: %d\n", result);

  free(numbers);
  fclose(file);
  return 0;
}
