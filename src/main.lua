--local aoe = require( "object.Aoe" )
Input = require( "lib.Input" )
Object = require("lib.classic")
Timer = require( "lib.Timer" )
Camera = require("lib.camera")
--require("lib.Shake")
util = require( "lib.util" )
GameObject = require("objects.GameObject")
Stage = require("Objects.Stage")
-- require( "object.Circle" )
-- require( "object.CircleRoom" )
-- require( "object.RectangleRoom" )
-- require("object.PolygonRoom")
-- require( "object.Area" )
-- require( "object.Stage" )

function love.load(  )
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")
    font = love.graphics.newFont("assets/font/unifont.ttf",16)
    love.graphics.setFont(font)
    love.keyboard.setKeyRepeat(true)
    resize(3)
    local object_files = {}
    recursiveEnumerate('objects',object_files)
    requireFiles(object_files)

    input = Input()
    camera = Camera()
    input:bind("f1","circle")
    input:bind("f2","rectangle")
    input:bind("f3","polygon")
    input:bind("1",function() camera:shake(4,60,1) end )
    rooms = {}

    circle_room = CircleRoom()
    -- circle_room.area:addObject("Circle",100,100)
    addRoom("Stage","room")
    addRoom("CircleRoom","circle_room")
    addRoom("RectangleRoom","rectangle")
    addRoom("PolygonRoom","polygon")
    --circle_room.area:addObject("Circle",100,100)
    current_room = circle_room
end

function love.update(dt)
    camera:update(dt)
    if input:pressed('circle') then gotoRoom("CircleRoom","circle_room") end
    if input:pressed('rectangle') then gotoRoom("RectangleRoom","rectangle") end
    if input:pressed('polygon') then gotoRoom("PolygonRoom","polygon") end
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
    -- circle_room:draw()
end

