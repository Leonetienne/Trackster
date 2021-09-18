local optionsFrame = CreateFrame("frame");
optionsFrame.name = "Trackster";
optionsFrame:RegisterEvent("ADDON_LOADED");

local resetSafeword = "Diddly-squat";
local isResetPrimed = false;

local areDefValsLoaded = false;

InterfaceOptions_AddCategory(optionsFrame);

local function InvertBool(b)
	if (b == true) then 
		return false;
	else 
		return true;
	end
end

local buttonApply = CreateFrame("Button", nil, optionsFrame);
buttonApply:SetPoint("CENTER", optionsFrame, "BOTTOMRIGHT", -50, 20);
buttonApply:SetWidth(80);
buttonApply:SetHeight(21);
buttonApply:SetText("Apply");
buttonApply:SetNormalFontObject("GameFontNormal");

local buttonReset = CreateFrame("Button", nil, optionsFrame);
buttonReset:SetWidth(105);
buttonReset:SetHeight(21);
buttonReset:SetText("Reset all stats");
buttonReset:SetNormalFontObject("GameFontNormal");
buttonReset:SetEnabled(false);

local buttonShowhide = CreateFrame("Button", "Trackster_ButtonShowHide", optionsFrame);
buttonShowhide:SetPoint("CENTER", optionsFrame, "BOTTOMRIGHT", -50, 45);
buttonShowhide:SetWidth(80);
buttonShowhide:SetHeight(21);
buttonShowhide:SetText("Show/Hide");
buttonShowhide:SetNormalFontObject("GameFontNormal");
buttonShowhide:SetEnabled(true);
buttonShowhide:SetScript("OnClick", function(self) Trackster.SetRenderMainFrame(InvertBool(Trackster_showMainframe)) end);

local ntexA = buttonApply:CreateTexture();
ntexA:SetTexture("Interface/Buttons/UI-Panel-Button-Up");
ntexA:SetTexCoord(0, 0.625, 0, 0.6875);
ntexA:SetAllPoints()	;
buttonApply:SetNormalTexture(ntexA);

local htexA = buttonApply:CreateTexture()
htexA:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight");
htexA:SetTexCoord(0, 0.625, 0, 0.6875);
htexA:SetAllPoints();
buttonApply:SetHighlightTexture(htexA);

local ptexA = buttonApply:CreateTexture();
ptexA:SetTexture("Interface/Buttons/UI-Panel-Button-Down");
ptexA:SetTexCoord(0, 0.625, 0, 0.6875);
ptexA:SetAllPoints();
buttonApply:SetPushedTexture(ptexA);
----------------------------------------
local htexR = buttonReset:CreateTexture()
htexR:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight");
htexR:SetTexCoord(0, 0.625, 0, 0.6875);
htexR:SetAllPoints();
buttonReset:SetHighlightTexture(htexR);

local ptexR = buttonReset:CreateTexture();
ptexR:SetTexture("Interface/Buttons/UI-Panel-Button-Down");
ptexR:SetTexCoord(0, 0.625, 0, 0.6875);
ptexR:SetAllPoints();
buttonReset:SetPushedTexture(ptexR);

local ntexR = buttonReset:CreateTexture();
ntexR:SetTexture("Interface/Buttons/UI-Panel-Button-Up");
ntexR:SetTexCoord(0, 0.625, 0, 0.6875);
ntexR:SetAllPoints()	;
buttonReset:SetNormalTexture(ntexR);
----------------------------------------
local htexS = buttonShowhide:CreateTexture()
htexS:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight");
htexS:SetTexCoord(0, 0.625, 0, 0.6875);
htexS:SetAllPoints();
buttonShowhide:SetHighlightTexture(htexS);

local ptexS = buttonShowhide:CreateTexture();
ptexS:SetTexture("Interface/Buttons/UI-Panel-Button-Down");
ptexS:SetTexCoord(0, 0.625, 0, 0.6875);
ptexS:SetAllPoints();
buttonShowhide:SetPushedTexture(ptexS);

local ntexS = buttonShowhide:CreateTexture();
ntexS:SetTexture("Interface/Buttons/UI-Panel-Button-Up");
ntexS:SetTexCoord(0, 0.625, 0, 0.6875);
ntexS:SetAllPoints()	;
buttonShowhide:SetNormalTexture(ntexS);


local textFont = "GameFontWhite";
local textMarginB = 27.5;
local textMarginT = 25;
local textMarginL = 25;
local textMarginLC2 = textMarginL + 300;
local editboxMarginL = 150;
local editboxMarginLC2 = textMarginLC2 + 125;  --> second column

local fsInfo = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
fsInfo:SetText("Thanks for using Trackster!\nPlease note, that some stats are only tracked by this AddOn, hence only count\n upwards from the point of installation. If you want some stats to be tracked\naccount wide, just change them in the .toc file in the AddOn folder!\nHave fun! -Allpi");
fsInfo:SetPoint("CENTER", 0, -230);

local fsKills = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDeaths = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsQuests = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
--local fsDmg = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsCasts = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsGold = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsCrits = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsLogins = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsBoss = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsItem = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsChat = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsJump = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsTime = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsHearthstones = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsTimeRunBegin = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsScale = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist__swam = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist__walked = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist__groundmount = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist__flight = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist__taxi = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
local fsDist__ghost = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);

fsKills:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (0 * textMarginB)))
fsDeaths:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (1 * textMarginB)))
fsTime:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (2 * textMarginB)))
fsTimeRunBegin:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (3 * textMarginB)))
fsDist:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (4 * textMarginB)))
fsQuests:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (5 * textMarginB)))
--fsDmg:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (4 * textMarginB)))
fsBoss:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (6 * textMarginB)))
fsCasts:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (7 * textMarginB)))
fsGold:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (8 * textMarginB)))
fsCrits:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (9 * textMarginB)))
fsLogins:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (10 * textMarginB)))
fsItem:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (11 * textMarginB)))
fsChat:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (12 * textMarginB)))
fsJump:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (13 * textMarginB)))
fsScale:SetPoint("TOPLEFT", textMarginL, -(textMarginT + (14 * textMarginB)))

fsHearthstones:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (0 * textMarginB)))
fsDist__swam:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (1 * textMarginB)))
fsDist__walked:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (2 * textMarginB)))
fsDist__groundmount:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (3 * textMarginB)))
fsDist__flight:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (4 * textMarginB)))
fsDist__taxi:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (5 * textMarginB)))
fsDist__ghost:SetPoint("TOPLEFT", textMarginLC2, -(textMarginT + (6 * textMarginB)))

buttonReset:SetPoint("TOPLEFT", textMarginL - 5, -(textMarginT + ((15 + 0.2) * textMarginB)));

fsKills:SetText("Kills offset:");
fsDeaths:SetText("Deaths offset:");
fsTime:SetText("Time played offset:");
fsTimeRunBegin:SetText("Started run at:");
fsDist:SetText("Distance(m) offset:");
fsQuests:SetText("Quests offset:");
--fsDmg:SetText("Damage offset:");
fsJump:SetText("Jumps offset:");
fsCasts:SetText("Cast offset:");
fsGold:SetText("Gold offset:");
fsCrits:SetText("Crit offset:");
fsLogins:SetText("Logins offset:");
fsBoss:SetText("Bosskills offset:");
fsChat:SetText("Chat msg offset:");
fsItem:SetText("Items offset:");
fsScale:SetText("Frame scale:");
fsHearthstones:SetText("Hearthed offset:");
fsDist__swam:SetText("Dist swam offset:");
fsDist__walked:SetText("Dist foot offset:");
fsDist__groundmount:SetText("Dist rode offset:");
fsDist__flight:SetText("Dist flew offset:");
fsDist__taxi:SetText("Dist taxi offset:");
fsDist__ghost:SetText("Dist ghost offset:");

local maxCharacters = 12;
local ebWidth = 110;

local ebKills = CreateFrame("EditBox", "editboxOffsetKills", optionsFrame, "InputBoxTemplate");
ebKills:SetFrameStrata("DIALOG");
ebKills:SetSize(ebWidth,21);
ebKills:SetMaxLetters(maxCharacters);
ebKills:SetAutoFocus(false);
ebKills:SetNumeric(false);

local ebDeaths = CreateFrame("EditBox", "editboxOffsetDeaths", optionsFrame, "InputBoxTemplate");
ebDeaths:SetFrameStrata("DIALOG");
ebDeaths:SetSize(ebWidth,21);
ebDeaths:SetMaxLetters(maxCharacters);
ebDeaths:SetAutoFocus(false);
ebDeaths:SetNumeric(false);

local ebDist = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist:SetFrameStrata("DIALOG");
ebDist:SetSize(ebWidth,21);
ebDist:SetMaxLetters(maxCharacters);
ebDist:SetAutoFocus(false);
ebDist:SetNumeric(false);

local ebDist__swam = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist__swam:SetFrameStrata("DIALOG");
ebDist__swam:SetSize(ebWidth,21);
ebDist__swam:SetMaxLetters(maxCharacters);
ebDist__swam:SetAutoFocus(false);
ebDist__swam:SetNumeric(false);

local ebDist__walked = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist__walked:SetFrameStrata("DIALOG");
ebDist__walked:SetSize(ebWidth,21);
ebDist__walked:SetMaxLetters(maxCharacters);
ebDist__walked:SetAutoFocus(false);
ebDist__walked:SetNumeric(false);

local ebDist__groundmount = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist__groundmount:SetFrameStrata("DIALOG");
ebDist__groundmount:SetSize(ebWidth,21);
ebDist__groundmount:SetMaxLetters(maxCharacters);
ebDist__groundmount:SetAutoFocus(false);
ebDist__groundmount:SetNumeric(false);

local ebDist__flight = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist__flight:SetFrameStrata("DIALOG");
ebDist__flight:SetSize(ebWidth,21);
ebDist__flight:SetMaxLetters(maxCharacters);
ebDist__flight:SetAutoFocus(false);
ebDist__flight:SetNumeric(false);

local ebDist__taxi = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist__taxi:SetFrameStrata("DIALOG");
ebDist__taxi:SetSize(ebWidth,21);
ebDist__taxi:SetMaxLetters(maxCharacters);
ebDist__taxi:SetAutoFocus(false);
ebDist__taxi:SetNumeric(false);

local ebDist__ghost = CreateFrame("EditBox", "editboxOffsetDist", optionsFrame, "InputBoxTemplate");
ebDist__ghost:SetFrameStrata("DIALOG");
ebDist__ghost:SetSize(ebWidth,21);
ebDist__ghost:SetMaxLetters(maxCharacters);
ebDist__ghost:SetAutoFocus(false);
ebDist__ghost:SetNumeric(false);

local ebQuests = CreateFrame("EditBox", "editboxOffsetQuests", optionsFrame, "InputBoxTemplate");
ebQuests:SetNumeric(false);
ebQuests:SetFrameStrata("DIALOG");
ebQuests:SetSize(ebWidth,21);
ebQuests:SetMaxLetters(maxCharacters);
ebQuests:SetAutoFocus(false);
ebQuests:SetNumeric(false);

--local ebDmg = CreateFrame("EditBox", "editboxOffsetDmg", optionsFrame, "InputBoxTemplate");
--ebDmg:SetFrameStrata("DIALOG");
--ebDmg:SetSize(ebWidth,21);
--ebDmg:SetMaxLetters(maxCharacters);
--ebDmg:SetAutoFocus(false);
--ebDmg:SetNumeric(false);

local ebBoss = CreateFrame("EditBox", "editboxOffsetBoss", optionsFrame, "InputBoxTemplate");
ebBoss:SetFrameStrata("DIALOG");
ebBoss:SetSize(ebWidth,21);
ebBoss:SetMaxLetters(maxCharacters);
ebBoss:SetAutoFocus(false);
ebBoss:SetNumeric(false);

local ebCast = CreateFrame("EditBox", "editboxOffsetCast", optionsFrame, "InputBoxTemplate");
ebCast:SetFrameStrata("DIALOG");
ebCast:SetSize(ebWidth,21);
ebCast:SetMaxLetters(maxCharacters);
ebCast:SetAutoFocus(false);
ebCast:SetNumeric(false);

local ebGold = CreateFrame("EditBox", "editboxOffsetGold", optionsFrame, "InputBoxTemplate");
ebGold:SetFrameStrata("DIALOG");
ebGold:SetSize(ebWidth,21);
ebGold:SetMaxLetters(maxCharacters);
ebGold:SetAutoFocus(false);
ebGold:SetNumeric(false);

local ebCrit = CreateFrame("EditBox", "editboxOffsetCrit", optionsFrame, "InputBoxTemplate");
ebCrit:SetFrameStrata("DIALOG");
ebCrit:SetSize(ebWidth,21);
ebCrit:SetMaxLetters(maxCharacters);
ebCrit:SetAutoFocus(false);
ebCrit:SetNumeric(false);

local ebLogin = CreateFrame("EditBox", "editboxOffsetLogin", optionsFrame, "InputBoxTemplate");
ebLogin:SetFrameStrata("DIALOG");
ebLogin:SetSize(ebWidth,21);
ebLogin:SetMaxLetters(maxCharacters);
ebLogin:SetAutoFocus(false);
ebLogin:SetNumeric(false);

local ebJumps = CreateFrame("EditBox", "editboxOffsetJumps", optionsFrame, "InputBoxTemplate");
ebJumps:SetFrameStrata("DIALOG");
ebJumps:SetSize(ebWidth,21);
ebJumps:SetMaxLetters(maxCharacters);
ebJumps:SetAutoFocus(false);
ebJumps:SetNumeric(false);

local ebChat = CreateFrame("EditBox", "editboxOffsetChat", optionsFrame, "InputBoxTemplate");
ebChat:SetFrameStrata("DIALOG");
ebChat:SetSize(ebWidth,21);
ebChat:SetMaxLetters(maxCharacters);
ebChat:SetAutoFocus(false);
ebChat:SetNumeric(false);

local ebItem = CreateFrame("EditBox", "editboxOffsetItem", optionsFrame, "InputBoxTemplate");
ebItem:SetFrameStrata("DIALOG");
ebItem:SetSize(ebWidth,21);
ebItem:SetMaxLetters(maxCharacters);
ebItem:SetAutoFocus(false);
ebItem:SetNumeric(false);

local ebTime = CreateFrame("EditBox", "editboxOffsetTime", optionsFrame, "InputBoxTemplate");
ebTime:SetFrameStrata("DIALOG");
ebTime:SetSize(ebWidth,21);
ebTime:SetMaxLetters(maxCharacters);
ebTime:SetAutoFocus(false);
ebTime:SetNumeric(false);

local ebTimeRunStarted = CreateFrame("EditBox", "editboxOffsetTime", optionsFrame, "InputBoxTemplate");
ebTimeRunStarted:SetFrameStrata("DIALOG");
ebTimeRunStarted:SetSize(ebWidth,21);
ebTimeRunStarted:SetMaxLetters(maxCharacters);
ebTimeRunStarted:SetAutoFocus(false);
ebTimeRunStarted:SetNumeric(false);

local ebReset = CreateFrame("EditBox", "editboxConfirmReset", optionsFrame, "InputBoxTemplate");
ebReset:SetFrameStrata("DIALOG");
ebReset:SetSize(ebWidth,21);
ebReset:SetMaxLetters(maxCharacters);
ebReset:SetAutoFocus(false);
ebReset:SetNumeric(false);

local ebScale = CreateFrame("EditBox", "editboxConfirmScale", optionsFrame, "InputBoxTemplate");
ebScale:SetFrameStrata("DIALOG");
ebScale:SetSize(ebWidth,21);
ebScale:SetMaxLetters(maxCharacters);
ebScale:SetAutoFocus(false);
ebScale:SetNumeric(false);

local ebHearthstones = CreateFrame("EditBox", "editboxConfirmScale", optionsFrame, "InputBoxTemplate");
ebHearthstones:SetFrameStrata("DIALOG");
ebHearthstones:SetSize(ebWidth,21);
ebHearthstones:SetMaxLetters(maxCharacters);
ebHearthstones:SetAutoFocus(false);
ebHearthstones:SetNumeric(false);


local fsResetInfo = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontWhite");
fsResetInfo:SetText("<- Enter \"" .. resetSafeword .. "\" to enable the reset function.");

local fsTimeUNIT = optionsFrame:CreateFontString(nil, "OVERLAY", textFont);
fsTimeUNIT:SetText("seconds");

ebKills:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (0 * textMarginB)));
ebDeaths:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (1 * textMarginB)));
ebTime:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (2 * textMarginB)));
ebTimeRunStarted:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (3 * textMarginB)));
ebDist:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (4 * textMarginB)));
ebQuests:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (5 * textMarginB)));
--ebDmg:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (4 * textMarginB)));
ebBoss:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (6 * textMarginB)));
ebCast:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (7 * textMarginB)));
ebGold:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (8 * textMarginB)));
ebCrit:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (9 * textMarginB)));
ebLogin:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (10 * textMarginB)));
ebItem:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (11 * textMarginB)));
ebChat:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (12 * textMarginB)));
ebJumps:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (13 * textMarginB)));
ebScale:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + (14 * textMarginB)));

ebHearthstones:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (0 * textMarginB)));
ebDist__swam:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (1 * textMarginB)));
ebDist__walked:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (2 * textMarginB)));
ebDist__groundmount:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (3 * textMarginB)));
ebDist__flight:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (4 * textMarginB)));
ebDist__taxi:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (5 * textMarginB)));
ebDist__ghost:SetPoint("TOPLEFT", editboxMarginLC2, -(textMarginT + (6 * textMarginB)));

ebReset:SetPoint("TOPLEFT", editboxMarginL, -(textMarginT + ((15 + 0.2) * textMarginB)));
fsTimeUNIT:SetPoint("TOPLEFT", editboxMarginL * 1.75, -(textMarginT + ((2 + 0.2) * textMarginB) - 2));
fsResetInfo:SetPoint("TOPLEFT", editboxMarginL * 1.85, -(textMarginT + ((15 + 0.2) * textMarginB) + 5));

local function CheckIfICanPrimeReset()
	
	if(ebReset:GetText() == resetSafeword) then
		isResetPrimed = true;
	else
		isResetPrimed = false;
	end
end
ebReset:SetScript("OnTextChanged", CheckIfICanPrimeReset);

local function SetResetButtonEnabled(state)

	if(state == false) then
		buttonReset:SetNormalTexture(dtexR);
		buttonReset:SetEnabled(false);
	else
		buttonReset:SetNormalTexture(ntexR);
		buttonReset:SetEnabled(true);
	end
end

SetResetButtonEnabled(true);

local function eventHandler(self, event, ...)

	if(event == "ADDON_LOADED") then
		local name = select(1, ...);
		if(name == "Trackster") then

		end
	end
end
optionsFrame:SetScript("OnEvent", eventHandler);

local function LoadDefaultTexts(doAnways)
	if (doAnways == nil) then doAnways = false; end
	if (doAnways == true) then areDefValsLoaded = false; end
	
	if (areDefValsLoaded == false) then
		ebKills:SetText(Trackster.OffsetKills());
		ebDeaths:SetText(Trackster.OffsetDeaths());
		ebDist:SetText(Trackster.OffsetDistance());
		ebQuests:SetText(Trackster.OffsetQuests());
		--ebDmg:SetText(Trackster.OffsetDmg());
		ebBoss:SetText(Trackster.OffsetBoss());
		ebCast:SetText(Trackster.OffsetCasts());
		ebGold:SetText(Trackster.OffsetGold());
		ebCrit:SetText(Trackster.OffsetCrits());
		ebLogin:SetText(Trackster.OffsetLogin());
		ebItem:SetText(Trackster.OffsetItem());
		ebChat:SetText(Trackster.OffsetChat());
		ebJumps:SetText(Trackster.OffsetJumps());
		ebTime:SetText(Trackster.OffsetTime());
		ebHearthstones:SetText(Trackster.OffsetHearthstones());
		ebTimeRunStarted:SetText(Trackster_timestampRunBegin);
		ebScale:SetText(Trackster_frameScale);
		ebDist__swam:SetText(Trackster.OffsetDistance__swam());
		ebDist__walked:SetText(Trackster.OffsetDistance__walked());
		ebDist__groundmount:SetText(Trackster.OffsetDistance__groundmount());
		ebDist__flight:SetText(Trackster.OffsetDistance__flight());
		ebDist__taxi:SetText(Trackster.OffsetDistance__taxi());
		ebDist__ghost:SetText(Trackster.OffsetDistance__ghost());
		
		areDefValsLoaded = true;
	end
end
optionsFrame:SetScript("OnShow", LoadDefaultTexts);
optionsFrame:SetScript("OnEnter", LoadDefaultTexts);

buttonReset:SetScript("OnClick", function(self)
	
	if (isResetPrimed == true) then
		Trackster.ResetAllStats();
		LoadDefaultTexts(true); 
		isResetPrimed = false;
		ebReset:ClearFocus();
		ebReset:SetText("");
		message("All stats counted by this addon have been reset.");
	else
		message("Reset blocked!\nPlease enter the safeword!");
	end
end);

local function UpdateOffsets()

	ebKills:ClearFocus();
	ebDeaths:ClearFocus();
	ebDist:ClearFocus();
	ebQuests:ClearFocus();
	--ebDmg:ClearFocus();
	ebBoss:ClearFocus();
	ebCast:ClearFocus();
	ebGold:ClearFocus();
	ebCrit:ClearFocus();
	ebLogin:ClearFocus();
	ebItem:ClearFocus();
	ebChat:ClearFocus();
	ebJumps:ClearFocus();
	ebTime:ClearFocus();
	ebHearthstones:ClearFocus();
	ebTimeRunStarted:ClearFocus();
	ebDist__swam:ClearFocus();
	ebDist__walked:ClearFocus();
	ebDist__groundmount:ClearFocus();
	ebDist__flight:ClearFocus();
	ebDist__taxi:ClearFocus();
	ebDist__ghost:ClearFocus();
	ebScale:ClearFocus();
	
	Trackster.SetFrameScale(ebScale:GetNumber());
	Trackster.OffsetKills(ebKills:GetNumber());
	Trackster.OffsetDeaths(ebDeaths:GetNumber());
	Trackster.OffsetDistance(ebDist:GetNumber());
	Trackster.OffsetQuests(ebQuests:GetNumber());
	--Trackster.OffsetDmg(ebDmg:GetNumber());
	Trackster.OffsetBoss(ebBoss:GetNumber());
	Trackster.OffsetCasts(ebCast:GetNumber());
	Trackster.OffsetGold(ebGold:GetNumber());
	Trackster.OffsetCrits(ebCrit:GetNumber());
	Trackster.OffsetLogin(ebLogin:GetNumber());
	Trackster.OffsetItem(ebItem:GetNumber());
	Trackster.OffsetChat(ebChat:GetNumber());
	Trackster.OffsetJumps(ebJumps:GetNumber());
	Trackster.OffsetTime(ebTime:GetNumber());
	Trackster.OffsetHearthstones(ebHearthstones:GetNumber());
	Trackster.OffsetDistance__swam(ebDist__swam:GetNumber());
	Trackster.OffsetDistance__walked(ebDist__walked:GetNumber());
	Trackster.OffsetDistance__groundmount(ebDist__groundmount:GetNumber());
	Trackster.OffsetDistance__flight(ebDist__flight:GetNumber());
	Trackster.OffsetDistance__taxi(ebDist__taxi:GetNumber());
	Trackster.OffsetDistance__ghost(ebDist__ghost:GetNumber());
	Trackster_timestampRunBegin = ebTimeRunStarted:GetNumber();
	
	
	LoadDefaultTexts(true);
end

buttonApply:SetScript("OnClick", UpdateOffsets);
ebKills:SetScript("OnEnterPressed", UpdateOffsets);
ebDeaths:SetScript("OnEnterPressed", UpdateOffsets);
ebTime:SetScript("OnEnterPressed", UpdateOffsets);
ebDist:SetScript("OnEnterPressed", UpdateOffsets);
ebQuests:SetScript("OnEnterPressed", UpdateOffsets);
--ebDmg:SetScript("OnEnterPressed", UpdateOffsets);
ebBoss:SetScript("OnEnterPressed", UpdateOffsets);
ebCast:SetScript("OnEnterPressed", UpdateOffsets);
ebGold:SetScript("OnEnterPressed", UpdateOffsets);
ebCrit:SetScript("OnEnterPressed", UpdateOffsets);
ebLogin:SetScript("OnEnterPressed", UpdateOffsets);
ebItem:SetScript("OnEnterPressed", UpdateOffsets);
ebTimeRunStarted:SetScript("OnEnterPressed", UpdateOffsets);
ebChat:SetScript("OnEnterPressed", UpdateOffsets);
ebJumps:SetScript("OnEnterPressed", UpdateOffsets);
ebHearthstones:SetScript("OnEnterPressed", UpdateOffsets);
ebDist__swam:SetScript("OnEnterPressed", UpdateOffsets);
ebDist__walked:SetScript("OnEnterPressed", UpdateOffsets);
ebDist__groundmount:SetScript("OnEnterPressed", UpdateOffsets);
ebDist__flight:SetScript("OnEnterPressed", UpdateOffsets);
ebDist__taxi:SetScript("OnEnterPressed", UpdateOffsets);
ebDist__ghost:SetScript("OnEnterPressed", UpdateOffsets);
ebScale:SetScript("OnEnterPressed", UpdateOffsets);
