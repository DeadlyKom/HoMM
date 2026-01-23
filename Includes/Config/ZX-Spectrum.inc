
                ifndef _CONFIG_ZX_SPECTRUM_
                define _CONFIG_ZX_SPECTRUM_
PAGE_0                  EQU 0x00
PAGE_1                  EQU 0x01
PAGE_2                  EQU 0x02
PAGE_3                  EQU 0x03
PAGE_4                  EQU 0x04
PAGE_5                  EQU 0x05
PAGE_6                  EQU 0x06
PAGE_7                  EQU 0x07
PAGE_N                  EQU 0x08

SCR_BASE                EQU 0x00
SCR_ADR_BASE            EQU MemBank_01_SCR
SCR_STACK_ADR_BASE      EQU MemBank_01_SCR  + ImageSize
SCR_SHADOW              EQU 0x01
SCR_ADR_SHADOW          EQU MemBank_03_SCR
SCR_STACK_ADR_SHADOW    EQU MemBank_03_SCR + ImageSize
SCR_SIZE                EQU ScreenSize

                endif ; ~_CONFIG_ZX_SPECTRUM_
