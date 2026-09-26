
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_INCLUDE_
                define _VFX_CROSSFADE_FALLING_BLOCKS_INCLUDE_

                module VFX
                module FallingBlocks
Const:          ; константные значения
.BlocksCount    EQU Size.FallingOrder                                           ; количество блоков исходного экрана
.MaxFalling     EQU MAX_FALL_BLOCKS                                             ; максимальное количество одновременно падающих блоков
.FrameTicks     EQU #01                                                         ; интервал между началами кадров эффекта в прерываниях
.OrderAdr       EQU Adr.FallingOrder                                            ; адрес массива номеров блоков, 192 байта
.DistancesAdr   EQU Adr.FallingDist                                             ; адрес массива расстояний, 192 байта
.StencilAdr     EQU Adr.FallingStencil                                          ; адрес трафарета неподвижных блоков
.StencilSize    EQU Size.FallingStencil                                         ; размер трафарета, по одному биту на блок
.FallingAdr     EQU Adr.FallingArray                                            ; адрес массива состояния падающих блоков
.FallingSize    EQU Size.FallingArray                                           ; размер массива состояния падающих блоков
.BlockSize      EQU Size.FallingBlock                                           ; размер блока, 32 байта пикселей и 4 байта атрибутов
.BufferAdr      EQU Adr.FallingBuffer                                           ; адрес буфера графики всех блоков
.CodeAdr        EQU Adr.FallingCode                                             ; адрес размещения кода эффекта в странице 7

                include "Macro.inc"
                include "Deploy.asm"

CodeSource:     DISP Const.CodeAdr
                include "Draw.asm"
                include "Move.asm"
                include "Play.asm"
                include "Restore.asm"
                include "SortOrder.asm"
                include "Initialize.asm"
                include "BuildOrder.asm"
                include "BuildBlocks.asm"
                include "Functions/Include.inc"
                ENT

                ; расчёт фактической длины исходного блока для копирования
CodeSize        EQU $-CodeSource
                assert CodeSize <= Size.FallingCode                             ; проверка вместимости кода в отведённую область

                endmodule
                endmodule

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_INCLUDE_
