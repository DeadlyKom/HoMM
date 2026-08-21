
                ifndef _TICK_SPAWN_STANDARD_
                define _TICK_SPAWN_STANDARD_
; -----------------------------------------
; спавн падающего штандарта
; In:
;   DE - положение гексагона (D - y, E - x)
; Out:
;   A' - идентификатор объекта
;   IX - адрес структуры настроек (FODS_UI)
;   IY - адрес структуры созданного объекта (FObjectUI)
;   флаг переполнения установлен, если нет свободного места в массиве
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;
;   ℹ️ код расположен в странице 0
; -----------------------------------------
Standard:       LD B, ODS_ID_UI_STANDARD
                CALL Object.Spawn
                RET C                                                           ; выход, если отсутствует свободное место

                SET LAYER_OBJECT_AXIS_Y_OFFSET_BIT, (IY + FObjectUI.Layer.Flags); вычитать положительное смещение из экранной позиции
                LD (IY + FObjectUI.Layer.AxisOffset.Y), UI_STANDARD_DROP_HEIGHT ; начальное положение выше гекса приземления
                RET

                endif ; ~_TICK_SPAWN_STANDARD_

