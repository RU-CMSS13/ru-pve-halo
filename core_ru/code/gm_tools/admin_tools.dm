// TOGGLABLE OBSERVE \\

GLOBAL_VAR_INIT(admin_only_observe, FALSE)

/client/proc/toggle_admin_only_observe()
	set name = "Toggle Admin Only Observe"
	set category = "Game Master.Flags"
	if(!check_rights(R_SERVER)) return
	GLOB.admin_only_observe = !GLOB.admin_only_observe
	message_admins("[key_name_admin(usr)] toggled admin-only observe [GLOB.admin_only_observe ? "ON" : "OFF"].")
	log_admin("[key_name(usr)] toggled admin-only observe [GLOB.admin_only_observe ? "ON" : "OFF"].")
