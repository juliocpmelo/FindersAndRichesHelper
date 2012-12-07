local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

 -- internationalization code 
 -- = LibStub("AceLocale-3.0"):GetLocale("FindersAndRichiesHelper", not debug)

--
local L

local Astrolabe = DongleStub("Astrolabe-1.0")

FindersAndRichiesHelper = LibStub("AceAddon-3.0"):NewAddon("FindersAndRichiesHelper", "AceConsole-3.0")

local addonName = "Finders And Richies Helper (frh)"



local defaultSettings = {
  global = {
	-- verify which variables need to be stored to previous use
	limitZone = true,
	limitMissing = true,
	addFindersWaypoints = false,
	addRichiesWaypoints = false
  }
}

local updaterFrame = nil

-- richies of pandaria locations according wowhead (12/03/12)						 
local richiesOfPandaria	={ --Jade Forest items
						 {map=806, qid = 31400 , desc = 'Ancient Pandaren Tea Pot', pos = { x=26.22 , y=32.35}},
						 {map=806, qid = 31401 , desc = 'Lucky Pandaren Coin', pos = { x=31.96  , y=27.75}},
						 {map=806, qid = 31404 , desc = 'Pandaren Ritual Stone', pos = { x=23.49 , y=35.05}},
						 {map=806, qid = 31396 , desc = 'Ship\'s Locker', pos = { x=51.22 , y=100.00}},
						  --Valley of the Four Winds items
						 {map=807, qid = 31405 , desc = 'Virmen Treasure Cache', pos = { x=23.71 , y=28.33}},
						 {map=807, qid = 31408 , desc = 'Saurok Stone Tablet', pos = { x=75.1 , y=55.1}},
						  -- The Veiled Stair Items
						 {map=873, qid = 31428 , desc = 'The Hammer of Folly', pos = { x=74.93 , y=76.48}},
						  -- Kun-Lai Summit
						 {map=809, qid = 31420 , desc = 'Ancient Mogu Tablet', pos = { x=63.94 , y=49.84}},
						 {map=809, qid = 31414 , desc = 'Hozen Treasure Cache', pos = { x=50.36 , y=61.77}},
						 {map=809, qid = 31418 , desc = 'Lost Adventurer\'s Belongings', pos = { x=36.70 , y=79.70}},
						 {map=809, qid = 31419 , desc = 'Rikktik\'s Tiny Chest', pos = { x=52.57 , y=51.54}},
						 {map=809, qid = 31416 , desc = 'Statue of Xuen', pos = { x=72.01 , y=33.96}},
						 {map=809, qid = 31415 , desc = 'Stolen Sprite Treasure', pos = { x=41.67 , y=44.12}},
						 {map=809, qid = 31422 , desc = 'Terracotta Head', pos = { x=59.24 , y=73.03}},
						  -- Townlong Steppes
						 {map=810, qid = 31427 , desc = 'Abandoned Crate of Goods', pos = { x=62.82 , y=34.05}},
						 {map=810, qid = 31426 , desc = 'Amber Encased Moth', pos = { x=65.83 , y=86.08}},
						 {map=810, qid = 31423 , desc = 'Fragment of Dread', pos = { x=48.49 , y=89.46}},
						 {map=810, qid = 31424 , desc = 'Hardened Sap of Kri\'vess', pos = { x=52.84 , y=56.17}},
						 }

-- finders keepers locations according wowhead (12/03/12)
-- TODO check possibility to use the npc scan to track the npcs
local findersKeepers	={ --Jade Forest items
						 {map=806, qid = 31402 , desc = 'Ancient Jinyu Staff spot 1', pos = { x=47.10 , y=67.40}},
						 {map=806, qid = 31402 , desc = 'Ancient Jinyu Staff spot 2', pos = { x=46.20 , y=71.20}},
						 {map=806, qid = 31402 , desc = 'Ancient Jinyu Staff spot 3', pos = { x=44.90 , y=64.60}},
						 {map=806, qid = 31399 , desc = 'Ancient Pandaren Mining Pick spot 1', pos = { x=46.10 , y=29.10}},
						 {map=806, qid = 31399 , desc = 'Ancient Pandaren Mining Pick spot 2', pos = { x=44.10 , y=27.00}},
						 {map=806, qid = 31399 , desc = 'Ancient Pandaren Mining Pick spot 3', pos = { x=43.80 , y=30.70}},
						 {map=806, qid = 31403 , desc = 'Hammer of Ten Thunders spot 1', pos = { x=41.80 , y=17.60}},
						 {map=806, qid = 31403 , desc = 'Hammer of Ten Thunders spot 2', pos = { x=43.00 , y=11.60}},
						 {map=806, qid = 31307 , desc = 'Jade Infused Blade', pos = { x=39.26 , y=46.65}, npc = {id='64272', name='Jade Warrior Statue'}}, -- npc scan id 64272 Jade Warrior Statue
						 {map=806, qid = 31397 , desc = 'Wodin\'s Mantid Shanker', pos = { x=39.00 , y=7.00}},
						  --Valley of the Four Winds items
						 {map=807, qid = 31284 , desc = 'Ancient Pandaren Fishing Charm', pos = { x=45.40 , y=38.20}, npc = {id=64004, name='Ghostly Pandaren Fisherman'}}, -- npc scan id 64004 Ghostly Pandaren Fisherman
						 {map=807, qid = 31292 , desc = 'Ancient Pandaren Woodcutter', pos = { x=45.40 , y=38.20}, npc = {id=64191, name='Ghostly Pandaren Craftsman'}}, -- npc scan id 64191 Ghostly Pandaren Craftsman
						 {map=807, qid = 31406 , desc = 'Cache of Pilfered Goods', pos = { x=43.50 , y=37.40}},
						 {map=807, qid = 31407 , desc = 'Staff of the Hidden Master spot 1', pos = { x=15.40 , y=29.10}},
						 {map=807, qid = 31407 , desc = 'Staff of the Hidden Master spot 2', pos = { x=17.50 , y=35.70}},
						 {map=807, qid = 31407 , desc = 'Staff of the Hidden Master spot 3', pos = { x=19.10 , y=37.90}},
						 {map=807, qid = 31407 , desc = 'Staff of the Hidden Master spot 4', pos = { x=15.00 , y=33.70}},
						 {map=807, qid = 31407 , desc = 'Staff of the Hidden Master spot 5', pos = { x=19.00 , y=42.50}},
						  -- Krasarang Wilds
						 {map=857, qid = 31410 , desc = 'Equipment Locker', pos = { x=42.00 , y=91.00}},
						 {map=857, qid = 31409 , desc = 'Pandaren Fishing Spear', pos = { x=50.80 , y=49.30}},
						 {map=857, qid = 31411 , desc = 'Recipe: Banana Infused Rum', pos = { x=52.30 , y=88.00}},
						  -- Kun-Lai Summit
						 {map=809, qid = 31413 , desc = 'Hozen Warrior Spear', pos = { x=52.80 , y=71.30}},
						 {map=809, qid = 31304 , desc = 'Kafa Press', pos = { x=37.37 , y=77.84}},
						 {map=809, qid = 31412 , desc = 'Sprite\'s Cloth Chest', pos = { x=74.70 , y=74.90}},
						 {map=809, qid = 31421 , desc = 'Sturdy Yaungol Spear spot 1', pos = { x=71.20 , y=62.60}},
						 {map=809, qid = 31421 , desc = 'Sturdy Yaungol Spear spot 2', pos = { x=70.00 , y=63.80}},
						 {map=809, qid = 31417 , desc = 'Tablet of Ren Yun', pos = { x=44.7 , y=52.4}},
						  -- Townlong Steppes
						 {map=810, qid = 31425 , desc = 'Yaungol Fire Carrier', pos = { x=66.30 , y=44.70}},
						 {map=810, qid = 31425 , desc = 'Yaungol Fire Carrier', pos = { x=66.80 , y=48.00}},
						  -- Dread Wastes
						 {map=858, qid = 31438 , desc = 'Blade of the Poisoned Mind', pos = { x=28.00 , y=42.00}},
						 {map=858, qid = 31433 , desc = 'Blade of the Prime', pos = { x=25.70 , y=54.40}},
						 {map=858, qid = 31436 , desc = 'Bloodsoaked Chitin Fragment', pos = { x=25.70 , y=54.40}},
						 {map=858, qid = 31435 , desc = 'Dissector\'s Staff of Mutation', pos = { x=30.20 , y=90.80}},
						 {map=858, qid = 31431 , desc = 'Lucid Amulet of the Agile Mind', pos = { x=32.00 , y=30.00}},
						 {map=858, qid = 31430 , desc = 'Malik\'s Stalwart Spear', pos = { x=48.00 , y=30.00}},
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 1', pos = { x=42.00 , y=62.20}, npc = {id='65552', name='Glinting Rapana Whelk'}}, -- npc scan id 65552 Glinting Rapana Whelk
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 2', pos = { x=42.20 , y=63.60}},
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 3', pos = { x=41.60 , y=64.60}},
						 {map=858, qid = 31434 , desc = 'Swarming Cleaver of Ka\'roz', pos = { x=56.80 , y=77.60}},
						 {map=858, qid = 31666 , desc = 'Wind-Reaver\'s Dagger of Quick Strikes', pos = { x=71.80 , y=36.10}},
						 }



--vector to store the current showed waypoints 
local currentWayPoints = {}
 
--vector to store the current tracked npcs
local currentTrackedNpcs = {}
 
--called when the player changes the map or when he logs in the game
function eventHandler(frame, event, ...)
	--update map every change if show mode is enabled.
	-- TODO: add achievement track or quest track to remove waypoints when a item is found
	-- QUEST_WATCH_UPDATE, CRITERIA_UPDATE or 
	if (event == "ZONE_CHANGED_NEW_AREA") then
		if FindersAndRichiesHelper.settings.global.limitZone then -- remove the waypoints from previous area and add for the new one
			--FindersAndRichiesHelper:Print('clear npcs and waypoints')
			FindersAndRichiesHelper:ClearWaypoints()
			FindersAndRichiesHelper:ClearNpcs()
			if FindersAndRichiesHelper.settings.global.addFindersWaypoints then
				--FindersAndRichiesHelper:Print('processing waypoints to Finders')
				FindersAndRichiesHelper:SetAchievementWaypoints(FindersAndRichiesHelper.settings.global.limitZone, FindersAndRichiesHelper.settings.global.limitMissing, richiesOfPandaria)
			end
			if FindersAndRichiesHelper.settings.global.addRichiesWaypoints then 
				--FindersAndRichiesHelper:Print('processing waypoints to Richies')
				FindersAndRichiesHelper:SetAchievementWaypoints(FindersAndRichiesHelper.settings.global.limitZone, FindersAndRichiesHelper.settings.global.limitMissing, findersKeepers)
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then -- reload the configurations from previous sessions
		if FindersAndRichiesHelper.settings.global.addFindersWaypoints then
			--FindersAndRichiesHelper:Print('processing waypoints to Finders')
			FindersAndRichiesHelper:SetAchievementWaypoints(FindersAndRichiesHelper.settings.global.limitZone, FindersAndRichiesHelper.settings.global.limitMissing, richiesOfPandaria)
		end
		if FindersAndRichiesHelper.settings.global.addRichiesWaypoints then 
			--FindersAndRichiesHelper:Print('processing waypoints to Richies')
			FindersAndRichiesHelper:SetAchievementWaypoints(FindersAndRichiesHelper.settings.global.limitZone, FindersAndRichiesHelper.settings.global.limitMissing, findersKeepers)
		end
	elseif event == "PLAYER_LEAVING_WORLD" then -- remove waypoints from tomtom
		FindersAndRichiesHelper:ClearWaypoints();
		FindersAndRichiesHelper:ClearNpcs();
	end
	--QUEST_WATCH_UPDATE
	--PLAYER_LEAVING_WORLD
	
end

 
 
 function FindersAndRichiesHelper:OnInitialize()
	-- Called when the addon is loaded
	self:RegisterChatCommand("findersandrichieshelper", "SlashCommand")
	self:RegisterChatCommand("frh", "SlashCommand")

	self.settings = LibStub("AceDB-3.0"):New("FRH_Settings", defaultSettings)
  
	if updaterFrame == nil then
		--updaterFrame = CreateFrame("frame")
		--InterfaceOptions_AddCategory(updaterFrame)
		local AceConfig = LibStub("AceConfig-3.0")
		AceConfig:RegisterOptionsTable("Finders And Richies Helper (frh)", function () return self:InterfaceOptions() end)
		updaterFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Finders And Richies Helper (frh)")
		updaterFrame.default = function() self:SetDefaultOptions() end
		updaterFrame:SetScript("OnEvent", eventHandler)
		updaterFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		updaterFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		updaterFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
		updaterFrame:Show()
	end
end

function FindersAndRichiesHelper:SetDefaultOptions() 
  self.settings.global.limitMissing = true
  self.settings.global.limitZone = true
  self.settings.global.addFindersWaypoints = false
  self.settings.global.addRichiesWaypoints = false
  FindersAndRichiesHelper:ProcessOptions()
end

function FindersAndRichiesHelper:ProcessOptions()
  FindersAndRichiesHelper:ClearNpcs();
  FindersAndRichiesHelper:ClearWaypoints();
  if self.settings.global.addFindersWaypoints then
	--self:Print('processing waypoints to Finders')
	FindersAndRichiesHelper:SetAchievementWaypoints(self.settings.global.limitZone, self.settings.global.limitMissing, richiesOfPandaria)
  end
  if self.settings.global.addRichiesWaypoints then
	--self:Print('processing waypoints to Richies')
	FindersAndRichiesHelper:SetAchievementWaypoints(self.settings.global.limitZone, self.settings.global.limitMissing, findersKeepers)
  end
end

function FindersAndRichiesHelper:PrintUsage()
  local s

  s = "\n"
  s = s .. "|cff7777ff/FindersAndRichiesHelper ...|r\n"
  s = s .. "|cff7777ff/use the commands without the richies or finders key words to track/clear both achievement critaria...|r\n"
  s = s .. "|cff7777ff/frh (richies|finders) all zone|r " .. "add waypoints to all items in current zone, including already found ones" .. "\n"
  s = s .. "|cff7777ff/frh (richies|finders) missing zone|r " .. "add waypoints to all items in current zone, excluding alrady found ones" .. "\n"
  s = s .. "|cff7777ff/frh (richies|finders) all|r " .. "add waypoints to all items in all maps, including already found ones" .. "\n"
  s = s .. "|cff7777ff/frh (richies|finders) all missing|r " .. "add waypoints to all items in all maps, excluding already found ones" .. "\n"
  s = s .. "|cff7777ff/frh clear|r " .. "clear all waypoints to the tracked achievements" .. "\n"
  s = s .. "|cff7777ff/frh debug|r " .. "esable/disable debug mode"
  

  self:Print(s)
end

function FindersAndRichiesHelper:SlashCommand(command)
  local limitZone, limitMissing, distance
  
  
  addFindersWaypoints = false
  addRichiesWaypoints = false
  limitMissing = false
  limitZone = false
  clearWaypoints = false
  
  --debug mode for test only
  if command:match"^%s*debug%s*$" then
    debug = not debug
    local str = "\n"
    if debug then
      str = str .. 'Debug mode enabled'
    else
      str = str .. 'Debug mode disabled'
    end
    self:Print(str)
  -- both achievements at the same time
  elseif command:match"^%s*all%s+zone%s*$" then -- markers only in the current zone, but including already found items
	limitZone = true
	addFindersWaypoints = true
	addRichiesWaypoints = true
  elseif command:match"^%s*missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	limitZone = true
	limitMissing = true
	addFindersWaypoints = true
	addRichiesWaypoints = true
  elseif command:match"^%s*all%s*$" then -- markers in all maps, but including already found items
	addFindersWaypoints = true
	addRichiesWaypoints = true
  elseif command:match"^%s*missing%s*$" then -- markers in all maps, but excluding already found items
	limitMissing = true
	addFindersWaypoints = true
	addRichiesWaypoints = true
  elseif command:match"^%s*all%s+missing%s*$" then
	limitMissing = true
	addFindersWaypoints = true
	limitMissing = true
   elseif command:match"^%s*clear%s*$" then
    --self:Print('clearing all waypoints')
	clearWaypoints = true
  -- tracker only for the Finders Keepers Achievement
  elseif command:match"^%s*finders%s+all%s+zone%s*$" then -- markers only in the current zone, but including already found items
	--self:Print('finders all zone')
	limitZone = true
	addFindersWaypoints = true
  elseif command:match"^%s*finders%s+missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	--self:Print('finders missing zone')
	limitZone = true
	limitMissing = true
	addFindersWaypoints = true
  elseif command:match"^%s*finders%s+all%s*$" then -- markers in all maps, but including already found items
	---self:Print('finders all')
	addFindersWaypoints = true
  elseif command:match"^%s*finders%s+all%s+missing%s*$" then -- markers in all maps, but excluding already found items
	--self:Print('finders all missing')
	limitMissing = true
	addFindersWaypoints = true
  -- tracker only for the Richies of Pandaria Achievement
  elseif command:match"^%s*richies%s+all%s+zone%s*$" then -- markers only in the current zone, but including already found items
	--self:Print('richies all zone')
	limitZone = true
	addRichiesWaypoints = true
  elseif command:match"^%s*richies%s+missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	--self:Print('richies missing zone')
	limitZone = true
	limitMissing = true
	addRichiesWaypoints = true
  elseif command:match"^%s*richies%s+all%s*$" then -- markers in all maps, but including already found items
	--self:Print('richies all')
	addRichiesWaypoints = true
  elseif command:match"^%s*richies%s+all%s+missing%s*$" then -- markers in all maps, but excluding already found items
	--self:Print('richies all')
	addRichiesWaypoints = true
	limitMissing = true
  else
    FindersAndRichiesHelper:PrintUsage()
  end

  --store actual configuration
  self.settings.global.addFindersWaypoints = addFindersWaypoints
  self.settings.global.addRichiesWaypoints = addRichiesWaypoints
  self.settings.global.limitZone = limitZone
  self.settings.global.limitMissing = limitMissing
  
  FindersAndRichiesHelper:ProcessOptions();
  
end

function FindersAndRichiesHelper:SetAchievementWaypoints(limitZone, limitMissing, achievementCriteriaSet)
	local doAdd
	local zoneName = GetZoneText()
	
	--self:Print("set finders keepers waypoints : limitZone = " .. limitZone .. " limitMissing=" .. limitMissing)
	for k, a in pairs(achievementCriteriaSet) do
		if limitZone and zoneName == GetMapNameByID(a.map) then
			FindersAndRichiesHelper:ProcessAchievementCriteria(a, limitMissing)
		elseif limitZone == false then
			FindersAndRichiesHelper:ProcessAchievementCriteria(a, limitMissing)
		end
	end
end

function FindersAndRichiesHelper:ProcessAchievementCriteria(criteria, limitMissing)
	if limitMissing then -- if limit missing then dont add waypoints for already found treaasures
		if(IsQuestFlaggedCompleted(criteria.qid)) then -- have to do this way because nil is not false
			-- self:Print("adding waypoint to " .. criteria.desc .. " failed because you have already found it")
			-- nop
		else
			if (criteria.npc ~= nil) then
				FindersAndRichiesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, criteria.desc .. '\n|cffffff00Npc: |cffffa500' .. criteria.npc.name)
				FindersAndRichiesHelper:AddNpc(criteria.npc.id, criteria.map, criteria.npc.name)
			else
				FindersAndRichiesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, criteria.desc)
			end
			--check if npc
		end
	else
		if(IsQuestFlaggedCompleted(criteria.qid)) then
			if (criteria.npc ~= nil) then
				FindersAndRichiesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, criteria.desc .. '\n|cffffff00Npc: |cffffa500' .. criteria.npc.name .. '|cffff1111(Already found)')
				FindersAndRichiesHelper:AddNpc(criteria.npc.id, criteria.map, criteria.npc.name)
			else
				FindersAndRichiesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, criteria.desc)
			end
			--check if npc
		else
			if (criteria.npc ~= nil) then
				FindersAndRichiesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, criteria.desc .. '\n|cffffff00Npc: |cffffa500' .. criteria.npc.name)
				FindersAndRichiesHelper:AddNpc(criteria.npc.id, criteria.map, criteria.npc.name)
			else
				FindersAndRichiesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, criteria.desc)
			end
			--check if npc
		end
	end
end

--adds a Npc in NPCScan case it is installed
function FindersAndRichiesHelper:AddNpc(npcId, map, npcName)
	if _NPCScan and _NPCScan.NPCAdd then
		--self:Print('adding npc ' .. npcName .. ' id ' .. npcId)
		_NPCScan.NPCAdd(npcId, npcName, GetMapNameByID(map))
	else
		-- cant add npc name because npc scan isn't installed
		--nop
		--self:Print('Can\'t add npc ' .. npcName .. ' because NPCScan is not installed')
	end
	currentTrackedNpcs[table.getn(currentTrackedNpcs)+1] = npcId
end

--removes all current tracked achievement npcs
function FindersAndRichiesHelper:ClearNpcs()
	--self:Print("removing " .. table.getn(currentTrackedNpcs) .. " npcs ")
	for k, npcId in pairs(currentTrackedNpcs) do
		if _NPCScan and _NPCScan.NPCAdd then
			_NPCScan.NPCRemove(npcId)
		end
	end
	currentTrackedNpcs = {}
end


--adds a waypoint in TomTom case it is installed
function FindersAndRichiesHelper:AddWaypoint(map, floorNum, x, y, title)
  local s
  if TomTom and TomTom.AddMFWaypoint then
    wayPointId = TomTom:AddMFWaypoint(map, floorNum or nil, x, y, {title = title})
  elseif TomTomLite and TomTomLite.AddWaypoint then
    wayPointId = TomTomLite.AddWaypoint(map, floorNum or nil, x, y, {title = title})
  else
    s = GetMapNameByID(map)
    -- show floor?
    s = s .. " (" .. x*100 .. ", " .. y*100 .. "): " .. title
    self:Print(s)
  end
  currentWayPoints[table.getn(currentWayPoints)+1] = wayPointId
  --self:Print("added " .. table.getn(currentWayPoints) .. " waypoints ")
end

--removes all currently tracked waypoints
function FindersAndRichiesHelper:ClearWaypoints()
	--self:Print("removing " .. table.getn(currentWayPoints) .. " waypoints ")
	for k, wayPoint in pairs(currentWayPoints) do
		if TomTom and TomTom.RemoveWaypoint then
			TomTom:RemoveWaypoint(wayPoint)
		elseif TomTomLite and TomTomLite.RemoveWaypoint then
			TomTomLite.RemoveWaypoint(wayPoint)
		end
	end
	currentWayPoints = {};
end



function FindersAndRichiesHelper:OnEnable()
  --FindersAndRichiesHelper:Print("processing options " .. tostring(self.settings.global.limitZone) .. "," .. tostring(self.settings.global.limitMissing) .. "," .. tostring(self.settings.global.addFindersWaypoints) .. "," .. tostring(self.settings.global.addRichiesWaypoints) )
  FindersAndRichiesHelper:ProcessOptions()
end

function FindersAndRichiesHelper:OnDisable()
  FindersAndRichiesHelper:ClearWaypoints()
  FindersAndRichiesHelper:ClearNcps()
  if updaterFrame then
    updaterFrame:Hide()
    updaterFrame:SetParent(nil)
    updaterFrame = nil
  end
end
-- LDB


function FindersAndRichiesHelper:InterfaceOptions()
	local texSize = 20
	local canBeTank, canBeHealer, canBeDamager = UnitGetAvailableRoles("player")
	local greyTint = {155, 155, 155}
	--TODO list of all gotten/missing treasures
	return {
		name = addonName,
		type = "group",
		--get = function(info) return self.settings.global[] end,
		--set = function(info, val) self.settings.global[info[#info]] = val end,
		args = {
			findersKeepersOptions = {
				icon = "Interface\\Icons\\achievement_faction_lorewalkers",
				name = "Finders Keepers",
				type = "group",
				inline = true,
				order = 1,
				args = {
					enable = {
						name = "Enable\n",
						type = "toggle",
						desc = "Enable/Disable tracking for Finders Keepers",
						get = function(info) return self.settings.global.addFindersWaypoints end,
						set = function(info, val) self.settings.global.addFindersWaypoints = val; FindersAndRichiesHelper:ProcessOptions() end,
						order = 0
					}
				}
			},
			richiesOfPandaria = {
				icon = "Interface\\Icons\\achievement_faction_lorewalkers",
				name = "Richies of Pandaria",
				type = "group",
				inline = true,
				order = 2,
				args = {
					enable = {
						name = "Enable", 
						type = "toggle",
						desc = "Enable/Disable tracking for Richies of Pandaria",
						get = function(info) return self.settings.global.addRichiesWaypoints end,
						set = function(info, val) self.settings.global.addRichiesWaypoints = val; FindersAndRichiesHelper:ProcessOptions() end,
						order = 0
					}
				}
			},
			trackingOptions = {
				name = "Tracking Options",
				type = "group",
				order = 3,
				inline = true,
				args = {
					zone = {
						name = "Zone Limitation",
						type = "select",
						values = {"Zone Only", "All Zones"},
						desc = "Tracks only waypoints for the current zone",
						get = function(info) if self.settings.global.limitZone then return 1 else return 2 end end,
						set = function(info, val) if val == 1 then self.settings.global.limitZone = true else self.settings.global.limitZone = false end FindersAndRichiesHelper:ProcessOptions() end,
						order = 1,
					},
					missing = {
						name = "Tracked Treasures",
						type = "select",
						values = {"Missing Only", "All Treasues"},
						desc = "Tracks only missing treasures",
						get = function(info) if self.settings.global.limitMissing then return 1; else return 2 end end,
						set = function(info, val) if val == 1 then self.settings.global.limitMissing = true else self.settings.global.limitMissing = false end FindersAndRichiesHelper:ProcessOptions() end,
						order = 2,
					}
				}
			}
		}
	}
end



--[[ old function
function FindersAndRichiesHelper:SetRichiesOfPandariaWaypoints(limitZone, limitMissing)
	local doAdd
	local zoneName = GetZoneText()
	
	for k, a in pairs(richiesOfPandaria) do
		if limitZone and zoneName == GetMapNameByID(a.map) then
			if limitMissing then
				if(IsQuestFlaggedCompleted(a.qid)) then
					self:Print("adding waypoint to " .. a.desc .. " failed because you have already found it")
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			else
				if(IsQuestFlaggedCompleted(a.qid)) then
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc .. ' (Already found)')
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			end
		else
			if limitMissing then
				if(IsQuestFlaggedCompleted(a.qid)) then
					self:Print("adding waypoint to " .. a.desc .. " failed because you have already found it")
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			else
				if( not IsQuestFlaggedCompleted(a.qid)) then
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc .. ' (Already found)')
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			end
		end
	end
end
]]--
