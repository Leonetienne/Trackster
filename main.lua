--[[
	I know, this code looks like ass,
	if you feel personally insulted, feel free to contact /2
]]

local mainFrame = CreateFrame("frame", "TracksterMainFrame", self, BackdropTemplateMixin and "BackdropTemplate");
Trackster = {};

Trackster_jumpCounter = 0;
Trackster_castCounter = 0;
Trackster_critCounter = 0;
Trackster_loginCounter = 0;
Trackster_bossCounter = 0;
Trackster_chatCounter = 0;
Trackster_itemCounter = 0;
Trackster_goldCounter = 0;
Trackster_distanceTravelledCounter = 0;

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
local textMarginB = 20;
local textMarginT = 25;
local textMarginL = 25;

local fsDeaths = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_deathOffset = 0;

local fsKills = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_killsOffset = 0;

local fsDist = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_distanceTravelledOffset = -0;

local fsQuests = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_questsOffset = -0;

--local fsDmg = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
--Trackster_dmgOffset = 0;

local fsJump = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_jumpOffset = 0;

local fsPlvl = mainFrame:CreateFontString(nil, "OVERLAY", textFont);

local fsIlvl = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_IlvlOffset = 0;

local fsGold = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_goldOffset = 0;

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

local fsTime = mainFrame:CreateFontString(nil, "OVERLAY", textFont);
Trackster_timeOffset = 0;
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

mainFrame:SetBackdrop({
      bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", 
      edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
      tile=1, tileSize=32, edgeSize=32, 
      insets={left=11, right=12, top=12, bottom=11}
})

fsKills:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (0 * textMarginB)));
fsDeaths:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (1 * textMarginB)));
fsTime:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (2 * textMarginB)));
fsDist:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (3 * textMarginB)));
fsQuests:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (4 * textMarginB)));
fsPlvl:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (5 * textMarginB)));
fsIlvl:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (6 * textMarginB)));
--fsDmg:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (5 * textMarginB)));
fsGold:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (7 * textMarginB)));
fsBoss:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (8 * textMarginB)));
fsCasts:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (9 * textMarginB)));
fsCrits:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (10 * textMarginB)));
fsLogins:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (11 * textMarginB)));
--fsItem:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (12 * textMarginB)));
fsChat:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (12 * textMarginB)));
fsJump:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (13 * textMarginB)));

mainFrame:SetWidth(220 + textMarginL);
mainFrame:SetHeight((textMarginT * 2) + (textMarginB *  14));
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

function Round(f)
	return math.floor(f+0.5);
end

local timer = 0;
function UpdateDistanceTravelled(self, deltaTime, forceTextUpdate)
	--> Update value in background in every frame
	Trackster_distanceTravelledCounter = Trackster_distanceTravelledCounter + (GetUnitSpeed("PLAYER") * 0.9144 * deltaTime);
	local val = Round(Trackster_distanceTravelledCounter + Trackster_distanceTravelledOffset);
				
	timer = timer + deltaTime;
	local updateDelayS = 1;
	if (val < 5000) then
		updateDelayS = 0.1;
	elseif (val < 10000) then
		updateDelayS = 1;
	else
		updateDelayS = 10;
	end
	
	if (timer >= updateDelayS or forceTextUpdate) then --> Update UI text every deltaTime seconds
		if (val < 10000) then
			fsDist:SetText("Distance travelled: " .. val .. "m");
		else
			fsDist:SetText("Distance travelled: " .. Round(val/1000) .. "km");
		end
		timer = 0;
	end
end

function UpdatePlvl()
	fsPlvl:SetText("Character level: " .. UnitLevel("PLAYER"));
end

function UpdateDeaths()
	Trackster_deathOffset = round(Trackster_deathOffset);

	local val = select(1, GetStatistic(60));
	
	if (val == "--") then
		fsDeaths:SetText("Death count: " .. (val));
	else
		fsDeaths:SetText("Death count: " .. (val + Trackster_deathOffset));
	end
end

local function UpdateKills()
	Trackster_killsOffset = round(Trackster_killsOffset);
	
	local val = select(1, GetStatistic(1197));
	
	if (val == "--") then
		fsKills:SetText("Kill count: " .. (val));
	else
		fsKills:SetText("Kill count: " .. (val + Trackster_killsOffset));
	end
end	

local function UpdateQuests()
	Trackster_questsOffset = round(Trackster_questsOffset);

	local val = select(1, GetStatistic(98));
	
	if (val == "--") then
		fsQuests:SetText("Quest count: " .. (val));
	else
		fsQuests:SetText("Quest count: " .. (val + Trackster_questsOffset));
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
	fsJump:SetText("Jump count: " .. (Trackster_jumpCounter + Trackster_jumpOffset));

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
	
	fsCasts:SetText("Cast count: " .. val);

end

local function UpdateCrits()
	Trackster_critOffset = round(Trackster_critOffset);
	fsCrits:SetText("Crit count: " .. (Trackster_critCounter + Trackster_critOffset));

end

local function UpdateLogins()
	Trackster_loginOffset = round(Trackster_loginOffset);
	fsLogins:SetText("Login count: " .. (Trackster_loginCounter + Trackster_loginOffset));

end

local function UpdateBoss()
	Trackster_bossOffset = round(Trackster_bossOffset);
	fsBoss:SetText("Boss count: " .. (Trackster_bossCounter + Trackster_bossOffset));

end


local function UpdateIlvl()
	local overall, equipped = GetAverageItemLevel();
	local val = math.floor(equipped + Trackster_IlvlOffset);
	
	
	fsIlvl:SetText("ItemLvl: " .. val);
end

local function UpdateGold()
	--local val = select(1, GetStatistic(328));
	local val = GetCoinTextureString(Trackster_goldCounter + Trackster_goldOffset);
	fsGold:SetText("Gold total: " .. val);
end

local function UpdateChat()
	Trackster_chatOffset = round(Trackster_chatOffset);
	fsChat:SetText("Chat msgs sent: " .. (Trackster_chatCounter + Trackster_chatOffset));
end

local function UpdateItem()
	Trackster_itemOffset = round(Trackster_itemOffset);
	fsItem:SetText("Items collected: " .. (Trackster_itemCounter + Trackster_itemOffset));
end

local function UpdateTime()
	Trackster_timeOffset = round(Trackster_timeOffset);
	
	local d, h, m, s = select(1, FormatTime(lastConfirmedTime + internalTimeOffset + Trackster_timeOffset));
	
	fsTime:SetText("Time played: " .. d .. ":" .. h .. ":" .. m .. ":" .. s);
end


hooksecurefunc( "JumpOrAscendStart", function()
  if (IsFlying() == false and UnitOnTaxi("PLAYER") == false and IsSwimming() == false) then
	Trackster_jumpCounter = Trackster_jumpCounter + 1;
	UpdateJump();
  end
end );

Trackster.OffsetDistance = function(offset)
	if(offset == nil) then return Trackster_distanceTravelledOffset; end;
	
	Trackster_distanceTravelledOffset = offset;
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
end
mainFrame:SetScript("OnShow", UpdateAll);

local function ProcessChatMsg(...)
	
	author = select(2, ...);
	
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
		local type, fo, foo, source = select(2, CombatLogGetCurrentEventInfo());

		if(source == GetUnitName("player")) then
		
			if (type == "UNIT_DIED") then UpdateKills();
			
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
		UpdateQuests();
		
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
