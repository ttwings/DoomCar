--- @class Stage
--- @field world World
--- @field area Area
require("objects.Area")

Stage = Object:extend()

function Stage:new()
	self.area = Area(self)
	self.font = font
	self.score = 0
	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass("Player")
	self.area.world:addCollisionClass("Projectile",{ignores = {"Projectile","Player"}})
	self.area.world:addCollisionClass("Collectable",{ignores = {"Collectable","Projectile","Player"}})
	self.area.world:addCollisionClass("Enemy",{ignores = {"Collectable","Projectile","Player"}})
	self.area.world:addCollisionClass("EnemyProjectile",{ignores = {"Collectable","Projectile","EnemyProjectile","Enemy"}})
	self.main_canvas = love.graphics.newCanvas(gw,gh)
	self.player = self.area:addObject("Player",gw/2,gh/2)
	input:bind("p",function ()
		self.area:addObject("Ammo")
		self.area:addObject("Rock")

		self.area:addObject("Shooter")

		self.area:addObject("Hp")
		self.area:addObject("Sp")
		self.area:addObject("Attack",0,0,{name = table.random(attacks_name)})
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
		camera:attach()
		--love.graphics.print("中文")
		if self.area then self.area:draw() end
		camera:detach()
	--- score
	love.graphics.setColor(Color.default)
	love.graphics.print('得分：' .. self.score,gw - 100,0)
	--- sp
	love.graphics.setColor(Color.skill_point)
	love.graphics.print('科技 : ' .. self.player.sp,0,0)
	-- HP
	local r, g, b = unpack(Color.hp)
	local hp, max_hp = self.player.hp, self.player.max_hp
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
	love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
	love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)
	love.graphics.print('护甲', gw/2 - 52 + 24, gh - 24, 0, 1, 1,
			math.floor(self.font:getWidth('护甲')/2), math.floor(self.font:getHeight()/2))
	love.graphics.print(hp .. '/' .. max_hp, gw/2 - 52 + 24, gh - 6, 0, 1, 1,
			math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2),
			math.floor(self.font:getHeight()/2))

	-- Ammo
	local r, g, b = unpack(Color.ammo)
	local ammo, max_ammo = self.player.ammo, self.player.max_ammo
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 - 52, 16, 48*(ammo/max_ammo), 4)
	love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
	love.graphics.rectangle('line', gw/2 - 52, 16, 48, 4)
	love.graphics.print('弹药', gw/2 - 52 + 24, 24, 0, 1, 1,
			math.floor(self.font:getWidth('弹药')/2), math.floor(self.font:getHeight()/2))
	love.graphics.print(ammo .. '/' .. max_ammo, gw/2 - 52 + 24, 6, 0, 1, 1,
			math.floor(self.font:getWidth(ammo .. '/' .. max_ammo)/2),
			math.floor(self.font:getHeight()/2))

	-- Boost
	local r, g, b = unpack(Color.boost)
	local boost, max_boost = self.player.boost, self.player.max_boost
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', gw/2 + 4, 16, 48*(boost/max_boost), 4)
	love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
	love.graphics.rectangle('line', gw/2 + 4, 16, 48, 4)
	love.graphics.print('燃料', gw/2 + 24 + 4, 24, 0, 1, 1,
			math.floor(self.font:getWidth('燃料')/2), math.floor(self.font:getHeight()/2))
	love.graphics.print(math.floor(boost) .. '/' .. max_boost, gw/2 + 24 + 4, 6, 0, 1, 1,
			math.floor(self.font:getWidth(math.floor(boost)  .. '/' .. max_boost)/2),
			math.floor(self.font:getHeight()/2))

	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.setBlendMode('alpha','premultiplied')
	love.graphics.draw(self.main_canvas,0,0,0,3,3)
	love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
	if self.area then
		self.area:destroy()
		self.area = nil
	end
	if self.director then
		self.director:destroy()
		self.director = nil
	end
end

function Stage:finished()
	table.insert(score,self.score)
	timer:after(1,function ()
		gotoRoom("StageEnd","StageEnd")
		p_print("new stage")
	end)
	debug.getCollection()
end

function Stage:deactivate()
	p_print("deactivate")
	self:destroy()
end

function Stage:activate()
	self:new()
end

return Stage