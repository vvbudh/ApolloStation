/datum/contract/deface
	title = "Deface the Station" // /obj/effect/decal/cleanable/crayon
	desc = "eat crayons and puke on the floor"
	time_limit = 900
	reward = 500 // /area/hallway/primary/central_one 

	var/phrase = null
	var/list/phrases = list(
		"dogs",
		"butt",
		"fuckers",
		"die",
		"fuck nt",
		"nt sucks",
		"get out",
		"piss off")

/datum/contract/deface/New()
	..()
	if(ticker.current_state == 1)	return 0

	phrase = get_phrase()

	if(!phrase)
		qdel(src)
		return

	set_details()

/datum/contract/deface/set_details()
	desc = "[pick(list("We've a surprisingly serious contract for you", "There's an urgent task at hand"))]. Write \"[phrase]\" in the Central Primary Hallway with crayons."

/datum/contract/deface/check_completion()
	var/hallway = locate(/area/hallway/primary/central_one)

	var/found_phrase = ""
	var/atom/O = locate(/obj/effect/decal/cleanable/crayon) in hallway // so that we don't have to make an even bigger scope pyramid
	if(!O)	return // also this

	for(var/obj/effect/decal/cleanable/crayon/L in hallway)
		if(found_phrase == phrase)	break // we found it in the last loop!
		var/list/namelist = text2list(L.name)
		if(namelist.len > 1)	continue

		found_phrase = ""
		found_phrase += L.name
		var/list/adjacents = orange(1, L)
		O = locate(/obj/effect/decal/cleanable/crayon) in adjacents
		if(O)
			found_phrase += O.name
			var/dir = get_dir(L, O)
			var/spaces = 0
			while(get_step(O, dir) && spaces < 2)
				if(locate(/obj/effect/decal/cleanable/crayon) in get_step(O, dir)) // we have to go deeper
					O = locate(/obj/effect/decal/cleanable/crayon) in get_step(O, dir)
				else
					found_phrase += " "
					spaces++
					O = get_step(O, dir)
					continue
				found_phrase += O.name
				if(found_phrase == phrase)	break

	if(found_phrase == phrase)
		var/mob/living/completer = null
		for(var/mob/M in workers)
			if(M.client.key == O.fingerprintslast)
				completer = M
				break
		end(1, completer)

/datum/contract/deface/proc/get_taken_phrases()
	var/datum/mind/list/taken = list()
	for(var/datum/contract/deface/C in (faction.contracts - src))
		if(istype(C) && C.phrase)	taken += C.phrase
	return taken

/datum/contract/deface/proc/get_phrase()
	phrases -= get_taken_phrases()
	return (phrases.len > 0 ? pick(phrases) : null)