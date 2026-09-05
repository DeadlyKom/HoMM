
                ifndef _MODULE_WORLD_LAUNCH_CREATE_TEXTURE_
                define _MODULE_WORLD_LAUNCH_CREATE_TEXTURE_
; -----------------------------------------
; подготовка и генерация текстуры Bayer
; In:
;   A - страница модуля мира
; Out:
;   Kernel.Modules.World.MemoryAddress - адрес выделенного блока с текстурой
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
CreateTexture:  ; расчёт адреса первого блока после модуля мира
                LD D, A                                                         ; сохранение страницы дополнительного блока памяти
                LD IX, GameState.Assets
                CALL_IN_PAGE Page.AssetManager, AssetsManager.CalcNextBlock
                LD (Kernel.Modules.World.MemoryAddress), HL                     ; сохранение адреса дополнительного блока памяти

                ; выделение одного блока памяти по рассчитанному адресу
                LD E, #01                                                       ; блок 256 байт всегда существует, если модуль был архивированный
                SET_REGISTER IX, HL
                CALL_IN_PAGE Page.AssetManager, AssetsManager.MemAllocation.Wrap
                EX AF, AF'                                                      ; восстановление результата выделения памяти
                DEBUG_BREAK_POINT_C                                             ; ошибка, выделение памяти не удалось

                ; генерация текстуры Bayer в выделенном блоке памяти
                LD HL, (Kernel.Modules.World.MemoryAddress)
                CALL World.Tables.TG_BayerGradient

                ; установка порога завершения подготовки и генерации текстуры Bayer
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_TEXTURE_END
                JP_LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                endif ; ~_MODULE_WORLD_LAUNCH_CREATE_TEXTURE_
