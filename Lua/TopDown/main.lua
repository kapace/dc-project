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
	
	tower = love.graphics.newImage( "ball.png" )
	
	love.physics.setMeter( worldSize )
	world = love.physics.newWorld( 0, 9.81 *  worldSize, true )
	
	objects = {}	
	
	objects.ground = {}
	objects.ground.body = love.physics.newBody( world,cxClient / 2, cyClient )
	objects.ground.shape = love.physics.newRectangleShape( cxClient * 4, 25 )
	objects.ground.fixture = love.physics.newFixture( objects.ground.body,objects.ground.shape )
	
	objects.tower = {}
	objects.tower.body = love.physics.newBody( world, cxClient / 2 , cyClient  / 2 	)
	objects.tower.shape = love.physics.newCircleShape( 25 )
	objects.tower.fixture = love.physics.newFixture( objects.tower.body,objects.tower.shape )
	objects.tower.fixture:setRestitution( 0.4 )
	objects.tower.body:setActive ( false )
		
end

function love.update(dt)

	
	world:update(dt)
	
end

function love.draw()
	x, y = love.mouse.getPosition();
	deltaY = y ;
	deltaX = x ;
	
	angle = math.atan( deltaY, deltaX ) * 180 / math.pi;

	love.graphics.setColor(160, 230, 250)
	love.graphics.rectangle("fill", 0, 0, cxClient, cyClient)
	
	love.graphics.setColor( 40, 0, 0 )
	love.graphics.print(love.timer.getFPS(), 10, 10)
	
	
	love.graphics.translate ( cxClient / 2, cyClient / 2 );
	
	love.graphics.draw(tower,  0, 0,  angle)

	
	--love.graphics.setColor( 40, 255, 40 )
	--love.graphics.polygon( "fill",objects.ground.body:getWorldPoints( objects.ground.shape:getPoints() ) )

	--love.graphics.setColor( 165, 122, 10 )
	
	
end

function love.keypressed(key)	
	if key == "escape" then
		love.event.push( "quit" )
	end
end

function love.mousepressed( x,y,button )

	
end

function love.mousereleased(x, y, button)

end