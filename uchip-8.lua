#!/usr/bin/env lua
if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	return {
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
	}
end)()
for k, v in pairs(_temp) do _libs["lua/basic-0/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _2a_1, _2f_1, _25_1, _2e2e_1, arg_23_1, len_23_1, slice1, error1, getmetatable1, print1, getIdx1, setIdx_21_1, tonumber1, tostring1, type_23_1, _23_1, byte1, char1, find1, format1, gsub1, len1, lower1, sub1, concat1, unpack1, iterPairs1, car1, cdr1, list1, cons1, _21_1, pretty1, arg1, apply1, list_3f_1, empty_3f_1, string_3f_1, type1, eq_3f_1, neq_3f_1, floor1, min1, car2, cdr2, map1, traverse1, nth1, nths1, pushCdr_21_1, range1, cadr1, cadar1, caddr1, charAt1, _2e2e_2, split1, trim1, exit1, getenv1, open1, exit_21_1, self1, readAllMode_21_1, readAll_21_1, readLines_21_1, writeAllMode_21_1, writeBytes_21_1, config1, coloredAnsi1, colored_3f_1, colored1, failed1, err_21_1, errLine_21_1, exitFailed_21_1, removeComments1, getLineParts1, lettersOnly1, validLabel1, parseInt1, parseByte1, parseAddress1, parseRegister1, parseSpecial1, parseToken1, makeTokens1, lex1, resolveLabels1, errArgs_21_1, assertArgs_21_1, generateOpcode1, generateBinary1, parse1, loadInput_21_1, writeOutput_21_1, compile1, run1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_2a_1 = function(v1, v2) return (v1 * v2) end
_2f_1 = function(v1, v2) return (v1 / v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
_2e2e_1 = function(v1, v2) return (v1 .. v2) end
arg_23_1 = arg
len_23_1 = function(v1) return #(v1) end
slice1 = _libs["lua/basic-0/slice"]
error1 = error
getmetatable1 = getmetatable
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
tonumber1 = tonumber
tostring1 = tostring
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
byte1 = string.byte
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
len1 = string.len
lower1 = string.lower
sub1 = string.sub
concat1 = table.concat
unpack1 = table.unpack
iterPairs1 = function(x, f) for k, v in pairs(x) do f(k, v) end end
car1 = (function(xs1)
	return xs1[1]
end)
cdr1 = (function(xs2)
	return slice1(xs2, 2)
end)
list1 = (function(...)
	local xs3 = _pack(...) xs3.tag = "list"
	return xs3
end)
cons1 = (function(x2, xs4)
	return (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = x2
		_temp = xs4
		for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 1
		return _result
	end)()
end)
_21_1 = (function(expr1)
	return not expr1
end)
pretty1 = (function(value1)
	local ty1 = type_23_1(value1)
	if (ty1 == "table") then
		local tag1 = value1["tag"]
		if (tag1 == "list") then
			local out1 = ({tag = "list", n = 0})
			local r_51 = _23_1(value1)
			local r_31 = nil
			r_31 = (function(r_41)
				if (r_41 <= r_51) then
					out1[r_41] = pretty1(value1[r_41])
					return r_31((r_41 + 1))
				else
				end
			end)
			r_31(1)
			return ("(" .. (concat1(out1, " ") .. ")"))
		elseif ((type_23_1(getmetatable1(value1)) == "table") and (type_23_1(getmetatable1(value1)["--pretty-print"]) == "function")) then
			return getmetatable1(value1)["--pretty-print"](value1)
		elseif (tag1 == "list") then
			return value1["contents"]
		elseif (tag1 == "symbol") then
			return value1["contents"]
		elseif (tag1 == "key") then
			return (":" .. value1["value"])
		elseif (tag1 == "string") then
			return format1("%q", value1["value"])
		elseif (tag1 == "number") then
			return tostring1(value1["value"])
		else
			local out2 = ({tag = "list", n = 0})
			iterPairs1(value1, (function(k1, v1)
				out2 = cons1((pretty1(k1) .. (" " .. pretty1(v1))), out2)
				return nil
			end))
			return ("{" .. (concat1(out2, " ") .. "}"))
		end
	elseif (ty1 == "string") then
		return format1("%q", value1)
	else
		return tostring1(value1)
	end
end)
if (nil == arg_23_1) then
	arg1 = ({tag = "list", n = 0})
else
	arg_23_1["tag"] = "list"
	if arg_23_1["n"] then
	else
		arg_23_1["n"] = #(arg_23_1)
	end
	arg1 = arg_23_1
end
apply1 = (function(f1, xs5)
	return f1(unpack1(xs5, 1, _23_1(xs5)))
end)
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
empty_3f_1 = (function(x4)
	local xt1 = type1(x4)
	if (xt1 == "list") then
		return (_23_1(x4) == 0)
	elseif (xt1 == "string") then
		return (#(x4) == 0)
	else
		return false
	end
end)
string_3f_1 = (function(x5)
	return ((type_23_1(x5) == "string") or ((type_23_1(x5) == "table") and (x5["tag"] == "string")))
end)
type1 = (function(val1)
	local ty2 = type_23_1(val1)
	if (ty2 == "table") then
		return (val1["tag"] or "table")
	else
		return ty2
	end
end)
eq_3f_1 = (function(x6, y1)
	if (x6 == y1) then
		return true
	else
		local typeX1 = type1(x6)
		local typeY1 = type1(y1)
		if ((typeX1 == "list") and ((typeY1 == "list") and (_23_1(x6) == _23_1(y1)))) then
			local equal1 = true
			local r_291 = _23_1(x6)
			local r_271 = nil
			r_271 = (function(r_281)
				if (r_281 <= r_291) then
					if neq_3f_1(x6[r_281], y1[r_281]) then
						equal1 = false
					end
					return r_271((r_281 + 1))
				else
				end
			end)
			r_271(1)
			return equal1
		elseif (("symbol" == typeX1) and ("symbol" == typeY1)) then
			return (x6["contents"] == y1["contents"])
		elseif (("key" == typeX1) and ("key" == typeY1)) then
			return (x6["value"] == y1["value"])
		elseif (("symbol" == typeX1) and ("string" == typeY1)) then
			return (x6["contents"] == y1)
		elseif (("string" == typeX1) and ("symbol" == typeY1)) then
			return (x6 == y1["contents"])
		elseif (("key" == typeX1) and ("string" == typeY1)) then
			return (x6["value"] == y1)
		elseif (("string" == typeX1) and ("key" == typeY1)) then
			return (x6 == y1["value"])
		else
			return false
		end
	end
end)
neq_3f_1 = (function(x7, y2)
	return _21_1(eq_3f_1(x7, y2))
end)
floor1 = math.floor
min1 = math.min
car2 = (function(x8)
	local r_531 = type1(x8)
	if (r_531 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", r_531), 2)
	end
	return car1(x8)
end)
cdr2 = (function(x9)
	local r_541 = type1(x9)
	if (r_541 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", r_541), 2)
	end
	if empty_3f_1(x9) then
		return ({tag = "list", n = 0})
	else
		return cdr1(x9)
	end
end)
map1 = (function(fn1, ...)
	local xss1 = _pack(...) xss1.tag = "list"
	local lenghts1
	local out3 = ({tag = "list", n = 0})
	local r_631 = _23_1(xss1)
	local r_611 = nil
	r_611 = (function(r_621)
		if (r_621 <= r_631) then
			pushCdr_21_1(out3, _23_1(nth1(xss1, r_621)))
			return r_611((r_621 + 1))
		else
		end
	end)
	r_611(1)
	lenghts1 = out3
	local out4 = ({tag = "list", n = 0})
	local r_391 = apply1(min1, lenghts1)
	local r_371 = nil
	r_371 = (function(r_381)
		if (r_381 <= r_391) then
			pushCdr_21_1(out4, apply1(fn1, nths1(xss1, r_381)))
			return r_371((r_381 + 1))
		else
		end
	end)
	r_371(1)
	return out4
end)
traverse1 = (function(xs6, f2)
	return map1(f2, xs6)
end)
nth1 = (function(xs7, idx1)
	return xs7[idx1]
end)
nths1 = (function(xss2, idx2)
	local out5 = ({tag = "list", n = 0})
	local r_431 = _23_1(xss2)
	local r_411 = nil
	r_411 = (function(r_421)
		if (r_421 <= r_431) then
			pushCdr_21_1(out5, nth1(nth1(xss2, r_421), idx2))
			return r_411((r_421 + 1))
		else
		end
	end)
	r_411(1)
	return out5
end)
pushCdr_21_1 = (function(xs8, val2)
	local r_781 = type1(xs8)
	if (r_781 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_781), 2)
	end
	local len2 = (_23_1(xs8) + 1)
	xs8["n"] = len2
	xs8[len2] = val2
	return xs8
end)
range1 = (function(start1, _eend1)
	local out6 = ({tag = "list", n = 0})
	local r_451 = nil
	r_451 = (function(r_461)
		if (r_461 <= _eend1) then
			pushCdr_21_1(out6, r_461)
			return r_451((r_461 + 1))
		else
		end
	end)
	r_451(start1)
	return out6
end)
cadr1 = (function(x10)
	return car2(cdr2(x10))
end)
cadar1 = (function(x11)
	return car2(cdr2(car2(x11)))
end)
caddr1 = (function(x12)
	return car2(cdr2(cdr2(x12)))
end)
charAt1 = (function(xs9, x13)
	return sub1(xs9, x13, x13)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out7 = ({tag = "list", n = 0})
	local loop1 = true
	local start2 = 1
	local r_881 = nil
	r_881 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start2))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			if ((nstart1 == nil) or (limit1 and (_23_1(out7) >= limit1))) then
				loop1 = false
				pushCdr_21_1(out7, sub1(text1, start2, len1(text1)))
				start2 = (len1(text1) + 1)
			elseif (nstart1 > len1(text1)) then
				if (start2 <= len1(text1)) then
					pushCdr_21_1(out7, sub1(text1, start2, len1(text1)))
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out7, sub1(text1, start2, nstart1))
				start2 = (nstart1 + 1)
			else
				pushCdr_21_1(out7, sub1(text1, start2, (nstart1 - 1)))
				start2 = (nend1 + 1)
			end
			return r_881()
		else
		end
	end)
	r_881()
	return out7
end)
trim1 = (function(str1)
	return (gsub1(gsub1(str1, "^%s+", ""), "%s+$", ""))
end)
exit1 = os.exit
getenv1 = os.getenv
open1 = io.open
exit_21_1 = (function(reason1, code1)
	local code2
	if string_3f_1(reason1) then
		code2 = code1
	else
		code2 = reason1
	end
	if string_3f_1(reason1) then
		print1(reason1)
	end
	return exit1(code2)
end)
self1 = (function(x14, key1, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x14[key1](x14, unpack1(args2, 1, _23_1(args2)))
end)
readAllMode_21_1 = (function(path1, binary1)
	local handle1 = open1(path1, _2e2e_2("r", (function()
		if binary1 then
			return "b"
		else
			return ""
		end
	end)()
	))
	if handle1 then
		local data1 = self1(handle1, "read", "*all")
		if data1 then
			self1(handle1, "close")
			return data1
		else
			return nil
		end
	else
		return nil
	end
end)
readAll_21_1 = (function(path2)
	return readAllMode_21_1(path2, false)
end)
readLines_21_1 = (function(path3)
	local data2 = readAll_21_1(path3)
	if data2 then
		return split1(data2, "\n")
	else
	end
end)
writeAllMode_21_1 = (function(path4, append1, binary2, data3)
	local handle2 = open1(path4, _2e2e_2((function()
		if append1 then
			return "a"
		else
			return "w"
		end
	end)()
	, (function()
		if binary2 then
			return "b"
		else
			return ""
		end
	end)()
	))
	if handle2 then
		self1(handle2, "write", data3)
		self1(handle2, "close")
		return true
	else
		return false
	end
end)
writeBytes_21_1 = (function(path5, data4)
	local bytes_2d3e_string1
	bytes_2d3e_string1 = (function(bytes1, idx3)
		if (idx3 > _23_1(bytes1)) then
			return ({tag = "list", n = 0})
		else
			return cons1(char1(nth1(bytes1, idx3)), bytes_2d3e_string1(bytes1, (idx3 + 1)))
		end
	end)
	return writeAllMode_21_1(path5, false, true, concat1(bytes_2d3e_string1(data4, 1)))
end)
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_2("\27[", col1, "m", msg1, "\27[0m")
end)
if (config1 and (charAt1(config1, 1) ~= "\\")) then
	colored_3f_1 = true
elseif (getenv1 and (getenv1("ANSICON") ~= nil)) then
	colored_3f_1 = true
else
	local temp1
	if getenv1 then
		local term1 = getenv1("TERM")
		if term1 then
			temp1 = find1(term1, "xterm")
		else
			temp1 = nil
		end
	else
		temp1 = false
	end
	if temp1 then
		colored_3f_1 = true
	else
		colored_3f_1 = false
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg2)
		return msg2
	end)
end
failed1 = ({tag = "list", n = 1, ({ tag="symbol", contents="false", var="table: 0xed6770"})})
err_21_1 = (function(message1)
	print1(colored1(31, _2e2e_2("[ERROR] ", message1)))
	failed1[1] = true
	return nil
end)
errLine_21_1 = (function(line1, message2)
	return err_21_1(_2e2e_2("line ", tostring1(line1), ": ", message2))
end)
exitFailed_21_1 = (function()
	if (nth1(failed1, 1) == true) then
		return exit_21_1("compilation failed.", -1)
	else
	end
end)
removeComments1 = (function(line2)
	if find1(line2, ";") then
		return removeComments1(sub1(line2, 1, (find1(line2, ";") - 1)))
	else
		return line2
	end
end)
getLineParts1 = (function(line3)
	local line4 = lower1(trim1(removeComments1(line3)))
	if eq_3f_1(line4, "") then
		return ({tag = "list", n = 0})
	else
		local cmd1
		if find1(line4, "%s") then
			cmd1 = sub1(line4, 1, (find1(line4, "%s") - 1))
		else
			cmd1 = line4
		end
		return cons1(cmd1, (function(args3)
			return args3
		end)((function()
			if find1(line4, "%s") then
				return map1(trim1, split1(sub1(line4, (find1(line4, "%s") + 1), len1(line4)), ","))
			else
				return ({tag = "list", n = 0})
			end
		end)()
		))
	end
end)
lettersOnly1 = (function(str2)
	local match1 = true
	local r_2161 = range1(1, len1(str2))
	local r_2191 = _23_1(r_2161)
	local r_2171 = nil
	r_2171 = (function(r_2181)
		if (r_2181 <= r_2191) then
			local idx4 = r_2161[r_2181]
			local c1 = byte1(charAt1(str2, idx4))
			if ((c1 < 97) or (c1 > 122)) then
				match1 = false
			end
			return r_2171((r_2181 + 1))
		else
		end
	end)
	r_2171(1)
	return match1
end)
validLabel1 = (function(str3)
	local match2 = true
	local r_2231 = range1(1, len1(str3))
	local r_2261 = _23_1(r_2231)
	local r_2241 = nil
	r_2241 = (function(r_2251)
		if (r_2251 <= r_2261) then
			local idx5 = r_2231[r_2251]
			local c2 = byte1(charAt1(str3, idx5))
			if c2 then
				if (idx5 == 1) then
					if (((c2 < 97) or (c2 > 122)) and (c2 ~= 95)) then
						match2 = false
					end
				else
					if (((c2 < 97) or (c2 > 122)) and (((c2 < 48) or (c2 > 57)) and (c2 ~= 95))) then
						match2 = false
					end
				end
			end
			return r_2241((r_2251 + 1))
		else
		end
	end)
	r_2241(1)
	return match2
end)
parseInt1 = (function(str4)
	if (charAt1(str4, len1(str4)) == "h") then
		return tonumber1(sub1(str4, 1, (len1(str4) - 1)), 16)
	else
		return tonumber1(str4, 10)
	end
end)
parseByte1 = (function(str5)
	local int1 = parseInt1(str5)
	if int1 then
		if ((int1 >= 0) and (int1 < 256)) then
			return int1
		else
		end
	else
	end
end)
parseAddress1 = (function(str6)
	if (charAt1(str6, 1) == "$") then
		local int2 = parseInt1(sub1(str6, 2, len1(str6)))
		if int2 then
			if ((int2 >= 0) and (int2 < 4096)) then
				return int2
			else
			end
		else
		end
	else
	end
end)
parseRegister1 = (function(str7)
	if ((charAt1(str7, 1) == "v") and (len1(str7) == 2)) then
		local n1 = tonumber1(charAt1(str7, 2), 16)
		if n1 then
			return list1(({ tag="symbol", contents="v"}), n1)
		else
		end
	elseif (str7 == "i") then
		return list1(({ tag="symbol", contents="i"}))
	elseif (str7 == "st") then
		return list1(({ tag="symbol", contents="st"}))
	elseif (str7 == "dt") then
		return list1(({ tag="symbol", contents="dt"}))
	else
		return nil
	end
end)
parseSpecial1 = (function(str8)
	if (str8 == "k") then
		return list1(({ tag="symbol", contents="k"}))
	elseif (str8 == "f") then
		return list1(({ tag="symbol", contents="f"}))
	elseif (str8 == "b") then
		return list1(({ tag="symbol", contents="b"}))
	elseif (str8 == "[i]") then
		return list1(({ tag="symbol", contents="ai"}))
	else
		return nil
	end
end)
parseToken1 = (function(str9)
	if parseRegister1(str9) then
		return parseRegister1(str9)
	elseif parseSpecial1(str9) then
		return parseSpecial1(str9)
	elseif parseAddress1(str9) then
		return list1(({ tag="symbol", contents="address"}), parseAddress1(str9))
	elseif parseByte1(str9) then
		return list1(({ tag="symbol", contents="byte"}), parseByte1(str9))
	elseif validLabel1(str9) then
		return list1(({ tag="symbol", contents="label"}), str9)
	else
		return ({tag = "list", n = 0})
	end
end)
makeTokens1 = (function(linesParts1)
	return map1((function(lineIdx1)
		local parts1 = nth1(linesParts1, lineIdx1)
		if (_23_1(parts1) > 0) then
			return map1((function(partIdx1)
				local part1 = nth1(parts1, partIdx1)
				if (partIdx1 == 1) then
					if (charAt1(part1, -1) == ":") then
						local label1 = sub1(part1, 1, (len1(part1) - 1))
						if _21_1(validLabel1(label1)) then
							errLine_21_1(lineIdx1, _2e2e_2("invalid label name \"", label1, "\"."))
						end
						return list1(({ tag="symbol", contents="label"}), sub1(part1, 1, (len1(part1) - 1)))
					else
						if _21_1(lettersOnly1(part1)) then
							errLine_21_1(lineIdx1, _2e2e_2("unexpected symbol in opcode \"", part1, "\"."))
						end
						return list1(({ tag="symbol", contents="opcode"}), part1)
					end
				else
					if (part1 == "") then
						errLine_21_1(lineIdx1, "empty argument.")
					end
					local token1 = parseToken1(part1)
					if (_23_1(token1) == 0) then
						errLine_21_1(lineIdx1, _2e2e_2("invalid argument \"", part1, "\"."))
					end
					return token1
				end
			end), range1(1, _23_1(parts1)))
		else
			return ({tag = "list", n = 0})
		end
	end), range1(1, _23_1(linesParts1)))
end)
lex1 = (function(lines1)
	local linesParts2 = map1(getLineParts1, lines1)
	local tokens1 = makeTokens1(linesParts2)
	exitFailed_21_1()
	return tokens1
end)
resolveLabels1 = (function(linesTokens1)
	local labels1 = {}
	local pc1 = 512
	local cutLinesTokens1 = traverse1(linesTokens1, (function(lineTokens1)
		local firstToken1 = car2(lineTokens1)
		if eq_3f_1((function()
			if firstToken1 then
				return car2(firstToken1)
			else
			end
		end)()
		, ({ tag="symbol", contents="opcode"})) then
			if (cadr1(firstToken1) ~= "dd") then
				pc1 = (pc1 + 1)
			end
			pc1 = (pc1 + 1)
			return lineTokens1
		elseif eq_3f_1((function()
			if firstToken1 then
				return car2(firstToken1)
			else
			end
		end)()
		, ({ tag="symbol", contents="label"})) then
			labels1[cadr1(firstToken1)] = pc1
			return ({tag = "list", n = 0})
		else
			return lineTokens1
		end
	end))
	return (traverse1(range1(1, _23_1(cutLinesTokens1)), (function(lineIdx2)
		return traverse1(cutLinesTokens1[lineIdx2], (function(token2)
			if eq_3f_1(car2(token2), ({ tag="symbol", contents="label"})) then
				if labels1[cadr1(token2)] then
					return list1(({ tag="symbol", contents="address"}), labels1[cadr1(token2)])
				else
					errLine_21_1(lineIdx2, _2e2e_2("unknown label \"", cadr1(token2), "\""))
					return nil
				end
			else
				return token2
			end
		end))
	end)))
end)
errArgs_21_1 = (function(lineIdx3, opcode1)
	return errLine_21_1(lineIdx3, _2e2e_2("invalid types of arguments to opcode \"", opcode1, "\""))
end)
assertArgs_21_1 = (function(lineInfo1, paramArgsTypes1)
	local argsTypes1 = car2(lineInfo1)
	if argsTypes1 then
		local opcode2 = cadr1(lineInfo1)
		if opcode2 then
			local lineIdx4 = caddr1(lineInfo1)
			if lineIdx4 then
				if neq_3f_1(argsTypes1, paramArgsTypes1) then
					return errArgs_21_1(lineIdx4, opcode2)
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	else
		return nil
	end
end)
generateOpcode1 = (function(lineTokens2, lineIdx5)
	if empty_3f_1(lineTokens2) then
		return nil
	else
		local argsTokens1 = cdr2(lineTokens2)
		local args4 = map1(cadr1, argsTokens1)
		local argsTypes2 = map1(car2, argsTokens1)
		local nArgs1 = _23_1(args4)
		local opcode3 = cadar1(lineTokens2)
		local lineInfo2 = list1(argsTypes2, opcode3, lineIdx5)
		if (opcode3 == "cls") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 0}))
			return 224
		elseif (opcode3 == "ret") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 0}))
			return 238
		elseif (opcode3 == "sys") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="address"})}))
			return car2(args4)
		elseif (opcode3 == "jp") then
			if eq_3f_1(argsTypes2, ({tag = "list", n = 1, ({ tag="symbol", contents="address"})})) then
				return (4096 + car2(args4))
			else
				assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="address"})}))
				if (car2(args4) == 0) then
					return (45056 + cadr1(args4))
				else
					return errLine_21_1(lineIdx5, "invalid register number to \"jp\"")
				end
			end
		elseif (opcode3 == "call") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="address"})}))
			return (8192 + car2(args4))
		elseif (opcode3 == "se") then
			if eq_3f_1(argsTypes2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="byte"})})) then
				return (12288 + ((256 * car2(args4)) + cadr1(args4)))
			else
				assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
				return (20480 + ((256 * car2(args4)) + (16 * cadr1(args4))))
			end
		elseif (opcode3 == "sne") then
			if eq_3f_1(argsTypes2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="byte"})})) then
				return (16384 + ((256 * car2(args4)) + cadr1(args4)))
			else
				assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
				return (36864 + ((256 * car2(args4)) + (16 * cadr1(args4))))
			end
		elseif (opcode3 == "ld") then
			if (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="byte"})))))) then
				return (24576 + ((256 * car2(args4)) + cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (32768 + ((256 * car2(args4)) + (16 * cadr1(args4))))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="i"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="address"})))))) then
				return (40960 + cadr1(args4))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="dt"})))))) then
				return (61447 + (256 * car2(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="k"})))))) then
				return (61450 + (256 * car2(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="dt"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (61461 + (256 * cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="st"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (61464 + (256 * cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="f"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (61481 + (256 * cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="b"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (61491 + (256 * cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="ai"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (61525 + (256 * cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="ai"})))))) then
				return (61541 + (256 * car2(args4)))
			else
				return errArgs_21_1(lineIdx5, opcode3)
			end
		elseif (opcode3 == "add") then
			if (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="byte"})))))) then
				return (28672 + ((256 * car2(args4)) + cadr1(args4)))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="v"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (32772 + ((256 * car2(args4)) + (16 * cadr1(args4))))
			elseif (list_3f_1(argsTypes2) and ((_23_1(argsTypes2) >= 2) and ((_23_1(argsTypes2) <= 2) and (eq_3f_1(nth1(argsTypes2, 1), ({ tag="symbol", contents="i"})) and eq_3f_1(nth1(argsTypes2, 2), ({ tag="symbol", contents="v"})))))) then
				return (61470 + (256 * cadr1(args4)))
			else
				return errArgs_21_1(lineIdx5, opcode3)
			end
		elseif (opcode3 == "or") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
			return (32769 + ((256 * car2(args4)) + (16 * cadr1(args4))))
		elseif (opcode3 == "and") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
			return (32770 + ((256 * car2(args4)) + (16 * cadr1(args4))))
		elseif (opcode3 == "xor") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
			return (32771 + ((256 * car2(args4)) + (16 * cadr1(args4))))
		elseif (opcode3 == "sub") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
			return (32773 + ((256 * car2(args4)) + (16 * cadr1(args4))))
		elseif (opcode3 == "shr") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="v"})}))
			return (32774 + (256 * car2(args4)))
		elseif (opcode3 == "subn") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"})}))
			return (32775 + ((256 * car2(args4)) + (16 * cadr1(args4))))
		elseif (opcode3 == "shl") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="v"})}))
			return (32782 + (256 * car2(args4)))
		elseif (opcode3 == "rnd") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="byte"})}))
			return (49152 + ((256 * car2(args4)) + cadr1(args4)))
		elseif (opcode3 == "drw") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 3, ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="v"}), ({ tag="symbol", contents="byte"})}))
			if (caddr1(args4) < 16) then
				return (53248 + (((256 * car2(args4)) + (16 * cadr1(args4))) + caddr1(args4)))
			else
				return errArgs_21_1(lineIdx5, opcode3)
			end
		elseif (opcode3 == "skp") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="address"})}))
			return (57502 + car2(args4))
		elseif (opcode3 == "sknp") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="address"})}))
			return (57505 + car2(args4))
		elseif (opcode3 == "dd") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 1, ({ tag="symbol", contents="byte"})}))
			return car2(args4)
		elseif (opcode3 == "dw") then
			assertArgs_21_1(lineInfo2, ({tag = "list", n = 2, ({ tag="symbol", contents="byte"}), ({ tag="symbol", contents="byte"})}))
			return ((256 * car2(args4)) + cadr1(args4))
		else
			return errLine_21_1(lineIdx5, _2e2e_2("unknown opcode \"", opcode3, "\""))
		end
	end
end)
generateBinary1 = (function(linesTokens2)
	local binary3 = ({tag = "list", n = 0})
	local r_2421 = _23_1(linesTokens2)
	local r_2401 = nil
	r_2401 = (function(r_2411)
		if (r_2411 <= r_2421) then
			local lineTokens3 = nth1(linesTokens2, r_2411)
			if lineTokens3 then
				local opcode4 = generateOpcode1(lineTokens3, r_2411)
				if opcode4 then
					if (cadar1(lineTokens3) ~= "dd") then
						pushCdr_21_1(binary3, floor1((opcode4 / 256)))
					end
					pushCdr_21_1(binary3, (opcode4 % 256))
				else
				end
			else
			end
			return r_2401((r_2411 + 1))
		else
		end
	end)
	r_2401(1)
	return binary3
end)
parse1 = (function(linesTokens3)
	local linesTokens4 = resolveLabels1(linesTokens3)
	local binary4 = generateBinary1(linesTokens4)
	exitFailed_21_1()
	return binary4
end)
loadInput_21_1 = (function(infile1)
	local lines2 = readLines_21_1(infile1)
	if _21_1(lines2) then
		err_21_1("failed to read input file.")
	end
	exitFailed_21_1()
	return lines2
end)
writeOutput_21_1 = (function(outfile1, data5)
	if _21_1(writeBytes_21_1(outfile1, data5)) then
		err_21_1("failed to write to output file.")
	end
	return exitFailed_21_1()
end)
compile1 = (function(infile2, outfile2)
	local lines3 = loadInput_21_1(infile2)
	local lexedLines1 = lex1(lines3)
	local output1 = parse1(lexedLines1)
	writeOutput_21_1(outfile2, output1)
	return print1(pretty1(concat1(map1((function(opcode5)
		return format1("%02X", opcode5)
	end), output1))))
end)
run1 = (function()
	if (_23_1(arg1) == 0) then
		return print1("uchip-8 <input file> [output file]")
	else
		return compile1(nth1(arg1, 1), (nth1(arg1, 2) or "out.ch8"))
	end
end)
return run1()
