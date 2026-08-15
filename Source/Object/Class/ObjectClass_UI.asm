
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
UI:             ; инициализация базового состояния объекта
                LD (IY + FObject.Flags), OBJECT_DIRTY | OBJECT_TICK_ENABLED

                ; инициализация объекта привязки
                LD (IY + FObjectUI.Anchor), UI_ANCHOR_NONE

                ; инициализация времени жизни UI объекта
                LD A, (IX + FODS_UI.Super.Variable_A)
                LD (IY + FObjectUI.Lifetime), A

                ; инициализация порядка отображения UI объекта
                LD A, (IX + FODS_UI.Super.Variable_B)
                LD (IY + FObjectUI.ZOrder), A

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_UI_
