#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  FILE *input_file = fopen("sample.txt", "rb");
  if (input_file == NULL) {
    fprintf(stdout, "ERROR: %s\n", strerror(errno));
    exit(1);
  }

  char buffer[16];
  char *p = fgets(buffer, sizeof(buffer), input_file);

  // ERROR HANDLING
  if (p == NULL) {
    if (ferror(input_file)) {
      fprintf(stdout, "ERROR: %s\n", strerror(errno));
      exit(1);
    } else if (feof(input_file)) {
      fprintf(stdout, "ERROR: reached EOF: %s\n", strerror(errno));
      exit(1);
    } else {
      assert(0 && "unreachable");
    }
  }

  printf("%s\n", buffer);

  fclose(input_file);

  return 0;
}