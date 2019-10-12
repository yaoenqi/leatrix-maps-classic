
	----------------------------------------------------------------------
	-- 	Leatrix Maps 1.13.05 (8th August 2019, www.leatrix.com)
	----------------------------------------------------------------------

	-- 10:Func, 20:Comm, 30:Evnt, 40:Panl

	-- Create global table
	_G.LeaMapsDB = _G.LeaMapsDB or {}

	-- Create local tables
	local LeaMapsLC, LeaMapsCB = {}, {}

	-- Version
	LeaMapsLC["AddonVer"] = "1.13.05"
	LeaMapsLC["RestartReq"] = nil

	-- If client restart is required and has not been done, show warning and quit
	if LeaMapsLC["RestartReq"] then
		local metaVer = GetAddOnMetadata("Leatrix_Maps", "Version")
		if metaVer and metaVer ~= LeaMapsLC["AddonVer"] then
			C_Timer.After(1, function()
				print("NOTICE!|nYou must fully restart your game client before you can use this version of Leatrix Maps.")
			end)
			return
		end
	end

	-- Get locale table
	local void, Leatrix_Maps = ...
	local L = Leatrix_Maps.L

	----------------------------------------------------------------------
	-- L00: Leatrix Maps
	----------------------------------------------------------------------

	-- Main function
	function LeaMapsLC:MainFunc()

		-- Get player faction
		local playerFaction = UnitFactionGroup("player")

		----------------------------------------------------------------------
		-- Show dungeon location icons
		----------------------------------------------------------------------

		do

			local dnTex, rdTex = "Dungeon", "Raid"
			local pATex, pHTex, pNTex = "TaxiNode_Continent_Alliance", "TaxiNode_Continent_Horde", "TaxiNode_Continent_Neutral"
			local chTex = "ChallengeMode-icon-chest"

			local PinData = {

				-- Eastern Kingdoms
				[1418] =  --[[Badlands]] {{42.6, 10.8, L["Uldaman"], L["Dungeon"], dnTex},},
				[1420] =  --[[Tirisfal Glades]] {{83.5, 32.0, L["Scarlet Monastery"], L["Dungeon"], dnTex},},
				[1421] =  --[[Silverpine Forest]] {{42.6, 66.6, L["Shadowfang Keep"], L["Dungeon"], dnTex},},
				[1422] =  --[[Western Plaguelands]] {{69.8, 76.0, L["Scholomance"], L["Dungeon"], dnTex},},
				[1423] =  --[[Eastern Plaguelands]] {{30.9, 15.2, L["Stratholme (Main Entrance)"], L["Dungeon"], dnTex}, {48.3, 21.8, L["Stratholme (Side Entrance)"], L["Dungeon"], dnTex}, {28.9, 11.7, L["Naxxramas"], L["Raid"], rdTex},},
				[1426] =  --[[Dun Morogh]] {{30.5, 36.3, L["Gnomeregan"], L["Dungeon"], dnTex},},
				[1427] =  --[[Searing Gorge]] {{35.2, 84.2, L["Blackrock Mountain"], L["Blackrock Depths"] .. ", " .. L["Lower Blackrock Spire"] .. ", " .. L["Upper Blackrock Spire"] .. ", " .. L["Molten Core"] .. ", " .. L["Blackwing Lair"], dnTex},},
				[1434] =  --[[Stranglethorn Vale]] {{51.9, 17.5, L["Zul'Gurub"], L["Raid"], rdTex},},
				[1435] =  --[[Swamp of Sorrows]] {{69.6, 53.2, L["Temple of Atal'Hakkar"], L["Dungeon"], dnTex},},
				[1436] =  --[[Westfall]] {{42.4, 70.4, L["The Deadmines"], L["Dungeon"], dnTex},},
				[1453] =  --[[Stormwind City]] {{41.0, 57.0, L["The Stockade"], L["Dungeon"], dnTex},},

				-- Kalimdor
				[1413] =  --[[The Barrens]] {{45.5, 35.5, L["Wailing Caverns"], L["Dungeon"], dnTex}, {42.6, 88.5, L["Razorfen Kraul"], L["Dungeon"], dnTex}, {50.0, 92.0, L["Razorfen Downs"], L["Dungeon"], dnTex},},
				[1440] =  --[[Ashenvale]] {{13.4, 12.8, L["Blackfathom Deeps"], L["Dungeon"], dnTex},},
				[1443] =  --[[Maraudon]] {{29.5, 57.8, L["Maraudon"], L["Dungeon"], dnTex},},
				[1444] =  --[[Feralas]] {{58.9, 41.5, L["Dire Maul"], L["Dungeon"], dnTex},},
				[1445] =  --[[Dustwallow Marsh]] {{53.5, 75.6, L["Onyxia's Lair"], L["Raid"], rdTex},},
				[1446] =  --[[Tanaris]] {{39.5, 21.3, L["Zul'Farrak"], L["Dungeon"], dnTex},},
				[1451] =  --[[Silithus]] {{28.6, 92.4, L["Ahn'Qiraj"], L["Ruins of Ahn'Qiraj"] .. ", " .. L["Temple of Ahn'Qiraj"], rdTex},},
				[1454] =  --[[Orgrimmar]] {{50.9, 51.5, L["Ragefire Chasm"], L["Dungeon"], dnTex},},

			}

			local LeaMix = CreateFromMixins(MapCanvasDataProviderMixin)

			function LeaMix:RefreshAllData()

				-- Remove all pins created by Leatrix Maps
				self:GetMap():RemoveAllPinsByTemplate("LeaMapsGlobalPinTemplate")

				-- Show new pins if option is enabled
				if LeaMapsLC["ShowIcons"] == "On" then

					-- Make new pins
					local pMapID = WorldMapFrame.mapID
					if PinData[pMapID] then
						local count = #PinData[pMapID]
						for i = 1, count do

							-- Do nothing if pinInfo has no entry for zone we are looking at
							local pinInfo = PinData[pMapID][i]
							if not pinInfo then return nil end

							-- Get POI if any quest requirements have been met
							if not pinInfo[6] or pinInfo[6] and not pinInfo[7] and IsQuestFlaggedCompleted(pinInfo[6]) or pinInfo[6] and pinInfo[7] and IsQuestFlaggedCompleted(pinInfo[6]) and not IsQuestFlaggedCompleted(pinInfo[7]) then
								if playerFaction == "Alliance" and pinInfo[5] ~= pHTex or playerFaction == "Horde" and pinInfo[5] ~= pATex then
									local myPOI = {}
									myPOI["position"] = CreateVector2D(pinInfo[1] / 100, pinInfo[2] / 100)
									myPOI["name"] = pinInfo[3]
									myPOI["description"] = pinInfo[4]
									myPOI["atlasName"] = pinInfo[5]
									self:GetMap():AcquirePin("LeaMapsGlobalPinTemplate", myPOI)
								end
							end
						end
					end

				end

			end

			LeaMapsGlobalPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE")

			function LeaMapsGlobalPinMixin:OnAcquired(myInfo)
				BaseMapPoiPinMixin.OnAcquired(self, myInfo)
			end

			WorldMapFrame:AddDataProvider(LeaMix)

			-- Toggle icons when option is clicked
			LeaMapsCB["ShowIcons"]:HookScript("OnClick", function() LeaMix:RefreshAllData() end)

		end

		----------------------------------------------------------------------
		-- Reveal unexplored areas
		----------------------------------------------------------------------

		-- Create table to store revealed overlays
		local overlayTextures = {}

		-- Function to refresh overlays (Blizzard_SharedMapDataProviders\MapExplorationDataProvider)
		local function MapExplorationPin_RefreshOverlays(pin, fullUpdate)
			overlayTextures = {}
			local mapID = WorldMapFrame.mapID; if not mapID then return end
			local artID = C_Map.GetMapArtID(mapID); if not artID or not Leatrix_Maps["Reveal"][artID] then return end
			local LeaMapsZone = Leatrix_Maps["Reveal"][artID]

			-- Store already explored tiles in a table so they can be ignored
			local TileExists = {}
			local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
			if exploredMapTextures then
				for i, exploredTextureInfo in ipairs(exploredMapTextures) do
					local key = exploredTextureInfo.textureWidth .. ":" .. exploredTextureInfo.textureHeight .. ":" .. exploredTextureInfo.offsetX .. ":" .. exploredTextureInfo.offsetY
					TileExists[key] = true
				end
			end

			-- Get the sizes
			pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
			local layers = C_Map.GetMapArtLayers(mapID)
			local layerInfo = layers and layers[pin.layerIndex]
			if not layerInfo then return end
			local TILE_SIZE_WIDTH = layerInfo.tileWidth
			local TILE_SIZE_HEIGHT = layerInfo.tileHeight

			-- Show textures if they are in database and have not been explored
			for key, files in pairs(LeaMapsZone) do
				if not TileExists[key] then
					local width, height, offsetX, offsetY = strsplit(":", key)
					local fileDataIDs = { strsplit(",", files) }
					local numTexturesWide = ceil(width/TILE_SIZE_WIDTH)
					local numTexturesTall = ceil(height/TILE_SIZE_HEIGHT)
					local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
					for j = 1, numTexturesTall do
						if ( j < numTexturesTall ) then
							texturePixelHeight = TILE_SIZE_HEIGHT
							textureFileHeight = TILE_SIZE_HEIGHT
						else
							texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
							if ( texturePixelHeight == 0 ) then
								texturePixelHeight = TILE_SIZE_HEIGHT
							end
							textureFileHeight = 16
							while(textureFileHeight < texturePixelHeight) do
								textureFileHeight = textureFileHeight * 2
							end
						end
						for k = 1, numTexturesWide do
							local texture = pin.overlayTexturePool:Acquire()
							if ( k < numTexturesWide ) then
								texturePixelWidth = TILE_SIZE_WIDTH
								textureFileWidth = TILE_SIZE_WIDTH
							else
								texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
								if ( texturePixelWidth == 0 ) then
									texturePixelWidth = TILE_SIZE_WIDTH
								end
								textureFileWidth = 16
								while(textureFileWidth < texturePixelWidth) do
									textureFileWidth = textureFileWidth * 2
								end
							end
							texture:SetSize(texturePixelWidth, texturePixelHeight)
							texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight)
							texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k-1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
							texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")
							texture:SetDrawLayer("ARTWORK", -1)
							if LeaMapsLC["RevealMap"] == "On" then
								texture:Show()
								if fullUpdate then
									pin.textureLoadGroup:AddTexture(texture)
								end
							else
								texture:Hide()
							end
							if LeaMapsLC["RevTint"] == "On" then
								texture:SetVertexColor(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
							end
							tinsert(overlayTextures, texture)
						end
					end
				end
			end
		end

		-- Reset texture color and alpha
		local function TexturePool_ResetVertexColor(pool, texture)
			texture:SetVertexColor(1, 1, 1)
			texture:SetAlpha(1)
			return TexturePool_HideAndClearAnchors(pool, texture)
		end

		-- Show overlays on startup
		for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
			hooksecurefunc(pin, "RefreshOverlays", MapExplorationPin_RefreshOverlays)
			pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
		end

		-- Toggle overlays if reveal option is clicked
		LeaMapsCB["RevealMap"]:HookScript("OnClick", function()
			if LeaMapsLC["RevealMap"] == "On" then 
				for i = 1, #overlayTextures  do
					overlayTextures[i]:Show()
				end
			else
				for i = 1, #overlayTextures  do
					overlayTextures[i]:Hide()
				end	
			end
		end)

		-- Create tint frame
		local tintFrame = CreateFrame("FRAME", nil, UIParent)
		tintFrame:ClearAllPoints()
		tintFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		tintFrame:SetSize(370, 340)
		tintFrame:Hide()
		tintFrame:SetFrameStrata("FULLSCREEN_DIALOG")
		tintFrame:SetFrameLevel(20)
		tintFrame:SetClampedToScreen(true)
		tintFrame:EnableMouse(true)
		tintFrame:SetMovable(true)
		tintFrame:RegisterForDrag("LeftButton")
		tintFrame:SetScript("OnDragStart", tintFrame.StartMoving)
		tintFrame:SetScript("OnDragStop", function()
			tintFrame:StopMovingOrSizing()
			tintFrame:SetUserPlaced(false)
			LeaMapsLC["MainPanelA"], void, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"] = tintFrame:GetPoint()
		end)

		-- Set panel attributes when shown
		tintFrame:SetScript("OnShow", function()
			tintFrame:ClearAllPoints()
			tintFrame:SetPoint(LeaMapsLC["MainPanelA"], UIParent, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"])
		end)

		-- Make it a system frame
		_G["LeaMapsGlobalTintPanel"] = tintFrame
		table.insert(UISpecialFrames, "LeaMapsGlobalTintPanel")

		-- Add background color
		tintFrame.t = tintFrame:CreateTexture(nil, "BACKGROUND")
		tintFrame.t:SetAllPoints()
		tintFrame.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add textures
		tintFrame.mt = tintFrame:CreateTexture(nil, "BORDER")
		tintFrame.mt:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		tintFrame.mt:SetSize(370, 293)
		tintFrame.mt:SetPoint("TOPRIGHT")
		tintFrame.mt:SetVertexColor(0.7, 0.7, 0.7, 0.7)

		tintFrame.ft = tintFrame:CreateTexture(nil, "BORDER")
		tintFrame.ft:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		tintFrame.ft:SetSize(370, 48)
		tintFrame.ft:SetPoint("BOTTOM")
		tintFrame.ft:SetVertexColor(0.5, 0.5, 0.5, 1.0)

		-- Add close Button
		local CloseB = CreateFrame("Button", nil, tintFrame, "UIPanelCloseButton") 
		CloseB:SetSize(30, 30)
		CloseB:SetPoint("TOPRIGHT", 0, 0)

		-- Add content
		tintFrame.mt = tintFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		tintFrame.mt:SetPoint('TOPLEFT', 16, -16)
		tintFrame.mt:SetText(L["Reveal Map"])

		-- Add description
		tintFrame.v = tintFrame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		tintFrame.v:SetHeight(32);
		tintFrame.v:SetPoint('TOPLEFT', tintFrame.mt, 'BOTTOMLEFT', 0, -8)
		tintFrame.v:SetPoint('RIGHT', tintFrame, -32, 0)
		tintFrame.v:SetJustifyH('LEFT'); tintFrame.v:SetJustifyV('TOP');
		tintFrame.v:SetText(L["Configuration Panel"])

		-- Add controls
		LeaMapsLC:MakeTx(tintFrame, "Settings", 16, -72)
		LeaMapsLC:MakeCB(tintFrame, "RevTint", "Tint unexplored areas", 16, -92, false)
		LeaMapsLC:MakeSL(tintFrame, "tintRed", "Red", "", 0, 1, 0.1, 36, -142, "%.1f")
		LeaMapsLC:MakeSL(tintFrame, "tintGreen", "Green", "", 0, 1, 0.1, 36, -192, "%.1f")
		LeaMapsLC:MakeSL(tintFrame, "tintBlue", "Blue", "", 0, 1, 0.1, 36, -242, "%.1f")
		LeaMapsLC:MakeSL(tintFrame, "tintAlpha", "Transparency", "", 0.1, 1, 0.1, 196, -242, "%.1f")

		-- Add preview color block
		tintFrame.preview = tintFrame:CreateTexture(nil, "ARTWORK")
		tintFrame.preview:SetSize(50, 50)
		tintFrame.preview:SetPoint("TOP", LeaMapsCB["tintAlpha"], "TOP", 0, 90)

		local prvTitle = LeaMapsLC:MakeWD(tintFrame, "Preview", 196, -132)
		prvTitle:ClearAllPoints()
		prvTitle:SetPoint("TOP", tintFrame.preview, "TOP", 0, 20)

		-- Function to set tint color
		local function SetTintCol()
			tintFrame.preview:SetColorTexture(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
			-- Set slider values
			LeaMapsCB["tintRed"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintRed"] * 100)
			LeaMapsCB["tintGreen"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintGreen"] * 100)
			LeaMapsCB["tintBlue"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintBlue"] * 100)
			LeaMapsCB["tintAlpha"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintAlpha"] * 100)
			-- Set tint
			if LeaMapsLC["RevTint"] == "On" then
				-- Enable tint
				for i = 1, #overlayTextures  do
					overlayTextures[i]:SetVertexColor(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
				end
				-- Enable controls
				LeaMapsCB["tintRed"]:Enable(); LeaMapsCB["tintRed"]:SetAlpha(1.0)
				LeaMapsCB["tintGreen"]:Enable(); LeaMapsCB["tintGreen"]:SetAlpha(1.0)
				LeaMapsCB["tintBlue"]:Enable(); LeaMapsCB["tintBlue"]:SetAlpha(1.0)
				LeaMapsCB["tintAlpha"]:Enable(); LeaMapsCB["tintAlpha"]:SetAlpha(1.0)
				prvTitle:SetAlpha(1.0); tintFrame.preview:SetAlpha(1.0)
			else
				-- Disable tint
				for i = 1, #overlayTextures  do
					overlayTextures[i]:SetVertexColor(1, 1, 1)
					overlayTextures[i]:SetAlpha(1.0)
				end
				-- Disable controls
				LeaMapsCB["tintRed"]:Disable(); LeaMapsCB["tintRed"]:SetAlpha(0.3)
				LeaMapsCB["tintGreen"]:Disable(); LeaMapsCB["tintGreen"]:SetAlpha(0.3)
				LeaMapsCB["tintBlue"]:Disable(); LeaMapsCB["tintBlue"]:SetAlpha(0.3)
				LeaMapsCB["tintAlpha"]:Disable(); LeaMapsCB["tintAlpha"]:SetAlpha(0.3)
				prvTitle:SetAlpha(0.3); tintFrame.preview:SetAlpha(0.3)
			end
		end

		-- Set tint properties when controls are changed and on startup
		LeaMapsCB["RevTint"]:HookScript("OnClick", SetTintCol)
		LeaMapsCB["tintRed"]:HookScript("OnMouseWheel", SetTintCol)
		LeaMapsCB["tintRed"]:HookScript("OnValueChanged", SetTintCol)
		LeaMapsCB["tintGreen"]:HookScript("OnMouseWheel", SetTintCol)
		LeaMapsCB["tintGreen"]:HookScript("OnValueChanged", SetTintCol)
		LeaMapsCB["tintBlue"]:HookScript("OnMouseWheel", SetTintCol)
		LeaMapsCB["tintBlue"]:HookScript("OnValueChanged", SetTintCol)
		LeaMapsCB["tintAlpha"]:HookScript("OnMouseWheel", SetTintCol)
		LeaMapsCB["tintAlpha"]:HookScript("OnValueChanged", SetTintCol)
		SetTintCol()

		-- Back to Main Menu button click
		local tintConfirmBtn = LeaMapsLC:CreateButton("tintConfirmBtn", tintFrame, "Back to Main Menu", "BOTTOMRIGHT", -16, 10, 25)
		tintConfirmBtn:HookScript("OnClick", function()
			tintFrame:Hide()
			LeaMapsLC["PageF"]:Show()
		end)

		-- Reset button click
		local tintResetBtn = LeaMapsLC:CreateButton("tintResetBtn", tintFrame, "Reset", "BOTTOMLEFT", 16, 10, 25)
		tintResetBtn:HookScript("OnClick", function()
			LeaMapsLC["RevTint"] = "On"
			LeaMapsLC["tintRed"] = 0.6
			LeaMapsLC["tintGreen"] = 0.6
			LeaMapsLC["tintBlue"] = 1
			LeaMapsLC["tintAlpha"] = 1
			SetTintCol()
			tintFrame:Hide(); tintFrame:Show()
		end)

		-- Show tint configuration panel when configuration button is clicked
		LeaMapsCB["RevTintBtn"]:HookScript("OnClick", function()
			if IsShiftKeyDown() and IsControlKeyDown() then
				-- Preset profile
				LeaMapsLC["RevTint"] = "On"
				LeaMapsLC["tintRed"] = 0.6
				LeaMapsLC["tintGreen"] = 0.6
				LeaMapsLC["tintBlue"] = 1
				LeaMapsLC["tintAlpha"] = 1
				SetTintCol()
				if tintFrame:IsShown() then tintFrame:Hide(); tintFrame:Show(); end
			else
				tintFrame:Show()
				LeaMapsLC["PageF"]:Hide()
			end
		end)

		----------------------------------------------------------------------
		-- Final code
		----------------------------------------------------------------------

		-- Release memory
		LeaMapsLC.MainFunc = nil

	end

	----------------------------------------------------------------------
	-- L10: Functions
	----------------------------------------------------------------------

	-- Load a string variable or set it to default if it's not set to "On" or "Off"
	function LeaMapsLC:LoadVarChk(var, def)
		if LeaMapsDB[var] and type(LeaMapsDB[var]) == "string" and LeaMapsDB[var] == "On" or LeaMapsDB[var] == "Off" then
			LeaMapsLC[var] = LeaMapsDB[var]
		else
			LeaMapsLC[var] = def
			LeaMapsDB[var] = def
		end
	end

	-- Load a numeric variable and set it to default if it's not within a given range
	function LeaMapsLC:LoadVarNum(var, def, valmin, valmax)
		if LeaMapsDB[var] and type(LeaMapsDB[var]) == "number" and LeaMapsDB[var] >= valmin and LeaMapsDB[var] <= valmax then
			LeaMapsLC[var] = LeaMapsDB[var]
		else
			LeaMapsLC[var] = def
			LeaMapsDB[var] = def
		end
	end

	-- Load an anchor point variable and set it to default if the anchor point is invalid
	function LeaMapsLC:LoadVarAnc(var, def)
		if LeaMapsDB[var] and type(LeaMapsDB[var]) == "string" and LeaMapsDB[var] == "CENTER" or LeaMapsDB[var] == "TOP" or LeaMapsDB[var] == "BOTTOM" or LeaMapsDB[var] == "LEFT" or LeaMapsDB[var] == "RIGHT" or LeaMapsDB[var] == "TOPLEFT" or LeaMapsDB[var] == "TOPRIGHT" or LeaMapsDB[var] == "BOTTOMLEFT" or LeaMapsDB[var] == "BOTTOMRIGHT" then
			LeaMapsLC[var] = LeaMapsDB[var]
		else
			LeaMapsLC[var] = def
			LeaMapsDB[var] = def
		end
	end

	-- Print text
	function LeaMapsLC:Print(text)
		DEFAULT_CHAT_FRAME:AddMessage(L[text], 1.0, 0.85, 0.0)
	end

	-- Lock control
	function LeaMapsLC:SetDim()
		if LeaMapsLC["RevealMap"] == "On" then
			LeaMapsCB["RevTintBtn"]:Enable()
			LeaMapsCB["RevTintBtn"]:SetAlpha(1.0)
		else
			LeaMapsCB["RevTintBtn"]:Disable()
			LeaMapsCB["RevTintBtn"]:SetAlpha(0.3)
		end
	end

	-- Create a standard button
	function LeaMapsLC:CreateButton(name, frame, label, anchor, x, y, height)
		local mbtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		LeaMapsCB[name] = mbtn
		mbtn:SetHeight(height)
		mbtn:SetPoint(anchor, x, y)
		mbtn:SetHitRectInsets(0, 0, 0, 0)
		mbtn:SetText(L[label])

		-- Create fontstring and set button width based on it
		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetText(L[label])
		mbtn:SetWidth(mbtn.f:GetStringWidth() + 20)

		-- Set skinned button textures
		mbtn:SetNormalTexture("Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp")
		mbtn:GetNormalTexture():SetTexCoord(0.5, 1, 0, 1)
		mbtn:SetHighlightTexture("Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp")
		mbtn:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 1)

		-- Hide the default textures
		mbtn:HookScript("OnShow", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnEnable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnDisable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnMouseDown", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnMouseUp", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)

		return mbtn
	end

	-- Create a subheading
	function LeaMapsLC:MakeTx(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
		return text
	end

	-- Create text
	function LeaMapsLC:MakeWD(frame, title, x, y, width)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		text:SetPoint("TOPLEFT", x, y)
		text:SetJustifyH("LEFT")
		text:SetText(L[title])
		if width then text:SetWidth(width) end
		return text
	end

	-- Create a checkbox control
	function LeaMapsLC:MakeCB(parent, field, caption, x, y, reload)

		-- Create the checkbox
		local Cbox = CreateFrame('CheckButton', nil, parent, "ChatConfigCheckButtonTemplate")
		LeaMapsCB[field] = Cbox
		Cbox:SetPoint("TOPLEFT",x, y)

		-- Add label and tooltip
		Cbox.f = Cbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		Cbox.f:SetPoint('LEFT', 24, 0)
		if reload then
			Cbox.f:SetText(L[caption] .. "*")
		else
			Cbox.f:SetText(L[caption])
		end

		-- Set label parameters
		Cbox.f:SetJustifyH("LEFT")
		Cbox.f:SetWordWrap(false)

		-- Set maximum label width
		if Cbox.f:GetWidth() > 292 then
			Cbox.f:SetWidth(292)
		end

		-- Set checkbox click width
		if Cbox.f:GetStringWidth() > 292 then
			Cbox:SetHitRectInsets(0, -272, 0, 0)
		else
			Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 4, 0, 0)
		end

		-- Set default checkbox state and click area
		Cbox:SetScript('OnShow', function(self)
			if LeaMapsLC[field] == "On" then
				self:SetChecked(true)
			else
				self:SetChecked(false)
			end
		end)

		-- Process clicks
		Cbox:SetScript('OnClick', function()
			if Cbox:GetChecked() then
				LeaMapsLC[field] = "On"
			else
				LeaMapsLC[field] = "Off"
			end
			LeaMapsLC:SetDim() -- Lock invalid options
		end)
	end

	-- Create configuration button
	function LeaMapsLC:CfgBtn(name, parent)
		local CfgBtn = CreateFrame("BUTTON", nil, parent)
		LeaMapsCB[name] = CfgBtn
		CfgBtn:SetWidth(20)
		CfgBtn:SetHeight(20)
		CfgBtn:SetPoint("LEFT", parent.f, "RIGHT", 0, 0)

		CfgBtn.t = CfgBtn:CreateTexture(nil, "BORDER")
		CfgBtn.t:SetAllPoints()
		CfgBtn.t:SetTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn.t:SetTexCoord(0, 0.50, 0, 0.50);
		CfgBtn.t:SetVertexColor(1.0, 0.82, 0, 1.0)

		CfgBtn:SetHighlightTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn:GetHighlightTexture():SetTexCoord(0, 0.50, 0, 0.50);
	end

	-- Create a slider control
	function LeaMapsLC:MakeSL(frame, field, label, caption, low, high, step, x, y, form)

		-- Create slider control
		local Slider = CreateFrame("Slider", "LeaPlusGlobalSlider" .. field, frame, "OptionssliderTemplate")
		LeaMapsCB[field] = Slider
		Slider:SetMinMaxValues(low, high)
		Slider:SetValueStep(step)
		Slider:EnableMouseWheel(true)
		Slider:SetPoint('TOPLEFT', x,y)
		Slider:SetWidth(100)
		Slider:SetHeight(20)
		Slider:SetHitRectInsets(0, 0, 0, 0)

		-- Remove slider text
		_G[Slider:GetName().."Low"]:SetText('')
		_G[Slider:GetName().."High"]:SetText('')

		-- Set label
		_G[Slider:GetName().."Text"]:SetText(label)

		-- Create slider label
		Slider.f = Slider:CreateFontString(nil, 'BACKGROUND')
		Slider.f:SetFontObject('GameFontHighlight')
		Slider.f:SetPoint('LEFT', Slider, 'RIGHT', 12, 0)
		Slider.f:SetFormattedText("%.2f", Slider:GetValue())

		-- Process mousewheel scrolling
		Slider:SetScript("OnMouseWheel", function(self, arg1)
			if Slider:IsEnabled() then
				local step = step * arg1
				local value = self:GetValue()
				if step > 0 then
					self:SetValue(min(value + step, high))
				else
					self:SetValue(max(value + step, low))
				end
			end
		end)

		-- Process value changed
		Slider:SetScript("OnValueChanged", function(self, value)
			local value = floor((value - low) / step + 0.5) * step + low
			Slider.f:SetFormattedText(form, value)
			LeaMapsLC[field] = value
		end)

		-- Set slider value when shown
		Slider:SetScript("OnShow", function(self)
			self:SetValue(LeaMapsLC[field])
		end)

	end

	----------------------------------------------------------------------
	-- Stop error frame
	----------------------------------------------------------------------

	-- Create stop error frame
	local stopFrame = CreateFrame("FRAME", nil, UIParent)
	stopFrame:ClearAllPoints()
	stopFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	stopFrame:SetSize(370, 150)
	stopFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	stopFrame:SetFrameLevel(500)
	stopFrame:SetClampedToScreen(true)
	stopFrame:EnableMouse(true)
	stopFrame:SetMovable(true)
	stopFrame:Hide()
	stopFrame:RegisterForDrag("LeftButton")
	stopFrame:SetScript("OnDragStart", stopFrame.StartMoving)
	stopFrame:SetScript("OnDragStop", function()
		stopFrame:StopMovingOrSizing()
		stopFrame:SetUserPlaced(false)
	end)

	-- Add background color
	stopFrame.t = stopFrame:CreateTexture(nil, "BACKGROUND")
	stopFrame.t:SetAllPoints()
	stopFrame.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

	-- Add textures
	stopFrame.mt = stopFrame:CreateTexture(nil, "BORDER")
	stopFrame.mt:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
	stopFrame.mt:SetSize(370, 103)
	stopFrame.mt:SetPoint("TOPRIGHT")
	stopFrame.mt:SetVertexColor(0.5, 0.5, 0.5, 1.0)

	stopFrame.ft = stopFrame:CreateTexture(nil, "BORDER")
	stopFrame.ft:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
	stopFrame.ft:SetSize(370, 48)
	stopFrame.ft:SetPoint("BOTTOM")
	stopFrame.ft:SetVertexColor(0.5, 0.5, 0.5, 1.0)

	LeaMapsLC:MakeTx(stopFrame, "Leatrix Maps", 16, -12)
	LeaMapsLC:MakeWD(stopFrame, "A stop error has occurred but no need to worry.  It can happen from time to time.  Click the reload button to resolve it.", 16, -32, 338)

	-- Add reload UI Button
	local stopRelBtn = LeaMapsLC:CreateButton("StopReloadButton", stopFrame, "Reload", "BOTTOMRIGHT", -16, 10, 25)
	stopRelBtn:SetScript("OnClick", ReloadUI)
	stopRelBtn.f = stopRelBtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	stopRelBtn.f:SetHeight(32)
	stopRelBtn.f:SetPoint('RIGHT', stopRelBtn, 'LEFT', -10, 0)
	stopRelBtn.f:SetText(L["Your UI needs to be reloaded."])
	stopRelBtn:Hide(); stopRelBtn:Show()

	-- Add close Button
	local stopFrameClose = CreateFrame("Button", nil, stopFrame, "UIPanelCloseButton") 
	stopFrameClose:SetSize(30, 30)
	stopFrameClose:SetPoint("TOPRIGHT", 0, 0)

	----------------------------------------------------------------------
	-- L20: Commands
	----------------------------------------------------------------------

	-- Slash command function
	local function SlashFunc(str)
		local str = string.lower(str)
		if str and str ~= "" then
			-- Traverse parameters
			if str == "reset" then
				-- Reset the configuration panel position
				LeaMapsLC["MainPanelA"], LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
				if LeaMapsLC["PageF"]:IsShown() then LeaMapsLC["PageF"]:Hide() LeaMapsLC["PageF"]:Show() end
				return
			elseif str == "wipe" then
				-- Wipe all settings
				SetCVar("mapFade", "1")
				wipe(LeaMapsDB)
				LeaMapsLC["NoSaveSettings"] = true
				ReloadUI()
			elseif str == "admin" then
				-- Preset profile (reload required)
				wipe(LeaMapsDB)
				LeaMapsLC["RevealMap"] = "On"
				LeaMapsLC["RevTint"] = "On"
				LeaMapsLC["tintRed"] = 0.6
				LeaMapsLC["tintGreen"] = 0.6
				LeaMapsLC["tintBlue"] = 1.0
				LeaMapsLC["tintAlpha"] = 1.0
				LeaMapsLC["ShowIcons"] = "On"
				LeaMapsLC["NoMapFade"] = "On"
				LeaMapsLC["NoMapEmote"] = "On"
				ReloadUI()
			elseif str == "help" then
				-- Show available commands
				LeaMapsLC:Print("Leatrix Maps" .. "|n")
				LeaMapsLC:Print(L["Classic"] .. " " .. LeaMapsLC["AddonVer"] .. "|n|n")
				LeaMapsLC:Print("/ltm reset - Reset the panel position.")
				LeaMapsLC:Print("/ltm wipe - Wipe all settings and reload.")
				LeaMapsLC:Print("/ltm help - Show this information.")
				return
			else
				-- Invalid command entered
				LeaMapsLC:Print("Invalid command.  Enter /ltm help for help.")
				return
			end
		else
			-- Prevent options panel from showing if a game options panel is showing
			if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
			-- Toggle the options panel if game options panel is not showing
			if LeaMapsLC["PageF"]:IsShown() then
				LeaMapsLC["PageF"]:Hide()
			else
				LeaMapsLC["PageF"]:Show()
			end
		end
	end

	-- Add slash commands
	_G.SLASH_Leatrix_Maps1 = "/ltm"
	_G.SLASH_Leatrix_Maps2 = "/leamaps" 
	SlashCmdList["Leatrix_Maps"] = function(self)
		-- Run slash command function
		SlashFunc(self)
		-- Redirect tainted variables
		RunScript('ACTIVE_CHAT_EDIT_BOX = ACTIVE_CHAT_EDIT_BOX')
		RunScript('LAST_ACTIVE_CHAT_EDIT_BOX = LAST_ACTIVE_CHAT_EDIT_BOX')
	end

	----------------------------------------------------------------------
	-- L30: Events
	----------------------------------------------------------------------

	-- Create event frame
	local eFrame = CreateFrame("FRAME")
	eFrame:RegisterEvent("ADDON_LOADED")
	eFrame:RegisterEvent("PLAYER_LOGIN")
	eFrame:RegisterEvent("PLAYER_LOGOUT")
	eFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
	eFrame:SetScript("OnEvent", function(self, event, arg1)

		if event == "ADDON_LOADED" and arg1 == "Leatrix_Maps" then
			-- Load settings or set defaults
			LeaMapsLC:LoadVarChk("RevealMap", "On")						-- Reveal unexplored areas
			LeaMapsLC:LoadVarChk("RevTint", "On")						-- Tint revealed unexplored areas
			LeaMapsLC:LoadVarNum("tintRed", 0.6, 0, 1)					-- Tint red
			LeaMapsLC:LoadVarNum("tintGreen", 0.6, 0, 1)				-- Tint green
			LeaMapsLC:LoadVarNum("tintBlue", 1, 0, 1)					-- Tint blue
			LeaMapsLC:LoadVarNum("tintAlpha", 1, 0, 1)					-- Tint transparency
			LeaMapsLC:LoadVarChk("ShowIcons", "On")						-- Show dungeon location icons
			LeaMapsLC:LoadVarAnc("MainPanelA", "CENTER")				-- Panel anchor
			LeaMapsLC:LoadVarAnc("MainPanelR", "CENTER")				-- Panel relative
			LeaMapsLC:LoadVarNum("MainPanelX", 0, -5000, 5000)			-- Panel X axis
			LeaMapsLC:LoadVarNum("MainPanelY", 0, -5000, 5000)			-- Panel Y axis
			LeaMapsLC:SetDim()

		elseif event == "PLAYER_LOGIN" then
			-- Run main function
			LeaMapsLC:MainFunc()

		elseif event == "PLAYER_LOGOUT" and not LeaMapsLC["NoSaveSettings"] then
			-- Save settings
			LeaMapsDB["RevealMap"] = LeaMapsLC["RevealMap"]
			LeaMapsDB["RevTint"] = LeaMapsLC["RevTint"]
			LeaMapsDB["tintRed"] = LeaMapsLC["tintRed"]
			LeaMapsDB["tintGreen"] = LeaMapsLC["tintGreen"]
			LeaMapsDB["tintBlue"] = LeaMapsLC["tintBlue"]
			LeaMapsDB["tintAlpha"] = LeaMapsLC["tintAlpha"]
			LeaMapsDB["ShowIcons"] = LeaMapsLC["ShowIcons"]
			LeaMapsDB["MainPanelA"] = LeaMapsLC["MainPanelA"]
			LeaMapsDB["MainPanelR"] = LeaMapsLC["MainPanelR"]
			LeaMapsDB["MainPanelX"] = LeaMapsLC["MainPanelX"]
			LeaMapsDB["MainPanelY"] = LeaMapsLC["MainPanelY"]

		elseif event == "ADDON_ACTION_FORBIDDEN" and arg1 == "Leatrix_Maps" then
			-- Stop error has occured
			StaticPopup_Hide("ADDON_ACTION_FORBIDDEN")
			stopFrame:Show()

		end
	end)

	----------------------------------------------------------------------
	-- L40: Panel
	----------------------------------------------------------------------

	-- Create the panel
	local PageF = CreateFrame("Frame", nil, UIParent)

	-- Make it a system frame
	_G["LeaMapsGlobalPanel"] = PageF
	table.insert(UISpecialFrames, "LeaMapsGlobalPanel")

	-- Set frame parameters
	LeaMapsLC["PageF"] = PageF
	PageF:SetSize(370, 340)
	PageF:Hide()
	PageF:SetFrameStrata("FULLSCREEN_DIALOG")
	PageF:SetFrameLevel(20)
	PageF:SetClampedToScreen(true)
	PageF:EnableMouse(true)
	PageF:SetMovable(true)
	PageF:RegisterForDrag("LeftButton")
	PageF:SetScript("OnDragStart", PageF.StartMoving)
	PageF:SetScript("OnDragStop", function()
		PageF:StopMovingOrSizing()
		PageF:SetUserPlaced(false)
		-- Save panel position
		LeaMapsLC["MainPanelA"], void, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"] = PageF:GetPoint()
	end)

	-- Add background color
	PageF.t = PageF:CreateTexture(nil, "BACKGROUND")
	PageF.t:SetAllPoints()
	PageF.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

	-- Add textures
	local MainTexture = PageF:CreateTexture(nil, "BORDER")
	MainTexture:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
	MainTexture:SetSize(370, 293)
	MainTexture:SetPoint("TOPRIGHT")
	MainTexture:SetVertexColor(0.7, 0.7, 0.7, 0.7)
	MainTexture:SetTexCoord(0.09, 1, 0, 1)

	local FootTexture = PageF:CreateTexture(nil, "BORDER")
	FootTexture:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
	FootTexture:SetSize(370, 48)
	FootTexture:SetPoint("BOTTOM")
	FootTexture:SetVertexColor(0.5, 0.5, 0.5, 1.0)

	-- Set panel position when shown
	PageF:SetScript("OnShow", function()
		PageF:ClearAllPoints()
		PageF:SetPoint(LeaMapsLC["MainPanelA"], UIParent, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"])
	end)

	-- Add main title
	PageF.mt = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	PageF.mt:SetPoint('TOPLEFT', 16, -16)
	PageF.mt:SetText("Leatrix Maps")

	-- Add version text
	PageF.v = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	PageF.v:SetHeight(32)
	PageF.v:SetPoint('TOPLEFT', PageF.mt, 'BOTTOMLEFT', 0, -8)
	PageF.v:SetPoint('RIGHT', PageF, -32, 0)
	PageF.v:SetJustifyH('LEFT'); PageF.v:SetJustifyV('TOP')
	PageF.v:SetNonSpaceWrap(true); PageF.v:SetText(L["Classic"] .. " " .. LeaMapsLC["AddonVer"])

	-- Add close Button
	local CloseB = CreateFrame("Button", nil, PageF, "UIPanelCloseButton") 
	CloseB:SetSize(30, 30)
	CloseB:SetPoint("TOPRIGHT", 0, 0)

	-- Add content
	LeaMapsLC:MakeTx(PageF, "Reveal", 16, -72)
	LeaMapsLC:MakeCB(PageF, "RevealMap", "Reveal unexplored areas of the map", 16, -92, false)

	LeaMapsLC:MakeTx(PageF, "Icons", 16, -132)
	LeaMapsLC:MakeCB(PageF, "ShowIcons", "Show dungeon location icons", 16, -152, false)

 	LeaMapsLC:CfgBtn("RevTintBtn", LeaMapsCB["RevealMap"])
