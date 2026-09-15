
                ifndef _PAGE_7_CURSOR_
                define _PAGE_7_CURSOR_
UI_Cursor:
.Draw           EQU World.SharedCode.Render.Cursor.Draw                         ; отображение курсора
.Update         EQU World.SharedScreen.Cursor.Update                            ; обновление курсора
.Initialize     EQU World.SharedScreen.Cursor.Initialize                        ; инициализация состояние курсора

.CurrentState   EQU World.SharedCode.Render.Cursor.CurrentState
.Idle.SpriteID  EQU World.SharedScreen.Cursor.StateTable.Idle.SpriteID
.Click.SpriteID EQU World.SharedScreen.Cursor.StateTable.Click.SpriteID
                endif ; ~_PAGE_3_CURSOR_
