                
                ifndef _AI_DIRECTOR_DISTANCE_MAP_INITIALIZE_
                define _AI_DIRECTOR_DISTANCE_MAP_INITIALIZE_
; -----------------------------------------
; инициализация карты расстояний
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   код расположен в общей памяти
;
;   должна быть включена страница Page.Hextile
;   Adr.Hextile и Adr.DistanceMap отличаются битом 7 старшего байта адреса
; -----------------------------------------
Initialize:     ; инициализация
                LD HL, Adr.Hextile                                              ; #4000/#C000 (DistanceMap/Hextile)
                LD D, HIGH Adr.SurfPassability
                LD BC, Size.Hextile

.Loop           ; чтение типа поверхности текущего гексагона
                LD E, (HL)                                                      ; индекс гексагона
                LD A, (DE)                                                      ; чтение FMapSurface.Passability
                AND SURFACE_TYPE_MASK

                ; обычные типы  → #FF   (DISTANCE_PACKED_FAR)
                ; дорога        → #0F
                ; поселение     → #F0
                RES 7, H
                LD (HL), DISTANCE_PACKED_FAR

                SUB SURFACE_TYPE_ROAD
                JR C, .NextHextile                                              ; переход, если тип поверхности не является дорогой или поселением

                ; выбор инструкции изменения нужного полубайта:
                ; дорога    → #ED, #67 (RRD) → #0F
                ; поселение → #ED, #6F (RLD) → #F0
                RRA
                RRA
                OR #67
                LD (.RollHalf), A
                XOR A
.RollHalf       EQU $+1
                DB #ED, #00                                                     ; #ED, #67 / #ED, #6F  - RRD/RLD

.NextHextile    ; следующий гексагон
                SET 7, H
                INC HL

                ; уменьшение счётчика оставшихся гексагонов
                DEC BC

                ; проверка завершения очередного блока из 256 гексагонов
                LD A, C
                OR A
                JR NZ, .Loop                                                    ; переход, если блок из 256 гексагонов не завершён

                ; продвижение прогресса после обработки 256 гексагонов
                PUSH BC                                                         ; сохранение счётчика оставшихся гексагонов
                PROGRESS_PERCENT_FIXED DIRECTOR_PROGRESS_DISTANCE_INITIALIZE_STEP
                CALL Session.SharedCode.Director.ProgressIncrement
                POP BC                                                          ; восстановление счётчика оставшихся гексагонов

                ; проверка завершения инициализации карты расстояний
                LD A, B
                OR A
                JR NZ, .Loop                                                    ; переход, если обработаны не все гексагоны

                ; установка точного порога завершения инициализации
                PROGRESS_PERCENT_FIXED DIRECTOR_PROGRESS_DISTANCE_INITIALIZE_END
                JP Session.SharedCode.Director.ProgressToPercent

                endif ; ~_AI_DIRECTOR_DISTANCE_MAP_INITIALIZE_
