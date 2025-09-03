
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
                ; * Adr.MapBiome хранит значения тайлы биомы,                   (1 страница)
                ;   каждый тайл имеет проходимость Adr.SurfacePassability
                ;   знаяения между 0 - высокая проходимость, 255 - непроходимый
                ; * на основе объектов Adr.ObjectsArray                         (0 страница)
                ;   получить непроходимые объекты, а также триггеры событий
                ; * запуск поиска пути                                          (1 страница)
                ;   результат поиска будет хранится в Adr.FoundPath
                ; * полученый путь необходимо скопировать в Adr.HeroPath
                ; * на основе полученого пути Adr.HeroPath сформировать UI объекты

                ; проверка наличия активного пути у героя
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                LD A, (GameState.Event + FEvent.HeroID)

                ; -----------------------------------------
                ; получить адреса героя
                ; In:
                ;   A  - индекс героя
                ; Out:
                ;   IX - адрес героя            (FHero)
                ;   IY - адрес объекта героя    (FObjectHero)
                ; -----------------------------------------
                CALL Hero.Utils.GetHeroAdres
                LD A, (IY + FObjectHero.PathID)
                CP PATH_ID_NONE
                RET NZ                                                          ; ToDo временно выход, в дальнейшем, весь путь нужно очищать

                ; координаты начала в тайлах
                LD E, (IY + FObjectHero.Super.Position.X.High)
                LD D, (IY + FObjectHero.Super.Position.Y.High)

                SET_INTERRUPT_FLAG INT_DISABLE_GLOBAL_TICK_BIT                  ; запрет глобального тика

                ; запрос поиска пути
                SET_PAGE_PATHFINDING                                            ; включить страницу работы с поиском пути
                LD HL, (GameState.Event + FEvent.Position)                      ; координаты назначения в тайлах
                CALL Pathfinding.Request                                        ; запрос поиска пути
                DEBUG_BREAK_POINT_NC                                            ; произошла ошибка!
                CALL Pathfinding.MemcpyPath                                     ; копирование пути в буфер Adr.SharedBuffer

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL Hero.MemcpyPath                                            ; копирование пути в буфер Adr.HeroPath
                                                                                ;   C - длина пути
                ; получить адреса героя
                LD A, (GameState.Event + FEvent.HeroID)
                CALL Hero.Utils.GetHeroAdres
                ; установить длины пути героя
                DEC C
                LD (IY + FObjectHero.PathID), C
                
                LD D, (IY + FObjectHero.Super.Position.Y.High)
                LD E, (IY + FObjectHero.Super.Position.X.High)
                LD B, (IY + FObjectHero.PathID)
                CALL Hero.ReificationPath                                       ; овеществление путь героя

                RES_INTERRUPT_FLAG INT_DISABLE_GLOBAL_TICK_BIT                  ; разрешение глобального тика
                RET

                endif ; ~_WORLD_EVENT_PATHFINDING_
