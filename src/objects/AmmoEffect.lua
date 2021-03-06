---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/16 上午11:40
---
require("objects.NewGameObject")
--- @class AmmoEffect : NewGameObject
AmmoEffect = GameObject:extend()

function AmmoEffect:new(area,x,y,opts)
    AmmoEffect.super.new(self,area,x,y,opts)

    self.color = opts.color or Color.default
    self.r = random(0, 2*math.pi)
    self.s = opts.s or random(2,3)
    self.v = opts.v or random(75,150)
    self.w,self.h = 4,4

    self.collider = self.area.world:newCircleCollider(self.x ,self.y ,self.s)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v*math.cos(self.r),self.v*math.sin(self.r))

    self.line_width = 3
    self.timer:tween(opts.d or random(0.5,0.1), self,{s = 0,v=0,line_width = 0},
            'linear',function () self:die() end )

    self.visible = true
    self.timer:after(0.2,function ()
        self.timer:every(0.05,function () self.visible = not self.visible end,6)
        self.timer:after(0.35,function () self.visible = true end)
    end)
end

function AmmoEffect:update(dt)
    AmmoEffect.super.update(self,dt)
    self.collider:setLinearVelocity(self.v*math.cos(self.r),self.v*math.sin(self.r))
    --
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
end

function AmmoEffect:draw()
    AmmoEffect.super.draw()
    pushRote(self.x,self.y,self.r)
    --love.graphics.rectangle("fill",self.x,self.y,self.s,self.v)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.s ,self.y ,self.x + self.s, self.y)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(1)
    if self.visible then
        draft:rectangle(self.x,self.y,self.w,self.h)
    end
    love.graphics.pop()
end

function AmmoEffect:die()
    self.dead = true
    --self.area:addObject('ProjectileDeathEffect',self.x,self.y,{color = Color.hp,w = 3*self.s})
end