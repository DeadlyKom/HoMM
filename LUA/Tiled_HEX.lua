    lua allpass
    function ConvertTMX_Hex(input_filename, output_filename_bin)
        local fp
        
        fp = assert(io.open(input_filename, "rb"))
        assert(fp:close())
        
        local width, height
        local in_data = false
        local tiles = {}

        -- Tiled GID -> внутренний HextileID, используемый картой игры
        local transform = {
            [0]   = 7, -- пустой гексагон/контур
            [23]  = 0, -- трава                         (sprite_1)
            [46]  = 4, -- лес в середине гекса          (sprite_8)
            [48]  = 5, -- плотный лес                   (sprite_2)
            [111] = 6, -- укрепление                    (sprite_3)
            [133] = 3, -- маленькое поселение           (sprite_10)
            [137] = 2, -- болото                        (sprite_6)
            [160] = 1, -- гора                          (sprite_4)
        }

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
                local tile = tiles[index]
                local out_tile = transform[tile]

                assert(out_tile ~= nil, "Tile не описан в transform: "..tile)

                fp:write(string.char(out_tile))
                -- print (index, out_tile)
            end
        end

		assert(fp:flush())
		assert(fp:close())

        return width, height
    end
    endlua
