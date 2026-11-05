
                ifndef _WORLD_RENDER_PIPELINE_HEXAGONS_
                define _WORLD_RENDER_PIPELINE_HEXAGONS_
; -----------------------------------------
; конвейера отображения гексагонов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
PipelineHexagons:
                SET_RENDER_TO_BASE_SCREEN                                       ; установка работы с основным экраном
                CALL SetViewBound                                               ; установить границы мира для просмотра
                ; -----------------------------------------
                ; ⚠️ холодный запуск:
                ;    1. принудительно выставить адрес левого верхнего угла отображаемой карты
                ;       данные о центрировании карты могут браться из метаданных карты и/или иным способом
                ;    2. принудительное копирование в Tilemap-буфер из тайловой карты на странице 1
                ;    3. принудительное выставление флагов в Render-буфере
                ;       формируется для каждого тайла
                ;
                ; ⚠️ горячий запуск:
                ;    не должен самовозбуждать флаги обновления в Render-буфере,
                ;    дабы снизить нагрузку на обновление экрана
                ;
                ; ℹ️ цикл обновления экрана:
                ;    1. в выставленные тайминги скролла проверить вектор движения карты,
                ;       обновить адрес левого верхнего угла отображаемой карты
                ;    2. принудительное обновление Tilemap- и Render-буферов по необходимости,
                ;       если адрес левого верхнего угла отображения карты изменился
                ;       * Tilemap-буфер копируется из тайловой карты на странице 1
                ;       * Render-буфер формируется для каждого тайла, где:
                ;         - выставляется флаг HU (принудительного обновления гексагона)
                ;         - копируется флаг FG (тумана, 0 — гексагон закрашен туманом целиком)
                ;           из буфера метаданных карты
                ;         - номер анимации гексагона устанавливается в ноль,
                ;           в последующих шагах он будет модифицирован
                ;       * Render-буфер для каждого столбца гексагона выставляется флаг CU
                ;           необходимости обновить столбец гексагона (0 - обновление столбца не требуется)
                ;    3. применение внешних событий изменения/обновления гексагонов
                ;       * основной список гексагон-объектов,
                ;         которые обязаны менять анимацию каждый тик гексагонов
                ;         каждый такой объект имеет информацию о количестве анимаций в цикле
                ;       * дополнительный список гексагон-объектов,
                ;         которые рандомно выбираются из доступных на экране
                ;         каждый такой объект после проигрывания одного цикла анимации
                ;         удаляется из списка
                ;    4. отображение гексагонов
                ;    5. отображение объектов на карте
                ;       * список динамических объектов влияет на флаг HU (принудительного обновления гексагона)
                ;         спрайты героя, VFX заклинаний и т.п.
                ;    6. отображение тумана на видимых гексагонах
                ;    7. копирование узора рамки на игровой части экрана
                ;    8. анализ флагов HU (принудительного обновления гексагона) и высот гексагонов,
                ;       позволяет определить, какие экранные блоки требуется копировать в теневой экран
                ;       * выставленный флаг HU говорит о том, что гексагон изменился
                ;         используя высоты гексагона, можно определить,
                ;         какие соседние экранные блоки были задеты,
                ;         и на их основе формируются флаги обновления грязных экранных блоков
                ;       * экранные блоки копируются в теневой экран
                ;
                ; ℹ️ цикл обновления курсора:
                ;    1. если не требуется копирование из основного экрана в теневой:
                ;       ⚠️ важно: обязательно в начале прерывания (избежать сечения луча)
                ;       * восстанавливаем фон под курсором (в теневом экране), если он имеется
                ;       * отображаем курсор в новой позиции (в теневом экране)
                ;       ℹ️ ToDo: можно избежать этого пункта,
                ;           если предыдущая анимация и положение не изменились
                ;       * любая логика прерывания
                ;    2. буферный экран (основной) готов копироваться в теневой экран
                ;       * включить в адресном пространстве #C000–#FFFF страницу 7
                ;         (с теневым экраном)
                ;       * отображаем курсор в новой позиции (в основном экране)
                ;       * переключаемся на отображение основного экрана
                ;         (теневой экран перестаёт быть видимым)
                ;       * на странице 7 расположен код копирования экранных блоков,
                ;         буфер под курсор и другие необходимые массивы
                ;         (гексагон-объектов и т.п.)
                ;         копируются блоки экрана в теневой
                ;         (ℹ️ сечение луча не страшен)
                ;       * отображаем курсор в новой позиции (в теневом экране)
                ;       * переключаемся на отображение теневого экрана
                ;         (основной экран перестаёт быть видимым)
                ;       * восстановить фон в основном экране под курсором
                ;       * сброс флагов готовности экрана
                ; -----------------------------------------
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL World.SharedCode.Render.Object.InView                      ; формирование списка объектов в области видимости
                PUSH AF
                CALL NZ, World.SharedCode.Render.Object.DirtyEnvir              ; анализ видимых объектов и выставление флагов гексагонов, которые требуется перерисовать

                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CALL BufferUtilities.AdjRenderBufCol                            ; корректировка столбцов рендер буфера

                ; подготовка снега по однократно рассчитанной маске обновляемых блоков
                SET_PAGE_SCREEN_SHADOW
                CALL World.SharedScreen.Effects.Weather.Prepare
                SET_PAGE_MAP
                RESTORE_BC                                                      ; защитная от порчи данных с разрешённым прерыванием
                CALL Draw.HexByDL
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL ScreenBlock.HexAnalysis                                    ; анализ обновления гексагонов

                POP AF
                CALL NZ, Object.Draw                                            ; отображение объектов в массиве SortBuffer

                ; -----------------------------------------
                SET_MODULE_PAGE_World                                           ; включить страницу модуля "World"

                ; проверка завершения режима остановки времени
                CHECK_TICK_CONTROL_FLAG GAME_SUSPEND_BIT
                CALL Z, World.Display.GameplaySuspend.Resume                    ; вызов, если остановка времени выключена

                CALL World.Display.GameplayFrame.Ornament

                ; проверка режима "остановки времени"
                CHECK_TICK_CONTROL_FLAG GAME_SUSPEND_BIT
                CALL NZ, World.Display.GameplaySuspend                          ; вызов, если режим "остановки времени" включён

                ; проверка запроса обновления фазы суток
                CHECK_WORLD_CHRONO_FLAG WORLD_DAY_PHASE_UPDATE_BIT
                CALL NZ, World.Display.DiamondChrono.Display                    ; вызов, если запрошено обновление фазы суток
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                 
                ; установка флага готовности кадра и долгого переключения экранов
                RENDER_FLAGS
                SET_FLAG FRAME_READY_BIT
                SET_FLAG SWAP_PENDING_BIT
                RES_VIEW_FLAG FORCED_FRAME_UPDATE_BIT                           ; сброс флага принудительного обновления кадра
                RET

.Swap           SET_RENDER_FLAG SWAPPED_PENDING_BIT                             ; установить флаг успеного переключения экрана, ожидаем окончание прерывания
                JP_SHOW_BASE_SCREEN                                             ; отображение базового экрана

.MemcpyScreen   ; ToDo: см Interrupt.Memcpy описание ошибки
                ; RESTORE_SCR World.SharedCode.Interrupt.Memcpy
                
                ; ToDo: мб такая ситуация, когда за время копирование, данные в буфере фона курсора устарели
                ;       придётся их копировать в другой и восстанавливать из него
                
                SET_FLAG_MODIFY CursorMemcpyGate.Flag                           ; блокировка работы с буфером курсора

                ; стирание прежнего режима осадков до применения переключения погоды
                CALL World.SharedScreen.Effects.Weather.Erase

                ; стирание прежнего разряда до обновления пикселей мира
                if WEATHER_STORM_ON
                CALL World.SharedScreen.Effects.Bolt.Erase
                endif

                ; копирование блоков, если курсор находится в игровой зоне, он скопируется тоже
                CALL ScreenBlock.Memcpy                                         ; копирование screen block'и в теневой экран

                ifdef _DEBUG
                ; перенос шести знакомест отладочной подписи вместе с атрибутами
                LD HL, SCR_ADR_BASE + 24
                LD IXL, #01
                CALL World.SharedScreen.ScreenRefresh.Memcpy.Screen_6
                endif

                ; проверка необходимости переноса обновлённого ромба
.DiamondFlag    FLAG_MODIFY 0                                                   ; флаг переноса ромба в теневой экран
                CALL C, .CopyDiamond                                            ; вызов, если ромб обновлён на основном экране

                ; проверка необходимости переноса индикатора или восстановленной рамки
.SuspendFlag    FLAG_MODIFY 0                                                   ; флаг, запрос переноса области индикатора паузы
                CALL C, .CopySuspend                                            ; вызов, если область индикатора обновлена на основном экране

                ; принудительно меняем адрес на теневой буфер,
                ; затераем возможное копирование курсора
                LD HL, (Kernel.Sprite.Restore.BufferAdr)
                LD A, (HL)
                OR A
                JR Z, .SkipCurRestore                                           ; переход, если адрес буфера неуказан (затёрт)
                INC L
                LD E, (HL)
                INC L
                LD D, (HL)
                SET 7, D
                CALL Draw.RestoreByScrAdr                                       ; восстановление фона под курсором в указанном адресе экрана (только для OR_XOR_SAVE)

                ; ToDo: см Interrupt.Memcpy описание ошибки
                ; RESTORE_SCR_

.SkipCurRestore ; обновление атрибутной вспышки после переноса игрового кадра
                if WEATHER_STORM_ON
                CALL World.SharedScreen.Effects.Lightning.Tick
                endif

                ; обновление выбранного режима осадков непосредственно на теневом экране
                CALL World.SharedScreen.Effects.Weather.Tick

                ; подготовка обработки UI после копирования экранных блоков
                SET_MODULE_PAGE_World                                           ; включить страницу модуля "World"

                ; проверка запроса паузы игры
                CHECK_TICK_REQUEST_FLAG GAME_PAUSE_REQUEST_BIT
                JR Z, .PreviousMode                                             ; переход, если запроc "паузы игры" сброшен

                ; проверка текущего состояния "паузы игры"
                CHECK_TICK_CONTROL_FLAG GAME_PAUSE_BIT
                CALL Z, World.UI.Initialize.Layer_GamePause                     ; вызов, если "пауза игры" выключена
                                                                                ; запустить режим "паузы игры"
                JR .ProcessUI

.PreviousMode   ; проверка текущего состояния "паузы игры"
                CHECK_TICK_CONTROL_FLAG GAME_PAUSE_BIT
                CALL NZ, World.UI.Initialize.PreviousMode                       ; вызов, если "пауза игры" включена
                                                                                ; вернуть предыдущий режим
.ProcessUI      ; проверка возможности начать обработку запроса смены UI режима
                CALL UI.Runtime.Process
                JP C, .StartUI                                                  ; переход, если начат переход UI режима

                ; разрешение работы с курсором перед показом теневого экрана
                RES_FLAG_MODIFY CursorMemcpyGate.Flag                           ; разрешение работы с буфером курсора

                ; завершение переноса кадра при разрешённой работе с курсором
                RES_RENDER_FLAGS SWAPPED_PENDING | SWAP_PENDING                 ; сброс флагов ожидания переключения экранов
                RET

.StartUI        ; передача управления переходу UI при заблокированном курсоре
                RES_RENDER_FLAGS SWAPPED_PENDING | SWAP_PENDING                 ; сброс флагов ожидания переключения экранов
                JP UI.Runtime.StartTransition
; -----------------------------------------
; снятие одной снежинки с обновлением фона без скрытия курсора
; In:
;   IX - запись FSnowFlake
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   включена страница 7, IX и IY сохраняются, прерывания разрешены
; -----------------------------------------
.RemoveSnow     PUSH IX
                PUSH IY

                ; сохранение прежнего затвора на время обращения к фону курсора
                CALL CursorMemcpyGate
                PUSH AF
                SET_FLAG_MODIFY CursorMemcpyGate.Flag                           ; блокировка работы с буфером курсора
                CALL .SnowCurrentHit
                CALL .SnowSelectPlot
                CALL World.SharedScreen.Effects.Snow.Shape
                JP .SnowRelease
; -----------------------------------------
; замена одной снежинки с обновлением фона курсора в старой и новой позициях
; In:
;   DE - прежняя позиция, D по Y, E по X, используется при установленном бите 7 Shown
;   IX - запись FSnowFlake с новой позицией
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   включена страница 7, IX и IY сохраняются, прежний затвор восстанавливается
; -----------------------------------------
.ReplaceSnow    PUSH IX
                PUSH IY
                CALL CursorMemcpyGate
                PUSH AF
                SET_FLAG_MODIFY CursorMemcpyGate.Flag                           ; блокировка работы с буфером курсора
                PUSH DE

                ; проверка наличия прежней формы перед проверкой её пересечения
                BIT 7, (IX + FSnowFlake.Shown)
                JR Z, .SnowNewHit                                               ; переход, если снежинка ещё не нарисована

                ; проверка пересечения прежней позиции с сохранённым фоном курсора
                PUSH DE
                POP IY
                CALL .SnowCursorHit
                JR C, .SnowReplaceDo                                            ; переход, если прежняя форма уже требует записи в фон курсора

.SnowNewHit     CALL .SnowCurrentHit
.SnowReplaceDo  CALL .SnowSelectPlot
                POP DE

                ; снятие прежней формы сразу перед рисованием новой
                BIT 7, (IX + FSnowFlake.Shown)
                CALL NZ, World.SharedScreen.Effects.Snow.ShapeAt                 ; вызов, если прежняя форма была нарисована
                CALL World.SharedScreen.Effects.Snow.Shape
                SET 7, (IX + FSnowFlake.Shown)
.SnowRelease    ; возврат обычного вывода перед восстановлением прежнего затвора
                LD HL, World.SharedScreen.Effects.Rain.Pixel.Both
                LD (World.SharedScreen.Effects.Rain.Pixel.Output), HL
                POP AF
                JR C, .SnowKeepGate                                              ; переход, если затвор уже был закрыт до изменения снежинки

                RES_FLAG_MODIFY CursorMemcpyGate.Flag                           ; разрешение работы с буфером курсора
.SnowKeepGate   POP IY
                POP IX
                RET
; -----------------------------------------
; выбор записи в экран или сохранённый фон для текущей формы
; In:
;   C - флаг, форма пересекает фон курсора
; Out:
; Corrupt:
;   HL
; -----------------------------------------
.SnowSelectPlot LD HL, World.SharedScreen.Effects.Rain.Pixel.Both
                JR NC, .SnowSetPlot                                              ; переход, если сохранённый фон курсора не затрагивается

                LD HL, .SnowPixel
.SnowSetPlot    LD (World.SharedScreen.Effects.Rain.Pixel.Output), HL
                RET
; -----------------------------------------
; пересечение новой позиции снежинки с сохранённым фоном курсора
; In:
;   IX - запись FSnowFlake
; Out:
;   C - флаг, пересечение найдено
; Corrupt:
;   HL, DE, BC, AF, IY
; -----------------------------------------
.SnowCurrentHit ; передача текущей позиции без изменения записи снежинки
                LD L, (IX + FSnowFlake.Position.X)
                LD H, (IX + FSnowFlake.Position.Y)
                PUSH HL
                POP IY
                JP .SnowCursorHit
; -----------------------------------------
; пересечение формы снежинки с сохранённым прямоугольником фона курсора
; In:
;   IY - экранная позиция, IYH по Y, IYL по X
; Out:
;   C - флаг, пересечение найдено
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
.SnowCursorHit  ; проверка наличия сохранённого фона курсора
                LD HL, (Kernel.Sprite.Restore.BufferAdr)
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если курсор сейчас не нарисован, флаг переноса сброшен

                ; чтение экранного адреса и размера сохранённого фона
                INC L
                LD E, (HL)
                INC L
                LD D, (HL)
                INC L
                LD B, (HL)
                INC L
                LD C, (HL)

                ; расчёт горизонтальной границы фона в пикселях
                LD A, E
                AND #1F
                ADD A, A
                ADD A, A
                ADD A, A
                LD H, A
                LD A, IYL
                SUB H
                INC A
                LD L, A
                LD A, B
                ADD A, A
                ADD A, A
                ADD A, A
                INC A
                INC A
                LD B, A

                ; проверка горизонтального пересечения с запасом по краю снежинки
                LD A, L
                CP B
                RET NC                                                          ; выход, если форма не пересекает фон курсора по горизонтали

                ; восстановление экранной координаты Y из адреса пиксельной памяти
                LD A, D
                AND #07
                LD H, A
                LD A, E
                AND #E0
                RRCA
                RRCA
                OR H
                LD H, A
                LD A, D
                AND #18
                RLCA
                RLCA
                RLCA
                OR H
                LD H, A

                ; проверка вертикального пересечения с запасом по краю снежинки
                LD A, IYH
                SUB H
                INC A
                LD L, A
                LD A, C
                INC A
                INC A
                LD B, A
                LD A, L
                CP B
                RET
; -----------------------------------------
; XOR пары экранов с отложенным обновлением пикселя под видимым курсором
; In:
;   HL - адрес битовой маски пикселя
;   DE - адрес пиксельного байта теневого экрана
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   затвор курсора закрыт вызывающим кодом, IX сохраняется
;   пиксель под курсором меняется в фоне и появится на экране при штатном IRQ
; -----------------------------------------
.SnowPixel      PUSH HL
                PUSH DE
                PUSH IX

                ; проверка наличия сохранённого фона перед обращением к его данным
                LD HL, (Kernel.Sprite.Restore.BufferAdr)
                LD A, (HL)
                OR A
                JP Z, .SnowDirect                                               ; переход, если курсор сейчас не нарисован

                PUSH HL
                POP IX
                LD C, (IX + 1)
                LD B, (IX + 2)

                ; расчёт столбца пиксельного байта относительно сохранённого фона
                LD A, C
                AND #1F
                LD H, A
                LD A, E
                AND #1F
                SUB H
                JP C, .SnowDirect                                               ; переход, если байт находится левее фона курсора

                CP (IX + 3)
                JP NC, .SnowDirect                                              ; переход, если байт находится правее фона курсора

                LD L, A

                ; восстановление координаты Y пикселя из адреса теневого экрана
                LD A, D
                AND #07
                LD H, A
                LD A, E
                AND #E0
                RRCA
                RRCA
                OR H
                LD H, A
                LD A, D
                AND #18
                RLCA
                RLCA
                RLCA
                OR H
                LD H, A

                ; восстановление координаты Y первой строки сохранённого фона
                PUSH BC
                LD A, B
                AND #07
                LD B, A
                LD A, C
                AND #E0
                RRCA
                RRCA
                OR B
                LD B, A
                POP AF
                AND #18
                RLCA
                RLCA
                RLCA
                OR B
                LD B, A

                ; проверка попадания пикселя в вертикальные границы фона
                LD A, H
                SUB B
                JP C, .SnowDirect                                               ; переход, если пиксель находится выше фона курсора

                CP (IX + 4)
                JP NC, .SnowDirect                                              ; переход, если пиксель находится ниже фона курсора

                ; расчёт смещения байта в построчном массиве сохранённого фона
                LD B, A
                LD H, 0
                LD E, (IX + 3)
                LD D, 0
                OR A
                JR Z, .SnowBgAddress                                            ; переход, если пиксель находится в первой строке фона

.SnowBgRow      ADD HL, DE
                DJNZ .SnowBgRow
.SnowBgAddress  LD DE, 5
                ADD HL, DE
                PUSH IX
                POP DE
                ADD HL, DE

                ; выбор второго экрана по адресу фона, видимый курсор не изменяется
                LD A, (IX + 2)
                AND #80
                POP IX
                POP DE
                POP BC
                JR Z, .SnowBgXor                                                ; переход, если курсор сохранён с основного экрана

                RES 7, D
.SnowBgXor      ; изменение фона под курсором вместо записи поверх его пикселей
                LD A, (BC)
                XOR (HL)
                LD (HL), A

                ; немедленное изменение того же пикселя на втором экране
                LD H, B
                LD L, C
                LD A, (DE)
                XOR (HL)
                LD (DE), A
                RET

.SnowDirect     POP IX
                POP DE
                POP HL
                JP World.SharedScreen.Effects.Rain.Pixel.Both
; -----------------------------------------
; перенос области трафарета с основного экрана на теневой
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   ℹ️ необходимо включить страницу теневого экрана
;   работа с буфером курсора должна быть заблокирована
; -----------------------------------------
.CopyDiamond    ; расчёт адреса левого верхнего знакоместа трафарета
                SCREEN_ADR_REG HL, \
                    SCR_ADR_BASE, \
                    World.Stencil.Const.StencilPosX << 3, \
                    World.Stencil.Const.StencilPosY << 3

                ; перенос семи строк знакомест шириной шесть знакомест
                LD IXL, World.Stencil.Const.StencilHeight
                CALL World.SharedScreen.ScreenRefresh.Memcpy.Screen_6

                ; сброс запроса после завершения переноса области
                RES_FLAG_MODIFY PipelineHexagons.DiamondFlag
                RET
; -----------------------------------------
; перенос области индикатора паузы с основного экрана на теневой
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   необходимо включить страницу теневого экрана
;   работа с буфером курсора должна быть заблокирована
;   область переносится вместе с атрибутами
; -----------------------------------------
.CopySuspend    ; расчёт начала блока из четырёх знакомест у правого края рамки
                SCREEN_ADR_REG HL, SCR_ADR_BASE, \
                    (World.Display.Const.Suspend.PausePosX - 2) << 3, \
                    World.Display.Const.Suspend.PausePosY << 3

                ; перенос четырёх строк знакомест шириной четыре знакоместа
                LD IXL, #04
                CALL World.SharedScreen.ScreenRefresh.Memcpy.Screen_4

                ; сброс запроса после завершения переноса области
                RES_FLAG_MODIFY PipelineHexagons.SuspendFlag
                RET

                ; вентель, блокирующий восстановление курсора из буфера вовремя 
                ; обновления теневого экрана
CursorMemcpyGate:
.Flag           EQU $
                NOP                                                             ; OR A/SCF #B7/#37
                RET

                display " - Pipeline hexagons:\t\t\t\t\t", /A, PipelineHexagons, "\t= busy [ ", /D, $-PipelineHexagons, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_PIPELINE_HEXAGONS_
