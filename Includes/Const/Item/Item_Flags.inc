
                ifndef _CONST_ITEM_FLAGS_
                define _CONST_ITEM_FLAGS_
; -----------------------------------------
;   флаги базового описания предмета
; -----------------------------------------
ITEM_FLAG_ALLOW_AFFIXES_BIT EQU 0x00                                            ; флаг, разрешения дополнительных аффиксов
ITEM_FLAG_ALLOW_AFFIXES     EQU 1 << ITEM_FLAG_ALLOW_AFFIXES_BIT
ITEM_FLAG_NONE              EQU 0x00

; -----------------------------------------
;   состояние размещения предмета
; -----------------------------------------
ITEM_LOCATION_EQUIPPED_BIT EQU 0x00                                             ; флаг, экипировки предмета

ITEM_LOCATION_EQUIPPED     EQU 1 << ITEM_LOCATION_EQUIPPED_BIT

                endif ; ~_CONST_ITEM_FLAGS_

