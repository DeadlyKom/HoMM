
                ifndef _SPRITE_ADD_
                define _SPRITE_ADD_
; -----------------------------------------
; добавление спрайта
; In:
;   DE - адрес структуры FSprite
; Out:
;   A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
;   HL - адрес структуры FSprite (текущего спрайта)
;   флаг переполнения Carry сброшен, если спрайт не был добавлен
; Corrupt:
;   HL, DE, B, AF
; Note:
;   * автоматически корректирует адрес и страницу после загрузки ассета
; -----------------------------------------
Add:            ; проверка переполнения буфера
                LD A, (GameState.SpriteInfoNum)
                CP SPRITE_BUF_MAX
                RET NC

                INC A
                LD (GameState.SpriteInfoNum), A
                DEC A

                ADD A, A    ; x2
                LD L, A
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                EX DE, HL
; -----------------------------------------
; копирование линейной структуры FSptrite в буфер SpriteInfoBuffer
; In:
;   HL - адрес структуры FSprite
;   DE - адрес буфера SpriteInfoBuffer
; Out:
;   A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
;   HL - адрес структуры FSprite + 8
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   * автоматически корректирует адрес и страницу после загрузки ассета
; -----------------------------------------
Copy:           LDI     ; FSprite.Info.Width
                LDI     ; FSprite.Info.Height
                LDI     ; FSprite.Info.SOx
                LDI     ; FSprite.Info.SOy
                LDI     ; FSprite.Dummy

                ; FSprite.Data.Page
                LD A, (GameState.Assets + FAssets.Address.Page)
                OR (HL)
                LD (DE), A
                INC HL
                INC E

                ; FSprite.Data.Adr
                PUSH DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX (SP), HL
                PUSH HL
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                ADD HL, DE
                POP DE
                EX DE, HL
                LD (HL), E
                INC L
                LD (HL), D
                POP HL

                LD A, (GameState.SpriteInfoNum)
                DEC A
                SCF                                                             ; установка флага, успешность добавления
                RET

                display " - Sprite add:\t\t\t\t\t", /A, Add, "\t= busy [ ", /D, $-Add, " byte(s)  ]"

                endif ; ~_SPRITE_ADD_
