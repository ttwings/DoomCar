Input = require( "lib.Input" )
Object = require("lib.classic")
Timer = require( "lib.Timer" )
Camera = require("lib.Camera")
util = require( "lib.util" )
Physics = require("lib.windfield")

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

    slow_amount = 1
    input = Input()
    camera = Camera()
    timer = Timer()
    --input:bind("f1","circle")
    --input:bind("f2","rectangle")
    --input:bind("f3","polygon")
    input:bind("1",function() camera:shake(4,1,60) end )
    input:bind("left","left")
    input:bind("right","right")

    input:bind("f2",function ()
        testRoom = addRoom("Stage","testRoom")
        gotoRoom("Stage","testRoom")
    end)

    input:bind("f3",function ()
        current_room:destroy()
    end)


    input:bind("f1",function ()
        print("Before collection : " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection : ".. collectgarbage("count")/1024)
        print("object count : " )
        local counts = type_count()
        for k , v in pairs(counts) do print(k,v) end
        print("------------------------------")
    end)

    rooms = {}
    --gameStage = addRoom("Stage","room")
    current_room = nil
end

function love.update(dt)
    timer:update(dt*slow_amount)
    camera:update(dt*slow_amount)
    if current_room then current_room:update(dt*slow_amount) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function slow(amount,duration)
    slow_amount = amount
    timer:tween(duration,_G,{slow_amount = 1},"in-out-cubic")
end
