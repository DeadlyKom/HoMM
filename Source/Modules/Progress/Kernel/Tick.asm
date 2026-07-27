
                ifndef _MODULE_PROGRESS_TICK_
                define _MODULE_PROGRESS_TICK_
; -----------------------------------------
; тик окна прогресса
; In:
; Out:
; Corrupt:
;   HL, BC, AF
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
                CALL .HL

                ; переход к следующему кадру анимации
                LD HL, .FrameCounter
                DEC (HL)
                RET NZ                                                          ; выход, если счётчик не обнулён
.FrameNum       EQU $+1
                LD (HL), #00
                endif
                RET
.HL             JP (HL)

                endif ; ~_MODULE_PROGRESS_TICK_
