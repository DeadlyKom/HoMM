
                ifndef _MACRO_TR_DOS_
                define _MACRO_TR_DOS_
; -----------------------------------------
; расчёт количества секторов с округлением размера вверх
; In:
;   Size? - размер данных в байтах
;   Label? - метка результата
; Out:
;   Label? - количество секторов с округлением вверх
; -----------------------------------------
SIZE_TO_SECTORS  macro Size?, Label?
Label?          = ((Size?) + TRDOS.SECTOR_SIZE - 1) / TRDOS.SECTOR_SIZE
                endm

SET_TR_DOS_FLAG macro FlagBit?
                LD HL, Adr.Stash_TRDOS
                SET_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_TR_DOS_
