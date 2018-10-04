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


return function(core, title,tree, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or tree
	opt.font = opt.font or love.graphics.getFont()

	w = w or opt.font:getWidth(text) + 4
	h = h or opt.font:getHeight() + 4
    
    local itemDraws = {}
    local cy = y + offy - (tree.slider and tree.slider.value or 0)
    local function ergodic(target,layer)
        for i, item in ipairs(target) do
            if item.fold then
                if item.children then
                    local b = core:Button("+",{id = tostring(item).."btn",nodraw = true},x+offx+(layer-1)*20, cy ,20,20)
                    table.insert(itemDraws,b.draw)
                    if b.hit then
                        item.fold = false
                        tree.slider = nil
                    end
                else
                    local l = core:Label("--",{id = tostring(item).."btn",nodraw = true},x+offx+(layer-1)*20, cy ,20,20)
                    table.insert(itemDraws,l.draw)
                end
                item.opt = item.opt or {id = tostring(item).."lb",nodraw = true}
                local l = core:Label(item.text,item.opt,x+offx+(layer-1)*20+ 25, cy ,nil,20)
                cy = cy + 25
                item.reply = l
                table.insert(itemDraws,l.draw)
            else
                if item.children then
                    local b =core:Button("-",{id = tostring(item).."btn",nodraw = true},x+offx+(layer-1)*20, cy,20,20)
                    table.insert(itemDraws,b.draw)
                    if b.hit then
                        item.fold = true
                        tree.slider = nil
                    end
                else
                    local l = core:Label("--",{id = tostring(item).."btn",nodraw = true},x+offx+(layer-1)*20, cy ,20,20)
                    table.insert(itemDraws,l.draw)
                end
                item.opt = item.opt or {id = tostring(item).."lb",nodraw = true}
                local l = core:Label(item.text,item.opt,x+2+(layer-1)*20+ 27, cy ,nil,20)
                table.insert(itemDraws,l.draw)
                item.reply = l
                cy = cy + 25
                if item.children then
                    ergodic(item.children,layer+1)
                end
            end
        end
    end
    ergodic(tree,1)
    local f = core:Frame(title,x,y,w,h)
    core:registerDraw(drawFunc,itemDraws,x,y,w,h)
    if cy >= y+h then
		tree.slider = tree.slider or {
			min = 0,
			max =  cy - y - h,
			value = 0,	
		}
		core:Slider(tree.slider,{vertical = true},x+w-15,y+4,15,h-8)
	else
        tree.slider = nil
    end
    --opt.state = core:registerHitbox(opt.id, x,y,w,h)
	--core:registerDraw(opt.draw or core.theme.Button, text, opt, x,y,w,h)
	return {
		id = opt.id,
        tree = tree,
        frame = f,
	}
end
