#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

struct termios original_termios;
struct termios raw;
void handle_resize(int);
void enable_no_echo();
void enable_raw_mode();
void disable_raw_mode();
void disable_no_echo();

void init() {
  enable_raw_mode();
  enable_no_echo();
}

void deinit() { tcsetattr(STDIN_FILENO, TCSAFLUSH, &original_termios); }

void enable_no_echo() {
  raw.c_lflag &= ~(ECHO);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

__attribute__((constructor)) void init_base_termios() {
  tcgetattr(STDIN_FILENO, &original_termios);
  raw = original_termios;
}

void enable_raw_mode() {
  raw.c_iflag &= ~(BRKINT | IGNBRK | ICRNL | INPCK | ISTRIP | IXON);
  raw.c_lflag &= ~(ICANON | IEXTEN | ISIG);
  raw.c_oflag &= ~(OPOST);
  raw.c_cflag |= (CS8);
  raw.c_cc[VMIN] = 0;
  raw.c_cc[VTIME] = 1;
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void disable_raw_mode() {
  raw.c_iflag |= (BRKINT | IGNBRK | ICRNL | INPCK | ISTRIP | IXON);
  raw.c_lflag |= (ICANON | IEXTEN | ISIG);
  raw.c_oflag |= (OPOST);
  raw.c_cflag |= (CS8);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void disable_no_echo() {
  raw.c_lflag |= ECHO;
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

__attribute__((constructor)) void init_resize_handler() {
  struct sigaction sigact;
  sigact.sa_handler = handle_resize;
}

void handle_resize(int signal) {
  if (signal == SIGWINCH) {
  }
}
