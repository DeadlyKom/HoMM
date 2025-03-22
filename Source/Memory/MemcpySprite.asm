
                    ifndef _MEMORY_COPY_SPRITE_
                    define _MEMORY_COPY_SPRITE_

                    module Memcpy
; -----------------------------------------
; копирование спрайта в общий буфер
; In:
;   DE - адрес спрайта
;   A  - количество копируемых байт
; Out:
;   HL  - адрес спрайта
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   максимальный размер спрайта 256 байт
; -----------------------------------------
Sprite:         ; установка адреса расположения спрайта
                NEG
                LD (.SpriteAdr), A

                ; ---------------------------------------------
                ; расчёт адреса перехода
                ; ---------------------------------------------
                LD H, #00
                LD L, A
                ADD HL, HL
                LD BC, .Memcpy
                ADD HL, BC
                LD (.MemcpyJump), HL

                ; подготовка для работы с включенным прерыванием
                RESTORE_HL
                LD (.ContainerSP), SP

                ; чтение данных спрайта
                EX DE, HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL

                ; подготовка использования стека
                LD (.Source), HL
                EX DE, HL
.Source         EQU $+1
                LD SP, #0000

                ; копирование данных
.MemcpyJump     EQU $+1
                JP #0000
; ---------------------------------------------
; копирование данных из массива
; In:
;   SP - адрес спрайта
;   HL - первая пара данных спрайта
; Out:
;   HL - адрес начала спрайта
; Corrupt:
;   HL
; Note:
; ---------------------------------------------
.Memcpy
.Count          defl Adr.SharedBuffer
                dup 127
                LD (.Count), HL
.Count          = .Count + 2
                POP HL
                edup
                LD (.Count), HL
.ContainerSP    EQU $+1
                LD SP, #0000
.SpriteAdr      EQU $+1
                LD HL, Adr.SharedBuffer
                RET

                display " - Memcpy sprite:\t\t\t\t\t", /A, Sprite, "\t= busy [ ", /D, $ - Sprite, " byte(s)  ]"

                endmodule

                endif ; ~_MEMORY_COPY_SPRITE_
