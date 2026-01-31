
                ifndef _STRUCTS_CURSOR_
                define _STRUCTS_CURSOR_

                struct FCursorState
State           DB #00                                                          ; состояние курсора
Direction       DB #00
SpriteIndex     DB #00
SpriteID        DB #00
Counter         DB #00
IndexMax        DB #00
                ends

                endif ; ~_STRUCTS_CURSOR_
