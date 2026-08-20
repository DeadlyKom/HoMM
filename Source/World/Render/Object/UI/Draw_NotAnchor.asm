
                ifndef _WORLD_RENDER_OBJECT_UI_DRAW_NOT_ANCHOR_
                define _WORLD_RENDER_OBJECT_UI_DRAW_NOT_ANCHOR_
; -----------------------------------------
; отображение объекта UI - без объекта привязки
; In:
;   IX - адрес функции обработки спрайта
;   IY - адрес структуры объекта (FObjectUI)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw.NotAnchor: ; расчёт экранного положения объекта привязки
                
                ; преобразование положения объекта относительно экрана
                ;   IY - адрес структуры FObject
                CALL Utilities.TransformToScr
                ;   HL - позиция по вертикали
                ;   DE - позиция по горизонтали

                ; прибавление смещения UI объекта по вертикали
                LD A, (IY + FObjectUI.AxisOffset.Y)
                ; приведение к фиксированной точки 14.2
                LD B, #00
                ADD A, A  ; << 1
                RL B
                ADD A, A  ; << 2
                RL B
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; прибавление смещения UI объекта по горизонтали
                EX DE, HL
                LD A, (IY + FObjectUI.AxisOffset.X)
                ; приведение к фиксированной точки 14.2
                LD B, #00
                ADD A, A  ; << 1
                RL B
                ADD A, A  ; << 2
                RL B
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                JR Draw.UI

                endif ; ~_WORLD_RENDER_OBJECT_UI_DRAW_NOT_ANCHOR_
