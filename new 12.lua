local dlstatus = require('moonloader').download_status
local lanes = require('lanes').configure()
local current_ver = 0.8 
local f = float
local ver = float

function async_http_request(method, url, args, resolve, reject)
    local request_lane = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
        local requests = require 'requests'
        local ok, result = pcall(requests.request, method, url, args)
        if ok then
            result.json, result.xml = nil, nil -- cannot be passed through a lane
            return true, result
        else
            return false, result -- return error
        end
    end)
    if not reject then reject = function() end end
    lua_thread.create(function()
        local lh = request_lane()
        while true do
            local status = lh.status
            if status == 'done' then
                local ok, result = lh[1], lh[2]
                if ok then resolve(result) else reject(result) end
                return
            elseif status == 'error' then
                return reject(lh[1])
            elseif status == 'killed' or status == 'cancelled' then
                return reject(status)
            end
            wait(0)
        end
    end)
end



function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		error("Отсутствует SAMPFUNCS")
	end
	
	while not isSampAvailable() do wait(100) end
	 
	sampAddChatMessage('Dev',0x99999)
	 
	async_http_request('GET', 'https://raw.githubusercontent.com/Mahonya404/MMEHelper/master/ver.txt', nil,
		function(response)
			print('Последняя версия: '..response.text)
			ver = tonumber(response.text)
			if ver > current_ver then print('1') else print('2') end
			end)
	

	
	
	sampRegisterChatCommand("reload", function()
		thisScript():reload();
	end)
end