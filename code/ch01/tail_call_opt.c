#include <stdio.h>
#define sum_rec(N) _sum_rec(N, 0)

int _sum_rec(int n, int acc) {
  if (n <= 0) {
    return acc;
  }
  return _sum_rec(n - 1, n + acc);
}

int sum_loop(int n) {
  int a = 0;
  while (n > 0) {
    a += n;
    n--;
  }
  return a;
}

int main(void) {
  printf("%d", sum_rec(10));
  printf("%d", sum_loop(10));
  return 0;
}