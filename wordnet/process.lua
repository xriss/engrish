#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")

local words={}

local files={
	["index.adj"]={		index=true,		class="a",	},
	["index.adv"]={		index=true,		class="av",	},
	["index.noun"]={	index=true,		class="n",	},
	["index.sense"]={	index=true,		class="",	},
	["index.verb"]={	index=true,		class="v",	},
	["adj.exc"]={		exc=true,		class="a",	},
	["adv.exc"]={		exc=true,		class="av",	},
	["cousin.exc"]={	exc=true,		class="",	},
	["noun.exc"]={		exc=true,		class="n",	},
	["verb.exc"]={		exc=true,		class="v",	},
}

for fn,it in pairs(files) do

	local fp=io.open("dict/"..fn,"r")
	for line in fp:lines() do
		local cols=wstr.split(line," ")
		local word=cols[1]
		local class=it.class or ""
		word=word:gsub("[^a-z]","")
		if word~="" and word==cols[1] then -- good word
			if not words[word] then words[word]={} end
			if class~="" then
				words[word][class]=true
			end
		end
	end
	fp:close()

	local c=0 for a,b in pairs(words) do c=c+1 end
	print(c)

end


local tab={}
local tab={}
for word,_ in pairs(words) do
	local weight=0--math.ceil(math.pow(val,1/2))
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
	return a[1]<b[1]
end)


local fp=io.open("words.tsv","w")
--fp:write("eng".."\t".."weight".."\t".."class".."\n")
for i,v in ipairs(tab) do
	fp:write(v[1].."\t"..v[2].."\t"..v[3].."\n")
end
fp:close()
