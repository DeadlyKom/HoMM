    lua allpass
    function ConvertMapTilded(file_name, file_array)
        local fp
        
        fp = assert(io.open(file_name, "rb"))
        assert(fp:close())

        Layer = 0
        numbers = {}
        for line in io.lines(file_name) do
            if data == 1 then
                _, _, _data = line:find("/data(%/?)")
                if _data ~= nil then
                    data = 0
                else
                    for str in line:gmatch("[^,]+") do
                        local number = tonumber(str) - 1
                        table.insert(numbers, number)
                    end
                end

            else
                _, _, layer = line:find("layer id=\"(%d)\"")
                if layer ~= nil then
                    _, _, layer, width, height = line:find("(%d+)[^%d]+(%d+)[^%d]+(%d+)")
                    Layer = layer
                else
                    _, _, _data = line:find("data encoding=(%/?)")
                    if _data ~= nil then
                        data = 1
                    end
                end
            end
        end

        -- print("File: "..file_array.. " [ layer: " ..Layer.. " ("..width.." x "..height..") = "..#numbers.. " byte(s) ]")

        fp = assert(io.open(file_array, "wb"))

        for i = 1, #numbers do
            assert(fp:write(string.char(numbers[i])))
        end

		assert(fp:flush())
		assert(fp:close())

        return width, height

    end

    endlua
