
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_RESTORE_
                define _VFX_CROSSFADE_FALLING_BLOCKS_RESTORE_
; -----------------------------------------
; восстановление старых положений падающих блоков
; In:
;   Play.FallingCount - количество падающих блоков
;   Const.FallingAdr - массив записей FFallingBlock
;   Const.StencilAdr - трафарет неподвижных блоков
;   Play.FallTable - таблица смещений падения
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   фон копируется из теневого экрана в основной
;   шаги падения и трафарет не изменяются
; -----------------------------------------
Restore:        ; проверка наличия падающих блоков
                LD A, (Play.FallingCount)
                OR A
                RET Z                                                           ; выход, если падающих блоков нет

                LD B, A
                LD HL, Const.FallingAdr

.Loop           ; чтение номера блока и шага падения
                LD C, (HL)                                                      ; FFallingBlock.Index
                INC L
                LD E, (HL)                                                      ; FFallingBlock.Step
                INC L

                ; пропуск полного адреса графики в записи
                INC L
                INC L

                ; сохранение указателя следующей записи и счётчика обхода
                PUSH HL
                PUSH BC

                ; расчёт адреса смещения по текущему шагу падения
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

                ; восстановление верхней половины с сохранением координат
                PUSH BC
                CALL .Half
                POP BC

                ; расчёт Y нижней половины
                LD A, B
                ADD A, #08

                ; проверка положения нижней половины относительно экрана
                CP 192
                JP NC, .Next                                                    ; переход, если нижняя половина ниже экрана
                LD B, A

                ; восстановление нижней половины
                CALL .Half

.Next           ; продолжение обхода массива падающих блоков
                POP BC
                POP HL
                DJNZ .Loop
                RET

.Half           ; расчёт номера участка назначения, B = Y, C = X блока
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

                ; получение адреса строки теневого экрана
                LD L, B
                LD H, HIGH Adr.ScrAdrTable
                OR (HL)
                LD E, A
                INC H
                LD D, (HL)

                ; подготовка источника в HL и назначения в основном экране DE
                LD H, D
                LD L, E
                RES 7, D

                ; восстановление пикселей и атрибутов половины блока
                FB_RESTORE_HALF
                RET

                endif                                                           ; ~_VFX_CROSSFADE_FALLING_BLOCKS_RESTORE_
