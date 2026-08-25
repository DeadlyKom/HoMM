
                ifndef _TICK_OBJECT_UI_UPDATE_HOVER_
                define _TICK_OBJECT_UI_UPDATE_HOVER_
; -----------------------------------------
; обновление hover-поведения UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   IY - адрес объекта привязки (FObject)
; Out:
;   флаг переполнения установлен, если hover-поведение активно
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.UpdateHover: ; получение настроек UI объекта
                LD A, (IX + FObject.Settings)
                CALL Object.Utilities.GetSettingsAdr.HL

                ; переход к FODS_UI.Flags
                LD A, L
                ADD A, FODS_UI.Flags
                LD L, A
                ; OR A                                                            ; сброс флага переполнения, hover-поведение не активно

                ; проверка поддержки hover-поведения
                BIT OBJECT_UI_HOVER_BIT, (HL)                                   ; FODS_UI.Flags
                RET Z                                                           ; выход, если hover-поведение не поддерживается

                ; проверка попадания курсора в bound объекта привязки
                BIT OBJECT_CURSOR_HIT_STATE_BIT, (IY + FObject.FastFlags)
                RET Z                                                           ; выход, если курсор покинул объект привязки

                ; обновление времени жизни hover UI
                DEC L                                                           ; переход к FObjectDefaultSettings.Variable_B
                DEC L                                                           ; переход к FObjectDefaultSettings.Variable_A
                LD A, (HL)
                LD (IX + FObjectUI.Lifetime), A
                SCF                                                             ; установка флага переполнения, hover-поведение активно
                RET

                endif ; ~_TICK_OBJECT_UI_UPDATE_HOVER_
