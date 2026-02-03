
                ifndef _BUFFERS_RECONNAISSANCE_
                define _BUFFERS_RECONNAISSANCE_
; -----------------------------------------
; рекогносцировка
; In:
;   A  - радиус обзора в тайлах
;   C  - номер бита туман отвечающий за игрока
;   DE - координаты в тайлах (D - y, E - x)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Reconnaissance: ; расчёт адреса из таблицы
                DEC A
                ADD A, A    ; x2
                ADD A, LOW .RadiusTable
                LD L, A
                ADC A, HIGH .RadiusTable
                SUB L
                LD H, A

                ; установить номер бита игрока
                LD A, C
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                OR #C6      ; SET n, (HL)
                LD (.PlayerBit), A

                ; чтение адреса
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A

                ; проверка достижения вехней границы по оси Y 
                LD A, D         ; D - Y
                LD (.Y), A
                SUB (HL)
                JR NC, .SetNewY ; переход, если окружность не обрезается сверху
                NEG
                ADD A, L
                LD L, A
                XOR A
.SetNewY        LD D, A         ; D - новое значение Y (верхняя точка)
                INC HL

.Loop           ; чтение значения
                LD B, (HL)
                INC B
                RET Z                                                           ; выход, если #FF
                DEC B
                INC HL
                PUSH HL

                ; проверка достижения левой границы по оси X
                LD A, E         ; E - X
                SUB B
                JR NC, .SetNewX
                LD C, #00
                JR .SkipIndent_R

.SetNewX        LD C, A         ; C - новое значение X (левая точка)

                ; проверка на смещение по горизонтали, чётной/нечётной строки
                BIT 0, D
                JR NZ, .SkipIndent_R                                            ; переход, если отступ справа вначале не требуется

                ; определение растояние между хордой и центром окружности
.Y              EQU $+1
                LD A, #00
                SUB D
                RRA
                JR NC, .SkipIndent_R                                            ; переход, если отступ справа не требуется
                INC C

.SkipIndent_R   ; определение длины хорды
                LD A, (GameSession.MapSize.Width)                               ; размер какрты по горизонтали
                LD L, A
                LD A, E         ; E - X
                ADD A, B        ; B - радиус
                CP L            ; L - ширина карты
                JR C, .NotClipped
                LD A, L
                DEC A
.NotClipped     SUB C           ; C - левая точка хорды
                INC A           ; +1 тайл центр отсчёта
                LD B, A         ; В - длина хорды

                ; корректирвка длины хорды
                LD A, (.Y)
                RRA
                JR C, .SkipIndent_L                                             ; переход, если нет необходимости изменять длину хорды
                BIT 0, D
                JR Z, .SkipIndent_L                                             ; переход, если нет необходимости изменять длину хорды
                DEC B
                JR NZ, $+3      ; реультат нулевой?
                INC B

.SkipIndent_L   ; расчёт адреса метаданных
                LD L, D
                SET 6, L                    ; 6 бит отвечает за адреса карты/метаданных
                LD H, HIGH Adr.MapAdrTable
                LD A, (HL)
                SET 7, L                    ; 7 бит отвечает за младший/старший адрес
                LD H, (HL)
                ADD A, C
                LD L, A
                JR NC, $+3      ; переполнение младшего байта?
                INC H

.PlayerBit      EQU $+1
.ChordsLoop     SET 0, (HL)
                INC HL
                DJNZ .ChordsLoop

                POP HL
                
                INC D
                LD A, (GameSession.MapSize.Height)
                LD C, A
                LD A, D
                CP C
                JP C, .Loop

                RET

.RadiusTable:   DW .Radius_1
                DW .Radius_2
                DW .Radius_3
                DW .Radius_4
                DW .Radius_5
                DW .Radius_6
                DW .Radius_7

                ; первое значение, смещение по оси Y от центра
                ; последующие значения смещения влево и вправо от центра, 
                ; начиная от вехней точки окружности до нижней
.Radius_1       DB 1, 1,1,1, #FF
.Radius_2       DB 2, 1,2,2,2,1, #FF
.Radius_3       DB 3, 2,2,3,3,3,2,2, #FF
.Radius_4       DB 4, 2,3,3,4,4,4,3,3,2, #FF
.Radius_5       DB 5, 3,3,4,4,5,5,5,4,4,3,3, #FF
.Radius_6       DB 6, 3,4,4,5,5,6,6,6,5,5,4,4,3, #FF
.Radius_7       DB 7, 4,4,5,5,6,6,7,7,7,6,6,5,5,4,4, #FF

                endif ; ~_BUFFERS_RECONNAISSANCE_
