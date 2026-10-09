
                ifndef _MODULE_WORLD_RESTORE_STATE_
                define _MODULE_WORLD_RESTORE_STATE_
; -----------------------------------------
; восстановление состояния модуля мира
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
RestoreState:   RES_USER_HANDLER                                                ; отключение обработчика перед заменой общего кода
                HALT                                                            ; синхронизация
                ATTR_IPB SCR_ADR_BASE, BLACK, BLACK, 0                          ; скрытие атрибутами основного экрана

                ; восстановление общей памяти из образа мира
                MEMCPY World.Adr.Deploy.World, Adr.World, \
                            World.Size.Deploy.World

                ; восстановление страничной памяти из образа мира
                MEMCPY_PAGE World.Adr.Deploy.SharedScreen, Adr.SharedScreen, \
                            Page.SharedScreen, World.Size.Deploy.SharedScreen

                ; инициализация состояния курсора с сохранёнными идентификаторами спрайтов
                CALL_IN_PAGE Page.SharedScreen, UI_Cursor.Initialize

                CALL Launch.GameplayWindow                                      ; отображение игрового окна
                CALL Launch.Initialize                                          ; инициализация "мира"

                ; освобождение покинутых модулей после переключения на мир
                RELEASE_ASSETS_IN_PAGE ASSETS_ID_CHARACTERISTICS                ; освобождение модуля "характеристик"
                JP_RELEASE_ASSETS_IN_PAGE ASSETS_ID_INVENTORY                   ; освобождение модуля "инвентаря"

                endif ; ~_MODULE_WORLD_RESTORE_STATE_
