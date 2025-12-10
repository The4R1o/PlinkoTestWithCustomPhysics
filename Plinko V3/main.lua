require("vector2D")
require("vector_math")
require("body")
require("world")

local iterationCount = 32

function love.load( )
	
	-- Creating the pegs layout --
	local startX = -10
	local startY = 40
	local spreadSize = 30

	for i = 1, 18 do
		for j = 1, 10 do
			if i%2==0 then
				newBody = Body:CreateCircle(4, Vector2D.new(startX+(spreadSize * j),startY + (spreadSize * i)), 2, 0.6, true)
				World.AddBody(newBody)	
			else
				newBody = Body:CreateCircle(4, Vector2D.new(startX+(spreadSize * j + (spreadSize/2) ),startY + (spreadSize * i)), 2, 0.6, true)
				World.AddBody(newBody)
			end

		end
	end
end

function love.update(dt)
	----------------------------------------
	--Checking if balls are outside the bounds 
	--of screen and removing them for the list
	----------------------------------------
	for i=1, #World.activeBodyList do
		if  World:GetBody(i) ~= nil then

			local boxCheck = World.activeBodyList[i]:GetAABB() 
			
			if(boxCheck.Min.y >= love.graphics.getHeight()) then
				World.RemoveBody(i)
			end
		end	
	end
	----------------------------------------
	--Physics Step--
	----------------------------------------
	World.Step(dt, iterationCount)


end

function love.draw()
----------------------------------------
-- FPS Display
----------------------------------------
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.print("Current Alive: "..#World.activeBodyList, 10, 30)

----------------------------------------
-- Drawing pegs and balls to the screen
----------------------------------------

	for i=1, #World.activeBodyList do
	   body = World:GetBody(i)
	   if body.isStatic then
		love.graphics.setColor(0, 1, 1)
			love.graphics.circle("fill", body.position.x, body.position.y, body.radius)
		else
			love.graphics.setColor(1, 1, 0)
			love.graphics.circle("fill", body.position.x, body.position.y, body.radius)
	   end
	end
end


function love.mousepressed(x, y, btn, touch)
	if btn == 1 then
		if x > 30 and x < 300 then
			newBody = Body:CreateCircle(10, Vector2D.new(math.random(30,300),0), 0.8, 0.4, false)
			World.AddBody(newBody)		
		end	
	end
end
