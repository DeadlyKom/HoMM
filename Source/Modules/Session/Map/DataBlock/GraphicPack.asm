
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_GRAPHIC_PACK_
                define _MODULE_SESSION_MAP_DATA_BLOCK_GRAPHIC_PACK_
; -----------------------------------------
; обработка блока GraphicPack
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GraphicPack:    EX DE, HL                                                       ; меняем местами

                ; загрузка базовых графических пакетов                          ; (0)
                CALL Session.SharedCode.Load.BaseGraphics
                PUSH AF                                                         ; сохранить количество загруженных спрайтов

                ; загрузка графических пакетов карты                            ; (1)
                LD D, HIGH Adr.TilemapBuffer
                CALL Session.SharedCode.Load.GraphicsPackages                   ; загрузка графических пакетов

                ; -----------------------------------------
                ; проверка переполнения буфера спрайтов (Adr.SpriteInfoBuffer) новых гексагонных тайлов
                POP BC                                                          ; восстановить количество загруженных спрайтов
                EX AF, AF'
                ADD A, B                                                        ; общее количество загруженных спрайтов

                ; деление на 4 с округлением в большую сторону
                ; OR A
                RRA         ; >> 1
                ADC A, #00  ; округлением в большую сторону
                RRA         ; >> 2
                ADC A, #00  ; округлением в большую сторону
                LD B, A

                ; проверка размещения спрайтов в буфере спрайтов
                LD A, (GameState.SpriteInfoNum)
                ADD A, B
                CP SPRITE_BUF_MAX
                ; ToDo: в будущем предоставить пользователю сообщение об ошибке
                DEBUG_BREAK_POINT_NC                                            ; ошибка, если массив переполнен
                LD (GameState.SpriteInfoNum), A

                ; инициализация стартового индекса отрисовки гексагональных тайлов в буфере спрайтов (Adr.SpriteInfoBuffer)
                SUB B
                ; базовые графические пакеты находятся HEX.StartRenderIdx-8 всегда
                INC A                                                           ; пропуск системных спрайтов гексагонов (4 шт)
                INC A                                                           ; пропуск системных спрайтов гексагонов (+4 шт)
                ADD A, A    ; x2
                LD (HEX.StartRenderIdx), A                                      ; стартовый индекс отрисовки гексагональных тайлов в буфере спрайтов (Adr.SpriteInfoBuffer) x2
                ; -----------------------------------------
                CALL Session.SharedCode.Initialize.BaseGraphics                 ; инициализация базовые графические пакеты

                LD D, HIGH Adr.TilemapBuffer
                LD A, (HEX.StartRenderIdx)
                CALL Session.SharedCode.Initialize.GraphicsPackages             ; инициализация графических пакетов
                RET

                display " - Parsing FMapDataBlockInfo for GraphicPack:\t\t", /A, GraphicPack, "\t= busy [ ", /D, $-GraphicPack, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_GRAPHIC_PACK_
