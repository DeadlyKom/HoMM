
                ifndef _CONFIG_ZX_SPECTRUM_PORT_7FFD_
                define _CONFIG_ZX_SPECTRUM_PORT_7FFD_
PORT_7FFD       EQU #7FFD
SCREEN_BIT      EQU 0x03
ROM_BIT         EQU 0x04
LOCK_48K_BIT    EQU 0x05
SCREEN          EQU 1 << SCREEN_BIT
SCREEN_INV      EQU (~SCREEN) & 0xFF
ROM             EQU 1 << ROM_BIT

PAGE_MASK       EQU %11000111
PAGE_MASK_INV   EQU (~PAGE_MASK) & 0xFF                                         ; %00111000

                endif ; ~_CONFIG_ZX_SPECTRUM_PORT_7FFD_
