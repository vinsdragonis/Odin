#include "lib.h"
#include "console.h"
#include "stdint.h"

static void cmd_get_total_memory(void)
{
    uint64_t total;

    total = get_total_memoryu();
    printf("Total memory = %d MB\n", total);
}

static int read_cmd(char *buffer)
{
    char ch[2] = {0};
    int buffer_size = 0;

    while (1)
    {
        ch[0] = keyboard_readu();

        if (ch[0] == '\n' || buffer_size >= 80)
        {
            printf("%s", ch);
            break;
        }
        else if (ch[0] == '\b')
        {
            if (buffer_size > 0)
            {
                buffer_size--;
                printf("%s", ch);
            }
        }
        else
        {
            buffer[buffer_size++] = ch[0];
            printf("%s", ch);
        }
    }

    return buffer_size;
}

static int parse_cmd(char *buffer, int buffer_size)
{
    int cmd = -1;

    if (buffer_size == 8 && (!memcmp("totalmem", buffer, 8)))
    {
        cmd = 0;
    }

    return cmd;
}

static void execute_cmd(int cmd)
{
    CmdFunc cmd_list[1] = {cmd_get_total_memory};

    if (cmd == 0)
    {
        cmd_list[0]();
    }
}

int main(void)
{
    char buffer[80] = {0};
    int buffer_size = 0;
    int cmd = 0;

    while (1)
    {
        printf("shell# ");
        buffer_size = read_cmd(buffer);

        if (buffer_size == 0)
        {
            continue;
        }

        cmd = parse_cmd(buffer, buffer_size);

        if (cmd < 0)
        {
            printf("Command not found!\n");
        }
        else
        {
            execute_cmd(cmd);
        }
    }

    return 0;
}
