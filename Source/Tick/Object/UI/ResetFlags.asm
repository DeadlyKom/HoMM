
                ifndef _TICK_OBJECT_UI_RESET_FLAGS_
                define _TICK_OBJECT_UI_RESET_FLAGS_
; -----------------------------------------
; сброс флагов UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   DE - адрес структуры настроек (FUISettings_Flags)
; Out:
;   флаг переполнения установлен, фаза завершена
; Corrupt:
;   AF
; Note:
;   флаги сбрасываются в FObjectUI.Layer.Flags операцией AND с инвертированной маской
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.ResetFlags:  LD A, (DE)                                                      ; FUISettings_Flags.Flags
                CPL                                                             ; инвертирование маски сбрасываемых флагов
                AND (IX + FObjectUI.Layer.Flags)
                LD (IX + FObjectUI.Layer.Flags), A

                SCF                                                             ; флаг переполнения установлен, фаза завершена
                JP UI.MarkDirty                                                 ; обновление области объекта после изменения флагов

                endif ; ~_TICK_OBJECT_UI_RESET_FLAGS_
