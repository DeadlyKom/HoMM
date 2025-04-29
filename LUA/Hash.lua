    lua allpass

    local function checkint( name, argidx, x, level )
        local n = tonumber( x )
        if not n then
            error( string.format(
                "bad argument #%d to '%s' (number expected, got %s)",
                argidx, name, type( x )
            ), level + 1 )
        end
        return math.floor( n )
    end
    
    local function checkint32( name, argidx, x, level )
        local n = tonumber( x )
        if not n then
            error( string.format(
                "bad argument #%d to '%s' (number expected, got %s)",
                argidx, name, type( x )
            ), level + 1 )
        end
        return math.floor( n ) % 0x100000000
    end

    function ror( x, disp )
        x = checkint32( 'ror', 1, x, 2 )
        disp = -checkint( 'ror', 2, disp, 2 ) % 32
    
        local x = x * 2^disp
        return ( x % 0x100000000 ) + math.floor( x / 0x100000000 )
    end

    function Hash(string)

        local HASH = 0x5AA5A55A
        for i = 1, #string do
            local char = string:sub(i,i)
            local byte = string.byte(char)
            HASH = (ror(HASH, 5) + HASH + byte) % 0x100000000
            -- print (string.format(" %i, %s -> hash:  0x%X", i, string, HASH))
        end

        return HASH
    end
    

    function Hash32(string)

        local HASH = Hash(string)

        -- print (string.format("%s -> hash:  0x%X", string, HASH))
        _pc("DW " ..  (HASH & 0xFFFF))
        _pc("DW " .. ((HASH >> 16) & 0xFFFF))

        return HASH
    end

    function Hash16(string)

        local HASH = Hash(string)
        HASH = (((HASH >> 16) & 0xFFFF) + (HASH & 0xFFFF)) % 0x10000
        -- print (string.format("%s -> hash:  0x%X", string, HASH))
        _pc("DW " ..  HASH)

    end
    endlua