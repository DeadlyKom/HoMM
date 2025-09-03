
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
                ; FPath {  7, 11 }                                                ;
                ; FPath {  6, 10 }                                                ;
                ; FPath {  5,  9 }                                                ;
                ; FPath {  5,  8 }                                                ;
                ; FPath {  6,  7 }                                                ;
                ; FPath {  7,  7 }                                                ;
                ; FPath {  8,  8 }                                                ;
                ; FPath {  9,  8 }                                                ;
                ; FPath { 10,  7 }                                                ;
                ; FPath { 11,  7 }                                                ;
                ; FPath { 12,  8 }                                                ;
                ; FPath { 12,  9 }                                                ;
                ; FPath { 11, 10 }                                                ;
                ; FPath { 10, 10 }                                                ;
                ; FPath {  9, 11 }                                                ;
                FPath {  9, 12 }                                                ; 31
                FPath { 10, 13 }                                                ; 30
                FPath { 10, 14 }                                                ; 29
                FPath {  9, 15 }                                                ; 28
                FPath {  8, 15 }                                                ; 27
                FPath {  7, 14 }                                                ; 26
                FPath {  7, 13 }                                                ; 25
                FPath {  8, 12 }                                                ; 24
                FPath {  9, 11 }                                                ; 23
                FPath {  9, 10 }                                                ; 22
                FPath {  8,  9 }                                                ; 21
                FPath {  7,  9 }                                                ; 20
                FPath {  6, 10 }                                                ; 19
                FPath {  6, 11 }                                                ; 18
                FPath {  7, 12 }                                                ; 17
                FPath {  8, 13 }                                                ; 16
                FPath {  9, 13 }                                                ; 15
                FPath { 10, 12 }                                                ; 14
                FPath { 11, 11 }                                                ; 13
                FPath { 11, 10 }                                                ; 12
                FPath { 10,  9 }                                                ; 11
                FPath {  9,  9 }                                                ; 10
                FPath {  8,  8 }                                                ; 9
                FPath {  7,  8 }                                                ; 8
                FPath {  6,  8 }                                                ; 7
                FPath {  5,  9 }                                                ; 6
                FPath {  4, 10 }                                                ; 5
                FPath {  4, 11 }                                                ; 4
                FPath {  5, 12 }                                                ; 3
                FPath {  6, 12 }                                                ; 2
                FPath {  7, 11 }                                                ; 1
.DebugPath.Num  EQU ($-.DebugPath) / FPath

                endif ; ~_PATHFINDING_UTILS_MEMORY_COPY_PATH_
