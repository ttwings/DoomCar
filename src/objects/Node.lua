---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 18-9-18 下午3:32
---

--- @class Node : Object

Node = Object:extend()

--- @param x number
--- @param y number
--- @field w number
--- @field h number
--- @field bought boolean
function Node:new(id,x,y)
    self.id = id
    self.x = x
    self.y = y
    self.w = 10
    self.h = self.w or 10
    self.bought = false
end


function Node:update(dt)
    --local mx,my = camera:getMousePosition(sx * camera.scale,sy * camera.scale,0,0,sx * gw,sy * gh)
    local mx,my = camera:getMousePosition()
    if  mx > self.x - self.w/2 and mx < self.x + self.w/2 and
        my > self.y - self.h/2 and my < self.y + self.h/2 then
        self.hot = true
    else
        self.hot = false
    end
    --- p_print(mx,my)
    --- bought
    if fn.any(bought_node_indexes,self.id) then
        self.bought = true
    else
        self.bought = false
    end

    if self.hot and skill_points.left > 0
            and skill_points.bought < skill_points.max and input:pressed("left_click") then
        if current_room:canNodeBeBought(self.id) then
            table.insert(bought_node_indexes,self.id)
            skill_points.bought = skill_points.bought + 1
            skill_points.left = skill_points.left - 1
        end
    end
end

function Node:draw()
    local r,g,b = unpack(Color.default)
    love.graphics.setColor(Color.background)
    love.graphics.circle('fill',self.x,self.y,self.w)
    if self.bought then
        love.graphics.setColor(r,g,b,255)
    else
        love.graphics.setColor(r,g,b,32)
    end
    love.graphics.circle('line',self.x,self.y,self.w)
    love.graphics.setColor(r,g,b,255)
end