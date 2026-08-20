
                ifndef _WORLD_RENDER_OBJECT_UI_DRAW_ICON_CHARACTER_
                define _WORLD_RENDER_OBJECT_UI_DRAW_ICON_CHARACTER_
; -----------------------------------------
; отображение объекта UI - иконка персонажа
; In:
;   IX - адрес функции обработки спрайта
;   IY - адрес структуры объекта (FObjectUI)
;   HL - позиция по вертикали
;   DE - позиция по горизонтали
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw.IconChar:  ; расчёт экранного положения объекта привязки

                ; прибавление смещения UI объекта по вертикали
                LD BC, (IY + FObject.Position.Y)
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; прибавление смещения UI объекта по горизонтали
                EX DE, HL
                LD BC, (IY + FObject.Position.X)
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                JP Draw.UI

                endif ; ~_WORLD_RENDER_OBJECT_UI_DRAW_ICON_CHARACTER_
