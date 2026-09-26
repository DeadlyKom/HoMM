
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_MOVE_
                define _VFX_CROSSFADE_FALLING_BLOCKS_MOVE_
; -----------------------------------------
; обновление шага падения и удаление ушедших блоков
; In:
;   Play.FallingCount - количество падающих блоков
;   Const.FallingAdr - массив записей FFallingBlock
;   Play.FallTable - таблица смещений падения
; Out:
;   Play.FallingCount - количество оставшихся падающих блоков
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   вызывается после восстановления старых положений блоков
;   каждая исходная запись обрабатывается один раз за проход
; -----------------------------------------
Move:           ; проверка наличия падающих блоков
                LD A, (Play.FallingCount)
                OR A
                RET Z                                                           ; выход, если падающих блоков нет

                LD B, A                                                         ; количество записей
                LD C, #00                                                       ; позиция обхода
                LD HL, Const.FallingAdr

.Loop           ; расчёт исходного Y по номеру блока
                LD A, (HL)                                                      ; FFallingBlock.Index
                AND #F0
                PUSH HL                                                         ; адрес текущей записи

                ; увеличение шага падения текущего блока
                INC L
                INC (HL)                                                        ; FFallingBlock.Step

                ; расчёт адреса нового смещения в таблице падения
                LD E, (HL)
                LD D, #00
                LD HL, Play.FallTable
                ADD HL, DE

                ; расчёт нового Y и проверка переполнения байта
                ADD A, (HL)
                POP HL
                JP C, .Remove                                                   ; переход, если новый Y достиг 256

                ; проверка полного выхода блока за нижнюю границу экрана
                CP 192
                JP NC, .Remove                                                  ; переход, если блок целиком ниже экрана

                ; переход к следующей позиции обхода
                INC C

                ; проверка завершения обхода оставшихся записей
                LD A, C
                CP B
                RET Z                                                           ; выход, если все падающие блоки обработаны

                ; расчёт адреса следующей четырёхбайтной записи
                LD A, L
                ADD A, FFallingBlock
                LD L, A
                JP .Loop

.Remove         ; уменьшение количества падающих блоков
                DEC B
                LD A, B
                LD (Play.FallingCount), A

                ; проверка удаления последней записи массива
                CP C
                RET Z                                                           ; выход, если удалена последняя запись массива

                ; расчёт младшего байта адреса последней занятой записи
                ADD A, A    ; x2
                ADD A, A    ; x4
                OR LOW Const.FallingAdr

                ; подготовка адресов назначения и источника
                LD D, H
                LD E, L
                LD L, A
                LD H, HIGH Const.FallingAdr

                ; сохранение текущей позиции и счётчиков обхода
                PUSH DE
                PUSH BC

                ; перенос всей записи, включая полный адрес графики
                LDI                                                             ; FFallingBlock.Index
                LDI                                                             ; FFallingBlock.Step
                LDI                                                             ; FFallingBlock.Source, младший байт
                LDI                                                             ; FFallingBlock.Source, старший байт

                ; продолжение обработки подставленной записи в той же позиции
                POP BC
                POP HL
                JP .Loop

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_MOVE_

