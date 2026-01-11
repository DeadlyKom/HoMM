
                ifndef _CONST_MAP_TILEMAP_
                define _CONST_MAP_TILEMAP_
TILEMAP_WIDTH_DATA      EQU 5                                                   ; ширина данных в тайловом буфере
TILEMAP_HEIGHT_DATA     EQU 8                                                   ; высота данных в тайловом буфере
TILEMAP_DATA_SIZE       EQU TILEMAP_WIDTH_DATA * TILEMAP_HEIGHT_DATA            ; размер данных в тайловом буфере

; флаги работы с тайлами при отрисовки гексагонов
RENDER_FLAG_HEX_UPDATE_BIT  EQU 0x07                                            ; флаг, принудительного обновления гексагона (частично или полностью)
                                                                                ; если установлен, необходимо обновить гексагон
RENDER_FLAG_HEX_FOG_BIT     EQU 0x06                                            ; флаг, тумана (0 - гексагон закрашен туманом целиком)
RENDER_FLAG_HEX_ANIM_MASK   EQU %00001111                                       ; маска номера анимации гексагона

RENDER_FLAG_HEX_UPDATE      EQU 1 << RENDER_FLAG_HEX_UPDATE_BIT
RENDER_FLAG_HEX_FOG         EQU 1 << RENDER_FLAG_HEX_FOG_BIT

                endif ; ~_CONST_MAP_TILEMAP_
