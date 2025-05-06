
                ifndef _OBJECT_CLASS_HERO_
                define _OBJECT_CLASS_HERO_
; -----------------------------------------
; инициализация объекта - герой
; In:
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Hero:           ; -----------------------------------------
                XOR A
                LD (IY + FObject.Flags), A
                ; -----------------------------------------

                RET
                
                endif ; ~_OBJECT_CLASS_HERO_
