local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

 -- internationalization code 
 -- = LibStub("AceLocale-3.0"):GetLocale("FindersAndRichesHelper", not debug)

--
local L

--local Astrolabe = DongleStub("Astrolabe-1.0")

FindersAndRichesHelper = LibStub("AceAddon-3.0"):NewAddon("FindersAndRichesHelper", "AceConsole-3.0")

local addonName = "Finders And Riches Helper (frh)"



local defaultSettings = {
  global = {
	-- verify which variables need to be stored to previous use
	limitZone = true,
	limitMissing = true,
	addFindersWaypoints = true,
	addRichesWaypoints = true,
	showMinimapIcon = true
  }
}

local updaterFrame = nil
local minimapIcon = nil

-- TODO use the floor param to mark the correct position of indor items
-- riches of pandaria locations according wowhead (12/03/12)						 
local richesOfPandaria	={ --Jade Forest items
						 {map=806, qid = 31400 , desc = 'Ancient Pandaren Tea Pot', positions = {{ x=26.22 , y=32.35}}},
						 {map=806, qid = 31401 , desc = 'Lucky Pandaren Coin', positions = {{ x=31.96  , y=27.75}}},
						 {map=806, qid = 31404 , desc = 'Pandaren Ritual Stone', positions = {{ x=23.49 , y=35.05}}},
						 {map=806, qid = 31396 , desc = 'Ship\'s Locker', extraNote='Inside the lower deck of the sunken boat', positions = {{ x=51.22 , y=100.00}}},
						  --Valley of the Four Winds items
						 {map=807, qid = 31405 , desc = 'Virmen Treasure Cache', submapEntrance={note='Cave entrance', positions = {{x=23.19, y=30.75}}, map=807}, positions = {{ x=23.71 , y=28.33}}},
						 {map=807, qid = 31408 , desc = 'Saurok Stone Tablet', submapEntrance={note='Cave entrance', positions = {{x=71, y=9}}, map=857}, positions = {{ x=75.1 , y=55.1}}},
						  -- The Veiled Stair Items
						 {map=873, qid = 31428 , desc = 'The Hammer of Folly', positions = {{ x=74.93 , y=76.48}}},
						  -- Kun-Lai Summit
						 {map=809, qid = 31420 , desc = 'Ancient Mogu Tablet', submapEntrance={note='Path of Conquerors entrance', positions = {{x=63.94, y=49.84}}, map=809}, positions = {{ x=63.94 , y=49.84}}},
						 {map=809, qid = 31414 , desc = 'Hozen Treasure Cache', submapEntrance={note='Cave entrance', positions = {{x=0, y=0}}, map=809}, positions = {{ x=50.36 , y=61.77}}},
						 {map=809, qid = 31418 , desc = 'Lost Adventurer\'s Belongings', positions = {{ x=36.70 , y=79.70}}},
						 {map=809, qid = 31419 , desc = 'Rikktik\'s Tiny Chest', positions = {{ x=52.57 , y=51.54}}},
						 {map=809, qid = 31416 , desc = 'Statue of Xuen', positions = {{ x=72.01 , y=33.96}}},
						 {map=809, qid = 31415 , desc = 'Stolen Sprite Treasure', submapEntrance={note='Cave entrance', positions = {{x=59.5, y=52.9}}, map=809}, positions = {{ x=41.67 , y=44.12}}},
						 {map=809, qid = 31422 , desc = 'Terracotta Head', positions = {{ x=59.24 , y=73.03}}},
						  -- Townlong Steppes
						 {map=810, qid = 31427 , desc = 'Abandoned Crate of Goods', positions = {{ x=62.82 , y=34.05}}},
						 {map=810, qid = 31426 , desc = 'Amber Encased Moth', positions = {{ x=65.83 , y=86.08}}},
						 --todo check the locations of this item
						 {map=810, qid = 31423 , desc = 'Fragment of Dread', submapEntrance={note='Catacombs entrance', positions = {{x=32.6, y=61.8}}, map=810}, positions = {{ x=33.81 , y=61.80}}},
						 {map=810, qid = 31424 , desc = 'Hardened Sap of Kri\'vess', extraNote='Various spawn points arround the Kri\'vess Tree', positions = {{ x=52.84 , y=56.17}}},
						 }

-- finders keepers locations according wowhead (12/03/12)
local findersKeepers	={ --Jade Forest items
						 {map=806, qid = 31402 , desc = 'Ancient Jinyu Staff', positions = {{ x=47.10 , y=67.40}, { x=46.20 , y=71.20}, { x=44.90 , y=64.60}}},
						 {map=806, qid = 31399 , desc = 'Ancient Pandaren Mining Pick',  extraNote='Inside Greenstone Quarry', submapEntrance={note='Greenstone Quarry entrance and first spot', positions = {{x=46.1, y=29.1}}, map=806}, positions = {{ x=46.10 , y=29.10} , { x=44.10 , y=27.00}, {x=43.80 , y=30.70}}},
						 {map=806, qid = 31403 , desc = 'Hammer of Ten Thunders', positions = {{ x=41.80 , y=17.60}, { x=43.00 , y=11.60}}},
						 {map=806, qid = 31307 , desc = 'Jade Infused Blade', positions = {{ x=39.26 , y=46.65}}, npc = {id='64272', name='Jade Warrior Statue'}}, -- npc scan id 64272 Jade Warrior Statue
						 {map=806, qid = 31397 , desc = 'Wodin\'s Mantid Shanker', positions = {{ x=39.00 , y=7.00}}},
						  --Valley of the Four Winds items
						 {map=807, qid = 31284 , desc = 'Ancient Pandaren Fishing Charm', positions = {{ x=45.40 , y=38.20}}, npc = {id=64004, name='Ghostly Pandaren Fisherman'}}, -- npc scan id 64004 Ghostly Pandaren Fisherman
						 {map=807, qid = 31292 , desc = 'Ancient Pandaren Woodcutter', positions = {{ x=45.40 , y=38.20}}, npc = {id=64191, name='Ghostly Pandaren Craftsman'}}, -- npc scan id 64191 Ghostly Pandaren Craftsman
						 {map=807, qid = 31406 , desc = 'Cache of Pilfered Goods', submapEntrance={note='Cave entrance', positions = {{x=43,y=35}}, map=807}, positions = {{ x=43.50 , y=37.40}}},
						 {map=807, qid = 31407 , desc = 'Staff of the Hidden Master', positions = {{ x=15.40 , y=29.10}, { x=17.50 , y=35.70}, { x=19.10 , y=37.90}, { x=15.00 , y=33.70}, { x=19.00 , y=42.50}}},
						  -- Krasarang Wilds
						 {map=857, qid = 31410 , desc = 'Equipment Locker', extraNote='On the lowest deck of the ship', positions = {{ x=42.00 , y=91.00}}},
						 {map=857, qid = 31409 , desc = 'Pandaren Fishing Spear', positions = {{ x=50.80 , y=49.30}}},
						 {map=857, qid = 31411 , desc = 'Recipe: Banana Infused Rum', extraNote='Search for a Barrel of Banana Infused Rum', positions = {{ x=52.30 , y=88.00}}},
						  -- Kun-Lai Summit
						 {map=809, qid = 31413 , desc = 'Hozen Warrior Spear', submapEntrance={note='The Deeper entrance', positions = {{x=52.8, y=71.3}}, map=809}, positions = {{ x=52.80 , y=71.30}}},
						 {map=809, qid = 31304 , desc = 'Kafa Press', submapEntrance={note='Cave entrance', positions = {{x=35.19, y=76.35}}, map=809}, positions = {{ x=37.37 , y=77.84}}, npc={id=64227, name='Frozen Trail Packer'}},
						 {map=809, qid = 31412 , desc = 'Sprite\'s Cloth Chest', submapEntrance={note='Prankster\'s Hollow entrance', positions = {{x=73.0, y=73.5}}, map=809},  positions = {{ x=74.70 , y=74.90}}},
						 {map=809, qid = 31421 , desc = 'Sturdy Yaungol Spear', positions = {{ x=71.20 , y=62.60}, { x=70.00 , y=63.80}}},
						 {map=809, qid = 31417 , desc = 'Tablet of Ren Yun', positions = {{ x=44.7 , y=52.4}}},
						  -- Townlong Steppes
						 {map=810, qid = 31425 , desc = 'Yaungol Fire Carrier', positions = {{ x=66.30 , y=44.70}}},
						 {map=810, qid = 31425 , desc = 'Yaungol Fire Carrier', positions = {{ x=66.80 , y=48.00}}},
						  -- Dread Wastes
						 {map=858, qid = 31438 , desc = 'Blade of the Poisoned Mind', positions = {{ x=28.00 , y=42.00}}},
						 {map=858, qid = 31433 , desc = 'Blade of the Prime', submapEntrance={note='Cave entrance', positions = {{x=66.7, y=63.7}}, map=858}, positions = {{ x=25.70 , y=54.40}}},
						 {map=858, qid = 31436 , desc = 'Bloodsoaked Chitin Fragment', submapEntrance={note='Cave entrance', positions = {{x=25.7, y=54.4}}, map=858}, positions = {{ x=25.70 , y=54.40}}},
						 {map=858, qid = 31435 , desc = 'Dissector\'s Staff of Mutation', positions = {{ x=30.20 , y=90.80}}},
						 {map=858, qid = 31431 , desc = 'Lucid Amulet of the Agile Mind', positions = {{ x=32.00 , y=30.00}}},
						 {map=858, qid = 31430 , desc = 'Malik\'s Stalwart Spear', positions = {{ x=48.00 , y=30.00}}},
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 1', positions = {{ x=42.00 , y=62.20}, { x=42.20 , y=63.60}, { x=41.60 , y=64.60} }, npc = {id='65552', name='Glinting Rapana Whelk'}}, -- npc scan id 65552 Glinting Rapana Whelk
						 {map=858, qid = 31434 , desc = 'Swarming Cleaver of Ka\'roz', extraNote='At the bottom of the sea', positions = {{ x=56.80 , y=77.60}}},
						 {map=858, qid = 31437 , desc = 'Swarmkeeper\'s Medallion', positions = {{ x=54.2, y=56.4}}},
						 {map=858, qid = 31666 , desc = 'Wind-Reaver\'s Dagger of Quick Strikes', positions = {{ x=71.80 , y=36.10}}},
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
	FindersAndRichesHelper:Print('event fired ' .. event)
	if (event == "ZONE_CHANGED_NEW_AREA") then
		if FindersAndRichesHelper.settings.global.limitZone then -- remove the waypoints from previous area and add for the new one
			--FindersAndRichesHelper:Print('clear npcs and waypoints')
			FindersAndRichesHelper:ProcessOptions()
			--FindersAndRichesHelper:ClearWaypoints()
			--FindersAndRichesHelper:ClearNpcs()
			--if FindersAndRichesHelper.settings.global.addFindersWaypoints then
				--FindersAndRichesHelper:Print('processing waypoints to Finders')
				--FindersAndRichesHelper:SetAchievementWaypoints(FindersAndRichesHelper.settings.global.limitZone, FindersAndRichesHelper.settings.global.limitMissing, richesOfPandaria)
			--end
			--if FindersAndRichesHelper.settings.global.addRichesWaypoints then 
				--FindersAndRichesHelper:Print('processing waypoints to Riches')
				--FindersAndRichesHelper:SetAchievementWaypoints(FindersAndRichesHelper.settings.global.limitZone, FindersAndRichesHelper.settings.global.limitMissing, findersKeepers)
			--end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then -- reload the configurations from previous sessions
		FindersAndRichesHelper:ProcessOptions()
	elseif event == "PLAYER_LEAVING_WORLD" then -- remove waypoints from tomtom
		FindersAndRichesHelper:ClearWaypoints();
		FindersAndRichesHelper:ClearNpcs();
	end
	--QUEST_WATCH_UPDATE
	--PLAYER_LEAVING_WORLD
	
end


--mini

 
 menuFrame = nil
 
 function FindersAndRichesHelper:OnInitialize()
	-- Called when the addon is loaded
	self:RegisterChatCommand("findersandricheshelper", "SlashCommand")
	self:RegisterChatCommand("frh", "SlashCommand")

	self.settings = LibStub("AceDB-3.0"):New("FRH_Settings", defaultSettings)
  
	if updaterFrame == nil then
		--updaterFrame = CreateFrame("frame")
		--InterfaceOptions_AddCategory(updaterFrame)
		local AceConfig = LibStub("AceConfig-3.0")
		AceConfig:RegisterOptionsTable("Finders And Riches Helper (frh)", function () return self:InterfaceOptions() end)
		updaterFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Finders And Riches Helper (frh)")
		updaterFrame.default = function() self:SetDefaultOptions() end
		updaterFrame:SetScript("OnEvent", eventHandler)
		--updaterFrame:SetScript("OnUpdate", updateHandler)
		updaterFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		updaterFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		updaterFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
		updaterFrame:Show()
		
		
		local findersandRichesHelperLDB = LibStub("LibDataBroker-1.1"):NewDataObject("frh_ldb", {
																								type = "data source",
																								text = "Finders and Riches Helper",
																								icon = "Interface\\Icons\\INV_Chest_Cloth_17",
																								OnClick =	function(clickedframe, button) 
																												if button == "LeftButton" then
																													FindersAndRichesHelper:MinimapButtonOptions(clickedframe)
																												end
																											 end,
																								})
		minimapIcon = LibStub("LibDBIcon-1.0")
		minimapIcon:Register("FRH_ldbIcon", findersandRichesHelperLDB, self.settings.showMinimapIcon)
		
		

		-- Make the menu appear at the cursor: 
		--EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
		-- Or make the menu appear at the frame:
		
	
	end
end

function FindersAndRichesHelper:SetDefaultOptions() 
  self.settings.global.limitMissing = true
  self.settings.global.limitZone = true
  self.settings.global.addFindersWaypoints = true
  self.settings.global.addRichesWaypoints = true
  FindersAndRichesHelper:ProcessOptions()
end

function FindersAndRichesHelper:ProcessOptions()
  FindersAndRichesHelper:ClearNpcs();
  FindersAndRichesHelper:ClearWaypoints();
  if self.settings.global.addFindersWaypoints then
	--self:Print('processing waypoints to Finders')
	FindersAndRichesHelper:SetAchievementWaypoints(self.settings.global.limitZone, self.settings.global.limitMissing, findersKeepers)
  end
  if self.settings.global.addRichesWaypoints then
	--self:Print('processing waypoints to Riches')
	FindersAndRichesHelper:SetAchievementWaypoints(self.settings.global.limitZone, self.settings.global.limitMissing, richesOfPandaria)
  end
  if self.settings.global.addFindersWaypoints or self.settings.global.addRichesWaypoints then
	TomTom:SetClosestWaypoint()
  end
end

function FindersAndRichesHelper:PrintUsage()
  local s

  s = "\n"
  s = s .. "|cff7777ff/FindersAndRichesHelper ...|r\n"
  s = s .. "|cff7777ff/use the commands without the riches or finders key words to track/clear both achievement critaria...|r\n"
  s = s .. "|cff7777ff/frh (riches|finders) all zone|r " .. "add waypoints to all items in current zone, including already found ones" .. "\n"
  s = s .. "|cff7777ff/frh (riches|finders) missing zone|r " .. "add waypoints to all items in current zone, excluding alrady found ones" .. "\n"
  s = s .. "|cff7777ff/frh (riches|finders) all|r " .. "add waypoints to all items in all maps, including already found ones" .. "\n"
  s = s .. "|cff7777ff/frh (riches|finders) all missing|r " .. "add waypoints to all items in all maps, excluding already found ones" .. "\n"
  s = s .. "|cff7777ff/frh clear|r " .. "clear all waypoints to the tracked achievements" .. "\n"
  s = s .. "|cff7777ff/frh debug|r " .. "esable/disable debug mode"
  

  self:Print(s)
end

function FindersAndRichesHelper:SlashCommand(command)
  local limitZone, limitMissing, distance
  
  
  addFindersWaypoints = false
  addRichesWaypoints = false
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
	addRichesWaypoints = true
  elseif command:match"^%s*missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	limitZone = true
	limitMissing = true
	addFindersWaypoints = true
	addRichesWaypoints = true
  elseif command:match"^%s*all%s*$" then -- markers in all maps, but including already found items
	addFindersWaypoints = true
	addRichesWaypoints = true
  elseif command:match"^%s*missing%s*$" then -- markers in all maps, but excluding already found items
	limitMissing = true
	addFindersWaypoints = true
	addRichesWaypoints = true
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
  -- tracker only for the Riches of Pandaria Achievement
  elseif command:match"^%s*riches%s+all%s+zone%s*$" then -- markers only in the current zone, but including already found items
	--self:Print('riches all zone')
	limitZone = true
	addRichesWaypoints = true
  elseif command:match"^%s*riches%s+missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	--self:Print('riches missing zone')
	limitZone = true
	limitMissing = true
	addRichesWaypoints = true
  elseif command:match"^%s*riches%s+all%s*$" then -- markers in all maps, but including already found items
	--self:Print('riches all')
	addRichesWaypoints = true
  elseif command:match"^%s*riches%s+all%s+missing%s*$" then -- markers in all maps, but excluding already found items
	--self:Print('riches all')
	addRichesWaypoints = true
	limitMissing = true
  else
    FindersAndRichesHelper:PrintUsage()
  end

  --store actual configuration
  self.settings.global.addFindersWaypoints = addFindersWaypoints
  self.settings.global.addRichesWaypoints = addRichesWaypoints
  self.settings.global.limitZone = limitZone
  self.settings.global.limitMissing = limitMissing
  
  FindersAndRichesHelper:ProcessOptions();
  
end

function FindersAndRichesHelper:SetAchievementWaypoints(limitZone, limitMissing, achievementCriteriaSet)
	local zoneName = GetZoneText()
	
	
	for k, a in pairs(achievementCriteriaSet) do
		--self:Print("set waypoint to " .. a.desc)
	--	if a.submapEntrance ~= nil then
		--	 self:Print("set submap entrance in map" .. a.submapEntrance.map)
	--	end
		if limitZone and zoneName == GetMapNameByID(a.map) or (a.submapEntrance ~= nil and zoneName == GetMapNameByID(a.submapEntrance.map) ) then
		
			FindersAndRichesHelper:ProcessAchievementCriteria(a, limitMissing)
		elseif limitZone == false then
			FindersAndRichesHelper:ProcessAchievementCriteria(a, limitMissing)
		end
	end
end

function FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, isSubmap)
	description = criteria.desc
	if isSubmap then
		description = description .. '\n|cffffffff' .. criteria.submapEntrance.note
	else
		if IsQuestFlaggedCompleted(criteria.qid) then
			description = description .. '|cffff1111(Already found)'
		end
		if criteria.extraNote ~= nil then
			description = description .. '\n|cffffffff' .. criteria.extraNote
		end
		if criteria.npc ~= nil then
			description = description .. '\n|cffffffffHave to interact with |cffffff00Npc: |cffffa500' .. criteria.npc.name
		end
	end
	return description
end

-- process the given achievement criteria, adding waypoints 
function FindersAndRichesHelper:ProcessAchievementCriteria(criteria, limitMissing)
	if limitMissing then -- if limit missing then dont add waypoints for already found treaasures
		if(IsQuestFlaggedCompleted(criteria.qid)) then -- have to do this way because nil is not false
			-- self:Print("adding waypoint to " .. criteria.desc .. " failed because you have already found it")
			-- nop
		else
			if (criteria.submapEntrance ~= nil) then
				FindersAndRichesHelper:AddWaypoint(criteria.submapEntrance.map, criteria.submapEntrance.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, true), criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
			elseif (criteria.npc ~= nil) then
				FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
				FindersAndRichesHelper:AddNpc(criteria.npc.id, criteria.map, criteria.npc.name)
			else
				FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
			end
		end
	else
		if(IsQuestFlaggedCompleted(criteria.qid)) then
			if (criteria.submapEntrance ~= nil) then
				FindersAndRichesHelper:AddWaypoint(criteria.submapEntrance.map, criteria.submapEntrance.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, true), criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
			elseif (criteria.npc ~= nil) then
				FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
				FindersAndRichesHelper:AddNpc(criteria.npc.id, criteria.map, criteria.npc.name)
			else
				FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
			end
		else
			if (criteria.submapEntrance ~= nil) then
				FindersAndRichesHelper:AddWaypoint(criteria.submapEntrance.map, criteria.submapEntrance.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, true), criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
				--FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.pos.f or nil, criteria.pos.x / 100, criteria.pos.y / 100, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, true))
			elseif (criteria.npc ~= nil) then
				FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
				FindersAndRichesHelper:AddNpc(criteria.npc.id, criteria.map, criteria.npc.name)
			else
				FindersAndRichesHelper:AddWaypoint(criteria.map, criteria.positions, FindersAndRichesHelper:GetAchievementCriteriaDescription(criteria, false))
			end
		end
	end
end

--adds a Npc in NPCScan case it is installed
function FindersAndRichesHelper:AddNpc(npcId, map, npcName)
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
function FindersAndRichesHelper:ClearNpcs()
	--self:Print("removing " .. table.getn(currentTrackedNpcs) .. " npcs ")
	for k, npcId in pairs(currentTrackedNpcs) do
		if _NPCScan and _NPCScan.NPCAdd then
			_NPCScan.NPCRemove(npcId)
		end
	end
	currentTrackedNpcs = {}
end

local function waypointArrivalCallback(event, uid, range, distance, lastdistance)
	
	-- if a cave waypoint is hit, add new waypoints related to it
	--FindersAndRichesHelper:Print('cave entrance arrived ' .. uid.submapWaypoints ~= nil )
	if uid.private.submapWaypoints ~= nil then
		--FindersAndRichesHelper:Print('cave entrance arrived adding new waypoints ' .. table.getn(uid.submapWaypoints))
		FindersAndRichesHelper:AddWaypoint(uid.private.mapId, uid.private.submapWaypoints, uid.private.submapTitle)
	end
	TomTom:SetClosestWaypoint()
end

--adds a waypoint in TomTom case it is installed
function FindersAndRichesHelper:AddWaypoint(map, mainWaypoints, title, submapId, submapWaypoints, submapTitle)
  for k, pos in pairs (mainWaypoints) do
	  if TomTom and TomTom.AddMFWaypoint then
		wayPointId = TomTom:AddMFWaypoint(map, pos.floorNum or nil, pos.x/100, pos.y/100, {title = title} )
	  elseif TomTomLite and TomTomLite.AddWaypoint then
		wayPointId = TomTomLite.AddWaypoint(map, pos.floorNum or nil, pos.x/100, pos.y/100, {title = title})
	  else
		s = GetMapNameByID(map)
		-- show floor?
		s = s .. " (" .. pos.x*100 .. ", " .. pos.y*100 .. "): " .. title
		self:Print(s)
	  end
	  if wayPointId ~= nil then
		  wayPointId.callbacks.distance[wayPointId.arrivaldistance] = waypointArrivalCallback
		  currentWayPoints[table.getn(currentWayPoints)+1] = wayPointId
		  if submapId~=nil then
			  wayPointId.private = {}
			  wayPointId.private.submapWaypoints = submapWaypoints
			  wayPointId.private.mapId = submapId
			  wayPointId.private.submapTitle = submapTitle
		  end
	  end
  end
 
  --[[]]--
  --self:Print("added " .. table.getn(currentWayPoints) .. " waypoints ")
end



--removes all currently tracked waypoints
function FindersAndRichesHelper:ClearWaypoints()
	--self:Print("removing " .. table.getn(currentWayPoints) .. " waypoints ")
	for k, wayPoint in pairs(currentWayPoints) do
		if TomTom and TomTom.RemoveWaypoint then
			TomTom:RemoveWaypoint(wayPoint)
			--self:Print('removing waypoint waypoint to ' .. wayPoint.title)
		elseif TomTomLite and TomTomLite.RemoveWaypoint then
			TomTomLite.RemoveWaypoint(wayPoint)
		end
	end
	currentWayPoints = {};
end



function FindersAndRichesHelper:OnEnable()
  --FindersAndRichesHelper:Print("processing options " .. tostring(self.settings.global.limitZone) .. "," .. tostring(self.settings.global.limitMissing) .. "," .. tostring(self.settings.global.addFindersWaypoints) .. "," .. tostring(self.settings.global.addRichesWaypoints) )
  FindersAndRichesHelper:ProcessOptions()
end

function FindersAndRichesHelper:OnDisable()
  FindersAndRichesHelper:ClearWaypoints()
  FindersAndRichesHelper:ClearNcps()
  if updaterFrame then
    updaterFrame:Hide()
    updaterFrame:SetParent(nil)
    updaterFrame = nil
  end
end
-- LDB


function FindersAndRichesHelper:InterfaceOptions()
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
						set = function(info, val) self.settings.global.addFindersWaypoints = val; FindersAndRichesHelper:ProcessOptions() end,
						order = 0
					}
				}
			},
			richesOfPandaria = {
				icon = "Interface\\Icons\\achievement_faction_lorewalkers",
				name = "Riches of Pandaria",
				type = "group",
				inline = true,
				order = 2,
				args = {
					enable = {
						name = "Enable", 
						type = "toggle",
						desc = "Enable/Disable tracking for Riches of Pandaria",
						get = function(info) return self.settings.global.addRichesWaypoints end,
						set = function(info, val) self.settings.global.addRichesWaypoints = val; FindersAndRichesHelper:ProcessOptions() end,
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
						set = function(info, val) if val == 1 then self.settings.global.limitZone = true else self.settings.global.limitZone = false end FindersAndRichesHelper:ProcessOptions() end,
						order = 1,
					},
					missing = {
						name = "Tracked Treasures",
						type = "select",
						values = {"Missing Only", "All Treasues"},
						desc = "Tracks only missing treasures",
						get = function(info) if self.settings.global.limitMissing then return 1; else return 2 end end,
						set = function(info, val) if val == 1 then self.settings.global.limitMissing = true else self.settings.global.limitMissing = false end FindersAndRichesHelper:ProcessOptions() end,
						order = 2,
					}
				}
			},
			minimapIconOptions = {
				name = "Minimap Icon",
				type = "group",
				inline = true,
				order = 4,
				args = {
					enable = {
						name = "Enable", 
						type = "toggle",
						desc = "Enable/Disable minimap icon from FRH",
						get = function(info) return self.settings.global.showMinimapIcon end,
						set = function(info, val) self.settings.global.showMinimapIcon = val  if not val then minimapIcon:Hide("FRH_ldbIcon") else minimapIcon:Show("FRH_ldbIcon") end end,
						order = 0
					}
				}
			}
		}
	}
end

local FINDERS	_KEEPERS_INDEX=2
local RICHES_OF_PANDARIA_INDEX=3
local ZONE_LIMITATION_INDEX=4
local ZONE_LIMITATION_ZONE_ONLY_INDEX = 1
local ZONE_LIMITATION_ALL_ZONES_INDEX = 2
local TRACKED_TREASURES_INDEX=5
local TRACKED_TREASURES_MISSING_ONLY_INDEX=1 
local TRACKED_TREASURES_ALL_TREASURES_INDEX=2
local HIDE_MINIMAP_INDEX=6
local HIDE_MINIMAP_YES_INDEX=1
local HIDE_MINIMAP_NO_INDEX=2


-- ids used to refer the list internally
local ZONE_LIMITATION_ZONE_ONLY_ID = 1
local ZONE_LIMITATION_ALL_ZONES_ID = 2
local TRACKED_TREASURES_MISSING_ONLY_ID=3
local TRACKED_TREASURES_ALL_TREASURES_ID=4
local TRACKED_TREASURES_ALL_TREASURES_ID=5
local HIDE_MINIMAP_YES_ID=6
local HIDE_MINIMAP_NO_ID=7

local menu={{ text = "FRH Options", isTitle = true, notCheckable=true},
			{ text = "Finders Keepers", keepShownOnClick= true, func = 	function(self, arg1, arg2, checked) 
																			FindersAndRichesHelper.settings.global.addFindersWaypoints = checked
																			FindersAndRichesHelper:ProcessOptions()
																		end 
			},
			{ text = "Riches of Pandaria", keepShownOnClick= true, func = 	function(self, arg1, arg2, checked) 
																				FindersAndRichesHelper.settings.global.addRichesWaypoints = checked
																				FindersAndRichesHelper:ProcessOptions()
																			end 
			},
			{ text = "Zone Limitation", notCheckable=true, keepShownOnClick= true, hasArrow = true,
				menuList = {
					{ text = "Zone Only", keepShownOnClick= true, value= ZONE_LIMITATION_ZONE_ONLY_ID, func = function(self, arg1, arg2, checked) 
																			
																			--print ('selecting value zone only' )
																			
																			if(not FindersAndRichesHelper.settings.global.limitZone) then -- in this case 11 is selected
																				print ('selecting value zone only 1' )
																				FindersAndRichesHelper.settings.global.limitZone = true
																				
																				UIDropDownMenu_SetSelectedValue(menuFrame, ZONE_LIMITATION_ALL_ZONES_ID)
																				UIDropDownMenu_SetSelectedValue(menuFrame, ZONE_LIMITATION_ZONE_ONLY_ID) --doesn't make any sence: the reverse order doesn't work
																				
																				
																				FindersAndRichesHelper:ProcessOptions()
																			else -- dont update in case it is already selected
																				print ('selecting value zone only 2' )
																				UIDropDownMenu_SetSelectedValue(menuFrame, ZONE_LIMITATION_ZONE_ONLY_ID)
																			end
																			
																			
																		 end 
					},
					{ text = "All Zones", keepShownOnClick= true, value= ZONE_LIMITATION_ALL_ZONES_ID, func = function(self, arg1, arg2, checked) 
																			
																			
																			if(FindersAndRichesHelper.settings.global.limitZone) then -- in this case 11 is selected
																				print ('selecting value all zones 1' )
																				FindersAndRichesHelper.settings.global.limitZone = false
																				UIDropDownMenu_SetSelectedValue(menuFrame, ZONE_LIMITATION_ZONE_ONLY_ID)
																				UIDropDownMenu_SetSelectedValue(menuFrame, ZONE_LIMITATION_ALL_ZONES_ID)
																				FindersAndRichesHelper:ProcessOptions()
																			elseif(not FindersAndRichesHelper.settings.global.limitZone) then -- dont update in case it is already selected
																				print ('selecting value all zones 2' )
																				UIDropDownMenu_SetSelectedValue(menuFrame, ZONE_LIMITATION_ALL_ZONES_ID)
																			end
																			
																		 end 
					}
				}
			},
			{text = "Tracked Treasures", notCheckable=true, keepShownOnClick= true, hasArrow = true,
				menuList = {
					{ text = "Missing Only", keepShownOnClick= true, value=TRACKED_TREASURES_MISSING_ONLY_ID, func = function(self, arg1, arg2, checked)
																				if(not FindersAndRichesHelper.settings.global.limitMissing) then -- in this case 11 is selected
																			
																					FindersAndRichesHelper.settings.global.limitMissing = true
																					
																					UIDropDownMenu_SetSelectedValue(menuFrame, TRACKED_TREASURES_ALL_TREASURES_ID)
																					UIDropDownMenu_SetSelectedValue(menuFrame, TRACKED_TREASURES_MISSING_ONLY_ID)
																					
																					FindersAndRichesHelper:ProcessOptions()
																				elseif(FindersAndRichesHelper.settings.global.limitMissing) then -- dont update in case it is already selected
																					UIDropDownMenu_SetSelectedValue(menuFrame, TRACKED_TREASURES_MISSING_ONLY_ID)
																				end
																				 
																				
																			end 
					},
					{ text = "All Treasures", keepShownOnClick= true, value=TRACKED_TREASURES_ALL_TREASURES_ID, func = function(self, arg1, arg2, checked) 
																				if(FindersAndRichesHelper.settings.global.limitMissing) then -- in this case 11 is selected
																			
																					FindersAndRichesHelper.settings.global.limitMissing = false
																					
																					UIDropDownMenu_SetSelectedValue(menuFrame, TRACKED_TREASURES_MISSING_ONLY_ID)
																					UIDropDownMenu_SetSelectedValue(menuFrame, TRACKED_TREASURES_ALL_TREASURES_ID)
																					FindersAndRichesHelper:ProcessOptions()
																				elseif(not FindersAndRichesHelper.settings.global.limitMissing) then -- dont update in case it is already selected
																					UIDropDownMenu_SetSelectedValue(menuFrame, TRACKED_TREASURES_ALL_TREASURES_ID)
																				end
																			 end
					}
				}
			},
			{text="Hide Minimap Icon", notCheckable=true, keepShownOnClick= true, hasArrow = true, menuList = {
					{ text = "Yes", value=HIDE_MINIMAP_YES_ID, func = function(self, arg1, arg2, checked)
																		if(not FindersAndRichesHelper.settings.global.showMinimapIcon) then -- in this case 11 is selected
																			FindersAndRichesHelper.settings.global.showMinimapIcon = true
																			UIDropDownMenu_SetSelectedValue(menuFrame, HIDE_MINIMAP_NO_ID)
																			UIDropDownMenu_SetSelectedValue(menuFrame, HIDE_MINIMAP_YES_ID)
																			minimapIcon:Hide("FRH_ldbIcon")
																		else -- dont update in case it is already selected
																			UIDropDownMenu_SetSelectedValue(menuFrame, HIDE_MINIMAP_YES_ID)
																		end
																	  end 
					},
					{ text = "No", keepShownOnClick= true, value=HIDE_MINIMAP_NO_ID, func = function(self, arg1, arg2, checked) 
																				if(FindersAndRichesHelper.settings.global.showMinimapIcon) then -- in this case 11 is selected

																					FindersAndRichesHelper.settings.global.showMinimapIcon = false
																					UIDropDownMenu_SetSelectedValue(menuFrame, HIDE_MINIMAP_YES_ID)
																					UIDropDownMenu_SetSelectedValue(menuFrame, HIDE_MINIMAP_NO_ID)
																					minimapIcon:Show("FRH_ldbIcon")
																				else -- dont update in case it is already selected
																					UIDropDownMenu_SetSelectedValue(menuFrame, HIDE_MINIMAP_NO_ID)
																				end
																			 end
					}
				}
			},
			{text= "Close", notCheckable=true}
		   }
function FindersAndRichesHelper:MinimapButtonOptions(parentFrame)
	if menuFrame == nil then
		menuFrame = CreateFrame("Frame", "ExampleMenuFrame", parentFrame, "UIDropDownMenuTemplate")
	end
		
	
	--set actual values
	menu[FINDERS_KEEPERS_INDEX].checked = self.settings.global.addFindersWaypoints
	menu[RICHES_OF_PANDARIA_INDEX].checked = self.settings.global.addRichesWaypoints

	menu[ZONE_LIMITATION_INDEX].menuList[ZONE_LIMITATION_ZONE_ONLY_INDEX].checked = self.settings.global.limitZone
	menu[ZONE_LIMITATION_INDEX].menuList[ZONE_LIMITATION_ALL_ZONES_INDEX].checked = not self.settings.global.limitZone
	
	menu[TRACKED_TREASURES_INDEX].menuList[TRACKED_TREASURES_MISSING_ONLY_INDEX].checked = self.settings.global.limitMissing
	menu[TRACKED_TREASURES_INDEX].menuList[TRACKED_TREASURES_ALL_TREASURES_INDEX].checked = not self.settings.global.limitMissing
	
	menu[HIDE_MINIMAP_INDEX].menuList[HIDE_MINIMAP_YES_INDEX].checked = not self.settings.global.showMinimapIcon
	menu[HIDE_MINIMAP_INDEX].menuList[HIDE_MINIMAP_NO_INDEX].checked = self.settings.global.showMinimapIcon
	
	menuFrame:SetPoint("Center", parentFrame, "Center")
	EasyMenu(menu, menuFrame, menuFrame, 0 , 0, "MENU") 
end
-- Minimap options




--[[ old function
function FindersAndRichesHelper:SetRichesOfPandariaWaypoints(limitZone, limitMissing)
	local doAdd
	local zoneName = GetZoneText()
	
	for k, a in pairs(richesOfPandaria) do
		if limitZone and zoneName == GetMapNameByID(a.map) then
			if limitMissing then
				if(IsQuestFlaggedCompleted(a.qid)) then
					self:Print("adding waypoint to " .. a.desc .. " failed because you have already found it")
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			else
				if(IsQuestFlaggedCompleted(a.qid)) then
					FindersAndRichesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc .. ' (Already found)')
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			end
		else
			if limitMissing then
				if(IsQuestFlaggedCompleted(a.qid)) then
					self:Print("adding waypoint to " .. a.desc .. " failed because you have already found it")
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			else
				if( not IsQuestFlaggedCompleted(a.qid)) then
					FindersAndRichesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc .. ' (Already found)')
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
				end
			end
		end
	end
end


-- workarround into minimap buttons 
VuhDoMinimap = {

	["Create"] = function(self, someModSettings, someInitSettings)

		if (VuhDoMinimapButton ~= nil) then
			return;
		end

		local tFrame = CreateFrame("Button", "VuhDoMinimapButton", Minimap);

		tFrame:SetWidth(31);
		tFrame:SetHeight(31);
		tFrame:SetFrameStrata("LOW");
		tFrame:SetToplevel(true);
		tFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
		tFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT");

		local tIcon = tFrame:CreateTexture("VuhDoMinimapButtonIcon", "BACKGROUND");
		tIcon:SetTexture(VUHDO_STANDARD_ICON);
		tIcon:SetWidth(20);
		tIcon:SetHeight(20);
		tIcon:SetPoint("TOPLEFT", tFrame, "TOPLEFT", 7, -5);

		local tOverlay = tFrame:CreateTexture("VuhDoMinimapButtonOverlay", "OVERLAY");
		tOverlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
		tOverlay:SetWidth(53);
		tOverlay:SetHeight(53);
		tOverlay:SetPoint("TOPLEFT", tFrame, "TOPLEFT")

		tFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		tFrame:SetScript("OnClick", self.OnClick);

		tFrame:SetScript("OnMouseDown", self.OnMouseDown);
		tFrame:SetScript("OnMouseUp", self.OnMouseUp);
		tFrame:SetScript("OnEnter", self.OnEnter);
		tFrame:SetScript("OnLeave", self.OnLeave);

		tFrame:RegisterForDrag("LeftButton");
		tFrame:SetScript("OnDragStart", self.OnDragStart);
		tFrame:SetScript("OnDragStop", self.OnDragStop);

		if (someModSettings["position"] == nil) then
			someModSettings["drag"] = someInitSettings["drag"];
			someModSettings["position"] = someInitSettings["position"];
		end

		tFrame["modSettings"] = someModSettings;
		self:Move();
	end,


]]--
