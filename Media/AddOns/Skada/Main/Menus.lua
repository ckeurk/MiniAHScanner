-- ==================================================================================================================== --
--															--
--	File			Menus.lua										--
--															--
--															--
--	Author			Zarnivoop	| Basis, thx |			| Version	   :	 10.0.2 |	--
--										| Curse-Project-ID :	 694380 |	--
--										| License	   :	  MIT/X |	--
--															--
--															--
--				Baltha		| Revision |			| Version	   :	 11.0.7 |	--
--										|			 11.1.0 |	--
--										| Curse-Project-ID :	1188318 |	--
--										| License	   :	  MIT/X |	--
--															--
--															--
--	Path | Revision |	"..\World of Warcraft\_retail_\Interface\AddOns\Skada\Misc\Changelog\ChangeLog.txt"	--
--															--
-- ==================================================================================================================== --


local _, Skada	   = ...


local L		   = LibStub("AceLocale-3.0"):GetLocale("Skada", false)
local AceGUI	   = LibStub("AceGUI-3.0")


local mChecked	   = {}
local MenuVariants = MenuVariants or {}


local leftSpacer1  = string.rep(" ", 3)
local leftSpacer2  = string.rep(" ", 6)


-- =================
-- | menu: general |
-- =================
local mSize	   = 16
local mTexture	   = "GameFontNormalSmall"




-- =========================================
-- | skada windows: implementation counter |
-- =========================================
local function CountWindows(elements, names)
 
	SkadaWindowsSort    = SkadaWindowsSort    or {}
	SkadaWindowsChanges = SkadaWindowsChanges or {}

	if #SkadaWindowsSort == 0 then

		for i = 1, elements do

			table.insert(SkadaWindowsSort, i, names[i] .. "-" .. "Alphabetical")
		end
	end

	-- ===============================
	-- | sort: insert/delete entries |
	-- ===============================
	if SkadaWindowsSort ~= 0 then

		for i = 1, elements do

			table.insert(SkadaWindowsSort, SkadaWindowsSort[i])

			for j = #CurrentSkadaNames + 1, #SkadaWindowsSort do

				table.remove(SkadaWindowsSort, j, SkadaWindowsSort[j])
			end
		end
	end
end




-- =================================================
-- | context menu: implementation helper functions |
-- =================================================
local function mTitle(getDescription, getText)

	local Title = getDescription:CreateTitle(getText)

	Title:AddInitializer(function(title, description, menu)

				     title.fontString:SetFontObject(mTexture)
				     title.fontString:SetHeight(mSize)
			     end

			    )

	return
end




local function mButton(getDescription, getText, getFunction)

	local Button = getDescription:CreateButton(getText, getFunction)

	Button:AddInitializer(function(button, description, menu)

				      button.fontString:SetFontObject(mTexture)
				      button.fontString:SetHeight(mSize)

			      end
			     )

	return
end




-- ==============================================================================================
-- | context menu implementation: Blizzard_Menu (new framework), replacement for UIDropDownMenu	|
-- ==============================================================================================
function Skada:OpenMenu(window)


	if not self.skadamenu then self.skadamenu = CreateFrame("Frame", "SkadaMenu") end


	-- ======================
	-- | generator function |
	-- ======================
	local function GeneratorFunction(owner, rootDescription)


		-- =============================
		-- | top level 00: contextmenu |
		-- =============================
		mTitle(rootDescription, L["Skada Menu"])


			-- =========================
			-- | sub level 01: general |
			-- =========================
			mTitle(rootDescription, leftSpacer1 .. L["General"])


				-- =======================================
				-- | sub level 01-01: configuration menu |
				-- =======================================
				mInfo	   = {}
				mInfo.func = function()
						     Skada:OpenOptions(window)
					     end
				mInfo.text = leftSpacer2 .. L["Configure"]

				mButton(rootDescription, mInfo.text, mInfo.func)


				-- =========================================
				-- | sub level 01-02: close dropdown menus |
				-- =========================================
				mInfo	   = {}
				mInfo.func = function()
						     CloseDropDownMenus()
					     end
				mInfo.text = leftSpacer2 .. CLOSE

				mButton(rootDescription, mInfo.text, mInfo.func)


			-- ========================
			-- | sub level 02: report |
			-- ========================
			mTitle(rootDescription, leftSpacer1 .. L["Report"])


				-- ================================
				-- | sub level 02-01: open report |
				-- ================================
				if not window or (window and window.selectedmode) then

				mInfo	   = {}
				mInfo.func = function()
						     Skada:OpenReportWindow(window)
					     end
				mInfo.text = leftSpacer2 .. L["Report"]

				mButton(rootDescription, mInfo.text, mInfo.func)
				end


			-- ========================================
			-- [  sub level 03: show player button(s) |
			-- ========================================
			mTitle(rootDescription, leftSpacer1 .. L["Window"])


			for i, win in ipairs(Skada:GetWindows()) do

				if i == 1 then CurrentSkadaNames = {} end

				CurrentSkadaNames[i] = win.db.name
				CurrentSkadaWindows  = i
			end


			CountWindows(CurrentSkadaWindows, CurrentSkadaNames)


			for i, win in ipairs(Skada:GetWindows()) do

				local currentChecked = false

				if i == 1 then SkadaWindowsNames = {} end

				mInfo		     = {}
				mInfo.text	     = leftSpacer2 .. win.db.name
				mInfo.value	     = win

				SkadaWindowsNames[i] = win.db.name


				submenu	= rootDescription:CreateButton(mInfo.text)

				submenu:AddInitializer(function(button, description, menu)

							       button.fontString:SetFontObject(mTexture)
							       button.fontString:SetHeight(mSize)

							       arrow = MenuVariants.CreateSubmenuArrow(button)
						       end

						      )


				local window	     = mInfo.value


				-- =====================================================
				-- | sub level 03-11: entries mode button alphabetical |
				-- =====================================================
				if SkadaWindowsSort[i] == SkadaWindowsNames[i] .. "-" .. "Alphabetical" then


					-- ======================
					-- | sort: alphabetical |
					-- ======================
					local alphabetical = {}


					for j, module in ipairs(Skada:GetModes()) do table.insert(alphabetical, module) end


					Skada:CurrentSort(alphabetical, "ALP")


					for j, module in ipairs(alphabetical) do

						if j == 1 then

							mInfo	   = {}
							mInfo.text = leftSpacer2 .. L["Click"] .. "\124cFF00FF00" .. L["Alphabetical"] .. " -> " .. L["Categorized"]
							mInfo.func = function()

									     -- ===========================================================================
									     -- | if using this button, the current Skada-Frames switch to "Categorized". |
									     -- ===========================================================================
									     if "LeftButton" then

										     SkadaWindowsSort[i] = SkadaWindowsNames[i] .. "-" .. "Categorized"
									     else

										     SkadaWindowsSort[i] = SkadaWindowsNames[i] .. "-" .. "Alphabetical"
									     end


									     -- ===========================
									     -- | last sorting entry only |
									     -- ===========================
									     table.insert(SkadaWindowsSort, SkadaWindowsSort[i])

									     for j = #CurrentSkadaNames + 1, #SkadaWindowsSort do

										     table.remove(SkadaWindowsSort, j, SkadaWindowsSort[j])
									     end										
								     end

							mTitle(submenu, L["Mode"] .. " - "  .. L["Alphabetical"])
							mButton(submenu, mInfo.text, mInfo.func)
							mTitle(submenu, "")
						end

						mInfo	      = {}
						mInfo.text    = leftSpacer2 .. module:GetName()
						mInfo.func    = function()
									window:DisplayMode(module)
								end
						mInfo.checked = (window.selectedmode == module)

						if mInfo.checked then mInfo.text = "\124cFF00FF00" .. mInfo.text end

						mButton(submenu, mInfo.text, mInfo.func)
					end
				end


				-- ====================================================
				-- | sub level 03-12: entries mode button categorized |
				-- ====================================================				
				if SkadaWindowsSort[i] == SkadaWindowsNames[i] .. "-" .. "Categorized" then


					-- =====================
					-- | sort: categorized |
					-- =====================
					local categorized = {}


					for j, module in ipairs(Skada:GetModes()) do table.insert(categorized, module) end


					Skada:CurrentSort(categorized, "CAT")


					local lastcat = nil


					for j, module in ipairs(categorized) do

						if j == 1 then

							mInfo	   = {}
							mInfo.text = leftSpacer2 .. L["Click"] .. "\124cFF00FF00" .. L["Categorized"] .. " -> " .. L["Alphabetical"]
							mInfo.func = function()

									     -- ========================================================================
									     -- | if using this button, current Skada-Frames switch to "Alphabetical". |
									     -- ========================================================================
									     if "LeftButton" then

										     SkadaWindowsSort[i] = SkadaWindowsNames[i] .. "-" .. "Alphabetical"
									     else

										     SkadaWindowsSort[i] = SkadaWindowsNames[i] .. "-" .. "Categorized"
									     end


									     -- ===========================
									     -- | last sorting entry only |
									     -- ===========================
									     table.insert(SkadaWindowsSort, SkadaWindowsSort[i])

									     for j = #CurrentSkadaNames + 1, #SkadaWindowsSort do

										     table.remove(SkadaWindowsSort, j, SkadaWindowsSort[j])
									     end
								     end


							mTitle(submenu, L["Mode"] .. " - " .. L["Categorized"])
							mButton(submenu, mInfo.text, mInfo.func)
							mTitle(submenu, "")
						end


						if not lastcat or lastcat ~= module.category then

							mInfo	   = {}
							mInfo.text = module.category

							mTitle(submenu, leftSpacer2 .. mInfo.text)

							lastcat	   = module.category
						end


						mInfo	      = {}
						mInfo.text    = leftSpacer2 .. module:GetName()
						mInfo.func    = function()
									window:DisplayMode(module)
								end
						mInfo.checked = (window.selectedmode == module)

						if mInfo.checked then mInfo.text = "\124cFF00FF00" .. mInfo.text end

						mButton(submenu, mInfo.text, mInfo.func)
					end
				end


				-- ====================================
				-- | sub level 03-20: entries windows |
				-- ====================================
				mTitle(submenu, L["Window"])


					-- =======================================
					-- | sub level 03-21: hide selected mode |
					-- =======================================
					mInfo	      = {}
					mInfo.func    = function()
								if window:IsShown() then
									window.db.hidden = true
									window:Hide()
								else
									window.db.hidden = false
									window:Show()
								end
							end
					mInfo.text    = leftSpacer2 .. L["Hide window"]
					mInfo.checked = not window:IsShown()

					if mInfo.checked then mInfo.text = "\124cFFFF0000" .. mInfo.text end

					mButton(submenu, mInfo.text, mInfo.func)


					-- =======================================
					-- | sub level 03-22: lock selected mode |
					-- =======================================
					mInfo	      = {}
					mInfo.text    = leftSpacer2 .. L["Lock window"]
					mInfo.func    = function()
								window.db.barslocked = not window.db.barslocked
								Skada:ApplySettings()
							end
					mInfo.checked = window.db.barslocked

					if mInfo.checked then

						mInfo.text = "\124cFF00FF00" .. mInfo.text
					else

						mInfo.text = "\124cFFFF0000" .. mInfo.text
					end

					mButton(submenu, mInfo.text, mInfo.func)


				-- ====================================
				-- | sub level 03-30: entries segment |
				-- ====================================
				mTitle(submenu, L["Segment"])


					-- =================================
					-- | sub level 03-31: current mode |
					-- =================================
					mInfo	      = {}
					mInfo.text    = leftSpacer2 .. L["Current"]
					mInfo.func    = function()
								window.selectedset = "current"
								Skada:Wipe()
								Skada:UpdateDisplay(true)
							end
					mInfo.checked = (window.selectedset == "current")

					if mInfo.checked then mInfo.text = "\124cFF00FF00" .. mInfo.text end

					mButton(submenu, mInfo.text, mInfo.func)


					-- ===============================
					-- | sub level 03-32: total mode |
					-- ===============================
					mInfo	      = {}
					mInfo.text    = leftSpacer2 .. L["Total"]
					mInfo.func    = function()
								window.selectedset = "total"
								Skada:Wipe()
								Skada:UpdateDisplay(true)
							end
					mInfo.checked = (window.selectedset == "total")

					if mInfo.checked then mInfo.text = "\124cFF00FF00" .. mInfo.text end

					mButton(submenu, mInfo.text, mInfo.func)
			end


			-- ===============================================
			-- | sub level window(s) 04-01: toggle window(s) |
			-- ===============================================
			mInfo		   = {}
			mInfo.func	   = function()
						     Skada:ToggleWindow()
					     end
			mInfo.text	   = leftSpacer2 .. L["Toggle window"]

			mButton(rootDescription, mInfo.text, mInfo.func)


			-- ==============================================
			-- | sub level window(s) 04-02: reset window(s) |
			-- ==============================================
			mInfo		   = {}
			mInfo.func	   = function()
						     Skada:Reset()
					     end
			mInfo.text	   = leftSpacer2 .. L["Reset"]

			mButton(rootDescription, mInfo.text, mInfo.func)


			-- =========================
			-- | sub level 05: segment |
			-- =========================
			mTitle(rootDescription, leftSpacer1 .. L["Segment"])


				-- =================================
				-- | sub level 05-01: keep segment |
				-- =================================
				mInfo		   = {}
				mInfo.text	   = leftSpacer2 .. L["Keep segment"]

				submenu = rootDescription:CreateButton(mInfo.text)

				submenu:AddInitializer(function(button, description, menu)

							       button.fontString:SetFontObject(mTexture)
							       button.fontString:SetHeight(mSize)

							       arrow = MenuVariants.CreateSubmenuArrow(button)
						       end

						      )

				for i, set in ipairs(Skada:GetSets()) do

					if i == 1 then mTitle(submenu, L["Keep segment"]) end

					mInfo.text    = Skada:GetSetLabel(set)
					mInfo.func    = function()
								set.keep = not set.keep
								Skada:Wipe()
								Skada:UpdateDisplay(true)
						        end
					mInfo.checked = set.keep

					mChecked[i] = mInfo.checked

					if mInfo.checked then mInfo.text = "\124cFF00FF00" .. mInfo.text end

					mButton(submenu, leftSpacer1 .. mInfo.text, mInfo.func)
				end


				-- ===================================
				-- | sub level 05-02: delete segment |
				-- ===================================
				mInfo		   = {}
				mInfo.text	   = leftSpacer2 .. L["Delete segment"]

				submenu = rootDescription:CreateButton(mInfo.text)

				submenu:AddInitializer(function(button, description, menu)

							       button.fontString:SetFontObject(mTexture)
							       button.fontString:SetHeight(mSize)

							       arrow = MenuVariants.CreateSubmenuArrow(button)
						       end

						      )

				for i, set in ipairs(Skada:GetSets()) do

					if i == 1 then mTitle(submenu, L["Delete segment"]) end

					mInfo.text	   = Skada:GetSetLabel(set)
					mInfo.func	   = function()
							  	     Skada:DeleteSet(set)
							     end

					if mChecked[i] == true then	mInfo.text = "\124cCCAB82FF" .. mInfo.text end

					mButton(submenu, leftSpacer1 .. mInfo.text, mInfo.func)
				end


				-- ================================
				-- | sub level 05-03: new segment |
				-- ================================
				mInfo		   = {}
				mInfo.text	   = leftSpacer2 .. L["Start new segment"]
				mInfo.func	   = function()
							     Skada:NewSegment()
							     end
				mButton(rootDescription, mInfo.text, mInfo.func)
	end




	-- =====================================
	-- | menu utility: create context menu |
	-- =====================================
	MenuUtil.CreateContextMenu(UIParent, GeneratorFunction)

		local skadamenu	      = self.skadamenu

		skadamenu.displayMode = "MENU"
		skadamenu.initialize  = function(self)
	end
end




function Skada:OpenReportWindow(window)

	if self.ReportWindow == nil then self:CreateReportWindow(window) end

	self.ReportWindow:Show()
end




local function destroywindow()

	if Skada.ReportWindow then

		local frame	     = Skada.ReportWindow
		frame.LayoutFinished = frame.orig_LayoutFinished

		frame.frame:SetScript("OnKeyDown", nil)
		frame.frame:EnableKeyboard(false)
		frame.frame:SetPropagateKeyboardInput(false)

		frame:ReleaseChildren()
		frame:Release()
	end

	Skada.ReportWindow = nil
end




function Skada:CreateReportWindow(window)

	local locale	  = GetLocale()
	labelButton	  = { "\124cnWHITE_FONT_COLOR:" .. L["Click"] .. "\124cFF00FF00" .. L["Alphabetical"] .. " -> " .. L["Categorized"],
			      "\124cnWHITE_FONT_COLOR:" .. L["Click"] .. "\124cFF00FF00" .. L["Categorized"] .. " -> " .. L["Alphabetical"] }

	self.ReportWindow = AceGUI:Create("Window")
	local frame	  = self.ReportWindow

	frame:EnableResize(false)
	frame:SetWidth(250)
	frame:SetLayout("List")

	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame.frame:SetClampedToScreen(true)

	frame.orig_LayoutFinished = frame.LayoutFinished
	frame.LayoutFinished	  = function(self, _, height) frame:SetHeight(height + 57) end

	frame.frame:EnableKeyboard(true)
	frame.frame:SetPropagateKeyboardInput(true)


	if window then

		frame:SetTitle(L["Report"] .. (" - %s"):format(window.db.name))
	else

		frame:SetTitle(L["Report"])
	end


	frame:SetCallback("OnClose", function(widget, callback) destroywindow() end)


	if window then

		Skada.db.profile.report.set = window.selectedset
		Skada.db.profile.report.mode = window.db.mode
	else

		modeSort    = modeSort or {}
		channelSort = channelSort or {}


		-- ==================================
		-- | mode: alphabetical/categorized |
		-- ==================================
		local modeLabel      = AceGUI:Create("Label")

			do
				if #modeSort == 0 then

					table.insert(modeSort, "ALP")
					modeLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Mode"] .. " - " .. L["Alphabetical"])
				else

					if modeSort[1] == "ALP" then modeLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Mode"] .. " - " .. L["Alphabetical"]) end
					if modeSort[1] == "CAT" then modeLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Mode"] .. " - " .. L["Categorized"]) end
				end
			end

		frame:AddChild(modeLabel)


		local modeButton     = AceGUI:Create("Button")

		modeButton:SetWidth(210)
		modeButton:SetHeight(20)


		local modeDropdown   = AceGUI:Create("Dropdown")

		local msaModulTable  = {}
		local mscModulTable  = {}

		msaNameTable	     = {}
		mscNameTable	     = {}

		local sortTable      = {}
		local cachedModeSort = modeSort[1]


		if modeSort[1] == "ALP" then modeButton:SetText(labelButton[1])	end
		if modeSort[1] == "CAT" then modeButton:SetText(labelButton[2])	end


		modeDropdown:SetList(sortTable)


		for i, mode in ipairs(Skada:GetModes()) do

			modeDropdown:AddItem(mode:GetName(), mode:GetName())

			table.insert(msaModulTable, mode)
			table.insert(mscModulTable, mode)
		end


		if modeSort[1] == "CAT" then

			if locale == "deDE" then

				modeDropdown:AddItem("dividingLineA", "\124cnNORMAL_FONT_COLOR:" .. L["Healing"])
				modeDropdown:AddItem("dividingLineB", "\124cnNORMAL_FONT_COLOR:" .. L["Power gains"])
				modeDropdown:AddItem("dividingLineC", "\124cnNORMAL_FONT_COLOR:" .. L["Damage"])
				modeDropdown:AddItem("dividingLineD", "\124cnNORMAL_FONT_COLOR:" .. L["Other"])
			end


			if locale == "enUS" then

				modeDropdown:AddItem("dividingLineA", "\124cnNORMAL_FONT_COLOR:" .. L["Damage"])
				modeDropdown:AddItem("dividingLineB", "\124cnNORMAL_FONT_COLOR:" .. L["Healing"])
				modeDropdown:AddItem("dividingLineC", "\124cnNORMAL_FONT_COLOR:" .. L["Power gains"])
				modeDropdown:AddItem("dividingLineD", "\124cnNORMAL_FONT_COLOR:" .. L["Other"])
			end
		end


		Skada:CurrentSort(msaModulTable, "ALP")
		Skada:CurrentSort(mscModulTable, "CAT")


		if #msaNameTable == 0 then

			for i, mode in ipairs(msaModulTable) do

				table.insert(msaNameTable, mode:GetName())
			end
		end


		if #mscNameTable == 0 then

			for i, mode in ipairs(mscModulTable) do

				table.insert(mscNameTable, mode:GetName())
			end


			if locale == "deDE" then

				table.insert(mscNameTable,  1, "dividingLineA")
				table.insert(mscNameTable,  8, "dividingLineB")
				table.insert(mscNameTable, 23, "dividingLineC")
				table.insert(mscNameTable, 30, "dividingLineD")
			end


			if locale == "enUS" then

				table.insert(mscNameTable,  1, "dividingLineA")
				table.insert(mscNameTable,  8, "dividingLineB")
				table.insert(mscNameTable, 15, "dividingLineC")
				table.insert(mscNameTable, 30, "dividingLineD")
			end

		end


		if cachedModeSort then

			if modeSort[1] == "ALP" then modeDropdown:SetList(sortTable, msaNameTable) end
			if modeSort[1] == "CAT" then modeDropdown:SetList(sortTable, mscNameTable) end
		end


		modeButton:SetCallback("OnClick",

						function()

							if modeSort[1] == "ALP" then

								modeLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Mode"] .. " - " .. L["Categorized"])


								if locale == "deDE" then

									modeDropdown:AddItem("dividingLineA", "\124cnNORMAL_FONT_COLOR:" .. L["Healing"])
									modeDropdown:AddItem("dividingLineB", "\124cnNORMAL_FONT_COLOR:" .. L["Power gains"])
									modeDropdown:AddItem("dividingLineC", "\124cnNORMAL_FONT_COLOR:" .. L["Damage"])
									modeDropdown:AddItem("dividingLineD", "\124cnNORMAL_FONT_COLOR:" .. L["Other"])
								end


								if locale == "enUS" then

									modeDropdown:AddItem("dividingLineA", "\124cnNORMAL_FONT_COLOR:" .. L["Damage"])
									modeDropdown:AddItem("dividingLineB", "\124cnNORMAL_FONT_COLOR:" .. L["Healing"])
									modeDropdown:AddItem("dividingLineC", "\124cnNORMAL_FONT_COLOR:" .. L["Power gains"])
									modeDropdown:AddItem("dividingLineD", "\124cnNORMAL_FONT_COLOR:" .. L["Other"])
								end


								table.insert(modeSort, 1, "CAT")
								table.remove(modeSort)

								modeButton:SetText(labelButton[2])
								modeDropdown:SetList(sortTable, mscNameTable)
							else

								modeLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Mode"] .. " - " .. L["Alphabetical"])


								table.insert(modeSort, 1, "ALP")
								table.remove(modeSort)

								modeButton:SetText(labelButton[1])
								modeDropdown:SetList(sortTable, msaNameTable)
							end

							return
						end

				  )

		frame:AddChild(modeButton)


		modeDropdown:SetCallback("OnEnter",

						function()

							modeDropdown:SetItemDisabled("dividingLineA", true)
							modeDropdown:SetItemDisabled("dividingLineB", true)
							modeDropdown:SetItemDisabled("dividingLineC", true)
							modeDropdown:SetItemDisabled("dividingLineD", true)
						end

					)


		modeDropdown:SetCallback("OnValueChanged", function(f, e, value) Skada.db.profile.report.mode = value end)
		modeDropdown:SetValue(Skada.db.profile.report.mode or Skada:GetSets()[1])

		frame:AddChild(modeDropdown)


		-- ===========================================================================
		-- | segement: current/total - blank line - (other) last in first out [LIFO] |
		-- ===========================================================================
		local segmentDropdown = AceGUI:Create("Dropdown")

		segmentDropdown:SetLabel(L["Segment"])
		segmentDropdown:SetList({current = L["Current"], total = L["Total"], vanishingEntry = " " })


		for i, set in ipairs(Skada:GetSets()) do

			segmentDropdown:AddItem(i, (Skada:GetSetLabel(set)))
		end


		segmentDropdown:SetCallback("OnValueChanged", function(f, e, value) Skada.db.profile.report.set = value end)
		segmentDropdown:SetValue(Skada.db.profile.report.set or Skada:GetSets()[1])

		frame:AddChild(segmentDropdown)
	end


	-- =====================================
	-- | channel: alphabetical/categorized |
	-- =====================================
	local channellist =

		{

			whisper	      = { L["Whisper"]		 , "whisper", true},
			target	      = { L["Whisper Target"]	 , "whisper"},
			say	      = { L["Say"]		 , "preset"},
			raid	      = { L["Raid"]		 , "preset"},
			party	      = { L["Party"]		 , "preset"},
			instance_chat = { L["Instance"]		 , "preset"},
			guild	      = { L["Guild"]		 , "preset"},
			officer	      = { L["Officer"]		 , "preset"},
			self	      = { L["Self"]		 , "self"},
--			bnet	      = { BATTLENET_OPTIONS_LABEL, "bnet", true},

		}


	local list = {GetChannelList()}


	for i=1, #list, 3 do

		local chan = list[i+1]

		if chan ~= "Trade" and chan ~= "General" and chan ~= "LocalDefense" and chan ~= "LookingForGroup" then

			channellist[chan] = {("%s: %d/%s"):format(L["Channel"], list[i], chan), "channel"}
		end
	end


	local channelLabel    = AceGUI:Create("Label")

		do
			if #channelSort == 0 then

				table.insert(channelSort, "CSA")
				channelLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Channel"] .. " - " .. L["Alphabetical"])
			else

				if channelSort[1] == "CSA" then channelLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Channel"] .. " - " .. L["Alphabetical"]) end
				if channelSort[1] == "CSC" then channelLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Channel"] .. " - " .. L["Categorized"]) end
			end
		end

	frame:AddChild(channelLabel)


	local channelButton	= AceGUI:Create("Button")

	channelButton:SetWidth(210)
	channelButton:SetHeight(20)


	local channelDropdown = AceGUI:Create("Dropdown")

	local csaChannelTable	= {}
	local cscChannelTable	= {}

	local sortTable		= {}

	csaNameTable		= {}
	cscNameTable		= {}
	csaKindTable		= {}

--	channelSort		= channelSort or {}
--
--
--	if #channelSort == 0 then table.insert(channelSort, "CSA") end


	local cachedChannelSort = channelSort[1]


	if channelSort[1] == "CSA" then channelButton:SetText(labelButton[1]) end
	if channelSort[1] == "CSC" then channelButton:SetText(labelButton[2]) end


	channelDropdown:SetList(sortTable)


	for i, kind in pairs(channellist) do

		table.insert(csaChannelTable, kind[1])
		table.insert(cscChannelTable, kind[1])
	end


	if channelSort[1] == "CSA" then

		for i = 1, #csaChannelTable do

			for chan, kind in pairs(channellist) do

				if csaChannelTable[i] == kind[1] then

					channelDropdown:AddItem(chan, kind[1])
					break
				end
			end
		end
	end


	if channelSort[1] == "CSC" then

		for i = 1, #cscChannelTable do

			for chan, kind in pairs(channellist) do

				if cscChannelTable[i] == kind[1] then

					channelDropdown:AddItem(chan, kind[1])
					break
				end
			end
		end


		channelDropdown:AddItem("dividingLineA", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Guild"])
		channelDropdown:AddItem("dividingLineB", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Group"])
		channelDropdown:AddItem("dividingLineC", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Local"])
		channelDropdown:AddItem("dividingLineD", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Whisper"])
		channelDropdown:AddItem("dividingLineE", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Channel"])
	end


	if #csaNameTable == 0 then

		for chan, kind in pairs(channellist) do

			table.insert(csaNameTable, chan)
		end
	end


	if #cscNameTable == 0 then

		for chan, kind in pairs(channellist) do

			table.insert(cscNameTable, chan)
		end
	end


	if #csaKindTable == 0 then

		for chan, kind in pairs(channellist) do

			if string.sub(kind[1], 1, 5) == "Kanal" or string.sub(kind[1], 1, 7) == "Channel" then

				table.insert(csaKindTable, kind[1])
			end
		end
	end


	Skada:CurrentSort(csaKindTable, "CSK")
	Skada:CurrentSort(csaNameTable, "CSA")
	Skada:CurrentSort(cscNameTable, "CSC")


	table.insert(cscNameTable,  1, "dividingLineA")
	table.insert(cscNameTable,  4, "dividingLineB")
	table.insert(cscNameTable,  8, "dividingLineC")
	table.insert(cscNameTable, 11, "dividingLineD")
	table.insert(cscNameTable, 14, "dividingLineE")


	if cachedChannelSort then
	
			if channelSort[1] == "CSA" then channelDropdown:SetList(sortTable, csaNameTable) end
			if channelSort[1] == "CSC" then channelDropdown:SetList(sortTable, cscNameTable) end
	end


	channelButton:SetCallback("OnClick",

					function()

						if channelSort[1] == "CSA" then

							channelLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Channel"] .. " - " .. L["Categorized"])


							channelDropdown:AddItem("dividingLineA", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Guild"])
							channelDropdown:AddItem("dividingLineB", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Group"])
							channelDropdown:AddItem("dividingLineC", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Local"])
							channelDropdown:AddItem("dividingLineD", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Whisper"])
							channelDropdown:AddItem("dividingLineE", "\124cnNORMAL_FONT_COLOR:" .. L["Chat Channel"])


							table.insert(channelSort, 1, "CSC")
							table.remove(channelSort)

							channelButton:SetText(labelButton[2])
							channelDropdown:SetList(sortTable, cscNameTable)
						else

							channelLabel:SetText("\124cnNORMAL_FONT_COLOR:" .. L["Channel"] .. " - " .. L["Alphabetical"])

							table.insert(channelSort, 1, "CSA")
							table.remove(channelSort)

							channelButton:SetText(labelButton[1])
							channelDropdown:SetList(sortTable, csaNameTable)
						end

						return
					end

				  )


	frame:AddChild(channelButton)


	local origchan = Skada.db.profile.report.channel or "say"


	if not channellist[origchan] then origchan = "say" end


	channelDropdown:SetCallback("OnEnter",

					function()

						channelDropdown:SetItemDisabled("dividingLineA", true)
						channelDropdown:SetItemDisabled("dividingLineB", true)
						channelDropdown:SetItemDisabled("dividingLineC", true)
						channelDropdown:SetItemDisabled("dividingLineD", true)
						channelDropdown:SetItemDisabled("dividingLineE", true)
					end

				)


	channelDropdown:SetValue(origchan)
	channelDropdown:SetCallback("OnValueChanged",

			       function(f, e, value)

				       Skada.db.profile.report.channel = value
				       Skada.db.profile.report.chantype = channellist[value][2]


				       if channellist[origchan][3] ~= channellist[value][3] then

					       local pos = { frame:GetPoint() }
					       destroywindow()

					       Skada:CreateReportWindow(window)
					       Skada.ReportWindow:SetPoint(unpack(pos))
				       end
			       end

			      )

	frame:AddChild(channelDropdown)


	local lines = AceGUI:Create("Slider")


	lines:SetLabel(L["Lines"])
	lines:SetValue(Skada.db.profile.report.number ~= nil and Skada.db.profile.report.number	 or 10)
	lines:SetSliderValues(1, 25, 1)

	lines:SetCallback("OnValueChanged", function(self, event, value) Skada.db.profile.report.number = value end)
	lines:SetFullWidth(true)


	frame:AddChild(lines)


	if channellist[origchan][3] then

		local whisperbox = AceGUI:Create("EditBox")


		whisperbox:SetLabel(L["Whisper Target"])
		whisperbox:SetText(Skada.db.profile.report.target or "")
		whisperbox:SetCallback("OnEnterPressed",

				       function(box, event, text)

					       if strlenutf8(text) == #text then

						       local ntext = text:gsub("%s","")

						       if ntext ~= text then

							       text = ntext
							       whisperbox:SetText(text)
						       end
					       end

					       Skada.db.profile.report.target = text
					       frame.button.frame:Click()
				       end
				      )


		whisperbox:SetCallback("OnTextChanged", function(box, event, text) Skada.db.profile.report.target = text end)
		whisperbox:SetFullWidth(true)

		frame:AddChild(whisperbox)
	end



	local report = AceGUI:Create("Button")
	frame.button = report

	report:SetText(L["Report"])
	report:SetCallback("OnClick",

			   function()

				   local mode, set, channel, chantype, number = Skada.db.profile.report.mode, Skada.db.profile.report.set,
					 Skada.db.profile.report.channel, Skada.db.profile.report.chantype, Skada.db.profile.report.number

				   if channel == "whisper" then

					   channel = Skada.db.profile.report.target

					   if channel and #strtrim(channel) == 0 then channel = nil end
				   elseif channel == "bnet" then

					   channel = BNet_GetBNetIDAccount(Skada.db.profile.report.target)
				   elseif channel == "target" then

					   if UnitExists("target") then

						   local toon, realm = UnitName("target")

						   if realm and #realm > 0 then
							   channel = toon .. "-" .. realm
						   else
							   channel = toon
						   end
					   else

						   channel = nil
					   end
				   end


				   if channel and chantype and mode and set and number then

					   Skada:Report(channel, chantype, mode, set, number, window)
					   frame:Hide()
				   else

					   Skada:Print("Error: Whisper target not found")
				   end
			   end
			  )


	report:SetFullWidth(true)
	frame:AddChild(report)
end




-- ======================================
-- | menu variant: create submenu arrow |
-- ======================================
function MenuVariants.CreateSubmenuArrow(frame)

	size = mSize

	local arrow = frame:AttachTexture()
	frame.arrow = arrow

	arrow:SetPoint("RIGHT")
	arrow:SetSize(size, size)
	arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
	arrow:SetDrawLayer("ARTWORK")

	return arrow;
end