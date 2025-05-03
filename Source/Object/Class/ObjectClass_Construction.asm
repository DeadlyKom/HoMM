
                ifndef _OBJECT_CLASS_CONSTRUCTION_
                define _OBJECT_CLASS_CONSTRUCTION_
; -----------------------------------------
; инициализация объекта - постройка
; In:
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Construction:   ; -----------------------------------------
                BIT OBJECT_AFFILIATION_BIT, (IX + FObjectDefaultSettings.Flags) ; принадлежность
                                                                                ;   0 - объект не может кому либо принадлежать
                                                                                ;   1 - объект может принадлежать кому либо
                ; -----------------------------------------
                XOR A
                LD (IY + FObject.Flags), A
                ; -----------------------------------------

                RET
                
                endif ; ~_OBJECT_CLASS_CONSTRUCTION_
