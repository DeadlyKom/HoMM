
                ifndef _MODULE_CORE_INITIALIZE_CORE_
                define _MODULE_CORE_INITIALIZE_CORE_
; -----------------------------------------
; инициализация "ядра"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Core:           EI
                BORDER BLACK                                                    ; установка бордюра

                ; -----------------------------------------
                ; первичная очистка экранов
                ; -----------------------------------------
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CLS SCR_ADR_SHADOW, 0xFF                                        ; очистка теневого экрана
                ATTR_IPB SCR_ADR_SHADOW, BLACK, WHITE, 0                        ; очистка атрибутов теневого экрана

                ; -----------------------------------------
                ; отображение версии сборки
                ; -----------------------------------------
                CALL Console.SetDrawToOne
                CALL Convert.SetBaseScreen                                      ; установка работы с основным экраном
                SET_REG_ATTR_IPB A, CYAN, BLACK, 0
                CALL Console.SetAttribute
                LD BC, VersionText
                CALL Console.StringLength
                LD A, #20 - 1
                SUB E
                LD E, A
                LD D, #16
                CALL Console.SetCursor
                CALL Console.DrawString
                ; -----------------------------------------
                ; принудительная установка места загрузки ресурса
                ; -----------------------------------------
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_TR_DOS_FLAG ENABLE_IM2_BIT                                  ; включить прерывание IM2 по завершению работы с ПЗУ TR-DOS

                ; -----------------------------------------
                ; очистка 
                ; -----------------------------------------
                MEMSET_BYTE Adr.GameState, 0, Size.GameState                    ; очистка состояний игры
                MEMSET_BYTE Adr.GameSession, 0, Size.GameSession                ; очистка сессии игры

                ; -----------------------------------------
                ; установка дефолтной конфигурации
                ; -----------------------------------------
                LD HL, .DefaultConfig
                LD DE, Adr.GameConfig
                LD BC, Size.GameConfig
                CALL Memcpy.FastLDIR

                ; -----------------------------------------
                ; установка дефолтной сейв слота
                ; -----------------------------------------
                LD A, SAVE_SLOT_0
                LD (GameSession.SaveSlotID), A

                LD HL, .DefaultSlot
                LD DE, GameSession.SaveSlot
                LD BC, FSaveSlot
                CALL Memcpy.FastLDIR

                ; -----------------------------------------
                ; инициализация
                ; -----------------------------------------
                CALL Input                                                      ; инициализация управления
                ; CALL Core.Tables.TG_PRNG                                        ; пока отключена - генерация таблицы PRNG
                CALL Core.Tables.TG_ScrAdr                                      ; генерация адресов экрана
                CALL Core.Tables.TG_ShiftTable                                  ; генерация таблицы сдвигов
                CALL Core.Tables.TG_ByteMirror                                  ; генерация таблицы зеркальных байт
                CALL Core.Tables.TG_MulSprTable                                 ; генерация таблицы умножения для спрайтов
                CALL Convert.SetShadowScreen                                    ; установка работы с теневым экраном
                
                ; инициализация работы с объектами
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL Object.Initialize

                DELAY 1
                ; -----------------------------------------
                ; конечная очистка экрана
                ; -----------------------------------------
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана
                RET

.DefaultConfig  FGameConfig {
                    VK_ENTER,                                                   ; клавиша по умолчанию "меню/пауза"
                    VK_CAPS_SHIFT,                                              ; клавиша по умолчанию "ускорить"
                    VK_EDIT,                                                    ; клавиша по умолчанию "выход"
                    VK_SPACE,                                                   ; клавиша по умолчанию "выбор"
                    VK_D,                                                       ; клавиша по умолчанию "вправо"
                    VK_A,                                                       ; клавиша по умолчанию "влево"
                    VK_S,                                                       ; клавиша по умолчанию "вниз"
                    VK_W,                                                       ; клавиша по умолчанию "вверх"
                    INPUT_KEYBOARD,                                             ; флаги игровых настроек
                    CURSOR_MIN_SPEED,                                           ; минимальная скорость курсора
                    CURSOR_MAX_SPEED,                                           ; максимальная скорость курсора
                    1                                                           ; скорость скролла тайловой карты
                }

.DefaultSlot    FSaveSlot {
                    {"Default Slot\0"},                                         ; имя слота сохранения
                    ASSETS_ID_MAP_DEBUG                                         ; идентификатор карты
                }

                endif ; ~_MODULE_CORE_INITIALIZE_CORE_
