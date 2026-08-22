
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

                ; применение смещения объекта слоя по вертикали
                LD C, (IY + FObjectUI.Layer.AxisOffset.Y)
                XOR A

                BIT LAYER_OBJECT_AXIS_Y_OFFSET_BIT, (IY + FObjectUI.Layer.Flags)
                JR Z, $+7

                LD A, C
                NEG
                LD C, A
                SBC A, A    ; расширение знака до 16 бит

                ; преобразование пиксельного смещения в формат 12.4
                SLA C
                RLA         ; << 1
                SLA C
                RLA         ; << 2
                SLA C
                RLA         ; << 3
                SLA C
                RLA         ; << 4
                LD B, A
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; применение смещения объекта слоя по горизонтали
                EX DE, HL
                LD C, (IY + FObjectUI.Layer.AxisOffset.X)
                XOR A

                BIT LAYER_OBJECT_AXIS_X_OFFSET_BIT, (IY + FObjectUI.Layer.Flags)
                JR Z, $+7

                LD A, C
                NEG
                LD C, A
                SBC A, A    ; расширение знака до 16 бит

                ; преобразование пиксельного смещения в формат 12.4
                SLA C
                RLA         ; << 1
                SLA C
                RLA         ; << 2
                SLA C
                RLA         ; << 3
                SLA C
                RLA         ; << 4
                LD B, A
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                JP Draw.UI

                endif ; ~_WORLD_RENDER_OBJECT_UI_DRAW_NOT_ANCHOR_
