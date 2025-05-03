
                ifndef _OBJECT_CLASS_CHARACTER_
                define _OBJECT_CLASS_CHARACTER_
; -----------------------------------------
; инициализация объекта - персонаж
; In:
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Character:      ; -----------------------------------------
                XOR A
                LD (IY + FObject.Flags), A
                ; -----------------------------------------

                RET
                
                endif ; ~_OBJECT_CLASS_CHARACTER_
