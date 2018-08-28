Input = require( "lib.Input" )
Object = require("lib.classic")
Timer = require( "lib.Timer" )
Camera = require("lib.Camera")
util = require( "lib.util" )

function love.load(  )
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")
    --font = love.graphics.newFont("assets/font/unifont.ttf",16)
    --love.graphics.setFont(font)
    resize(3)
    local object_files = {}
    recursiveEnumerate('objects',object_files)
    requireFiles(object_files)
    p_print(#object_files)

    input = Input()
    camera = Camera()
    --input:bind("f1","circle")
    --input:bind("f2","rectangle")
    --input:bind("f3","polygon")
    input:bind("1",function() camera:shake(4,1,60) end )

    input:bind("k",function ()
        print("Before collection : " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection : ".. collectgarbage("count")/1024)
        print("object count : " )
        local counts = type_count()
        for k , v in pairs(counts) do print(k,v) end
        print("------------------------------")
    end)

    rooms = {}
    gameStage = addRoom("Stage","room")
    current_room = gameStage
end

function love.update(dt)
    camera:update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

