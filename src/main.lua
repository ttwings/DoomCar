require('globals')
require('lib.gooi')
Input = require( "lib.Input" )
Object = require("lib.classic")
Timer = require( "lib.Timer" )
Camera = require("lib.Camera")
util = require( "lib.util" )
Physics = require("lib.windfield")
Draft = require("lib.draft")
Vector = require("lib.vector")
fn = require("lib.moses")
bitser = require("lib.bitser")
function love.load(  )
    font = Fonts.unifont
    draft = Draft()
    love.graphics.setFont(font)
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")
    ww = love.graphics.getWidth()
    wh = love.graphics.getHeight()

    --love.window.setMode(ww,wh)
    --gw = 400
    --gh = 240
    --p_print(love.graphics.getDimensions())
    --sw = ww/gw
    --sh = wh/gh
    --p_print(gw,gh,sw,sh,ww,wh)
    resize(sw,sh)
    --- dpad ui img
    pad = {
        ['t'] = love.graphics.newImage("assets/graphics/ui/dpad_t.png"),
        ['b'] = love.graphics.newImage("assets/graphics/ui/dpad_b.png"),
        ['l'] = love.graphics.newImage("assets/graphics/ui/dpad_l.png"),
        ['r'] = love.graphics.newImage("assets/graphics/ui/dpad_r.png"),
        ['start'] = love.graphics.newImage("assets/graphics/ui/start.png"),
        ['back'] = love.graphics.newImage("assets/graphics/ui/back.png"),
    }
    --- @type Object[]
    local object_files = {}

    recursiveEnumerate('objects',object_files)
    requireFiles(object_files)

    slow_amount = 1
    input = Input()
    camera = Camera()
    timer = Timer()

    input:bind("1","left_click")
    input:bind('2','right_click')
    input:bind('3','zoom_in')
    input:bind('4','zoom_out')
    input:bind("left","left")
    input:bind("right","right")
    input:bind("up","up")
    input:bind("down","down")

    input:bind("f2",function ()
        --gotoRoom("Stage","Stage")
        --gotoRoom("StageShop","stage_shop")
        --gotoRoom("StageMain","stage_main")
        gotoRoom("SkillTree","skill_tree")
        --gotoRoom('StageMap','StageMap')
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
    --gotoRoom("StageShop","StageShop")
    flash_frames = nil
    tx ,ty = gw,gh
    --- apk 报错。 需要了解原因。 可能是需要判断系统？
    --loadData()
end

function love.update(dt)
    timer:update(dt*slow_amount)
    camera:update(dt*slow_amount)
    if current_room then current_room:update(dt*slow_amount) end
    touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
        tx, ty = love.touch.getPosition(id)
    end

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
    --love.graphics.circle("line", tx, ty, 20)
end

function love.mousereleased(x,y,button) gooi.released() end
function love.mousepressed(x,y,button) gooi.pressed() end


function slow(amount,duration)
    slow_amount = amount
    timer:tween(duration,_G,{slow_amount = 1},"in-out-cubic")
end

function flash(frames)
    flash_frames = frames
end


--- @type func
function saveData()
    local save_data  = {}
    --- set all save data here
    save_data.score = score
    save_data.skill_points = skill_points
    save_data.tree = tree
    save_data.achievements = achievements
    bitser.dumpLoveFile('save',save_data)
end

function loadData()
    if love.filesystem.getInfo('save').type == "file" then
        local save_data = bitser.loadLoveFile('save')
        --- load all save data here
        --- eg
        score = save_data.score
        --p_print(score)
        skill_points = save_data.skill_points
        tree = save_data.tree
        achievements = save_data.achievements
    else
        first_run_ever = true
    end
end