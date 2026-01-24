
                ifndef _KERNEL_DRAW_
                define _KERNEL_DRAW_
Draw:
.HexByDL            EQU Kernel.Hex.HexByDL
.HexDLGeneration    EQU Kernel.Hex.HexDLGeneration                              ; генерация списка отображения гексагонов
.SpriteClipping     EQU Kernel.Sprite.DrawClipping                              ; отображение спрайта с поддержкой обрезки
.SpriteClipping.HL  EQU Kernel.Sprite.DrawClipping.FSprite                      ; отображение спрайта (HL - адрес структуры FSprite)
.SpriteNotClipping  EQU Kernel.Boundary.DrawNotClipping.Bound                   ; отображение спрайта без поддержкой обрезки
.SpriteNotBound     EQU Kernel.Boundary.DrawNotClipping.NotBound                ; отображение спрайта без поддержкой обрезки (без ограничений)
.Composite          EQU Kernel.Sprite.DrawComposite                             ; отображение композитного спрайта
.Restore            EQU Kernel.Sprite.Restore                                   ; восстановление фона под спрайтом (только для OR_XOR_SAVE)
.RestoreByScrAdr    EQU Kernel.Sprite.Restore.ByScrAdr                          ; восстановление фона под спрайтом в указанном адресе экрана (только для OR_XOR_SAVE)
                endif ; ~_KERNEL_DRAW_
