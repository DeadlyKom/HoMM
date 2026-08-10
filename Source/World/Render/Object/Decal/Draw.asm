
                ifndef _WORLD_RENDER_OBJECT_DECAL_DRAW_
                define _WORLD_RENDER_OBJECT_DECAL_DRAW_
; -----------------------------------------
; отображение Decal объекта
; In:
;   IX - адрес функции обработки спрайта
;   IY - адрес структуры объекта (FObjectDecal)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; выравнивание экранного положения по знакоместу
                BIT LAYER_OBJECT_ATTR_ALIGN_BIT, (IY + FObjectDecal.Layer.Flags)
                CALL NZ, World.Base.Render.Object.LayerObject.AlignToAttr
                JP World.Base.Render.Object.Simple.Draw                         ; отображение спрайта

                endif ; ~_WORLD_RENDER_OBJECT_DECAL_DRAW_
