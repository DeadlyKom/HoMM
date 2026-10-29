                ifndef _MODULE_SESSION_MAP_POST_LOAD_EQUIPMENT_
                define _MODULE_SESSION_MAP_POST_LOAD_EQUIPMENT_
; -----------------------------------------
; назначение начальной экипировки персонажам
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
;
;   ⚠️ ВАЖНО ⚠️
;   меняет страницу памяти
; -----------------------------------------
Equipment:      ; проверка наличия предметов в общем массиве
                LD A, (GameState.ItemsNum)
                OR A
                RET Z                                                           ; выход, если массив предметов пуст
                LD B, A

.ItemLoop       ; сохранение счётчика обхода предметов
                PUSH BC

                ; расчёт идентификатора очередного предмета
                LD A, B
                DEC A
                LD D, A                                                         ; сохранение идентификатора предмета

                ; получение размещения предмета
                CALL Item.Utilities.GetLocAdr.HL
                SET_PAGE_A                                                      ; включение страницы массива предметов

                ; проверка назначения предмета в экипировку
                BIT ITEM_LOCATION_EQUIPPED_BIT, (HL)
                JR Z, .Next                                                     ; переход, если предмет не экипирован

                ; чтение владельца и слота экипировки
                INC HL                                                          ; FItemLocation.Container
                LD A, (HL)                                                      ; индекс персонажа
                INC HL                                                          ; FItemLocation.Position.X
                LD E, (HL)                                                      ; индекс слота в FCharacterEquipment

                ; сохранение адреса позиции для сброса после назначения
                PUSH HL

                ; получение адреса персонажа
                PUSH AF                                                         ; сохранение индекса персонажа
                SET_PAGE_OBJECT                                                 ; включение страницы работы с персонажами
                POP AF
                CALL Character.Utilities.GetAdr.HL

                ; расчёт адреса идентификатора предмета в экипировке
                LD A, E
                ADD A, FCharacter.Equipment
                ADD A, L
                LD L, A

                ; назначение экземпляра предмета в указанный слот
                LD (HL), D

                ; восстановление адреса позиции на странице предметов
                POP HL
                LD A, (GameState.Inventory.Page)
                SET_PAGE_A                                                      ; включение страницы массива предметов

                ; сброс позиции экипированного предмета
                LD (HL), #FF                                                    ; FItemLocation.Position.X
                INC HL                                                          ; FItemLocation.Position.Y
                LD (HL), #FF

.Next           ; восстановление счётчика обхода предметов
                POP BC
                DJNZ .ItemLoop
                RET

                endif ; ~_MODULE_SESSION_MAP_POST_LOAD_EQUIPMENT_
