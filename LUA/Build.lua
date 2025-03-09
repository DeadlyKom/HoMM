	lua pass3

	function increase_build(fname)
		local fp
		local build
		fp = assert(io.open(fname, "rb"))
		build = tonumber(fp:read("*all"))
		assert(fp:close())
		if type(build) == "nil" then
		   return
		end
		build = build + 1;
		sj.insert_define("BUILD", build)
		fp = assert(io.open(fname, "wb"))
		assert(fp:write( build ))
		assert(fp:flush())
		assert(fp:close())
	end

	increase_build("Tmp/Build.counter")
	sj.insert_define("TIME", '"' .. os.date("%Y-%m-%d %H:%M:%S") .. '"')

    endlua
