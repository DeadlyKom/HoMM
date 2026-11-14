                ifndef _SUBMODULES_CONTOUR_MEMORY_SIZE_
                define _SUBMODULES_CONTOUR_MEMORY_SIZE_
; -----------------------------------------
; размеры дополнительной памяти сабмодуля "обводки" в байтах
; -----------------------------------------
Size.Tables     EQU #0900                                                       ; размер таблицы расширения (3 радиуса * 256 комбинаций * 3 байта результата, 0/+1/-1)
Size.Buffer     EQU #0100                                                       ; временный буфер внутренней и внешней масок, по 128 байт
Size.Work       EQU Size.Tables + Size.Buffer                                   ; общий объём памяти таблиц и временного буфера

                endif ; ~_SUBMODULES_CONTOUR_MEMORY_SIZE_
