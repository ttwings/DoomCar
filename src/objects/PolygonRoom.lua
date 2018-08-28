-- PolygonRoom.lua
PolygonRoom = Stage:extend()

function PolygonRoom:draw()
	love.graphics.polygon("fill", 100,20,150,80,10,200)
end