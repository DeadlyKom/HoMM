
                ifndef _KERNEL_DRAW_
                define _KERNEL_DRAW_
Draw:
; .Background     EQU Kernel.World.Background                                     ; отображение фона миры
.Hex.World      EQU Kernel.Hex.World
.HexByDL        EQU Kernel.Hex.HexByDL
.Sprite         EQU Kernel.Sprite.DrawClipped                                   ; отображение спрайта
.Sprite.HL      EQU Kernel.Sprite.DrawClipped.FSprite                           ; отображение спрайта (HL - адрес структуры FSprite)
.Composite      EQU Kernel.Sprite.DrawComposite                                 ; отображение композитного спрайта
.Restore        EQU Kernel.Sprite.Restore                                       ; восстановление фона под спрайтов (только для OR_XOR_SAVE)

                endif ; ~_KERNEL_DRAW_
