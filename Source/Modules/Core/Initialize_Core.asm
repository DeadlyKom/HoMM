
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
                CLS SCR_ADR_BASE, 0x00                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, WHITE, BLACK, 0                          ; очистка атрибутов основного экрана
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CLS SCR_ADR_SHADOW, 0x00                                        ; очистка теневого экрана
                ATTR_IPB SCR_ADR_SHADOW, WHITE, BLACK, 0                        ; очистка атрибутов теневого экрана

                ; -----------------------------------------
                ; отображение версию сборки
                ; -----------------------------------------
                SCREEN_ADR_REG HL, MemBank_01_SCR, 20 << 3, 23 << 3
                CALL Console.SetScreenAdr
                SET_REG_ATTR_IPB A, CYAN, BLACK, 0
                CALL Console.SetAttribute
                LD BC, VersionText
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
                ; инициализация
                ; -----------------------------------------
                CALL Input                                                      ; инициализация управления
                CALL Core.Tables.TG_PRNG                                        ; генерация таблицы PRNG
                CALL Core.Tables.TG_ScrAdr                                      ; генерация адресов экрана
                CALL Core.Tables.TG_ShiftTable                                  ; генерация таблицы сдвигов
                CALL Core.Tables.TG_ByteMirror                                  ; генерация таблицы зеркальных байт
                CALL Core.Tables.TG_MulSprTable                                 ; генерация таблицы умножения для спрайтов
                CALL Convert.SetShadowScreen

                DELAY 1
                ; -----------------------------------------
                ; конечная очистка экрана
                ; -----------------------------------------
                CLS SCR_ADR_BASE, 0x00                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, WHITE, BLACK, 0                          ; очистка атрибутов основного экрана
                RET

.DefaultConfig  FGameConfig {
                VK_ENTER,                                                       ; клавиша по умолчанию "меню/пауза"
                VK_CAPS_SHIFT,                                                  ; клавиша по умолчанию "ускорить"
                VK_EDIT,                                                        ; клавиша по умолчанию "выход"
                VK_SPACE,                                                       ; клавиша по умолчанию "выбор"
                VK_D,                                                           ; клавиша по умолчанию "вправо"
                VK_A,                                                           ; клавиша по умолчанию "влево"
                VK_S,                                                           ; клавиша по умолчанию "вниз"
                VK_W,                                                           ; клавиша по умолчанию "вверх"
                INPUT_KEYBOARD,                                                 ; флаги игровых настроек
                0,                                                              ; флаги ограничения железа
                1,                                                              ; скорость скролла тайловой карты
                0,                                                              ; левая грань видимой части     (в пикселах)
                SCREEN_CURSOR_X >> 3,                                           ; ширина видимой части          (в знакоместах)
                0,                                                              ; верхняя грань видимой части   (в пикселах)
                SCREEN_CURSOR_Y                                                 ; высота видимой части          (в пикселах)
                }

                endif ; ~_MODULE_CORE_INITIALIZE_CORE_
