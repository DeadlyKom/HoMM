
                ifndef _HERO_PATH_SET_HERO_PATH_
                define _HERO_PATH_SET_HERO_PATH_
; -----------------------------------------
; установить длины пути героя
; In:
;   A - идентификатор героя
;   C - длина пути
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SetHeroPath:    ;---------------------------------------------------------------
                ; расчёт адреса распологаемого героя
                ; HL = HERO_SIZE * индекс добовляемого героя (64)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW Adr.HeroArray >> 3
                LD IXL, A
                ADC A, HIGH Adr.HeroArray >> 3
                SUB IXL
                LD IXH, A
                ADD IX, IX  ; x8
                ADD IX, IX  ; x16
                ADD IX, IX  ; x32
                ;---------------------------------------------------------------
                ; расчёт адреса распологаемого героя

                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                LD H, HIGH Adr.ObjectsArray >> 4    ; %00001100
                LD A, (IX + FHero.ObjectID)     ; %aaaaaaaa
                ADD A, A                        ; %aaaaaaa0 : a
                RL H                            ; %0001100a
                ADD A, A                        ; %aaaaaa00 : a
                RL H                            ; %001100aa
                ADD A, A                        ; %aaaaa000 : a
                RL H                            ; %01100aaa
                ADD A, A                        ; %aaaa0000 : a
                RL H                            ; %1100aaaa

                LD IYL, A
                LD A, H
                LD IYH, A

                ; установка длины пути
                DEC C
                LD (IY + FObjectHero.PathID), C

                RET

                endif ; ~_HERO_PATH_SET_HERO_PATH_
