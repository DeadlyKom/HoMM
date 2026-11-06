
                ifndef _PLAYER_MUSIC_AY_MUTE_
                define _PLAYER_MUSIC_AY_MUTE_
; -----------------------------------------
; обработка конца списка позиций
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   при повторе возвращает управление в Play, при остановке снимает адрес возврата и продолжает через Mute
; -----------------------------------------
CheckLoop:      ; отметка о достижении конца списка позиций
                LD HL, Setup                                                    ; проверка режима проигрывания в конце списка позиций
                SET PT3_FINISHED_BIT, (HL)

                ; проверка, запрещено ли повторное проигрывание
                BIT PT3_NO_LOOP_BIT, (HL)
                RET Z                                                           ; выход, если разрешено продолжить с позиции зацикливания

                ; выход из текущего тика через Mute и возврат счётчиков к значениям перед тиком
                POP HL
                LD HL, PlayerState.TickCounter
                INC (HL)
                LD HL, PlayerState.ChanA + FPT3Channel.RowTicks
                INC (HL)
; -----------------------------------------
; заглушение звука на трёх каналах AY
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   состояние паттерна сохраняется, SetRegisters записывает буфер AY
; -----------------------------------------
Mute:           ; обнуление громкости трёх каналов перед записью регистров AY
                XOR A
                LD H, A
                LD L, A
                LD (PlayerState.AYRegisters + AmplA), A
                LD (PlayerState.AYRegisters + AmplB), HL
                JP SetRegisters

                endif ; ~ _PLAYER_MUSIC_AY_MUTE_
