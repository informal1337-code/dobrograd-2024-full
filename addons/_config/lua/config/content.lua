--
-- dobrograd
--

if game.GetMap():find('eastcoast') then
    resource.AddWorkshop '1407179012' -- rp_eastcoast_v4c
end

if game.GetMap():find('truenorth') then
	resource.AddWorkshop '1601428630' -- rp_truenorth_v1a
	resource.AddWorkshop '1601425051' -- rp_truenorth_v1a content 1
	resource.AddWorkshop '1601404123' -- rp_truenorth_v1a content 2
end
if game.GetMap():find('truenorth') then
	resource.AddWorkshop '1601428630' -- rp_truenorth_v1a
	resource.AddWorkshop '1601425051' -- rp_truenorth_v1a content 1
	resource.AddWorkshop '1601404123' -- rp_truenorth_v1a content 2
end

resource.AddWorkshop '2756091933' -- octocars https://steamcommunity.com/sharedfiles/filedetails/?id=2756091933
resource.AddWorkshop '3340482717' -- transport content --https://steamcommunity.com/sharedfiles/filedetails/?id=3340482717
resource.AddWorkshop '3343739718' -- characters content -- https://steamcommunity.com/sharedfiles/filedetails/?id=3343739718
resource.AddWorkshop '2532822854' -- props content 1
resource.AddWorkshop '2532517900' -- props content 2
resource.AddWorkshop '2534082994' -- props content 3 -- НЕ ПИЗДИ ШЛЮХА
resource.AddWorkshop '3369485796' --chards
resource.AddWorkshop '2599597450' --https://steamcommunity.com/sharedfiles/filedetails/?id=2599597450
resource.AddFile 'resource/fonts/Roboto-Black.ttf'
resource.AddFile 'resource/fonts/Roboto-BlackItalic.ttf'
resource.AddFile 'resource/fonts/Roboto-Bold.ttf'
resource.AddFile 'resource/fonts/Roboto-BoldCondensed.ttf'
resource.AddFile 'resource/fonts/Roboto-BoldCondensedItalic.ttf'
resource.AddFile 'resource/fonts/Roboto-BoldItalic.ttf'
resource.AddFile 'resource/fonts/Roboto-Condensed.ttf'
resource.AddFile 'resource/fonts/Roboto-CondensedItalic.ttf'
resource.AddFile 'resource/fonts/Roboto-Italic.ttf'
resource.AddFile 'resource/fonts/Roboto-Light.ttf'
resource.AddFile 'resource/fonts/Roboto-LightItalic.ttf'
resource.AddFile 'resource/fonts/Roboto-Medium.ttf'
resource.AddFile 'resource/fonts/Roboto-MediumItalic.ttf'
resource.AddFile 'resource/fonts/Roboto-Regular.ttf'
resource.AddFile 'resource/fonts/Roboto-Thin.ttf'
resource.AddFile 'resource/fonts/Roboto-ThinItalic.ttf'

--
-- octolib
--
resource.AddWorkshop '1394544550' -- icons
resource.AddFile 'resource/fonts/arial.ttf'
resource.AddFile 'resource/fonts/arialbd.ttf'
resource.AddFile 'resource/fonts/arialbi.ttf'
resource.AddFile 'resource/fonts/arialblk.ttf'
resource.AddFile 'resource/fonts/ariali.ttf'
resource.AddFile 'resource/fonts/blogger.ttf'
resource.AddFile 'resource/fonts/bloggerb.ttf'
resource.AddFile 'resource/fonts/bloggerbi.ttf'
resource.AddFile 'resource/fonts/bloggeri.ttf'
resource.AddFile 'resource/fonts/bloggerl.ttf'
resource.AddFile 'resource/fonts/bloggerli.ttf'
resource.AddFile 'resource/fonts/bloggerm.ttf'
resource.AddFile 'resource/fonts/bloggermi.ttf'
resource.AddFile 'resource/fonts/fontawesome-webfont.ttf'

--
-- serverguard
--
resource.AddWorkshop '685130934'

--
-- simfphys
--
resource.AddWorkshop '771487490'

--
-- stormfox
--
resource.AddWorkshop '2447979470'

--
-- atm
--
resource.AddFile 'materials/newcity/atm.png'

resource.AddFile 'models/props_unique/atm01.mdl'
resource.AddSingleFile 'models/props_unique/atm01.dx80.vtx'
resource.AddSingleFile 'models/props_unique/atm01.dx90.vtx'
resource.AddSingleFile 'models/props_unique/atm01.mdl'
resource.AddSingleFile 'models/props_unique/atm01.phy'
resource.AddSingleFile 'models/props_unique/atm01.vtx'
resource.AddSingleFile 'models/props_unique/atm01.vvt'

resource.AddFile 'materials/models/props_unique/atm.vmt'
resource.AddSingleFile 'materials/models/props_unique/atm.vmt'
resource.AddSingleFile 'materials/models/props_unique/atm.vtf'
resource.AddSingleFile 'materials/models/props_unique/atm_ref.vtf'

--
-- fadmin (darkrp)
--
local function AddDir(dir)
	local files, folders = file.Find(dir .. "/*", "GAME")
	for _, fdir in pairs(folders) do
		if fdir ~= ".svn" then AddDir(dir .. "/" .. fdir) end
	end
	for k, v in pairs(files) do resource.AddFile(dir .. "/" .. v) end
end
AddDir("materials/fadmin")
-- t.me/urbanichka