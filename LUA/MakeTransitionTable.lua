    lua allpass

    local function filesize (file)
        local current = file:seek()
        local size = file:seek("end")
        file:seek("set", current)
        return size
    end

    function MakeTransitionTable(PathA, PathB)

        file = assert(io.open(PathA, "rb"))
        local size = filesize(file)
        local bytes_a = {}
        repeat
            local str = file:read(size)
            for c in (str or ''):gmatch'.' do
                bytes_a[#bytes_a+1] = c:byte()
                -- print (string.format("%i", c:byte()))
            end
        until not str
        assert(io.close(file))

        file = assert(io.open(PathB, "rb"))
        local size = filesize(file)
        local bytes_b = {}
        repeat
            local str = file:read(size)
            for c in (str or ''):gmatch'.' do
                bytes_b[#bytes_b+1] = c:byte()
                -- print (string.format("%i", c:byte()))
            end
        until not str
        assert(io.close(file))

        assert(#bytes_a == #bytes_b)
        local offsets = {}
        for i = 1, #bytes_a do
            if bytes_a[i] ~= bytes_b[i] then
                local Offset = i-2
                local Value = bytes_a[i] * 256 + bytes_a[i-1]
                -- print(string.format("Offset: 0x%04X = [0x%04X]", Offset, Value))
                offsets[#offsets+1] = Offset
            end
        end

        _pc("DB " .. #offsets)
        local size_offset = #offsets * 2                                        -- размер адресов смещений + количество + смещение к первой функции
        local old_offset = -size_offset
        for i = 1, #offsets do
            -- print(string.format("Offset: 0x%04X", offsets[i]))
            local offset = offsets[i] - old_offset;
            old_offset = offsets[i];
            _pc("DW " .. offset)
        end

    end
    endlua