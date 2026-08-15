
                ifndef _WORLD_RENDER_LAYER_OBJECT_ALIGN_TO_ATTR_
                define _WORLD_RENDER_LAYER_OBJECT_ALIGN_TO_ATTR_
; -----------------------------------------
; выравнивание экранного положения объекта по знакоместу
; In:
;   Kernel.Sprite.DrawClipping.PositionX - положение по горизонтали
;   Kernel.Sprite.DrawClipping.PositionY - положение по вертикали
; Out:
;   Kernel.Sprite.DrawClipping.PositionX - положение по горизонтали, выровненное по знакоместу
;   Kernel.Sprite.DrawClipping.PositionY - положение по вертикали, выровненное по знакоместу
; Corrupt:
;   AF
; Note:
;   знакоместо равно 8 пикселям или #80 в формате 12.4
; -----------------------------------------
AlignToAttr:    LD A, (Kernel.Sprite.DrawClipping.PositionX)
                AND #80
                LD (Kernel.Sprite.DrawClipping.PositionX), A

                LD A, (Kernel.Sprite.DrawClipping.PositionY)
                AND #80
                LD (Kernel.Sprite.DrawClipping.PositionY), A
                RET

                display " - Align layer object to attribute:\t\t\t", /A, AlignToAttr, "\t= busy [ ", /D, $-AlignToAttr, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_LAYER_OBJECT_ALIGN_TO_ATTR_
