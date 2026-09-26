
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_DEPLOY_
                define _VFX_CROSSFADE_FALLING_BLOCKS_DEPLOY_
; -----------------------------------------
; развёртывание кода эффекта падающих блоков
; In:
; Out:
;   код эффекта скопирован в страницу 7
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ адрес исполнения неизвестен
;   перед вызовом включена страница модуля с исходным блоком кода
;   при возврате восстанавливается страница вызывающего кода
; -----------------------------------------
Deploy:         ; копирование исполняемого блока в страницу эффекта
                JP_MEMCPY_PAGE CodeSource, Const.CodeAdr, \
                                Page.FallingBlocks, CodeSize

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_DEPLOY_
