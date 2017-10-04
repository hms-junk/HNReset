--@optimizations
local game = game
local Color3 = Color3
local Vector3 = Vector3
local string = string
local math = math
local table = table
local tonumber = tonumber
local pairs = pairs
--@main
local hnUtil = { }
local HttpService = game:GetService("HttpService")

function hnUtil.HexToVector3(hex, decimal)
    hex = hex:gsub("#", "")
	if decimal then
		return Vector3.new(tonumber("0x" .. hex:sub(1, 2) / 255), tonumber("0x" .. hex:sub(3, 4) / 255), tonumber("0x" .. hex:sub(5, 6)) / 255)
	elseif not decimal then
		return Vector3.new(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)))
	elseif decimal == nil then
		return Vector3.new(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)))
	end
end

function hnUtil.HexToColor3(hex, decimal)
	hex = hex:gsub("#", "")
    if decimal then
		return Color3.new(tonumber("0x" .. hex:sub(1, 2) / 255), tonumber("0x" .. hex:sub(3, 4) / 255), tonumber("0x" .. hex:sub(5, 6)) / 255)
	elseif not decimal then
		return Color3.new(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)))
	elseif decimal == nil then
		return Color3.new(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)))
	end
end

function hnUtil.Color3ToHex(clr3)
	local hx = "0x"
	if (not clr3.r == math.floor(clr3.r)) or (not clr3.g == math.floor(clr3.g)) or (not clr3.b == math.floor(clr3.b)) then
		rgb = { clr3.r * 255, clr3.g * 255, clr3.b * 255 }
	else
		rgb = { clr3.r, clr3.g, clr3.b }
	end
	for key, value in pairs(rgb) do
		local hex = ""
		while value > 0 do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub("0123456789ABCDEF", index, index) .. hex
		end
		if #hex == 0 then --if string.len(hex) == 0 then
			hex = "00"
		elseif #hex == 1 then --elseif string.len(hex) == 1 then
			hex = "0" .. hex
		end
		hx = hx .. hex
	end
	return hx
end

function hnUtil.Vector3ToHex(vec3)
	local hx = "0X"
	if (not vec3.x == math.floor(vec3.x)) or (not vec3.y == math.floor(vec3.y)) or (not vec3.z == math.floor(vec3.z)) then
		rgb = { vec3.x * 255, vec3.y * 255, vec3.z * 255 }
	else
		rgb = { vec3.x, vec3.y, vec3.z }
	end
	for key, value in pairs(rgb) do
		local hex = ""
		while value > 0 do --while value > 0cdo lol, nice typing.
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub("0123456789ABCDEF", index, index) .. hex
		end
		if #hex == 0 then
			hex = "00"
		elseif #hex == 1 then
			hex = "0" .. hex
		end
		hx = hx .. hex
	end
	return hx
end

function hnUtil.rrandom()
	numbers = { }
	for i = 1, 255 do
		if min == nil or max == nil then
			newvalues = math.random(-100, 100)
		elseif max == nil and min ~= nil then
			newvalues = math.random(min, 100)
		elseif min == nil and max ~= nil then
			newvalues = math.random(-100, max)
		else
			newvalues = math.random(min, max)
		end
		table.insert(numbers, #numbers, newvalues)
	end
	term = math.random(1, 255)
	return numbers[term]
end

return hnUtil
