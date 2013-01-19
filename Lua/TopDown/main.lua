function love.load()
	--love.mouse.setGrab( true )
	cxClient = love.graphics.getWidth()
	cyClient = love.graphics.getHeight()
	
	worldSize = 64;
	
	currentBullet = 1
	
	bullet = love.graphics.newImage( "ball.png" )
	tower = love.graphics.newImage( "Turretsmall.png" )
	sound = love.audio.newSource( "sound.wav", "static" )
	music = love.audio.newSource( "maid.mp3", "stream" )
	--love.audio.play( music )
	
	love.physics.setMeter( worldSize )
	world = love.physics.newWorld( 0, 0 *  worldSize, true )
	
	world:setCallbacks(begingContact, endContact, preSolve, postSolve)
	
	objects = {}	
	bullets = {}
	
	objects.ground = {}
	objects.ground.body = love.physics.newBody( world,cxClient / 2, cyClient )
	objects.ground.shape = love.physics.newRectangleShape( cxClient * 4, 25 )
	objects.ground.fixture = love.physics.newFixture( objects.ground.body,objects.ground.shape )
	objects.ground.fixture:setRestitution( 0.2 )
	
	objects.right = {}
	objects.right.body = love.physics.newBody( world, cxClient , cyClient/2 )
	objects.right.shape = love.physics.newRectangleShape( 25, cyClient )
	objects.right.fixture = love.physics.newFixture( objects.right.body,objects.right.shape )
	objects.right.fixture:setRestitution( 0.2 )
	
	objects.left = {}
	objects.left.body = love.physics.newBody( world, 0, cyClient/2 )
	objects.left.shape = love.physics.newRectangleShape( 25, cyClient )
	objects.left.fixture = love.physics.newFixture( objects.left.body,objects.left.shape )
	objects.left.fixture:setRestitution( 0.2 )
	
	objects.ceiling = {}
	objects.ceiling.body = love.physics.newBody( world,cxClient / 2, 0 )
	objects.ceiling.shape = love.physics.newRectangleShape( cxClient * 4, 25 )
	objects.ceiling.fixture = love.physics.newFixture( objects.ceiling.body,objects.ceiling.shape )
	objects.ceiling.fixture:setRestitution( 0.2 )
	
	objects.tower = {}
	objects.tower.body = love.physics.newBody( world, cxClient / 2 , cyClient  / 2 	)
	objects.tower.shape = love.physics.newCircleShape( 25 )
	objects.tower.fixture = love.physics.newFixture( objects.tower.body, objects.tower.shape )
	objects.tower.fixture:setRestitution( 0.4 )
	objects.tower.body:setActive ( false )			
end

function begingContact( a, b, coll ) 
	if( coll:getRestitution() < .7 ) then
		a:destroy()
		b:destroy()
	end
	love.audio.play( sound )
	love.audio.rewind( sound )
end

function endContact(a, b, coll)
    
end

function preSolve(a, b, coll)
    
end

function postSolve(a, b, coll)
    
end

function love.update( dt )
	world:update( dt )	
end

function love.draw()
	x, y = love.mouse.getPosition();
	deltaY = y  - objects.tower.body:getY();
	deltaX = x - objects.tower.body:getX();
	
	angle = math.atan2( deltaY, deltaX ) * 180  / math.pi -- Calc the degrees. 
	angle = angle - 90 -- Minus 90 to offset rotation of image. 
	angle = angle * (math.pi / 180) -- Converting to Radians. 
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", 0, 0, cxClient, cyClient)
	
	love.graphics.setColor( 40, 0, 0 )
	love.graphics.print(love.timer.getFPS(), 10, 10)
	love.graphics.print( angle, 40, 40 );
	

	
	love.graphics.setColor(100, 100, 100)
	--love.graphics.line( x, y, objects.tower.body:getX(), objects.tower.body:getY())
	
	
	-- Push the current coordinate System. 
	love.graphics.push()
	
	love.graphics.translate ( cxClient / 2, cyClient / 2 );
	
	love.graphics.setColor(255, 255, 255)
 	love.graphics.rotate( angle )
	love.graphics.draw(tower,  -15, -15)
	-- Pop it back to normal.
	love.graphics.pop()
	
	
	love.graphics.reset( )
	
	for i = 1, #bullets do
		love.graphics.draw(bullet, bullets[i].body:getX(), bullets[i].body:getY() )
	end
	
end

function love.keypressed(key)	
	if key == "escape" then
		love.event.push( "quit" )
	end
end

function love.mousepressed( x,y,button )
	bullets[currentBullet] = {}
	bullets[currentBullet].body = love.physics.newBody( world, objects.tower.body:getX(), objects.tower.body:getY(), "dynamic" )
	bullets[currentBullet].shape = love.physics.newCircleShape( 5 )
	bullets[currentBullet].fixture = love.physics.newFixture( bullets[currentBullet].body, bullets[currentBullet].shape )
	bullets[currentBullet].fixture:setRestitution( .9 )	
	bullets[currentBullet].body:applyForce( deltaX * 50, deltaY * 50 )
	currentBullet = currentBullet + 1
	
	-- Play a sound and rewind it for next time. 
	love.audio.play( sound )
	love.audio.rewind( sound )
	
	
end