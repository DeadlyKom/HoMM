                ifndef _MAIN_MENU_PARTICLE_REFILL_POINT_QUEUE_
                define _MAIN_MENU_PARTICLE_REFILL_POINT_QUEUE_
; -----------------------------------------
; пополнение очереди точек
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
RefillPointQueue:
                ; инициализация
.Cursor         EQU $+1
                LD HL, .TestText

                ; проверка флага завершения
.BaselineFlag   EQU $
                NOP
                JR C, .IsIndicated                                              ; переход, если базовая линия указана

                ; чтение позиции текста на экране
                LD E, (HL)  ; X
                INC HL
                LD D, (HL)  ; Y
                INC HL
                LD (.BaselinePos), DE                                           ; сохранение позиции базовой линии
                
                ; установка флага завершения
                SET_FLAG_MODIFY RefillPointQueue.BaselineFlag

.IsIndicated    ;
                ; установка страницы шрифта
                LD A, (MainMenu.Base.Content.Font.Page)
                SET_PAGE_A

                ; чтение символа
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если текст закончился
                SUB #21 + #20 ; временно!

                ; сохранение адреса позиции курсора
                LD B, H
                LD C, L

                ; расчёт адреса символа по таблице
                LD HL, (MainMenu.Base.Content.Font.Adr)
                ADD A, A    ; x2
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                ; чтение адреса структуры FGlyphHeader
                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL

                ; проверка помещения точек глифа в буфере
.NumAvailable   EQU $+1                                                         ; количество доступных элементов в буфере очереди точек
                LD A, #00
                SUB (HL)                                                        ; количество точек в глифе
                RET C                                                           ; выход, если доступного места недостаточно
                LD (.NumAvailable), A                                           ; сохранение количество доступных элементов

                ; сохранение адреса следующего символа
                INC BC
                LD (.Cursor), BC

                ; чтение FGlyphHeader
                LD B, (HL)                                                      ; количество точек в глифе
                INC HL
                LD A, (HL)                                                      ; насколько сдвинуть курсор после буквы (шиирина буквы + пробел)
                INC HL
                LD C, (HL)                                                      ; базовая линия глифа
                INC HL
                EXX
.Pointer        EQU $+1                                                         ; адрес буфера очереди точек
                LD HL, #0000
                LD C, A
                EXX

.Loop           LD A, (HL)                                                      ; чтение точки
                INC HL

                EXX
                LD B, A

.BaselinePos    EQU $+1
                LD DE, #0000

                ; расчёт точки по горизонтали
                AND #0F
                ADD A, E
                LD (HL), A
                INC HL

                ; расчёт почки по вертикали
                LD A, B
                RRA
                RRA
                RRA
                RRA
                AND #0F
                ADD A, D
                SUB C
                LD (HL), A
                INC HL
                LD (.Pointer), HL
                EXX

                DJNZ .Loop

                ; сместить курсор по горизонтали
                LD A, (.BaselinePos)
                ADD A, C
                LD (.BaselinePos), A
    
                RET

.TestText       ; отображение текста "АБВГДЕ"
                DW #B267                                                        ; позиция базовой линии строки в пикселях
                lua allpass
                Convert ("АБВГДЕ")
                endlua

                endif ; ~_MAIN_MENU_PARTICLE_REFILL_POINT_QUEUE_
