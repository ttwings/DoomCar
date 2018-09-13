Input = require( "lib.Input" )
Object = require("lib.classic")
Timer = require( "lib.Timer" )
Camera = require("lib.Camera")
util = require( "lib.util" )
Physics = require("lib.windfield")
fn = require("lib.moses")

function love.load(  )
    font = Fonts.unifont
    love.graphics.setFont(font)
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

    input:bind("left","left")
    input:bind("right","right")
    input:bind("up","up")
    input:bind("down","down")

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
    current_room = nil
    flash_frames = nil
end

function love.update(dt)
    timer:update(dt*slow_amount)
    camera:update(dt*slow_amount)
    if current_room then current_room:update(dt*slow_amount) end
end

function love.draw()
    if current_room then current_room:draw() end
    if flash_frames then
        flash_frames = flash_frames - 1
        if flash_frames < 0 then
            flash_frames = nil
        end
    end

    if flash_frames then
        love.graphics.setColor(Color.background)
        love.graphics.rectangle("fill",0,0,sw*gw,sh*gh)
        love.graphics.setColor(1,1,1,1)
    end
   
end

function slow(amount,duration)
    slow_amount = amount
    timer:tween(duration,_G,{slow_amount = 1},"in-out-cubic")
end

function flash(frames)
    flash_frames = frames
end