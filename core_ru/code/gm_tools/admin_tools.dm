// Some MODULAR code \\

/client/add_admin_verbs()
	. = ..()
	if(CLIENT_HAS_RIGHTS(src, R_BUILDMODE))
		add_verb(src, /client/proc/roll_dices)
		add_verb(src, /client/proc/toggle_admin_only_observe)


/client/remove_admin_verbs()
	. = ..()
	remove_verb(src, list(
		/client/proc/roll_dices,
		/client/proc/toggle_admin_only_observe,
	))

// TOGGLABLE OBSERVE \\

GLOBAL_VAR_INIT(admin_only_observe, FALSE)

/client/proc/toggle_admin_only_observe()
	set name = "Toggle Admin Only Observe"
	set category = "Game Master.Flags"
	if(!check_rights(R_SERVER)) return
	GLOB.admin_only_observe = !GLOB.admin_only_observe
	message_admins("[key_name_admin(usr)] toggled admin-only observe [GLOB.admin_only_observe ? "ON" : "OFF"].")
	log_admin("[key_name(usr)] toggled admin-only observe [GLOB.admin_only_observe ? "ON" : "OFF"].")
