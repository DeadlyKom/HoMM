
                ifndef _STRUCTS_ITEM_AFFIX_LEVEL_
                define _STRUCTS_ITEM_AFFIX_LEVEL_
; -----------------------------------------
;   диапазон уровня генерации для выбора аффикса
; -----------------------------------------
                struct FItemAffixLevel                                          ; диапазон уровня генерации                             [2 байта]
Min             DB #00                                                          ; минимальный уровень генерации                         [1 байт]
Max             DB #00                                                          ; максимальный уровень генерации                        [1 байт]
                ends

                endif ; ~_STRUCTS_ITEM_AFFIX_LEVEL_
