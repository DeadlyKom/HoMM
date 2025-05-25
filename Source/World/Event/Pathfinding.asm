
                ifndef _WORLD_EVENT_PATHFINDING_
                define _WORLD_EVENT_PATHFINDING_
; -----------------------------------------
; обработчик события - поиска пути
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Pathfinding:    ; ToDo
                ; * необходимо сформировать поле проходимости:                  (1 страница)
                ;   - формирование первого слоя проходимости из Adr.BiomeBuf, 
                ;     значения между 0 - высокая проходимость, 255 - непроходимый
                ; * на основе объектов Adr.ObjectsArray                         (0 страница)
                ;   получить непроходимые объекты, а также триггеры событий
                ; * запуск поиска пути                                          (3 страница)
                ;   результат поиска будет хранится в Adr.FoundPath
                ; * полученый путь необходимо скопировать в Adr.HeroPath
                ; * на основе полученого пути Adr.HeroPath сформировать UI объекты

                SET_PAGE_PATHFINDING                                            ; включить страницу работы с поиском пути
                CALL MemcpyFoundPath                                            ; копирование пути в буфер Adr.SharedBuffer

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL MemcpyHeroPath                                             ; копирование пути в буфер Adr.HeroPath
                LD A, (GameState.Event + FEvent.HeroID)
                CALL SetHeroPath                                                ; установить длины пути героя
                
                LD D, (IY + FObjectHero.Super.Position.Y.High)
                LD E, (IY + FObjectHero.Super.Position.X.High)
                LD B, (IY + FObjectHero.PathID)
                CALL ReificationPath                                            ; овеществление путь героя

                RET

                endif ; ~_WORLD_EVENT_PATHFINDING_
