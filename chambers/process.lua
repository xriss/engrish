#!/usr/bin/env gamecake 

local wstr=require("wetgenes.string")

local fp=io.open("dict.tsv","r")
for line in fp:lines() do
	local cols=wstr.split(line,"\t")
	local word=cols[1]
	word=word:gsub("[^a-z]","")
	if word~="" and word==cols[1] then -- good word
	else -- bad word
		print(cols[1])
	end
end
fp:close()
