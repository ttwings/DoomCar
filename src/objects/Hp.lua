---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/15 下午1:52
---

--- @class Hp : NewGameObject
Hp = NewGameObject:extend()

function Hp:new(area, x, y, opts)
    Hp.super.new(self,area,x,y,opts)
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
    --self.collider:applyAngularImpulse(random(-12,12))
end

function Hp:draw()
    love.graphics.setColor(Color.boost)
    pushRote(self.x,self.y,self.collider:getAngle())
    draft:circle(self.x,self.y,1.5 * self.w,1.5 * self.h, 'line')
    love.graphics.setColor(Color.hp)
    draft:rectangle(self.x,self.y,0.3 * self.w,0.9 * self.h, 'fill')
    draft:rectangle(self.x,self.y,0.9 * self.w,0.3 * self.h, 'fill')
    love.graphics.pop()
    love.graphics.setColor(Color.default)
end

function Hp:die()
    self.dead = true
    self.area:addObject("HpEffect",self.x,self.y,{color = Color.hp})
    self.area:addObject("InfoText",self.x,self.y,{text="+HP",color=Color.hp})
end