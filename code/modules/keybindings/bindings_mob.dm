// Technically the client argument is unncessary here since that SHOULD be src.client but let's not assume things
// All it takes is one badmin setting their focus to someone else's client to mess things up
// Or we can have NPC's send actual keypresses and detect that by seeing no client

/mob/key_down(_key, client/user)
	if(SSinput.typing_indicator_binds[_key])
		var/macroset = winget(user, "mainwindow", "macro")
		var/list/L = SSinput.macro_set_reverse_lookups[macroset]
		var/valid = FALSE
		for(var/the_verb in L)
			if(the_verb in SSinput.typing_indicator_verbs)
				var/list/keys = L[the_verb]
				valid = TRUE
				if(length(keys) > 1)
					for(var/i in 2 to length(keys))
						if(!client.keys_held[keys[i]])
							valid = FALSE
							break
		if(valid)
			display_typing_indicator()
	switch(_key)
		if("Escape")			//escape breaks out of clientside verb text input without executing at all, meaning we can't hook the verb to do this for us.
			clear_typing_indicator()
		if("Delete", "H")
			if(!pulling)
				to_chat(src, "<span class='notice'>You are not pulling anything.</span>")
			else
				stop_pulling()
			return
		if("Insert", "G")
			a_intent_change(INTENT_HOTKEY_RIGHT)
			return
		if("F")
			a_intent_change(INTENT_HOTKEY_LEFT)
			return
		if("X", "Northeast") // Northeast is Page-up
			swap_hand()
			return
		if("Y", "Z", "Southeast")	// Southeast is Page-down
			mode()					// attack_self(). No idea who came up with "mode()"
			return
		if("Q", "Northwest") // Northwest is Home
			var/obj/item/I = get_active_held_item()
			if(!I)
				to_chat(src, "<span class='warning'>You have nothing to drop in your hand!</span>")
			else
				dropItemToGround(I)
			return
		if("E")
			quick_equip()
			return
		if("Alt")
			toggle_move_intent()
			return
		//Bodypart selections
		if("Numpad8")
			user.body_toggle_head()
			return
		if("Numpad4")
			user.body_r_arm()
			return
		if("Numpad5")
			user.body_chest()
			return
		if("Numpad6")
			user.body_l_arm()
			return
		if("Numpad1")
			user.body_r_leg()
			return
		if("Numpad2")
			user.body_groin()
			return
		if("Numpad3")
			user.body_l_leg()
			return

	if(client.keys_held["Ctrl"])
		switch(SSinput.movement_keys[_key])
			if(NORTH)
				if(client.keys_held["Shift"])
					northshift()
				else
					northface()
				return
			if(SOUTH)
				if(client.keys_held["Shift"])
					southshift()
				else
					southface()
				return
			if(WEST)
				if(client.keys_held["Shift"])
					westshift()
				else
					westface()
				return
			if(EAST)
				if(client.keys_held["Shift"])
					eastshift()
				else
					eastface()
				return
	return ..()

/mob/key_up(_key, client/user)
	switch(_key)
		if("Alt")
			toggle_move_intent()
			return
	return ..()
