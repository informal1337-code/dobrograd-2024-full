local copData = {check = DarkRP.isCop}
octochat.defineCommand('/callhelp', copData)
octochat.defineCommand('/panicbutton', copData)
octochat.defineCommand('/warrant', copData)
octochat.defineCommand('/wanted', copData)
octochat.defineCommand('/unwanted', copData)
octochat.defineCommand('/givelicense', copData)
octochat.defineCommand('/takelicense', copData)
octochat.defineCommand('/carcheck', copData)
octochat.defineCommand('/pbroadcast', {
	check = function(ply)
		return ply:isChief()
	end
})

octochat.defineCommand('/cr', true)