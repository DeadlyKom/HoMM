
                ifndef _MODULE_SESSION_UTILITIES_DATA_AVAILABILITY_
                define _MODULE_SESSION_UTILITIES_DATA_AVAILABILITY_
; -----------------------------------------
; проверка доступных данных
; In:
;   HL - адрес блока
;   BC - длина блока
; Out:
;   флаг переполнения установлен, если найдены данные отличные от нуля
; Corrupt:
; Note:
;   адрес исполнения неизвестен
; -----------------------------------------
DataAvailable:  XOR A

                ; поиск данных отличных от нуля
.Loop           CPI
                JR NZ, .Found
                JP PE, .Loop
                RET

.Found          SCF
                RET

                display " - Utilities data availability:\t\t\t\t\t     \t= busy [ ", /D, $-DataAvailable, " byte(s) ]"

                endif ; ~_MODULE_SESSION_UTILITIES_DATA_AVAILABILITY_
