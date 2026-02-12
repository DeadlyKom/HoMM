
                ifndef _CONST_GAME_VIEW_
                define _CONST_GAME_VIEW_

; флаги работы с видом
UPDATE_TILEMAP_BUF_BIT          EQU 0x00                                        ; флаг, необходимости обновить TilemapBuffer
UPDATE_RENDER_BUF_BIT           EQU 0x01                                        ; флаг, необходимости обновить RenderBuffer
FORCED_FRAME_UPDATE_BIT         EQU 0x02                                        ; флаг, принудительного обновления кадра
SET_MAP_POSITION_ON_MINIMAP_BIT EQU 0x03                                        ; флаг, установить положение карты по мини-карте

UPDATE_TILEMAP_BUF              EQU 1 << UPDATE_TILEMAP_BUF_BIT
UPDATE_RENDER_BUF               EQU 1 << UPDATE_RENDER_BUF_BIT

                endif ; ~_CONST_GAME_VIEW_
