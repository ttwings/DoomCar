
--- @class Joystick

Joystick = Object:extend()
--- @field working boolean
--- @field stickSize int
--- @field sw number
--- @field sh number
--- @field changeRange number
--- @field relative boolean
--- @field resetPosition func


function Joystick:new()
	self.working=false
	self.stickSize=30
	self.sw,self.sh = love.graphics.getDimensions()
	self.changeRange = 0.25
	self.relative = false
	self.depth = 0
	self:resetPosition()
end

function Joystick:resetPosition()
	--self.size=setting.ctrlSize/gw
	--self.cx = setting.ctrlX
	--self.cy = setting.ctrlY

	self.size = 20
	self.cx = 40
	self.cy = gh - 40
end

function Joystick:inBound()
	return love.mouse.getX()< love.graphics.getWidth()/2
end

local function getDist(x,y,z,w)
	return math.sqrt((x-z)*(x-z) + (y-w)*(y-w))
end

function Joystick:limitToRound()
	local dist=getDist(self.cx,self.cy,self.sx,self.sy)
	if  dist>self.size then
		local dx = (self.sx-self.cx)* self.size/dist
		local dy = (self.sy-self.cy)* self.size/dist
		self.sx= self.cx+(self.sx-self.cx)* self.size/dist
		self.sy= self.cy+(self.sy-self.cy)* self.size/dist
		--self.cx=self.cx+(self.sx-self.cx)* self.size/dist/10
		--self.cy=self.cy+(self.sy-self.cy)* self.size/dist/10
	end
end

function Joystick:getValue()
	if self.left then 
		self.vx= (self.sx-self.cx)/self.size
		self.vy= (self.sy-self.cy)/self.size
	else
		self.vx= 0
		self.vy= 0
	end

end

function Joystick:testTouch()
	local touches = love.touch.getTouches()
	self.left = false
	self.right = false
	self.mx,self.my = 0,0
	--touches[1] = love.mouse.isDown(1)
    for i, id in ipairs(touches) do
        local x,y = love.touch.getPosition(id)
        --local x,y = love.mouse.getPosition()
        if x< self.sw/2 then
        	self.left = true
        	self.mx,self.my = x,y
        else
        	self.right = true
        	self.rx,self.ry = x,y
        end
    end
end


function Joystick:update()
	p_print("joystick update")
	self:testTouch()
	if self.relative then
		if self.working then
			if self.left then
				self.sx,self.sy = self.mx,self.my
				self.limitToRound()
			else
				self.cx=nil
				self.working=false
				return 
			end
		else
			self.working = self.left
			if self.working then	
				self.cx,self.cy = self.mx,self.my
				self.sx,self.sy = self.cx, self.cy
			end
			
		end
	else
		if self.left then
			self.sx,self.sy = self.mx,self.my
			self:limitToRound()
		end
	end
	self:getValue()
end


function Joystick:control(tank,dt)
	
	if self.vx > self.changeRange then
		if self.vy< - self.changeRange then -- right up
			if self.lastDown == "up" then
				self.currentDown = "right"
			elseif self.lastDown == "right" then
				self.currentDown = "up"
			end
		elseif self.vy > self.changeRange then --right down
				if self.lastDown == "down" then
					self.currentDown = "right"
				elseif self.lastDown == "right" then
					self.currentDown = "down"
				end
		else --right
			self.lastDown = "right"
			self.currentDown = "right"
		end
	elseif self.vx< - self.changeRange then
		if self.vy< - self.changeRange then -- left up
			if self.lastDown == "up" then
				self.currentDown = "left"
			elseif self.lastDown == "left" then
				self.currentDown = "up"
			end
		elseif self.vy > self.changeRange then --left down
				if self.lastDown == "left" then
					self.currentDown = "left"
				elseif self.lastDown == "left" then
					self.currentDown = "down"
				end
		else --left
			self.lastDown = "left"
			self.currentDown = "left"
		end
	elseif self.vy>self.changeRange then
		self.lastDown = "down"
		self.currentDown = "down"
	elseif self.vy<-self.changeRange then
		self.lastDown = "up"
		self.currentDown = "up"
	else
		self.currentDown = "none"
	end

	if self.currentDown == "up" then
		if tank.rot == 0 then
			tank.dx = 0
        	tank.dy = - tank.speed*dt
		else
			tank.rot = 0
		end
	elseif self.currentDown == "down" then
		if tank.rot == 2 then
			tank.dx = 0
        	tank.dy = tank.speed*dt
		else
			tank.rot = 2
		end 
	elseif self.currentDown == "left" then
		if tank.rot  == 3 then
			tank.dy = 0
        	tank.dx = - tank.speed*dt
		else
			tank.rot = 3
		end   
	elseif self.currentDown == "right" then
		if tank.rot == 1 then
			tank.dy = 0
        	tank.dx = tank.speed*dt
		else
			tank.rot = 1
		end      
	end

    if self.right then
    	tank:fire()
    end
end


function Joystick:draw()
	
	love.graphics.setColor(1, 1, 1, 0.7)
	love.graphics.circle("line", self.cx, self.cy, self.size)
	if self.left then
		love.graphics.setColor(1, 1,1, 0.5)
		love.graphics.circle("fill", self.sx, self.sy, self.stickSize)
	end

	if self.right then
		love.graphics.setColor(1, 1,1, 0.5)
		love.graphics.circle("fill", self.rx, self.ry, self.stickSize)
	end
	self:getValue()
	love.graphics.print(string.format("axis x: %0.2f; axis y: %0.2f",self.vx,self.vy),100,100)
end

return Joystick