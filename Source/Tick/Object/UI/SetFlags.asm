
                ifndef _TICK_OBJECT_UI_SET_FLAGS_
                define _TICK_OBJECT_UI_SET_FLAGS_
; -----------------------------------------
; установка флагов UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   DE - адрес структуры настроек (FUISettings_Flags)
; Out:
;   флаг переполнения установлен, фаза завершена
; Corrupt:
;   AF
; Note:
;   флаги устанавливаются в FObjectUI.Layer.Flags операцией OR
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.SetFlags:    LD A, (DE)                                                      ; FUISettings_Flags.Flags
                OR (IX + FObjectUI.Layer.Flags)                                 ; установка флагов из настроек
                LD (IX + FObjectUI.Layer.Flags), A

                SCF                                                             ; флаг переполнения установлен, фаза завершена
                JP UI.MarkDirty                                                 ; обновление области объекта после изменения флагов

                endif ; ~_TICK_OBJECT_UI_SET_FLAGS_
