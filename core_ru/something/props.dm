/obj/structure/prop/tyrargo/boards
	name = "boards"
	desc = "Salvaged wooden boards."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "boards"
	density = FALSE
	anchored = TRUE
	unslashable = FALSE
	health = 100
	layer = 2.4
	plane = -7
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/prop/tyrargo/boards/boards_1
	icon_state = "boards_2"

/obj/structure/prop/tyrargo/boards/boards_2
	icon_state = "boards_3"

/obj/structure/prop/tyrargo/boards/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/woodhit.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/tyrargo/boards/proc/explode()
	visible_message(SPAN_DANGER("[src] crumbles!"), max_distance = 1)
	playsound(loc, 'sound/effects/woodhit.ogg', 25)

	deconstruct(FALSE)

/obj/structure/prop/tyrargo/boards/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/tyrargo/boards/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/tyrargo/boards/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// Prop Generator

/obj/structure/machinery/generator_okopnoe_govno
	name = "\improper UE-11 Generator Unit"
	desc = "Special power module designed to be a backup generator in the event of a transformer malfunction."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "gen"
	anchored = TRUE
	wrenchable = TRUE
	density = TRUE
	use_power = USE_POWER_NONE
	needs_power = FALSE

	var/active = FALSE
	var/charge_rate = 5
	var/obj/structure/machinery/power/apc/linked_apc

	var/time_to_sound = 1

/obj/structure/machinery/generator_okopnoe_govno/Initialize(mapload, ...)
	. = ..()
	find_apc()

/obj/structure/machinery/generator_okopnoe_govno/Destroy()
	STOP_PROCESSING(SSobj, src)
	linked_apc = null
	return ..()

/obj/structure/machinery/generator_okopnoe_govno/proc/find_apc()
	if(linked_apc && !QDELETED(linked_apc))
		return linked_apc

	var/area/A = get_area(src)
	linked_apc = A ? A.get_apc() : null
	return linked_apc

/obj/structure/machinery/generator_okopnoe_govno/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!anchored)
		to_chat(user, SPAN_WARNING("\The [src] must be anchored! Use a wrench!"))
		return
	toggle(user)

/obj/structure/machinery/generator_okopnoe_govno/attackby(obj/item/W, mob/user)
	if(active)
		to_chat(user, SPAN_WARNING("We need to turn off \the [src]!"))
		return
	..()

/obj/structure/machinery/generator_okopnoe_govno/proc/toggle(mob/user)
	if(!find_apc())
		to_chat(user, SPAN_WARNING("[src] cannot find an APC in this zone!"))
		return

	active = !active
	icon_state = active ? "gen_on" : "gen"
	playsound(src, 'sound/machines/switch.ogg', 25, 1)

	if(active)
		user.visible_message(SPAN_NOTICE("[user] starts \the [src]."), SPAN_NOTICE("You start \the [src]."))
		set_light(2, l_color = LIGHT_COLOR_FIRE)
		START_PROCESSING(SSobj, src)
	else
		user.visible_message(SPAN_NOTICE("[user] turns off \the [src]."), SPAN_NOTICE("You turn off \the [src]."))
		set_light(0)
		STOP_PROCESSING(SSobj, src)

/obj/structure/machinery/generator_okopnoe_govno/process(delta_time)
	if(!active)
		return
	if(!find_apc() || !linked_apc.cell)
		return
	if(linked_apc.cell.charge >= linked_apc.cell.maxcharge)
		return
	linked_apc.cell.give(charge_rate * delta_time)

	time_to_sound -= delta_time
	if(time_to_sound <= 0)
		playsound(loc, 'core_ru/sounds/engine.ogg', 40, FALSE, 3)
		time_to_sound = initial(time_to_sound)

/obj/structure/machinery/generator_okopnoe_govno/get_examine_text(mob/user)
	. = ..()
	. += active ? SPAN_NOTICE("The generator is running.") : SPAN_NOTICE("The generator is turned off")

/obj/structure/platform/kutjevo/rock/okopnoe_govno
	density = FALSE //for sandbag placement
	color = "#999999"

/obj/structure/platform_decoration/kutjevo/rock/okopnoe_govno
	color = "#999999"

/obj/structure/girder/okopnoe_govno
	name = "wooden girder"
	color = "#857169"
	debris = list(/obj/item/stack/sheet/wood, /obj/item/stack/sheet/wood)

/obj/structure/prop/brazier/torch/okopnoe_govno
	light_range = 3

/obj/structure/prop/brazier/frame/full/campfire/smolder/stove_okopnoe_govno_smolder
	name = "smoldering stove"
	desc = "The stove in which a fire was burning, but it was extinguished. You seem to see the remains of an unquenched fire on the firewood inside."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "stove0"
	frame_type = /obj/structure/prop/brazier/frame/full/campfire/stove_okopnoe_govno_unlit

/obj/structure/prop/brazier/frame/full/campfire/stove_okopnoe_govno_unlit
	name = "unlit stove"
	desc = "The old stove looks like you can light it if you add wood to it."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "stove0"
	frame_type = /obj/structure/prop/brazier/campfire/stove_okopnoe_govno
	density = TRUE

/obj/structure/prop/brazier/campfire/stove_okopnoe_govno
	name = "stove"
	desc = "The old stove in which a fire bursts. Sometimes there is a slight crackling of fire coming from it."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "stove3"
	density = TRUE
	smoldering_type = /obj/structure/prop/brazier/frame/full/campfire/smolder/stove_okopnoe_govno_smolder

/*----------------------*/
// HESCO
/*----------------------*/

/obj/structure/barricade/hesco
	name = "HESCO barricade"
	desc = "A sandbag wall. Provides better protection than a makeshift sandbag barricade, but requires specialized equipment to set up."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "sand_wall"
	wire_icon = 'core_ru/icons/tyrargo_props.dmi'
	health = 800
	maxhealth = 800
	layer = OBJ_LAYER
	stack_type = /obj/item/stack/sandbags
	debris = list(/obj/item/stack/sandbags)
	stack_amount = 5
	destroyed_stack_amount = 1
	barricade_hitsound = 'sound/weapons/Genhit.ogg'
	can_change_dmg_state = 0
	barricade_type = "sand_wall"
	can_wire = FALSE
	repair_materials = list("sandbag" = 1)
	metallic = FALSE

/obj/structure/barricade/hesco/attackby(obj/item/W as obj, mob/user as mob)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return
	if(istype(W, /obj/item/stack/sandbags))
		var/obj/item/stack/sandbags/D = W
		if(health < maxhealth)
			if(D.get_amount() < 1)
				to_chat(user, SPAN_WARNING("You need one sandbag to repair [src]."))
				return
			visible_message(SPAN_NOTICE("[user] begins to repair [src]."))
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src) && health < maxhealth)
				if (D.use(1))
					update_health(-0.5*maxhealth)
					update_damage_state()
					visible_message(SPAN_NOTICE("[user] clumsily repairs [src]."))
		return

	if(try_nailgun_usage(W, user))
		return

	return ..()

/obj/structure/barricade/hesco/hit_barricade(obj/item/I)
	switch(I.damtype)
		if("fire")
			take_damage( I.force * I.demolition_mod * 1.5 )
		if("brute")
			take_damage( I.force * I.demolition_mod * 1.0 )

/obj/structure/barricade/hesco/brown
	color = "#a98c7c"

/turf/closed/noise
	name = "distant noise"
	desc = "In these days, electrical noise follows people everywhere. Not always intelligible, but always unstoppable. It is like radio interference. It seems to intensify as it approaches the boundary of known space. Sometimes you can make out words in the noise. A strange whisper that makes no sense."
	icon = 'core_ru/icons/noise.dmi'
	icon_state = "noise1"
	var/noise_on = FALSE //virubator 3000
/*
	light_range = 1
	light_power = 0.8
	light_color = "#ffffff"
*/
/turf/closed/noise/Initialize(mapload, ...)
	. = ..()
	icon_state = "noise[rand(1,3)]"
	if(!noise_on)
		return
	addtimer(CALLBACK(src, PROC_REF(playnoise)), rand(8,12) SECONDS)

/turf/closed/noise/proc/playnoise()
	if(QDELETED(src))
		return

	playsound(src, pick('core_ru/sounds/noise.ogg', 'core_ru/sounds/noise2.ogg', 'core_ru/sounds/noise3.ogg'), 25, TRUE, 12, VOLUME_AMB, falloff = 3)

	addtimer(CALLBACK(src, PROC_REF(playnoise)), rand(8,12) SECONDS)

/obj/structure/rocks
	name = "rock pile"
	desc = "A pile of huge rocks, guess a pickaxe would come in handy here."
	icon = 'core_ru/icons/tyrargo_props.dmi'
	icon_state = "boulder1"
	density = TRUE
	debris = list(/obj/item/ore, /obj/item/ore/iron)

/obj/structure/rocks/Initialize(mapload, ...)
	. = ..()
	icon_state = "boulder[rand(1,4)]"

/obj/structure/rocks/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/tool/pickaxe))
		to_chat(user, SPAN_WARNING("A [W] won't work here, you need to find a pickaxe!"))
		return ..()

	playsound(loc, 'core_ru/sounds/pickaxe.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE("You started clearing away a pile of rocks with a [W]!"))

	if(!do_after(user, 15 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		return

	playsound(loc, "rocks", 25, 1)
	var/mob/living/carbon/human/H = user
	H.stamina.apply_damage(15)

	if(QDELETED(src))
		return

	var/ore_gacha = pick(debris)
	new ore_gacha(loc)

	qdel(src)

/obj/structure/ladder/prefab_door
	name = "prefabricated door"
	desc = "The door, maybe you can enter."
	icon = 'icons/obj/structures/props/ice_colony/fabs_tileset.dmi'
	icon_state = "fabdoor"
	layer = DOOR_CLOSED_LAYER

	climb_time = 3 SECONDS
	climb_sound = 'sound/effects/doorcreaky.ogg'

	var/door_color

/obj/structure/ladder/prefab_door/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/ladder/prefab_door/update_icon()
	overlays.Cut()
	if(door_color)
		overlays += image(icon, "+[door_color]")

// FLOODLIGHT

/obj/structure/machinery/colony_floodlight/tyrargo
	name = "\improper UE-92/B Area Illuminator"
	desc = "Varient of the UE-92, a large deployable floodlight. This version is less powerful but it houses an internal power source that allows it to operate for several hours without being linked to a power generator."
	icon = 'core_ru/icons/illuminator.dmi'
	icon_state = "floodlight-off"
	health = 200
	lum_value = 8

	floodlight_color ="#e7c0a4"

/obj/structure/machinery/colony_floodlight/tyrargo/update_icon()
	if(damaged)
		icon_state = "floodlight-off"
	else if(is_lit)
		icon_state = "floodlight-on"
	else
		icon_state = "floodlight-off"
