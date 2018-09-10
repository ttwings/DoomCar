---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/11 上午12:31
---
require("objects.NewGameObject")
---@class Ammo

Ammo = NewGameObject:extend()

function Ammo:new(area,x,y,opts)
    Ammo.super.new(self,area,x,y,opts)
    --self.x = x
    --self.y = y
    self.w = 8
    self.h = 8
    self.collider = self.area.world:newRectangleCollider(self.x,self.y,self.w,self.h)
    self.collider:setCollisionClass("Ammo")
    --TODO setCollisionClass  learn setFixedRotation
    self.collider:setFixedRotation(false)
    self.r = random(0,2 * math.pi)
    self.v = random(10,20)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
    self.collider:applyAngularImpulse(random(-24,24))
end

function Ammo:draw()
    love.graphics.setColor(Color.ammo)
    pushRote(self.x,self.y,self.collider:getAngle())
    love.graphics.rectangle('line',self.x-self.w/2,self.y-self.h/2,self.w,self.h)
    love.graphics.pop()
end