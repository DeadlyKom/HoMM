
                ifndef _TICK_OBJECT_UI_
                define _TICK_OBJECT_UI_
; -----------------------------------------
; обработчик тика объекта "UI"
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI:             ; получение адреса настроек текущего UI объекта
                LD A, (IX + FObject.Settings)                                   ; настройки объекта по умолчанию
                CALL Object.Utilities.GetSettingsAdr.HL

                ; переход к полю поведения внутри FODS_UI
                LD A, L
                ADD A, FODS_UI.Behavior
                LD L, A
                LD A, (HL)                                                      ; FODS_UI.Behavior

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_UI_BEHAVIOR_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого поведения UI
                endif

                ; выбор обработчика поведения UI объекта
                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW UI.Default                                                   ; OBJECT_UI_BEHAVIOR_DEFAULT

                endif ; ~_TICK_OBJECT_UI_
