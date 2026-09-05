
                ifndef _CONST_WORLD_TIME_
                define _CONST_WORLD_TIME_
WORLD_TICKS_PER_HOUR       EQU 60                                               ; количество "мировых тиков" в одном игровом часу

; значения FWorldTimeControl.Flags
WORLD_EPOCH_ACTIVE_BIT     EQU 0x00                                             ; флаг, активной фазы "мирового тика" в текущей cadence-эпохе
WORLD_DAY_PHASE_UPDATE_BIT EQU 0x01                                             ; флаг, запроса обновления фазы суток

WORLD_EPOCH_ACTIVE         EQU 1 << WORLD_EPOCH_ACTIVE_BIT
WORLD_DAY_PHASE_UPDATE     EQU 1 << WORLD_DAY_PHASE_UPDATE_BIT

                endif ; ~_CONST_WORLD_TIME_
