
                ifndef _PATHFINDING_UTILS_MEMORY_COPY_PATH_
                define _PATHFINDING_UTILS_MEMORY_COPY_PATH_
; -----------------------------------------
; копирование пути в буфер Adr.SharedBuffer
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
MemcpyFoundPath ;
                LD HL, Adr.SharedBuffer
                LD DE, .DebugPath ; Adr.FoundPath
                LD BC, .DebugPath.Num * FPath
                
                ; размер пути
                LD (HL), C
                INC L
                LD (HL), B
                INC L
                EX DE, HL
                JP Memcpy.FastLDIR

.DebugPath       ; начало 8, 8
                FPath {  8,  8 }                                                ; 0
                FPath {  7,  9 }                                                ; 11
                FPath {  8, 10 }                                                ; 10
                FPath {  9, 10 }                                                ; 9
                FPath { 10,  9 }                                                ; 8
                FPath { 11,  9 }                                                ; 7
                FPath { 12,  8 }                                                ; 6
                FPath { 12,  7 }                                                ; 5
                FPath { 11,  6 }                                                ; 4
                FPath { 10,  6 }                                                ; 3
                FPath {  9,  6 }                                                ; 2
                FPath {  8,  7 }                                                ; 1
.DebugPath.Num  EQU ($-.DebugPath) / FPath

                endif ; ~_PATHFINDING_UTILS_MEMORY_COPY_PATH_
