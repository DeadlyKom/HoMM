
                ifndef _PLAYER_MUSIC_AY_INCLUDE_
                define _PLAYER_MUSIC_AY_INCLUDE_
; -----------------------------------------
; Vortex Tracker II v1.0 PT3 player for ZX Spectrum
; (c)2004,2007 S.V.Bulba <vorobey@mail.khstu.ru>
; http://bulba.untergrund.net (http://bulba.at.kz)
; -----------------------------------------

; -----------------------------------------
; порядок работы проигрывателя
;
;   Initialize читает заголовок модуля, настраивает адреса потоков
;   и строит таблицы периодов нот и громкости.
;
;   Play выполняется один раз за музыкальный тик.
;   Когда истекает задержка строки, он выбирает потоки текущего
;   паттерна и вызывает DecodeRow для каналов, у которых истёк
;   собственный счётчик строк.
;
;   DecodeRow читает команды канала. Дополнительные эффекты
;   выполняются через таблицу Effects.EffectTable в конце строки.
;
;   RenderChannel вызывается на каждом тике для всех трёх каналов.
;   Он читает орнамент и сэмпл, рассчитывает тон и громкость
;   и добавляет состояние канала в общий микшер.
;
;   Play собирает общие значения шума и огибающей. WriteAY
;   передаёт собранные значения в регистры AY.
; -----------------------------------------

                module AY
                include "Const.inc"
                include "Structs.inc"

Begin           EQU $
                include "Settings.asm"
                include "Mute.asm"
                include "Initialize.asm"
                include "DecodeRow.asm"
                include "Effects.asm"
                include "RenderChannel.asm"
                include "Play.asm"                                              ; (0) расчёт тика
                include "WriteAY.asm"                                           ; (1) продолжение Play.asm
                include "Tables.asm"
                include "Variables.asm"
Size            EQU $-Begin
                display " - PT3 Player:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " bytes  ]"
                endmodule

                endif ; ~ _PLAYER_MUSIC_AY_INCLUDE_
