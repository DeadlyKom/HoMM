
                ifndef _CHARACTER_UTILITIES_MEMORY_COPY_CHARACTER_OBJECT_
                define _CHARACTER_UTILITIES_MEMORY_COPY_CHARACTER_OBJECT_
; -----------------------------------------
; копировать объект "персонаж"
; In:
;   DE' - адрес копирования объекта
;   C'  - идентификатор персонажа
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
Character.MemcpyObject; 
                EXX
                ; -----------------------------------------
                ; получить адреса персонажа
                ; In:
                ;   A  - индекс персонажа
                ; Out:
                ;   IX - адрес персонажа            (FCharacter)
                ;   IY - адрес объекта персонажа    (FObjectCharacter)
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                LD A, C
                CALL Character.Utilities.GetAdr

                ; копирование FCharacter
                PUSH IX
                POP HL
                LD A, E
                LD IXL, A
                LD A, D
                LD IXH, A
                LD BC, CHARACTER_SIZE
                CALL Memcpy.FastLDIR

                ; копирование FObjectCharacter
                PUSH IY
                POP HL
                LD A, E
                LD IYL, A
                LD A, D
                LD IYH, A
                LD C, OBJECT_SIZE
                JP Memcpy.FastLDIR

                endif ; ~_CHARACTER_UTILITIES_MEMORY_COPY_CHARACTER_OBJECT_
