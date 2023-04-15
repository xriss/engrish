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

local abbrevs={
  ["_aor._"]=                   "aorist.",
  ["_abbrev._"]=                "abbreviation.",
  ["_abl._"]=                   "ablative.",
  ["_acc._"]=                   "according.",
  ["_accus._"]=                 "accusative.",
  ["_adj._"]=                   "adjective.",
  ["_adv._"]=                   "adverb.",
  ["_agri._"]=                  "agriculture.",
  ["_alg._"]=                   "algebra.",
  ["_anat._"]=                  "anatomy.",
  ["_app._"]=                   "apparently.",
  ["_arch._"]=                  "archaic.",
  ["_archit._"]=                "architecture.",
  ["_arith._"]=                 "arithmetic.",
  ["_astrol._"]=                "astrology.",
  ["_astron._"]=                "astronomy.",
  ["_attrib._"]=                "attributive.",
  ["_augm._"]=                  "augmentative.",
  ["_B._"]=                     "Bible.",
  ["_biol._"]=                  "biology.",
  ["_book-k._"]=                "book-keeping.",
  ["_bot._"]=                   "botany.",
  ["_c._"]=                     "about.",
  ["_circa_"]=                  "about.",
  ["_c._"]=                     "century.",
  ["_cent._"]=                  "century.",
  ["_carp._"]=                  "carpentry.",
  ["_cf._"]=                    "compare.",
  ["_chem._"]=                  "chemistry.",
  ["_cog._"]=                   "cognate.",
  ["_coll._"]=                  "colloquially.",
  ["_colloq._"]=                "colloquially.",
  ["_comp._"]=                  "comparative.",
  ["_conch._"]=                 "conchology.",
  ["_conj._"]=                  "conjunction.",
  ["_conn._"]=                  "connected.",
  ["_contr._"]=                 "contracted.",
  ["_cook._"]=                  "cookery.",
  ["_corr._"]=                  "corruption.",
  ["_crystal._"]=               "crystallography.",
  ["_dat._"]=                   "dative.",
  ["_demons._"]=                "demonstrative.",
  ["_der._"]=                   "derivation.",
  ["_dial._"]=                  "dialect.",
  ["_Dict._"]=                  "Dictionary.",
  ["_dim._"]=                   "diminutive.",
  ["_dub._"]=                   "doubtful.",
  ["_eccles._"]=                "ecclesiastical history.",
  ["_e.g._"]=                   "for example.",
  ["_elect._"]=                 "electricity.",
  ["_entom._"]=                 "entomology.",
  ["_esp._"]=                   "especially.",
  ["_ety._"]=                   "etymology.",
  ["_fem._"]=                   "feminine.",
  ["_fig._"]=                   "figuratively.",
  ["_fol._"]=                   "followed.",
  ["_fort._"]=                  "fortification.",
  ["_freq._"]=                  "frequentative.",
  ["_fut._"]=                   "future.",
  ["_gen._"]=                   "genitive.",
  ["_gener._"]=                 "generally.",
  ["_geog._"]=                  "geography.",
  ["_geol._"]=                  "geology.",
  ["_geom._"]=                  "geometry.",
  ["_ger._"]=                   "gerundive.",
  ["_gram._"]=                  "grammar.",
  ["_gun._"]=                   "gunnery.",
  ["_her._"]=                   "heraldry.",
  ["_hist._"]=                  "history.",
  ["_hort._"]=                  "horticulture.",
  ["_hum._"]=                   "humorous.",
  ["_i.e._"]=                   "that is.",
  ["_imit._"]=                  "imitative.",
  ["_imper._"]=                 "imperative.",
  ["_impers._"]=                "impersonal.",
  ["_indic._"]=                 "indicative.",
  ["_infin._"]=                 "infinitive.",
  ["_inten._"]=                 "intensive.",
  ["_interj._"]=                "interjection.",
  ["_interrog._"]=              "interrogative.",
  ["_jew._"]=                   "jewellery.",
  ["_lit._"]=                   "literally.",
  ["_mach._"]=                  "machinery.",
  ["_masc._"]=                  "masculine.",
  ["_math._"]=                  "mathematics.",
  ["_mech._"]=                  "mechanics.",
  ["_med._"]=                   "medicine.",
  ["_metaph._"]=                "metaphysics.",
  ["_mil._"]=                   "military.",
  ["_Milt._"]=                  "Milton.",
  ["_min._"]=                   "mineralogy.",
  ["_mod._"]=                   "modern.",
  ["_Mt._"]=                    "Mount.",
  ["_mus._"]=                   "music.",
  ["_myth._"]=                  "mythology.",
  ["_n._"]=                     "noun.",
  ["_ns._"]=                    "nouns.",
  ["_nat. hist._"]=             "natural history.",
  ["_naut._"]=                  "nautical.",
  ["_neg._"]=                   "negative.",
  ["_neut._"]=                  "neuter.",
  ["_n.pl._"]=                  "noun plural.",
  ["_n.sing._"]=                "noun singular.",
  ["_N.T._"]=                   "New Testament.",
  ["_obs._"]=                   "obsolete.",
  ["_opp._"]=                   "opposed.",
  ["_opt._"]=                   "optics.",
  ["_orig._"]=                  "originally.",
  ["_ornith._"]=                "ornithology.",
  ["_O.S._"]=                   "old style.",
  ["_O.T._"]=                   "Old Testament.",
  ["_p._"]=                     "participle.",
  ["_part._"]=                  "participle.",
  ["_p.adj._"]=                 "participial adjective.",
  ["_paint._"]=                 "painting.",
  ["_paleog._"]=                "paleography.",
  ["_paleon._"]=                "paleontology.",
  ["_palm._"]=                  "palmistry.",
  ["_pa.p._"]=                  "past participle.",
  ["_pass._"]=                  "passive.",
  ["_pa.t._"]=                  "past tense.",
  ["_path._"]=                  "pathology.",
  ["_perf._"]=                  "perfect.",
  ["_perh._"]=                  "perhaps.",
  ["_pers._"]=                  "person.",
  ["_pfx._"]=                   "prefix.",
  ["_phil._"]=                  "philosophy.",
  ["_philos._"]=                "philosophy.",
  ["_philol._"]=                "philology.",
  ["_phon._"]=                  "phonetics.",
  ["_phot._"]=                  "photography.",
  ["_phrenol._"]=               "phrenology.",
  ["_phys._"]=                  "physics.",
  ["_physiol._"]=               "physiology.",
  ["_pl._"]=                    "plural.",
  ["_poet._"]=                  "poetical.",
  ["_pol. econ._"]=             "political economy.",
  ["_poss._"]=                  "possessive.",
  ["_Pr.Bk._"]=                 "Book of Common Prayer.",
  ["_pr.p._"]=                  "present participle.",
  ["_prep._"]=                  "preposition.",
  ["_pres._"]=                  "present.",
  ["_print._"]=                 "printing.",
  ["_priv._"]=                  "privative.",
  ["_prob._"]=                  "probably.",
  ["_Prof._"]=                  "Professor.",
  ["_pron._"]=                  "pronoun;",
  ["_prop._"]=                  "properly.",
  ["_pros._"]=                  "prosody.",
  ["_prov._"]=                  "provincial.",
  ["_q.v._"]=                   "which see.",
  ["_R.C._"]=                   "Roman Catholic.",
  ["_recip._"]=                 "reciprocal.",
  ["_redup._"]=                 "reduplication.",
  ["_refl._"]=                  "reflexive.",
  ["_rel._"]=                   "related.",
  ["_rhet._"]=                  "rhetoric.",
  ["_sculp._"]=                 "sculpture.",
  ["_Shak._"]=                  "Shakespeare.",
  ["_sig._"]=                   "signifying.",
  ["_sing._"]=                  "singular.",
  ["_spec._"]=                  "specifically.",
  ["_Spens._"]=                 "Spenser.",
  ["_subj._"]=                  "subjunctive.",
  ["_suff._"]=                  "suffix.",
  ["_superl._"]=                "superlative.",
  ["_surg._"]=                  "surgery.",
  ["_term._"]=                  "termination.",
  ["_teleg._"]=                 "telegraphy.",
  ["_Tenn._"]=                  "Tennyson.",
  ["_Test._"]=                  "Testament.",
  ["_theat._"]=                 "theatre.",
  ["_theol._"]=                 "theology.",
  ["_trig._"]=                  "trigonometry.",
  ["_ult._"]=                   "ultimately.",
  ["_v.i._"]=                   "verb intransitive.",
  ["_voc._"]=                   "vocative.",
  ["_v.t._"]=                   "verb transitive.",
  ["_vul._"]=                   "vulgar.",
  ["_zool._"]=                  "zoology.",
  [" Amer."]=      " American.",
  [" Ar."]=        " Arabic.",
  [" A.S."]=       " Anglo-Saxon.",
  [" Austr."]=     " Australian.",
  [" Bav."]=       " Bavarian.",
  [" Beng."]=      " Bengali.",
  [" Bohem."]=     " Bohemian.",
  [" Braz."]=      " Brazilian.",
  [" Bret."]=      " Breton.",
  [" Carib."]=     " Caribbean.",
  [" Celt."]=      " Celtic.",
  [" Chal."]=      " Chaldean.",
  [" Chin."]=      " Chinese.",
  [" Corn."]=      " Cornish.",
  [" Dan."]=       " Danish.",
  [" Dut."]=       " Dutch.",
  [" Egypt."]=     " Egyptian.",
  [" Eng."]=       " English.",
  [" Finn."]=      " Finnish.",
  [" Flem."]=      " Flemish.",
  [" Fr."]=        " French.",
  [" Fris."]=      " Frisian.",
  [" Gael."]=      " Gaelic.",
  [" Ger."]=       " German.",
  [" Goth."]=      " Gothic.",
  [" Gr."]=        " Greek.",
  [" Heb."]=       " Hebrew.",
  [" Hind."]=      " Hindustani.",
  [" Hung."]=      " Hungarian.",
  [" Ice."]=       " Icelandic.",
  [" Ind."]=       " Indian.",
  [" Ion."]=       " Ionic.",
  [" Ir."]=        " Irish.",
  [" It."]=        " Italian.",
  [" Jap."]=       " Japanese.",
  [" Jav."]=       " Javanese.",
  [" L."]=         " Latin.",
  [" Lith."]=      " Lithuanian.",
  [" L. =L."]=     " Low or Late Latin.",
  [" M. =E."]=     " Middle English.",
  [" Mex."]=       " Mexican.",
  [" Norm."]=      " Norman.",
  [" Norw."]=      " Norwegian.",
  [" O. =Fr."]=    " Old French.",
  [" Pers."]=      " Persian.",
  [" Peruv."]=     " Peruvian.",
  [" Pol."]=       " Polish.",
  [" Port."]=      " Portuguese.",
  [" Prov."]=      " Provençal.",
  [" Rom."]=       " Romance.",
  [" Russ."]=      " Russian",
  [" Sans."]=      " Sanskrit.",
  [" Scand."]=     " Scandinavian.",
  [" Scot."]=      " Scottish.",
  [" Singh."]=     " Singhalese.",
  [" Slav."]=      " Slavonic.",
  [" Sp."]=        " Spanish.",
  [" Sw."]=        " Swedish.",
  [" Teut."]=      " Teutonic.",
  [" Turk."]=      " Turkish.",
  [" U.S."]=       " United States.",
  [" W."]=         " Welsh.",
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

local fpt=io.open("dict.tsv","w")
for i,line in ipairs( lines ) do
	local words=wstr.split_words(line)
	local class
	for i=1,10 do class=class or classes[ words[i] ] end
	class=class or ""
	local word=string.lower(string.sub(line,string.find(line,"^[^%,%=%.]*")))
	if #word>20 then word="" end
	if string.sub(word,2,2)==" " then word=string.sub(word,1,1) end -- catch single letters
	local eline=line
	for n,v in pairs( abbrevs ) do
		if string.find( eline , n ) then
			eline=string.gsub( eline , n , v )
		end
	end
	fpt:write(word.."\t"..class.."\t"..eline.."\n")
end
fpt:close()

