#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")

local words={}
local weights={}

local files={
	["../chambers/words.tsv"]={		},
	["../wordnet/words.tsv"]={		},
}

for fn,it in pairs(files) do

	local fp=io.open(fn,"r")
	local weight=0
	local fweights={}
	for line in fp:lines() do
		weight=weight+1
		local cols=wstr.split(line,"\t")
		local word=cols[1]
--		local weight=tonumber( cols[2] ) or 0
		local classs=cols[2]

		if not fweights[word] then fweights[word]=weight end

		if not words[word] then words[word]={} end
		if classs then
			for _,class in ipairs( wstr.split(classs," ") ) do
				if class~="" then
					words[word][class]=true
				end
			end
		end
	end
	for n,v in pairs(fweights) do -- guess the weight
		if not weights[n] then
			weights[n]=math.floor(10-(9*(v/weight)))
		end
	end
	fp:close()

	local c=0 for a,b in pairs(words) do c=c+1 end
	print(c)

end


local tab={}
local tab={}
for word,_ in pairs(words) do
	local weight=weights[word] or 0--math.ceil(math.pow(val,1/2))
	if weight>9 then weight=9 end
	local classes={}
	for class in pairs( words[word] or {} ) do
		classes[#classes+1]=class
	end
	table.sort(classes)
	classes=table.concat(classes," ")
	tab[#tab+1]={word,weight,classes}
end
table.sort(tab,function(a,b)
	if a[2] == b[2] then
		return a[1]<b[1]
	end
	return a[2]>b[2]
end)


local fp=io.open("words.tsv","w")
--fp:write("eng".."\t".."weight".."\t".."class".."\n")
for i,v in ipairs(tab) do -- v[2] can be recalculated
	fp:write(v[1].."\t"..v[3].."\n")
end
fp:close()
