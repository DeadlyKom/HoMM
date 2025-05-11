
                ifndef _MODULE_SESSION_UTILS_DATA_AVAILABILITY_
                define _MODULE_SESSION_UTILS_DATA_AVAILABILITY_
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

                display " - Utils data availability:\t\t\t\t", /A, DataAvailable, "\t= busy [ ", /D, $-DataAvailable, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_UTILS_DATA_AVAILABILITY_
