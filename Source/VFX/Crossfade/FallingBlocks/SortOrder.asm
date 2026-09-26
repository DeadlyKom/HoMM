
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_SORT_ORDER_
                define _VFX_CROSSFADE_FALLING_BLOCKS_SORT_ORDER_
; -----------------------------------------
; сортировка номеров блоков и расстояний от большего к меньшему
; In:
; Out:
;   Const.OrderAdr - номера блоков в порядке убывания расстояния
;   Const.DistancesAdr - расстояния в том же порядке
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   равные расстояния сохраняют исходный порядок блоков
;   массивы содержат по 192 байта и начинаются с нулевого младшего байта
;   Const.DistancesAdr = Const.OrderAdr + #0100
; -----------------------------------------
SortOrder:      ; начало сравнения со второго элемента
                LD HL, Const.DistancesAdr + #01
                LD B, #02

.Loop           ; сравнение расстояний предыдущего и текущего блоков
                LD C, (HL)
                DEC L
                LD A, (HL)
                CP C
                JP NC, .Next                                                    ; переход, если предыдущее расстояние не меньше текущего

                ; перестановка расстояний соседних блоков
                LD (HL), C
                INC L
                LD (HL), A

                ; перестановка соответствующих номеров в массиве Order
                DEC H
                LD A, (HL)
                DEC L
                LD C, (HL)
                LD (HL), A
                INC L
                LD (HL), C
                INC H

                ; проверка наличия предыдущей пары после перестановки
                DEC L
                JP NZ, .Loop                                                    ; переход, если слева осталась пара для сравнения

.Next           ; выбор следующего элемента за обработанной частью массива
                LD L, B
                INC B

                ; проверка завершения сортировки всех элементов
                LD A, L
                CP Size.FallingOrder
                JR C, .Loop                                                     ; переход, если остались элементы для сортировки

                RET

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_SORT_ORDER_
