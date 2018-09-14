---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by apple.
--- DateTime: 2018/9/14 上午12:09
---
--- @class InfoText : NewGameObject

InfoText = NewGameObject:extend()

function InfoText:new(area,x,y,opts)
    InfoText.super.new(self,area,x,y,opts)
    self.text = opts.text or ""
    self.font = Fonts.unifont
    self.color = opts.color or {1,0,0}
    self.depth = 80
    self.characters = {}
    self.visible = true

    for i = 1,#self.text,3 do
        table.insert(self.characters,self.text:sub(i,i+2))
    end
    self.timer:after(0.7,function ()
        self.timer:every(0.05,function () self.visible = not self.visible end)
        self.timer:after(0.35,function () self.visible = true end)
    end)
    self.timer:after(1.10,function ()
        self:die()
    end)
end
--- TODO complete
function InfoText:update(dt)

end

function InfoText:draw()
    love.graphics.setFont(self.font)
    for i = 1, #self.characters do
        local width = 0
        if i>1 then
            for j = 1,i-1 do
                width = width + self.font:getWidth(self.characters[j])
            end
        end
        love.graphics.setColor(self.color)
        if self.visible then
            love.graphics.print(self.characters[i],self.x + width,self.y,
                    0,1,1,0,self.font:getHeight()/2)
        end

    end
end

function InfoText:die()
    self.dead = true
end