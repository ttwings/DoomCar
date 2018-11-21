--- @class StageMain
--- @field world World
--- @field area Area

StageMain = Object:extend()

function StageMain:new()
    self.font = font
    self.main_canvas = love.graphics.newCanvas(gw,gh)
    style = {
        font = font,
        showBorder = false,
        bg = {1,1,1,1}
    }
    gooi.setStyle(style)
    gooi.newButton({group = "StageMain",text = "科技升级", x = 0,y = gh*sh/2 - 80,w=gw*sw,h=40})
        :center()
        :bg({1,1,1,0.1})
        :onRelease(
            function()
                gotoRoom("SkillTree","SkillTree")
                gooi.setGroupEnabled("StageMain",false)
                gooi.setGroupVisible("StageMain",false)
                gooi.setGroupEnabled("SkillTree",true)
                gooi.setGroupVisible("SkillTree",true)
            end
    )
    gooi.newButton({group = "StageMain",text = "冒险模式", x = 0,y = gh*sh/2 - 40,w=gw*sw,h=40})
        :center()
        :bg({1,1,1,0.1})
        :onRelease(
            function()
                gotoRoom("StageMap","StageMap")
                gooi.setGroupEnabled("StageMain",false)
                gooi.setGroupVisible("StageMain",false)
                gooi.setGroupEnabled("StageMap",true)
                gooi.setGroupVisible("StageMap",true)
            end
    )
    gooi.newButton({group = "StageMain",text = "积分模式", x = 0,y = gh*sh/2,w=gw*sw,h=40})
            :center()
            :bg({1,1,1,0.1})
            :onRelease(
            function()
                gotoRoom("Stage","Stage")
                gooi.setGroupEnabled("StageMain",false)
                gooi.setGroupVisible("StageMain",false)
                gooi.setGroupEnabled("Stage",true)
                gooi.setGroupVisible("Stage",true)
            end
    )

    gooi.newButton({group = "StageMain",text = "查看帮助", x = 0,y = gh*sh/2 + 40,w=gw*sw,h=40})
        :center()
        :bg({1,1,1,0.1})
        :onRelease(
            function()
                gotoRoom("StageEnd","StageEnd")
                gooi.setGroupEnabled("StageMain",false)
                gooi.setGroupVisible("StageMain",false)
                gooi.setGroupEnabled("StageEnd",true)
                gooi.setGroupVisible("StageEnd",true)
            end
    )
    gooi.newButton({group = "StageMain",text = "语言选择", x = 0,y = gh*sh/2 + 80,w=gw*sw,h=40})
        :center()
        :bg({1,1,1,0.1})
        :onRelease(
            function()
                gotoRoom("StageSelect","StageSelect")
                gooi.setGroupEnabled("StageMain",false)
                gooi.setGroupVisible("StageMain",false)
                gooi.setGroupEnabled("StageSelect",true)
                gooi.setGroupVisible("StageSelect",true)
            end
    )
    gooi.newButton({group = "StageMain",text = "关于游戏", x = 0,y = gh*sh/2 + 120,w=gw*sw,h=40})
        :center()
        :bg({1,1,1,0.1})
        :onRelease(
            function()
                gotoRoom("StageAbout","StageAbout")
                gooi.setGroupEnabled("StageMain",false)
                gooi.setGroupVisible("StageMain",false)
                gooi.setGroupEnabled("StageAbout",true)
                gooi.setGroupVisible("StageAbout",true)
            end
    )
    gooi.newButton({group = "StageMain",text = "退出游戏", x = 0,y = gh*sh/2 + 160,w=gw*sw,h=40})
        :center()
        :bg({1,1,1,0.1})
        :onRelease(
            function()
                love.event.quit()
            end
    )

end

function StageMain:update(dt)

end

function StageMain:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0,0,sw*gw,sh*gh)
    camera:detach()
    love.graphics.print(title,gw/2,gh/2 - 80,0,sw,sh,math.floor(self.font:getWidth(title)/2))

    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255,255)
    love.graphics.setBlendMode('alpha','premultiplied')
    love.graphics.draw(self.main_canvas,0,0,0,sw,sh)
    love.graphics.setBlendMode('alpha')
    gooi.draw('StageMain')
end

function StageMain:destroy()

end

function StageMain:finished()

end

return StageMain