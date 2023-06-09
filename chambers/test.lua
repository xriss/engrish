#!/usr/bin/env gamecake 

local classes={
	["noun plural"]           = "ns",
	["noun singular"]         = "n",
	["noun"]                  = "n",
	["pronoun"]               = "pn",

	["verb intransitive"]     = "vi",
	["verb transitive"]       = "vt",
	["adverb"]                = "a",

	["participial adjective"] = "pj",
	["adjective"]             = "j",
	["conjunction"]           = "c",
	["interjection"]          = "i",
	["preposition"]           = "p",
}


local dwords=function(word,maxdepth,words)
	words=words or {}
	maxdepth=maxdepth or #word
	local depth=1
	local new={[word]=true}
	if ( not words[word] ) or ( depth < words[word] ) then words[word]=depth end
	depth=depth+1
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
local maxweight
--local minweight
local fp=io.open("words.tsv","r")
--local fp=io.open("/home/kriss/Desktop/wlist.txt","r")
--local header
for line in fp:lines() do
	local cols={} ; for col in line:gmatch("%S+") do cols[#cols+1]=col end
--	if not header then
--		header=cols
--	else
		local word=string.lower(cols[1])
		local weight=cols[2] and tonumber(cols[2]) or 1
		if not maxweight or weight>maxweight then maxweight=weight end
--		if not minweight or weight<minweight then minweight=weight end
		words[ word ] = weight
--	end
end
fp:close()

for n,w in pairs(words) do -- weights between 0 and 1
	words[n]=1+(w/maxweight)	-- we add 2 so the number of transforms is more important
end

local addletters=4		-- lower this numnber, faster we can go
local subletters=4		-- no real speed incentive but reduces pointless hits
local args={...}
for i,w in ipairs(args) do
	w=string.lower(w)
	print(w)
	local m={}
	local ws=dwords(w,subletters)
	for v,n in pairs(words) do
		if ( #v+1-addletters <= #w ) and ( #w+1-subletters <= #v ) then -- must be this long for possible match
			for t,f in pairs( dwords(v,addletters) ) do
				if ws[t] then -- hit
					local weight=n/(f+ws[t])
					if ( not m[v] ) or ( m[v]<weight ) then
						m[v]=weight
					end
				end
			end
		end
	end
	local t={}
	for a,b in pairs(m) do
		t[#t+1]={a,b}
	end
	table.sort(t,function(a,b) if a[2]==b[2] then return a[1]>b[1] end return a[2]>b[2] end)
	local oo={}
	for i=1,10 do
		if t[i] then
			oo[#oo+1]=t[i][1] -- ..":"..t[i][2]
--			print( "" , t[i][1] ) -- , t[i][2] )
		end
	end
	print( "" , unpack(oo) )
end
