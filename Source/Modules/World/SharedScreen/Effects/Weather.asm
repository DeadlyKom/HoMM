                ifndef _WORLD_SCREEN_EFFECTS_WEATHER_
                define _WORLD_SCREEN_EFFECTS_WEATHER_
                module Weather
                if WEATHER_TORNADO_ON
                ; сброс состояния при входе в мир
Reset:          JP World.SharedScreen.Effects.Tornado.Reset

                ; снятие прежней накладки до рисования карты
Prepare:        JP World.SharedScreen.Effects.Tornado.EraseBase

                ; одинаковый рисунок в обоих экранах перед показом карты
Overlay:        JP World.SharedScreen.Effects.Tornado.DrawBase

                ; сохранение одинакового рисунка на время переноса блоков
Erase:          RET

                ; обновление только скрытого экрана после восстановления курсора
Tick:           CALL World.SharedScreen.Effects.Tornado.Erase
                JP World.SharedScreen.Effects.Tornado.Tick
                else
                if WEATHER_SNOW_ON
Reset:          JP World.SharedScreen.Effects.Snow.Reset
; -----------------------------------------
; снятие временной снежной накладки до штатной отрисовки карты
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   включена страница 7, основной экран скрыт
; -----------------------------------------
Prepare:        JP World.SharedScreen.Effects.Snow.EraseBase
; -----------------------------------------
; подготовка одинакового снега на обоих экранах перед показом готовой карты
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   включена страница 7, кадр ещё не объявлен готовым
; -----------------------------------------
Overlay:        ; проверка необходимости временной снежной накладки
                LD A, (ActiveMode)
                CP WEATHER_SNOW
                RET NZ                                                          ; выход, если сейчас отображается дождь

                JP World.SharedScreen.Effects.Snow.DrawBase
; -----------------------------------------
; снятие дождя перед копированием, одинаковый снег на экранах сохраняется
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   включена страница 7, CursorMemcpyGate закрыт штатным конвейером
; -----------------------------------------
Erase:          ; проверка ранее показанного режима осадков
                if WEATHER_RAIN_ON
                LD A, (ActiveMode)
                CP WEATHER_SNOW
                RET Z                                                           ; выход, если снег должен оставаться одинаковым на время копирования

                JP World.SharedScreen.Effects.Rain.Erase
                else
                RET
                endif
; -----------------------------------------
; смена теневого снега после копирования и восстановления курсора
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; Note:
;   основная накладка остаётся в прежних координатах до следующего Prepare
; -----------------------------------------
Tick:           ; проверка необходимости снять прежний теневой снег
                LD A, (ActiveMode)
                CP WEATHER_SNOW
                CALL Z, World.SharedScreen.Effects.Snow.Erase                   ; вызов, если до копирования отображался снег

                ; применение выбранного режима после снятия прежнего рисунка
                if WEATHER_RAIN_ON
                LD A, (World.SharedCode.Render.WeatherMode)
                LD (ActiveMode), A
                CP WEATHER_SNOW
                JR Z, .Snow                                                     ; переход, если выбран снег

                JP World.SharedScreen.Effects.Rain.Tick
                endif

.Snow           ; обновление общего ветра существующей логикой дождя
                CALL World.SharedScreen.Effects.Rain.Weather
                JP World.SharedScreen.Effects.Snow.Tick

ActiveMode      DB WEATHER_SNOW                                                 ; режим последнего показанного рисунка
                else
Reset:          RET
Prepare:        RET
Overlay:        RET
                if WEATHER_RAIN_ON
Erase:          JP World.SharedScreen.Effects.Rain.Erase
Tick:           JP World.SharedScreen.Effects.Rain.Tick
                else
Erase:          RET
Tick:           RET
                endif
                endif
                endif
                endmodule
                endif                                                           ; ~_WORLD_SCREEN_EFFECTS_WEATHER_
