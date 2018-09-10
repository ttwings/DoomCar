--- @class Stage

Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.area:addPhysicsWorld()
	self.main_canvas = love.graphics.newCanvas(gw,gh)
	self.player = self.area:addObject("Player",gw/2,gh/2)
end

function Stage:update(dt)
	if self.area then self.area:update(dt) end
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
		camera:attach(0,0,sw*gw,sh*gh)
		if self.area then self.area:draw() end
		camera:detach()
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.setBlendMode('alpha','premultiplied')
	love.graphics.draw(self.main_canvas,0,0,0,3,3)
	love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
	if self.area then
		self.area:destroy()
		self.area = nil
	end
end

return Stage