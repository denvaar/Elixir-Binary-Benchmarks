#include <stdio.h>

int main(int argc, char *argv[]) {
  unsigned int x;

  sscanf(argv[1], "%d", &x);

  printf("%d\n", __builtin_popcount(x));
}
