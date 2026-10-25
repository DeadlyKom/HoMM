
                ifndef _CONST_ITEM_QUALITY_
                define _CONST_ITEM_QUALITY_
; -----------------------------------------
;   качества предметов, значения используются как номера битов
; -----------------------------------------
ITEM_QUALITY_NORMAL EQU 0x00                                                    ; обычный
ITEM_QUALITY_MAGIC  EQU 0x01                                                    ; магический
ITEM_QUALITY_RARE   EQU 0x02                                                    ; редкий
ITEM_QUALITY_UNIQUE EQU 0x03                                                    ; уникальный
ITEM_QUALITY_SET    EQU 0x04                                                    ; сетовый

                endif ; ~_CONST_ITEM_QUALITY_
