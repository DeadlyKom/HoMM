
                ifndef _OBJECT_UTILITIES_GET_OBJECT_ID_BY_ADDRESS_
                define _OBJECT_UTILITIES_GET_OBJECT_ID_BY_ADDRESS_
; -----------------------------------------
; получить ID объекта
; In:
;   HL - адрес объекта
; Out:
;   A  - ID объекта
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
ObjectID.HL:    CALC_OBJECT_ID HL                                               ; расчёт ID объекта
                LD A, H
                RET
; -----------------------------------------
; получить адрес объекта
; In:
;   IX - адрес объекта
; Out:
;   A  - ID объекта
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
ObjectID.IX:    LD A, IXH
                LD H, A
                LD A, IXL
                LD L, A

                CALC_OBJECT_ID HL                                               ; расчёт ID объекта
                LD A, H
                RET
; -----------------------------------------
; получить адрес объекта
; In:
;   IY - адрес объекта
; Out:
;   A  - ID объекта
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
ObjectID.IY:    LD A, IYH
                LD H, A
                LD A, IYL
                LD L, A
                
                CALC_OBJECT_ID HL                                               ; расчёт ID объекта
                LD A, H
                RET

                endif ; ~_OBJECT_UTILITIES_GET_OBJECT_ID_BY_ADDRESS_
