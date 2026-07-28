
                ifndef _MODULE_PROGRESS_TICK_
                define _MODULE_PROGRESS_TICK_
; -----------------------------------------
; тик окна прогресса
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   адрес исполнения неизвестен
;   функция использует специальное соглашение по стеку и вызывается напрямую,
;   без ExecuteModule.Progress
;
;   прямой вызов через диспетчер загруженного модуля:
;       SET_MODULE_PAGE_Progress
;       LD HL, (Kernel.Modules.Progress.Address)
;       LD A, Progress.Tick
;       PUSH AF
;       JP (HL)
; -----------------------------------------
Tick:           ifdef ENABLE_LOADING_PROCESS
                ;
                LD HL, WorldTreeSymbol + 1
.FrameCounter   EQU $+1
                LD A, #00
                LD E, A                                                         ; сохранить индекс текущего кадра
                ADD A, A    ; x2: размер элемента таблицы смещений
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                ; чтение смещения до кода текущего кадра
                LD C, (HL)
                INC HL
                LD B, (HL)
                ADD HL, BC
                PUSH HL

                ; чтение адреса следующего кадра
                LD HL, WorldTreeSymbol + 1
                LD A, E
                INC A                                                           ; следующий кадр для вычисления длины
                ADD A, A    ; x2: размер элемента таблицы смещений
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                ; чтение смещения до кода предыдущего кадра
                LD C, (HL)
                INC HL
                LD B, (HL)
                ADD HL, BC

                ; размер кода равен разнице адресов следующего и текущего кадров
                POP DE                                                          ; адрес кода текущего кадра
                OR A                                                            ; сброс Carry перед вычитанием
                SBC HL, DE
                LD B, H
                LD C, L

                ; копирование кода кадра в фиксированный буфер
                EX DE, HL                                                       ; адрес кода текущего кадра
                LD DE, TickBuffer
                CALL Memcpy.FastLDIR

                ; запуск копии при включённой странице теневого экрана;
                ; после RET страница модуля Progress будет восстановлена
                CALL_IN_PAGE PAGE_7, TickBuffer

                ; переход к следующему кадру анимации
                LD HL, .FrameCounter
                DEC (HL)
                RET NZ                                                          ; выход, если счётчик не обнулён
.FrameNum       EQU $+1
                LD (HL), #00
                endif
                RET

                endif ; ~_MODULE_PROGRESS_TICK_
