                ifndef _WORLD_SCREEN_EFFECTS_WEATHER_
                define _WORLD_SCREEN_EFFECTS_WEATHER_
                module Weather
; -----------------------------------------
; подготовка снега до перерисовки гексов, общий ветер и координаты не меняются
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; -----------------------------------------
Prepare:        ; проверка наличия снега в текущем режиме
                LD A, (ActiveMode)
                CP WEATHER_SNOW
                RET NZ                                                          ; выход, если сейчас показан дождь

                JP World.SharedScreen.Effects.Snow.Prepare
; -----------------------------------------
; стирание дождя до переноса, снег подготовлен перед рисованием гексов
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   включена страница 7, смена запроса из прерывания не меняет выбранное стирание
; -----------------------------------------
Erase:          ; проверка ранее показанного режима
                ; исключение перехода к отсутствующему обработчику дождя
                if WEATHER_RAIN_ON
                LD A, (ActiveMode)
                CP WEATHER_SNOW
                RET Z                                                           ; выход, если снег уже подготовлен до обновления карты

                JP World.SharedScreen.Effects.Rain.Erase
                else
                RET
                endif
; -----------------------------------------
; применение запроса погоды и отображение выбранного эффекта
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; -----------------------------------------
Tick:           ; чтение запрошенного режима после стирания предыдущего рисунка
                ; исключение переключения на отсутствующий обработчик дождя
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
                endmodule
                endif ; ~_WORLD_SCREEN_EFFECTS_WEATHER_
