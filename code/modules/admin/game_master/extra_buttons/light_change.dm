#define GROUNDMAP_Z_LEVEL 2
#define SHIPMAPMAP_Z_LEVEL 3

/client/proc/gm_lighting()
	set name = "Change Daytime"
	set category = "Game Master.Extras"

	if(!check_rights(R_ADMIN))
		return

	var/list/z_level_options = list("Groundmap" = GROUNDMAP_Z_LEVEL, "Shipmap" = SHIPMAPMAP_Z_LEVEL)

	var/map_choice = tgui_alert(usr, "Select the map where you need to change the lighting.", "Confirm", z_level_options)
	if(!map_choice)
		return

	var/z_level = z_level_options[map_choice]

	var/light_str = input(usr, "Set the light power.", "Daytime Brightness", "0.3") as null|num
	var/daytime_color = input(usr, "Please select the color to use.", "Daytime Color") as color|null

	var/confirm = tgui_alert(usr, "Are you sure you wish to change daytime on the map to this settings?", "Confirm", list("Yes", "No"), 1 HOURS)
	if(confirm != "Yes")
		return FALSE

	message_admins("[key_name(usr)] changed lighting on map to [daytime_color] color with [light_str].")

	var/list/lightturfs = block(locate(world.maxx, world.maxy, z_level), locate(1, 1, z_level))
	for(var/atom/A as anything in lightturfs.Copy())
		if(istype(A.loc, /area/))
			var/area/targeted = A.loc
			if(!targeted.daytime_affected)
				lightturfs -= A

	for(var/turf/T as anything in lightturfs)
		T.set_light(1, light_str, l_color = daytime_color)

#undef GROUNDMAP_Z_LEVEL
#undef SHIPMAPMAP_Z_LEVEL
