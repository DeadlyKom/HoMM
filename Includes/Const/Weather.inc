                ifndef _CONST_WEATHER_
                define _CONST_WEATHER_
WEATHER_RAIN    EQU 0                                                           ; режим дождя
WEATHER_SNOW    EQU 1                                                           ; режим снега с локальным закручиванием
WEATHER_RAIN_ON EQU 0                                                           ; временное исключение дождя из пакета мира, 1 включает обратно
WEATHER_STORM_ON EQU 0                                                          ; временное исключение молний и вспышек, 1 включает обратно
SNOW_COUNT      EQU 32                                                          ; количество свободно движущихся снежинок
SNOW_PERIOD     EQU 1                                                           ; интервал обновления движения в прерываниях
SNOW_VORT_RANGE EQU 48                                                          ; дальность влияния вихря по каждой оси в пикселях
SNOW_VORT_CORE  EQU 24                                                          ; граница сильного вращения, снаружи влияние слабее вдвое
SNOW_FALL_BASE  EQU 8                                                           ; базовая скорость падения, доли пикселя с делителем 16
SNOW_FALL_FRAC  EQU 128                                                          ; оседание центра вихря, доли пикселя с делителем 256
SNOW_WIND_SHIFT EQU 4                                                           ; масштаб общего ветра в дробных единицах положения центра
                ; проверка диапазонов движения и дробных координат
                assert SNOW_COUNT >= 1 && SNOW_COUNT <= 255
                assert SNOW_PERIOD >= 1 && SNOW_PERIOD <= 255
                assert SNOW_VORT_CORE > 0 && SNOW_VORT_CORE < SNOW_VORT_RANGE
                assert SNOW_VORT_RANGE <= 48 && SNOW_FALL_BASE >= 1 && SNOW_FALL_BASE <= 16
                assert SNOW_FALL_FRAC >= 1 && SNOW_FALL_FRAC <= 255
                assert SNOW_WIND_SHIFT >= 0 && SNOW_WIND_SHIFT <= 4
                endif ; ~_CONST_WEATHER_
