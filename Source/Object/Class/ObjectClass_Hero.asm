
                ifndef _OBJECT_CLASS_HERO_
                define _OBJECT_CLASS_HERO_
; -----------------------------------------
; инициализация объекта - герой
; In:
;   A' - идентификатор объекта
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject (FObjectHero)
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
