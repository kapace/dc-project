function love.load()
	--love.mouse.setGrab( true )
	cxClient = love.graphics.getWidth()
	cyClient = love.graphics.getHeight()
	-- Building Mode -- 
	building = false
	currentObject = 0
	worldSize = 64;
	ballGrabbed = false
	powerX = 0
	powerY = 0
	startX = 0
	startY = 0	
	
	ball = love.graphics.newImage( "ball.png" )
	
	love.physics.setMeter( worldSize )
	world = love.physics.newWorld( 0, 9.81 *  worldSize, true )
	
	objects = {}
	level = {}
	currentB = 1
	
	buildingTools = {}
	
	buildingTools[0] = {}
	buildingTools[0].body = love.physics.newBody( world,200, 200 )
	buildingTools[0].shape = love.physics.newRectangleShape( 40, 200 )
	
	buildingTools[1] = {}
	buildingTools[1].body = love.physics.newBody( world,200, 200 )
	buildingTools[1].shape = love.physics.newRectangleShape( 200, 40 )
	
	buildingTools[2] = {}
	buildingTools[2].body = love.physics.newBody( world,200, 200 )
	buildingTools[2].shape = love.physics.newRectangleShape( 50, 50 )
	
	buildingTools[3] = {}
	buildingTools[3].body = love.physics.newBody( world,200, 200 )
	buildingTools[3].shape = love.physics.newRectangleShape( 200, 10 )
	
	
	
	
	objects.ground = {}
	objects.ground.body = love.physics.newBody( world,cxClient / 2, cyClient )
	objects.ground.shape = love.physics.newRectangleShape( cxClient * 4, 25 )
	objects.ground.fixture = love.physics.newFixture( objects.ground.body,objects.ground.shape )
	
	objects.start = {}
	objects.start.body = love.physics.newBody( world, cxClient - (cxClient * 0.85), cyClient - 100 )
	objects.start.shape = love.physics.newRectangleShape( 10, 200 )	
	
	objects.ball = {}
	objects.ball.body = love.physics.newBody( world, cxClient - (cxClient * 0.85) , cyClient - 200, "dynamic")
	objects.ball.shape = love.physics.newCircleShape( 25 )
	objects.ball.fixture = love.physics.newFixture( objects.ball.body,objects.ball.shape )
	objects.ball.fixture:setRestitution( 0.4 )
	objects.ball.body:setActive ( false )
		
end

function love.update(dt)
	x, y = love.mouse.getPosition()
	xoffset = objects.ball.body:getX()
	
	
	for i = 1, #level do
		--level[i].body:setX( level[i].body:getX() - - objects.ball.body:getX() )
	end
	
	if building then
		buildingTools[currentObject].body:setX(x)
		buildingTools[currentObject].body:setY(y)
	end
	if ballGrabbed then
		objects.ball.body:setX(x)
		objects.ball.body:setY(y)
		objects.ball.body:setActive ( true )
	end
	--if not building then
		world:update(dt)
	--end
end

function love.draw()
	love.graphics.setColor(160, 230, 250)
	love.graphics.rectangle("fill", 0, 0, cxClient, cyClient)
	
	offset = objects.ball.body:getX() - 200
	
	--love.graphics.setColor( 40, 0, 0 )
	love.graphics.print(love.timer.getFPS(), 10, 10)
	--love.graphics.draw(ball,  objects.ball.body:getX() - objects.ball.shape:getRadius(), objects.ball.body:getY() - objects.ball.shape:getRadius(),  objects.ball.shape:getRadius())
	love.graphics.setColor(70, 70, 70)
	love.graphics.circle("fill", objects.ball.body:getX() , objects.ball.body:getY(), objects.ball.shape:getRadius())
	
	love.graphics.setColor( 140, 140, 140 )
	love.graphics.polygon( "fill",objects.start.body:getWorldPoints( objects.start.shape:getPoints() )  )
	--love.graphics.rectangle( "fill", objects.start.body:getX() - offset, objects.start.body:getY(), objects.start.body:getWidth(), objects.start.body:getHeight())
	
	love.graphics.setColor( 40, 255, 40 )
	love.graphics.polygon( "fill",objects.ground.body:getWorldPoints( objects.ground.shape:getPoints() ) )

	love.graphics.setColor( 165, 122, 10 )
	for i = 1, #level do
		love.graphics.polygon( "fill",level[i].body:getWorldPoints( level[i].shape:getPoints() ) )
	end
	
	if building then
		love.graphics.setColor( 255, 0, 0 )
		love.graphics.polygon( "fill",buildingTools[currentObject].body:getWorldPoints( buildingTools[currentObject].shape:getPoints() ) )
	end
	
end

function love.keypressed(key)	
	if key == "escape" then
		love.event.push( "quit" )
	end
	if key == " " then

		objects.ball = {}
		objects.ball.body = love.physics.newBody( world, cxClient - (cxClient * 0.85) , cyClient - 200, "dynamic")
		objects.ball.shape = love.physics.newCircleShape( 25 )
		objects.ball.fixture = love.physics.newFixture( objects.ball.body,objects.ball.shape )
		objects.ball.fixture:setRestitution( 0.4 )
		objects.ball.body:setActive ( false )
	end
	if key == "q" then
		building = not building
	end
	if key == "w" then
		currentObject = (currentObject + 1) % (#buildingTools + 1)
	end
end

function love.mousepressed( x,y,button )
	if button == "r" then
		level[currentB] = {}
		level[currentB].body = love.physics.newBody( world, x, y, "dynamic" )
		level[currentB].shape = buildingTools[currentObject].shape
		level[currentB].fixture = love.physics.newFixture( level[currentB].body, level[currentB].shape )
		level[currentB].fixture:setRestitution( 0.1 )
		--level[currentB].body:setMass( level[currentB].body:getMass() * 7)
		currentB = currentB + 1
	end

	ballx = objects.ball.body:getX()
	bally = objects.ball.body:getY()
	radius = objects.ball.shape:getRadius()
	
	distanceX = math.abs( ballx - x )
	distanceY = math.abs( bally - y )
	
	if distanceX < radius and  distanceY < radius then
		ballGrabbed = true
		startX = x
		startY = y
	end
	
end

function love.mousereleased(x, y, button)
	if ballGrabbed then
		ballGrabbed = false
		powerX = startX- x
		powerY = y- startY
		
		objects.ball.body:applyLinearImpulse(powerX * 8, -powerY * 8)
		powerX, powerY = 0
	end
end