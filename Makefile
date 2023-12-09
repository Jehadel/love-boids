play:
	love ./src/

love:
	mkdir -p dist
	cd src && zip -r ../dist/love-boids.love .

js: love
	love.js -c --title="Reynold’s Boids demo" ./dist/love-boids.love ./dist/js

