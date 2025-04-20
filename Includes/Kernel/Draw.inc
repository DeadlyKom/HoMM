
                ifndef _KERNEL_DRAW_
                define _KERNEL_DRAW_
Draw:
.Background     EQU Kernel.World.Background                                     ; отображение фона миры
.Sprite         EQU Kernel.Sprite.DrawClipped                                   ; отображение спрайта
.Composite      EQU Kernel.Sprite.DrawComposite                                 ; отображение композитного спрайта
.Restore        EQU Kernel.Sprite.Restore                                       ; восстановление фона под спрайтов (только для OR_XOR_SAVE)

                endif ; ~_KERNEL_DRAW_
