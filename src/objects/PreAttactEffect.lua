---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/20 下午11:15
---

--- @class PreAttackEffect : NewGameObject

PreAttackEffect = NewGameObject:extend()

function PreAttackEffect:new(area,x,y,opts)
    PreAttackEffect.super.new(self,area,x,y,opts)
    self.duration = opts.duration or 1
    self.timer:every(0.02,function ()
        self.area:addObject("TargetParticle",
                self.x + random(-20,20),self.y + random(-20,20),
                {target_x = self.x,target_y = self.y,color = self.color})
    end)
    self.timer:after(self.duration - self.duration/4,function () self.dead = true end)
end

function PreAttackEffect:update(dt)
    PreAttackEffect.super.update(self,dt)
    if self.shooter and not self.shooter.dead then
        self.x = self.shooter.x + 1.4 * self.shooter.w * math.cos(self.shooter.collider:getAngle())
        self.y = self.shooter.y + 1.4 * self.shooter.w * math.sin(self.shooter.collider:getAngle())
    end
end

