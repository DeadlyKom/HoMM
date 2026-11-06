
                ifndef _PLAYER_MUSIC_AY_TABLES_
                define _PLAYER_MUSIC_AY_TABLES_
; -----------------------------------------
; выбор периода и поправок по номеру таблицы и версии PT3
;   первый байт, удвоенное смещение исходных периодов от BasePeriods
;   бит 0 первого байта выбирает правило округления при делении периода
;   второй байт, смещение списка поправок от NoteCorrections
; -----------------------------------------
NoteTableParams DB (PlayerState.NewPeriods0-PlayerState.BasePeriods)*2          ; пары байтов для выбора исходных периодов и таблицы поправок по версии PT3
                DB NoteCorrections.NewNoteFix0-NoteCorrections
                DB (PlayerState.OldPeriods0-PlayerState.BasePeriods)*2+1
                DB NoteCorrections.OldNoteFix0-NoteCorrections
                DB (PlayerState.NewPeriods1-PlayerState.BasePeriods)*2+1
                DB NoteCorrections.NewNoteFix1-NoteCorrections
                DB (PlayerState.OldPeriods1-PlayerState.BasePeriods)*2+1
                DB NoteCorrections.OldNoteFix1-NoteCorrections
                DB (PlayerState.NewPeriods2-PlayerState.BasePeriods)*2
                DB NoteCorrections.NewNoteFix2-NoteCorrections
                DB (PlayerState.OldPeriods2-PlayerState.BasePeriods)*2
                DB NoteCorrections.OldNoteFix2-NoteCorrections
                DB (PlayerState.NewPeriods3-PlayerState.BasePeriods)*2
                DB NoteCorrections.NewNoteFix3-NoteCorrections
                DB (PlayerState.OldPeriods3-PlayerState.BasePeriods)*2
                DB NoteCorrections.OldNoteFix3-NoteCorrections
; -----------------------------------------
; списки поправок к периодам для старых и новых вариантов таблиц
;   нулевой байт завершает список
;   байт без младшего бита задаёт смещение младшего байта периода от NotePeriods
;   бит 0 выбирает поправку, 0 - прибавить 1, 1 - вычесть 1
; -----------------------------------------
NoteCorrections ; начало таблиц поправок к периодам нот
.OldNoteFix0    DB #00+1, #04+1, #08+1, #0A+1, #0C+1, #0E+1, #12+1, #14+1
                DB #18+1, #24+1, #3C+1, #00
.OldNoteFix1    DB #5C+1, #00
.OldNoteFix2    DB #30+1, #36+1, #4C+1, #52+1, #5E+1, #70+1, #82, #8C, #9C
                DB #9E, #A0, #A6, #A8, #AA, #AC, #AE, #AE, #00
.NewNoteFix3    DB #56+1
.OldNoteFix3    DB #1E+1, #22+1, #24+1, #28+1, #2C+1, #2E+1, #32+1, #BE+1, #00
.NewNoteFix0    DB #1C+1, #20+1, #22+1, #26+1, #2A+1, #2C+1, #30+1, #54+1
                DB #BC+1, #BE+1, #00
.NewNoteFix1    EQU .OldNoteFix1
.NewNoteFix2    DB #1A+1, #20+1, #24+1, #28+1, #2A+1, #3A+1, #4C+1, #5E+1
                DB #BA+1, #BC+1, #BE+1, #00
                ; общий заголовок пустого орнамента и сэмпла, позиция зацикливания #00 и длина #01
                ; предыдущий #00 также служит признаком конца начального потока паттерна
EmptySampleOrn  EQU $-1                                                         ; адрес предыдущего нулевого байта, позиция зацикливания
                ; первый байт задаёт длину, второй задаёт нулевую поправку ноты орнамента
                ; у сэмпла второй байт является первым управляющим байтом
                DB 1, 0, #90                                                    ; #90 отключает тон и шум пустого сэмпла
; -----------------------------------------
; исходные удвоенные периоды, упакованные по группам
;   первый период группы записан старшим байтом вперёд
;   следующие байты задают половину приращения к предыдущему периоду
; -----------------------------------------
PackedPeriods   DB #06EC*2/256, (#06EC*2) & 0xFF                                ; упакованные удвоенные периоды нот нижней октавы
                DB #0755-#06EC
                DB #07C5-#0755
                DB #083B-#07C5
                DB #08B8-#083B
                DB #093D-#08B8
                DB #09CA-#093D
                DB #0A5F-#09CA
                DB #0AFC-#0A5F
                DB #0BA4-#0AFC
                DB #0C55-#0BA4
                DB #0D10-#0C55
                DB #066D*2/256, (#066D*2) & 0xFF
                DB #06CF-#066D
                DB #0737-#06CF
                DB #07A4-#0737
                DB #0819-#07A4
                DB #0894-#0819
                DB #0917-#0894
                DB #09A1-#0917
                DB #0A33-#09A1
                DB #0ACF-#0A33
                DB #0B73-#0ACF
                DB #0C22-#0B73
                DB #0CDA-#0C22
                DB #0704*2/256, (#0704*2) & 0xFF
                DB #076E-#0704
                DB #07E0-#076E
                DB #0858-#07E0
                DB #08D6-#0858
                DB #095C-#08D6
                DB #09EC-#095C
                DB #0A82-#09EC
                DB #0B22-#0A82
                DB #0BCC-#0B22
                DB #0C80-#0BCC
                DB #0D3E-#0C80
                DB #07E0*2/256, (#07E0*2) & 0xFF
                DB #0858-#07E0
                DB #08E0-#0858
                DB #0960-#08E0
                DB #09F0-#0960
                DB #0A88-#09F0
                DB #0B28-#0A88
                DB #0BD8-#0B28
                DB #0C80-#0BD8
                DB #0D60-#0C80
                DB #0E10-#0D60
                DB #0EF8-#0E10

                endif ; ~ _PLAYER_MUSIC_AY_TABLES_
