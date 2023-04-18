#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")


local classes={
	["noun plural"]           = "np",
	["noun singular"]         = "ns",
	["noun"]                  = "n",
	["pronoun"]               = "pn",

	["verb intransitive"]     = "vi",
	["verb transitive"]       = "vt",
	["adverb"]                = "av",

	["participial adjective"] = "pa",
	["adjective"]             = "a",
	["conjunction"]           = "c",
	["interjection"]          = "i",
	["preposition"]           = "p",
}


local dwords=function(word,maxdepth,words)
	words=words or {}
	if #word<2 then return words end -- nothing to split
	maxdepth=maxdepth or #word
	local depth=1
	local new={[word]=true}
	if ( not words[word] ) or ( 1 > words[word] ) then words[word]=1 end
	while depth<maxdepth do
		local weight=depth -- (maxdepth-depth)/maxdepth
		local newnew={}
		for word in pairs(new) do
			for i=1,#word do
				local a=word:sub(0,i-1)
				local b=word:sub(i+1)
				local c=a..b
				if ( not words[c] ) or ( weight < words[c] ) then
					words[c]=weight
					newnew[c]=true
				end
			end
		end
		new=newnew
		depth=depth+1
	end
	return words
end



local words={}

local fp=io.open("words.tsv","r")
local header
for line in fp:lines() do
	local cols=wstr.split(line,"\t")
	if not header then
		header=cols
	else
		words[ cols[1] ] = cols[2]
	end
end
fp:close()

local args={...}
for i,w in ipairs(args) do
	print(w)
	local m={}
	local ws=dwords(w)
	for v,n in pairs(words) do
		for t,f in pairs( dwords(v,4) ) do
			if ws[t] then -- hit
				local weight=(n+1000000)/(f+ws[t])
				if ( not m[v] ) or ( m[v]<weight ) then
					m[v]=weight
				end
			end
		end
	end
	local t={}
	for a,b in pairs(m) do
		t[#t+1]={a,b}
	end
	table.sort(t,function(a,b) return a[2]>b[2] end)
	local oo={}
	for i=1,10 do
		if t[i] then
			oo[#oo+1]=t[i][1]
--			print( "" , t[i][1] ) -- , t[i][2] )
		end
	end
	print( "" , unpack(oo) )
end
