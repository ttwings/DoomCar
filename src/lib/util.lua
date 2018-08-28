function resize( s )
	love.window.setMode(s*gw,s*gh)
	sx,sy = s,s
end

function UUID()
	local fn = function ( x )
		local r = love.math.random(16) - 1
		r = (x == 'x') and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef"):sub(r,r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]",fn))
end

function addRoom( room_type, room_name, ... )
    local room = _G[room_type](room_name, ...)
    rooms[room_name] = room
    return room
end

function gotoRoom( room_type, room_name, ... )
    if current_room and rooms[room_name] then
        if current_room.deactivate then current_room:activate() end
        current_room = rooms[room_name]
        if current_room.activate then current_room:activate() end
    else current_room = addRoom(room_type, room_name, ...) end
end

function recursiveEnumerate( folder,file_list )
    local items = love.filesystem.getDirectoryItems(folder)
    for _,item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list,file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file,file_liset)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1,-5)
        require(file)
    end
end

function random(min,max)
    local min,max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end