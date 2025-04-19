
                ifndef _SPRITE_INITIALIZE_
                define _SPRITE_INITIALIZE_
; -----------------------------------------
; инициализация массива информации о спрайтах SpriteInfoBuffer
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     XOR A
                LD (GameState.SpriteInfoNum), A

                ; использования буфера, как карту инициализированных значений
                JP_MEMSET_BYTE BUFFER_ADDRESS, EMPTY_INDEX, 256

                display " - Sprite initialize:\t\t\t\t\t", /A, Initialize, "\t= busy [ ", /D, $-Initialize, " byte(s)  ]"

                endif ; ~ _SPRITE_INITIALIZE_
