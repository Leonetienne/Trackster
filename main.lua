--[[
	I know, this code looks like ass,
	if you feel personally insulted, feel free to contact /2
]]

local mainFrame = CreateFrame("frame", "TracksterMainFrame", nil, BackdropTemplateMixin and "BackdropTemplate");
Trackster = {};

Trackster_jumpCounter = 0;
Trackster_castCounter = 0;
Trackster_critCounter = 0;
Trackster_loginCounter = 0;
Trackster_bossCounter = 0;
Trackster_chatCounter = 0;
Trackster_itemCounter = 0;
Trackster_goldCounter = 0;
Trackster_questCounter = 0;
Trackster_killCounter = 0;
Trackster_distanceTravelledCounter = 0;
Trackster_distanceTravelledCounter__swam = 0;
Trackster_distanceTravelledCounter__walked = 0;
Trackster_distanceTravelledCounter__groundmount = 0;
Trackster_distanceTravelledCounter__flight = 0;
Trackster_distanceTravelledCounter__ghost = 0;
Trackster_distanceTravelledCounter__taxi = 0;

Trackster_frameScale = 1;

local updateOneSecondTimer = 0;

local buttonX = CreateFrame("Button", nil);
buttonX:SetPoint("TOPRIGHT", mainFrame, 6, 6);
buttonX:SetFrameStrata("Background");
buttonX:SetWidth(33);
buttonX:SetHeight(33);

local ntex = buttonX:CreateTexture();
ntex:SetTexture("Interface/Buttons/UI-Panel-MinimizeButton-Up");
ntex:SetTexCoord(0, 1, 0, 1);
ntex:SetAllPoints()	;
buttonX:SetNormalTexture(ntex);

local htex = buttonX:CreateTexture()
htex:SetTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight");
htex:SetTexCoord(0, 1, 0, 1);
htex:SetAllPoints();
buttonX:SetHighlightTexture(htex);

local ptex = buttonX:CreateTexture();
ptex:SetTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down");
ptex:SetTexCoord(0, 1, 0, 1);
ptex:SetAllPoints();
buttonX:SetPushedTexture(ptex);


local textFont = "GameFontWhite";
local textMarginB = 20; --> margin between
local textMarginT = 25; --> margin top
local textMarginL = 25; --> margin left

local textCol_value = "|cFFFFD044"; --> text color string vor values

local fsDeaths = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_deathOffset = 0;

local fsKills = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_killsOffset = 0;

local fsDist = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset = 0;

local fsDist__swam = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset__swam = 0;

local fsDist__walked = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset__walked = 0;

local fsDist__groundmount = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset__groundmount = 0;

local fsDist__flight = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset__flight = 0;

local fsDist__taxi = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset__taxi = 0;

local fsDist__ghost = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset__ghost = 0;

local fsQuests = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_questsOffset = 0;

--local fsDmg = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
--Trackster_dmgOffset = 0;

local fsJump = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_jumpOffset = 0;

local fsPlvl = mainFrame:CreateFontString(nil, "OVERLAY", textFont);

local fsIlvl = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_IlvlOffset = 0;

local fsGold = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_goldOffset = 0;

local fsGoldCurrent = mainFrame:CreateFontString(nil, "OVERLAY", textFont);

local fsCasts = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_castOffset = 0;

local fsCrits = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_critOffset = 0;

local fsLogins = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_loginOffset = 0;

local fsBoss = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_bossOffset = 0;

local fsChat = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_chatOffset = 0;

local fsItem = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_itemOffset = 0;

local fsHearthstones = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_HearthstonesOffset = 0;

local fsTime = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsAbsTime = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_timeOffset = 0;
Trackster_timestampRunBegin = 0;
local lastConfirmedTime = 0;
local internalTimeOffset = 0;

local function InvertBool(b)
	if (b == true) then 
		return false;
	else 
		return true;
	end
end

local function PrintMsg(s)
	print("|cFFFFD044Trackster:|r " .. s);
end

--> Will play a sound and display a string on screen
local function AnnounceMilestone(message)
	--> Play a nice sound --> https://www.wowhead.com/sound=63971/ui-legendaryloot-toast
	PlaySound(63971);
	--> Announce the message on screen
	UIErrorsFrame:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME)
	--> Announce in chat
	PrintMsg(message);
end

--> Will call AnnounceMilestone automatically, each time value is a multiple of interval, or explicitly defined in avMessages
--> Only use for integer, steady, individually incremented values!
--> Meaning, they are integers, never decrease in value, and call this method for every single increment, and every increment must be by 1!
local function AutoAnnounceMilestone_INT_STEADY_IINCR(value, kindkey, prettyName, interval)
	if (value > 0) then
		--> If a multiple of interval, or if we have a special message for that count
		if (value % interval == 0) or (Trackster_avMessages[kindkey] and Trackster_avMessages[kindkey][value]) then
		 
			--> Fetch a special message if we have one, else come up with one
			local message;
			if Trackster_avMessages[kindkey] and Trackster_avMessages[kindkey][value] then
				message = Trackster_avMessages[kindkey][value];
			else
				--> Little special case for time played
				if (kindkey == "timePlayed") then
					local totalHours = math.floor((lastConfirmedTime + internalTimeOffset + Trackster_timeOffset) / 3600);
					message = "Congratulations! You have played for " .. totalHours .. " hours!";
				else
					message = "Congratulations! You have reached " .. value .. " " .. kindkey .. "!";
				end
			end
		
			AnnounceMilestone(message);
		end
	end
end

--> Will call AnnounceMilestone automatically, each time value is close to a multiple of interval, or explicitly defined in avMessages
--> Only use for decimal, steady values!
--> Meaning, they are decimal numbers and must never decrease in value!
--> Y is the leeway to trigger. Let's say, if you set a trigger for 1,000,000, and have a Y of 2, it would still trigger for 1,000,002.
local aamds_triggersUsed = {}
local function AutoAnnounceMilestone_DEC_STEADY(value, kindkey, prettyName, interval, Y)
	if (Y == nil) then Y = 1 end;
	
	local intval = math.floor(value);
	
	--> Special trigger points
	if (Trackster_avMessages[kindkey]) then
		--> Find closest trigger point
		local closestKey = nil;
		local minDifference = math.huge;
		for key, _ in pairs(Trackster_avMessages[kindkey]) do
			if key <= intval then
				local difference = intval - key
				if difference < minDifference then
					minDifference = difference
					closestKey = key
				end
			end
		end

		--> If we have found a closest key (may be 0 because were only looking at <= value keys
		if (closestKey) then
			--> If value is near closest defined trigger value AND trigger value is not blacklisted
			local intsOverNearestTrigger = intval - closestKey;
			if ((intsOverNearestTrigger <= Y) and (aamds_triggersUsed[kindkey][closestKey] == nil)) then
				--> Announce the milestone
				local message = Trackster_avMessages[kindkey][closestKey];
				AnnounceMilestone(message);
				
				--> Blacklist this trigger value
				if (aamds_triggersUsed[kindkey] == nil) then
					aamds_triggersUsed[kindkey] = {};
				end
				aamds_triggersUsed[kindkey][closestKey] = true;
				
				return;
			end
		end
	end

	--> Procedural trigger points
	local mod = intval % interval;
    local intsOverNearestTrigger = intval % interval;
	local nearestTrigger = intval - intsOverNearestTrigger;
	
	--> If value is near procedural trigger AND trigger value is not blacklisted
	if ((intsOverNearestTrigger <= Y) and (aamds_triggersUsed[kindkey] == nil or aamds_triggersUsed[kindkey][nearestTrigger] == nil)) then
		--> Announce the milestone
		local message = "Congratulations! You have reached " .. value .. " " .. prettyName .. "!";
		AnnounceMilestone(message);
		
		--> Blacklist this trigger value
		if (aamds_triggersUsed[kindkey] == nil) then
			aamds_triggersUsed[kindkey] = {};
		end
		aamds_triggersUsed[kindkey][nearestTrigger] = true;
	end
end

local function CommafyNumber(number)
  -- Convert the number to a string
  local strNumber = tostring(number)
  
  -- Reverse the string
  local reversedStr = string.reverse(strNumber)
  
  -- Add commas every three characters
  local formattedStr = reversedStr:gsub("(%d%d%d)", "%1,")
  
  -- Reverse the formatted string back to its original order
  local finalStr = string.reverse(formattedStr)
  
  -- Remove any leading comma if present
  if string.sub(finalStr, 1, 1) == "," then
    finalStr = string.sub(finalStr, 2)
  end
  
  -- Return the formatted number
  return finalStr
end


mainFrame:SetBackdrop({
      bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", 
      edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
      tile=1, tileSize=32, edgeSize=32, 
      insets={left=11, right=12, top=12, bottom=11}
})

fsKills:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (0 * textMarginB)));
fsDeaths:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (1 * textMarginB)));
fsTime:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (2 * textMarginB)));
fsAbsTime:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (3 * textMarginB)));
fsDist:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (4 * textMarginB)));
fsDist__swam:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (5 * textMarginB)));
fsDist__walked:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (6 * textMarginB)));
fsDist__groundmount:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (7 * textMarginB)));
fsDist__flight:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (8 * textMarginB)));
fsDist__taxi:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (9 * textMarginB)));
fsDist__ghost:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (10 * textMarginB)));
fsQuests:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (11 * textMarginB)));
fsPlvl:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (12 * textMarginB)));
fsIlvl:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (13 * textMarginB)));
--fsDmg:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (5 * textMarginB)));
fsGold:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (14 * textMarginB)));
fsGoldCurrent:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (15 * textMarginB)));
fsBoss:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (16 * textMarginB)));
fsCasts:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (17 * textMarginB)));
fsCrits:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (18 * textMarginB)));
fsLogins:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (19 * textMarginB)));
--fsItem:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (12 * textMarginB)));
fsChat:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (20 * textMarginB)));
fsJump:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (21 * textMarginB)));
fsHearthstones:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (22 * textMarginB)));

mainFrame:SetWidth(220 + textMarginL);
mainFrame:SetHeight((textMarginT * 2) + (textMarginB *  22));
mainFrame:EnableMouse(true);
mainFrame:SetPoint("CENTER", 480, 0, UIParent);
mainFrame:SetMovable(true);
mainFrame:RegisterForDrag("LeftButton");
mainFrame:SetFrameStrata("Background");
mainFrame:SetUserPlaced(true);
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving);
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing);

mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
mainFrame:RegisterEvent("PLAYER_LOGOUT");
mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
mainFrame:RegisterEvent("PLAYER_DEAD");
mainFrame:RegisterEvent("QUEST_TURNED_IN");
mainFrame:RegisterEvent("ADDON_LOADED");
mainFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
mainFrame:RegisterEvent("PLAYER_MONEY");
mainFrame:RegisterEvent("PLAYER_LOGIN");
mainFrame:RegisterEvent("PLAYER_LEVEL_UP");
mainFrame:RegisterEvent("BOSS_KILL");
mainFrame:RegisterEvent("CHAT_MSG_LOOT");
mainFrame:RegisterEvent("QUEST_LOOT_RECEIVED");
mainFrame:RegisterEvent("CHAT_MSG_SAY");
mainFrame:RegisterEvent("CHAT_MSG_CHANNEL");
mainFrame:RegisterEvent("CHAT_MSG_GUILD");
mainFrame:RegisterEvent("CHAT_MSG_OFFICER");
mainFrame:RegisterEvent("CHAT_MSG_PARTY");
mainFrame:RegisterEvent("CHAT_MSG_PARTY_LEADER");
mainFrame:RegisterEvent("CHAT_MSG_RAID");
mainFrame:RegisterEvent("CHAT_MSG_RAID_LEADER");
mainFrame:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
mainFrame:RegisterEvent("CHAT_MSG_YELL");
mainFrame:RegisterEvent("CHAT_MSG_INSTANCE_CHAT");
mainFrame:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER");
mainFrame:RegisterEvent("TIME_PLAYED_MSG");
mainFrame:RegisterEvent("LOADING_SCREEN_DISABLED");
mainFrame:RegisterEvent("CINEMATIC_START");
mainFrame:RegisterEvent("CINEMATIC_STOP");

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0);
  return math.floor(num * mult + 0.5) / mult;
end

local function FormatTime(t)

	local secondsInDay = (60 * 60 * 24);
	local secondsInHour = (60 * 60);
	local secondsInMinute = (60);

	local rmnTime = t;
	
	local d = math.floor(rmnTime / secondsInDay);
	rmnTime = rmnTime % secondsInDay;
	
	local h = math.floor(rmnTime / secondsInHour);
	rmnTime = rmnTime % secondsInHour;
	
	local m = math.floor(rmnTime / secondsInMinute);
	rmnTime = rmnTime % secondsInMinute;
	
	local s = rmnTime;
	
	return select(1, d, h, m, s);
end

local timer__all = 0;
local timer__swam = 0;
local timer__walked = 0;
local timer__groundmount = 0;
local timer__flight = 0;
local timer__taxi = 0;
local timer__ghost = 0;
function UpdateDistanceTravelled(self, deltaTime, forceTextUpdate)
	--> Update value in background in every frame
	local deltaDistance = GetUnitSpeed("PLAYER") * 0.9144 * deltaTime; --> Distance gets saved in meters, GetUnitSpeed returns yards per second
	Trackster_distanceTravelledCounter = Trackster_distanceTravelledCounter + deltaDistance;

	--> Increment specialized distance counters, if the state fits (like, swimming only if IsSwimming() == true)
	if (IsSwimming()) then
		Trackster_distanceTravelledCounter__swam = Trackster_distanceTravelledCounter__swam + deltaDistance;
	elseif (UnitOnTaxi("PLAYER")) then
		Trackster_distanceTravelledCounter__taxi = Trackster_distanceTravelledCounter__taxi + deltaDistance;
	elseif (IsFlying()) then
		Trackster_distanceTravelledCounter__flight = Trackster_distanceTravelledCounter__flight + deltaDistance;
	elseif (IsMounted()) then
		Trackster_distanceTravelledCounter__groundmount = Trackster_distanceTravelledCounter__groundmount + deltaDistance;
	elseif (UnitIsDeadOrGhost("PLAYER")) then
		Trackster_distanceTravelledCounter__ghost = Trackster_distanceTravelledCounter__ghost + deltaDistance;
	elseif (UnitInVehicle("PLAYER") == false) then
		Trackster_distanceTravelledCounter__walked = Trackster_distanceTravelledCounter__walked + deltaDistance;
	end


	local val__all = round(Trackster_distanceTravelledCounter + Trackster_distanceTravelledOffset);
	local val__swam = round(Trackster_distanceTravelledCounter__swam + Trackster_distanceTravelledOffset__swam);
	local val__walked = round(Trackster_distanceTravelledCounter__walked + Trackster_distanceTravelledOffset__walked);
	local val__groundmount = round(Trackster_distanceTravelledCounter__groundmount + Trackster_distanceTravelledOffset__groundmount);
	local val__flight = round(Trackster_distanceTravelledCounter__flight + Trackster_distanceTravelledOffset__flight);
	local val__taxi = round(Trackster_distanceTravelledCounter__taxi + Trackster_distanceTravelledOffset__taxi);
	local val__ghost = round(Trackster_distanceTravelledCounter__ghost + Trackster_distanceTravelledOffset__ghost);
	
	AutoAnnounceMilestone_DEC_STEADY(val__all, "distAll", "kilometers travelled", 1000*1000, 100); --> Each 1,000 km
	AutoAnnounceMilestone_DEC_STEADY(val__swam, "distSwam", "kilometers swam", 50*1000, 100); --> Each 50 km
	AutoAnnounceMilestone_DEC_STEADY(val__walked, "distWalked", "kilometers travelled by foot", 500*1000, 100); --> Each 500 km
	AutoAnnounceMilestone_DEC_STEADY(val__groundmount, "distGroundmount", "kilometers rode (on ground)", 1000*1000, 100); --> Each 1,000 km
	AutoAnnounceMilestone_DEC_STEADY(val__flight, "distFlight", "kilometers flown", 1000*000, 100); --> Each 1,000 km
	AutoAnnounceMilestone_DEC_STEADY(val__taxi, "distTaxi", "kilometers rode (on taxi)", 500*000, 100); --> Each 500 km
	AutoAnnounceMilestone_DEC_STEADY(val__ghost, "distGhost", "kilometers haunted", 10*000, 100); --> Each 10 km
				
	timer__all 			= timer__all + deltaTime;
	timer__swam 		= timer__swam + deltaTime;
	timer__walked 		= timer__walked + deltaTime;
	timer__groundmount 	= timer__groundmount + deltaTime;
	timer__flight 		= timer__flight + deltaTime;
	timer__taxi 		= timer__taxi + deltaTime;
	timer__ghost 		= timer__ghost + deltaTime;

	local updateDelayS__all = 1;
	local updateDelayS__swam = 1;
	local updateDelayS__walked = 1;
	local updateDelayS__groundmount = 1;
	local updateDelayS__flight = 1;
	local updateDelayS__taxi = 1;
	local updateDelayS__ghost = 1;
	
	if (val__all < 5000) then
		updateDelayS__all = 0.1;
	elseif (val__all < 10000) then
		updateDelayS__all = 1;
	else
		updateDelayS__all = 10;
	end
	
	if (val__swam < 5000) then
		updateDelayS__swam = 0.1;
	elseif (val__swam < 10000) then
		updateDelayS__swam = 1;
	else
		updateDelayS__swam = 10;
	end

	if (val__walked < 5000) then
		updateDelayS__walked = 0.1;
	elseif (val__walked < 10000) then
		updateDelayS__walked = 1;
	else
		updateDelayS__walked = 10;
	end

	if (val__groundmount < 5000) then
		updateDelayS__groundmount = 0.1;
	elseif (val__groundmount < 10000) then
		updateDelayS__groundmount = 1;
	else
		updateDelayS__groundmount = 10;
	end

	if (val__flight < 5000) then
		updateDelayS__flight = 0.1;
	elseif (val__flight < 10000) then
		updateDelayS__flight = 1;
	else
		updateDelayS__flight = 10;
	end

	if (val__taxi < 5000) then
		updateDelayS__taxi = 0.1;
	elseif (val__taxi < 10000) then
		updateDelayS__taxi = 1;
	else
		updateDelayS__taxi = 10;
	end

	if (val__ghost < 5000) then
		updateDelayS__ghost = 0.1;
	elseif (val__ghost < 10000) then
		updateDelayS__ghost = 1;
	else
		updateDelayS__ghost = 10;
	end
	
	if (timer__all >= updateDelayS__all or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__all < 10000) then
			fsDist:SetText("Distance travelled: " .. textCol_value .. CommafyNumber(val__all) .. "m");
		else
			fsDist:SetText("Distance travelled: " .. textCol_value .. CommafyNumber(round(val__all/1000)) .. "km");
		end

		timer__all = 0;
	end

	if (timer__swam >= updateDelayS__swam or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__swam < 10000) then
			fsDist__swam:SetText("Distance swam: " .. textCol_value .. CommafyNumber(val__swam) .. "m");
		else
			fsDist__swam:SetText("Distance swam: " .. textCol_value .. CommafyNumber(round(val__swam/1000)) .. "km");
		end

		timer__swam = 0;
	end

	if (timer__walked >= updateDelayS__walked or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__walked < 10000) then
			fsDist__walked:SetText("Distance by foot: " .. textCol_value .. CommafyNumber(val__walked) .. "m");
		else
			fsDist__walked:SetText("Distance by foot: " .. textCol_value .. CommafyNumber(round(val__walked/1000)) .. "km");
		end

		timer__walked = 0;
	end

	if (timer__groundmount >= updateDelayS__groundmount or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__groundmount < 10000) then
			fsDist__groundmount:SetText("Distance rode: " .. textCol_value .. CommafyNumber(val__groundmount) .. "m");
		else
			fsDist__groundmount:SetText("Distance rode: " .. textCol_value .. CommafyNumber(round(val__groundmount/1000)) .. "km");
		end

		timer__groundmount = 0;
	end

	if (timer__flight >= updateDelayS__flight or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__flight < 10000) then
			fsDist__flight:SetText("Distance flown: " .. textCol_value .. CommafyNumber(val__flight) .. "m");
		else
			fsDist__flight:SetText("Distance flown: " .. textCol_value .. CommafyNumber(round(val__flight/1000)) .. "km");
		end

		timer__flight = 0;
	end

	if (timer__taxi >= updateDelayS__taxi or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__taxi < 10000) then
			fsDist__taxi:SetText("Distance on taxi: " .. textCol_value .. CommafyNumber(val__taxi) .. "m");
		else
			fsDist__taxi:SetText("Distance on taxi: " .. textCol_value .. CommafyNumber(round(val__taxi/1000)) .. "km");
		end

		timer__taxi = 0;
	end

	if (timer__ghost >= updateDelayS__ghost or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val__ghost < 10000) then
			fsDist__ghost:SetText("Distance haunted: " .. textCol_value .. CommafyNumber(val__ghost) .. "m");
		else
			fsDist__ghost:SetText("Distance haunted: " .. textCol_value .. CommafyNumber(round(val__ghost/1000)) .. "km");
		end

		timer__ghost = 0;
	end
end

function UpdatePlvl()
	fsPlvl:SetText("Character level: " .. textCol_value .. UnitLevel("PLAYER"));
end

function UpdateDeaths()
	Trackster_deathOffset = round(Trackster_deathOffset);

	local val = select(1, GetStatistic(60));
	
	if (val == "--") then
		fsDeaths:SetText("Death count: " .. textCol_value .. CommafyNumber(Trackster_deathOffset));
		AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_deathOffset, "deaths", "deaths", 100);
	else
		fsDeaths:SetText("Death count: " .. textCol_value .. CommafyNumber(val + Trackster_deathOffset));
	end
end

local function UpdateKills()
	Trackster_killsOffset = round(Trackster_killsOffset);
		
	fsKills:SetText("Kill count: " .. textCol_value .. CommafyNumber(Trackster_killCounter + Trackster_killsOffset));
	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_deathOffset, "kills", "creatures slain", 1000);
end	

local function UpdateQuests()
	Trackster_questsOffset = round(Trackster_questsOffset);
	fsQuests:SetText("Quest count: " .. textCol_value .. CommafyNumber(Trackster_questCounter + Trackster_questsOffset));
	
	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_questCounter + Trackster_questsOffset, "quests", "quests completed", 100);
end

local function UpdateHearthstones()
	Trackster_HearthstonesOffset = round(Trackster_HearthstonesOffset);
	
	local val = select(1, GetStatistic(353));
	
	if (val == "--") then
		fsHearthstones:SetText("Hearthed: " .. textCol_value .. (Trackster_HearthstonesOffset) .. " times");
	else
		fsHearthstones:SetText("Hearthed: " .. textCol_value .. (val + Trackster_HearthstonesOffset) .. " times");
	end
end	

local function UpdateDmg()
	--Trackster_dmgOffset = round(Trackster_dmgOffset);
	--
	--local val = select(1, GetStatistic(197));
	--
	--if (val == "--") then
	--	fsDmg:SetText("Total dmg: " .. (val));
	--else
	--
	--	val = tonumber(val + Trackster_dmgOffset);
	--	
	--		if(val >= 100000000000) then val = tostring(round(val / 1000000000, 0)) .. "B";
	--    elseif(val >= 10000000000) then val = tostring(round(val / 1000000000, 1)) .. "B";
	--	elseif(val >= 1000000000) then val = tostring(round(val / 1000000, 0)) .. "M";
	--	elseif(val >= 100000000) then val = tostring(round(val / 1000000, 1)) .. "M";
	--	elseif(val >= 100000) then val = tostring(round(val / 1000), 0) .. "K"; 
	--	end
	--	
	--	fsDmg:SetText("Total dmg: " .. (val));
	--end
end

local function UpdateJump()
	Trackster_jumpOffset = round(Trackster_jumpOffset);
	fsJump:SetText("Jump count: " .. textCol_value .. CommafyNumber(Trackster_jumpCounter + Trackster_jumpOffset));
	
	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_jumpCounter + Trackster_jumpOffset, "jumps", "times jumped", 10000);
end

local function UpdateCasts()
	Trackster_castOffset = round(Trackster_castOffset);
	
	local val = Trackster_castCounter + Trackster_castOffset;
	
	if(val >= 100000000000) then val = tostring(round(val / 1000000000, 0)) .. "B";
	elseif(val >= 10000000000) then val = tostring(round(val / 1000000000, 1)) .. "B";
	elseif(val >= 1000000000) then val = tostring(round(val / 1000000, 0)) .. "M";
	elseif(val >= 100000000) then val = tostring(round(val / 1000000, 1)) .. "M";
	elseif(val >= 100000) then val = tostring(round(val / 1000), 0) .. "K"; 
	end
	
	fsCasts:SetText("Cast count: " .. textCol_value .. CommafyNumber(val));

	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_castCounter + Trackster_castOffset, "casts" , "spells casted", 10000);
end

local function UpdateCrits()
	Trackster_critOffset = round(Trackster_critOffset);
	fsCrits:SetText("Crit count: " .. textCol_value .. CommafyNumber(Trackster_critCounter + Trackster_critOffset));

	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_critCounter + Trackster_critOffset, "crits", "critical hits", 10000);
end

local function UpdateLogins()
	Trackster_loginOffset = round(Trackster_loginOffset);
	fsLogins:SetText("Login/Reload count: " .. textCol_value .. CommafyNumber(Trackster_loginCounter + Trackster_loginOffset));

end

local function UpdateBoss()
	Trackster_bossOffset = round(Trackster_bossOffset);
	fsBoss:SetText("Boss count: " .. textCol_value .. CommafyNumber(Trackster_bossCounter + Trackster_bossOffset));

	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_bossCounter + Trackster_bossOffset, "bosses", "bosses slain", 100);
end


local function UpdateIlvl()
	local overall, equipped = GetAverageItemLevel();
	local val = math.floor(equipped + Trackster_IlvlOffset);
	
	
	fsIlvl:SetText("ItemLvl: " .. textCol_value .. val);
end

local function UpdateGold()
	--local val = select(1, GetStatistic(328));
	local valTotal = GetCoinTextureString(Trackster_goldCounter + Trackster_goldOffset);
	fsGold:SetText("Gold total: " .. textCol_value .. valTotal);
	
	local valCurrent = GetCoinTextureString(GetMoney());
	fsGoldCurrent:SetText("Gold current: " .. textCol_value .. valCurrent);
end

local function UpdateChat()
	Trackster_chatOffset = round(Trackster_chatOffset);
	fsChat:SetText("Chat msgs sent: " .. textCol_value .. CommafyNumber(Trackster_chatCounter + Trackster_chatOffset));
	
	AutoAnnounceMilestone_INT_STEADY_IINCR(Trackster_chatCounter + Trackster_chatOffset, "chatMessagesSent", "chat messages sent", 1000);
end

local function UpdateItem()
	Trackster_itemOffset = round(Trackster_itemOffset);
	fsItem:SetText("Items collected: " .. textCol_value .. (Trackster_itemCounter + Trackster_itemOffset));
end

local function UpdateTime()
	Trackster_timeOffset = round(Trackster_timeOffset);
	
	local d, h, m, s = select(1, FormatTime(lastConfirmedTime + internalTimeOffset + Trackster_timeOffset));
	local totalHours = math.floor((lastConfirmedTime + internalTimeOffset + Trackster_timeOffset) / 3600);
	
	fsTime:SetText("Time played: " .. textCol_value .. d .. "d, " .. h .. ":" .. m .. ":" .. s .. " (" .. totalHours .. "h)");
	
	local d, h, m, s = select(1, FormatTime(time() - Trackster_timestampRunBegin));
	fsAbsTime:SetText("Time real: " .. textCol_value .. d .. "d, " .. h .. ":" .. m .. ":" .. s);
	
	AutoAnnounceMilestone_INT_STEADY_IINCR(lastConfirmedTime + internalTimeOffset + Trackster_timeOffset, "timePlayed", "time played", 3600*100);
end


hooksecurefunc( "JumpOrAscendStart", function()
  if (IsFlying() == false and UnitOnTaxi("PLAYER") == false and IsSwimming() == false) then
	Trackster_jumpCounter = Trackster_jumpCounter + 1;
	UpdateJump();
  end
  
  -- Just to keep it up-to-date. The event gets fired too early...
  UpdatePlvl();
end );

Trackster.OffsetDistance = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset; end;
	
	Trackster_distanceTravelledOffset = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetDistance__swam = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset__swam; end;
	
	Trackster_distanceTravelledOffset__swam = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetDistance__walked = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset__walked; end;
	
	Trackster_distanceTravelledOffset__walked = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetDistance__groundmount = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset__groundmount; end;
	
	Trackster_distanceTravelledOffset__groundmount = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetDistance__flight = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset__flight; end;
	
	Trackster_distanceTravelledOffset__flight = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetDistance__taxi = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset__taxi; end;
	
	Trackster_distanceTravelledOffset__taxi = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetDistance__ghost = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset__ghost; end;
	
	Trackster_distanceTravelledOffset__ghost = offset;
	UpdateDistanceTravelled(0,0,true);
end

Trackster.OffsetKills = function(offset)
	if(offset == nil) then return Trackster_killsOffset; end;
	
	Trackster_killsOffset = offset;
	UpdateKills();
end

Trackster.OffsetDeaths = function(offset)
	if(offset == nil) then return Trackster_deathOffset; end;

	Trackster_deathOffset = offset;
	UpdateDeaths();
end

Trackster.OffsetQuests = function(offset)
	if(offset == nil) then return Trackster_questsOffset; end;

	Trackster_questsOffset = offset;
	UpdateQuests();
end

Trackster.OffsetDmg = function(offset)
	--if(offset == nil) then return Trackster_dmgOffset; end;
	--
	--Trackster_dmgOffset = offset;
	--UpdateDmg();
end

Trackster.OffsetJumps = function(offset)
	if(offset == nil) then return Trackster_jumpOffset; end;
	
	Trackster_jumpOffset = offset;
	UpdateJump();
end

Trackster.OffsetCasts = function(offset)
	if(offset == nil) then return Trackster_castOffset; end;
	
	Trackster_castOffset = offset;
	UpdateCasts();
end

Trackster.OffsetGold = function(offset)
	if(offset == nil) then return Trackster_goldOffset; end;
	
	Trackster_goldOffset = offset;
	UpdateGold();
end

Trackster.OffsetCrits = function(offset)
	if(offset == nil) then return Trackster_critOffset; end;
	
	Trackster_critOffset = offset;
	UpdateCrits();
end

Trackster.OffsetLogin = function(offset)
	if(offset == nil) then return Trackster_loginOffset; end;
	
	Trackster_loginOffset = offset;
	UpdateLogins();
end

Trackster.OffsetBoss = function(offset)
	if(offset == nil) then return Trackster_bossOffset; end;
	
	Trackster_bossOffset = offset;
	UpdateBoss();
end

Trackster.OffsetChat = function(offset)
	if(offset == nil) then return Trackster_chatOffset; end;
	
	Trackster_chatOffset = offset;
	UpdateChat();
end

Trackster.OffsetItem = function(offset)
	if(offset == nil) then return Trackster_itemOffset; end;
	
	Trackster_itemOffset = offset;
	UpdateItem();
end

Trackster.OffsetTime = function(offset)
	if(offset == nil) then return Trackster_timeOffset; end;
	
	Trackster_timeOffset = offset;
	UpdateTime();
end

Trackster.OffsetHearthstones = function(offset)
	if(offset == nil) then return Trackster_HearthstonesOffset; end;
	
	Trackster_HearthstonesOffset = offset;
	UpdateHearthstones();
end

local function UpdateAll()
	UpdateDeaths();
	UpdateKills();
	UpdateDistanceTravelled(0,0, true);
	UpdateQuests();
	--UpdateDmg();
	UpdatePlvl();
	UpdateIlvl();
	UpdateGold();
	UpdateCasts();
	UpdateCrits();
	UpdateLogins();
	UpdateBoss();
	UpdateJump();
	UpdateChat();
	UpdateItem();
	UpdateTime();
	UpdateHearthstones();
end
mainFrame:SetScript("OnShow", UpdateAll);

local function ProcessChatMsg(...)
	author = select(2, ...)
	
	if(author == GetUnitName("player") .. "-" .. GetRealmName()) then
		Trackster_chatCounter = Trackster_chatCounter + 1;
		UpdateChat();
	end
end

local function SyncTimePlayedWithBlizzardServer(t)
	lastConfirmedTime = t;
	internalTimeOffset = 0;
	updateOneSecondTimer = 0;
	
	UpdateTime();
end

function UpdateHandler(self, deltaTime)
	UpdateDistanceTravelled(self, deltaTime);
	updateOneSecondTimer = updateOneSecondTimer + deltaTime;
	
	if(updateOneSecondTimer >= 1) then
		updateOneSecondTimer = 0;
		
		internalTimeOffset = internalTimeOffset + 1;
		FormatTime(lastConfirmedTime + internalTimeOffset + Trackster_timeOffset);
		UpdateTime();
	end
end
mainFrame:SetScript("OnUpdate", UpdateHandler);

Trackster.SetFrameScale = function(s)
	mainFrame:SetScale(s);
	buttonX:SetScale(s);
	Trackster_frameScale = round(s, 3);
end

-- This function will return the amount of gold earned when PLAYER_MONEY fires.
local lastGold = 0;
local GetGoldDifference = function()
	local tmp = GetMoney() - lastGold;
	lastGold = GetMoney();
	return tmp;
end

local timeLastQuestCompleted = time() --> This event may fire multiple times per quest turnin -.- so we'll just add a cooldown to it...
local function eventHandler(self, event, ...)

	if (event == "PLAYER_ENTERING_WORLD") then
		UpdateAll();
		RequestTimePlayed();
		GetGoldDifference();
		
	elseif (event == "PLAYER_LOGOUT") then
	
	elseif (event == "PLAYER_LEVEL_UP") then
		UpdatePlvl();
		
	elseif (event == "PLAYER_DEAD") then
		UpdateDeaths();
		
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local type, _, _, source, _, _, dest = select(2, CombatLogGetCurrentEventInfo());

		if(source == GetUnitName("player")) then
		
			if (type == "PARTY_KILL") then
				Trackster_killCounter = Trackster_killCounter + 1;
				PlaySoundFile("Interface\\AddOns\\Trackster\\hurt.wav", "MASTER");
				print(type .. ', ' .. source .. ', ' .. dest);
				UpdateKills();
			
			elseif (type == "SPELL_DAMAGE") then 
				
				isCrit = select(21, CombatLogGetCurrentEventInfo());
				if (isCrit) then
					Trackster_critCounter = Trackster_critCounter + 1;
					UpdateCrits();
					
				end
			--UpdateDmg();
			
			
			elseif (type == "SPELL_PERIODIC_DAMAGE") then UpdateDmg();
			
			elseif (type == "SPELL_CAST_SUCCESS") then 
				Trackster_castCounter = Trackster_castCounter + 1;
				UpdateCasts();
			end
		end
					
		UpdateKills();
		--UpdateDmg();
		
	elseif (event == "QUEST_TURNED_IN") then
		--> This event may fire multiple times per quest turnin -.- so we'll just add a cooldown to it...
		local timeNow = time();
		if (timeNow - timeLastQuestCompleted > 1) then
			print("Quest turned in, fired, and counted!");
			Trackster_questCounter = Trackster_questCounter + 1;
			UpdateQuests();
		else
			print("Quest turned in, fired, but it was ignored as a duplicate!");
		end
		timeLastQuestCompleted = timeNow;

	elseif (event == "PLAYER_EQUIPMENT_CHANGED") then
		UpdateIlvl();
		
	elseif (event == "PLAYER_MONEY") then
		local goldDiff = GetGoldDifference();
		
		if (goldDiff > 0) then
			Trackster_goldCounter = Trackster_goldCounter + goldDiff;
			UpdateGold();
		end
		
	elseif (event == "PLAYER_LOGIN") then
		Trackster_loginCounter = Trackster_loginCounter + 1;
		UpdateLogins();
		
	elseif (event == "BOSS_KILL") then
		Trackster_bossCounter = Trackster_bossCounter + 1;
		UpdateBoss();
		
	elseif (event == "CHAT_MSG_LOOT") then
		local receiver = select(5, ...);
		
		if(receiver == UnitName("player")) then
			Trackster_itemCounter = Trackster_itemCounter + 1;
			UpdateItem();
		end
		
	elseif (event == "QUEST_LOOT_RECEIVED") then
		Trackster_itemCounter = Trackster_itemCounter + 1;
		UpdateItem();
			
	elseif (event == "TIME_PLAYED_MSG") then
		local timePlayed = select(1, ...);
		SyncTimePlayedWithBlizzardServer(timePlayed);

	elseif (event == "LOADING_SCREEN_DISABLED") then
		UpdateHearthstones();
	
		
	elseif (event == "CHAT_MSG_SAY") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_CHANNEL") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_GUILD") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_OFFICER") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_PARTY") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_PARTY_LEADER") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_RAID") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_RAID_LEADER") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_YELL") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_INSTANCE_CHAT") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_INSTANCE_CHAT_LEADER") then ProcessChatMsg(...);
	elseif (event == "CHAT_MSG_WHISPER_INFORM") then
		Trackster_chatCounter = Trackster_chatCounter + 1;
		UpdateChat();
		
	elseif (event == "CINEMATIC_START") then
		mainFrame:Hide();
		buttonX:Hide();
	
	elseif (event == "CINEMATIC_STOP") then
		Trackster.SetRenderMainFrame(Trackster_showMainframe);
	
	elseif (event == "ADDON_LOADED") then
		local addonName = select(1, ...);
		
		if(addonName == "Trackster") then
			if (Trackster_timestampRunBegin == 0) then
				Trackster_timestampRunBegin = time();
			end
			
			mainFrame:SetUserPlaced(true);
			Trackster.SetFrameScale(Trackster_frameScale);
			Trackster.SetRenderMainFrame(Trackster_showMainframe);
			UpdateAll();
		end
	end
end
mainFrame:SetScript("OnEvent", eventHandler);

Trackster.ResetAllStats = function()

	Trackster_jumpCounter = 0;
	Trackster_distanceTravelledCounter = 0;
	Trackster_castCounter = 0;
	Trackster_critCounter = 0;
	Trackster_goldCounter = 0;
	Trackster_loginCounter = 0;
	Trackster_bossCounter = 0;
	Trackster_chatCounter = 0;
	Trackster_itemCounter = 0;
	Trackster_timestampRunBegin = time();
	
	UpdateAll();
end

Trackster.SetRenderMainFrame = function(state)

	if (state == true) then
		mainFrame:Show();
		buttonX:Show();
		Trackster_showMainframe = true;
	else
		mainFrame:Hide();
		Trackster_showMainframe = false;
		buttonX:Hide();
	end
end
buttonX:SetScript("OnClick", function(self) Trackster.SetRenderMainFrame(false) end);


SLASH_Trackster1 = "/Trackster";
SLASH_Trackster2 = "/tr";
SLASH_Trackster3 = "/trackster";
SLASH_Trackster4 = "/tracker";
SLASH_Trackster5 = "/track";
SlashCmdList["Trackster"] = function(msg)
	
	if (msg == "") then
		Trackster.SetRenderMainFrame(InvertBool(Trackster_showMainframe));
	
	elseif (msg == "show") then
		Trackster.SetRenderMainFrame(true);
	
	elseif (msg == "open") then
		Trackster.SetRenderMainFrame(true);
		
	elseif (msg == "hide") then
		Trackster.SetRenderMainFrame(false);
		
	elseif (msg == "close") then
		Trackster.SetRenderMainFrame(false);
		
	elseif (msg == "toggle") then
		Trackster.SetRenderMainFrame(InvertBool(Trackster_showMainframe));
		
	elseif (msg == "pos") then
		mainFrame:SetUserPlaced(false);
		mainFrame:SetPoint("CENTER", 480, 0, UIParent);
		ReloadUI();
		
	elseif (msg == "save") then
		ReloadUI();
		
	elseif (msg == "help") then
		PrintMsg("Aliases for /trackster:");
		PrintMsg("/track");
		PrintMsg("/tr");
		PrintMsg("Commands:");
		PrintMsg("/tr open -> Opens the Trackster window.");
		PrintMsg("/tr close -> Closes the Trackster window.");
		PrintMsg("/tr toggle -> Toggles the Trackster window.");
		PrintMsg("/tr -> Toggles the Trackster window");
		PrintMsg("/tr pos -> Resets the Trackster windows position.");
		PrintMsg("/tr save -> Saves the stats. (Automatically on logout)");
		PrintMsg("/tr help -> Displays this message.");
	else 
		PrintMsg("Unknown command...");
		PrintMsg("Type  /trackster help for a list of commands.")
  end
end 

local enableSDEastereggPartII = false;
SLASH_SDEG1 = "/ur";
SlashCmdList["SDEG"] = function(msg)
	if (msg == "mom gey") then
		print("no u");
		enableSDEastereggPartII = true;
	elseif (msg == "mom and dad gey together") then
		if (enableSDEastereggPartII == true) then
			print("Darn! You might win this time...");
		end
	end
end
