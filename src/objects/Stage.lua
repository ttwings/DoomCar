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
	---- director
	self.director = Director(self)
	--- camera  follow style  LOCKON  PLATFORMER TOPDOWN  TOPDOWN_TIGHT  SCREEN_BY_SCREEN  NO_DEADZONE
	camera:setFollowStyle('NO_DEADZONE')
    --- gooi ui
    style = {
        font = Fonts.unifont,
        showBorder = false,
    }
    gooi.setStyle(style)
	self.jx,self.jy = 0,gh*sh - 130
    img_ui_dir = "assets/graphics/ui/"
    joy_ship = gooi.newJoy({group = "Stage",x = self.jx,y = self.jy,size = 128}):setDigital():setStyle({bgColor = {1,1,1,0.1},showBorder = true})
    button_shot_main = gooi.newButton({group = "Stage",text = "" ,x = gw*sw - 40,y = gh*sh - 80,icon=img_ui_dir .. "dpad_b.png"}):bg({1,1,1,0.1}):onRelease(
            function()
                self.player:shot(dt)
            end
    )

    gooi.newButton({group = "Stage",x = gw*sw - 60,y = 10,text = "返回"}):bg({1,1,1,0.1}):onRelease(
            function()
                gotoRoom("StageMain","StageMain")
                gooi.setGroupEnabled("Stage",false)
                gooi.setGroupVisible("Stage",false)
                gooi.setGroupEnabled("StageMain",true)
                gooi.setGroupVisible("StageMain",true)
            end
    )
end

function Stage:update(dt)
	if self.area then self.area:update(dt) end
	if self.director then self.director:update(dt) end
	camera:update(dt)
	camera:follow(self.player.x + gw/sw, self.player.y + gh/sh)
    gooi.update(dt)
    ---
    local dir = joy_ship:direction()
    if dir:match('l') then
        self.player:turnLeft(dt)
    elseif dir:match('r') then
        self.player:turnRight(dt)
    end
    if dir:match('t') then
        self.player:up(dt)
    elseif dir:match('b') then
        self.player:down(dt)
    end
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach(0,0,gw*sw,gh*sh)
	if self.area then self.area:draw() end
	camera:detach()
	camera:draw()
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
	r, g, b = unpack(Color.ammo)
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
	r, g, b = unpack(Color.boost)
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
	--- draw virtual game pad
	love.graphics.setColor(1,1,1,1)
	love.graphics.circle('line',self.jx,self.jy,50)
	--love.graphics.setColor(1,1,1,0.7)
	--love.graphics.circle('fill',40,gh - 40,20)
	--love.graphics.circle('fill',gw - 20,gh - 40,15)
	--love.graphics.circle('fill',gw - 60,gh - 40,15)
	--love.graphics.circle('fill',gw - 40,gh - 40,20)

	--local touches = love.touch.getTouches()
    --
	--for i, id in ipairs(touches) do
	--	local x, y = love.touch.getPosition(id)
	--	love.graphics.circle("fill", x, y, 20)
	--end

    --
	--love.graphics.draw(pad.l,gw - 32,gh - 64)
	--love.graphics.draw(pad.r,gw - 96,gh - 64)
	--love.graphics.draw(pad.t,gw - 64,gh - 32)
	--love.graphics.draw(pad.b,gw - 64,gh - 96)
	--love.graphics.draw(pad.start,gw/2 + 24,gh - 24)
	--love.graphics.draw(pad.back,gw/2 - 24,gh - 24)
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.setBlendMode('alpha','premultiplied')
	love.graphics.draw(self.main_canvas,0,0,0,sw,sh)
	love.graphics.setBlendMode('alpha')
    --- ui draw
    gooi.draw("Stage")
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
        if not achievements['10k Fighter'] and score >=10000 and device == 'Fighter' then
            achievements['10k Fighter'] = true
        end
    end)
end

function Stage:deactivate()
	self:destroy()
end

function Stage:activate()
	self:new()
end

return Stage