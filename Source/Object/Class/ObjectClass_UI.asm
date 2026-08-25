
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
UI:             ; инициализация быстрых флагов объекта
                LD (IY + FObject.FastFlags), OBJECT_DIRTY | \
                                            OBJECT_TICK_ENABLED | \
                                            OBJECT_SELF_CALCULATED_POSITION

                ; инициализация медленных флагов объекта
                LD (IY + FObject.SlowFlags), OBJECT_TICK_WHEN_SUSPENDED

                ; инициализация флага выравнивания положения по знакоместу
                BIT OBJECT_UI_ATTR_ALIGN_BIT, (IX + FODS_UI.Flags)
                LD A, #86 | (LAYER_OBJECT_ATTR_ALIGN_BIT << 3)                  ; RES LAYER_OBJECT_ATTR_ALIGN_BIT, (IY+d)
                JR Z, $+4
                LD A, #C6  | (LAYER_OBJECT_ATTR_ALIGN_BIT << 3)                 ; SET LAYER_OBJECT_ATTR_ALIGN_BIT, (IY+d)
                LD (.LayerOpcode), A

.LayerOpcode    EQU $+3
                DB #FD, #CB, FObjectUI.Layer.Flags, #00                         ; RES/SET LAYER_OBJECT_ATTR_ALIGN_BIT, (IY + FObjectUI.Layer.Flags)

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
