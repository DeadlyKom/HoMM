
                ifndef _PAGE_1_BUFFERS_
                define _PAGE_1_BUFFERS_
Buffer:
.Render                     EQU Page1.Buffer.RenderBuffer                       ; обновление Render-буфера
.Memcpy.Tilemap             EQU Page1.Buffer.Memcpy.TilemapBuffer               ; копирование блока тайлов в Tile-буфер

BufferUtilities:
.GetRender                  EQU Page1.Buffer.Utilities.GetRenderBuffer          ; определение адреса Render-буфера по индексу гексагона
.GetIndexRender             EQU Page1.Buffer.Utilities.GetIndexRender           ; определение индекса Render-буфера по координатам гексагона
.GetIndexRender.Wrap        EQU Page1.Buffer.Utilities.GetIndexRender.Wrap      ; определение индекса Render-буфера по координатам гексагона    (обёртка)
.GetMapArrayAdr             EQU Page1.Buffer.Utilities.GetMapArrayAdr           ; получение адреса массива карты по координатам
.GetMetaArrayAdr            EQU Page1.Buffer.Utilities.GetMetaArrayAdr          ; получение адреса массива метаданных карты по координатам
.GetHextileIDByCoord        EQU Page1.Buffer.Utilities.GetHextileIDByCoord      ; получение ID гексагона по координатам
.GetHextileIDByCoord.Wrap   EQU Page1.Buffer.Utilities.GetHextileIDByCoord.Wrap ; получение ID гексагона по координатам                         (обёртка)
.UpdateHextile              EQU Page1.Buffer.Hextile                            ; обновление Render-буфера указанного гексогонального тайла
.AdjRenderBufCol            EQU Page1.Buffer.AdjRenderBufCol                    ; корректировка столбцов рендер буфера
.SpriteBound                EQU Page1.Buffer.SpriteBound                        ; обновление Render-буфера указанного bound спрайта
.Reconnaissance             EQU Page1.Buffer.Reconnaissance                     ; рекогносцировка
                endif ; ~_PAGE_1_BUFFERS_
