-- TO DO
-- o align
--
-- **********************************
-- Demo variables
-- *********************************

-- Constants
W_WIDTH = 800
W_HEIGHT = 600
W_LIMIT = 50

N_BOIDS = 100
CVISUAL_RANGE = 75 -- could be an individual boid property
VMAX = 100
V_TURN = 2 -- could be an individual boid property
AVOIDANCE = .1
MINDISTANCE = 50

-- boids table
local boids = {}
boids.list = {}
boids.img = love.graphics.newImage('pix/boid.png')
boids.w = boids.img:getWidth()
boids.h = boids.img:getHeight()

-- *****************
-- Fonctions
-- *****************

function distance(pBoid1, pBoid2) 

  return math.sqrt((pBoid1.x - pBoid2.x)^2 + (pBoid1.y - pBoid2.y)^2)

end

-- Boids 
function createBoid()

  local boid = {}
  boid.x = math.random(W_LIMIT, W_WIDTH - W_LIMIT) 
  boid.y = math.random(W_LIMIT, W_HEIGHT - W_LIMIT)
  boid.vx = math.random(-VMAX, VMAX)  
  boid.vy = math.random(-VMAX, VMAX) 

  return boid

end

function keepDistance(pBoid, pMinDistance, pAvoidance)

  local dVx = 0
  local dVy = 0
  
  for index, otherBoid in ipairs(boids.list) do
    if pBoid ~= otherBoid then
      if distance(otherBoid, pBoid) < pMinDistance then
        dVx = dVx + (pBoid.x - otherBoid.x)
        dVy = dVy + (pBoid.y - otherBoid.y)
      end
    end
  end

  pBoid.vx = pBoid.vx + dVx * pAvoidance
  pBoid.vy = pBoid.vy + dVy * pAvoidance

  return pBoid

end


function keepInside(pBoid)

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
    boid = keepDistance(boid, MINDISTANCE, AVOIDANCE)
    boid = keepInside(boid)

    -- speed limitation
    if math.abs(boid.vx) > VMAX then
      boid.vx = boid.vx/boid.vx * VMAX
    end
    if math.abs(boid.vy) > VMAX then
      boid.vy = boid.vy/boid.vy * VMAX
    end

    -- move boid according to its speed
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
