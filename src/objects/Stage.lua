--- @class Stage
--- @field world World
--- @field area Area

Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass("Player")
	self.area.world:addCollisionClass("Projectile",{ignores = {"Projectile","Player"}})
	self.area.world:addCollisionClass("Collectable",{ignores = {"Collectable","Projectile","Player"}})
	self.area.world:addCollisionClass("Enemy",{ignores = {"Collectable","Projectile","Player"}})
	self.area.world:addCollisionClass("EnemyProjectile",{ignores = {"Collectable","Projectile","EnemyProjectile","Enemy"}})
	self.main_canvas = love.graphics.newCanvas(gw,gh)
	self.player = self.area:addObject("Player",gw/2,gh/2)
	input:bind("p",function ()
		--self.area:addObject("Ammo",random(0,gw),random(0,gh))
		--self.area:addObject("Rock",random(32,gw - 32),random(32,gh - 32))
		self.area:addObject("Shooter",random(32,gw - 32),random(32,gh - 32))

		--self.area:addObject("Hp")
		--self.area:addObject("Sp")
		--self.area:addObject("Attack",0,0,{name = table.random(attacks_name)})
	end )

	---- director
	self.director = Director(self)


end

function Stage:update(dt)
	if self.area then self.area:update(dt) end
	if self.director then self.director:update(dt) end
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
		camera:attach(0,0,sw*gw,sh*gh)
		love.graphics.print("中文")
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