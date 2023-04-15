#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")

local words={}
local lines={}

local fp=io.open("dict.tsv","r")
for line in fp:lines() do
	local cols=wstr.split(line,"\t")
	local word=cols[1]
	word=word:gsub("[^a-z]","")
	if word~="" and word==cols[1] then -- good word
		words[word]=true
	else -- bad word
		print("IGNORE",cols[1])
	end
	lines[#lines+1]=cols[3]
end
fp:close()


local freqs={}
local freqt=0
for word in pairs(words) do
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
	tab[#tab+1]={word,val}
end
table.sort(tab,function(a,b) return a[2]>b[2] end)

local fp=io.open("words.tsv","w")
for i,v in ipairs(tab) do
	local freq=("%f"):format(100*v[2]/freqt)
	fp:write(v[1].."\t"..freq.."\n")
end
fp:close()

