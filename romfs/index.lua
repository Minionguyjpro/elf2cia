----------------------------------------------
-- Minimalist JPGV Player by Rinnegatamante --
--        Optimized for performances        --
----------------------------------------------

-- Enable speedup for N3DS users
System.setCpuSpeed(804)

-- Open video
local video = JPGV.load("romfs:/video.jpgv")

-- Calculate video duration
local tot_time_sec = math.ceil(JPGV.getSize(video) / JPGV.getFPS(video))
local tot_time_min = 0
while (tot_time_sec >= 60) do
	tot_time_sec = tot_time_sec - 60
	tot_time_min = tot_time_min + 1
end

-- Using local variables
local cur_time_sec = 0
local cur_time_min = 0
local percentage = 0
local move = 0
local cinema = false

-- Using local functions
local UPSCREEN = TOP_SCREEN
local DOWNSCREEN = BOTTOM_SCREEN
local waitScreen = Screen.waitVblankStart
local refreshScreen = Screen.refresh
local clearScreen = Screen.clear
local drawVideo = JPGV.drawFast
local readInput = Controls.read
local initGpu = Graphics.initBlend
local termGpu = Graphics.termBlend
local drawRect = Graphics.fillRect
local printText = Screen.debugPrint
local checkInput = Controls.check
local totalLength = JPGV.getSize
local curPosition = JPGV.getFrame
local getFramerate = JPGV.getFPS
local flipScreen = Screen.flip
local START = KEY_START
local Y = KEY_Y
local A = KEY_A
local round = math.ceil

-- Initializie Sound and Graphics module
Sound.init()
Graphics.init()

-- Start video in non-looping mode
JPGV.start(video, NO_LOOP)

-- Initialize oldpad
local oldpad = 0
local pad = 0

-- Initialize a color
local white = Color.new(255,255,255)
local black = Color.new(0,0,0)

while true do

	-- Update screens
	waitScreen()
	refreshScreen()
	
	-- Drawing current frame for the video on screen
	drawVideo(video,UPSCREEN)
	
	-- Read controls input
	pad = readInput()
	
	-- Close player
	if (checkInput(pad,START)) then
		JPGV.stop(video)
		JPGV.unload(video)
		Sound.term()
		System.exit()
	end
	
	-- Enable / Disable Cinema
	if (checkInput(pad, Y) and not checkInput(oldpad, Y)) then
		cinema = not cinema
		if not cinema then
			Controls.enableScreen(DOWNSCREEN)
		else
			Controls.disableScreen(DOWNSCREEN)
		end
	end
	
	-- Pause / Resume video
	if (checkInput(pad, A) and not checkInput(oldpad, A)) then
		if JPGV.isPlaying(video) then
			JPGV.pause(video)
		else
			JPGV.resume(video)
		end
	end
	
	if not cinema then
	
		-- Purge screen
		clearScreen(DOWNSCREEN)
		
		-- Draw progress bar
		initGpu(DOWNSCREEN)
		percentage = (curPosition(video) * 100) / totalLength(video)
		drawRect(2,318,214,234,white)
		drawRect(3,317,215,233,black)
		move = ((314 * percentage) / 100)
		drawRect(3,3 + move,215,233,white)
		termGpu()
	
		-- Draw current time of the video
		cur_time_sec = round(curPosition(video) / getFramerate(video))
		cur_time_min = 0
		while (cur_time_sec >= 60) do
			cur_time_sec = cur_time_sec - 60
			cur_time_min = cur_time_min + 1
		end
		if (cur_time_sec < 10) then
			printText(2,128,"Time: " .. cur_time_min .. ":0" .. cur_time_sec .. " / " .. tot_time_min .. ":" .. tot_time_sec,white,DOWNSCREEN)
		else
			printText(2,128,"Time: " .. cur_time_min .. ":" .. cur_time_sec .. " / " .. tot_time_min .. ":" .. tot_time_sec,white,DOWNSCREEN)
		end
	
		-- Draw controls
		printText(2, 5, "A = Pause/Resume video", white, DOWNSCREEN)
		printText(2, 20, "Y = Enable/Disable Cinema", white, DOWNSCREEN)
		printText(2, 35, "START = Return Home Menu", white, DOWNSCREEN)
	
	end
	
	-- Flip screens
	flipScreen()
	
	-- Updating oldpad
	oldpad = pad
	
end