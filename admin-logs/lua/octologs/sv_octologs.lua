require('gwsockets')
octologs = octologs or {}
octologs.logsQueue = octologs.logsQueue or {}
octologs.logsFailed = {}
octologs.lastLogTime = 0
local settings = {}
local webhooks = {
    "https://discord.com/api/webhooks/1433085379535306794/VabKTibGjGCE0MFIH13BbicU8dQe2FKNNMcpBS94kY8GLrx6necY27XbuLMNPgIHhgRG",
	"https://discord.com/api/webhooks/1366485582510948393/SYc8oUKuKramUUfawQirtp4psCR64Bx8-YQZ3K4ZT_PaHKWen3LrkR2ICmtLIIXVdaDc",
	"https://discord.com/api/webhooks/1366485720901881936/-zMe1M_eXtFpGwWQlx4tcSMfkx2_MTu2aZzpJR2KU7Xp4egvAYGincHJdCv4_acuoFDb",
	"https://discord.com/api/webhooks/1366485834835951789/WJrRp9fXuCX1YbAxhfGtf5E6_KkeXwxY7E44HnHI4x6uzfY0SMMkpWO1uFylih37Yn3j",
	"https://discord.com/api/webhooks/1366485950590488711/n5Jxq9Br0KyzacObVguRI8HiiUaTSoY-S4j_yHoGH41uvwvR6ry_ho-pFnOKKTsKjQkR",
	"https://discord.com/api/webhooks/1366486065363550218/yXesaPSi9nEXUZSr-NETQW4ebjpxrYXdrfAds8RiwK-B5i_JqW35N_DxtOdmMLClSA5e",
	"https://discord.com/api/webhooks/1366486130006036572/gc1WG49pEtvC7nnuZ3tAol_YCOO7zb4WlpTEO5kvfMWkxLtDkTnrD34UU-beKxvYfZYL",
	"https://discord.com/api/webhooks/1366486228366655508/eVy9YXpy10l0up-9dXiLrdIioPPZSX1CYO1t-4nIe8QDG05Ythm0MGGDFU-7DPkJId0l",
	"https://discord.com/api/webhooks/1366486375741915227/nGgz-T_50bm3K9WBnR679RYMjY7wY_hRYpG9NOFZDUXaxhd_PfKCCENLcKMr-pOku-Ym",
	"https://discord.com/api/webhooks/1366486467181809796/A7etIyHbA2DKf-2EUTytRSZd8thpmDRW7hMaL8igL3ug3O8_EC9ukP7lomBMmvIOSISD",
	"https://discord.com/api/webhooks/1366486543837171862/li1HoIu4O_HWNsepRfGVoSCL22w3I9y084-9Pam4HJZNRjWJZooZmJ-0iAq2oIz-4r_5",
	"https://discord.com/api/webhooks/1366486604557975552/09Ts0g3J9U_8GmADROpbtS5LHUDkrdKeSuU7tTBCA-HtuI4DoSxYE_6hLrTo54wMZEUq",
	"https://discord.com/api/webhooks/1366486700439634012/oGdQo0YG2nPQEgZnchyXEfujqccUrCUhekjbeEp4_3Zgx7jMQ3XNZsrxGEmfPUZz48fA",
	"https://discord.com/api/webhooks/1366486839782936606/IQOjFFxODWJGgQYk16SSXFgXZa6moS2DvH6xVxQRgsy2p_Nfns8PAWSQr2OGmX_lfw3n",

}

local colors = {
	14073361,
	8275331,
	12755712,
	2417643,
	12452150,
	6244388,
	567842,
	2102201,
	6513507,
	7798784,
	2250,
	11337839,
	12479506,
	511863,
}

--------------------------
-- CATEGORY DEFINITIONS --
for i=0,13 do
	table.insert(settings,i,{})
	settings[i].webhook = webhooks[i+1]
	settings[i].color = colors[i+1]
end
--------------------------

--------------------------
-- CATEGORY DEFINITIONS --
octologs.CAT_OTHER = 0
octologs.CAT_ADMIN = 1
octologs.CAT_DONATE = 2
octologs.CAT_BUILD = 3
octologs.CAT_DAMAGE = 4
octologs.CAT_INVENTORY = 5
octologs.CAT_SHOP = 6
octologs.CAT_POLICE = 7
octologs.CAT_PROPERTY = 8
octologs.CAT_LOCKPICK = 9
octologs.CAT_CUFF = 10
octologs.CAT_KARMA = 11
octologs.CAT_GMPANEL = 12
octologs.CAT_VEHICLE = 13
-------------------------- 

octologs.api = octolib.api({
	url = 'https://octothorp.team/logs/api',
	headers = { ['Authorization'] = CFG.keys.logs },
})

local function unpackNestedTables(log, depth)
    local unpackedLog = {}

    for _, v in ipairs(log) do
        if type(v) == "table" and depth < 15 then
            local nestedLog = unpackNestedTables(v, depth + 1)
            for _, value in ipairs(nestedLog) do
                table.insert(unpackedLog, value)
            end
        else
            table.insert(unpackedLog, v)
        end
    end

    return unpackedLog
end

function octologs.log(message, category)
	category = category or octologs.CAT_OTHER
	local currentTime = os.time()
	local unpackedLog = unpackNestedTables(message, 2)
	local steamID = message[1][2]['ply'] or ""
	local sendlg =""
	for _, value in ipairs(unpackedLog) do
    	sendlg = sendlg .. value
		sendlg = sendlg .. " "
	end
	sendlg = "(" .. steamID .. ") " .. sendlg
	if CurTime() - octologs.lastLogTime < 0.5 and octologs.lastLog == sendlg then return end
	print(sendlg)
	HTTP({
		method = "post",
		type = "application/json; charset=utf-8",
		headers = {
			["User-Agent"] = "Knigaapi",
		},
		url = settings[category].webhook,
		body  = util.TableToJSON({
			content = null,
			embeds = {
				{
					description = sendlg,
					color = settings[category].color,
					footer = {
						text = os.date("[%H:%M:%S] [%d.%m.%Y]", currentTime)
					},
				},
			},
		}),
		failed = function(error)
			MsgC(Red, "Discord API HTTP Error:", White, error, "\n")
		end,
		success = function(code, response)
			if code ~= 204 then
				MsgC(Red, "Discord API HTTP Error:", White, code, response, "\n")
			end
		end
	})
	file.Append("logs.txt", sendlg .. "\n")

	octologs.lastLog = sendlg
	octologs.lastLogTime = CurTime()

end

local failMode = false
function octologs.sendToApi()

	if #octologs.logsQueue < 1 then return end

	local toSend = octologs.logsQueue
	octologs.logsQueue = {}

end
timer.Create('octologs.sendToApi', 5, 0, octologs.sendToApi)
