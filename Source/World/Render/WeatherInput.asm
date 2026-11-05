                ifndef _WORLD_RENDER_WEATHER_INPUT_
                define _WORLD_RENDER_WEATHER_INPUT_
; -----------------------------------------
; переключение погоды по одиночному нажатию N в обработчике ввода мира
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   вызывается из прерывания, рисование выполняется позже в штатной фазе переноса
; -----------------------------------------
WeatherKey:     ; проверка клавиши N через существующий обработчик виртуальных клавиш
                ; исключение переключения на отсутствующий код дождя
                if WEATHER_RAIN_ON
                LD A, VK_N
                CALL Input.CheckKeyState
                JR NZ, .Released                                                ; переход, если клавиша N отпущена

                ; проверка уже обработанного удержания клавиши
                LD A, (.Held)
                OR A
                RET NZ                                                          ; выход, если текущее нажатие уже обработано

                ; переключение запрошенного режима один раз на нажатие
                LD A, 1
                LD (.Held), A
                LD A, (WeatherMode)
                XOR 1
                LD (WeatherMode), A
                RET

.Released       XOR A
                LD (.Held), A
                RET

.Held           DB 0                                                            ; защёлка удержания клавиши N
                else
                RET
                endif
WeatherMode     DB WEATHER_SNOW                                                 ; запрошенный режим погоды, дождь или снег
                endif ; ~_WORLD_RENDER_WEATHER_INPUT_
