#define TIMER 30

#ifdef _WIN32
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

// Global variable to catch Ctrl+C signals
BOOL keep_running = TRUE;

// Signal handler to gracefully reset the terminal color when Ctrl+C is pressed
BOOL WINAPI console_handler(DWORD signal) {
  if (signal == CTRL_C_EVENT) {
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    // Reset to default Windows console colors (typically Light Gray text on Black background)
    SetConsoleTextAttribute(hConsole, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
    system("cls");
    keep_running = FALSE;
    return TRUE;
  }
  return FALSE;
}

int main() {
  HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

  // Array of Windows Console background attributes
  // (Black, Dark Red, Dark Green, Dark Yellow, Dark Blue, Dark Magenta, Dark Cyan, Gray)
  WORD backgrounds[] = {
      0,                                                   // Black
      BACKGROUND_RED,                                      // Red
      BACKGROUND_GREEN,                                    // Green
      BACKGROUND_RED | BACKGROUND_GREEN,                   // Yellow
      BACKGROUND_BLUE,                                     // Blue
      BACKGROUND_RED | BACKGROUND_BLUE,                    // Magenta
      BACKGROUND_GREEN | BACKGROUND_BLUE,                  // Cyan
      BACKGROUND_RED | BACKGROUND_GREEN | BACKGROUND_BLUE  // White/Gray
  };
  int num_colors = sizeof(backgrounds) / sizeof(backgrounds[0]);

  // Set the interval timer in milliseconds (1.5 seconds = 1500 milliseconds)
  DWORD timer = TIMER;

  // Register the Ctrl+C handler
  if (!SetConsoleCtrlHandler(console_handler, TRUE)) {
    printf("Error: Could not set Ctrl+C handler.\n");
    return 1;
  }

  //printf("Starting Windows color cycle... Press Ctrl+C to stop.\n");
  //Sleep(1000);

  while (keep_running) {
    for (int i = 0; i < num_colors && keep_running; i++) {
      // Set the background color attribute
      SetConsoleTextAttribute(hConsole, backgrounds[i]);

      // Clear the screen to fill the background entirely
      system("cls");

      // Wait for the specified time
      Sleep(timer);
    }
  }

  return 0;
}
#else
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

// Signal handler to reset the terminal color when Ctrl+C is pressed
void handle_sigint(int sig) {
  // \x1b[0m resets colors, \x1b[2J clears screen, \x1b[H moves cursor to top
  printf("\x1b[0m\x1b[2J\x1b[H");
  fflush(stdout);
  exit(0);
}

int main() {
  // Array of background ANSI color codes (Black, Red, Green, Yellow, Blue, Magenta, Cyan, White)
  int colors[] = { 40, 41, 42, 43, 44, 45, 46, 47 };
  int num_colors = sizeof(colors) / sizeof(colors[0]);

  // Set the interval timer in microseconds (1.5 seconds = 1500000 microseconds)
  unsigned int timer = TIMER * 1000;

  // Register the Ctrl+C signal handler
  signal(SIGINT, handle_sigint);

  //printf("Starting color cycle... Press Ctrl+C to stop.\n");
  //sleep(1);

  while (1) {
    for (int i = 0; i < num_colors; i++) {
      // \x1b[%dm sets the background color, \x1b[2J clears screen to fill background
      printf("\x1b[%dm\x1b[2J\x1b[H", colors[i]);
      fflush(stdout); // Force immediate output to the terminal
      usleep(timer);  // Wait for the specified time
    }
  }

  return 0;
}
#endif
