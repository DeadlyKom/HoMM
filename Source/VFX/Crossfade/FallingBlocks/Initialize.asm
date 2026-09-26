
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_INITIALIZE_
                define _VFX_CROSSFADE_FALLING_BLOCKS_INITIALIZE_
; -----------------------------------------
; подготовка данных эффекта падающих блоков перед проигрыванием
; In:
;   HL - адрес функции расчёта расстояния
;   BC - центр в пикселях, B = y [0..191], C = x [0..255]
; Out:
;   Const.BufferAdr - графика 192 блоков исходного экрана
;   Const.StencilAdr - трафарет неподвижных блоков заполнен единицами
;   Const.OrderAdr - номера блоков в порядке убывания расстояния
;   Const.DistancesAdr - расстояния в том же порядке
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   перед вызовом код эффекта должен быть перенесён методом Deploy
;   вызывается методом Play перед началом проигрывания
; -----------------------------------------
Initialize:     ; инициализация адреса функции расчёта расстояния
                LD (BuildOrder.Function), HL

                ; перевод координаты X в блоки 16x16 и инициализация центра
                LD A, C
                RRCA
                RRCA
                RRCA
                RRCA
                AND #0F
                LD (BuildOrder.CenterX), A

                ; перевод координаты Y в блоки 16x16 и инициализация центра
                LD A, B
                RRCA
                RRCA
                RRCA
                RRCA
                AND #0F
                LD (BuildOrder.CenterY), A

                MEMSET_BYTE Const.StencilAdr, #FF, #20                          ; заполнение трафарета перед подготовкой буферов
                CALL BuildBlocks                                                ; формирование графики блоков из базового экрана
                CALL BuildOrder                                                 ; построение номеров блоков и расстояний от центра
                JP SortOrder                                                    ; сортировка номеров блоков и расстояний

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_INITIALIZE_
