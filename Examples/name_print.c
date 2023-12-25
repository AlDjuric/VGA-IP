#include <stdio.h>
#include "DE10_Lite_VGA_Driver.h"
#include "draw_vga.h"

int main()
{
        clear_screen(Col_Black);

        tty_print(100, 100, "Aleksandar Djuric", Col_Red, Col_Black);

        return 0;
}
