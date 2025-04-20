
                ifndef _SPRITE_ADD_
                define _SPRITE_ADD_
; -----------------------------------------
; добавление спрайта
; In:
;   HL - адрес структуры FSprite
; Out:
;   A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
;   флаг переполнения Carry сброшен, если спрайт не был добавлен
; Corrupt:
;   HL, DE, B, AF
; Note:
;   * автоматически корректирует адрес и страницу после загрузки ассета
; -----------------------------------------
Add:            ; проверка переполнения буфера
                LD A, (GameState.SpriteInfoNum)
                CP SPRITE_BUF_MAX
                RET NC                                                          ; выход, если массив переполнен

                INC A
                LD (GameState.SpriteInfoNum), A
                DEC A

                ADD A, A    ; x2
                LD L, A
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                EX DE, HL
    
                ; проверка на структуру FSpritesRef, 7 бит первого байта включен
                BIT SPRITE_REF_BIT, (HL)
                JR Z, Copy                                                      ; переход, если это структура FSprite (хранит все конечные значения)
                
                ; HL указывает на структуру FSpritesRef, 
                ; необходимо скорректировать только линейный адрес спрайтов

                LD B, (HL)
                RES SPRITE_REF_BIT, B
                RES SPRITE_CS_BIT, B

                ; корректировка и копирование ссылочного спрайта
                ; HL - адрес структуры FSprite
                ; DE - адрес буфера SpriteInfoBuffer
                ; B  - количество структур FSprite в массиве

                ; FSpritesRef.Num
                LD A, (HL)
                RES SPRITE_REF_BIT, A                                           ; заранее очистка флага, дабы не обнулять его при рендере
                                                                                ; данный флаг переносится в 7 бит индекса спрайта в буфере SpriteInfoBuffer
                LD (DE), A
                INC HL
                INC E

                ; FSpritesRef.Data.Page
                LD A, (GameState.Assets + FAssets.Address.Page)
                OR (HL)
                LD (DE), A
                INC HL
                INC E

                ; FSpritesRef.Data.Adr
                PUSH DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                ADD HL, DE
                POP DE
                EX DE, HL
                LD (HL), E
                INC L
                LD (HL), D
                EX DE, HL
                
                ; HL - указывает на адрес структур FSprite
                ; B  - количество структур FSprite в массиве

.Nesting        ; проверка на необходимость корректировки адресов
                LD A, B
                OR A
                JR Z, .Exit                                                     ; переход, если не требуется корректировка адресов в информации о спрайтах

.Loop           ;  проверка на структуру FSpritesRef, 7 бит первого байта включен
                BIT SPRITE_REF_BIT, (HL)
                JR Z, .Simple                                                   ; переход, если это структура FSprite (хранит все конечные значения)

                PUSH BC

                LD B, (HL)
                RES SPRITE_REF_BIT, B
                RES SPRITE_CS_BIT, B

                ; корректировка и копирование ссылочного спрайта
                ; HL - адрес структуры FSprite
                ; B  - количество структур FSprite в массиве

                ; FSpritesRef.Num
                INC HL

                ; FSpritesRef.Data.Page
                LD A, (GameState.Assets + FAssets.Address.Page)
                OR (HL)
                LD (HL), A
                INC HL

                ; FSpritesRef.Data.Adr
                LD E, (HL)
                INC HL
                LD D, (HL)
                PUSH HL
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                ADD HL, DE
                EX DE, HL
                POP HL
                LD (HL), D
                DEC HL
                LD (HL), E
                INC HL
                INC HL
                INC HL
                INC HL
                INC HL
                INC HL
                
                ; HL - указывает на адрес структур FSprite
                ; B  - количество структур FSprite в массиве

                PUSH HL
                EX DE, HL
                CALL .Nesting
                POP HL

                POP BC
                JR .NextSprite

.Simple         ; пропуск полуй структуры, не требующие изменения
                INC HL  ; FSprite.Info.Width
                INC HL  ; FSprite.Info.Height
                INC HL  ; FSprite.Info.SOx
                INC HL  ; FSprite.Info.SOy
                INC HL  ; FSprite.ExtraFlags

                ; FSprite.Data.Page
                LD A, (GameState.Assets + FAssets.Address.Page)
                OR (HL)
                LD (HL), A
                INC HL

                ; FSprite.Data.Adr
                LD E, (HL)
                INC HL
                LD D, (HL)
                PUSH HL
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                ADD HL, DE
                POP DE
                EX DE, HL
                LD (HL), D
                DEC HL
                LD (HL), E
                INC HL
                INC HL

.NextSprite     DJNZ .Loop

.Exit           LD A, (GameState.SpriteInfoNum)
                DEC A
                SET SPRITE_REF_BIT, A
                SCF                                                             ; установка флага, успешность добавления
                RET
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
                LDI     ; FSprite.ExtraFlags

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
