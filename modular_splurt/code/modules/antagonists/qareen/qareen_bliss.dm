/datum/disease/qarbliss
	name = "Unnatural Sloth and Lust"
	stage_prob = 3
	max_stages = 7
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Holy Water, or Milk, or Semen, or Female Semen, or Spaceacillin."
	spread_text = "A fog of pink unholy energy"
	cures = list(/datum/reagent/water/holywater, /datum/reagent/consumable/semen, /datum/reagent/consumable/semen/femcum, /datum/reagent/consumable/milk, /datum/reagent/medicine/spaceacillin)
	cure_chance = 100
	agent = "Unholy Forces"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CURABLE
	permeability_mod = 1
	severity = DISEASE_SEVERITY_MEDIUM
	needs_all_cures = FALSE
	var/bliss_stage_1 = FALSE
	var/bliss_stage_2 = FALSE
	//Removed pink coloring - was making vicitm's sprite

/datum/disease/qarbliss/cure()
	if(affected_mob)
		if(affected_mob.dna && affected_mob.dna.species)
			affected_mob.dna.species.handle_mutant_bodyparts(affected_mob)
			affected_mob.dna.species.handle_hair(affected_mob)
		SEND_SIGNAL(affected_mob, COMSIG_CLEAR_MOOD_EVENT, "qar_bliss")
	..()

/datum/disease/qarbliss/stage_act()
	if(prob(stage*2))
		if(prob(5))
			to_chat(affected_mob, "<span class='revennotice'>You feel [pick("hot and bothered", "horny", "lusty", "like you're in a rut", "the need to breed", "breedable", "slimy")]...</span>")
		if(stage > 1 && prob(15))
			affected_mob.confused += 5
		if(stage > 2 && prob(15))
			affected_mob.hallucination += 5
		if(stage > 3 && prob(15))
			affected_mob.drowsyness += 10
		affected_mob.adjustStaminaLoss(stage*2)
		new /obj/effect/temp_visual/revenant(affected_mob.loc)
	..() //So we don't increase a stage before applying the stage damage.
	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.emote("blush")
				affected_mob.reagents.add_reagent(/datum/reagent/drug/aphrodisiac, 5)
		if(3)
			if(!bliss_stage_1)
				SEND_SIGNAL(affected_mob, COMSIG_ADD_MOOD_EVENT, "qar_bliss", /datum/mood_event/qareen_bliss)
				bliss_stage_1 = TRUE
			SEND_SIGNAL(affected_mob, COMSIG_MODIFY_SANITY, 0.12, SANITY_CRAZY)
			if(prob(5))
				affected_mob.emote(pick("blush","drool"))
				affected_mob.reagents.add_reagent(/datum/reagent/drug/aphrodisiac, 15)
		if(4)
			SEND_SIGNAL(affected_mob, COMSIG_MODIFY_SANITY, 0.18, SANITY_CRAZY)
			if(prob(5))
				affected_mob.emote(pick("blush","drool","moan"))
				affected_mob.reagents.add_reagent(/datum/reagent/drug/aphrodisiacplus, 5)
			affected_mob.add_quirk(/datum/quirk/cum_plus)
		if(5)
			if (bliss_stage_2 == FALSE)
				bliss_stage_2 = TRUE
				to_chat(affected_mob, "<span class='revenbignotice'>It's too much! Brain.. fried..</span>")
				if (ishuman(affected_mob))
					var/mob/living/carbon/human/H = affected_mob
					H.mob_climax(TRUE,"Bliss",src,TRUE)
				affected_mob.visible_message("<span class='warning'>[affected_mob] looks utterly depraved.</span>", "<span class='revennotice'>You suddenly feel like your skin is <i>tingling</i>...</span>")
				new /obj/effect/temp_visual/love_heart(affected_mob.loc)
				new /obj/effect/temp_visual/revenant(affected_mob.loc)
				affected_mob.reagents.add_reagent(/datum/reagent/drug/aphrodisiacplus, 10)
				// addtimer(CALLBACK(src, .proc/blessings), 150)
		if(7)
			stage = 6
			if (ishuman(affected_mob))
				var/mob/living/carbon/human/H = affected_mob
				H.mob_climax(forced_climax=TRUE, cause="Bliss")
				if(prob(30))
					affected_mob.emote(pick("blush","drool","moan"))
					affected_mob.reagents.add_reagent(/datum/reagent/drug/aphrodisiacplus, 15)

/datum/disease/qarbliss/proc/blessings()
	if(QDELETED(affected_mob))
		return
	affected_mob.playsound_local(affected_mob, 'sound/effects/gib_step.ogg', 40, 1, -1)
	to_chat(affected_mob, "<span class='revendanger'>You sense the curse of a lustful ghost befall you...</span>")
