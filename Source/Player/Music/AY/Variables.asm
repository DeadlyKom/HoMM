
                ifndef _PLAYER_MUSIC_AY_VARIABLES_
                define _PLAYER_MUSIC_AY_VARIABLES_
PlayerState     ; начало рабочей области проигрывателя

.ChanA          FPT3Channel                                                     ; состояние канала A
.ChanB          FPT3Channel                                                     ; состояние канала B
.ChanC          FPT3Channel                                                     ; состояние канала C

; общее состояние проигрывателя
.TickCounter    DB #00                                                          ; счётчик тиков до следующей строки паттерна
.EnvelopeSlide  DW #0000                                                        ; накопленная поправка периода от скольжения огибающей
.EnvSlideTicks  DB #00                                                          ; счётчик тиков до шага скольжения огибающей
.NoiseState     ; пара байтов для чтения основного периода шума и поправки одним словом
.NoiseBase      DB #00                                                          ; базовый период шума из команды паттерна
.NoiseOffset    DB #00                                                          ; поправка периода шума из сэмпла

.AYRegisters    ; буфер регистров AY в первых 14 байтах области VolumeTable

.VolumeTable    DS PT3_VOLUME_TABLE_SIZE                                        ; 256 байтов, значения громкости занимают индексы #10–#FF

.EnvelopeBase   EQU .VolumeTable + PT3_AY_REG_COUNT                             ; базовый период огибающей в байтах 14 и 15 области VolumeTable

.BasePeriods    EQU .VolumeTable + PT3_VOLUME_LEVELS                            ; временные распакованные периоды в области VolumeTable с байта 16

.OldPeriods1    EQU .BasePeriods
.OldPeriods2    EQU .OldPeriods1 + PT3_OCTAVE_BYTES
.OldPeriods3    EQU .OldPeriods2 + PT3_OCTAVE_BYTES
.OldPeriods0    EQU .OldPeriods3 + PT3_PERIOD_SIZE
.NewPeriods0    EQU .OldPeriods0
.NewPeriods1    EQU .OldPeriods1
.NewPeriods2    EQU .NewPeriods0 + PT3_OCTAVE_BYTES
.NewPeriods3    EQU .OldPeriods3

.NotePeriods    DS PT3_NOTE_TABLE_BYTES                                         ; 96 двухбайтовых периодов нот, заполняются при инициализации

.ChannelVolume  EQU .AYRegisters+AmplC                                          ; временный результат расчёта громкости, совпадает с регистром громкости C в буфере

.ClearStateEnd  EQU .VolumeTable + PT3_VOLUME_LEVELS                            ; граница очистки рабочего состояния при Initialize

.PlayerStateEnd EQU $                                                           ; конец рабочей области проигрывателя

                endif ; ~ _PLAYER_MUSIC_AY_VARIABLES_
