//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"
	STUI.debug.Add("\[[time_stamp()]]ERROR: [msg]<br>")
	STUI.processing |= 6

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"
	STUI.debug.Add("\[[time_stamp()]]WARNING: [msg]<br>")
	STUI.processing |= 6

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"
	STUI.debug.Add("\[[time_stamp()]]TEST: [msg]<br>")
	STUI.processing |= 6

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"
	STUI.admin.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	STUI.processing |= 2

/proc/log_adminpm(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"

/proc/log_debug(text)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text][log_end]"
	STUI.debug.Add("\[[time_stamp()]]DEBUG: [text]<br>")
	STUI.processing |= 6

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text]"


/proc/log_game(text)
	if (config.log_game)
		diary << "\[[time_stamp()]]GAME: [text][log_end]"
	STUI.admin.Add("\[[time_stamp()]]GAME: [text]<br>")
	STUI.processing |= 2


/proc/log_vote(text)
	if (config.log_vote)
		diary << "\[[time_stamp()]]VOTE: [text][log_end]"

/proc/log_access(text)
	if (config.log_access)
		diary << "\[[time_stamp()]]ACCESS: [text][log_end]"
	STUI.admin.Add("\[[time_stamp()]]ACCESS: [text]<br>")
	STUI.processing |= 2

/proc/log_say(text)
	if (config.log_say)
		diary << "\[[time_stamp()]]SAY: [text][log_end]"
	STUI.game.Add("\[[time_stamp()]]SAY: [text]<br>")
	STUI.processing |= 5

/proc/log_ooc(text)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]OOC: [text][log_end]"

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << "\[[time_stamp()]]WHISPER: [text][log_end]"
	STUI.game.Add("\[[time_stamp()]]WHISPER: [text]<br>")
	STUI.processing |= 5

/proc/log_emote(text)
	if (config.log_emote)
		diary << "\[[time_stamp()]]EMOTE: [text][log_end]"
	STUI.game.Add("\[[time_stamp()]]<font color='#999999'>EMOTE: [text]</font><br>")
	STUI.processing |= 5

/proc/log_attack(text)
	if (config.log_attack)
		diary << "\[[time_stamp()]]ATTACK: [text][log_end]" //Seperate attack logs? Why?  FOR THE GLORY OF SATAN!
	STUI.attack.Add("\[[time_stamp()]]ATTACK: [text]<br>")
	STUI.processing |= 1

/proc/log_adminsay(text)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]ADMINSAY: [text][log_end]"

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << "\[[time_stamp()]]ADMINWARN: [text][log_end]"
//	STUI.cached_logs[2] += "\[[time_stamp()]]ADMIN: [text]<br>"

/proc/log_pda(text)
	if (config.log_pda)
		diary << "\[[time_stamp()]]PDA: [text][log_end]"
	STUI.game.Add("\[[time_stamp()]]<font color='#cd6500'>PDA: [text]</font><br>")
	STUI.processing |= 5

/proc/log_misc(text)
	diary << "\[[time_stamp()]]MISC: [text][log_end]"
	STUI.debug.Add("\[[time_stamp()]]MISC: [text]<br>")
	STUI.processing |= 6

/proc/in_unlogged(var/mob/M) // Checks if the mob is in an unlogged area
	if( istype( M.loc.loc, /area/tdome ))
		return 1

	return 0