--- @class StageMain
--- @field world World
--- @field area Area

StageMain = Object:extend()

function StageMain:new()
    self.font = font
    self.main_canvas = love.graphics.newCanvas(gw,gh)
end

function StageMain:update(dt)
    input:bind("space",function ()
        gotoRoom("Stage","Stage")
    end)

    Suit.layout:reset(gw*sw/2 - 50,gh*sh/2)
    if Suit.Button("积分模式",Suit.layout:row(100,40)).hit then
        gotoRoom("Stage","Stage")
    end
    if Suit.Button("世界地图",Suit.layout:row(100,40)).hit then
        gotoRoom("StageMap","StageMap")
    end
    if Suit.Button("科技升级",Suit.layout:row(100,40)).hit then
        gotoRoom("SkillTree","SkillTree")
    end
    if Suit.Button("支持作者",Suit.layout:row(100,40)).hit then
        gotoRoom("SkillTree","SkillTree")
    end
end

function StageMain:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0,0,sw*gw,sh*gh)
    camera:detach()
    love.graphics.print("毁灭战车",gw/2,gh/2 - 50,0,3,3,math.floor(self.font:getWidth("打飞机")/2))
    local t1 = "按空格开始 或 点击开始"
    love.graphics.print(t1,gw/2,gh/2 + 40,0,1,1,math.floor(self.font:getWidth(t1)/2))
    local t2 = "左右箭头控制方向\n上下箭头控制速度"
    love.graphics.print(t2,gw/2,gh/2 + 60,0,1,1,math.floor(self.font:getWidth(t2)/2))
    love.graphics.setFont(font,32)

    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255,255)
    love.graphics.setBlendMode('alpha','premultiplied')
    love.graphics.draw(self.main_canvas,0,0,0,sw,sh)
    love.graphics.setBlendMode('alpha')
    Suit.draw()

end

function StageMain:destroy()

end

function StageMain:finished()

end

return StageMain