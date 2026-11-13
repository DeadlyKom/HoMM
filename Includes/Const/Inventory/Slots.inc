
                ifndef _CONST_INVENTORY_SLOTS_
                define _CONST_INVENTORY_SLOTS_
; -----------------------------------------
;   флаги состояния слотов "инвентаря"
; -----------------------------------------
INVENTORY_ACTIVE_SLOT_BIT   EQU 0x00                                            ; флаг, активности слота
INVENTORY_FADE_OUT_SLOT_BIT EQU 0x01                                            ; флаг, исчезновения слота, 0 - появление, 1 - исчезновение
INVENTORY_READY_SLOT_BIT    EQU 0x02                                            ; флаг, готовности обоих сохранённых буферов

INVENTORY_FADE_OUT_SLOT     EQU 1 << INVENTORY_FADE_OUT_SLOT_BIT

                ; -----------------------------------------
                ; цвета свободной области, обмена и запрещённого размещения
                ZX_COLOR_IPBF_EQU INVENTORY_GRID_HIGHLIGHT_FREE_COLOR, GREEN, BLACK, 1, 0
                ZX_COLOR_IPBF_EQU INVENTORY_GRID_HIGHLIGHT_SWAP_COLOR, WHITE, BLACK, 1, 0
                ZX_COLOR_IPBF_EQU INVENTORY_GRID_HIGHLIGHT_BLOCKED_COLOR, RED, BLACK, 1, 0
                ; -----------------------------------------

                endif ; ~_CONST_INVENTORY_SLOTS_
