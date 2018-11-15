--- @class StageEnd
--- @field world World
--- @field area Area

StageEnd = Object:extend()

function StageEnd:new()
    self.area = Area(self)
    self.font = font
    self.main_canvas = love.graphics.newCanvas(gw,gh)
end

function StageEnd:update(dt)
    if self.area then self.area:update(dt) end
    input:bind("space",function ()
        gotoRoom("Stage","Stage")
        saveData()
    end)
end

function StageEnd:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0,0,sw*gw,sh*gh)
    if self.area then self.area:draw() end
    camera:detach()
    love.graphics.print("你挂了~~",gw/2,gh/2 - 50,0,3,3,math.floor(self.font:getWidth("打飞机")/2))
    local t0 = "得分："..score[#score]
    love.graphics.print(t0,gw/2,gh/2 - 100,0,1,1,math.floor(self.font:getWidth(t0)/2))
    local t1 = "按“空格”重新开始"
    love.graphics.print(t1,gw/2,gh/2 + 40,0,1,1,math.floor(self.font:getWidth(t1)/2))
    local t2 = "左右箭头控制方向\n上下箭头控制速度"
    love.graphics.print(t2,gw/2,gh/2 + 60,0,1,1,math.floor(self.font:getWidth(t2)/2))
    love.graphics.setFont(font,32)
    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255,255)
    love.graphics.setBlendMode('alpha','premultiplied')
    love.graphics.draw(self.main_canvas,0,0,0,3,3)
    love.graphics.setBlendMode('alpha')
end

function StageEnd:destroy()
    --if self.area then
    --    self.area:destroy()
    --    --self.area = nil
    --end
end

function StageEnd:finished()

end

return StageEnd