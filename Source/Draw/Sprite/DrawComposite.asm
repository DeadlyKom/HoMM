
                ifndef _DRAW_SPRITE_DRAW_COMPOSITE_
                define _DRAW_SPRITE_DRAW_COMPOSITE_
; -----------------------------------------
; отображение композитного спрайта
; In:
;   HL - адрес на структуру FSpritesRef
;       ; -----------------------------------------
;       ;      7    6    5    4    3    2    1    0
;       ;   +----+----+----+----+----+----+----+----+
;       ;   | 0  | 0  | N5 | N4 | N3 | N2 | N1 | N0 |
;       ;   +----+----+----+----+----+----+----+----+
;       ;
;       ;   N5-N0   [5..0]      - количество спрайтов
;       ; -----------------------------------------
;   E  - хранит значение FSpritesRef.Num (все флаги обнулены)
;   A  - счётчик анимации
; Out:
; Corrupt:
; Node:
; -----------------------------------------
DrawComposite:  ; сохранение счётчика, от которого будет отталкиватьяс выбор анимации
                LD (.InputCounter), A

                ; переключение на страницу расположения списка FSpritesRef
                INC L                                                           ; пропуск FSpritesRef.Num

                ; чтение страницы расположения данных о структурах
                LD C, (HL)                                                      ; FSpritesRef.Data.Page
                INC L

                ; чтение адреса расположения массива структур
                LD A, (HL)
                INC L
                LD H, (HL)
                LD L, A

                LD B, E                                                         ; количество спрайтов

.DrawLoop       PUSH BC

                LD A, C
                SET_PAGE_A                                                      ; установка страницы спрайта

                ; HL - адрес структуры FSprite/FSpritesRef
                BIT SPRITE_REF_BIT, (HL)
                JR Z, .DrawSprite                                               ; спрайт является простым спрайтом (FSprite)

                ; -----------------------------------------
                ; спрайт имеет анимации, необходимо выбрать анимацию
                ; -----------------------------------------

                ; получение количества анимаций в списке 
                LD A, (HL)
                AND ~(SPRITE_REF | SPRITE_CS)
                LD E, A

                ; -----------------------------------------
                ; деление D на E
                ; In:
                ;   D - делимое
                ;   E - делитель
                ; Out:
                ;   D - результат деления   (D / E)
                ;   A - остаток             (D % E)
                ; Corrupt:
                ;   D, AF
                ; Note:
                ;   https://www.smspower.org/Development/DivMod
                ; -----------------------------------------
.InputCounter   EQU $+1
                LD D, #00
                CALL Math.Div8x8                                                ; mod
                SCF                                                             ; указываем на использование FSpritesRef,
                                                                                ; необходимо выбрать спрайт
.DrawSprite     ; копирование структуры
                SPRITE_DE SPRITE_TEMP_IDX
                rept FSprite
                LDI
                endr
                PUSH HL
                SPRITE_HL SPRITE_TEMP_IDX
                
                ; -----------------------------------------
                ;   HL - адрес спрайта FSprite/FSpritesRef
                ;   флаг переполнения указывает на структуру FSpritesRef в регистровой паре HL,
                ;   a в аккумуляторе хранится индекс спрайта
                ; Out:
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                CALL Draw.Sprite
                POP HL

                POP BC
                DJNZ .DrawLoop

                RET

                endif ; ~ _DRAW_SPRITE_DRAW_COMPOSITE_
