#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")

local files={
{"dict-abcd.txt",8,4},
{"dict-efghijklm.txt",4,9},
{"dict-nopqr.txt",4,5},
{"dict-stuvwxyz.txt",4,8},
}

local lines={}

local ignoreme={
["* * * * *"]=true,
["[Illustration]"]=true,
}

local classes={
	["_v.i._"]		=	"verb intransitive",
	["_v.t._"]		=	"verb transitive",
	["_n.pl._"]		=	"noun plural",
	["_n.sing._"]	=	"noun singular",
	["_n._"]		=	"noun",
	["_adj._"]		=	"adjective",
	["_adv._"]		=	"adverb",
	["_pron._"]		=	"pronoun",
	["_conj._"]		=	"conjunction",
	["_interj._"]	=	"interjection",
	["_prep._"]		=	"preposition",
}


local letter=string.char(string.byte("A")-1)

for i,it in ipairs(files) do
	
	local filename=it[1]
	local skips=it[2]
	local letters=it[3]

	local savelines
	local joinlines

	local fp=io.open(filename,"r")
	for line in fp:lines() do
	
		local words=wstr.split_words(line)
		local clean=table.concat(words," ")
		if clean == "* * * * *" then
			if skips>0 then
				skips=skips-1
			else
				if letters>0 then
					letters=letters-1
					savelines=true
					letter=string.char(string.byte(letter)+1)
					print(letter)
				else
					savelines=false
				end
			end
		end
		
		if not ignoreme[clean] then
			if savelines then
				if clean=="" then -- empty line
					if joinlines and joinlines[1] then

						local line=table.concat(joinlines," ")
						local words=wstr.split_words(line) -- fix some letters that where illustrated
						if     words[1]=="the" and words[2]=="first"  then line="A, "..line
						elseif words[1]=="the" and words[2]=="second" then line="B, "..line
						elseif words[1]=="the" and words[2]=="third"  then line="C, "..line
						elseif words[1]=="the" and words[2]=="fourth" then line="D, "..line
						end
						if line:sub(1,1)==letter then -- must start with this caps letter
							lines[#lines+1]=line
						else -- append
							if lines[#lines] then
								lines[#lines]=lines[#lines].." "..line
							end
						end
					end
					joinlines={}
				else
					if joinlines then
						joinlines[#joinlines+1]=clean
					end
				end
			end
		end
				
	end
	fp:close()

end

local fp=io.open("dict.csv","w")
for i,line in ipairs( lines ) do
	local words=wstr.split_words(line)
	local class
	for i=1,10 do class=class or classes[ words[i] ] end
	class=class or ""
	local word=string.sub(line,string.find(line,"^[A-Z %-]*"))
	local escline=string.gsub(line,"\"","\"\"")
	fp:write(word..","..class..",".."\""..escline.."\"\n")
end
fp:close()

