
                ifndef _STRUCTS_CURVE_
                define _STRUCTS_CURVE_

                struct FCurveKey                                                ; ключ линейной кривой                                  [2 байта]
Position        DB #00                                                          ; нормализованная позиция ключа 0..255                  [1 байт]
Value           DB #00                                                          ; значение ключа для конечного использования 0..255     [1 байт]
                ends

                endif                                                           ; ~_STRUCTS_CURVE_
