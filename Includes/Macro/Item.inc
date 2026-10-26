
                ifndef _MACRO_ITEM_
                define _MACRO_ITEM_
; -----------------------------------------
; регистрация идентификатора метки
; In:
;   Label?  - идентификатор метка визуализации предмета
; -----------------------------------------
REG_ITEM_VISUAL_ID  macro Label?
Label?              EQU ITEM_VISUAL_ID_COUNTER
ITEM_VISUAL_ID_COUNTER = ITEM_VISUAL_ID_COUNTER + 1
                    endm
; -----------------------------------------
; формирование структуры описания спрайта предмета
; In:
;   Width?  - ширина в ячейках
;   Height? - высота в ячейках
;   Offset? - смещение до данных спрайта
;   Label?  - идентификатор метка визуализации предмета
; -----------------------------------------
ITEM_VISUAL     macro Width?, Height?, Offset?, Label?
                REG_ITEM_VISUAL_ID Label?
                FItemVisual {
                    {
                        (Width?) << 1,
                        (Height?) << 1
                    },
                    Offset?
                }
                endm

                endif ; ~_MACRO_ITEM_
