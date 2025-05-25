
                ifndef _PATHFINDING_UTILS_MEMORY_COPY_PATH_
                define _PATHFINDING_UTILS_MEMORY_COPY_PATH_
; -----------------------------------------
; копирование пути в буфер Adr.SharedBuffer
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
MemcpyFoundPath:; инициализация
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

.DebugPath       ; начало 8, 11
                FPath {  8, 11 }                                                ; 0
                FPath {  7, 11 }                                                ;
                FPath {  6, 10 }                                                ;
                FPath {  5,  9 }                                                ;
                FPath {  5,  8 }                                                ;
                FPath {  6,  7 }                                                ;
                FPath {  7,  7 }                                                ;
                FPath {  8,  8 }                                                ;
                FPath {  9,  8 }                                                ;
                FPath { 10,  7 }                                                ;
                FPath { 11,  7 }                                                ;
                FPath { 12,  8 }                                                ;
                FPath { 12,  9 }                                                ;
                FPath { 11, 10 }                                                ;
                FPath { 10, 10 }                                                ;
                FPath {  9, 11 }                                                ;
.DebugPath.Num  EQU ($-.DebugPath) / FPath

                endif ; ~_PATHFINDING_UTILS_MEMORY_COPY_PATH_
