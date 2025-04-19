
                ifndef _MEMORY_COPY_PAGES_
                define _MEMORY_COPY_PAGES_

                module Memcpy
; -----------------------------------------
; копирование данных из страницы, находясь в другой странице
; In:
;   A  - страница исходного кода
;   A' - страница назначения
;   HL - адрес буфера
;   DE - адрес назначения
;   BC - длина блока
; Out:
; Corrupt:
; Note:
;   после копирования в буфер, вернёт исходную страницу
; -----------------------------------------
FromPage:       PUSH AF
                EX AF, AF'
                PUSH BC
                SET_PAGE_A
                POP BC
                CALL Memcpy.FastLDIR
                POP AF
                JP_PAGE_A
; -----------------------------------------
; копирование данных между страницами
; In:
;   A HL - адрес исходника  (аккумулятор страница)
;   A'DE - адрес назначения (аккумулятор страница)
;   BC   - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
BetweenPages:   ; инициализация
                LD (.SourcePage), A
                EX AF, AF'
                LD (.DestinationPage), A

.Loop           PUSH HL                                                         ; сохранение адреса исходника

                ; проверка превышения размера буфера
                LD HL, -.BUFFER_SIZE
                ADD HL, BC
                JR C, .FullBuf                                                  ; переход, если копируемый блок больше размера буфера
                
                LD HL, #0000
                JR .Memcopy

.FullBuf        LD BC, .BUFFER_SIZE                                             ; копирование займёт весь буфер
.Memcopy        LD (.Remainder), HL                                             ; сохраним остаток
                PUSH BC                                                         ; сохранение размера копируемого блока

                ; установка страницы исходника
.SourcePage     EQU $+1
                LD A, #00
                SET_PAGE_A

                POP BC
                POP HL                                                          ; восстановление адреса исходника
                PUSH DE                                                         ; сохранение адреса назначения
                PUSH BC

                ; -----------------------------------------
                ; копирование данных
                ; In:
                ;   HL - адрес исходника
                ;   DE - адрес назначения
                ;   BC - длина блока
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                LD DE, .BUFFER
                CALL Memcpy.FastLDIR

                LD (.AdrSource), HL                                             ; сохранение адреса исходника (обновлённый)

.DestinationPage EQU $+1
                LD A, #00
                SET_PAGE_A

                POP BC                                                          ; восстановление размера копируемого блока
                POP DE

                ; -----------------------------------------
                ; копирование данных
                ; In:
                ;   HL - адрес исходника
                ;   DE - адрес назначения
                ;   BC - длина блока
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                LD HL, .BUFFER
                CALL Memcpy.FastLDIR

                LD (.AdrDestination), DE                                        ; сохранение адреса назначения (обновлённый)

                ; проверка необходимости дальнейшего копирования
.Remainder      EQU $+1
                LD BC, #0000
                LD A, B
                OR C
                RET Z

.AdrSource      EQU $+1
                LD HL, #0000
.AdrDestination EQU $+1
                LD DE, #0000
                JR .Loop

.BUFFER         EQU Adr.ExtraBuffer                                             ; адрес буфера
.BUFFER_SIZE    EQU #0400                                                       ; размер буфера

                display " - Memcpy pages:\t\t\t\t\t", /A, FromPage, "\t= busy [ ", /D, $ - FromPage, " byte(s)  ]"

                endmodule

                endif ; ~_MEMORY_COPY_PAGES_
