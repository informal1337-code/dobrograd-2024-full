local e,n='https://i.imgur.com/','https://imgur.octo.gg/i/'local o
function octolib.imgurLoaded()return o~=nil
end
function octolib.forceImgurProxy(i)o=i and n or e
end
function octolib.imgurUsesProxy()return o==n
end
http.Fetch('https://i.imgur.com/7pODAQu.jpg',function(t,t,t,i)o=i==200 and e or n
hook.Run('octolib.imgur.loaded')end,function()o=n
end)function octolib.imgurImage(n)if not octolib.imgurLoaded()then
ErrorNoHalt('Tried to load imgur image before server determined')end
return(o or e)..n
end
octolib.loadingMat=Material('octoteam/icons/clock.png')local t={}local n={}local function l(o)return'imgscreen/'..string.StripExtension(o):gsub('https?://',''):gsub('[\\/:*?"<>|%.]','_')..'.'..(string.GetExtensionFromFilename(o)or'png')end
local function r(o)return'../data/'..l(o)end
function octolib.getURLMaterial(o,i,a,c)if n[o]then
table.insert(n[o],i)return octolib.loadingMat
end
local e=t[o]if not e then
t[o]=octolib.loadingMat
e=octolib.loadingMat
n[o]={i}http.Fetch(o,function(e)file.Write(l(o),e)local e=r(o)RunConsoleCommand('mat_reloadmaterial',string.StripExtension(e))t[o]=Material(e,c)for i,e in ipairs(n[o]or{})do
e(t[o])end
n[o]=nil
end)else
if a then
RunConsoleCommand('mat_reloadmaterial',string.StripExtension(r(o)))end
if isfunction(i)then i(e)end
end
return e
end
function octolib.getImgurMaterial(o,n,i,e)return octolib.getURLMaterial(octolib.imgurImage(o),n,i,e)end
local function o()file.CreateDir('imgscreen')local o=file.Find('imgscreen/*','DATA')for n,o in ipairs(o)do
file.Delete('imgscreen/'..o)end
end
hook.Add('Shutdown','imgscreen.clearCache',o)hook.Add('PlayerFinishedLoading','imgscreen.clearCache',o)hook.Add('Think','octolib-imgur.init',function()hook.Remove('Think','octolib-imgur.init')vgui.GetControlTable('DImage').SetURL=function(o,n)octolib.getURLMaterial(n,function(n)if not IsValid(o)then return end
o:SetMaterial(n)end)end
end)