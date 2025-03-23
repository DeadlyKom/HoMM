
                ifndef _MODULE_CORE_VERSION_TEXT_
                define _MODULE_CORE_VERSION_TEXT_
VersionText     BYTE "ver. "
.Major          DB '0' + MAJOR, '.'
.Minor          DB '0' + MINOR, '.'
.Build          ; преобразование объявления в строку
                lua allpass
                local num = sj.get_define("BUILD")
                local string = tostring(math.floor((num / 3) / 256))
                --print (string)
                for i = 1, #string do
                    local char = string:sub(i,i)
                    local byte = string.byte(char)
                    --print (byte)
                    _pc("DB " .. byte)
                end
                endlua
                DB "\0"

                endif ; ~_MODULE_CORE_VERSION_TEXT_
