
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_
; -----------------------------------------
; отображение спрайта выровненного в знакоместах (без ограничений)
; In:
;   HL - адрес спрайта
;   DE - координаты в пикселях (D - y, E - x)
;        если необходимы
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - спрайт не проверяется на границы экрана и не обрезается
;   - спрайт перед отрисовкой не копируется в буфер
;   - спрайт выводится только в основное окно (#4000)
;
;   установлена защитная от порчи данных с разрешённым прерыванием для регистровой пары BC
;   ℹ️ структура спрайта:
;    - первый байт количество FSpriteBlock'ов
;    - массив FSpriteBlock'ов
;    - данные спрайтов, на которые ссылаются FSpriteBlock'и
; -----------------------------------------
DrawNotClipping.NotBound
                LD BC, #0000    ; инициализация отсутствия ограничения вывода
; -----------------------------------------
; отображение спрайта выровненного в знакоместах
; In:
;   HL - адрес спрайта
;   DE - координаты в пикселях (D - y, E - x)
;        если необходимы
;   BC - ограничение по осям (B - y, C - x)
;        если не требуется, необходимо обнулить
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - спрайт не проверяется на границы экрана и не обрезается
;   - спрайт перед отрисовкой не копируется в буфер
;   - спрайт выводится только в основное окно (#4000)
;
;   установлена защитная от порчи данных с разрешённым прерыванием для регистровой пары BC
;   ℹ️ структура спрайта:
;    - первый байт количество FSpriteBlock'ов
;    - массив FSpriteBlock'ов
;    - данные спрайтов, на которые ссылаются FSpriteBlock'и
; -----------------------------------------
DrawNotClipping.Bound
                ; инициализация
                LD (.Possition), DE                                             ; сохранение вводной позиции
                LD (Functions.VHCounters), BC                                   ; сохранение вводного ограничения спрайта
                LD B, (HL)                                                      ; количество FSpriteBlock'ов
                INC HL
                LD (.BlockAdr), HL

                ifdef _DEBUG
                LD A, B
                OR A
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif

                ; проверка на единственный блок в списке
                DEC B
                JR Z, .DrawBlock                                                ; переход, если блок один

                ; формирование цикла обхода по блокам
                LD DE, .DrawBlock
.BlockLoop      PUSH DE
                DJNZ .BlockLoop

.DrawBlock      ; рисование блока
.BlockAdr       EQU $+1
                LD HL, #0000

                ; расчёт адреса начала отображения (в пикселях)
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL
                ADD HL, DE
                EX DE, HL
                PUSH DE

                ; чтение размера спрайта (в пикселях)
                LD C, (HL)
                INC HL
                LD B, (HL)
                INC HL

                ; чтение позиции спрайта (в пикселях)
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL

                ; чтение флагов
                LD A, (HL)
                INC HL
                LD (.BlockAdr), HL
                EX AF, AF'

                ; проверка флага позиции относительного или абсолютного положения
                DEC HL
                BIT SPRITE_NOT_CLIPPING_LOCATION_BIT, (HL)
                JR NZ, .IsAbsolute                                              ; переход, если абсолютные

                ; относительные
.Possition      EQU $+1
                LD HL, #0000
                ADD HL, DE
                EX DE, HL
.IsAbsolute     ; DE - координаты (D - y, E - x)        (в пикселях)
                ; BC - размер спрайта (B - y, C - x)    (в пикселях)
                ; A' - флаги вывода спрайта

                ; проверка отзеркаливания по вертикали
                BIT SPRITE_NOT_CLIPPING_MIRROR_VERTICAL_BIT, (HL)
                JR Z, .NotMirrorVert
                ; отчёт снизу вверх, добавим высоту спрайта к позиции
                LD A, D
                ADD A, B
                DEC A       ; уменьшить на еденицу, начиная с самой нижней строки знакоместа
                LD D, A

.NotMirrorVert  ; проверка отзеркаливания по горизонтали
                BIT SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL_BIT, (HL)
                JR Z, .NotMirrorHorz
                
                ; отчёт слева направо, добавим ширину спрайта к позиции
                LD A, E
                ADD A, C
                DEC A       ; уменьшить на еденицу, начиная с самой правой строки знакоместа
                LD E, A

.NotMirrorHorz  ; расчёт адреса функции рисования
                EX AF, AF'
                LD C, A
                AND %00001110
                ADD A, LOW FunctionTable
                LD L, A
                ADC A, HIGH FunctionTable
                SUB L
                LD H, A
                LD A, (HL)
                LD IXL, A
                INC HL
                LD A, (HL)
                LD IXH, A

                display " - Draw sprite aligned in boundary:\t\t\t", /A, DrawNotClipping.NotBound, "\t= busy [ ", /D, $-DrawNotClipping.NotBound, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_
