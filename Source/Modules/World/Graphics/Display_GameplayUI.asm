
                ifndef _MODULE_WORLD_DISPLAY_GAMEPLAY_UI_
                define _MODULE_WORLD_DISPLAY_GAMEPLAY_UI_
; -----------------------------------------
; отображение пользовательского интерфейса игрового окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameplayUI:     ; подготовка основного экрана
                ATTR_RECT_IPB SCR_ADR_BASE, 24, 9, 8, 15, BLACK, YELLOW, 1
                
                ; отображение большого ромба
                LD HL, BigDiamond
                CALL Draw.SpriteNotBound

                ; инициализация
                LD HL, .IconsList
                LD B, .IconsList.Num

.IconLoop       ; -----------------------------------------
                ; чтение данных структуры FUIIcon (подложка)
                LD A, (HL)                                                      ; FUIIcon.BackType
                INC HL
                LD E, (HL)                                                      ; FUIIcon.BackPosition.X
                INC HL
                LD D, (HL)                                                      ; FUIIcon.BackPosition.Y
                INC HL

                ; проверка видимости подложки
                BIT 7, A                                                        ; флаг, бит 7 установлен для скрытого спрайта
                CALL Z, .DrawIcon                                               ; вызов, если спрайт видим

                ; -----------------------------------------

                ; чтение данных структуры FUIIcon (иконка)
                LD A, (HL)                                                      ; FUIIcon.IconType
                INC HL
                LD E, (HL)                                                      ; FUIIcon.IconPosition.X
                INC HL
                LD D, (HL)                                                      ; FUIIcon.IconPosition.Y
                INC HL

                ; проверка видимости иконки
                BIT 7, A                                                        ; флаг, бит 7 установлен для скрытого спрайта
                CALL Z, .DrawIcon                                               ; вызов, если спрайт видим

                ; -----------------------------------------

                ; пропуск адреса обработчика в записи иконки
                INC HL
                INC HL

                DJNZ .IconLoop

                RET
; -----------------------------------------
; отображение иконки
; In:
;   DE - координаты в пикселях (D - y, E - x)
;   A - идентификатор иконки
; Out:
; Corrupt:
;   DE, AF, HL', DE', BC', AF', IX, IY
; Note:
; -----------------------------------------
.DrawIcon       ; сохранение регистров
                PUSH HL
                PUSH BC
                
                ; расчёт адреса иконки
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD C, A
                LD B, #00
                LD HL, Icons
                ADD HL, BC
                LD A, (Kernel.Modules.World.Page)
                CALL Draw.SpriteNotClipping.OR_XOR                              ; отображение спрайта иконки

                ; восстановление регистров
                POP BC
                POP HL
                RET

                struct FUIIcon
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | VF | IF | .. | T4 | T3 | T2 | T1 | T0 |
;   +----+----+----+----+----+----+----+----+
;
;   VF      [7]     - флаг, управляющий видимостью
;                       0 - видима, 1 - невидима
;   IF      [6]     - флаг, управляющий интерактивностью
;                      0 - интерактивна, 1 - неинтерактивна
;   T4-T0   [4..0]  - тип подложки иконки
; -----------------------------------------
BackType        DB #00                                                          ; тип подложки иконки
BackPosition    FVector8                                                        ; позиция подложки иконки
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | VF | .. | .. | T4 | T3 | T2 | T1 | T0 |
;   +----+----+----+----+----+----+----+----+
;
;   VF      [7]     - флаг, управляющий видимостью
;                       0 - видима, 1 - невидима
;   T4-T0   [4..0]  - тип иконки
; -----------------------------------------
IconType        DB #00                                                          ; тип иконки
IconPosition    FVector8                                                        ; позиция иконки
Handler         DW #0000                                                        ; адрес обработчика попадания в ромб
                ends

.IconsList      ; таблица подложек и иконок
                FUIIcon { #00 | Icons.Index.Diamond, { #E8, #4A }, #00 | Icons.Index.Center,     { #EB, #4C }, World.UI.Handler.GameUIIcons.Center }
                FUIIcon { #00 | Icons.Index.Diamond, { #D4, #50 }, #00 | Icons.Index.Character,  { #D9, #50 }, World.UI.Handler.GameUIIcons.Character }
                FUIIcon { #00 | Icons.Index.Diamond, { #C7, #5D }, #00 | Icons.Index.SpellsBook, { #C7, #5E }, World.UI.Handler.GameUIIcons.SpellsBook }
                FUIIcon { #00 | Icons.Index.Diamond, { #E1, #5D }, #00 | Icons.Index.Inventory,  { #E4, #5D }, World.UI.Handler.GameUIIcons.Inventory }
                FUIIcon { #40 | Icons.Index.SlotTL,  { #C1, #70 }, #80 | Icons.Index.Cloud,      { #C1, #72 }, #0000 }
                FUIIcon { #40 | Icons.Index.SlotTR,  { #F1, #70 }, #80 | Icons.Index.None,       { #00, #00 }, #0000 }
                FUIIcon { #40 | Icons.Index.SlotBL,  { #C1, #8C }, #80 | Icons.Index.None,       { #00, #00 }, #0000 }
                FUIIcon { #40 | Icons.Index.SlotBR,  { #F1, #8C }, #80 | Icons.Index.None,       { #00, #00 }, #0000 }
                FUIIcon { #00 | Icons.Index.Diamond, { #C7, #95 }, #00 | Icons.Index.Quest,      { #C8, #96 }, World.UI.Handler.GameUIIcons.Quest }
                FUIIcon { #00 | Icons.Index.Diamond, { #E1, #95 }, #00 | Icons.Index.Map,        { #E4, #94 }, World.UI.Handler.GameUIIcons.Map }
                FUIIcon { #00 | Icons.Index.Diamond, { #D4, #A2 }, #00 | Icons.Index.Options,    { #D4, #9F }, World.UI.Handler.GameUIIcons.Options }
.IconsList.Num  EQU ($-.IconsList) / FUIIcon 

                display " - Display gameplay UI:\t\t\t\t\t\t= busy [ ", /D, $-GameplayUI, " byte(s) ]"

                endif ; ~_MODULE_WORLD_DISPLAY_GAMEPLAY_UI_
