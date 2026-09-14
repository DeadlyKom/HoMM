                ifndef _MACRO_ASSET_
                define _MACRO_ASSET_
ASSETS_SIZE     macro Include?
                ORG 0x0000
                incbin Include?
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)
                endm
; ------------------------------------------------------------
; COMPRESS_FILE
;
; SrcFile? - исходный файл
; DstFile? - итоговый сжатый файл
;
; Вызов:
; COMPRESS_FILE "source.bin", "packed.bin.ar"
; ------------------------------------------------------------
COMPRESS_FILE   macro SrcFile?, DstFile?

                define __ASSET_SRC_FILE__ SrcFile?
                define __ASSET_DST_FILE__ DstFile?

                lua
                    local function trim(s)
                        if s == nil then
                            return nil
                        end

                        return (s:gsub("^%s+", ""):gsub("%s+$", ""))
                    end

                    local function unquote(s)
                        if s == nil then
                            return nil
                        end

                        s = trim(s)

                        if #s >= 2 and s:sub(1, 1) == '"' and s:sub(-1) == '"' then
                            return s:sub(2, -2)
                        end

                        return s
                    end

                    local compressor = "Tools/Compressor/salvador.exe"

                    local src = unquote(sj.get_define("__ASSET_SRC_FILE__"))
                    local dst = unquote(sj.get_define("__ASSET_DST_FILE__"))

                    if src == nil or src == "" then
                        error("__ASSET_SRC_FILE__ is nil")
                    end

                    if dst == nil or dst == "" then
                        error("__ASSET_DST_FILE__ is nil")
                    end

                    local cmd =
                        'cmd /C ""' .. compressor .. '" -v "' ..
                        src .. '" "' ..
                        dst .. '" 2>&1"'

                    local pipe = io.popen(cmd, "r")

                    if pipe == nil then
                        error("cannot run salvador.exe")
                    end

                    local output = pipe:read("*a")
                    local ok, how, code = pipe:close()

                    local success =
                        (ok == true) or
                        (ok == 0) or
                        (code == 0)

                    if not success then
                        error(
                            "salvador.exe failed: " ..
                            tostring(ok) .. " " ..
                            tostring(how) .. " " ..
                            tostring(code)
                        )
                    end

                    local f = io.open(dst, "rb")
                    if f == nil then
                        error("salvador.exe did not create file: " .. dst)
                    end
                    f:close()

                    local short_info = nil

                    if output ~= nil then
                        short_info = output:match(
                            "([%d%.]+%s+[Mm][Bb]/s,%s+" ..
                            "%d+%s+tokens%s+" ..
                            "%([%d%.]+%s+bytes/token%),%s+" ..
                            "%d+%s+into%s+%d+%s+bytes%s+" ..
                            "==>%s+[%d%.]+%s*%%)"
                        )
                    end

                    if short_info ~= nil then
                        print("[asset] " .. dst .. " | " .. short_info)
                    else
                        print("[asset] " .. dst .. " | compression unknown")
                    end
                endlua

                undefine __ASSET_SRC_FILE__
                undefine __ASSET_DST_FILE__
                endm
; ------------------------------------------------------------
; COMPRESSED_ASSET
; RawFile?     - временный несжатый файл
; PackedFile?  - итоговый сжатый файл
; ------------------------------------------------------------
COMPRESSED_ASSET macro RawFile?, PackedFile?

                if !(exist Size)
Size            EQU $-Begin
                endif
 
                if Size >= BankSize
                error "размер несжатого ассета должен быть меньше 16 КБ"
                endif

                ifdef _COMPRESSED_ASSET
                savebin RawFile?, Begin, Size
                COMPRESS_FILE RawFile?, PackedFile?
                endif
                ASSETS_SIZE PackedFile?
                endm
; ------------------------------------------------------------
; COMPRESS_ASSET_CODE
; упаковка перемещаемого кода с таблицей релокации
; RawFile?     - путь несжатого пакета без суффикса прохода
; PackedFile?  - путь итогового сжатого пакета
; Begin и Size исходного кода задаются модулем при PASS = 0/1
; ------------------------------------------------------------
COMPRESS_ASSET_CODE macro RawFile?, PackedFile?
                ; проверка режима полной пересборки
                ifdef _REBUILD

                ; сохранение кода первого прохода
                if     PASS = 0
                savebin RawFile? .. ".pass-1", Begin, Size

                ; сохранение кода второго прохода
                elseif PASS = 1
                savebin RawFile? .. ".pass-2", Begin, Size

                ; формирование перемещаемого пакета на завершающем проходе
                elseif PASS = 2

                ORG 0x0000
Begin:          EQU $
                include "Source/Functions/AdjustmentAddress.asm"                ; корректирование адресов (всегда первая)

                ; формирование таблицы релокации по двум проходам
                define __ASSET_CODE_RAW_FILE__ RawFile?
                lua allpass
                    local raw = sj.get_define("__ASSET_CODE_RAW_FILE__")
                    raw = raw:match("^%s*(.-)%s*$")
                    raw = raw:match('^"(.*)"$') or raw
                    MakeTransitionTable(raw .. ".pass-1", raw .. ".pass-2")
                endlua
                undefine __ASSET_CODE_RAW_FILE__

                ; добавление кода после таблицы релокации
                incbin RawFile? .. ".pass-1"

                ; расчёт полного размера перемещаемого пакета
Size            EQU $                                                           ; размер кода, таблицы и обработчика релокации

                ; сохранение и сжатие пакета
                COMPRESSED_ASSET RawFile?, PackedFile?
                endif
                endif

                ; чтение размера готового архива без повторной упаковки
                if PASS = 2
                ifndef _REBUILD
                ASSETS_SIZE PackedFile?
                endif
                else
                ; предварительные размеры до создания архива
Size.ar         EQU 0
Size.Sector.ar  EQU 0
                endif
                endm
SAVE_PACK       macro RawFile?

                if !(exist Size)
Size            EQU $-Begin
                endif

                if Size >= BankSize
                error "размер несжатого ассета должен быть меньше 16 КБ"
                endif

                savebin RawFile?, Begin, Size

                endm

                endif ; ~_MACRO_ASSETS_
