
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_DRAW_
                define _VFX_CROSSFADE_FALLING_BLOCKS_DRAW_
; -----------------------------------------
; рисование падающих блоков из готового буфера
; In:
;   Play.FallingCount    - количество падающих блоков
;   Const.FallingAdr     - массив записей FFallingBlock
;   Const.StencilAdr     - трафарет неподвижных блоков
;   FFallingBlock.Source - полный адрес графики исходного блока
;   Play.FallTable - таблица смещений падения
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   пиксели и атрибуты рисуются только на свободных участках трафарета
;   шаги падения и трафарет не изменяются
; -----------------------------------------
Draw:           ; проверка наличия падающих блоков
                LD A, (Play.FallingCount)
                OR A
                RET Z                                                           ; выход, если падающих блоков нет

                LD B, A
                LD HL, Const.FallingAdr

.Loop           ; чтение номера блока и шага падения
                LD C, (HL)                                                      ; FFallingBlock.Index
                INC L
                LD A, (HL)                                                      ; FFallingBlock.Step
                INC L

                ; чтение полного адреса графики из записи
                LD E, (HL)                                                      ; FFallingBlock.Source, младший байт
                INC L
                LD D, (HL)                                                      ; FFallingBlock.Source, старший байт
                INC L
                LD (.Source), DE

                ; сохранение указателя следующей записи и счётчика обхода
                PUSH HL
                PUSH BC

                ; расчёт адреса смещения по текущему шагу падения
                LD E, A
                LD D, #00
                LD HL, Play.FallTable
                ADD HL, DE

                ; расчёт текущего Y и проверка переполнения байта
                LD A, C
                AND #F0
                ADD A, (HL)
                JP C, .Next                                                     ; переход, если текущий Y достиг 256

                ; проверка положения верхней половины относительно экрана
                CP 192
                JP NC, .Next                                                    ; переход, если блок целиком ниже экрана
                LD B, A

                ; расчёт горизонтального номера блока
                LD A, C
                AND #0F
                LD C, A

                ; преобразование номера бита в код инструкции проверки
                AND #07
                ADD A, A                                                        ; x2
                ADD A, A                                                        ; x4
                ADD A, A                                                        ; x8
                OR #46                                                          ; BIT n, (HL)
                LD (.BIT), A

                ; рисование верхней половины с сохранением координат
                PUSH BC
                CALL .Upper
                POP BC

                ; расчёт Y нижней половины
                LD A, B
                ADD A, #08

                ; проверка положения нижней половины относительно экрана
                CP 192
                JP NC, .Next                                                    ; переход, если нижняя половина ниже экрана
                LD B, A

                ; рисование нижней половины
                CALL .Lower

.Next           ; проверка оставшихся записей после восстановления счётчика обхода
                POP BC
                POP HL
                DEC B
                JP NZ, .Loop                                                    ; переход, если остались падающие блоки
                RET

.Upper          ; проверка доступности участка для верхней половины
                CALL .Address
                RET NZ                                                          ; выход, если участок занят неподвижным блоком

                ; рисование верхней половины сверху вниз
.Source         EQU $+1
                LD DE, #0000
                FB_DRAW_HALF INC
                RET

.Lower          ; проверка доступности участка для нижней половины
                CALL .Address
                RET NZ                                                          ; выход, если участок занят неподвижным блоком

                ; расчёт адреса последней строки нижней половины
                LD A, H
                OR #07
                LD H, A

                ; расчёт адреса данных нижней половины
                LD DE, (.Source)
                LD A, E
                ADD A, #12
                LD E, A
                ADC A, D
                SUB E
                LD D, A

                ; рисование нижней половины снизу вверх
                FB_DRAW_HALF DEC
                RET

.Address        ; расчёт номера участка назначения, B = Y, C = X блока
                LD A, B
                AND #F0
                OR C

                ; расчёт адреса байта трафарета
                RRCA
                RRCA
                RRCA
                AND #1F
                OR LOW Const.StencilAdr
                LD L, A
                LD H, HIGH Const.StencilAdr

                ; проверка неподвижного блока в месте назначения
.BIT            EQU $+1
                DB #CB, #00
                RET NZ                                                          ; выход, если участок занят неподвижным блоком

                ; расчёт горизонтального смещения в байтах
                LD A, C
                ADD A, A                                                        ; x2

                ; получение адреса первой строки половины
                LD L, B
                LD H, HIGH Adr.ScrAdrTable
                OR (HL)
                LD E, A
                INC H
                LD H, (HL)
                LD L, E
                RES 7, H

                XOR A                                                           ; флаг, участок доступен для рисования
                RET

                endif                                                           ; ~_VFX_CROSSFADE_FALLING_BLOCKS_DRAW_
