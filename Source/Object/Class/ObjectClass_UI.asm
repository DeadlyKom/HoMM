
                ifndef _OBJECT_CLASS_UI_
                define _OBJECT_CLASS_UI_
; -----------------------------------------
; инициализация объекта - элемент UI
; In:
;   A' - идентификатор объекта
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject (FObjectUI)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
UI:             ; -----------------------------------------
                XOR A
                LD (IY + FObject.Flags), A
                ; -----------------------------------------

                RET
                
                endif ; ~_OBJECT_CLASS_UI_
