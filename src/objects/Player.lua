---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/8/28 下午8:28
---

---@class Player

require("globals")

Player = NewGameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.r = -math.pi / 2
    self.rv = 1.66 * math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100

    self.max_boost = 100
    self.boost = self.max_boost
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2

    self.max_hp = 100
    self.hp = self.max_hp

    self.max_ammo = 100
    self.ammo = self.max_ammo

    self.max_sp = 1000
    self.sp = 0

    self.trail_color = Color.skill_point

    self:setAttack("Neutral")
    --self:setAttack("Double")
    --self:setAttack("Triple")
    --self:setAttack("Rapid")
    --self:setAttack("Spread")
    --self:setAttack("Back")
    --self:setAttack("Side")
    --self:setAttack("Blast")
    self.invincible = false
    self.invincible_time = 0
    self.invincible_max_time = 0.3
    self.visible = true

    self.shoot_timer = 0
    self.shoot_cooldown = attacks[self.attack].cooldown
    ---- draw ship polygons ----
    self.ship = "Fighter"
    self.polygons = {}
    --if self.ship == "Fighter" then
    --    self.polygons[1] = {
    --        self.w, 0, -- 1
    --        self.w / 2, -self.w / 2, -- 2
    --        -self.w / 2, -self.w / 2, -- 3
    --        -self.w, 0, -- 4
    --        -self.w / 2, self.w / 2, -- 5
    --        self.w / 2, self.w / 2, -- 6
    --    }
    --    self.polygons[2] = {
    --        self.w / 2, -self.w / 2, -- 7
    --        0, -self.w, -- 8
    --        -self.w - self.w / 2, -self.w, -- 9
    --        -3 * self.w / 4, -self.w / 4, -- 10
    --        -self.w / 2, -self.w / 2, -- 1
    --    }
    --    self.polygons[3] = {
    --        self.w / 2, self.w / 2, -- 12
    --        -self.w / 2, self.w / 2, -- 13
    --        -3 * self.w / 4, self.w / 4, -- 14
    --        -self.w - self.w / 2, self.w, -- 15
    --        0, self.w, -- 16
    --    }
    --end

    self.timer:every(0.01, function()
        self.area:addObject("TrailParticle", self.x - self.w * math.cos(self.r),
                self.y - self.h * math.sin(self.r), { parent = self, r = random(2, 4), d = random(0.15, 0.25),
                                                      color = self.trail_color }
        )
    end)

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    --self.area.world:addCollisionClass("Player")
    self.collider:setCollisionClass("Player")
    self.collider:setObject(self)
    self.attack_speed = 1
    --self.timer:every(0.24 , function()
    --    self:shot()
    --end)
    self.timer:every(5, function()
        self:tick()
    end)
    input:bind('f4', function()
        self:die()
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)
    if self.collider:enter("Enemy") then
        local collision_data = self.collider:getEnterCollisionData("Enemy")
        local object = collision_data.collider:getObject()
        if object:is(Rock) and not self.invincible then
            object:hit(10)
            self:hit(30)
        end
        if object:is(Shooter) and not self.invincible then
            object:hit(10)
            self:hit(30)
        end
    end
    --- collect able
    if self.collider:enter("Collectable") then
        local collision_data = self.collider:getEnterCollisionData("Collectable")
        local object = collision_data.collider:getObject()

        if object:is(Ammo) then
            object:die()
            self:addAmmo(5)
        end

        if object:is(Boost) then
            object:die()
            self:addBoost(25)
        end

        if object:is(Hp) then
            object:die()
            self:addHp(10)
        end

        if object:is(Sp) then
            object:die()
            self:addSp(1)
        end

        if object:is(Attack) then
            object:die()
            self:setAttack(object.name)
        end
    end

--- out bound
    if self.x < 0 then
        self:die()
    end
    if self.y < 0 then
        self:die()
    end
    if self.x > gw then
        self:die()
    end
    if self.y > gh then
        self:die()
    end
--- boost
    self.boost = math.min(self.max_boost,self.boost + 10 * dt)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.max_v = self.base_max_v
    self.boosting = false
--- input
    if input:down("up") and self.boost > 1 and self.can_boost then
        self.boosting = true
        self.max_v = 1.5 * self.base_max_v
        self.boost = self.boost - 50 * dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    if input:down("down") and self.boost > 1 and self.can_boost then
        self.boosting = true
        self.max_v = 0.5 * self.base_max_v
        self.boost = self.boost - 50 * dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    self.trail_color = Color.skill_point
    if self.boosting then
        self.trail_color = Color.boost
    end
    if input:down("left") then
        self.r = self.r - self.rv * dt
    end
    if input:down("right") then
        self.r = self.r + self.rv * dt
    end
    self.v = math.min(self.v + self.a * dt, self.max_v)
    --- 在windfield源码的备注中找到。。。。貌似用的 love2d physics的方法。
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
--- shoot
    self.shoot_timer = self.shoot_timer + dt
    if self.shoot_timer > self.shoot_cooldown then
        self.shoot_timer = 0
        self:shot()
    end
end

function Player:draw()
    if not self.visible then return end
    pushRote(self.x, self.y, self.r - math.pi/2)
    --love.graphics.circle('line', self.x, self.y, self.w / 2)
    --love.graphics.rectangle("line", self.x - self.w, self.y - self.h, 2 * self.w, 2 * self.h)
    --love.graphics.line(self.x, self.y, self.x + 2 * self.w, self.y)

    -----
    draft:diamond(self.x,self.y,2 * self.w,'line')
    draft:circle(self.x,self.y,self.w/3,8,'line')
    --- 和尚 圆
    --draft:circle(self.x,self.y,self.w * 2,10,"line")
    --draft:circle(self.x,self.y + 3,3,5,"line")
    --draft:circle(self.x,self.y - 3,3,5,"line")
    --draft:circle(self.x + 3,self.y + 3,3,5,"line")
    --draft:circle(self.x + 3,self.y - 3,3,5,"line")
    --draft:circle(self.x - 3,self.y + 3,3,5,"line")
    --draft:circle(self.x - 3,self.y - 3,3,5,"line")
    --draft:circle(self.x + 3,self.y,3,5,"line")
    --draft:circle(self.x - 3,self.y,3,5,"line")
    --draft:circle(self.x,self.y,3,5,"line")
    --draft:rectangle(self.x,self.y,self.w * 3,self.h * 2,"line")
    ------
    --draft:rhombus(self.x,self.y,self.w,self.h,"line")
    --draft:square(self.x,self.y,self.w,"line")
    --draft:rectangle(self.x,self.y,self.w,self.h,'line')
    --draft:circle(self.x,self.y,self.w/2,10,'line')
    love.graphics.pop()


end
--- @field area Area
function Player:shot()
    local d = 1.2 * self.w
    self.area:addObject('ShootEffect', self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r), { player = self, d = d })
    if self.attack == "Neutral" then
        self.area:addObject('Projectile', self.x + 1.5 * d * math.cos(self.r),
                self.y + 1.5 * d * math.sin(self.r), { r = self.r })
    elseif self.attack == "Double" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + math.pi/12),
                self.y + 1.5 * d * math.sin(self.r + math.pi/12),
                { r = self.r + math.pi/12,attack = self.attack})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r - math.pi/12),
                self.y + 1.5 * d * math.sin(self.r - math.pi/12),
                { r = self.r - math.pi/12 ,attack = self.attack})
    elseif self.attack == "Triple" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + math.pi/12),
                self.y + 1.5 * d * math.sin(self.r + math.pi/12),
                { r = self.r + math.pi/12,attack = self.attack})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r),
                self.y + 1.5 * d * math.sin(self.r),
                { r = self.r ,attack = self.attack})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r - math.pi/12),
                self.y + 1.5 * d * math.sin(self.r - math.pi/12),
                { r = self.r - math.pi/12 ,attack = self.attack})
    elseif self.attack == "Rapid" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r),
                self.y + 1.5 * d * math.sin(self.r),
                { r = self.r ,attack = self.attack})
    elseif self.attack == "Spread" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        local random_r = table.random({-1,0,0,1})*math.pi/(random(8,10))
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + random_r),
                self.y + 1.5 * d * math.sin(self.r + random_r),
                { r = self.r + random_r,attack = self.attack})
    elseif self.attack == "Back" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        local add_r = math.pi
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r),
                self.y + 1.5 * d * math.sin(self.r),
                { r = self.r,attack = self.attack})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + add_r),
                self.y + 1.5 * d * math.sin(self.r + add_r),
                { r = self.r + add_r,attack = self.attack})
    elseif self.attack == "Side" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        local add_r = math.pi/2
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r),
                self.y + 1.5 * d * math.sin(self.r),
                { r = self.r,attack = self.attack})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + add_r),
                self.y + 1.5 * d * math.sin(self.r + add_r),
                { r = self.r + add_r,attack = self.attack})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r - add_r),
                self.y + 1.5 * d * math.sin(self.r - add_r),
                { r = self.r - add_r,attack = self.attack})
    elseif self.attack == "Blast" then
        self.ammo = self.ammo - attacks[self.attack].ammo
        local p_speed = attacks[self.attack].speed
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + math.pi/8),
                self.y + 1.5 * d * math.sin(self.r + math.pi/8),
                { r = self.r + math.pi/8,attack = self.attack,v = p_speed})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r + math.pi/12),
                self.y + 1.5 * d * math.sin(self.r + math.pi/12),
                { r = self.r + math.pi/12,attack = self.attack,v = p_speed})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r),
                self.y + 1.5 * d * math.sin(self.r),
                { r = self.r ,attack = self.attack,v = p_speed})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r - math.pi/12),
                self.y + 1.5 * d * math.sin(self.r - math.pi/12),
                { r = self.r - math.pi/12 ,attack = self.attack,v = p_speed})
        self.area:addObject('Projectile',
                self.x + 1.5 * d * math.cos(self.r - math.pi/8),
                self.y + 1.5 * d * math.sin(self.r - math.pi/8),
                { r = self.r - math.pi/8 ,attack = self.attack,v = p_speed})
    end

    if self.ammo <= 0 then
        self:setAttack("Neutral")
        self.ammo = self.max_ammo
    end

end

function Player:die()
    for i = 1, love.math.random(8, 12) do
        self.area:addObject('ExplodeParticle', self.x, self.y)
    end
    camera:shake(6, 0.4, 60)
    slow(0.5, 1)
    flash(4)
    self.dead = true
end

function Player:tick()
    self.area:addObject("TickEffect", self.x, self.y, { parent = self })
end

--- @type fun(amount:number)
function Player:addAmmo(amount)
    self.ammo = math.min(self.max_ammo,self.ammo + amount)
end
--- @type fun(amount:number)
function Player:addBoost(amount)
    self.boost = math.min(self.max_boost,self.boost + amount)
end

--- @type fun(amount:number)
function Player:addHp(amount)
    self.hp = math.min(self.max_hp,self.hp + amount)
end

--- @type fun(amount:number)
function Player:addSp(amount)
    self.sp = math.min(self.max_sp,self.sp + amount)
end

--- @type fun(attack:string)
function Player:setAttack(attack)
    self.attack = attack
    self.shoot_cooldown = attacks[attack].cooldown
    self.ammo = self.max_ammo
end

--- @type fun(damage:number)
function Player:hit(damage)
    local damage = damage or 10
    for i=1,math.random(4,8) do
        self.area:addObject("ExplodeParticle",self.x,self.y,{s=3,color = Color.default})
    end
    self:addHp(-damage)
    if damage >= 10 then
        self.timer:after(0.5, function()
            self.invincible = true
            if self.invincible then
                self.timer:every(0.04,function()
                    self.visible = not self.visible
                end)
            end
            self.timer:after(0.4,function ()
                self.visible = true
                self.invincible = false
            end)
        end)
    end

    if damage <= 30 then
        camera:shake(6, 0.4, 60)
        slow(0.75, 0.25)
        flash(2)
    end
    self.invincible = false

    if self.hp <= 0 then
        self:die()
    end
end