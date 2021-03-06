---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/16 下午11:18
---

--- @class Shooter : NewGameObject
--- @field area Area
--- @field world World
Shooter = NewGameObject:extend()

--- @param area Area
--- @param x number
--- @param y number
--- @param opts table
function Shooter:new(area,x,y,opts)
    Shooter.super.new(self,area,x,y,opts)
    local direction = table.random({-1,1})
    self.x = gw/2 + direction * (gw/2 + 48)
    self.y = random(16,gh - 16)
    --self.y = gh/2
    self.w,self.h = 8,8
    self.hp = 30
    self.hit_flash = false
    self.color = Color.hp
    self.collider = self.area.world:newPolygonCollider({self.w, 0, -self.w/2, self.h, -self.w, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x,self.y)
    self.collider:setCollisionClass("Enemy")
    self.collider:setObject(self)

    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)

    self.v = - direction * 10
    self.collider:setLinearVelocity(self.v,0)
    ---- add perAttack
    self.timer:every(random(3,5),function ()
        self.area:addObject("PreAttackEffect",
                self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
                self.y + 1.4*self.w*math.sin(self.collider:getAngle()),
                {shooter = self,color = Color.hp,duration = 1})
        self.timer:after(1,function ()
            self.area:addObject("EnemyProjectile",
                    self.x + 1.4 * self.w * math.cos(self.collider:getAngle()),
                    self.y + 1.4 * self.w * math.sin(self.collider:getAngle()),
                    {r=math.atan2(current_room.player.y - self.y,current_room.player.x - self.x),
                    v = random(80,100), s = 3.5}
            )
        end)
    end)
end

function Shooter:update(dt)
    Rock.super.update(self,dt)
    self.collider:setLinearVelocity(self.v,0)
end
--- @field draft Draft
function Shooter:draw()
    pushRote(self.x,self.y,self.collider:getAngle())
    love.graphics.setColor(self.color)
    if self.hit_flash then
        love.graphics.setColor(Color.default)
    end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line',points)
    love.graphics.pop()
    love.graphics.setColor(Color.default)
end

function Shooter:update(dt)
    Shooter.super.update(self,dt)
    if self.x < -gw then self:die() end
    if self.y < -gh then self:die() end
    if self.x > 2 * gw then self:die() end
    if self.y > 2 * gh then self:die() end
end

function Shooter:die()
    self.dead = true
    self.area:addObject("EnemyDeathEffect",self.x,self.y,{w=16,h=16,color = self.color})
end



function Shooter:hit(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self:die()
        current_room.score = current_room.score + 150
    else
        self.hit_flash = true
        self.timer:after(0.2,function ()
            self.hit_flash = false
        end )
    end
end
