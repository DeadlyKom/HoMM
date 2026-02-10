
                ifndef _DRAW_UTILS_GET_SPRITE_AABB_
                define _DRAW_UTILS_GET_SPRITE_AABB_

                module Utilities
; -----------------------------------------
; получить ограничивающий прямоугольник спрайта
; In:
;   HL - адрес спрайта FSprite/FSpritesRef
;   флаг переполнения указывает на структуру FSpritesRef в регистровой паре HL,
;   a в аккумуляторе хранится индекс спрайта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GetSpriteAABB:  
                RET

                display " - Get sprite AABB:\t\t\t\t\t", /A, GetSpriteAABB, "\t= busy [ ", /D, $ - GetSpriteAABB, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_UTILS_GET_SPRITE_AABB_
