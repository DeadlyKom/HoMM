                ifndef _WORLD_RENDER_WEATHER_INPUT_
                define _WORLD_RENDER_WEATHER_INPUT_
; -----------------------------------------
; запрос погоды по одиночному нажатию N в обработчике ввода мира
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   вызывается из прерывания, рисование выполняется позже в штатной фазе переноса
; -----------------------------------------
WeatherKey:     ; проверка клавиши N через существующий обработчик виртуальных клавиш
                ; проверка наличия эффекта с управлением по N
                if WEATHER_TORNADO_ON || WEATHER_RAIN_ON
                LD A, VK_N
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша N отпущена

                ; проверка уже обработанного удержания клавиши
                LD A, (.Held)
                OR A
                RET NZ                                                          ; выход, если текущее нажатие уже обработано

                ; запись одноразового запроса без рисования из прерывания
                LD A, 1
                LD (.Held), A
                if WEATHER_TORNADO_ON
                LD (TornadoRequest), A
                else
                LD A, (WeatherMode)
                XOR 1
                LD (WeatherMode), A
                endif
                RET

.Released       XOR A
                LD (.Held), A
                RET

.Held           DB 0                                                            ; защёлка удержания клавиши N
                else
                RET
                endif
                if WEATHER_TORNADO_ON
TornadoRequest  DB 0                                                            ; флаг, запрос нового запуска единственного смерча
                else
WeatherMode     DB WEATHER_SNOW                                                 ; запрошенный режим погоды, дождь или снег
                endif
                endif ; ~_WORLD_RENDER_WEATHER_INPUT_
