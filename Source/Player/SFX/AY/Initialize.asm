
                ifndef _PLAYER_SFX_AY_INITIALIZE_
                define _PLAYER_SFX_AY_INITIALIZE_
; -----------------------------------------
; инициализация проигрывателя эффектов
; In:
;   HL - адрес банка эффектов
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     INC HL                                                          ; переход к адресу таблицы смещений эффектов

                ; сохранение адреса таблицы смещений эффектов
                LD (Play.OffsetTable), HL

                ; инициализация внутренней структуры
                LD HL, AFX_Variables
                LD DE, #00FF
                LD BC, #03FD

.StructLoop     ; заполнение структуры дефолтными значениями
                LD (HL), D
                INC L
                LD (HL), D
                INC L
                LD (HL), E
                INC L
                DJNZ .StructLoop

                ; инициализация AY
                LD HL, #FFBF
                LD E, #0E                                                       ; R13 + 1

.ClearPortLoop  ; очистка портов
                DEC E
                LD B, H
                OUT (C), E
                LD B, L
                OUT (C), D
                JR NZ, .ClearPortLoop

                XOR A
                LD (Tick.Noise), A                                              ; сброс переменной проигрывателя
                LD (Adr.AY.R7_Settings), A                                      ; сброс переменной проигрывателя

                RET

                display "\t- Initialize: \t\t\t\t\t", /A, Initialize, " = busy [ ", /D, $ - Initialize, " bytes  ]"

                endif ; ~ _PLAYER_SFX_AY_INITIALIZE_
