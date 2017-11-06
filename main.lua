-- Project: Attack of the Cuteness Game
-- http://MasteringCoronaSDK.com
-- Version: 1.0
-- Copyright 2013 J. A. Whye. All Rights Reserved.
-- "Space Cute" art by Daniel Cook (Lostgarden.com) 

-- housekeeping stuff

display.setStatusBar(display.HiddenStatusBar) --hide status bar time, etc.

local centerX = display.contentCenterX 
local centerY = display.contentCenterY

-- set up forward references
local spawnEnemy
local gameTitle
local scoreTxt
local score = 0
local hitPlanet
local planet
local speedBump = 0
local numHits = 0

-- preload audio
local sndKill = audio.loadSound("boing-1.wav")
local sndBlast = audio.loadSound("blast.mp3")
local sndLose = audio.loadSound("wahwahwah.mp3")

-- create play screen
local function createPlayScreen()
	local background = display.newImage('background.png');
	background.x = centerX;
	background.y = 0
	background.alpha = 0
	transition.to( background, { time=3000, alpha=1, y=centerY } )--load once only not everytime you start game.
	--background:addEventListener ( 'tap', shipSmash )

	planet = display.newImage("planet.png");
	planet.x = centerX;
	planet.y = display.contentHeight + 60
	planet.alpha = 0;
	planet.xScale = 1; --double the size
	planet.yScale = 1; -- double the size
	--planet:addEventListener ( 'tap', shipSmash )
	
	local function showTitle()
		gameTitle = display.newImage("gametitle.png")
		gameTitle.alpha = 0
		gameTitle:scale(5, 5); --shorthand for xScale4, yScale4
		transition.to( gameTitle, { time=600, alpha=1, xScale =1, yScale=1 } )
		startGame()
	end
	transition.to( planet, { time=3000, alpha=1, y=centerY, onComplete=showTitle } ) --put this at create play screen
end


-- game functions
function spawnEnemy()
	local enemy = display.newImage('beetleship.png')
	enemy:addEventListener ( 'tap', shipSmash )

	if math.random(2) == 1 then
		enemy.x = math.random (-100, -10)
	else
		enemy.xScale = -1
		enemy.x = math.random ( display.contentWidth + 10, display.contentWidth + 100 )
	end
	enemy.y = math.random (display.contentHeight)
	enemy.attack = transition.to ( enemy, { x=centerX, y=centerY, time=3500, onComplete=hitPlanet } )
end

--level medium
function spawnMedium()
	local enemy = display.newImage('octopus.png')
	enemy:addEventListener ( 'tap', shipSmash2)
	if math.random(2) == 1 then
		enemy.x = math.random (-100, -10)
	else
		enemy.xScale = -1
		enemy.x = math.random ( display.contentWidth + 10, display.contentWidth + 100 )
	end
	enemy.attack = transition.to ( enemy, { x=centerX, y=centerY, time=3000, onComplete=hitPlanet } )
end

--level hard
function spawnHard()
	local enemy = display.newImage('rocketship.png')
	enemy:addEventListener ( 'tap', shipSmash2)
	if math.random(2) == 1 then
		enemy.x = math.random (-100, -10)
	else
		enemy.xScale = -1
		enemy.x = math.random ( display.contentWidth + 10, display.contentWidth + 100 )
	end
	enemy.attack = transition.to ( enemy, { x=centerX, y=centerY, time=3000, onComplete=hitPlanet } )
end


function startGame()
	local text = display.newText( "Tap here to start. Protect the Planet!", 0, 0, "Helvetica", 24 )
	text.x = centerX
	text.y = display.contentHeight - 60
	text.alpha = 0.5
	text.rotation = -10
	text:setTextColor(255, 254, 185)
	score = 0
	
	local function goAway(event)
		display.remove(event.target)
		text = nil
		display.remove(gameTitle)
		scoreTxt = display.newText ( "Score: 0", 0, 0, "Helvetica", 22 )
		scoreTxt.x = centerX; scoreTxt.y = display.screenOriginY + 10
		spawnEnemy()
	end
	text:addEventListener ( "tap", goAway )
end

function shipSmash(event)
	local obj = event.target
	display.remove( obj )
	audio.play(sndKill)
	transition.cancel ( event.target )
	score = score + 1
	scoreTxt.text = "Score: " .. score

	spawnEnemy()
	if score > 10 and score < 25 then
		spawnMedium()

	elseif score > 25 then
		spawnMedium()
		spawnHard()
	end
	return true -- to prevent click to pass through and remove BG
end

function shipSmash2(event)
	local obj = event.target
	display.remove( obj )
	audio.play(sndKill)
	transition.cancel ( event.target )
	score = score + 2
	scoreTxt.text = "Score: " .. score
	return true -- to prevent click to pass through and remove BG
end

function planetDamage()
	function goAway(obj)
			planet.xScale = 1
			planet.yScale = 1
			numHits = numHits + 0.2
			planet.numHits = numHits
			planet.alpha = 1 - numHits
			audio.play(sndLose)
	end
	transition.to ( planet, { time=200, xScale=1.2, yScale=1.2, onComplete=goAway } )
end

function hitPlanet(obj)
	display.remove( obj )
	planetDamage()
	audio.play(sndBlast)
	spawnEnemy()
end

createPlayScreen()