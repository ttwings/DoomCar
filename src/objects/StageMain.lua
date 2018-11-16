--- @class StageMain
--- @field world World
--- @field area Area

StageMain = Object:extend()

function StageMain:new()
    self.font = font
    self.main_canvas = love.graphics.newCanvas(gw,gh)
    style = {
        font = Fonts.unifont,
        showBorder = false,
    }
    gooi.setStyle(style)
    gooi.newButton({group = "main",text = "积分模式", x = gw*sw/2,y = gh*sh/2}):onRelease(
            function()
                gotoRoom("Stage","Stage")
                gooi.setGroupEnabled("main",false)
                gooi.setGroupVisible("main",false)
            end
    )

end

function StageMain:update(dt)
    input:bind("space",function ()
        gotoRoom("Stage","Stage")

    end)

    --gooi.update(dt)
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
    gooi.draw('main')
end

function StageMain:destroy()

end

function StageMain:finished()

end

return StageMain