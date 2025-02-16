
    lua allpass

    local id = 0 -- autoincremented id
    function ID(set)
        if set then
            id = set
        else
            id = id + 1
        end
        return id - 1
    end

    local Map = {
        [ID()] = 0x00,  -- space
        [ID()] = 0x01,  -- !
        [ID()] = 0x02,  -- "
        [ID()] = 0x03,  -- #
        [ID()] = 0x04,  -- $
        [ID()] = 0x05,  -- %
        [ID()] = 0x06,  -- &
        [ID()] = 0x07,  -- '
        [ID()] = 0x08,  -- (
        [ID()] = 0x09,  -- )
        [ID()] = 0x0A,  -- *
        [ID()] = 0x0B,  -- +
        [ID()] = 0x0C,  -- ,
        [ID()] = 0x0D,  -- -
        [ID()] = 0x0E,  -- .
        [ID()] = 0x0F,  -- /

        [ID()] = 0x10,  -- 0
        [ID()] = 0x11,  -- 1
        [ID()] = 0x12,  -- 2
        [ID()] = 0x13,  -- 3
        [ID()] = 0x14,  -- 4
        [ID()] = 0x15,  -- 5
        [ID()] = 0x16,  -- 6
        [ID()] = 0x17,  -- 7
        [ID()] = 0x18,  -- 8
        [ID()] = 0x19,  -- 9
        [ID()] = 0x1A,  -- :
        [ID()] = 0x1B,  -- ;
        [ID()] = 0x1C,  -- <
        [ID()] = 0x1D,  -- =
        [ID()] = 0x1E,  -- >
        [ID()] = 0x1F,  -- ?

        [ID()] = 0x20,  -- 
        [ID()] = 0x21,  -- A
        [ID()] = 0x22,  -- B
        [ID()] = 0x23,  -- C
        [ID()] = 0x24,  -- D
        [ID()] = 0x25,  -- E
        [ID()] = 0x26,  -- F
        [ID()] = 0x27,  -- G
        [ID()] = 0x28,  -- H
        [ID()] = 0x29,  -- I
        [ID()] = 0x2A,  -- J
        [ID()] = 0x2B,  -- K
        [ID()] = 0x2C,  -- L
        [ID()] = 0x2D,  -- M
        [ID()] = 0x2E,  -- N
        [ID()] = 0x2F,  -- O

        [ID()] = 0x30,  -- P
        [ID()] = 0x31,  -- Q
        [ID()] = 0x32,  -- R
        [ID()] = 0x33,  -- S
        [ID()] = 0x34,  -- T
        [ID()] = 0x35,  -- U
        [ID()] = 0x36,  -- V
        [ID()] = 0x37,  -- W
        [ID()] = 0x38,  -- X
        [ID()] = 0x39,  -- Y
        [ID()] = 0x3A,  -- Z
        [ID()] = 0x3B,  -- [
        [ID()] = 0x3C,  -- косая влево
        [ID()] = 0x3D,  -- ]
        [ID()] = 0x3E,  -- очистка
        [ID()] = 0x3F,  -- _

        [ID()] = 0x40,  -- '
        [ID()] = 0x41,  -- a
        [ID()] = 0x42,  -- b
        [ID()] = 0x43,  -- c
        [ID()] = 0x44,  -- d
        [ID()] = 0x45,  -- e
        [ID()] = 0x46,  -- f
        [ID()] = 0x47,  -- g
        [ID()] = 0x48,  -- h
        [ID()] = 0x49,  -- i
        [ID()] = 0x4A,  -- j
        [ID()] = 0x4B,  -- k
        [ID()] = 0x4C,  -- l
        [ID()] = 0x4D,  -- m
        [ID()] = 0x4E,  -- n
        [ID()] = 0x4F,  -- o

        [ID()] = 0x50,  -- p
        [ID()] = 0x51,  -- q
        [ID()] = 0x52,  -- r
        [ID()] = 0x53,  -- s
        [ID()] = 0x54,  -- t
        [ID()] = 0x55,  -- u
        [ID()] = 0x56,  -- v
        [ID()] = 0x57,  -- w
        [ID()] = 0x58,  -- x
        [ID()] = 0x59,  -- y
        [ID()] = 0x5A,  -- z
        [ID()] = 0x5B,  -- {
        [ID()] = 0x5C,  -- |
        [ID()] = 0x5D,  -- }
        [ID()] = 0x5E,  -- ~
        [ID()] = 0x5F,  --
        
        [string.byte('¡')]  = 0x20,  -- ¡
        [string.byte('¿')]  = 0x5F,  -- ¿

        [0xD090] = 0x21,  -- A
        [0xD091] = 0x61,  -- Б
        [0xD092] = 0x22,  -- В
        [0xD093] = 0x64,  -- Г
        [0xD094] = 0x66,  -- Д
        [0xD095] = 0x25,  -- E
        [0xD096] = 0x6B,  -- Ж
        [0xD097] = 0x6D,  -- З
        [0xD098] = 0x6F,  -- И
        [0xD099] = 0x71,  -- Й
        [0xD09A] = 0x2B,  -- К
        [0xD09B] = 0x74,  -- Л
        [0xD09C] = 0x2D,  -- М
        [0xD09D] = 0x28,  -- Н
        [0xD09E] = 0x2F,  -- О
        [0xD09F] = 0x78,  -- П

        [0xD0A0] = 0x30,  -- Р
        [0xD0A1] = 0x23,  -- С
        [0xD0A2] = 0x34,  -- Т
        [0xD0A3] = 0x7C,  -- У
        [0xD0A4] = 0x7D,  -- Ф
        [0xD0A5] = 0x38,  -- Х
        [0xD0A6] = 0x7F,  -- Ц
        [0xD0A7] = 0x81,  -- Ч
        [0xD0A8] = 0x83,  -- Ш
        [0xD0A9] = 0x85,  -- Щ
        [0xD0AA] = 0x8B,  -- Ъ
        [0xD0AB] = 0x87,  -- Ы
        [0xD0AC] = 0x89,  -- Ь
        [0xD0AD] = 0x8D,  -- Э
        [0xD0AE] = 0x8F,  -- Ю
        [0xD0AF] = 0x91,  -- Я

        [0xD0B0] = 0x60,  -- а
        [0xD0B1] = 0x62,  -- б
        [0xD0B2] = 0x63,  -- в
        [0xD0B3] = 0x65,  -- г
        [0xD0B4] = 0x67,  -- д
        [0xD0B5] = 0x68,  -- е
        [0xD0B6] = 0x6C,  -- ж
        [0xD0B7] = 0x6E,  -- з
        [0xD0B8] = 0x70,  -- и
        [0xD0B9] = 0x72,  -- й
        [0xD0BA] = 0x73,  -- к
        [0xD0BB] = 0x75,  -- л
        [0xD0BC] = 0x76,  -- м
        [0xD0BD] = 0x77,  -- н
        [0xD0BE] = 0x4F,  -- о
        [0xD0BF] = 0x79,  -- п

        [0xD180] = 0x7A,  -- р
        [0xD181] = 0x43,  -- с
        [0xD182] = 0x7B,  -- т
        [0xD183] = 0x59,  -- у
        [0xD184] = 0x7E,  -- ф
        [0xD185] = 0x58,  -- х
        [0xD186] = 0x80,  -- ц
        [0xD187] = 0x82,  -- ч
        [0xD188] = 0x84,  -- ш
        [0xD189] = 0x86,  -- щ
        [0xD18A] = 0x8C,  -- ъ
        [0xD18B] = 0x88,  -- ы
        [0xD18C] = 0x8A,  -- ь
        [0xD18D] = 0x8E,  -- э
        [0xD18E] = 0x90,  -- ю
        [0xD18F] = 0x92,  -- я

        [0xD081] = 0x69,  -- Ё
        [0xD191] = 0x6A,  -- ё
    };

    -- Get a value by ID
    function get(char)
        -- return Map[char]
        if Map[char] == nil then
            print (string.format("error %i", char))
            return 0;
        else
            return Map[char]
        end
        -- return assert(Map[id]).value
    end

    function Convert(string)
        local word = 0
        for i = 1, #string do
            local char = string:sub(i,i)
            local byte = string.byte(char)
            if byte >= 208 and word == 0 then
                word = byte
            elseif word > 0 then    -- ru
                word = word * 256 + byte
                --print (string.format("%s,  %s", word, get(word)))
                _pc("DB " .. get(word) + 32)
                word = 0
            else                    -- en
                local byte = get(string.byte(char) - 32)
                _pc("DB " .. byte + 32)
                --print (string.format("%s,  %s", char, byte))
            end
        end
        _pc("DB #00")
    end
    endlua