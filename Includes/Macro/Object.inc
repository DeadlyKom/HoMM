
                ifndef _MACRO_OBJECT_
                define _MACRO_OBJECT_
; -----------------------------------------
; расчёт ID объекта
; In:
;   Reg? - промежуточный регистр (HL, IX, IY)
; Out:
;   A    - ID объекта
; Corrupt:
;   Reg?
; Note:
; -----------------------------------------
CALC_OBJECT_ID  macro Reg?

                ; преобразование адреса объекта в ID объекта:
                ; Adr.ObjectsArray + ID * OBJECT_SIZE, где OBJECT_SIZE = 32
                if OBJECT_SIZE > 32
                error "address calculation error"
                endif

                ADD Reg?, Reg?  ; x2
                ADD Reg?, Reg?  ; x4
                ADD Reg?, Reg?  ; x8
                endm

                endif ; ~_MACRO_OBJECT_
