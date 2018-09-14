---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/14 下午10:48
---

--- @class Boost : NewGameObject
--- @field area Area
--- @field world World
Boost = NewGameObject:extend()


function Boost:new(area,x,y,opts)
    Boost.super.new(self,area,x,y,opts)
    local direction = table.random({-1,1})
    self.x = gw/2 + direction * (gw/2 + 48)
    self.y = random(48,gh - 48)
    self.w,self.h = 12,12
    self.collider = self.area.world:newRectangleCollider(self.x,self.y,self.w,self.h)
    self.collider:setCollisionClass("Collectable")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    --self.r = random(0,2 * math.pi)
    self.v = - direction * random(10,20)
    self.collider:setLinearVelocity(self.v,0)
    self.collider:applyAngularImpulse(random(-24,24))
end

function Boost:update(dt)
    Boost.super.update(self,dt)
    self.collider:setLinearVelocity(self.v,0)
end
--- @field draft Draft
function Boost:draw()
    love.graphics.setColor(Color.boost)
    pushRote(self.x,self.y,self.collider:getAngle())
    draft:rhombus(self.x,self.y,1.5 * self.w,1.5 * self.h, 'line')
    draft:rhombus(self.x,self.y,0.5 * self.w,0.5 * self.h, 'fill')
    love.graphics.pop()
    love.graphics.setColor(Color.default)
end

function Boost:die()
    self.dead = true
    --self.area:addObject("AmmoEffect",self.x,self.y,{color = Color.ammo,w = self.w,h = self.h})
    --for i=1,math.random(4,8) do
        self.area:addObject("BoostEffect",self.x,self.y,{color = Color.boost})
    --end
    self.area:addObject("InfoText",self.x,self.y,{text="+BOOST"})
end