
                ifndef _MODULE_PROGRESS_INITIALIZE_
                define _MODULE_PROGRESS_INITIALIZE_
; -----------------------------------------
; первичная инициализация
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     BORDER BLACK                                                    ; установка бордюра

                ; -----------------------------------------
                ; очистка экранов
                ; -----------------------------------------
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана
                CLS_SCR_SHADOW_IN_PAGE 0xFF, BLACK, WHITE, 0                    ; очистка теневого экрана (находясь в странице)

                ; загрузка ассета, с копированием блока ассета в буфер (находясь в странице)
                LOAD_ASSET_BLOCK_IN_PAGE \
                    ASSETS_ID_PROGRESS_STAGES, \
                    0, \
                    Adr.TilemapBuffer, \
                    UI.Graphics.Progress.Stages.HeaderSize

                ; -----------------------------------------
                ; Out:
                ;   HL - адрес блока в ассете
                ;   DE - адрес буфера
                ; -----------------------------------------

                ; проверка наличия требуемой стадии
                EX DE, HL                                                       ; адрес копированого блока
                LD B, (HL)                                                      ; первый байт указывает на количество доступных стадий
                POP AF                                                          ; чтение идентификатора картинки
                CP B
                JR C, $+3                                                       ; переход, если имеется требуемый идентификатор
                XOR A                                                           ; сброс идентификатора картинки, 
                                                                                ; нулевой идентификатор всегда общий
                ; рассчёт адреса смещения до требуемого изображения
                ADD A, A    ; x2
                LD L, A                                                         ; начальный адрес загрузки ассета всегда выровнен
                INC L                                                           ; пропуск количество стадий в ассете

                ; чтение смещения и расчёт адреса требуемого изображения
                LD C, (HL)
                INC L
                LD B, (HL)

                ; расчёт смещения
                EX DE, HL                                                       ; адрес блока в ассете
                ADD HL, BC
                LD (Draw.NotBoundSpriteAdr), HL                                 ; сохранение адреса спрайта

                ; отображение стадий прогресса
                LD HL, Draw.SpriteNotBoundSet
                LD A, (GameState.Assets + FAssets.Address.Page)                 ; чтение страницы расположения графики
                CALL Func.CallAnotherPage

                RELEASE_ASSETS_IN_PAGE ASSETS_ID_PROGRESS_STAGES                ; освобождение ассета (находясь в странице)
                RET

                endif ; ~_MODULE_PROGRESS_INITIALIZE_
