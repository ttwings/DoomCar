Circle = GameObject:extend()

function Circle:draw(  )
	love.graphics.print("circle")
	love.graphics.circle("fill",gw/2,gh/2,100)
end