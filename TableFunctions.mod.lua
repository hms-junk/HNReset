--This library handles a variety of table-based operations, which can be quite useful.
--@author fq_d, MICHEAL1988351, Quenty, Narrev
local setmetatable, getmetatable = setmetatable, getmetatable
local table = table
local type = type
local pairs, next, ipairs = pairs, next, ipairs
local tostring = tostring
local math = math local floor = math.floor local rng = math.random
local TableFunctions = setmetatable({ }, { __index = table })

--[[
	@usage:
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local table = require(ReplicatedStorage.TableFunctions)
	@functions
		table.NewInsert(Table, Index, Value)
			Works like table.insert(), but optimized.
		
		table.NewRemove(Table, Index)
			Works like table.remove(), but optimized.
		
		table.Count(Table)
			Counts the number of elements in the table.
		
		table.CopyAndAppendTable(OriginalTable, AppendedItems)
			Copies the original table, and then appends the values.
		
		table.GetStringTable(Table)
			Converts a table into a more human readable string.
		
		table.Append(Table, NewTable, Callback=nil)
			Appends items to Table from NewTable.
			Callback(Item)
				If exists, calls this before adding the item to the table.
		
		table.DirectAppend(Table, NewTable, Callback)
			Same way, but appends in a key-value merge instead of table.NewInsert.
		
		table.CopyTable(Table)
			Shallow copy of the table involved.
		
		table.DeepCopyTable
			Deep copy of the table involved.
		
		table.ShellSort
			Shellsort on the table.
		
		table.Contains(Table, Value)
			Returns whether @param value is in @param table.
		
		table.Copy(Table)
			Returns a new table that is a copy of @param table.
		
		table.GetIndexByValue(Table, Value)
			Returns the index of a Value in a table.
			@param - Table: table to search through.
			@value: the value to search for.
			@return The key of the value. Returns nil if it can't find it.
		
		table.Random(Table)
			Returns a random value (with an integer key) from @param Table.
			NewMap = table.Random{ map1, map2, map3 }
		
		table.Sum(Table)
			Adds up all the values in @param table via pairs.
		
		table.Overflow(Table, Seed)
			Continually subtracts the values (via ipairs) in @param Table from @param Seed until seed cannot be subtracted from further
			It then returns index at which the iterated value is greater than the remaining seed, and leftover seed (before subtracting final value)
			This can be used for relative probability.
			The following example chooses a random value from the Options table, with some options being more likely than others:
				local Options = { "opt1", "opt2", "opt3", "opt4", "opt5", "opt6" }
				local tab = { 2, 4, 5, 6, 1, 2 }
				local seed = math.random(1, table.Sum(tab))
				local chosenKey, LeftoverSeed = table.Overflow(tab, seed)
				local randomChoiceFromOptions = Options[chosenKey]
		
		yeet
]]--

local function NewInsert(Table, Index, Value)
	if Value ~= nil then
		if type(Index) == "number" then
			local tLen = #Table
			for i = tLen, Index do
				Table[i + 1] = Table[i]
			end
			Table[Index] = Value
		end
	else
		Table[#Table + 1] = Index
	end
end
TableFunctions.NewInsert = NewInsert
TableFunctions.newInsert = NewInsert
TableFunctions.new_insert = NewInsert

local function NewRemove(Table, Index)
	if type(Index) == "number" then
		Table[Index] = nil
		local tLen = #Table
		for i = Index + 1, tLen do
			Table[i - 1] = Table[i]
		end
		Table[tLen] = nil
	end
end
TableFunctions.NewRemove = NewRemove
TableFunctions.newRemove = NewRemove
TableFunctions.new_remove = NewRemove

--[[
local function NewConcat(Table, A, B)
	local X, Y, Z = ""
	for Index, _ in pairs(Table) do
		Y = Index
	end
	for Index, Value in pairs(Table) do
		X = X .. (not Z and Value or Index ~= Y and A .. Value or A .. B .. Value)
		Z = true
	end
	return X
end
TableFunctions.NewConcat = NewConcat
TableFunctions.newConcat = NewConcat
TableFunctions.new_concat = NewConcat
]]--

local function Count(Table)
	local Count = 0
	for _, _ in pairs(Table) do
		Count = Count + 1
	end
	return Count
end
TableFunctions.Count = Count
TableFunctions.count = Count

local function CopyAndAppendTable(OriginalTable, AppendedItems)
	local NewTable = { }
	for Index, Value in pairs(OriginalTable) do
		NewTable[Index] = Value
	end
	for Index, Value in pairs(AppendedItems) do
		NewTable[Index] = Value
	end
	return NewTable
end
TableFunctions.CopyAndAppend = CopyAndAppendTable
TableFunctions.copyAndAppend = CopyAndAppendTable
TableFunctions.copy_and_append = CopyAndAppendTable

local GetStringTable
function GetStringTable(Array, Indent, PrintValue)
	PrintValue = PrintValue or tostring(Array)
	Indent = Indent or 0
	for Index, Value in pairs(Array) do
		local Indentation = "  " --maybe do a tab like below?
	--	local Indentation = "	"
		local FormattedText = "\n" .. Indentation:rep(Indent) .. tostring(Index) .. ": "
		if type(Value) == "table" then
			PrintValue = PrintValue .. FormattedText
			PrintValue = GetStringTable(Value, Index + 1, PrintValue)
		else
			PrintValue = PrintValue .. FormattedText .. tostring(Value)
		end
	end
	return PrintValue
end
TableFunctions.GetStringTable = GetStringTable
TableFunctions.getStringTable = GetStringTable
TableFunctions.get_string_table = GetStringTable

local function Append(Table, NewTable, Callback)
	if Callback then
		for _, Item in pairs(NewTable) do
			if Callback(Item) then
				TableFunctions.TableInsert(Table, Item) --can I do this? :thinking:
			end
		end
	else
		for _, Item in pairs(NewTable) do
			TableFunctions.TableInsert(Table, Item)
		end
	end
	return Table
end
TableFunctions.Append = Append
TableFunctions.append = Append

local function DirectAppend(Table, NewTable, Callback)
	if Callback then
		for Index, Item in pairs(NewTable) do
			if Callback(Item) then
				Table[Index] = Item
			end
		end
	else
		for Index, Item in pairs(NewTable) do
			Table[Index] = Item
		end
	end
	return Table
end
TableFunctions.DirectAppend = DirectAppend
TableFunctions.directAppend = DirectAppend
TableFunctions.direct_append = DirectAppend

local function DeepDirectAppend(Table, NewTable)
	for Index, Value in pairs(NewTable) do
		if type(Table[Index]) == "table" and type(Value) == "table" then
			Table[Index] = DeepDirectAppend(Table[Index], Value)
		else
			Table[Index] = Value
		end
	end
	return Table
end
TableFunctions.DeepDirectAppend = DeepDirectAppend

local function CopyTable(OriginalTable)
	local Copy
	if type(OriginalTable) == "table" then
		Copy = { }
		for Index, Value in pairs(OriginalTable) do
			Copy[Index] = Value
		end
	else
		Copy = OriginalTable
	end
	return Copy
end
TableFunctions.Copy = CopyTable
TableFunctions.copy = CopyTable

local DeepCopy
function DeepCopy(OriginalTable)
	local OriginalType = type(OriginalTable)
	local Copy
	if OriginalType == "table" then
		Copy = { }
		for Index, Value in next, OriginalTable, nil do
			Copy[DeepCopy(Index)] = DeepCopy(Value)
		end
		setmetatable(Copy, DeepCopy(getmetatable(OriginalTable)))
	else
		Copy = OriginalTable
	end
	return Copy
end
TableFunctions.DeepCopy = DeepCopy
TableFunctions.deepCopy = DeepCopy
TableFunctions.deep_copy = DeepCopy

local function ShellSort(Table, GetValue)
	local function Swap(Table, A, B) Table[A], Table[B] = Table[B], Table[A] end
	local TableSize = #Table
	local Gap = #Table repeat
		local Switched repeat
			Switched = false
			local Index = 1
			while Index + Gap <= TableSize do
				if GetValue(Table[Index]) > GetValue(Table[Index + Gap]) then
					Swap(Table, Index, Index + Gap)
					Switched = true
				end
				Index = Index + 1
			end
		until not Switched
		Gap = floor(Gap * 0.5)
	until Gap == 0
end
TableFunctions.ShellSort = ShellSort
TableFunctions.shellSort = ShellSort
TableFunctions.shell_sort = ShellSort

local function Random(Table)
	return Table[rng(1, #Table)]
end
--local function Random(Table)
--	local Indexes = (function()
--		local RandomTable = { }
--		for i, _ in pairs(Table) do
--			RandomTable[#RandomTable + 1] = i
--		end
--		return RandomTable
--	end)()
--	return Table[Indexes[rng(1, #Indexes)]]
--end
TableFunctions.Random = Random
TableFunctions.random = Random

local function Contains(Table, Value)
	for _, v in pairs(Table) do
		if v == Value then
			return true
		end
	end
	return false
end
TableFunctions.Contains = Contains
TableFunctions.contains = Contains

local function Overflow(Table, Seed)
	for Index, Value in ipairs(Table) do
		if Seed - Value <= 0 then
			return Index, Seed
		end
		Seed = Seed - Value
	end
end
TableFunctions.Overflow = Overflow
TableFunctions.overflow = Overflow

local function Sum(Table)
	local Sum = 0
	for _, Value in pairs(Table) do
		Sum = Sum + Value
	end
	return Sum
end
TableFunctions.Sum = Sum
TableFunctions.sum = Sum

local function GetIndexByValue(Table, Value)
	for Index, TableValue in pairs(Table) do
		if Value == TableValue then
			return Index
		end
	end
	return nil
end
TableFunctions.GetIndexByValue = GetIndexByValue
TableFunctions.getIndexByValue = GetIndexByValue
TableFunctions.indexByValue = GetIndexByValue
TableFunctions.IndexByValue = GetIndexByValue
TableFunctions.index_by_value = GetIndexByValue

return TableFunctions
