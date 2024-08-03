#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

struct termios original_termios;
struct termios raw;
void handle_resize(int);

void enable_no_echo() {
  raw.c_lflag &= ~(ECHO);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void disable_no_echo() {
  raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void enable_raw_mode() {
  tcgetattr(STDIN_FILENO, &original_termios);
  tcgetattr(STDIN_FILENO, &raw);
  raw.c_iflag &= ~(BRKINT | IGNBRK | ICRNL | INPCK | ISTRIP | IXON);
  raw.c_lflag &= ~(ICANON | IEXTEN | ISIG);
  raw.c_oflag &= ~(OPOST);
  raw.c_cflag |= (CS8);
  raw.c_cc[VMIN] = 0;
  raw.c_cc[VTIME] = 1;
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void disable_raw_mode() {
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &original_termios);
}

__attribute__((constructor)) void init_resize_handler() {
  struct sigaction sigact;
  sigact.sa_handler = handle_resize;
}

void handle_resize(int signal) {
  if (signal == SIGWINCH) {
  }
}
