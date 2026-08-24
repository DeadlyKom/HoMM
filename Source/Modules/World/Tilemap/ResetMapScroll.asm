
                ifndef _WORLD_TILEMAP_RESET_MAP_SCROLL
                define _WORLD_TILEMAP_RESET_MAP_SCROLL
; -----------------------------------------
; сброс перемещения скролла карты
; In:
; Out:
; Corrupt:
; Note:
;   находится на странице "мир"
; -----------------------------------------
ResetMapScroll: ; сброс перемещения карты
                LD A, (GameState.Input.Value)
                AND ~MOVEMENT_MASK
                LD (GameState.Input.Value), A
                RET

                endif ; ~_WORLD_TILEMAP_RESET_MAP_SCROLL
