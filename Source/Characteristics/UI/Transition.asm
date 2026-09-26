
                ifndef _CHARACTERISTICS_UI_TRANSITION_
                define _CHARACTERISTICS_UI_TRANSITION_

                module UI
                module Transition

; -----------------------------------------
; переход с экрана мира падающими блоками
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   код эффекта заранее перенесён методом Launch.Deploy
;   вызов выполняется вне обработчика прерываний
; -----------------------------------------
FallingBlocks:  ; сохранение страницы перед проигрыванием эффекта
                PUSH_PAGE

                ; отображение основного экрана и включение страницы эффекта
                SHOW_BASE_SCREEN
                SET_PAGE_SCREEN_SHADOW

                ; чёрный фон, закомментировать следующую строку для текущего второго экрана
                CLS_SCR_SHADOW_IN_PAGE #00, BLACK, BLACK, #00

                ; выбор эллипса 48x40 и центра перехода в пикселях
                LD HL, Characteristics.VFX.FallingBlocks.Functions.Ellipse
                LD BC, (96 << 8) | 128                                          ; B = y, C = x
                CALL Characteristics.VFX.FallingBlocks.Play

                ; восстановление страницы после завершения перехода
                JP_POP_PAGE

                endmodule
                endmodule

                endif ; ~_CHARACTERISTICS_UI_TRANSITION_
