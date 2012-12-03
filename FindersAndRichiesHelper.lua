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

local defaultSettings = {
  global = {
    hintFrame = {
      locked = false,
      left = false,
      top = false,
      distance = 100
      -- TODO limit missing or all (configurable)
    }
  }
}

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
						 {map=806, qid = 31307 , desc = 'Jade Infused Blade', pos = { x=39.26 , y=46.65}, npc = {id=64272, name='Jade Warrior Statue'}}, -- npc scan id 64272 Jade Warrior Statue
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
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 1', pos = { x=42.00 , y=62.20}, npc = {id=65552, name='Glinting Rapana Whelk'}}, -- npc scan id 65552 Glinting Rapana Whelk
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 2', pos = { x=42.20 , y=63.60}},
						 {map=858, qid = 31432 , desc = 'Manipulator\'s Talisman spot 3', pos = { x=41.60 , y=64.60}},
						 {map=858, qid = 31434 , desc = 'Swarming Cleaver of Ka\'roz', pos = { x=56.80 , y=77.60}},
						 {map=858, qid = 31666 , desc = 'Wind-Reaver\'s Dagger of Quick Strikes', pos = { x=71.80 , y=36.10}},
						 }


						 
function FindersAndRichiesHelper:OnInitialize()
  -- Called when the addon is loaded
  self:RegisterChatCommand("findersandrichieshelper", "SlashCommand")
  self:RegisterChatCommand("frh", "SlashCommand")

  self.settings = LibStub("AceDB-3.0"):New("FRH_Settings", defaultSettings, true)
end

function FindersAndRichiesHelper:PrintUsage()
  local s

  s = "\n"
  s = s .. "|cff7777ff/FindersAndRichiesHelper ...|r\n"
  s = s .. "|cff7777ff/use the commands without the richies or finders key words to track both achievements...|r\n"
  s = s .. "|cff7777ff/frh (richies|finders) all zone|r " .. "add waypoints to all items in current zone, including already found ones" .. "\n"
  s = s .. "|cff7777ff/frh (richies|finders) missing zone|r " .. "add waypoints to all items in current zone, excluding alrady found ones" .. "\n"
  s = s .. "|cff7777ff/frh (richies|finders) all|r " .. "add waypoints to all items in all maps, including already found ones" .. "\n"
  s = s .. "|cff7777ff/frh (richies|finders) all missing|r " .. "add waypoints to all items in all maps, excluding already found ones" .. "\n"
  s = s .. "|cff7777ff/frh debug|r " .. "esable/disable debug mode"

  self:Print(s)
end

function FindersAndRichiesHelper:SlashCommand(command)
  local limitZone, limitMissing, distance
  -- commands: all (everything everywhere), all zone (all in current zone), missing (missing in current zone, default), all missing (missing in every zone)
  addFindersWaypoints = false
  addRichiesWaypoints = false
  limitMissing = false
  limitZone = false
  
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
  -- tracker only for the Finders Keepers Achievement
  elseif command:match"^%s*finders%s+all%s+zone%s*$" then -- markers only in the current zone, but including already found items
	self:Print('finders all zone')
	limitZone = true
	addFindersWaypoints = true
  elseif command:match"^%s*finders%s+missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	self:Print('finders missing zone')
	limitZone = true
	limitMissing = true
	addFindersWaypoints = true
  elseif command:match"^%s*finders%s+all%s*$" then -- markers in all maps, but including already found items
	self:Print('finders all')
	addFindersWaypoints = true
  elseif command:match"^%s*finders%s+all%s+missing%s*$" then -- markers in all maps, but excluding already found items
	self:Print('finders all missing')
	limitMissing = true
	addFindersWaypoints = true
  -- tracker only for the Richies of Pandaria Achievement
  elseif command:match"^%s*richies%s+all%s+zone%s*$" then -- markers only in the current zone, but including already found items
	self:Print('richies all zone')
	limitZone = true
	addRichiesWaypoints = true
  elseif command:match"^%s*richies%s+missing%s+zone%s*$" then -- markers only in the current zone, but excluding already found items
	self:Print('richies missing zone')
	limitZone = true
	limitMissing = true
	addRichiesWaypoints = true
  elseif command:match"^%s*richies%s+all%s*$" then -- markers in all maps, but including already found items
	self:Print('richies all')
	addRichiesWaypoints = true
  elseif command:match"^%s*richies%s+all%s+missing%s*$" then -- markers in all maps, but excluding already found items
	self:Print('richies all')
	addRichiesWaypoints = true
	limitMissing = true
  else
    FindersAndRichiesHelper:PrintUsage()
  end

  if addFindersWaypoints then
	self:Print('processing waypoints to Finders')
	FindersAndRichiesHelper:SetAchievementWaypoints(limitZone, limitMissing, richiesOfPandaria)
  end
  if addRichiesWaypoints then
	self:Print('processing waypoints to Richies')
	FindersAndRichiesHelper:SetAchievementWaypoints(limitZone, limitMissing, findersKeepers)
  end
end

function FindersAndRichiesHelper:SetAchievementWaypoints(limitZone, limitMissing, achievementCriteriaSet)
	local doAdd
	local zoneName = GetZoneText()
	
	--self:Print("set finders keepers waypoints : limitZone = " .. limitZone .. " limitMissing=" .. limitMissing)
	for k, a in pairs(achievementCriteriaSet) do
		if limitZone and zoneName == GetMapNameByID(a.map) then
			if limitMissing then
				if( IsQuestFlaggedCompleted(a.qid)) then
					self:Print("adding waypoint to " .. a.desc .. " failed because you have already found it")
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
					if (a.npc)
						FindersAndRichiesHelper:AddNpc(a.npc.id, a.map, a.npc.name)
				end
			else
				if( IsQuestFlaggedCompleted(a.qid)) then
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc .. ' (Already found)')
					--check if npc
					if (a.npc)
						FindersAndRichiesHelper:AddNpc(a.npc.id, a.map, a.npc.name)
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
					if (a.npc)
						FindersAndRichiesHelper:AddNpc(a.npc.id, a.map, a.npc.name)
					--check if npc
				end
			end
		elseif limitZone == false then
			if limitMissing then
				if(IsQuestFlaggedCompleted(a.qid)) then
					self:Print("adding waypoint to " .. a.desc .. " failed because you have already found it")
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
					if (a.npc)
						FindersAndRichiesHelper:AddNpc(a.npc.id, a.map, a.npc.name)
					--check if npc
				end
			else
				if( not IsQuestFlaggedCompleted(a.qid)) then
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc .. ' (Already found)')
					if (a.npc)
						FindersAndRichiesHelper:AddNpc(a.npc.id, a.map, a.npc.name)
					--check if npc
				else
					self:Print("adding waypoint to " .. a.desc)
					FindersAndRichiesHelper:AddWaypoint(a.map, a.pos.f or nil, a.pos.y / 100, a.pos.x / 100, a.desc)
					if (a.npc)
						FindersAndRichiesHelper:AddNpc(a.npc.id, a.map, a.npc.name)
					--check if npc
				end
			end
		end
	end
end

function FindersAndRichiesHelper:AddNpc(npcId, map, npcName)
  if NS and NS.NPCAdd then
    NS:NPCAdd(npcId, npcName, map)
  else
	-- cant add npc name because npc scan isn't installed
    -- s = GetMapNameByID(map)
    -- show floor?
    -- s = s .. " (" .. x*100 .. ", " .. y*100 .. "): " .. title
    self:Print('Can\'t add npc because NPCScan is not installed')
  end
end


function FindersAndRichiesHelper:AddWaypoint(map, floorNum, x, y, title)
  local s
  if TomTom and TomTom.AddMFWaypoint then
    TomTom:AddMFWaypoint(map, floorNum or nil, x, y, {title = title})
  elseif TomTomLite and TomTomLite.AddWaypoint then
    TomTomLite.AddWaypoint(map, floorNum or nil, x, y, {title = title})
  else
    s = GetMapNameByID(map)
    -- show floor?
    s = s .. " (" .. x*100 .. ", " .. y*100 .. "): " .. title
    self:Print(s)
  end
end

function FindersAndRichiesHelper:OnEnable()
  -- Called when the addon is enabled
  if not updaterFrame then
    --[===[@debug@
    LorewalkersHelper:Print('CreateFrame: LorewalkersHelperUpdaterFrame')
    --@end-debug@]===]
    updaterFrame = CreateFrame("frame")
    updaterFrame:SetScript("OnEvent", eventHandler)
    updaterFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    updaterFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  end
  updaterFrame:Show()
end

function FindersAndRichiesHelper:OnDisable()
  if updaterFrame then
    updaterFrame:Hide()
    updaterFrame:SetParent(nil)
    updaterFrame = nil
  end
end

function FindersAndRichiesHelper:eventHandler(self, event)
	--update map every change if show mode is enabled.
	self:Print("Hello World! Hello " .. event);
end
-- LDB

local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)

-- local LibQTip = LibStub('LibQTip-1.0')
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("LorewalkersHelper",
{
  type = "data source",
  label = "Lorewalkers Helper",
  text = "Lorewalkers Helper",
  -- icon = "Interface\\Icons\\Ability_mount_cloudmount",
  icon = "Interface\\Icons\\achievement_faction_lorewalkers",
  OnClick = function(clickedFrame, button)
    -- Click to add waypoints to missing criteria in current zone. (default)
    -- Shift-Click to add waypoints to missing criteria in Pandaria.
    -- Alt-Click to add waypoints to all criteria in current zone.
    -- Alt-Shift-Click to add waypoints to all criteria in Pandaria.
    if button == "LeftButton" then
      -- LorewalkersHelper:SetWaypoints(limitZone, limitMissing)
      LorewalkersHelper:SetWaypoints(not IsShiftKeyDown(), not IsAltKeyDown())
    elseif button == "RightButton" then
      LorewalkersHelper:ToggleMoveHintFrame()
    end
  end,
});

function LDB:OnTooltipShow()
  local zoneName, zoneId, counts, i, a, c
  self:AddLine("Lorewalkers Helper")

  self:AddLine(L["Missing achievements criteria in current zone"])

  zoneId = -1
  zoneName = GetZoneText()
  counts = {}
  for i, a in pairs(achiMap) do
    for i, c in pairs(a[2].p) do
      --[===[@alpha@
      if not select(3, GetAchievementCriteriaInfoByID(a[1], c.id)) then
        if counts[c.m] then
          counts[c.m] = counts[c.m] + 1
        else
          counts[c.m] = 1
        end
        if zoneName == GetMapNameByID(c.m) then
          zoneId = c.m -- store it for later use ^^
          self:AddLine("|cffff0000" ..
                       select(1, GetAchievementCriteriaInfoByID(a[1], c.id)) ..
                       "|r" ..
                       " (" .. a[1] .. " - " .. c.id .. ")")
        end
      else
        if zoneName == GetMapNameByID(c.m) then
          zoneId = c.m -- store it for later use ^^
          self:AddLine("|cff00ff00" ..
                       select(1, GetAchievementCriteriaInfoByID(a[1], c.id)) ..
                       "|r" ..
                       " (" .. a[1] .. " - " .. c.id .. ")")
        end
      end
      --@end-alpha@]===]
      --@non-alpha@
      if not select(3, GetAchievementCriteriaInfoByID(a[1], c.id)) then
        if counts[c.m] then
          counts[c.m] = counts[c.m] + 1
        else
          counts[c.m] = 1
        end
        if zoneName == GetMapNameByID(c.m) then
          zoneId = c.m -- store it for later use ^^
          self:AddLine("|cffff0000" ..
                       select(1, GetAchievementCriteriaInfoByID(a[1], c.id)) ..
                       "|r")
        end
      end
      --@end-non-alpha@
    end
  end

  if zoneId >= 0 and not counts[zoneId]  then
    self:AddLine(L["Nothing missing in current zone!"])
  end

  self:AddLine(" ")
  self:AddLine(L["Missing criteria in other zones"])

  for i, c in pairs(counts) do
    if i ~= zoneId then
      if not c then
        self:AddLine(GetMapNameByID(i) ..
                     ": |cff00ff00" ..
                     c ..
                     "|r")
      else
        self:AddLine(GetMapNameByID(i) ..
                     ": |cffff0000" ..
                     c ..
                     "|r")
      end
    end
  end

  self:AddLine(" ")
  -- colors are Alpha Red Green Blue
  self:AddLine("|cffed55aaClick|r: " .. L["add waypoints to missing criteria in current zone"])
  self:AddLine("|cffed55aaShift-Click|r: " .. L["add waypoints to missing criteria in all Pandaria zones"])
  self:AddLine("|cffed55aaAlt-Click|r: " .. L["add waypoints to every criteria in current zone"])
  self:AddLine("|cffed55aaAlt-Shift-Click|r: " .. L["add waypoints to every criteria across Pandaria"])
  self:AddLine("|cffed55aaRightClick|r: " .. L["lock/unlock info panel"])


  --[===[@debug@
  -- for i, a in pairs(achiMap) do
  --   for i, c in pairs(a[2].p) do
  --     self:AddLine(a[1] .. "." .. c.id .. " (" .. c.m .. ": " .. c.x .. ", " .. c.y .. "): " ..
  --                  "|cffff0000" ..
  --                  select(1, GetAchievementCriteriaInfoByID(a[1], c.id)) ..
  --                  "|r")
  --   end
  -- end
  --@end-debug@]===]
  --[===[@non-debug@
  --@non-debug@]===]

end

function LDB:OnEnter()
  GameTooltip:SetOwner(self, "ANCHOR_NONE")
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
  GameTooltip:ClearLines()
  LDB.OnTooltipShow(GameTooltip)
  GameTooltip:Show()
end

function LDB:OnLeave()
  GameTooltip:Hide()
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
