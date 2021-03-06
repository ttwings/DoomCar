--- @class BigRock : NewGameObject
--- @field area Area
--- @field world World
BigRock = NewGameObject:extend()


function BigRock:new(area,x,y,opts)
    BigRock.super.new(self,area,x,y,opts)
    self.area = current_room.area
    local direction = table.random({-1,1})
    self.x = gw/2 + direction * (gw/2 + 48)
    self.y = random(16,gh - 16)
    --self.y = gh/2
    self.w,self.h = 8,8
    self.hp = 50
    self.hit_flash = false
    self.color = Color.hp
    self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(32))
    self.collider:setPosition(self.x,self.y)
    self.collider:setCollisionClass("Enemy")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    self.v = - direction * random(10,20)
    self.collider:setLinearVelocity(self.v,0)
    self.collider:applyAngularImpulse(random(-100,100))
end

function BigRock:update(dt)
    --Rock.super.update(self,dt)
    self.collider:setLinearVelocity(self.v,0)
end
--- @field draft Draft
function BigRock:draw()
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

function BigRock:update(dt)
    BigRock.super.update(self,dt)
    if self.x < -gw then self:die() end
    if self.y < -gh then self:die() end
    if self.x > 2 * gw then self:die() end
    if self.y > 2 * gh then self:die() end
end

function BigRock:die()
    self.dead = true
    for _ = 1,random(2,4) do
        self.area:addObject("Rock",_,_,{x = self.x,y = self.y})
    end
end

function createIrregularPolygon(size,point_amount)
    local point_amount = point_amount or 8
    local points = {}
    for i = 1, point_amount do
        local angle_interval = 2 * math.pi/point_amount
        local distance = size + random(-size/4,size/4)
        local angle = (i-1)*angle_interval + random(-angle_interval/4,angle_interval/4)
        table.insert(points,distance * math.cos(angle))
        table.insert(points,distance * math.sin(angle))
    end
    return points
end

function BigRock:hit(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self:die()
        current_room.score = current_room.score + 100
    else
        self.hit_flash = true
        self.timer:after(0.2,function ()
            self.hit_flash = false
        end )
    end
end
