
                ifndef _TICK_UTILS_TRY_SPAWN_UI_
                define _TICK_UTILS_TRY_SPAWN_UI_
; -----------------------------------------
; проверка необходимости создания UI объекта
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
TrySpawnUI:     ; проверка попадания курсора в bound объекта
                BIT OBJECT_CURSOR_HIT_STATE_BIT, (IX + FObject.Flags)
                RET Z                                                           ; выход, если курсор находится вне bound объекта

                ; получение адреса настроек объекта по умолчанию
                LD A, (IX + FObject.Settings)
                CALL Object.Utilities.GetSettingsAdr.HL

                ; получение типа создаваемого UI объекта
                INC L                                                           ; пропуск FObjectDefaultSettings.Class
                INC L                                                           ; пропуск FObjectDefaultSettings.Flags
                LD A, (HL)                                                      ; FObjectDefaultSettings.Variable_A
                LD (FindUI.SettingsID), A                                       ; сохранение типа создаваемого UI объекта

                ; проверка поведения персонажа при наведении курсора
                INC L                                                           ; пропуск FObjectDefaultSettings.Variable_A
                INC L                                                           ; пропуск FObjectDefaultSettings.Variable_B
                BIT OBJECT_CHARACTER_SPAWN_UI_ON_HOVER_BIT, (HL)                ; FODS_Character.Flags
                RET Z                                                           ; выход, если создание UI объекта не разрешено

                ; получение ID объекта привязки
                CALL Object.Utilities.GetObjectID.IX
                LD (FindUI.AnchorID), A

                ; поиск ранее созданного UI объекта
                PUSH IX                                                         ; сохранение адреса объекта привязки
                LD IX, FindUI                                                   ; установка адреса функции предиката
                CALL Object.FindLastByPredicate
                POP IX                                                          ; восстановление адреса объекта привязки
                RET NC                                                          ; выход, если UI объект уже существует

                ; создание UI объекта в гексагоне объекта привязки
                ; тип настроек UI объекта
                LD A, (FindUI.SettingsID)
                LD B, A

                ; положение объекта привязки в гексагонах
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)

                PUSH IX                                                         ; сохранение адреса объекта привязки
                
                ; чтение ID персонажа
                LD A, (IX + FObjectCharacter.CharacterID)
                PUSH AF                                                         ; сохранение ID персонажа
                CALL Object.Spawn
                POP BC                                                          ; восстановление ID персонажа
                JR C, .Failed                                                   ; переход, если отсутствует свободное место

                ; получение индекса иконки персонажа
                LD A, B                                                         ; ID персонажа
                CALL Character.Utilities.GetAdr.HL
                INC L                                                           ; пропуск FCharacter.Class
                LD L, (HL)                                                      ; FCharacter.RepresentID
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16                                               ; размер структуры FRepresentation
                LD DE, Page0.Characters + FRepresentation.HeroID
                ADD HL, DE
                LD A, (HL)                                                      ; FRepresentation.HeroID
                LD (IY + FObject.Sprite), A                                     ; установка спрайта UI объекта

                ; преобразование смещения по горизонтали в формат 12.4
                LD A, (IX + FODS_UI.Offset.X)
                LD L, A
                ADD A, A    ; << 1
                SBC A, A
                LD H, A                                                         ; знаковое расширение смещения
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16                                               ; пропуск 4 бит сабпикселей, преобразование из пикселей в формат 12.4
                LD (IY + FObject.Position.X), HL

                ; преобразование смещения по вертикали в формат 12.4
                LD A, (IX + FODS_UI.Offset.Y)
                LD L, A
                ADD A, A    ; << 1
                SBC A, A
                LD H, A                                                         ; знаковое расширение смещения
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16                                               ; пропуск 4 бит сабпикселей, преобразование из пикселей в формат 12.4
                LD (IY + FObject.Position.Y), HL

                ; установка объекта привязки UI
                LD A, (FindUI.AnchorID)
                LD (IY + FObjectUI.Anchor), A

.Failed         POP IX                                                          ; восстановление адреса объекта привязки
                RET
; -----------------------------------------
; проверка соответствия UI объекта
; In:
;   IY - адрес проверяемого объекта (FObject)
; Out:
;   флаг переполнения сброшен, если объект соответствует условиям поиска
; Corrupt:
;   AF
; Note:
; -----------------------------------------
FindUI:         ; проверка на соответствие объекта UI
                LD A, (IY + FObject.Class)
                AND OBJECT_CLASS_MASK
                CP OBJECT_CLASS_UI
                JR NZ, .Failed                                                  ; переход, если объект не является UI

                ; проверка на соответствие анкора UI объекта к искомому объекту привязки
                LD A, (IY + FObjectUI.Anchor)
.AnchorID       EQU $+1
                CP #00
                JR NZ, .Failed                                                  ; переход, если UI принадлежит другому объекту

                ; проверка на соответствие типа настроек UI объекта
                LD A, (IY + FObject.Settings)
.SettingsID     EQU $+1
                CP #00
                JR NZ, .Failed                                                  ; переход, если тип UI объекта не соответствует

                OR A                                                            ; сброс флага переполнения, UI объект найден
                RET

.Failed         SCF                                                             ; установка флага переполнения, объект не соответствует
                RET

                endif ; ~_TICK_UTILS_TRY_SPAWN_UI_
