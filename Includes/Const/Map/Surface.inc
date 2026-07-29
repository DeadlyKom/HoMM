
                ifndef _CONST_MAP_SURFACE_
                define _CONST_MAP_SURFACE_
; биты проходимости (младший байт)
SURFACE_TYPE_BIT            EQU 0x05
SURFACE_TYPE_NORMAL         EQU 0x00 << SURFACE_TYPE_BIT                        ; тип поверхности - обычная
SURFACE_TYPE_ROAD           EQU 0x06 << SURFACE_TYPE_BIT                        ; тип поверхности - дорога      [Director/DistanceMap/Initialize.asm]   (6)
SURFACE_TYPE_SETTLEMENT     EQU 0x07 << SURFACE_TYPE_BIT                        ; тип поверхности - поселение   [Director/DistanceMap/Initialize.asm]   (7)
SURFACE_TYPE_MASK           EQU %11100000                                       ; маска типа поверхности
SURFACE_STEP_COST_MASK      EQU %00011111                                       ; маска стоимости прохода по поверхности

; модификатор разведки в свойстве (старший байт)
SURFACE_RECON_MOD_BIT       EQU 0x05
SURFACE_RECON_POS_MOD_1     EQU 0x01 << SURFACE_RECON_MOD_BIT                   ; модификатор разведки +1
SURFACE_RECON_POS_MOD_2     EQU 0x02 << SURFACE_RECON_MOD_BIT                   ; модификатор разведки +2
SURFACE_RECON_POS_MOD_3     EQU 0x03 << SURFACE_RECON_MOD_BIT                   ; модификатор разведки +3
SURFACE_RECON_NEG_MOD_2     EQU 0x06 << SURFACE_RECON_MOD_BIT                   ; модификатор разведки -2
SURFACE_RECON_NEG_MOD_1     EQU 0x07 << SURFACE_RECON_MOD_BIT                   ; модификатор разведки -1
SURFACE_RECON_MOD_MASK      EQU %11100000                                       ; маска модификатора разведки

                endif ; ~_CONST_MAP_SURFACE_
