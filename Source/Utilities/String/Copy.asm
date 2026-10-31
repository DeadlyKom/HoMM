
                ifndef _UTILITIES_STRING_COPY_
                define _UTILITIES_STRING_COPY_
; -----------------------------------------
; копирование строки
; In:
;   HL - адрес источника (включая завершающий нулевой символ)
;   DE - адрес места назначения
; Out:
;   HL - адрес следующего байта после завершающего нулевого символа
;   DE - адрес следующего байта места назначения
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
Copy:           LD A, (HL)
                LDI
                OR A
                RET Z
                JR Copy

                endif ; ~_UTILITIES_STRING_COPY_
