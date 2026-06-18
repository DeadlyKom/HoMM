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
                ifdef _COMPRESSED_ASSET
                savebin RawFile?, Begin, Size
                COMPRESS_FILE RawFile?, PackedFile?
                endif
                ASSETS_SIZE PackedFile?
                endm

                endif ; ~_MACRO_ASSETS_
