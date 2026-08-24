
                ifndef _MODULE_WORLD_UI_TRANSITION_GAME_PAUSE_
                define _MODULE_WORLD_UI_TRANSITION_GAME_PAUSE_
; -----------------------------------------
; переход к игровому меню паузы
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GamePause:      ; подготовка экрана
                SHOW_SHADOW_SCREEN                                              ; отображение теневого экрана
                CALL .ApplyScrGrid                                              ; наложение сетки на базовый экран
                HALT
                SHOW_BASE_SCREEN                                                ; отображение базового экрана
                SET_RENDER_FLAG SWAP_DISABLE_BIT                                ; запрет переключения экранов

                ; установка активного UI слоя
                SET_UI_LAYER World.Base.Layers.GamePause, \
                                World.Base.Layers.GamePause.Num

                CALL World.Tilemap.ResetMapScroll                               ; сброс перемещения скролла карты
                RES_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; сброс запроса обновления скролла карты
                SET_TICK_CONTROL_FLAG GAME_PAUSE_BIT                            ; включить паузу игры
                JP UI.Runtime.Complete                                          ; завершить переход смены UI режима
; -----------------------------------------
; ожидание отображения теневого экрана
; In:
; Out:
; Corrupt:
;   AF
; Note:
; -----------------------------------------
; .WaitShadowScr  ; проверка отображаемого экрана
;                 LD A, (Adr.Port_7FFD)
;                 BIT SCREEN_BIT, A                                               ; проверка флага отображения теневого экрана
;                 RET NZ                                                          ; выход, если отображается теневой экран

;                 HALT                                                            ; ожидание следующего прерывания
;                 JR .WaitShadowScr                                               ; переход к повторной проверке отображаемого экрана
; -----------------------------------------
; наложение сетки на базовый экран
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
.ApplyScrGrid   ; инициализация
                LD HL, SCR_ADR_BASE                                             ; адрес начала базового экрана
                LD E, #AA                                                       ; маска сетки первой строки
                LD C, SCREEN_CURSOR_Y                                           ; количество строк экрана

.RowLoop        LD D, L                                                         ; сохранение адреса начала строки
                LD B, SCREEN_CURSOR_X >> 3                                      ; количество байтов в строке экрана

.ByteLoop       LD A, (HL)                                                      ; чтение байта экрана
                OR E                                                            ; применение маски сетки
                LD (HL), A                                                      ; сохранение изменённого байта экрана
                INC L                                                           ; переход к следующему байту строки
                DJNZ .ByteLoop
                LD L, D                                                         ; восстановление адреса начала строки

                ; проверка завершения обработки строк экрана
                DEC C
                RET Z                                                           ; выход, если обработаны все строки экрана

                ; изменение маски сетки следующей строки
                LD A, E
                CPL
                LD E, A

                ; классический метод "DOWN HL" 25/59
                INC H
                LD A, H
                AND #07
                JP NZ, $+12
                LD A, L
                SUB #E0
                LD L, A
                SBC A, A
                AND #F8
                ADD A, H
                LD H, A
                JR .RowLoop                                                    ; переход к обработке следующей строки экрана

                endif ; ~_MODULE_WORLD_UI_TRANSITION_GAME_PAUSE_
