
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_PLAY_
                define _VFX_CROSSFADE_FALLING_BLOCKS_PLAY_
; -----------------------------------------
; каркас проигрывания перехода между экранами
; In:
;   HL - адрес функции расчёта расстояния
;   BC - центр в пикселях, B = y [0..191], C = x [0..255]
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   перед вызовом код эффекта должен быть перенесён методом Deploy
;   данные эффекта подготавливаются методом Initialize перед первым кадром
;   вызов выполняется вне обработчика прерываний, прерывания разрешены
; -----------------------------------------
Play:           ; подготовка данных эффекта перед проигрыванием
                CALL Initialize

                ; сброс позиции выборки и количества падающих блоков
                XOR A
                LD (.Position), A
                LD (.FallingCount), A

.Frame          ; сохранение номера прерывания в начале кадра
                LD HL, (TickCounterRef)
                LD (.FrameStart), HL

.AddBlock       ; проверка свободного места для нового падающего блока
.FallingCount   EQU $+1
                LD A, #00
                CP Const.MaxFalling
                JP NC, .Restore                                                 ; переход, если достигнут предел одновременно падающих блоков
                LD B, A

                ; проверка наличия следующего номера в массиве Order
.Position       EQU $+1
                LD A, #00
                CP Const.BlocksCount
                JP NC, .Restore                                                 ; переход, если все номера блоков уже выданы

                ; расчёт адреса очередного номера в массиве Order
                LD H, HIGH Const.OrderAdr
                LD L, A
                LD C, (HL)                                                      ; номер исходного блока

                ; расчёт адреса новой записи, по четыре байта на падающий блок
                LD A, B
                ADD A, A    ; x2
                ADD A, A    ; x4
                OR LOW Const.FallingAdr
                LD L, A
                LD H, HIGH Const.FallingAdr

                ; добавление номера блока и начального шага падения
                LD (HL), C                                                      ; FFallingBlock.Index
                INC L
                LD (HL), #00                                                    ; FFallingBlock.Step
                INC L

                ; сохранение указателя поля адреса графики
                PUSH HL

                ; расчёт адреса графики при добавлении исходного блока
                LD L, C
                LD H, #00
                ADD HL, HL                                                      ; x2
                ADD HL, HL                                                      ; x4
                LD D, H
                LD E, L
                ADD HL, HL                                                      ; x8
                ADD HL, HL                                                      ; x16
                ADD HL, HL                                                      ; x32
                ADD HL, DE                                                      ; x36
                LD DE, Const.BufferAdr
                ADD HL, DE

                ; запись полного адреса графики в состояние падающего блока
                EX DE, HL
                POP HL
                LD (HL), E                                                      ; FFallingBlock.Source, младший байт
                INC L
                LD (HL), D                                                      ; FFallingBlock.Source, старший байт

                ; расчёт адреса байта трафарета по номеру исходного блока
                LD A, C
                RRCA
                RRCA
                RRCA
                AND #1F
                OR LOW Const.StencilAdr
                LD L, A
                LD H, HIGH Const.StencilAdr

                ; преобразование номера бита в код инструкции сброса
                LD A, C
                AND #07
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                OR #86                                                          ; RES n, (HL)
                LD (.BIT), A

                ; снятие признака неподвижного блока
.BIT            EQU $+1
                DB #CB, #00

                ; увеличение количества падающих после добавления записи
                LD A, B
                INC A
                LD (.FallingCount), A

                ; переход к следующему элементу массива Order
                LD HL, .Position
                INC (HL)
                JP .AddBlock

.Restore        ; восстановление старых участков перед перемещением блоков
                CALL Restore

.Move           ; обновление положения и удаление ушедших за экран блоков
                CALL Move

.Draw           ; рисование новых положений оставшихся падающих блоков
                CALL Draw

.Finish         ; проверка завершения выборки всех исходных блоков
                LD A, (.Position)
                CP Const.BlocksCount
                JP C, .WaitFrame                                                ; переход, если остались невыданные номера блоков

                ; проверка завершения падения всех выданных блоков
                LD A, (.FallingCount)
                OR A
                RET Z                                                           ; выход, если все номера выданы и падающих блоков не осталось

.WaitFrame      ; расчёт числа прерываний, прошедших с начала кадра
                LD HL, (TickCounterRef)
.FrameStart     EQU $+1
                LD DE, #0000
                OR A
                SBC HL, DE

                ; проверка окончания заданного интервала кадра
                LD A, L
                CP Const.FrameTicks
                JP C, .WaitFrame                                                ; переход, если заданный интервал кадра ещё не закончился

                ; начало следующего кадра эффекта
                JP .Frame

.FallTable      ; смещения падения по счётчику блока, в пикселях
                lua allpass
                local distance = 192                                            -- расстояние падения, в пикселях
                local acceleration = 0.24                                       -- ускорение падения, в пикселях за шаг в квадрате
                local speed = 1.0                                               -- множитель скорости падения

                -- расчёт времени падения из расстояния и ускорения
                local last_step = math.ceil(math.sqrt(2 * distance / acceleration) / speed)

                -- проверка вместимости индекса таблицы в байтовый счётчик
                if last_step > 255 then
                    error("таблица падения не помещается в байтовый счётчик шага")
                end

                -- формирование смещений, кратных высоте знакоместа
                for step = 0, last_step - 1 do
                    local time = step * speed
                    local offset = 8 * math.floor((acceleration / 2) * time * time / 8)
                    _pc("DB " .. offset)
                end

                -- завершение таблицы смещением на полную высоту экрана
                _pc("DB " .. distance)
                endlua

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_PLAY_
