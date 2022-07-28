#include "lib.h"
#include "stdint.h"

int main(void)
{
    int64_t counter = 0;
    while (1) {
        if (counter % 1000000 == 0)
            printf("User 1 process started\n");
        counter++;
    }
    return 0;
}
