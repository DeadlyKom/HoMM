                ifndef _MACRO_ASSET_
                define _MACRO_ASSET_
; -----------------------------------------
; определение размера сжатого ресурса
; In:
;   Include? - путь сжатого файла
; Out:
;   Size.ar        - размер файла в байтах
;   Size.Sector.ar - размер файла в секторах
; -----------------------------------------
ASSETS_SIZE     macro Include?
                ORG 0x0000
                incbin Include?
Size.ar         EQU $
                SIZE_TO_SECTORS Size.ar, Size.Sector.ar
                endm
; -----------------------------------------
; сжатие файла
; In:
;   SrcFile? - исходный файл
;   DstFile? - итоговый сжатый файл
; -----------------------------------------
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
; -----------------------------------------
; сохранение и сжатие ресурса
; In:
;   RawFile?       - временный несжатый файл
;   PackedFile?    - итоговый сжатый файл
;   Begin          - начало несжатых данных
;   Size           - размер несжатых данных в байтах, если задан
; Out:
;   Size           - размер несжатых данных в байтах
;   Size.ar        - размер сжатого файла в байтах
;   Size.Sector.ar - размер сжатого файла в секторах
; -----------------------------------------
COMPRESSED_ASSET macro RawFile?, PackedFile?

                if !(exist Size)
Size            EQU $-Begin
                endif
 
                assert Size < BankSize, Uncompressed asset size must be less than 16 Kb

                ifdef _COMPRESSED_ASSET
                savebin RawFile?, Begin, Size
                COMPRESS_FILE RawFile?, PackedFile?
                endif
                ASSETS_SIZE PackedFile?
                endm
; -----------------------------------------
; упаковка перемещаемого кода с таблицей релокации
; In:
;   RawFile?       - путь несжатого пакета без суффикса прохода
;   PackedFile?    - путь итогового сжатого пакета
;   Begin          - начало исходного кода при PASS = 0/1
;   Size           - размер исходного кода в байтах при PASS = 0/1
; Out:
;   Size           - размер перемещаемого пакета в байтах при полной упаковке
;   Size.ar        - размер сжатого файла в байтах
;   Size.Sector.ar - размер сжатого файла в секторах
; -----------------------------------------
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
; -----------------------------------------
; упаковка перемещаемого кода с дополнительной памятью
; In:
;   ExtraSize?     - дополнительный объём памяти в байтах
;   RawFile?       - путь несжатого пакета без суффикса прохода
;   PackedFile?    - путь итогового сжатого пакета
;   Begin          - начало исходного кода при PASS = 0/1
;   Size           - размер исходного кода в байтах при PASS = 0/1
; Out:
;   Size           - размер перемещаемого пакета в байтах при полной упаковке
;   Size.ar        - размер сжатого файла в байтах
;   Size.Sector.ar - размер сжатого файла в секторах
;   Size.Memory    - объём памяти пакета и дополнительных данных в байтах
;   Size.Asset     - размер для регистрации ресурса в байтах
; Note:
;   пакет и дополнительная память округляются отдельно до 256 байт
;   служебные 256 байт загрузчика входят в дополнительную память
; -----------------------------------------
COMPRESS_ASSET_CODE_MEMORY macro ExtraSize?, RawFile?, PackedFile?
                COMPRESS_ASSET_CODE RawFile?, PackedFile?

                ; расчёт памяти пакета и дополнительных данных
                DIV_ROUND_UP Size, #0100, Size.Blocks
                DIV_ROUND_UP ExtraSize?, #0100, Size.Extra.Blocks
Size.Memory     EQU (Size.Blocks + Size.Extra.Blocks) * #0100

                ; проверка наличия дополнительной памяти
                if (ExtraSize?) > 0

                ; учёт служебных 256 байт, добавляемых загрузчиком
Size.Asset      EQU Size.Memory - #0100
                else
Size.Asset      EQU Size
                endif

                ; проверка размещения пакета и дополнительных данных в одной странице
                assert Size.Memory <= BankSize, Package and additional data exceed 16 Kb
                endm
; -----------------------------------------
; сохранение пакета данных
; In:
;   RawFile? - путь несжатого файла
;   Begin    - начало данных
;   Size     - размер данных в байтах, если задан
; Out:
;   Size - размер данных в байтах
; -----------------------------------------
SAVE_PACK       macro RawFile?

                if !(exist Size)
Size            EQU $-Begin
                endif

                assert Size < BankSize, Uncompressed asset size must be less than 16 Kb

                savebin RawFile?, Begin, Size

                endm

                endif ; ~_MACRO_ASSETS_
