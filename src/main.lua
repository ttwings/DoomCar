Input = require( "lib.Input" )
Object = require("lib.classic")
Timer = require( "lib.Timer" )
Camera = require("lib.Camera")
util = require( "lib.util" )
Physics = require("lib.windfield")
Draft = require("lib.draft")
Vector = require("lib.vector")
fn = require("lib.moses")

function love.load(  )
    font = Fonts.unifont
    --font = love.graphics.newFont("assets/font/SourceHanSerifCN-Regular.otf")
    draft = Draft()
    love.graphics.setFont(font)
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")
    --font = love.graphics.newFont("assets/font/unifont.ttf",16)
    --love.graphics.setFont(font)
    resize(3)
    --- @type Object[]
    local object_files = {}

    recursiveEnumerate('objects',object_files)
    requireFiles(object_files)

    slow_amount = 1
    input = Input()
    camera = Camera()
    timer = Timer()

    input:bind("mouse1","mouse1")
    input:bind("left","left")
    input:bind("right","right")
    input:bind("up","up")
    input:bind("down","down")

    input:bind("f2",function ()
        --testRoom = addRoom("Stage","testRoom")
        --stage_shop = addRoom("StageShop","stage_shop")
        --gotoRoom("Stage","Stage")
        --gotoRoom("StageShop","stage_shop")
        gotoRoom("StageMain","stage_main")
    end)

    input:bind("f3",function ()
        current_room:destroy()
    end)


    input:bind("f1",function ()
        debug.getCollection()
    end)
    --- @type Stage[]
    rooms = {}
    --current_room = StageMain:new()
    gotoRoom("StageMain","StageMain")
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