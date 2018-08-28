Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.main_canvas = love.graphics.newCanvas(gw,gh)
	self.player = self.area:addObject("Player",gw/2,gh/2)
	input:bind('f4',function () self.player.dead = true end )
end

function Stage:update(dt)
	if self.area then self.area:update(dt) end
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
		camera:attach(0,0,gw,gh)
		--love.graphics.circle("line",gw/2,gh/2,50)
		self.area:draw()
		camera:detach()
	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	love.graphics.setBlendMode('alpha','premultiplied')
	love.graphics.draw(self.main_canvas,0,0,0,sx,sy)
	love.graphics.setBlendMode('alpha')
end

return Stage