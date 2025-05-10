
                ifndef _BUILDER_BOOTLOADER_PACK_
                define _BUILDER_BOOTLOADER_PACK_

                MMU 1, PAGE_5
                module Bootloader

                display "'Bootloader':\t\t\t\t\t\t-------------------------------------------------------------------------"
Begin:          EQU $
                include "Basic.asm"
Size:           EQU $ - Begin
Sector          EQU ((Size % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size >> 8)
                
                if PASS = 2
                savetrd TRD_FILENAME, "boot.B", Begin, Size, 20
                endif
                endmodule

                endif ; ~ _BUILDER_BOOTLOADER_PACK_
