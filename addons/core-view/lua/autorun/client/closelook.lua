--[[
Server Name: [#] Доброград – Хэллоуин 🎃
Server IP:   46.174.50.203:27015
File Path:   <:@?#$*/>addons/core-view/lua/autorun/client/closelook.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

dbgView=dbgView or{}dbgView.look=dbgView.look or{enabled=false,state=0,cache={},}surface.CreateFont('dbg-hud.normal',{font='Calibri',extended=true,size=27,weight=350,shadow=true,})surface.CreateFont('dbg-hud.normal-sh',{font='Calibri',extended=true,size=27,blursize=5,weight=350,})surface.CreateFont('dbg-hud.small',{font='Roboto',extended=true,size=17,weight=350,shadow=true,})surface.CreateFont('dbg-hud.small-sh',{font='Roboto',extended=true,size=17,blursize=4,weight=350,})surface.CreateFont('octoinv.3d',{font='Arial Bold',extended=true,size=18,weight=300,antialias=true,})surface.CreateFont('octoinv.3d-sh',{font='Arial Bold',extended=true,size=18,weight=300,blursize=5,antialias=true,})local o=dbgView.look
local l
local e=GetConVar('cl_dbg_key_look'):GetInt()cvars.AddChangeCallback('cl_dbg_key_look',function(n,n,o)e=tonumber(o)end)hook.Add('PlayerBindPress','dbg-look',function(o,e)if e=='+zoom'then return true end end)hook.Add('PlayerButtonDown','dbg-look',function(t,n)if n==e and IsFirstTimePredicted()then o.enable(true)end end)hook.Add('PlayerButtonUp','dbg-look',function(t,n)if n==e and IsFirstTimePredicted()then o.enable(false)end end)function o.enable(e)if e then
o.enabled=true
netstream.Start('dbg-look.enable',true)timer.Create('dbg-look',.4,0,o.update)o.update()else
o.enabled=false
netstream.Start('dbg-look.enable',false)timer.Remove('dbg-look')for o,e in pairs(o.cache)do
e.killing=true
end
end
end
local function i(o,e)local n,t=o:WorldSpaceCenter(),o:GetAngles()if e.bone then
local e=o:LookupBone(e.bone)if e then n,t=o:GetBonePosition(e)end
end
if e.attachment then
local e=o:GetAttachment(o:LookupAttachment(e.attachment))if e then
n,t=e.Pos,e.Ang
end
end
if e.posRel then n=LocalToWorld(e.posRel,angle_zero,n,t)end
if e.posAbs then n:Add(e.posAbs)end
return n,t
end
local e={'name','attacker','bullet','cause','weapon','time'}local function k(n)local o={}for t,e in ipairs(e)do
o[e]=n:GetNetVar('Corpse.'..e)end
return o
end
local e=math.cos(math.rad(40))function o.update()local t=LocalPlayer()local d={}local r=t:EyePos()for n,e in pairs(ents.FindInCone(r,t:GetAimVector(),t:GetNetVar('closelookZoom')and 1200 or 300,e))do
if e:GetNoDraw()then continue end
local n=e.GetNetVar and e:GetNetVar('dbgLook')if not n then
n=hook.Run('dbgCloseLook.getDescription',e,t)end
if not n then continue end
if l and(n.jobs or n.orgJobs)then
local e=false
if n.jobs and n.jobs[l.command]then
e=true
elseif n.orgJobs then
for n,o in pairs(n.orgJobs)do
if not o[t:GetActiveRank(n)]then continue end
e=true
break
end
end
if not e then continue end
end
local l=i(e,n)local a={t}if t:InVehicle()then
local e=t:GetVehicle()a[#a+1]=e
a[#a+1]=e:GetParent()end
if e:IsPlayer()and e:InVehicle()then
local e=e:GetVehicle()a[#a+1]=e
a[#a+1]=e:GetParent()end
if hook.Run('dbgCloseLook.canSee',e,t)==false then continue end
local t=util.TraceLine({start=r,endpos=l,filter=a})if t.Hit and t.Entity~=e then continue end
d[e]=true
if o.cache[e]then continue end
o.cache[e]={data=n,al=0,rot=0,descAl=0,h=0,}end
for o,e in pairs(o.cache)do
e.killing=not d[o]end
end
hook.Add('EntityRemoved','dbg-look',function(e)o.cache[e]=nil
end)local G=Material('octoteam/icons/percent_inactive_white.png')local e,n=0,Material('overlays/vignette01')local b,p=Color(0,0,0),Color(255,255,255)local g=CFG.skinColors
local d,f,r,E,_,t,N,a,A
hook.Add('Think','dbg-look',function()if not o.enabled and e==0 then return end
e=math.Approach(e,o.enabled and 1 or 0,FrameTime()*1.5)o.state=octolib.tween.easing.outQuad(e,0,1,1)d=LocalPlayer()f,l=d:GetAimVector(),d:getJobTable()r,E,_,t,N,seesName,seesTime,police,a,A=d:Alive(),d:IsGhost(),l.seesGhosts,l.medic,l.seesCaliber,l.seesName,l.seesTime,l.police,d:Team()==TEAM_ADMIN,d:Team()==TEAM_PRIEST
f.z=0
f:Normalize()end)hook.Add('HUDPaint','dbg-look',function()if e==0 then return end
if hook.Run('HUDShouldDraw','dbg-look')==false then return end
n:SetFloat('$alpha',o.state)render.SetMaterial(n)render.DrawScreenQuad()local s,t,d=FrameTime(),ScrW()/2,ScrH()/2
for c,e in pairs(o.cache)do
if not IsValid(c)or(e.al<=0 and e.killing)then
o.cache[c]=nil
else
e.al=math.Approach(e.al,e.killing and 0 or 1,s*3)local h=octolib.tween.easing.outQuad(e.al,0,1,1)surface.SetAlphaMultiplier(h)local n=i(c,e.data)n=n:ToScreen()local l,r=math.floor(n.x),math.floor(n.y)local n=Vector(l,r,0)if e.data.lookOff then
local e=e.data.lookOff
n.x=n.x-e.x
n.y=n.y-e.y
end
local d=h*math.Clamp(220-Vector(l,r,0):DistToSqr(Vector(t,d,0))/200,0,200)/200
local T,u=e.data.name,e.data.desc
local t,n=e.descAl,e.descOn
local f=false
local i=e.data.eyeAngles
local m=EyeAngles().p
if d==1 or(i and i[2]>=m and i[1]<=m)then
f=true
end
local m=f and not n
local i=t
if u and u~=''then
if n then
local o=e.data.descRender and o.render[u]t=math.Approach(t,1,s*1.5)i=h*octolib.tween.easing.outQuad(t,0,1,1)if isfunction(o)then
o(c,e,l,r,h,i)else
e.mu=e.mu or markup.Parse(('<font=dbg-hud.small>%s</font>'):format(u),250)e.h=e.mu:GetHeight()/2
local o=r+5*i
e.mu:Draw(l,o,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,255*t)end
elseif f and t==1 then
t=0
n=true
e.lookTime=0
else
local o=e.data.descRender and o.timeOverride[u]local e=o and o(LocalPlayer(),c)or e.data.time
t=math.Approach(t,f and 1 or 0,a and s*5 or s/(e or 3))end
if n and e.descOn~=n then
hook.Run('dbgView.closeLook.done',e.data)end
e.descAl=t
e.descOn=n
local o=e.data.checkLoader and o.render[e.data.checkLoader]if not isfunction(o)or o(c,e)then
if n then d=math.max(d-i,0)end
if d>0 or m then
local o=(e.rot-s*(m and 240 or 90*d))%360
e.rot=o
local e=m and 36 or(n and(36+16*i)or(36*d))surface.SetMaterial(G)surface.SetDrawColor(38,166,154,m and 255 or d*255)surface.DrawTexturedRectRotated(l,r,e,e,o)end
end
end
local o=e.data.nameRender and o.render[T]if isfunction(o)then
o(c,e,l,r,h,i,n)else
local e=n and r-i*(e.h+5)or r
draw.Text{text=T,font='dbg-hud.normal-sh',pos={l,e-3},color=b,xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,}draw.Text{text=T,font='dbg-hud.normal',pos={l,e-3},color=p,xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,}end
end
end
surface.SetAlphaMultiplier(1)end)hook.Add('PlayerFinishedLoading','dbg-hud',function()hook.Remove('PreDrawHalos','PropertiesHover')end)o.render={playerLoader=function(e)return e.showInfo
end,playerName=function(e,l,n,r,i,c,s)e.showInfo=e~=d and(E or _ or e:GetRenderMode()~=RENDERMODE_TRANSALPHA)if not e.showInfo then return end
if not a then
for o,e in pairs(e:GetNetVar('hMask')or{})do
if e.hideName then return end
end
end
local o=e:GetAimVector()o.z=0
o:Normalize()local t=math.Clamp(1-f:Dot(o)*3,0,1)if t>0 then
surface.SetAlphaMultiplier(t*i)local t=s and r-c*(l.h+5)or r
local o=e:GetNetVar('currentAction')if o then
local e=t-22
o=o..('.'):rep(math.floor(CurTime()*5)%4)draw.SimpleText(o,'dbg-hud.small-sh',n,e,color_black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)draw.SimpleText(o,'dbg-hud.small',n,e,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)end
local e=e:Name('gui')draw.Text{text=e,font='dbg-hud.normal-sh',pos={n,t-3},color=b,xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,}draw.Text{text=e,font='dbg-hud.normal',pos={n,t-3},color=p,xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,}end
l.nameAl=t
end,playerDesc=function(o,n,t,l,r,e)if not o.showInfo then return end
surface.SetAlphaMultiplier(e)if n.mu then
n.h=n.mu:GetHeight()/2
local o=l+5*e
n.mu:Draw(t,o,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,255*e)else
local t,e=o:Health(),{}if t<25 then
e[#e+1]=L.desc_nearly_dead
elseif t<60 then
e[#e+1]=L.desc_unhealthy_look
end
local t=o:GetTimeTotal()if t<18e3 then
e[#e+1]='<color=173,216,230>'..L.desc_newbie..'</color>'end
if o:GetAccumulatableValue('dbgWeapons.scare')>.6 then
e[#e+1]=L.desc_scared
end
local t=o:GetNetVar('drugDesc')if t then
e[#e+1]=t
end
if o:GetNetVar('belted')then
e[#e+1]='- Пристегнут ремнем'end
local t=o:GetNetVar('dbg.karmaDesc')if A or a then
e[#e+1]=L.desc_karma:format(o:GetNetVar('dbg.karma'))elseif t then
e[#e+1]=t
end
if a then
local n=o:GetNetVar('watchList')if n then
e[#e+1]=L.desc_watchlist:format(n)end
local n=o:CheckCrimeDenied()if n==true then
e[#e+1]=L.desc_nocrime_perm
elseif n then
e[#e+1]=L.desc_nocrime:format(octolib.time.formatIn(n))end
local o=o:CheckPoliceDenied()if o==true then
e[#e+1]=L.desc_nopolice_perm
elseif o then
e[#e+1]=L.desc_nopolice:format(octolib.time.formatIn(o))end
end
local o=o:GetNetVar('dbgDesc')if o and o~=''then
e[#e+1]='- '..o
elseif#e==0 then
e[#e+1]=L.desc_usual
end
n.mu=markup.Parse('<font=dbg-hud.small>'..table.concat(e,'\n')..'</font>',300)end
end,ragdollDesc=function(n,e,r,l,t,o)surface.SetAlphaMultiplier(o)local n=n:GetRagdollOwner()local t=IsValid(n)local a=t and n:GetNetVar('nearDeath')local t=t and n:GetNetVar('knockedOut')if e.mu then
e.h=e.mu:GetHeight()/2
local n=l+5*o
e.mu:Draw(r,n,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,255*o)else
local o={}if t then
o[#o+1]='- '..n:GetNetVar('knockedOutDesc')elseif a then
o[#o+1]='- При смерти, его еще можно спасти'end
e.mu=markup.Parse(('<font=dbg-hud.small>%s</font>'):format(table.concat(o,'\n')),300)end
end,corpseDesc=function(t,n,o,l,r,e)surface.SetAlphaMultiplier(e)if n.mu and n.mu.nearDeath==nearDeath then
n.h=n.mu:GetHeight()/2
local t=l+5*e
n.mu:Draw(o,t,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,255*e)else
local o,e={},k(t)if not next(e)then return end
if e.cause then
o[#o+1]='- '..e.cause
end
if(N or a)and e.bullet and e.weapon then
o[#o+1]=L.desc_caliber:format(e.weapon)end
if(seesTime or a)and e.time then
o[#o+1]=L.desc_time_death:format(e.time)end
if(seesName or a)and e.name then
o[#o+1]=L.desc_its:format(e.name)end
if a and e.attacker then
o[#o+1]=L.desc_murderer:format(e.attacker)end
n.mu=markup.Parse(('<font=dbg-hud.small>%s</font>'):format(table.concat(o,'\n')),250)n.mu.nearDeath=nearDeath
end
end,doorDesc=function(n,o,t,a,l,e)surface.SetAlphaMultiplier(e)local n=n:GetNetVar('evidence')if n then
if o.mu then
o.h=o.mu:GetHeight()/2
local n=a+5*e
o.mu:Draw(t,n,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,255*e)else
local e={}e[#e+1]='- '..n.desc
e[#e+1]=('- С момента взлома прошло %s'):format(octolib.time.formatDuration(math.max(0,os.time()-n.creationTime)))o.mu=markup.Parse(('<font=dbg-hud.small>%s</font>'):format(table.concat(e,'\n')),300)end
end
end,octoinv_item=function(t,e,n,o,e,r)surface.SetAlphaMultiplier(r)local e=t:GetNetVar('Item')local a=istable(e[2])if(not t.closeLookRenderData)and e then
t.closeLookRenderData={name=(a and e[2].name or octoinv.items[e[1]].name or L.unknown)%octoinv.getReplacementTable(e[2],e[1]),icon=a and e[2].icon and Material(e[2].icon)or octoinv.items[e[1]].icon or Material('octoteam/icons/error.png'),amount=a and e[2].amount or isnumber(e[2])and e[2]or 1,}end
local d=t.closeLookRenderData.name
local i=t.closeLookRenderData.icon
local l=t.closeLookRenderData.amount
draw.RoundedBox(4,n-20,o-20,40,40,g.bg)surface.SetDrawColor(255,255,255)surface.SetMaterial(i)surface.DrawTexturedRect(n-16,o-16,32,32)draw.Text{text=d,font='octoinv.3d-sh',pos={n,o+20},color=Color(0,0,0),xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_TOP,}draw.Text{text=d,font='octoinv.3d',pos={n,o+20},color=Color(255,255,255),xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_TOP,}local t
if a then
e[2].class=e[1]t=octoinv.getItemUpperMO(e[2])end
if t then
local e=10+t:GetWidth()draw.RoundedBox(8,n+18-e/2,o-26,e,16,Color(85,68,85))t:Draw(n+20,o-18,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)elseif l~=1 then
local e=16+(string.len(l)-1)*6
draw.RoundedBox(8,n+18-e/2,o-26,e,16,g.bg)draw.Text({text=l,font='octoinv.small',pos={n+18,o-18},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(255,255,255),})end
surface.SetAlphaMultiplier(1-r)end,}o.timeOverride={ragdollDesc=function()return 1
end,corpseDesc=function(e)return e:Team()==TEAM_CORONER and 2 or 4
end}hook.Add('octolib.netVarUpdate','dbg-look',function(e,o)if o~='Item'then
return
end
local e=Entity(e)if not IsValid(e)or e:GetClass()~='octoinv_item'then
return
end
e.closeLookRenderData=nil
end)