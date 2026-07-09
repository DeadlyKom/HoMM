
                ifndef _CONST_WORLD_TIME_
                define _CONST_WORLD_TIME_
WORLD_TICKS_PER_HOUR       EQU 600                                              ; количество "мировых тиков" в одном игровом часу

; значения FWorldTimeControl.Flags
WORLD_EPOCH_ACTIVE_BIT     EQU 0x00                                             ; флаг, активной фазы "мирового тика" в текущей cadence-эпохе
WORLD_EPOCH_ACTIVE         EQU 1 << WORLD_EPOCH_ACTIVE_BIT

                endif ; ~_CONST_WORLD_TIME_
