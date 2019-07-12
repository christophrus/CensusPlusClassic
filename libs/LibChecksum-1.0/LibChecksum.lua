-- Author      : christophrus
-- Create Date : 7/7/2019 1:57:37 PM

local MAJOR, MINOR = "LibChecksum-1.0", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then
  return	-- already loaded and no upgrade necessary
end


-- from Maunotavast at https://eu.battle.net/forums/en/wow/topic/9337744534#post-4
local function utf8split(str)
	local utf8table = {}
	str:gsub("([^\128-\191][\128-\191]*)", function(char)
		local leadbyte = strbyte(char, 1)
		local length = -1

		if leadbyte < 248 then
			if leadbyte >= 240 then
				length = 4
			elseif leadbyte >= 224 then
				length = 3
			elseif leadbyte >= 192 then
				length = 2
			elseif leadbyte < 128 then
				length = 1
			end
		end

		tinsert(utf8table, (length == #char) and char)
	end)
	return utf8table
end

-- Copyright (c) 2006-2007, Kyle Smith
-- Copyright (c) 2019, christophrus
-- All rights reserved.
--
-- 
-- ABNF from RFC 3629
--
-- UTF8-octets = *( UTF8-char )
-- UTF8-char   = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4
-- UTF8-1      = %x00-7F
-- UTF8-2      = %xC2-DF UTF8-tail
-- UTF8-3      = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /
--               %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )
-- UTF8-4      = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /
--               %xF4 %x80-8F 2( UTF8-tail )
-- UTF8-tail   = %x80-BF
--
-- function scaffold of codepoint() is taken from Kyle Smith's
-- utf8charbytes() function out of his utf8.lua and enriched 
-- with unicode codepoint extraction

function codepoint(s)

	if (s == "" or s == nil) then
		return false
	end

	-- argument checking
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8charbytes' (string expected, got ".. type(s).. ")")
	end

	

	local codepoint
	local c1 = strbyte(s, 1)

	-- determine bytes needed for character, based on RFC 3629
	-- validate byte 1
	if c1 > 0 and c1 <= 127 then
		-- UTF8-1
		return c1

	elseif c1 >= 194 and c1 <= 223 then
		-- UTF8-2
		local c2 = strbyte(s, 2)

		if not c2 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- by christophrus
		-- encoding format is 110wwwww 10xxxxxx
		-- codepoint is ww wwwxxxxx
		local w = bit.band(c1, 0x1f)
		local x = bit.band(c2, 0x3f)

		-- concatenate the bits
		local wx = bit.bor(bit.lshift(w, 6), x)

		return wx

	elseif c1 >= 224 and c1 <= 239 then
		-- UTF8-3
		local c2 = strbyte(s, 2)
		local c3 = strbyte(s, 3)

		if not c2 or not c3 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c1 == 224 and (c2 < 160 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c1 == 237 and (c2 < 128 or c2 > 159) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		-- by christophrus
		-- encoding format is 110wwwww 10xxxxxx 10yyyyyy
		-- codepoint is w wwwwxxxx xxyyyyyy
		local w = bit.band(c1, 0x1f)
		local x = bit.band(c2, 0x3f)
		local y = bit.band(c3, 0x3f)

		-- concatenate the bits
		local wx = bit.bor(bit.lshift(w, 6), x)
		local wxy = bit.bor(bit.lshift(wx, 6), y)
		
		return wxy

	elseif c1 >= 240 and c1 <= 244 then
		-- UTF8-4
		local c2 = strbyte(s, 2)
		local c3 = strbyte(s, 3)
		local c4 = strbyte(s, 4)

		if not c2 or not c3 or not c4 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c1 == 240 and (c2 < 144 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c1 == 244 and (c2 < 128 or c2 > 143) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 4
		if c4 < 128 or c4 > 191 then
			error("Invalid UTF-8 character")
		end

		-- by christophrus
		-- encoding format is 11110www 10xxxxxx 10yyyyyy 10zzzzzz
		-- codepoint is wwwxx xxxxyyyy yyzzzzzz
		local w = bit.band(c1, 0x7)
		local x = bit.band(c2, 0x3f)
		local y = bit.band(c3, 0x3f)
		local z = bit.band(c4, 0x3f)

		-- concatenate the bits
		local wx = bit.bor(bit.lshift(w, 6), x)
		local wxy = bit.bor(bit.lshift(wx, 6), y)
		local wxyz = bit.bor(bit.lshift(wxy, 6), z)

		return wxyz

	else
		error("Invalid UTF-8 character")
	end
end

-- by Mikk - taken from https://wowwiki.fandom.com/wiki/USERAPI_StringHash
local function generateChecksum(str)
	local counter = 1
	str = utf8split(str);
	for i = 1, #str, 3 do 
		counter = math.fmod(counter*8161, 4294967279) +  -- 2^32 - 17: Prime!
		(codepoint(str[i])*16776193) +
		((codepoint(str[i+1]) or (#str-i+256))*8372226) +
		((codepoint(str[i+2]) or (#str-i+256))*3932164)
	end
	return math.fmod(counter, 4294967291) -- 2^32 - 5: Prime (and different from the prime in the loop)
end

function lib:generate(str)
	return generateChecksum(str)
end

function lib:verify(str, checksum)
	return checksum == generateChecksum(str)
end