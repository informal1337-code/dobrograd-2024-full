dbgChars = dbgChars or {}

octolib.shared('config/masks')
octolib.shared('config/clothes')
octolib.shared('config/dbg-characters')

octolib.include.prefixed('/dbg-characters')
octolib.module('dbg-characters/ghosts')
octolib.module('dbg-characters/karma')
octolib.module('dbg-characters/masks')