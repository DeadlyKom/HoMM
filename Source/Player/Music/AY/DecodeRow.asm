
                ifndef _PLAYER_MUSIC_AY_DECODEROW_
                define _PLAYER_MUSIC_AY_DECODEROW_
; -----------------------------------------
; обработка команд строки паттерна
; In:
;   E  - маска включения огибающей для команд её настройки
;   BC - адрес первого непрочитанного байта потока
;   A  - параметр команды после определения её группы
;   IX - адрес поля GateOffDelay в состоянии канала
;   флаг нуля установлен, если в .ReadEnvSample передана команда отключения огибающей #10
; Out:
;   BC - адрес следующей команды после прочитанных параметров
; Corrupt:
;   HL, DE, AF
; Note:
;   обработчики продолжают чтение через DecodeRow.ReadCommand или DecodeRow.DecodeNext
;   DecodeNext восстанавливает шаги распознавания команд в DE
;   границы групп команд описаны в Const.inc
;   период огибающей записан старшим байтом вперёд
;   команды #10–#1F и #F0–#FF хранят удвоенный номер сэмпла в отдельном байте
;   нулевой байт в начале строки канала A проверяет Play как конец паттерна
; -----------------------------------------
RowCommands     ; обработчики команд строки паттерна
.ReadOrnSample  LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.EnvelopeMask), #00

                ; -----------------------------------------
                ; выбор орнамента и возврат к его началу
                ; In:
                ;   A  - номер орнамента
                ;   IX - адрес поля GateOffDelay в состоянии канала
                ; Out:
                ;   OrnamentPtr - адрес выбранного орнамента в состоянии канала
                ;   OrnamentPos - #00, позиция первой строки орнамента
                ; Corrupt:
                ;   HL, DE, AF
                ; -----------------------------------------
                CALL Effects.SetOrnament

                ; чтение удвоенного номера сэмпла из потока
                LD A, (BC)
                INC BC
                RRCA

                ; расчёт смещения слова в таблице сэмплов
.SelectSample   ADD A, A    ; x2
.LoadSample     LD E, A
                LD D, #00

                ; чтение относительного смещения сэмпла из таблицы
                ; DE содержит смещение записи в таблице, после чтения в DE будет смещение сэмпла от начала модуля
.SampleTable    EQU $+1                                                         ; операнд с адресом таблицы смещений сэмплов
                LD HL, #0000
                ADD HL, DE
                LD E, (HL)                                                      ; младший байт смещения сэмпла
                INC HL
                LD D, (HL)                                                      ; старший байт смещения сэмпла

                ; расчёт абсолютного адреса сэмпла, HL = база модуля + смещение в DE
.ModuleBase     EQU $+1                                                         ; Initialize записывает сюда адрес начала загруженного модуля
                LD HL, #0000
                ADD HL, DE

                ; сохранение адреса сэмпла в состоянии текущего канала
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.SamplePtr), HL
                JR DecodeRow.DecodeNext                                         ; продолжение чтения команд строки после выбора сэмпла

                ; перенос громкости канала в старшую половину байта индекса
.SetVolume      RLCA
                RLCA
                RLCA
                RLCA
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.Volume), A
                JR DecodeRow.ReadCommand

                ; отключение огибающей и возврат орнамента к началу
.DisableEnv     LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.EnvelopeMask), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.OrnamentPos), A
                JR DecodeRow.ReadCommand

                ; различение команды задержки строк и команды формы огибающей
.ReadSkipOrEnv  DEC A
                JR NZ, .ReadEnvelope                                            ; переход, если команда задаёт огибающую

                ; чтение числа строк до следующей команды канала
                LD A, (BC)
                INC BC
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.RowDelay), A
                JR DecodeRow.ReadCommand

.ReadEnvelope   ; -----------------------------------------
                ; установка новой формы и периода огибающей
                ; In:
                ;   E  - маска включения огибающей канала
                ;   BC - адрес двух байтов периода, старший байт первым
                ;   A  - номер формы огибающей для R13
                ;   IX - адрес поля GateOffDelay в состоянии канала
                ; Out:
                ;   BC - адрес следующей команды строки
                ; Corrupt:
                ;   HL, AF
                ; Note:
                ;   включается огибающая канала, сбрасываются позиция орнамента и скольжение огибающей
                ; -----------------------------------------
                CALL Effects.SetEnvelope
                JR DecodeRow.ReadCommand                                        ; продолжение чтения команд той же строки

.ReadOrnament   ; -----------------------------------------
                ; выбор орнамента и возврат к его началу
                ; In:
                ;   A  - номер орнамента
                ;   IX - адрес поля GateOffDelay в состоянии канала
                ; Out:
                ;   OrnamentPtr - адрес выбранного орнамента в состоянии канала
                ;   OrnamentPos - #00, позиция первой строки орнамента
                ; Corrupt:
                ;   HL, DE, AF
                ; -----------------------------------------
                CALL Effects.SetOrnament
                JR DecodeRow.DecodeNext

                ; проверка, задана ли форма огибающей перед чтением номера сэмпла
.ReadEnvSample  LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.EnvelopeMask), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.OrnamentPos), A

                ; -----------------------------------------
                ; настройка огибающей перед выбором сэмпла
                ; In:
                ;   E  - маска включения огибающей канала
                ;   BC - адрес периода огибающей при ненулевой форме
                ;   A  - номер формы огибающей для R13
                ;   IX - адрес поля GateOffDelay в состоянии канала
                ;   флаг нуля установлен, если команда отключает огибающую
                ; Out:
                ;   BC - адрес байта с удвоенным номером сэмпла
                ; Corrupt:
                ;   HL, AF при выполнении вызова
                ; -----------------------------------------
                CALL NZ, Effects.SetEnvelope                                    ; вызов, если команда задаёт ненулевую форму огибающей

                ; чтение удвоенного номера сэмпла после параметров огибающей
                LD A, (BC)
                INC BC
                JR .LoadSample
; -----------------------------------------
; декодирование строки паттерна одного канала
; In:
;   BC - адрес команды в потоке паттерна
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес следующей команды после строки и параметров эффектов
; Corrupt:
;   HL, DE, AF, AF'
; Note:
;   адреса обработчиков кладутся на стек и выполняются в обратном порядке после конца строки
;   при сбросе состояния SP временно указывает на структуру канала
; -----------------------------------------
DecodeRow:      ; сохранение исходной ноты и скольжения для портаменто
                LD A, (IX - FPT3Channel.GateOffDelay + FPT3Channel.Note)        ; чтение команд строки канала, BC указывает на поток, IX указывает на поле GateOffDelay
                LD (Effects.PreviousNote), A
                LD HL, (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlide)
                LD (Effects.PreviousSlide), HL

                ; -----------------------------------------
                ; распознавание команд строки
                ; -----------------------------------------
.DecodeNext     LD DE, PT3_CMD_STEPS

                ; чтение байта и определение группы команды по переносу при сложении
.ReadCommand    LD A, (BC)                                                      ; распознавание команды по диапазону байта, перенос отмечает границу диапазона
                INC BC

                ; проверка диапазона совмещённой команды орнамента и сэмпла
                ADD A, E
                JR C, RowCommands.ReadOrnSample                                 ; переход, если команда задаёт орнамент и сэмпл

                ; проверка команд #D0–#EF, ноль означает конец строки, перенос означает выбор сэмпла
                ADD A, D
                JR Z, .FinishRow                                                ; переход, если достигнут конец строки
                JR C, RowCommands.SelectSample                                  ; переход, если команда выбирает сэмпл

                ; проверка команд #C0–#CF, ноль означает выключение ноты, перенос означает установку громкости
                ADD A, E
                JR Z, .ReleaseNote                                              ; переход, если команда выключает ноту
                JR C, RowCommands.SetVolume                                     ; переход, если команда задаёт громкость канала

                ; проверка команд #B0–#BF, ноль означает выключение огибающей, перенос означает чтение параметров
                ADD A, E
                JR Z, RowCommands.DisableEnv                                    ; переход, если команда выключает огибающую
                JR C, RowCommands.ReadSkipOrEnv                                 ; переход, если команда задаёт интервал строк или огибающую

                ; проверка диапазона номеров нот
                ADD A, PT3_CMD_NOTE_COUNT
                JR C, .StartNote                                                ; переход, если команда задаёт ноту

                ; проверка диапазона номеров орнаментов
                ADD A, E
                JR C, RowCommands.ReadOrnament                                  ; переход, если команда выбирает орнамент

                ; проверка диапазона значений базового периода шума
                ADD A, D
                JR C, .SetNoise                                                 ; переход, если команда задаёт базовый период шума

                ; проверка диапазона совмещённой команды огибающей и сэмпла
                ADD A, E
                JR C, RowCommands.ReadEnvSample                                 ; переход, если команда задаёт огибающую и сэмпл

                ; преобразование кода дополнительной команды в смещение слова
                ADD A, A    ; x2
                LD E, A

                ; компенсация смещения индекса после сложений и сохранение адреса обработчика на стеке
                LD HL, (Effects.EffectTable - PT3_EFFECT_INDEX_BIAS) & 0xFFFF
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                PUSH DE
                JR .DecodeNext
                ; -----------------------------------------
                ; обновление состояния канала
                ; -----------------------------------------
.SetNoise       LD (PlayerState.NoiseBase), A
                JR .ReadCommand

.ReleaseNote    RES PT3_NOTE_ON_BIT, (IX - FPT3Channel.GateOffDelay + FPT3Channel.Flags)
                JR .ResetNoteState

.StartNote      LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.Note), A
                SET PT3_NOTE_ON_BIT, (IX - FPT3Channel.GateOffDelay + FPT3Channel.Flags)
                XOR A

.ResetNoteState ; сброс первых 12 байтов канала через временный стек
                LD (.ContainerSP), SP
                LD SP, IX
                LD H, A
                LD L, A
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
                PUSH HL
.ContainerSP    EQU $+1
                LD SP, #0000                                                    ; восстановление SP после сброса полей канала через стек

                ; загрузка счётчика строк перед выполнением отложенных эффектов
.FinishRow      LD A, (IX - FPT3Channel.GateOffDelay + FPT3Channel.RowDelay)
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.RowTicks), A
                RET

                endif ; ~ _PLAYER_MUSIC_AY_DECODEROW_
