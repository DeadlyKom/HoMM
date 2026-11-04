                ifndef _WORLD_RENDER_RAIN_VISIBLE_
                define _WORLD_RENDER_RAIN_VISIBLE_
; -----------------------------------------
; проверка открытого гексагона в точке удара дождя
; In:
;   DE - экранная позиция, D - y, E - x в пикселях
; Out:
;   Z установлен, если гексагон скрыт или не найден
; Corrupt:
;   HL, BC, AF, HL', BC', AF'
; Note:
;   вход и выход со страницей 7, переключение выполняется из общего кода
;   не изменяет разрешение прерываний, расчёт допускает вложенный вызов из обработчика
;   повторяет расчёт с исходной точкой, если за время проверки изменился TickCounterRef
; -----------------------------------------
RainVisible:    ; сохранение номера прерывания и исходной точки для повторной проверки
.Retry          LD A, (TickCounterRef)
                PUSH AF
                PUSH DE

                ; определение гексагона по существующему алгоритму
                SET_MODULE_PAGE_World

                ; расчёт с локальным состоянием, независимым от обработки мыши в прерывании
                CALL World.Hexagon.GetPosByPixel

                ; получение индекса гексагона без изменения RenderBuffer
                PUSH BC
                SET_PAGE_MAP
                POP BC
                CALL BufferUtilities.GetIndexRender
                JR C, .Hidden                                                   ; переход, если гексагон отсутствует в буфере

                ; проверка флага разведки выбранного гексагона
                LD H, HIGH Adr.RenderBuffer
                LD L, A
                LD A, (HL)
                AND RENDER_FLAG_HEX_FOG
                JR .Restore

.Hidden         XOR A
.Restore        PUSH AF
                SET_PAGE_SCREEN_SHADOW
                POP BC                                                          ; сохранение результата и его флагов до проверки счётчика
                POP DE                                                          ; восстановление исходных пиксельных координат
                POP AF                                                          ; восстановление номера прерывания перед расчётом

                ; проверка изменения счётчика прерываний за время расчёта
                LD HL, TickCounterRef
                CP (HL)
                JR NZ, .Retry                                                   ; переход, если во время расчёта прошло прерывание

                ; возврат результата проверки со всеми полученными флагами
                PUSH BC
                POP AF
                RET

                endif                                                           ; ~_WORLD_RENDER_RAIN_VISIBLE_
