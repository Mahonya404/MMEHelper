script_name("Timer")
script_version("1.0")
script_author("Mahonya - Marco_Russo")
local wm =			require 'lib.windows.message'
local SE = 			require 'lib.samp.events'
local key =			require 'vkeys'
local encoding =	require 'encoding'
local inicfg =		require 'inicfg'
local IniDir = 'MassMedia/main.ini'
local MainIni = inicfg.load(nil,IniDir)
local u8 = encoding.UTF8
encoding.default = "CP1251"
u8=encoding.UTF8

function timer()
	wait(3000)
	while 1 == 1 do
	wait(1000)
		MainIni = inicfg.load(nil,IniDir)
		MainIni.timer.sec = MainIni.timer.sec + 1
		if inicfg.save(MainIni,IniDir) then end
		if MainIni.timer.sec == 60 then
			MainIni.timer.sec = 0
			MainIni.timer.min = MainIni.timer.min + 1
			MainIni.timer.tmin = MainIni.timer.tmin + 1
			if inicfg.save(MainIni,IniDir) then end
		elseif MainIni.timer.min == 60 then
			MainIni.timer.min = 0
			MainIni.timer.hour = MainIni.timer.hour + 1
			if inicfg.save(MainIni,IniDir) then end
		elseif MainIni.timer.hour == 24 then
			MainIni.timer.hour = 0
			MainIni.timer.day = MainIni.timer.day + 1
			if inicfg.save(MainIni,IniDir) then end
		elseif MainIni.timer.tmin == 60 then
			MainIni.timer.tmin = MainIni.timer.tmin - 60
			MainIni.timer.thour = MainIni.timer.thour + 1
			if inicfg.save(MainIni,IniDir) then end
		elseif MainIni.timer.thour == 24 then
			MainIni.timer.thour = 0
			MainIni.timer.tday = MainIni.timer.tday + 1
			if inicfg.save(MainIni,IniDir) then end
		end
	end
end

function reload()
	MainIni = inicfg.load(nil,IniDir)
	MainIni.timer.sec = 0
	MainIni.timer.min = 0
	MainIni.timer.hour = 0
	MainIni.timer.day = 0
	if inicfg.save(MainIni,IniDir) then end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		error("Отсутствует SAMPFUNCS")
	end

	while not isSampAvailable() do wait(100) end

	reload()

	while true do
		wait(0)
		timer()
	end
end
