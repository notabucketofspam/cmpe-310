#include <stdio.h>
#ifndef _WIN32
extern unsigned char ram[]; // RAM declared in assembly
extern void fill_ram(void); // Assembly function
#else
unsigned char ram[256];
void fill_ram(void){}
#endif
int main() {
  fill_ram(); // Run assembly code
  printf("RAM contents from 50H to 58H:\n");
  for (int i = 0x50; i <= 0x58; i++) {
    printf("%02X ", ram[i]);
  }
  printf("\n");
  return 0;
}
