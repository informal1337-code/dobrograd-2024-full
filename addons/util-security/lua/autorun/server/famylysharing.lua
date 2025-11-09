--[[
Credits :
C0nw0nk

Github : https://github.com/C0nw0nk/Garrys-Mod-Family-Sharing

Info :
This script will make it very hard for users who you ban from your server to return or bypass their current/existing bans.
When you ban a user it will also ban the account that owns Garry's Mod / has family shared them the game.
Because of the way this script works you can guarantee when you ban someone they have to buy a new Garry's Mod to be able to return. (Keep wasting your money. I am sure Garry does not mind you making him richer.)
Depending on the settings you assign you may also ban users by IP too what will make it harder for the banned user to return.
]]

local SteamFamilySharing = {}
--SteamFamilySharing.APIKey required to deal with those family sharing.
--You may obtain your Steam API Key from here | http://steamcommunity.com/dev/apikey
SteamFamilySharing.APIKey = "EA5C29DA57A70E2DAE67A680BA0616AC"

--The message displayed to those who connect by a family shared account that has been banned.
SteamFamilySharing.kickmessage = "The account that lent you Garry's Mod is banned on this server"

--Ban those who try to bypass a current ban by returning on a family shared account.
--Set true to enable | false to disable.
--If this is set to false it will only kick those bypassing bans.
SteamFamilySharing.banbypass = true

--The length to ban those who are trying to bypass a current / existing ban.
--This will also increase/change the ban length on the account that owns Garry's Mod. (They shouldn't attempt to bypass a current ban.)
--time is in minutes.
--0 is permanent.
SteamFamilySharing.banlength = 0

--The reason the player has been banned automaticly for connecting from a family shared account that already has a ban.
SteamFamilySharing.banreason = "attempting to bypass a current/existing ban."

--Enable banning users by IP address too.
--Makes it even harder for continuous offenders to return to the server.
--Set true to enable | false to disable.
SteamFamilySharing.banip = true
