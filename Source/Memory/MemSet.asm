
                ifndef _MEMORY_SET_
                define _MEMORY_SET_

                module Memset
Begin:          EQU $
; -----------------------------------------
; заполнение блока памяти
; In:
;   HL  - адрес блока памяти для заполнения
;   DE  - значение для заполнения
; Out:
; Corrupt:
;   HL, DE, AF, IX
; Note:
;   адрес блока должен учитываться с размером заполняемой области
;   т.к. заполнение происходит используя стек и PUSH
; -----------------------------------------
SafeFill_512:   RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
                JP MemSet_512
SafeFill_256:   RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
                JP MemSet_256
SafeFill_192:   RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
                JP MemSet_192
SafeFill_128:   RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
                JP MemSet_128
SafeFill_64:    RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
                JP MemSet_64
SafeFill_32:    RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
                JP MemSet_32
SafeFill_Screen LD IX, MemSet_768                                               ; 768 * 6 = 6144
                JR SafeFill
SafeFill_4096:  LD IX, MemSet_512                                               ; 512 * 8 = 4096
                JR SafeFill
SafeFill_2048:  LD IX, MemSet_256                                               ; 256 * 8 = 2048
                JR SafeFill
SafeFill_1024:  LD IX, MemSet_128                                               ; 128 * 8 = 1024
; -----------------------------------------
; вызов 8 цепочек функции заполнении
; In:
;   HL  - адрес блока памяти для заполнения
;   DE  - значение для заполнения
;   IX  - адрес функции заполнения
; Out:
; Corrupt:
;   HL, DE, AF, IX
; Note:
;   адрес блока должен учитываться с размером заполняемой области
;   т.к. заполнение происходит используя стек и PUSH
; -----------------------------------------
SafeFill:       RestoreDE
                LD (.ContainerSP), SP
                LD SP, HL
                LD A, #23                                                       ; INC HL
                LD (MS_ContainerSP - 1), A
                LD (MS_ContainerSP + 0), A
                LD A, #E9                                                       ; JP (HL)
                LD (MS_ContainerSP + 1), A
                LD HL, .Jumps
.Jumps          dup 7
                JP (IX)
                edup
                LD A, #31
                LD (MS_ContainerSP - 1), A
.ContainerSP    EQU $+1
                LD HL, #0000
                LD (MS_ContainerSP + 0), HL
                JP (IX)
SafeFill_768:   ; 768
                RestoreDE
                LD (MS_ContainerSP), SP
                LD SP, HL
MemSet_768:     dup 128                                                         ; 128 * 2 = 256 byte(s)
                PUSH DE
                edup
MemSet_512:     dup 128                                                         ; 128 * 2 = 256 byte(s)
                PUSH DE
                edup
MemSet_256:     dup 32                                                          ; 32 * 2  = 64 byte(s)
                PUSH DE
                edup
MemSet_192:     dup 32                                                          ; 32 * 2  = 64 byte(s)
                PUSH DE
                edup
MemSet_128:     dup 32                                                          ; 32 * 2  = 64 byte(s)
                PUSH DE
                edup
MemSet_64:      dup 16                                                          ; 16 * 2  = 32 byte(s)
                PUSH DE
                edup
MemSet_32:      dup 16                                                          ; 16 * 2  = 32 byte(s)
                PUSH DE
                edup
MS_ContainerSP: EQU $+1
                LD SP, #0000
                RET

                display " - Memory set: \t\t\t\t\t", /A, Begin, " = busy [ ", /D, $ - Begin, " byte(s)  ]"

                endmodule

                endif ; ~_MEMORY_SET_