function p_print(...)
    local info = debug.getinfo(2, "Sl")
    local source = info.source
    local msg = ("%s:%i ->"):format(source, info.currentline)
    print(msg, ...)
end

function resize( s )
	love.window.setMode(s*gw,s*gh)
	sw,sh = s,s
end

--- @type fun():string
function UUID()
	local fn = function ( x )
		local r = love.math.random(16) - 1
		r = (x == 'x') and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef"):sub(r,r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]",fn))
end
--- @type fun():Stage
function addRoom( room_type, room_name, ... )
    local room = _G[room_type](room_name, ...)
    rooms[room_name] = room
    return room
end
--- @type fun(room_type:string,room_name:string)
function gotoRoom( room_type, room_name, ... )
    if current_room and current_room.destroy then current_room:destroy() end
    if current_room and rooms[room_name] then
        if current_room.deactivate then current_room:activate() end
        current_room = rooms[room_name]
        if current_room.activate then current_room:activate() end
    else current_room = addRoom(room_type, room_name, ...) end
end
--- @type fun(folder:string,file_list:table)
function recursiveEnumerate( folder,file_list )
    local items = love.filesystem.getDirectoryItems(folder)
    for _,item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.getInfo(file).type == "file" then
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

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
        f(t)
        seen[t] = true
        for k,v in pairs(t) do
            if type(v) == "table" then
                count_table(v)
            elseif type(v) == "userdata" then
                f(v)
            end
        end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
        for k,v in pairs(_G) do
            global_type_table[v] = k
        end
        global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end

---@see GameObject

function pushRote(x,y,r,sx,sy)
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1,sy or sx or 1)
    love.graphics.translate(-x,-y)
end

---

Color = {}
Color.default = {1,1,1}
Color.background = {22/256,22/256,22/256}
Color.ammo = {123/256,200/256,164/256}
Color.boost = {76/256,195/256,217/256}
Color.hp = {241/256,103/256,69/256}
Color.skill_point = {255/256,198/256,93/256}
Color.trail_color = {0,0,1}

---
Fonts = {}
Fonts.unifont = love.graphics.newFont("assets/font/unifont.ttf")

--- table

function table.random(t)
    return t[math.random(1,#t)]
end

function table.copy(t)
    local table = {}

end

--- func

function chanceList( ... )
    return{
        chance_list = {},
        chance_definitions = { ... },
        next = function(self)
            if #self.chance_list == 0 then
                for _,chance_definition in ipairs(self.chance_definitions) do
                    for i = 1,chance_definition[2] do
                        table.insert(self.chance_list,chance_definition[1])
                    end
                end
            end
            return table.remove(self.chance_list,random(1,#self.chance_list))
        end
    }
end