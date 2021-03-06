---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/16 上午1:45
---

--- @class Attack : NewGameObject
--- @field area Area
--- @field world World
Attack = NewGameObject:extend()


function Attack:new(area,x,y,opts)
    Attack.super.new(self,area,x,y,opts)
    local direction = table.random({-1,1})
    self.x = gw/2 + direction * (gw/2 + 48)
    self.y = random(48,gh - 48)
    self.w,self.h = 18,18
    self.name = opts.name or "Neutral"
    self.color = attacks[self.name].color or Color.default
    self.abbreviation = attacks[self.name].abbreviation or "No"
    self.collider = self.area.world:newRectangleCollider(self.x,self.y,self.w,self.h)
    self.collider:setCollisionClass("Collectable")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    --self.r = random(0,2 * math.pi)
    self.v = - direction * random(10,20)
    self.collider:setLinearVelocity(self.v,0)
    --self.collider:applyAngularImpulse(random(-24,24))
end

function Attack:update(dt)
    Attack.super.update(self,dt)
    self.collider:setLinearVelocity(self.v,0)
end
--- @field draft Draft
function Attack:draw()
    pushRote(self.x,self.y,self.collider:getAngle())
    love.graphics.setColor(self.color)
    draft:rhombus(self.x,self.y,1.5 * self.w,1.5 * self.h, 'line')
    love.graphics.print(self.abbreviation,self.x,self.y,self.r,1,1,7,7)

    love.graphics.setColor(Color.default)
    draft:rhombus(self.x,self.y,1.2 * self.w,1.2 * self.h, 'line')
    love.graphics.pop()
    love.graphics.setColor(Color.default)
end

function Attack:die()
    self.dead = true
    self.area:addObject("BoostEffect",self.x,self.y,{color = self.color})
    self.area:addObject("InfoText",self.x,self.y,{text=self.name,color = self.color})
end