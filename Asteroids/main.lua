


function checkcollision(x1, y1, w1, h1, x2, y2, w2, h2)

	return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1

end

--function collision2(x1a, y1a, x2a, y2a, x3a, y3a, x4a, y4a, x1b, y1b, x2b, y2b, x3b, y3b, x4b, y4b)


--end







function love.load()



	Ship = {img = nil, x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2, O = 0, vel = {x = 0, y = 0}, pvel = {x = 0, y = 1}}
	Ship.img = love.graphics.newImage('triangle.png')

	lifeShips = {img = Ship.img, x = 2, y = 20, size = .5}


	Asteroid = {img = nil, x = nil, y = nil, vel = {x = nil, y = nil}, Size = nil}
	Asteroid.img = love.graphics.newImage('Asteroid.png')
	Bullet = {img = nil, x = nil, y = nil, vel = {x = nil, y = nil}, timer = nil}
	Bullet.img = love.graphics.newImage('Bullet.png')
	Asteroids = {}
	UFO = {cimg = nil, x = 0, y = 0, vel = {x = nil, y = nil}, canShoot = 100, size = 2, rotate = 10, leave = 3}
	UFOimg = {img = nil, img2 = nil, img3 = nil}
	UFOimg.img = love.graphics.newImage('UFO.png')
	UFOimg.img2 = love.graphics.newImage('UFO2.png')
	UFOimg.img3 = love.graphics.newImage('UFO3.png')
	UFO.cimg = UFOimg.img
	UFOs = {}
	reset = false
	


	astC = 0

	lives = 3

	col = {ship = false, bullet = false}

	Bullets = {}
	Level = {add = 0, need = 0, started = false}

	rxy = {x = 0, y = math.pi}

	star = {img = nil, x = 0, y = 0}
	star.img = Bullet.img
	starc = 0
	stars = {}

	OO = {x = Ship.x - (Ship.img:getWidth()/2) , y = Ship.y - (Ship.img:getHeight()/2 * 3)}

	test = false

	timers = {death = {enabled = false, time = 0}, blink = {enabled = false, time = 0}, clear = {enabled = false, time = 0}, UFO = 0}
	dead = false
	immune = {blink = false, visible = 1, timer = 1}
	something = 0
	onScreen = 0
	score = 0
	gameOver = false

	extraLife = 10000

	gameSpeed = 2

	

end


--function collision2(x1, y1, w1, h1, x2, y2, w2, h2)
	--return x2 < x1 + w1



--end



function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


function love.update(dt)
	if Ship.x < 0 then
		Ship.x = love.graphics.getWidth()
	end
	if Ship.x > love.graphics.getWidth() then
		Ship.x = 0
	end
	if Ship.y < 0 then
		Ship.y = love.graphics.getHeight()
	end
	if Ship.y > love.graphics.getHeight() then
		Ship.y = 0
	end

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		Ship.O = Ship.O - math.rad(3 * gameSpeed)
	end

	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		Ship.O = Ship.O + math.rad(3 * gameSpeed)

		Ship.O = math.rad(round(math.deg(Ship.O)))

	end

	--Ship.x = Ship.x + Ship.vel.x
	--Ship.y = ship.y + Ship.vel.y

	if Ship.O > math.rad(360) then
		Ship.O = Ship.O - math.rad(360)
	end
	if Ship.O <= math.rad(0) then
		Ship.O = Ship.O + math.rad(360)
	end

	Ship.pvel.x = math.sin(Ship.O)
	Ship.pvel.y = -math.cos(Ship.O)


	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then

		

		if Ship.pvel.x > 0 then
		Ship.vel.x = Ship.vel.x + (Ship.pvel.x * .1/ (math.abs(Ship.pvel.x) + math.abs(Ship.pvel.y)))
		end
		
		if Ship.pvel.y > 0 then

		Ship.vel.y = Ship.vel.y + (Ship.pvel.y * .1/ (math.abs(Ship.pvel.x) + math.abs(Ship.pvel.y)))
		end


		if Ship.pvel.x < 0 then
		Ship.vel.x = Ship.vel.x - (Ship.pvel.x * .1/ -(math.abs(Ship.pvel.x) + math.abs(Ship.pvel.y)))
		end
		
		if Ship.pvel.y < 0 then

		Ship.vel.y = Ship.vel.y - (Ship.pvel.y * .1/ -(math.abs(Ship.pvel.x) + math.abs(Ship.pvel.y)))

		end

	if math.abs(Ship.vel.x) + math.abs(Ship.vel.y) >= 10 then
		if Ship.vel.x > 0 then
			Ship.vel.x = (Ship.vel.x * 10/ (math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end
		if Ship.vel.y > 0 then
			Ship.vel.y = (Ship.vel.y * 10/ (math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end
		if Ship.vel.x < 0 then
			Ship.vel.x = (Ship.vel.x * 10/ (math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end
		if Ship.vel.y < 0 then
			Ship.vel.y = (Ship.vel.y * 10/ (math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end
	end



	--if Ship.vel.x + Ship.vel.y < 5 then
		--Ship.vel.x = Ship.pvel.x 
		--Ship.vel.y = Ship.pvel.y 

		--elseif Ship.vel.x + Ship.vel.y >= 5 then

			--Ship.vel.x = (Ship.vel.x * .05/(Ship.vel.x + Ship.vel.y))
			--Ship.vel.y = (Ship.vel.y * .05/(Ship.vel.x + Ship.vel.y))


	--end

	end

		Ship.x = Ship.x + Ship.vel.x * 2
		Ship.y = Ship.y + Ship.vel.y * 2

	local derp = 0

	--[[if math.abs(Ship.vel.x) + math.abs(Ship.vel.y) < .2 and (not love.keyboard.isDown('w') and not love.keyboard.isDown('up')) then
		Ship.vel.x = 0
		Ship.vel.y = 0
		derp = 1

	elseif derp == 0 and (not love.keyboard.isDown('w') and not love.keyboard.isDown('up')) then

		if Ship.vel.x > 0 then
		Ship.vel.x = Ship.vel.x - (Ship.vel.x * .05/(math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end
		
		if  Ship.vel.y > 0 then

		Ship.vel.y = Ship.vel.y - (Ship.vel.y * .05/(math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end


		if Ship.vel.x < 0 then
		Ship.vel.x = Ship.vel.x + (Ship.vel.x * .05/ -(math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		end
		
		if Ship.vel.y < 0 then

		Ship.vel.y = Ship.vel.y + (Ship.vel.y * .05/ -(math.abs(Ship.vel.x) + math.abs(Ship.vel.y)))
		


		end

	end]]


	derp = 0



	OO.x = Ship.x - (Ship.img:getWidth()/2)
	OO.y = Ship.y - (Ship.img:getHeight()/2 * 3)



--BULLETS\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/BULLETS

	for i, Bullet in ipairs(Bullets) do


		Bullet.x = Bullet.x + Bullet.vel.x * gameSpeed
		Bullet.y = Bullet.vel.y * gameSpeed + Bullet.y 


		if Bullet.x < 0 then
			Bullet.x = love.graphics.getWidth()
		end
		if Bullet.x > love.graphics.getWidth() then
			Bullet.x = 0
		end
		if Bullet.y < 0 then
			Bullet.y = love.graphics.getHeight()
		end
		if Bullet.y > love.graphics.getHeight() then
			Bullet.y = 0
		end


		if Bullet.timer ~= 0 then
			Bullet.timer = Bullet.timer - 1
			
		elseif Bullet.timer == 0 then
			table.remove(Bullets, i)

		end
	end



--ASTEROIDS \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ ASTROIDS

	local dude = math.random()

	
	if Level.add <= 0 then
		Level.need = Level.need + 1
		started = false
	end
	if Level.need > Level.add and Level.started == false then
		Level.add = Level.add + 1

		local moox = math.random(1, 2)
		local mooy = math.random(1, 2)
		local velx = math.random(1, 2)
		local vely = math.random(1, 2)

		if velx == 1 then
			velx = 1
		elseif velx == 2 then
			velx = -1
		end

		if vely == 1 then
			vely = 1
		elseif vely == 2 then
			vely = -1
		end
		


		if moox == 1 then

			if mooy == 1 then
				newAsteroid = {img = Asteroid.img, x = math.random(0, Ship.x - (Ship.img:getWidth()/2 * 3) - 20 - (Asteroid.img:getWidth() * 5)), y = math.random(0, Ship.y - (Ship.img:getHeight()/2 * 3) - 20 - Asteroid.img:getHeight() * 5), vel = {x = dude * velx, y = (math.abs(velx) - dude) * vely }, Size = 5}
			end
			if mooy == 2 then
				newAsteroid = {img = Asteroid.img, x = math.random(0, Ship.x - (Ship.img:getWidth()/2 * 3) - 20 - Asteroid.img:getWidth() * 5), y = math.random(Ship.y + (Ship.img:getHeight()/2 * 3) + 20, love.graphics.getHeight()), vel = {x = dude * velx, y = (math.abs(velx) - dude) * vely }, Size = 5}
			end
		end
		if moox == 2 then
			if mooy == 1 then
				newAsteroid = {img = Asteroid.img, x = math.random(Ship.x + (Ship.img:getWidth()/2 * 3) + 20, love.graphics.getWidth()), y = math.random(0, Ship.y - (Ship.img:getHeight()/2 * 3) - 20 - Asteroid.img:getHeight() * 5), vel = {x = dude * velx, y = (math.abs(velx) - dude) * vely }, Size = 5}
			end
			if mooy == 2 then
				newAsteroid = {img = Asteroid.img, x = math.random(Ship.x + (Ship.img:getWidth()/2 * 3) + 20, love.graphics.getWidth()), y = math.random(Ship.y + (Ship.img:getHeight()/2 * 3) + 20, love.graphics.getHeight() * 5), vel = {x = dude * velx, y = (math.abs(velx) - dude) * vely }, Size = 5}
			end
		end

		table.insert(Asteroids, newAsteroid)
		onScreen = onScreen + 1

	end



	for i, Asteroid in ipairs(Asteroids) do
		Asteroid.x = Asteroid.vel.x * gameSpeed + Asteroid.x
		Asteroid.y = Asteroid.vel.y * gameSpeed + Asteroid.y

		if Asteroid.x < 0 - (Asteroid.img:getWidth() * Asteroid.Size) then
			Asteroid.x = Asteroid.x + love.graphics.getWidth() + (Asteroid.img:getHeight() * Asteroid.Size)
		end
		if Asteroid.x > love.graphics.getWidth() then
			Asteroid.x = Asteroid.x - love.graphics.getWidth() - (Asteroid.img:getHeight() * Asteroid.Size)
		end
		if Asteroid.y < 0 - (Asteroid.img:getHeight() * Asteroid.Size) then
			Asteroid.y = Asteroid.y + love.graphics.getHeight() + (Asteroid.img:getHeight() * Asteroid.Size)
		end
		if Asteroid.y > love.graphics.getHeight() then
			Asteroid.y = Asteroid.y - love.graphics.getHeight() - (Asteroid.img:getHeight() * Asteroid.Size)
		end
		--***Bullet Collision***
		for j, Bullet in ipairs(Bullets) do
			if checkcollision(Asteroid.x, Asteroid.y, Asteroid.img:getWidth() * Asteroid.Size, Asteroid.img:getHeight() * Asteroid.Size, Bullet.x, Bullet.y, 0, 0) then

				if Asteroid.Size == 5 then
					score = score + 20
				end

				if Asteroid.Size == 3 then
					score = score + 50
				end

				if Asteroid.Size == 1 then
					score = score + 100
				end

				local velx = math.random(1, 2)
				local vely = math.random(1, 2)

				if velx == 1 then
					velx = 1
				elseif velx == 2 then
					velx = -1
				end

				if vely == 1 then
					vely = 1
				elseif vely == 2 then
					vely = -1
				end

				local v1 = math.random()
				newAsteroid = {img = Asteroid.img, x = (Asteroid.img:getWidth() * Asteroid.Size/2) - (Asteroid.img:getWidth() * (Asteroid.Size - 2) /2) + Asteroid.x, y = (Asteroid.img:getHeight() * Asteroid.Size/2) - (Asteroid.img:getHeight() * (Asteroid.Size - 2) /2) + Asteroid.y, vel = {x = v1 * velx, y = (math.abs(velx) - v1) * vely }, Size = Asteroid.Size - 2}
				if newAsteroid.Size >= 1 then
					table.insert(Asteroids, newAsteroid)
					onScreen = onScreen + 1
				end

				local velx = math.random(1, 2)
				local vely = math.random(1, 2)

				if velx == 1 then
					velx = 1
				elseif velx == 2 then
					velx = -1
				end

				if vely == 1 then
					vely = 1
				elseif vely == 2 then
					vely = -1
				end

				local v2 = math.random()
					newAsteroid = {img = Asteroid.img, x = (Asteroid.img:getWidth() * Asteroid.Size/2) - (Asteroid.img:getWidth() * (Asteroid.Size - 2) /2) + Asteroid.x, y = (Asteroid.img:getHeight() * Asteroid.Size/2) - (Asteroid.img:getHeight() * (Asteroid.Size - 2) /2) + Asteroid.y, vel = {x = v2 * velx, y = (math.abs(velx) - v2) * vely }, Size = Asteroid.Size - 2}
					if newAsteroid.Size >= 1 then
						table.insert(Asteroids, newAsteroid)
						onScreen = onScreen + 1
					end


				local velx = math.random(1, 2)
				local vely = math.random(1, 2)

					if velx == 1 then
					velx = 1
				elseif velx == 2 then
					velx = -1
				end

				if vely == 1 then
					vely = 1
				elseif vely == 2 then
					vely = -1
				end


				local v3 = math.random()
				newAsteroid = {img = Asteroid.img, x = (Asteroid.img:getWidth() * Asteroid.Size/2) - (Asteroid.img:getWidth() * (Asteroid.Size - 2) /2) + Asteroid.x, y = (Asteroid.img:getHeight() * Asteroid.Size/2) - (Asteroid.img:getHeight() * (Asteroid.Size - 2) /2) + Asteroid.y, vel = {x = v3 * velx, y = (math.abs(velx) - v3) * vely }, Size = Asteroid.Size - 2}
				if newAsteroid.Size >= 1 then
					table.insert(Asteroids, newAsteroid)
					onScreen = onScreen + 1
				end

				table.remove(Bullets, j)
				table.remove(Asteroids, i)
				onScreen = onScreen - 1

			end



	end

	xlol = Ship.x + ((math.sin(Ship.O)*Ship.img:getHeight()*.15)) --- 15 * math.cos(Ship.O))
	ylol = Ship.y + ((-math.cos(Ship.O)*Ship.img:getHeight()*.15)) --- 15 * math.sin(Ship.O))


	--xlol = Ship.x - (Ship.img:getHeight() / 2)
	--ylol = Ship.y - (Ship.img:getHeight() * 2/3)

	for i, Asteroid in ipairs(Asteroids) do
		if checkcollision(xlol - (Ship.img:getWidth()/2), ylol - (Ship.img:getHeight()/2), Ship.img:getWidth(), Ship.img:getHeight(), Asteroid.x, Asteroid.y, Asteroid.img:getWidth() * Asteroid.Size, Asteroid.img:getHeight() * Asteroid.Size) and not dead then
			 lives = lives - 1
			 if lives > 0 then
			dead = true
			immune.visible = 0
			timers.death.time = 2
			timers.death.enabled = true
			
			end

			if lives <= 0 then
				gameOver = true
				dead = true
				immune.visible = 0
				timers.death.enabled = true
				timers.death.time = 2

			end

		else
			

		end
	end

	if timers.death.time > 0 and timers.death.enabled and lives > 0 then
		timers.death.time = timers.death.time - (dt / onScreen)
	--elseif timers.death.time < 0 then
		--timers.death.enabled = false
	end


	if timers.death.time <= 0 and timers.death.enabled then
		timers.blink.time = 3
		timers.blink.enabled = true
		immune.blink = true
		Ship.O = 0
		Ship.x = love.graphics.getWidth()/2
		Ship.y = love.graphics.getHeight()/2
		Ship.vel.x = 0
		Ship.vel.y = 0
		timers.death.enabled = false


	end


	


	if timers.blink.time >= 0 and timers.blink.enabled then
		timers.blink.time = timers.blink.time - (dt / onScreen)
	--elseif timers.death.time < 0 then
		--timers.blink.enabled = false
	end

	immune.timer = immune.timer - 1 / onScreen

	if immune.blink then
		if immune.visible == 1 and immune.timer <= 0 then
			immune.visible = 0
			immune.timer = 1
		elseif immune.visible == 0 and immune.timer <= 0 then
			immune.visible = 1
			immune.timer = 1
		end



	end
end

	if timers.blink.time <= 0 and timers.blink.enabled then
		immune.blink = false
		immune.visible = 1
		dead = false
		timers.blink.enabled = false
	end


	if score >= extraLife then

		lives = lives + 1
		extraLife = extraLife + 10000

	end


--STARS \/\/\/\/\/\/\/\/\/\/\/ STARS
if starc < 18 then

	newStar = {x = math.random(0, love.graphics.getWidth()), y = math.random(0, love.graphics.getHeight()), img = star.img}


	table.insert(stars, newStar)

	starc = starc + 1

end
	

something = something + dt

if onScreen <= 0 then
	Level.add = 0
	
	Level.started = false
end
	

	





end

function love.draw(dt)


	for i, star in ipairs(stars) do
			love.graphics.draw(star.img, star.x, star.y, 0, .5, .5)
		end

	love.graphics.draw(Ship.img, Ship.x, Ship.y, Ship.O, immune.visible, immune.visible, Ship.img:getWidth()/2, Ship.img:getHeight()/3 * 2)
	
	
	
	
	for i, Asteroid in ipairs(Asteroids) do
		love.graphics.draw(Asteroid.img, Asteroid.x, Asteroid.y, 0, Asteroid.Size, Asteroid.Size)
	end

	for i, Bullet in ipairs(Bullets) do
		love.graphics.draw(Bullet.img, Bullet.x, Bullet.y, 0, 1, 1, Bullet.img:getWidth()/2, Bullet.img:getHeight()/2)
	end
	
		

		for i, UFO in ipairs (UFOs) do
			love.graphics.draw(UFO.cimg, UFO.x, UFO.y, 0, UFO.size, UFO.size)
		end
		love.graphics.print("Score: " .. score, 0, 0, 0, 1.5, 1.5)
		love.graphics.draw(lifeShips.img, lifeShips.x, lifeShips.y,  0 , lifeShips.size, lifeShips.size)
		love.graphics.print("X " .. lives, 5 + Ship.img:getWidth()/2, 22)


	if gameOver then

		love.graphics.print("Game Over", love.graphics.getWidth()/2 - 45, love.graphics.getHeight()/2 - 5)
		love.graphics.print("Press the space bar to retry", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 + 10)

	end


	
	--love.graphics.draw(Bullet.img, xlol - (Ship.img:getWidth()/2), ylol - (Ship.img:getHeight()/2), 0, 1, 1, Bullet.img:getWidth()/2, Bullet.img:getHeight()/2)


end


function love.keypressed(key)
	if key == "down" or key == "s" and not timers.death.enabled then
	Ship.x = math.random(0, love.graphics.getWidth())
	Ship.y = math.random(0, love.graphics.getHeight())
end

	if key == " " and not timers.death.enabled then
		newBullet = {x = Ship.x + (math.sin(Ship.O)*Ship.img:getHeight()*.8), y = Ship.y + (-math.cos(Ship.O)*Ship.img:getHeight()*.8), img = Bullet.img, vel = {x = Ship.pvel.x * 5, y = Ship.pvel.y * 5}, timer = 90}
		table.insert(Bullets, newBullet)



	end


	if key == " " and gameOver then
		while onScreen > 0 do
		for i, Asteroid in ipairs(Asteroids) do
			table.remove(Asteroids, i)
			onScreen = onScreen - 1
		end
		end
		immune.blink = false
		immune.visible = 1
		dead = false
		timers.blink.enabled = false
		Level.need = 0
		Ship.O = 0
		timers.death.enabled = false
		lives = 3
		Ship.vel.x = 0
		Ship.vel.y = 0
		Ship.x = love.graphics.getWidth()/2
		Ship.y = love.graphics.getHeight()/2
		Ship.O = 0
		score = 0
		gameOver = false
		extraLife = 10000
	end


end




