
                ifndef _MATH_CURVE_
                define _MATH_CURVE_

                module Math
Curve:          ; функции работы с линейной кривой
; -----------------------------------------
; получение значения линейной кривой
; In:
;   HL - адрес первого FCurveKey
;   B  - количество ключей
;   A  - нормализованная позиция на оси X 0..255
; Out:
;   A  - интерполированное значение кривой 0..255
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ⚠️ ВАЖНО ⚠️
;   количество ключей должно находиться в диапазоне 1..255
;   ключи должны быть отсортированы по FCurveKey.Position
;   позиции соседних ключей не должны совпадать
;   за границами кривой возвращается значение крайнего ключа
;
;   SegmentLength = Right.Position - Left.Position
;   LocalPosition = X - Left.Position
;   Delta = abs(Right.Value - Left.Value)
;   Result = Left.Value +/- Delta * LocalPosition / SegmentLength
; -----------------------------------------
.GetValue       LD C, A                                                         ; сохранение позиции на оси X
                
                ; чтение первого ключа
                LD A, (HL)                                                      ; чтение FCurveKey.Position
                LD D, A                                                         ; сохранение позиции левой границы
                INC HL                                                          ; переход к FCurveKey.Value
                LD E, (HL)                                                      ; чтение FCurveKey.Value

                ; проверка положения относительно первого ключа
                CP C
                LD A, E                                                         ; хранит значение FCurveKey.Value
                RET NC                                                          ; выход, если позиция находится перед первым ключом

                ; подготовка поиска правой границы диапазона
                INC HL                                                          ; переход к позиции следующего ключа
                DEC B
                RET Z                                                           ; выход, если кривая содержит только один ключ

                ; HL - адрес следующего ключа
                ; D  - хранит прошлую позицию ключа
                ; E  - хранит значение прошлого ключа
                ; C  - хранит искомую позицию

.Search         ; поиск правой границы текущего диапазона
                LD A, (HL)                                                      ; чтение FCurveKey.Position
                CP C
                JR Z, .ReturnRight                                              ; переход, если позиция совпадает с правым ключом
                JR NC, .FoundSegment                                            ; переход, если найден правый ключ диапазона

                ; перенос следующего ключа в левую границу нового диапазона
                LD D, A                                                         ; сохранение позиции левой границы
                INC HL                                                          ; переход к FCurveKey.Value
                LD E, (HL)                                                      ; сохранение значения левой границы
                INC HL                                                          ; переход к FCurveKey.Position следующего ключа
                DJNZ .Search

.ReturnLeft     ; возврат значения последнего ключа
                LD A, E                                                         ; чтение значения последнего ключа
                RET

.ReturnRight    ; возврат значения ключа, совпавшего с искомой позицией
                INC HL                                                          ; переход к FCurveKey.Value
                LD A, (HL)                                                      ; чтение значения правого ключа
                RET

                ; HL - адрес текущего ключа
                ; D  - хранит прошлую позицию ключа
                ; E  - хранит значение прошлого ключа
                ; C  - хранит искомую позицию
                ; A  - хранит текущую позицию ключа

.FoundSegment   ; расчёт длины выбранного сегмента
                ; SegmentLength = Right.Position - Left.Position
                SUB D
                LD B, A                                                         ; SegmentLength

                ; расчёт положения внутри выбранного сегмента
                ; LocalPosition = X - Left.Position
                LD A, C
                SUB D
                LD C, A                                                         ; LocalPosition

                ; чтение значения правого ключа
                INC HL                                                          ; переход к Right.Value
                LD A, (HL)                                                      ; чтение Right.Value

                ; проверка изменения значения внутри выбранного сегмента
                CP E
                RET Z                                                           ; выход, если значения прошлого и правого ключа совпадают

                ; определение направления изменения значения
                PUSH DE                                                         ; сохранение Left.Position и Left.Value
                JR C, .Descending                                               ; переход, если значение кривой уменьшается

                ; расчёт возрастающего значения кривой
                ; Result = Left.Value + (Right.Value - Left.Value) * LocalPosition / SegmentLength
                SUB E                                                           ; Delta = Right.Value - Left.Value
                CALL .Scale
                POP DE                                                          ; восстановление Left.Position и Left.Value

                ADD A, E                                                        ; Result = Left.Value + ScaledDelta
                RET

                ; HL - адрес текущего ключа (значения)
                ; D  - хранит прошлую позицию ключа
                ; E  - хранит значение прошлого ключа
                ; C  - хранит разницу позиций между искомым и прошлым ключом
                ; A  - хранит значение текущего ключа
                ; B  - хранит длину диапазона между прошлым и текущим ключами

.Descending     ; расчёт убывающего значения кривой
                ; Result = Left.Value - (Left.Value - Right.Value) * LocalPosition / SegmentLength
                LD D, A                                                         ; сохранение значения правого ключа
                LD A, E
                SUB D                                                           ; Delta = Left.Value - Right.Value
                CALL .Scale
                LD C, A                                                         ; сохранение ScaledDelta
                POP DE                                                          ; восстановление Left.Position и Left.Value

                LD A, E                                                         ; чтение Left.Value
                SUB C                                                           ; Result = Left.Value - ScaledDelta
                RET

                ; B  - хранит длину диапазона между предыдущим и текущим ключами
                ; C  - хранит разницу между искомой позицией и позицией предыдущего ключа
                ; A  - хранит разницу между значениями предыдущего и текущего ключей

.Scale          ; масштабирование разницы значений внутри выбранного сегмента
                ; Product = Delta * LocalPosition
                LD E, A                                                         ; Delta
                LD D, #00
                LD A, C                                                         ; LocalPosition
                ; ----------------------------------------
                ; In:
                ;   DE - multiplicand
                ;   A  - multiplier
                ; Out :
                ;   HL - product DE * A
                ; Corrupt :
                ;   HL, F
                ; ----------------------------------------
                CALL Math.Mul16x8_16

                ; ScaledDelta = Product / SegmentLength
                LD E, B                                                         ; SegmentLength
                ; -----------------------------------------
                ; деление HL на E
                ; In :
                ;   HL - делимое
                ;   E  - делитель
                ; Out :
                ;   L  - результат деления
                ;   H  - остаток
                ; Corrupt :
                ;   HL, AF
                ; -----------------------------------------
                CALL Math.Div16x8_16
                LD A, L                                                         ; возврат ScaledDelta
                RET

                endmodule

                endif ; ~_MATH_CURVE_
