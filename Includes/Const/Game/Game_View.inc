
                ifndef _CONST_GAME_VIEW_
                define _CONST_GAME_VIEW_

; -----------------------------------------
;   флаги работы с видом
; -----------------------------------------
UPDATE_TILEMAP_BUF_BIT          EQU 0x07                                        ; флаг, необходимости обновить TilemapBuffer
UPDATE_RENDER_BUF_BIT           EQU 0x06                                        ; флаг, необходимости обновить RenderBuffer
CONTOUR_ENABLED_BIT             EQU 0x04                                        ; флаг, разрешения вызова формирования обводки
SET_MAP_POSITION_ON_MINIMAP_BIT EQU 0x03                                        ; флаг, установить положение карты по мини-карте
FORCED_FRAME_UPDATE_BIT         EQU 0x02                                        ; флаг, принудительного обновления кадра

UPDATE_TILEMAP_BUF              EQU 1 << UPDATE_TILEMAP_BUF_BIT
UPDATE_RENDER_BUF               EQU 1 << UPDATE_RENDER_BUF_BIT
CONTOUR_ENABLED                 EQU 1 << CONTOUR_ENABLED_BIT
CONTOUR_PHASE_MASK              EQU %00000011                                   ; маска номера фазы

                endif ; ~_CONST_GAME_VIEW_
