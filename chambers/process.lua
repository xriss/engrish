#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")


local classes={
	["noun singular"]         = "n",
	["noun"]                  = "n",

	["verb intransitive"]     = "v",
	["verb transitive"]       = "v",

	["adjective"]             = "j",

	["adverb"]                = "a",

	["noun plural"]           = "m",	-- m is two ns
	
	["pronoun"]               = "i",	-- i is literally a pronoun
	["interjection"]          = "o",	-- o is literally an interjection

	["participial adjective"] = "g",	-- i do not even
	["conjunction"]           = "c",
	["preposition"]           = "p",
}



local words={}
local lines={}
local alts={}

local findalts=function(text,orig)

--	print(text)
	text=" "..text.." " -- make sure we start and end with whitespace
	for word in text:gmatch("%s[A-Z%p]+%s") do
		word=word:gsub("[^A-Z]",""):lower()
		if #word>2 then
			alts[word]=orig
		end
	end

end

local fp=io.open("dict.tsv","r")
for line in fp:lines() do
	local cols=wstr.split(line,"\t")
	local word=cols[1]
	local class=classes[ cols[2] ] or ""
	word=word:gsub("[^a-z]","")
	if word~="" and word==cols[1] then -- good word
		if not words[word] then words[word]={} end
		if class~="" then
			words[word][class]=true
		end
		findalts(cols[3] or "",word)
	else -- bad word
--		print("IGNORE",cols[1])
		findalts(cols[3] or "","")
	end
	lines[#lines+1]=cols[3]
end
fp:close()


local freqs={}
local freqt=0
for word in pairs(words) do
	freqs[word]=0
end
for word in pairs(alts) do
	freqs[word]=0
end

for _,line in pairs(lines) do
	for word in line:lower():gmatch("%l+") do
		if freqs[word] then
			freqs[word]=freqs[word]+1
			freqt=freqt+1
		end
	end
end

local twords=function(word)
	local words={}
	for i=1,#word do
		local a=word:sub(0,i-1)
		local b=word:sub(i+1)
		local c=a..b
		words[c]=true
	end
	return words
end

--[[
local wordish={}

for word in pairs(words) do
	wordish[word]=1
end

local idx=1
local new_words=words
while true do
	local news=0
	local new_new_words={}
	for word in pairs(new_words) do
		if #word>1 then
			local depth=wordish[word]+1
			for w in pairs(twords(word)) do
				if not wordish[w] then 
					news=news+1
					new_new_words[w]=true
					wordish[w]=depth
				end
			end
		end
	end
	print(idx,news)
	if news==0 then break end
	new_words=new_new_words
	idx=idx+1
	if idx>1 then break end
end
]]

local tab={}
for word,val in pairs(freqs) do
	if val>0 then
		local weight=math.ceil(math.pow(val,1/2))
		if weight>9 then weight=9 end
		local classes={}
		for class in pairs( words[word] or {} ) do
			classes[#classes+1]=class
		end
		table.sort(classes)
		classes=table.concat(classes,"")
		tab[#tab+1]={word,weight,classes}
	end
end
table.sort(tab,function(a,b)
	if a[2] == b[2] then
		return a[1]<b[1]
	end
	return a[2]>b[2]
end)

local fp=io.open("words.tsv","w")
--fp:write("eng".."\t".."weight".."\t".."class".."\n")
for i,v in ipairs(tab) do -- v[2] can be reconstructed
	fp:write(v[1])
	if v[3] ~= "" then
		fp:write("\t"..v[3])
	end
	fp:write("\n")
end
fp:close()

--[[
table.sort(tab,function(a,b)
	return a[1]<b[1]
end)
local find_diff=function(last,word)
	for i=0,#last do
		local a=last:sub(1,#last-i)
		local b=word:sub(1,#last-i)
print(i,a,b)
		if a==b then -- matched
			return i , word:sub(#last+1-i)
		end
	end
	return #last,word -- total replace
end
local fp=io.open("words.diff.tsv","w")
--fp:write("eng".."\t".."weight".."\t".."class".."\n")
local last=""
for i,v in ipairs(tab) do
	local word=v[1]
	local a,b=find_diff(last,word)
	last=word
	fp:write(a.."\t"..b.."\n")
end
fp:close()
]]
