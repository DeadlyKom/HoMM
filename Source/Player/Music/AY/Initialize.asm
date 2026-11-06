
                ifndef _PLAYER_MUSIC_AY_INITIALIZE_
                define _PLAYER_MUSIC_AY_INITIALIZE_
; -----------------------------------------
; инициализация состояния модуля и таблиц проигрывателя
; In:
;   HL - адрес начала модуля PT3
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   сохраняет адреса и задержку в операндах, готовит таблицы нот и громкости
; -----------------------------------------
Initialize:     ; -----------------------------------------
                ; чтение заголовка модуля
                ; -----------------------------------------

                ; сохранение базового адреса модуля
                LD (RowCommands.ModuleBase), HL
                LD (Effects.OrnModuleBase), HL
                PUSH HL

                ; чтение начальной задержки и расчёт адреса перед первой позицией
                LD DE, FPT3Header.Delay
                ADD HL, DE
                LD A, (HL)
                LD (Play.Delay), A
                PUSH HL
                POP IX
                ADD HL, DE
                LD (PositionPtr), HL

                ; расчёт адреса позиции зацикливания по индексу из заголовка
                LD E, (IX + FPT3Header.LoopPosition - FPT3Header.Delay)
                ADD HL, DE
                INC HL
                LD (Play.LoopPosPtr), HL
                POP DE

                ; преобразование смещения таблицы потоков в адрес
                LD HL, (IX + FPT3Header.PatternOffset - FPT3Header.Delay)
                ADD HL, DE
                LD (Play.PatternTable), HL

                ; сохранение адресов таблиц смещений орнаментов и сэмплов
                LD HL, FPT3Header.OrnamentOffsets
                ADD HL, DE
                LD (Effects.OrnamentTable), HL
                LD HL, FPT3Header.SampleOffsets
                ADD HL, DE
                LD (RowCommands.SampleTable), HL

                ; новый проход модуля, сброс признака конца списка позиций
                ; флаг запрета повтора в Setup сохраняется
                LD HL, Setup
                RES PT3_FINISHED_BIT, (HL)

                ; -----------------------------------------
                ; распаковка исходных периодов нот нижней октавы
                ; -----------------------------------------
                LD DE, PackedPeriods

                ; заполнение идёт с последнего байта буфера к началу
                LD BC, PlayerState.BasePeriods + PT3_PERIOD_SIZE * PT3_PACKED_COUNT - 1
.UnpackPeriod   LD A, (DE)
                INC DE

                ; проверка, начинается ли с текущего байта полный период или приращение
                CP PT3_PACKED_DELTA_MIN
                JR NC, .AddPeriodDelta                                          ; переход, если байт содержит приращение периода

                LD H, A
                LD A, (DE)
                LD L, A
                INC DE
                JR .StorePeriod

.AddPeriodDelta ; прибавление удвоенного приращения к предыдущему периоду
                PUSH DE
                LD D, #00
                LD E, A
                ADD HL, DE
                ADD HL, DE
                POP DE

.StorePeriod    LD A, H
                LD (BC), A
                DEC BC
                LD A, L
                LD (BC), A
                DEC BC

                ; проверка младшего байта периода на признак конца распаковки
                SUB LOW PT3_PACKED_LAST_PERIOD
                JR NZ, .UnpackPeriod                                            ; переход, если младший байт периода ещё не совпал с признаком конца

                ; -----------------------------------------
                ; начальное состояние проигрывателя
                ; -----------------------------------------
                LD HL, PlayerState
                LD (HL), A
                LD DE, PlayerState+1
                LD BC, PlayerState.ClearStateEnd-PlayerState-1
                LDIR
                INC A
                LD (PlayerState.TickCounter), A
                LD HL, PT3_INIT_ROW_VOLUME
                LD (PlayerState.ChanA + FPT3Channel.RowTicks), HL
                LD (PlayerState.ChanB + FPT3Channel.RowTicks), HL
                LD (PlayerState.ChanC + FPT3Channel.RowTicks), HL

                ; подстановка пустого орнамента и сэмпла до первой команды выбора
                LD HL, EmptySampleOrn
                LD (Play.PatternPtrA), HL                                       ; нулевой байт завершает начальный поток паттерна
                LD (PlayerState.ChanA + FPT3Channel.OrnamentPtr), HL
                LD (PlayerState.ChanB + FPT3Channel.OrnamentPtr), HL
                LD (PlayerState.ChanC + FPT3Channel.OrnamentPtr), HL
                LD (PlayerState.ChanA + FPT3Channel.SamplePtr), HL
                LD (PlayerState.ChanB + FPT3Channel.SamplePtr), HL
                LD (PlayerState.ChanC + FPT3Channel.SamplePtr), HL

                ; -----------------------------------------
                ; определение версии модуля и номера таблицы
                ; -----------------------------------------
                LD A, (IX + FPT3Header.VersionDigit - FPT3Header.Delay)         ; цифра версии из заголовка
                SUB PT3_ASCII_ZERO
                JR C, .DefaultVersion                                           ; переход, если символ версии меньше ASCII-цифры 0

                ; проверка верхней границы ASCII-цифры версии после вычитания кода нуля
                CP PT3_VERSION_DIGITS
                JR C, .SaveVersion                                              ; переход, если символ версии является ASCII-цифрой

.DefaultVersion ; выбор версии по умолчанию, если символ заголовка не является цифрой
                LD A, PT3_DEFAULT_VERSION
.SaveVersion    LD (Effects.Version), A
                PUSH AF

                ; проверка, нужна ли старая таблица периодов
                CP PT3_NOTE_TABLE_MIN_VER                                       ; перенос установлен для версий ниже PT3.4
                LD A, (IX + FPT3Header.NoteTable - FPT3Header.Delay)            ; номер таблицы периодов из заголовка

                ; расчёт индекса в NoteTableParams, номер таблицы * 2 + признак старого варианта
                RLA                                                             ; перенос после сравнения попадает в бит 0
                AND PT3_NOTE_TABLE_MASK                                         ; биты 2–1 содержат номер таблицы, бит 0 выбирает вариант

; -----------------------------------------
; построение таблицы периодов нот (NoteTableCreator, Ivan Roshin)
; A - номер таблицы в битах 2–1 и вариант для старых версий в бите 0
; -----------------------------------------

                ; выбор исходных периодов и поправок по номеру таблицы и версии
                LD HL, NoteTableParams
                PUSH DE
                LD D, B
                ADD A, A    ; x2
                LD E, A
                ADD HL, DE
                LD E, (HL)
                INC HL

                ; выбор операции округления по младшему биту параметра
                SRL E
                SBC A, A
                AND PT3_OP_AND_A                                                ; #00 (NOP) or #A7 (AND A)
                LD (.NoteRoundOp), A
                EX DE, HL
                POP BC                                                          ; адрес начала распакованных периодов
                ADD HL, BC

                ; расчёт адреса списка поправок по смещению от NoteCorrections
                LD A, (DE)
                ADD A, LOW NoteCorrections
                LD C, A
                ADC A, HIGH NoteCorrections
                SUB C
                LD B, A
                PUSH BC
                LD DE, PlayerState.NotePeriods
                PUSH DE

                LD B, PT3_NOTES_PER_OCTAVE
.NextNote       ; чтение удвоенного периода очередной ноты нижней октавы
                PUSH BC                                                         ; сохранение счётчика нот в B перед загрузкой периода в BC
                LD C, (HL)                                                      ; младший байт периода
                INC HL
                PUSH HL                                                         ; после расчёта октав отсюда перейдём к следующему исходному слову
                LD B, (HL)                                                      ; старший байт периода

                ; подготовка записи периода этой ноты во все октавы
                PUSH DE                                                         ; адрес ноты в нижней октаве, нужен для перехода к следующей ноте
                EX DE, HL                                                       ; HL указывает на место записи первого периода
                ; внутри цикла HL уже сдвигается на старший байт периода
                ; поэтому до младшего байта той же ноты в следующей октаве остаётся размер октавы минус один
                LD DE, PT3_OCTAVE_BYTES - 1
                LD IXH, PT3_OCTAVE_COUNT                                        ; счётчик октав для текущей ноты

.NextOctave     ; деление периода в BC на два, первый проход даёт период нижней октавы
                SRL B
                RR C                                                            ; отброшенный младший бит остаётся в переносе

                ; выбор округления по варианту таблицы нот
                ; NOP сохраняет перенос для округления, AND A сбрасывает его для усечения
.NoteRoundOp    DB #00                                                          ; байт инструкции записывается до входа в цикл

                ; запись округлённого слова в таблицу, D равен #00
                ; BC сохраняет результат деления без округления для следующей октавы
                LD A, C
                ADC A, D                                                        ; прибавление отброшенного бита к младшему байту
                LD (HL), A
                INC HL
                LD A, B
                ADC A, D                                                        ; учёт переноса, если младший байт переполнился
                LD (HL), A

                ; переход со старшего байта периода на младший байт той же ноты в следующей октаве
                ADD HL, DE

                ; проверка, заполнены ли все октавы для текущей ноты
                DEC IXH
                JR NZ, .NextOctave                                              ; переход, если для этой ноты остались октавы

                ; переход к следующей ноте нижней октавы в выходной таблице
                POP DE                                                          ; адрес младшего байта только что записанного периода нижней октавы
                INC DE                                                          ; пропуск младшего байта записанного периода
                INC DE                                                          ; пропуск старшего байта, DE указывает на место записи следующей ноты

                ; переход к следующему исходному удвоенному периоду
                POP HL                                                          ; адрес старшего байта уже прочитанного исходного периода
                INC HL                                                          ; пропуск старшего байта, HL указывает на младший байт следующего периода
                POP BC                                                          ; восстановление счётчика нот в B
                DJNZ .NextNote

                ; восстановление адресов для применения поправок после заполнения таблицы
                POP HL                                                          ; начало готовой таблицы периодов NotePeriods
                POP DE                                                          ; начало списка поправок выбранного варианта таблицы

                ; проверка, нужна ли отдельная поправка для старой таблицы 1
                LD A, E                                                         ; младший байт адреса выбранного списка поправок
                CP LOW NoteCorrections.OldNoteFix1
                JR NZ, .ReadNoteFix                                             ; переход, если выбрана другая таблица поправок

                ; особая поправка старой таблицы 1, заменить младший байт периода ноты 23
                LD A, PT3_NOTE_FIX_LOW
                LD (PlayerState.NotePeriods + PT3_NOTE_FIX_OFFSET), A

.ReadNoteFix    ; чтение очередного байта из списка поправок выбранной таблицы
                LD A, (DE)

                ; проверка, закончился ли список поправок
                AND A
                JR Z, .NoteTableReady                                           ; переход, если прочитан нулевой маркер конца поправок

                ; выделение направления поправки из младшего бита записи
                RRA                                                             ; перенос установлен для уменьшения периода
                PUSH AF                                                         ; сохранение направления, сложение изменит перенос

                ; расчёт адреса младшего байта периода, удвоение возвращает смещение без бита направления
                ADD A, A    ; x2
                LD C, A
                ADD HL, BC
                POP AF                                                          ; восстановление направления поправки
                JR NC, .ApplyNoteFix                                            ; переход, если поправка увеличивает период

                DEC (HL)
                DEC (HL)
.ApplyNoteFix   INC (HL)

                ; возврат к началу таблицы периодов перед следующей поправкой
                AND A
                SBC HL, BC
                INC DE
                JR .ReadNoteFix

.NoteTableReady POP AF

; -----------------------------------------
; построение таблицы громкости (VolTableCreator, Ivan Roshin)
; A - цифра версии PT3, для версий 0–4 и 5 и выше используются разные расчёты
; -----------------------------------------

                ; проверка версии и подготовка расчёта для PT3.5 и новее
                CP PT3_VOLUME_MIN_VER
                LD HL, PT3_VOLUME_STEP_INIT                                     ; начальное значение генератора #11
                LD D, H
                LD E, H                                                         ; начальное значение DE равно #0000
                LD A, PT3_OP_RLA                                                ; код RLA для округления по старшему биту дробной части
                JR NC, .SetVolumeOp                                             ; переход, если модуль использует расчёт громкости PT3.5 и новее

                ; подготовка расчёта для PT3.4 и более ранних версий
                DEC L                                                           ; начальное значение HL уменьшается с #11 до #10
                LD E, L                                                         ; начальное значение DE также равно #0010
                XOR A                                                           ; код NOP, старый вариант пропускает извлечение бита округления
.SetVolumeOp    LD (.VolumeRoundOp), A

                ; начало заполнения таблицы с индекса #10, громкость канала 1 и сэмпла 0
                ; первые 16 байтов заняты буфером регистров AY и базовым периодом огибающей
                LD IX, PlayerState.VolumeTable + PT3_VOLUME_LEVELS
                LD C, PT3_VOLUME_LEVELS

                ; расчёт шага для текущего уровня громкости канала
.ChannelVolume  PUSH HL
                ADD HL, DE
                EX DE, HL
                SBC HL, HL

                ; расчёт и запись громкости для очередного уровня сэмпла
.SampleVolume   LD A, L
.VolumeRoundOp  DB #00                                                          ; перед расчётом записывается NOP или RLA
                LD A, H
                ADC A, #00
                ; запись громкости в текущую ячейку таблицы, IX указывает на неё
                LD (IX + #00), A
                INC IX                                                          ; переход к следующей ячейке таблицы громкости
                ADD HL, DE
                INC C
                LD A, C

                ; проверка, обработаны ли все #10 уровней сэмпла для текущей громкости канала
                AND PT3_VOLUME_MAX
                JR NZ, .SampleVolume                                            ; переход, если для этой громкости канала остались уровни сэмпла

                POP HL
                LD A, E

                ; проверка шага, для которого требуется поправка на единицу
                CP PT3_VOLUME_STEP_FIX
                JR NZ, .NextVolume                                              ; переход, если особая поправка шага не требуется

                INC E
.NextVolume     LD A, C

                ; проверка переполнения индекса, после последнего уровня он возвращается к нулю
                AND A
                JR NZ, .ChannelVolume                                           ; переход, если остались уровни громкости канала

                JP SetRegisters

                endif ; ~ _PLAYER_MUSIC_AY_INITIALIZE_
