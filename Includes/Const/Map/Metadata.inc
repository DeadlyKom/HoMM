
                ifndef _CONST_MAP_METADATA_
                define _CONST_MAP_METADATA_
; флаги работы с метаданными карты

; флаг сброшен — гексагон закрашен туманом целиком
MAP_META_FOG_PLAYER_1_BIT   EQU 0x06                                            ; флаг, тумана первого игрока
MAP_META_FOG_PLAYER_2_BIT   EQU 0x01                                            ; флаг, тумана второго игрока
MAP_META_FOG_PLAYER_3_BIT   EQU 0x02                                            ; флаг, тумана третьего игрока
MAP_META_FOG_PLAYER_4_BIT   EQU 0x03                                            ; флаг, тумана четвёртого игрока

MAP_META_FOG_ENABLE         EQU 0x00                                            ; гексагон затуманен полностью
MAP_META_FOG_DISABLE        EQU 0x01                                            ; гексагон виден игроку (возможно частичное затуманивание)
MAP_META_FOG_PLAYER_1_MASK  EQU 1 << MAP_META_FOG_PLAYER_1_BIT                  ; маска тумана первого игрока
MAP_META_FOG_PLAYER_2_MASK  EQU 1 << MAP_META_FOG_PLAYER_2_BIT                  ; маска тумана второго игрока
MAP_META_FOG_PLAYER_3_MASK  EQU 1 << MAP_META_FOG_PLAYER_3_BIT                  ; маска тумана третьего игрока
MAP_META_FOG_PLAYER_4_MASK  EQU 1 << MAP_META_FOG_PLAYER_4_BIT                  ; маска тумана четвёртого игрока
MAP_META_FOG_OF_WAR_MASK    EQU MAP_META_FOG_PLAYER_1_MASK | \
                                MAP_META_FOG_PLAYER_2_MASK | \
                                MAP_META_FOG_PLAYER_3_MASK | \
                                MAP_META_FOG_PLAYER_4_MASK                      ; маска бит тумана, соответствующие каждому игроку
MAP_META_DEFAULT_VALUE      EQU %00000000                                       ; значение по умолчанию при инициализации карты

                endif ; ~_CONST_MAP_METADATA_
