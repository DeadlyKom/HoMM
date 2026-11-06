
                ifndef _PLAYER_MUSIC_AY_EFFECTS_
                define _PLAYER_MUSIC_AY_EFFECTS_
; -----------------------------------------
; настройка портаменто к новой ноте
; In:
;   BC - адрес параметров в потоке паттерна
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес после прочитанных параметров
; Corrupt:
;   HL, DE, AF, AF'
; Note:
;   читает пять байтов параметров, пересчитывает разность периодов
; -----------------------------------------
Effects         ; обработчики дополнительных команд PT3
.SetPortamento  ; переключение на скольжение с остановкой на целевой ноте
                RES PT3_GLISSANDO_BIT, (IX - FPT3Channel.GateOffDelay + FPT3Channel.Flags)

                ; чтение первого параметра команды #02, интервал между шагами портаменто в тиках
                LD A, (BC)
                INC BC

                ; пропуск двухбайтовой разности периодов, записанной в параметрах портаменто
                ; проигрыватель рассчитывает разность заново по текущей таблице нот
                INC BC                                                          ; пропуск младшего байта разности, смещение +1 от начала параметров
                INC BC                                                          ; пропуск старшего байта разности, BC указывает на младший байт шага
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideDelay), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideTicks), A

                ; -----------------------------------------
                ; расчёт разности периодов
                ; -----------------------------------------
                ; поиск периода целевой ноты в таблице
                LD DE, PlayerState.NotePeriods
                LD A, (IX - FPT3Channel.GateOffDelay + FPT3Channel.Note)
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.TargetNote), A
                ADD A, A    ; x2
                LD L, A
                LD H, #00
                ADD HL, DE
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A
                PUSH HL

                ; восстановление исходной ноты и поиск её периода
.PreviousNote   EQU $+1
                LD A, #00
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.Note), A
                ADD A, A    ; x2
                LD L, A
                LD H, #00
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                POP HL

                ; расчёт разности периодов целевой и исходной нот
                SBC HL, DE
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.TargetToneDelta), HL
                LD DE, (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlide)
.Version        EQU $+1                                                         ; операнд с цифрой версии PT3, используется обработчиками скольжения
                LD A, #00

                ; -----------------------------------------
                ; выбор направления и сохранение шага
                ; -----------------------------------------
                ; проверка версии для восстановления накопленного скольжения
                CP PT3_PORTAMENTO_MIN_VER
                JR C, .ReadToneStep                                             ; переход, если версия ниже PT3.6 и предыдущая поправка тона не восстанавливается

                ; восстановление поправки тона, действовавшей до чтения новой ноты
.PreviousSlide  EQU $+1                                                         ; DecodeRow сохраняет здесь предыдущую поправку ToneSlide
                LD DE, #0000
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlide), DE

.ReadToneStep   ; чтение знакового шага изменения периода тона из двух байтов
                LD A, (BC)                                                      ; младший байт шага
                INC BC
                EX AF, AF'                                                      ; сохранение младшего байта в A' для записи после проверки знака
                LD A, (BC)                                                      ; старший байт шага
                INC BC                                                          ; BC указывает на следующий байт потока

                ; проверка старшего байта знакового шага
                AND A
                JR Z, .CheckDirection                                           ; переход, если старший байт шага нулевой

                EX DE, HL

                ; проверка, ведёт ли шаг к целевому периоду
.CheckDirection SBC HL, DE
                JP P, .SaveToneStep                                             ; переход, если направление шага подходит для достижения целевого периода

                ; разворот шага скольжения в сторону целевой ноты
                CPL
                EX AF, AF'
                NEG
                EX AF, AF'

                ; сохранение шага тона и отключение периодических пауз канала
.SaveToneStep   LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideStep + 1), A
                EX AF, AF'
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideStep), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.GateTicks), #00
                RET
; -----------------------------------------
; настройка скольжения тона без целевой ноты
; In:
;   BC - адрес параметров в потоке паттерна
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес после прочитанных параметров
; Corrupt:
;   AF, AF'
; Note:
;   читает три байта параметров, использует общий хвост SaveToneStep
; -----------------------------------------
.SetGlissando   ; включение скольжения без целевой ноты
                SET PT3_GLISSANDO_BIT, (IX - FPT3Channel.GateOffDelay + FPT3Channel.Flags)

                ; чтение первого параметра команды #01, интервал между шагами глиссандо в тиках
                LD A, (BC)
                INC BC
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideDelay), A

                ; проверка, задана ли ненулевая задержка шага
                AND A
                JR NZ, .SaveSlideDelay                                          ; переход, если задержка шага ненулевая

                LD A, (.Version)                                                ; для PT3.7 и новее нулевая задержка запускает скольжение

                ; выбор начального счётчика при нулевой задержке
                ; до PT3.7 перенос даёт #FF после SBC и #00 после INC, скольжение выключено
                ; с PT3.7 без переноса счётчик становится #01, первый шаг выполняется в этом тике
                CP PT3_GLISS_ZERO_MIN_VER
                SBC A, A
                INC A

.SaveSlideDelay ; запуск счётчика до первого шага глиссандо
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideTicks), A

                ; чтение знакового шага периода тона, младший байт первым
                LD A, (BC)                                                      ; младший байт шага
                INC BC
                EX AF, AF'                                                      ; младший байт остаётся в A', пока читается старший
                LD A, (BC)                                                      ; старший байт шага
                INC BC                                                          ; BC указывает на следующий байт потока
                JR .SaveToneStep                                                ; сохранение шага и отключение периодических пауз канала
; -----------------------------------------
; установка позиции чтения сэмпла
; In:
;   BC - адрес параметров в потоке паттерна
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес после прочитанных параметров
; Corrupt:
;   AF
; Note:
;   читает один байт
; -----------------------------------------
.SetSamplePos   ; чтение индекса строки сэмпла, с которой продолжится проигрывание
                LD A, (BC)
                INC BC
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.SamplePos), A
                RET
; -----------------------------------------
; установка позиции чтения орнамента
; In:
;   BC - адрес параметров в потоке паттерна
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес после прочитанных параметров
; Corrupt:
;   AF
; Note:
;   читает один байт
; -----------------------------------------
.SetOrnPos      ; чтение индекса строки орнамента, с которой продолжится проигрывание
                LD A, (BC)
                INC BC
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.OrnamentPos), A
                RET
; -----------------------------------------
; настройка чередования звучания и паузы
; In:
;   BC - адрес параметров в потоке паттерна
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес после прочитанных параметров
; Corrupt:
;   AF
; Note:
;   читает два байта, сбрасывает скольжение тона
; -----------------------------------------
.SetVibrato     ; чтение длительности звучания канала в тиках
                LD A, (BC)
                INC BC
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.GateOnDelay), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.GateTicks), A   ; первый отсчёт начинается с длительности звучания

                ; чтение длительности паузы канала в тиках
                LD A, (BC)
                INC BC
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.GateOffDelay), A

                ; сброс счётчика и накопленной поправки скольжения тона
                XOR A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlideTicks), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlide), A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.ToneSlide + 1), A
                RET
; -----------------------------------------
; настройка скольжения огибающей
; In:
;   BC - адрес интервала и знакового шага в потоке паттерна
; Out:
;   BC - адрес следующего байта после трёх байтов параметров
; Corrupt:
;   HL, AF
; Note:
;   нулевой интервал выключает скольжение, накопленная поправка сохраняется
; -----------------------------------------
.SetEnvSlide    ; -----------------------------------------
                ; интервал между шагами огибающей
                ; -----------------------------------------
                LD A, (BC)                                                      ; интервал в тиках
                INC BC
                LD (Play.EnvSlideDelay), A                                      ; интервал для перезагрузки счётчика после каждого шага
                LD (PlayerState.EnvSlideTicks), A                               ; запуск первого отсчёта с того же интервала

                ; -----------------------------------------
                ; знаковый шаг изменения периода огибающей
                ; -----------------------------------------
                LD A, (BC)                                                      ; младший байт шага
                INC BC
                LD L, A
                LD A, (BC)                                                      ; старший байт шага
                INC BC
                LD H, A
                LD (Play.EnvSlideStep), HL                                      ; шаг, который Play прибавляет при истечении счётчика
                RET
; -----------------------------------------
; смена задержки между строками паттерна
; In:
;   BC - адрес параметров в потоке паттерна
; Out:
;   BC - адрес после прочитанных параметров
; Corrupt:
;   AF
; Note:
;   читает один байт, обновляет операнд Delay
; -----------------------------------------
.SetDelay       ; чтение нового интервала между строками паттерна в тиках
                LD A, (BC)
                INC BC
                LD (Play.Delay), A
                RET
; -----------------------------------------
; установка огибающей
; In:
;   E  - маска включения огибающей
;   BC - адрес периода в потоке паттерна
;   A  - номер формы огибающей
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
;   BC - адрес после двух байтов периода
;   в состоянии канала установлена маска огибающей, позиция орнамента сброшена
;   в буфер R13 записана новая форма, обновлён базовый период огибающей
;   счётчик и накопленная поправка скольжения огибающей сброшены
; Corrupt:
;   HL, AF
; Note:
;   период в потоке хранится старшим байтом вперёд
; -----------------------------------------
.SetEnvelope    ; включение огибающей канала и сохранение формы для R13
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.EnvelopeMask), E
                LD (PlayerState.AYRegisters + EnvTp), A

                ; чтение базового периода огибающей, старший байт первым
                LD A, (BC)                                                      ; старший байт периода
                INC BC
                LD H, A
                LD A, (BC)                                                      ; младший байт периода
                INC BC
                LD L, A
                LD (PlayerState.EnvelopeBase), HL

                ; возврат к началу орнамента и сброс предыдущего скольжения огибающей
                XOR A
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.OrnamentPos), A
                LD (PlayerState.EnvSlideTicks), A
                LD H, A
                LD L, A
                LD (PlayerState.EnvelopeSlide), HL
; -----------------------------------------
; выход для команд без обработчика
; In:
; Out:
; Corrupt:
; Note:
;   адрес также служит выходом из SetEnvelope
; -----------------------------------------
.SkipEffect     RET
; -----------------------------------------
; выбор орнамента
; In:
;   A  - номер орнамента
;   IX - адрес поля GateOffDelay в состоянии канала
; Out:
; Corrupt:
;   HL, DE, AF
; Note:
;   адрес сохраняется в OrnamentPtr, позиция чтения OrnamentPos сбрасывается
; -----------------------------------------
.SetOrnament    ; расчёт смещения слова в таблице орнаментов
                ADD A, A    ; x2
                LD E, A
                LD D, #00
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.OrnamentPos), D ; начало чтения выбранного орнамента с позиции #00

                ; чтение смещения орнамента от начала модуля
.OrnamentTable  EQU $+1                                                         ; операнд с адресом таблицы смещений орнаментов
                LD HL, #0000
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)

                ; расчёт и сохранение абсолютного адреса орнамента в состоянии канала
.OrnModuleBase  EQU $+1                                                         ; операнд с базовым адресом модуля для смещений орнаментов
                LD HL, #0000
                ADD HL, DE
                LD (IX - FPT3Channel.GateOffDelay + FPT3Channel.OrnamentPtr), HL
                RET
; -----------------------------------------
; параметры дополнительных команд PT3 по кодам
;   все 16 кодов имеют обработчик, незадействованные команды завершаются через SkipEffect
;
;   #01 - задержка шага, знаковый шаг периода тона
;   #02 - задержка шага, сохранённая разность периодов, знаковый шаг тона
;   #03 - начальная позиция сэмпла
;   #04 - начальная позиция орнамента
;   #05 - длительность звучания, длительность паузы
;   #08 - задержка шага, знаковый шаг периода огибающей
;   #09 - число тиков между строками
;   Остальные коды не читают параметры.
;
;   Задержки и позиции занимают по одному байту, шаги по два байта
;   младшим байтом вперёд. Сохранённую разность для #02 проигрыватель
;   пропускает и рассчитывает её по выбранной таблице нот.
; -----------------------------------------
.EffectTable    DW .SkipEffect                                                  ; таблица адресов обработчиков дополнительных команд PT3 по кодам 0–15
                DW .SetGlissando
                DW .SetPortamento
                DW .SetSamplePos
                DW .SetOrnPos
                DW .SetVibrato
                DW .SkipEffect
                DW .SkipEffect
                DW .SetEnvSlide
                DW .SetDelay
                DW .SkipEffect
                DW .SkipEffect
                DW .SkipEffect
                DW .SkipEffect
                DW .SkipEffect
                DW .SkipEffect

                endif ; ~ _PLAYER_MUSIC_AY_EFFECTS_
