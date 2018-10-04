-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

local offx = 5
local offy = 5

local drawFunc = function(itemsDraws,x,y,w,h)
	love.graphics.setScissor(x,y,w,h)
	for i,v in ipairs(itemsDraws) do
		v()
	end
	love.graphics.setScissor()
end


return function(core, title,tab, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or tab
	opt.font = opt.font or love.graphics.getFont()

	w = w or opt.font:getWidth() + 4
	h = h or opt.font:getHeight() + 4
    
    local itemDraws = {}
    local cy = y + offy - (tab.slider and tab.slider.value or 0)
    
    for _,item in ipairs(tab) do
        local l = core:Label(item.name,{id = tostring(item).."lab",nodraw = true},
            x+offx, cy ,w/3,30)
        item.input = item.input or {text = tostring(item.value)}
        table.insert(itemDraws,l.draw)
        local i = core:Input(item.input,{nodraw = true},x+offx+w/3,cy,w - offx*2 - w/3-15,30) 
        table.insert(itemDraws,i.draw)
        cy = cy + 40
    end
    
    
    local f = core:Frame(title,x,y,w,h)
    core:registerDraw(drawFunc,itemDraws,x,y,w,h)
    if cy >= y+h then
		tab.slider = tab.slider or {
			min = 0,
			max =  cy - y - h,
			value = 0,	
		}

		core:Slider(tab.slider,{vertical = true},x+w-15,y+4,15,h-8)
	else
        tab.slider = nil
    end
    --opt.state = core:registerHitbox(opt.id, x,y,w,h)
	--core:registerDraw(opt.draw or core.theme.Button, text, opt, x,y,w,h)
	return {
		id = opt.id,
        tab = tab,
        frame = f
	}
end
