---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/8/28 下午8:28
---

---@class Player

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


    self.trail_color = Color.skill_point
    ---- draw ship polygons ----
    self.ship = "Fighter"
    self.polygons = {}
    if self.ship == "Fighter" then
        self.polygons[1] = {
            self.w, 0, -- 1
            self.w / 2, -self.w / 2, -- 2
            -self.w / 2, -self.w / 2, -- 3
            -self.w, 0, -- 4
            -self.w / 2, self.w / 2, -- 5
            self.w / 2, self.w / 2, -- 6
        }
        self.polygons[2] = {
            self.w / 2, -self.w / 2, -- 7
            0, -self.w, -- 8
            -self.w - self.w / 2, -self.w, -- 9
            -3 * self.w / 4, -self.w / 4, -- 10
            -self.w / 2, -self.w / 2, -- 1
        }
        self.polygons[3] = {
            self.w / 2, self.w / 2, -- 12
            -self.w / 2, self.w / 2, -- 13
            -3 * self.w / 4, self.w / 4, -- 14
            -self.w - self.w / 2, self.w, -- 15
            0, self.w, -- 16
        }
    end

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
    self.timer:every(0.24 / self.attack_speed, function()
        self:shot()
    end)
    self.timer:every(5, function()
        self:tick()
    end)
    input:bind('f4', function()
        self:die()
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)
    --- collect able
    if self.collider:enter("Collectable") then
        p_print("1")
        local collision_data = self.collider:getEnterCollisionData("Collectable")
        local object = collision_data.collider:getObject()

        if object:is(Ammo) then
            object:die()
            self:addAmmo(5)
        end

        if object:is(Boost) then
            object:die()
            self:addBoost(5)

        end
    end


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

    self.boost = math.min(self.max_boost,self.boost + 10 * dt)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.max_v = self.base_max_v
    self.boosting = false

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
end

function Player:draw()
    pushRote(self.x, self.y, self.r)
    love.graphics.circle('line', self.x, self.y, self.w / 2)
    love.graphics.rectangle("line", self.x - self.w, self.y - self.h, 2 * self.w, 2 * self.h)
    love.graphics.line(self.x, self.y, self.x + 2 * self.w, self.y)
    love.graphics.pop()


end
--- @field area Area
function Player:shot()
    local d = 1.2 * self.w
    self.area:addObject('ShootEffect', self.x + 1.5 * d * math.cos(self.r),
            self.y + 1.5 * d * math.sin(self.r), { player = self, d = d })
    --self.area:addObject('Projectile',self.x - 4*math.cos(self.r) + d*math.cos(self.r),
    --        self.y + d*math.sin(self.r),{r=self.r})
    self.area:addObject('Projectile', self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r), { r = self.r })
    --self.area:addObject('Projectile',self.x + 4*math.sin(self.r) + d*math.cos(self.r),
    --        self.y + d*math.sin(self.r),{r=self.r})
    if self.ammo > 0 then
        self.ammo = self.ammo - 1
    end
end

function Player:die()
    --self.dead = true
    for i = 1, love.math.random(8, 12) do
        self.area:addObject('ExplodeParticle', self.x, self.y)
    end
    camera:shake(6, 0.4, 60)
    slow(0.5, 1)
    flash(4)
    --camera:flash(1,{1,0,1,1})
    self.area:addObject("InfoText",self.x,self.y,{text="咚！！"})
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