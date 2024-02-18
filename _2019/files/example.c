#include <stdio.h>

const char *numbers[] = {
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten"
};

void say(int i)
{
    const char *msg = numbers[i-1];
    printf("%s\n", msg);
}

int main()
{
    for (int i = 1; i <= 10; i++) {
        say(i);
    }
}
