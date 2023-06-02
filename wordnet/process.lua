#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")

local words={}
local freqs={}
local defs={}

local files={
	["data.adj"]={		index=true,		class="j",	inflect={"er","ist"},	},
	["data.adv"]={		index=true,		class="a",	inflect={},				},
	["data.noun"]={		index=true,		class="n",	inflect={"s"},			},
	["data.verb"]={		index=true,		class="v",	inflect={"s","ing"},	},
}

for fn,it in pairs(files) do

	local fp=io.open("dict/"..fn,"r")
	for line in fp:lines() do
		local def=wstr.split(line,"|")[2]
		if def then
			def=def:gsub("%s+"," ") -- replace all whitespace with a single space
			def=def:match("^%s*(.-)%s*$") -- trim
			def=it.class..": "..def
			local cols=wstr.split(line," ")
			local class=it.class or ""
			for idx=5,#cols,2 do
				local word=cols[idx]
				if word:find("%d") and #word==3 then break end -- break on 000 digits
				local safeword=word:gsub("[^a-z]","")
				if safeword~="" and safeword==word then -- good word
					if defs[word] then
						defs[word]=defs[word].." "..def -- definition
					else
						defs[word]=def -- definition
					end
					if not freqs[word] then freqs[word]=0 end
					freqs[word]=freqs[word]+1
					if not words[word] then words[word]={} end
					if class~="" then
						words[word][class]=true
					end
--[[
				for _,f in pairs(it.inflect) do
					local wordf=word..f
					if not freqs[wordf] then freqs[wordf]=0 end
					freqs[wordf]=freqs[wordf]+1
					if not words[wordf] then words[wordf]={} end
					if class~="" then
						words[wordf][class..f:sub(-1)]=true
					end
				end
]]
				end
			end
			
			local sdef=string.lower(def):gsub("%p",""):gsub("[^a-z]"," ")
			for _,word in ipairs( wstr.split(sdef," ") ) do
				if word~="" then
					if not freqs[word] then freqs[word]=0 end
					freqs[word]=freqs[word]+1
--					if not words[word] then words[word]={} end
				end
			end

		end
	end
	fp:close()

	local c=0 for a,b in pairs(words) do c=c+1 end
	print(c)

end


local tab={}
for word in pairs(words) do
	local val=freqs[word] or 0
--	if val>0 then
		local weight=math.ceil(math.pow(val,1/2))
		if weight>9 then weight=9 end
		if weight<0 then weight=0 end
		local classes={}
		for class in pairs( words[word] or {} ) do
			classes[#classes+1]=class
		end
		table.sort(classes)
		classes=table.concat(classes," ")
		local def=defs[word] or ""
		tab[#tab+1]={word,weight,classes,def}
--	end
end
table.sort(tab,function(a,b)
	if a[2] == b[2] then
		return a[1]<b[1]
	end
	return a[2]>b[2]
end)


local fp=io.open("words.tsv","w")
--fp:write("eng".."\t".."weight".."\t".."class".."\n")
for i,v in ipairs(tab) do
	fp:write(v[1].."\t"..v[2].."\t"..v[3].."\n")
end
fp:close()

local fp=io.open("dicts.tsv","w")
for i,v in ipairs(tab) do
	fp:write(v[1].."\t"..v[4].."\n")
end
fp:close()
