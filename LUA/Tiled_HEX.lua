    lua allpass
    function ConvertTMX_Hex(input_filename, output_filename_bin)
        local fp
        
        fp = assert(io.open(input_filename, "rb"))
        assert(fp:close())
        
        local width, height
        local in_data = false
        local tiles = {}

        for line in io.lines(input_filename) do

            -- ищем размеры слоя
            local w, h = line:match('<layer.-width="(%d+)".-height="(%d+)"')
            if w and h then
                width  = tonumber(w)
                height = tonumber(h)
                -- print (width, height)
            end

            -- начало CSV
            if line:find('<data') and line:find('encoding="csv"') then
                in_data = true
            elseif line:find('</data>') then
                in_data = false
            elseif in_data then
                for n in line:gmatch('%d+') do
                    tiles[#tiles + 1] = tonumber(n)
                end
            end
        end

        fp = assert(io.open(output_filename_bin, "wb"))

        for y = 0, height-1 do
            for x = 0, width-1 do
                local index = (y * width + x) + 1
                assert(fp:write(string.char(tiles[index])))
                -- print (index, tiles[index])
            end
        end

		assert(fp:flush())
		assert(fp:close())

        return width, height
    end
    endlua