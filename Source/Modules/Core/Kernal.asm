
                ifndef _MODULE_CORE_KERNAL_
                define _MODULE_CORE_KERNAL_
Kernel:
.Init           EQU 0x00
.Keyboard_WASD  EQU 0x01
.Keyboard_QAOP  EQU 0x02
.RedefineKeys   EQU 0x03
.Kempston5      EQU 0x04
.Kempston8      EQU 0x05

; -----------------------------------------
; выборка запускаемой функции
; In:
;   A  - индекс запускаемой функции
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
                POP AF
                ; -----------------------------------------
                ; переход по таблице переходов
                ; In:
                ;   A  - индекс перехода
                ;   HL - адрес таблицы переходов
                ; Out:
                ; Corrupt:
                ;   HL, AF
                ; Note:
                ; -----------------------------------------
                LD HL, .JumpTable
                JP Func.JumpTable
.JumpTable:     ; инициализация ядра                    (0)
                DW Initialize.Core
                ; установка клавиатуры (WASD)
                DW Initialize.SetKeyboard_WASD
                ; установка клавиатуры (QAOP)
                DW Initialize.SetKeyboard_QAOP
                ; установка клавиатуры (переназначение клавиш)
                DW Initialize.Input.SetRedefineKeys
                ; установка 5 кнопочного кемстона
                DW Initialize.Input.SetKempston5
                ; установка 8 кнопочного кемстона
                DW Initialize.Input.SetKempston8

                endif ; ~_MODULE_CORE_KERNAL_
