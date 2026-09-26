
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_BUILD_ORDER_
                define _VFX_CROSSFADE_FALLING_BLOCKS_BUILD_ORDER_
; -----------------------------------------
; построение массивов номеров блоков и расстояний
; In:
;   BuildOrder.Function - адрес функции расчёта расстояния
;   BuildOrder.CenterX - координата центра X в блоках 16x16 [0..15]
;   BuildOrder.CenterY - координата центра Y в блоках 16x16 [0..11]
; Out:
;   Const.OrderAdr - номера блоков от 0 до 191
;   Const.DistancesAdr - расстояния по исходным номерам блоков
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   массивы содержат по 192 байта и начинаются с нулевого младшего байта
;   Const.DistancesAdr = Const.OrderAdr + #0100
;   на время вызова функции HL и BC сохраняются в стеке, 4 байта
; -----------------------------------------
BuildOrder:     ; инициализация координат и указателя на первый блок
                LD BC, #0000
                LD HL, Const.OrderAdr

.Loop           ; расчёт смещения блока по X относительно центра
                LD A, C
.CenterX        EQU $+1
                SUB #00
                LD E, A

                ; расчёт смещения блока по Y относительно центра
                LD A, B
.CenterY        EQU $+1
                SUB #00
                LD D, A

                ; сохранение указателя и координат текущего блока
                PUSH HL
                PUSH BC

                ; расчёт расстояния выбранной функцией
.Function       EQU $+1
                LD HL, #0000
                CALL_HL

                ; восстановление координат и указателя текущего блока
                POP BC
                POP HL

                ; запись номера блока и рассчитанного расстояния
                LD H, HIGH Const.OrderAdr
                LD (HL), L
                INC H
                LD (HL), A

                ; переход к следующему блоку
                INC L

                ; проверка завершения обхода всех блоков
                LD A, L
                CP Size.FallingOrder
                RET Z                                                           ; выход, если обработаны все 192 блока

                ; расчёт номера следующей колонки
                INC C

                ; проверка границы строки из 16 блоков
                LD A, C
                CP #10
                JP C, .Loop                                                     ; переход, если следующая колонка находится в текущей строке

                ; переход к первой колонке следующей строки
                LD C, #00
                INC B
                JP .Loop

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_BUILD_ORDER_
