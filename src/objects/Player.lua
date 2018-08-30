---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/8/28 下午8:28
---

Player = NewGameObject:extend()
---@class Player

function Player:new(area,x,y,opts)
    Player.super.new(self, area, x, y, opts)
    self.x ,self.y = x,y
    self.w,self.h = 12,12
    self.r = -math.pi/2
    self.rv = 1.66*math.pi
    self.v = 0
    self.max_v = 100
    self.a = 100
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.w)
    --self.area.world:addCollisionClass("Player")
    --self.collider:setCollisionClass("Player")
    self.collider:setObject(self)
    self.attack_speed = 1
    self.timer:every(0.24/self.attack_speed,function () self:shot() end)
end

function Player:update(dt)
    Player.super.update(self,dt)
    if input:down("left") then self.r = self.r - self.rv*dt end
    if input:down("right") then self.r = self.r + self.rv*dt end
    self.v = math.min(self.v + self.a * dt,self.max_v)
    --- 在windfield源码的备注中找到。。。。貌似用的 love2d physics的方法。
    self.collider:setLinearVelocity(self.v*math.cos(self.r),self.v*math.sin(self.r))
end

function Player:draw()
    love.graphics.circle('line',self.x,self.y,self.w)
    love.graphics.line(self.x,self.y,self.x + 2*self.w*math.cos(self.r),
            self.y + 2*self.w*math.sin(self.r))
end

function Player:shot()
    local d = 1.2*self.w
    self.area:addObject('ShootEffect',self.x + 1.5*d*math.cos(self.r),
            self.y + 1.5*d*math.sin(self.r),{player=self,d = d})
    self.area:addObject('Projectile',self.x - 4*math.cos(self.r) + d*math.cos(self.r),
            self.y + d*math.sin(self.r),{r=self.r})
    self.area:addObject('Projectile',self.x + d*math.cos(self.r),
            self.y + d*math.sin(self.r),{r=self.r})
    self.area:addObject('Projectile',self.x + 4*math.sin(self.r) + d*math.cos(self.r),
            self.y + d*math.sin(self.r),{r=self.r})
end