-- TO DO
-- o ajout limite vitesse
--
-- **********************************
-- Demo variables
-- *********************************

-- Constants
W_WIDTH = 800
W_HEIGHT = 600
W_LIMIT = 50

N_BOIDS = 100
VISUAL_RANGE = 75
V_TURN = 2 

-- boids table
local boids = {}
boids.list = {}
boids.img = love.graphics.newImage('pix/boid.png')
boids.w = boids.img:getWidth()
boids.h = boids.img:getHeight()

-- *****************
-- Fonctions
-- *****************

-- Boids 
function createBoid()

  local boid = {}
  boid.x = math.random(W_LIMIT, W_WIDTH - W_LIMIT) 
  boid.y = math.random(W_LIMIT, W_HEIGHT - W_LIMIT)
  boid.vx = math.random(-100, 100)  
  boid.vy = math.random(-100, 100) 

  return boid

end

function keepInside(pBoid, dt)

  if pBoid.x < W_LIMIT then
    pBoid.vx = pBoid.vx + V_TURN 
  end

  if pBoid.x > W_WIDTH - W_LIMIT then
    pBoid.vx = pBoid.vx - V_TURN
  end

  if pBoid.y < W_LIMIT then
    pBoid.vy = pBoid.vy + V_TURN
  end

  if pBoid.y > W_HEIGHT - W_LIMIT then
    pBoid. vy = pBoid.vy - V_TURN
  end

  return pBoid
end

-- ****************************
-- INITIALISATION
-- ****************************

function initDemo()
  
  for n = 1, N_BOIDS do
    table.insert(boids.list, createBoid())
  end

end


function love.load()

  love.window.setMode(W_WIDTH, W_HEIGHT)
  love.window.setTitle('Reynolds’ Boids')
  
  --police = love.graphics.newFont('fonts/police.ttf', 20)
  --love.graphics.setFont(police)

  initDemo()

end


-- ******************
-- UPDATE
-- ******************

function love.update(dt)

  for index, boid in ipairs(boids.list) do 

    -- cohesion()
    -- align()
    -- keepDistance()
    boid = keepInside(boid)

    boid.x = boid.x + boid.vx * dt
    boid.y = boid.y + boid.vy * dt


end

end


-- ***************
-- DRAWING 
-- ***************

function love.draw()

  for index, boid in ipairs(boids.list) do
    love.graphics.draw(boids.img, boid.x, boid.y, -math.atan2(boid.vx, boid.vy), 1, 1, boids.w/2, boids.h/2)

  end

end

-- ******************
-- Quit demo
-- ******************

function love.keypressed(key)

  if key == 'escape' then
    love.event.quit()
  end

end
