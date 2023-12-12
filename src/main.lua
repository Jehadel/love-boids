-- TO DO
-- o align
--
-- **********************************
-- Demo variables
-- *********************************

-- Constants
W_WIDTH = 800
W_HEIGHT = 600
W_LIMIT = 40

N_BOIDS = 80
CVISUAL_RANGE = 60 -- could be an individual boid property
DEAD_ANGLE = 60
V_TURN = 2 -- could be an individual boid property
MINDISTANCE = 20
VMAX = 100

AVOIDANCE = 30 
COHESION = 2 
CENTERING = 270

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

-- Determine if a boid is in the dead angle of the first boid 
function deadAngle(pBoid1, pBoid2)

  -- pBoid1 direction = -arctan(vx, vy)

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


function cohesion(pBoid, pVisualRange)

  local delta = {}
  local dVx = 0
  local dVy = 0
  local nearBoids = {}
  local sumX = 0
  local sumY = 0
  local sumVx = 0
  local sumVy = 0
  local n = 0

  for index, otherBoid in ipairs(boids.list) do

    if distance(pBoid, otherBoid) < pVisualRange then
      sumX = sumX + otherBoid.x
      sumY = sumY + otherBoid.y
      sumVx = sumVx + otherBoid.vx
      sumVy = sumVy + otherBoid.vy
      n = n + 1
    end
  end

  delta.dx = sumX/n - pBoid.x
  delta.dy = sumY/n - pBoid.y
  delta.dVx = sumVx/n - pBoid.vx 
  delta.dVy = sumVy/n - pBoid.vy
  
  return delta

end


function keepDistance(pBoid, pMinDistance)

  local dist = {}
  dist.dx = 0
  dist.dy = 0
  
  for index, otherBoid in ipairs(boids.list) do
    if pBoid ~= otherBoid then
      if distance(otherBoid, pBoid) < pMinDistance then
        dist.dx = dist.dx + (pBoid.x - otherBoid.x)
        dist.dy = dist.dy + (pBoid.y - otherBoid.y)
      end
    end
  end

  return dist 

end


function keepInside(pBoid, pVTurn, pLimit)

  local turn = {}
  turn.dVx = 0
  turn.dVy = 0


  if pBoid.x < pLimit then
    turn.dVx = pVTurn
  end

  if pBoid.x > W_WIDTH - pLimit then
    turn.dVx = - pVTurn
  end

  if pBoid.y < pLimit then
    turn.dVy = pVTurn 
  end

  if pBoid.y > W_HEIGHT - pLimit then
    turn.dVy = - pVTurn 
  end

  return turn 

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

    -- align position and speed with that of others
    cohesionForce = cohesion(boid, CVISUAL_RANGE)
    -- boids avoid each other
    avoidanceForce = keepDistance(boid, MINDISTANCE)
    -- boids return to the center when approching window’s edges
    centeringForce = keepInside(boid, V_TURN, W_LIMIT)

    -- boids speed adjustement according all forces
    -- we could add ponderations
    boid.vx = boid.vx + (avoidanceForce.dx * AVOIDANCE
                          + centeringForce.dVx * CENTERING
                          + (cohesionForce.dx 
                            + cohesionForce.dVx) * COHESION
                        ) * dt

    boid.vy = boid.vy + (avoidanceForce.dy * AVOIDANCE
                        + centeringForce.dVy * CENTERING
                        + (cohesionForce.dy 
                          + cohesionForce.dVy) * COHESION
                        ) * dt

    -- speed limitation
    if math.abs(boid.vx) > VMAX then
      boid.vx = boid.vx/math.abs(boid.vx) * VMAX
    end
    if math.abs(boid.vy) > VMAX then
      boid.vy = boid.vy/math.abs(boid.vy) * VMAX
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
    love.graphics.draw(boids.img, boid.x, boid.y, -math.atan2(boid.vx, boid.vy), .67, .67, boids.w/2, boids.h/2)
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
