
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- version 1.0
-- Bip-Animator GUI
-- by N.K.

--------

macroScript NK_Tools
category: "NK Tools"
tooltip: "Bip-Animator"
icon: #("PhysX_Main", 15)

(
global gui_handle
(
	
		try (cui.unregisterDialogBar gui_handle) catch()
		try (closeRolloutFloater gui_handle) catch()
	

		
		rollout gui_rollout3 "Docking" (
			
			
		button btn1 "Left" across:4   height:20 offset:[-10,0] width:44
		button btn4 "Right"   height:20 offset:[-4,0] width:44
		button btn3 "Undock"    height:20 offset:[8,0] width:44
		button btn2 "Close"    height:20 offset:[10,0] width:44
			
			
			
			
	---------------------------------------------------------------------------------------------------------------------------------------------- Docking
		

		on btn1 Pressed do 
	(
		try (cui.registerDialogBar gui_handle) catch()
		
		cui.dockDialogBar gui_handle #cui_dock_left
		
	)
		
			on btn2 Pressed do 
	(
		
		try (cui.unregisterDialogBar gui_handle) catch()
		try (closeRolloutFloater gui_handle) catch()

	)
		
				on btn3 Pressed do 
	(
		
		try (cui.unregisterDialogBar gui_handle) catch()
		
	)
	
			on btn4 Pressed do 
	(
		try (cui.registerDialogBar gui_handle) catch()
		cui.dockDialogBar gui_handle #cui_dock_right
		
	)
			

		)
		
		
    ---------------------------------------------------------------------------------------------------------------------------------------	
	---------------------------------------------------------------------------------------------------------------------------------------	
	----------------------------------------------------------------------------------------------------------------------------------------ANIMATOR	
		rollout gui_rollout1 "" (


			
		group "TCB" (

	checkbutton AdditiveMode "Additive Mode" across:2 width:80 height:30 offset:[0,10] align:#left checked:true tooltip:"The TCB curves additively affect each other."
	button btnKey_ResetAll "Reset All"  width:80 height:30 offset:[0,10] 
	button btnKey_EaseTo "Ease To" across:3 width:80 height:40 align:#left offset:[0,10]
	button btnKey_ResetEaseTo "R" width:40 height:40 align:#right offset:[15,10]
	Spinner SpnEaseTo ""  width:40 range:[0,50,0] align:#right offset:[4,15]
			
	button btnKey_EaseFrom "Ease From"  across:3 width:80 height:40 align:#left 
	button btnKey_ResetEaseFrom "R" width:40 height:40 align:#right offset:[15,0]
	Spinner SpnEaseFrom ""  width:40 range:[0,50,0] align:#right offset:[4,6]
			
	button btnKey_Tension "Tension" across:3 width:80 height:40 align:#left 
	button btnKey_ResetTension "R" width:40 height:40 align:#right offset:[15,0]
	Spinner SpnTension ""  width:40 range:[0,50,25] align:#right offset:[4,6]
			
	button btnKey_ContinuityLinear "Continuity" across:3 width:80 height:40 align:#left 
	button btnKey_ResetLinear "R" width:40 height:40 align:#right offset:[15,0]
	Spinner SpnContinuity ""  width:40 range:[0,50,25] align:#right offset:[4,6]
			
	button btnKey_Bias0 "Bias 0"  across:3 width:80 height:40 align:#left 
	button btnKey_ResetBias "R" width:40 height:80 align:#right offset:[15,2]
    Spinner SpnBias ""  width:40 range:[0,50,25] align:#right offset:[4,28]
			
	button btnKey_Bias50 "Bias 50" across:2 width:80 height:40 align:#left  offset:[0,-43]
	
	
			
			
		)
		
		local Color1b = bitmap 10 6 color:gray
		local Color2b = bitmap 10 6 color:red
		imgtag img_spnEaseTo "" bitmap:Color1b align:#right offset:[-21,-240]
		imgtag img_spnEaseFrom "" bitmap:Color1b align:#right offset:[-21,-202]
		imgtag img_spnTension "" bitmap:Color1b align:#right offset:[-21,34]
		imgtag img_spnContinuity "" bitmap:Color1b align:#right offset:[-21,35]
		imgtag img_spnBias "" bitmap:Color1b align:#right offset:[-21,54]
		
		
		imgtag img_spnEaseTo2 "" offset:[0,30] ----offsets ui
		

		
				group "Keying" (
					
					button btnKey_Free "Free" across:3 width:50 height:40
	                button btnKey_Sliding "Sliding"width:50 height:40 
					button btnKey_Planted "Planted" width:50 height:40 
					
			


		)
		
			    local bmGray = bitmap 30 6 color:gray
		        local bmYellow = bitmap 30 6 color:yellow
		        local bmOrange = bitmap 30 6 color:orange
				imgtag img_tag "imgtag" bitmap:bmGray  across:3  offset:[13,0]
		        imgtag img_tag2 "imgtag" bitmap:bmYellow offset:[13,0]
		        imgtag img_tag3 "imgtag" bitmap:bmOrange offset:[13,0]
		
		group "" (
					
	button btnKey "Key All" across:2 width:74 height:20 align:#left offset:[5,0] tooltip:"Set a key for all biped parts at current frame, useful for body poses or setting a base key for animation layers."
	button btnDel "Del All" width:74 height:20 align:#right offset:[-5,0] tooltip:"Delete all biped keys at current frame."

		)

		
		

	
	

		
		
	
	--TCB------------------------------------------------------ TCB ------------------------------------------------------------------ TCB --------------
	
	fn ControllerToKey ctrl t =
	(
		theKey = undefined 
		count = ctrl.controller.keys.count
		k = undefined
		for i = 1 to count while theKey == undefined where (k = biped.getKey ctrl i).time == t do theKey = k
		theKey
	)
	
	
		fn BodyBipNodes theRoot =
	(
		nodeIndexList = #(#larm,#rArm,#lLeg,#rLeg,#spine,#head,#pelvis,#tail,#prop1,#prop2,#prop3,#pony1,#pony2)
		obj = undefined
		for i in nodeIndexList where ( obj = ( biped.getNode theRoot i ) ) != undefined collect obj
	)
	
	
		fn AllctrlNodesBip theRoot =
	(
		objList = ( BodyBipNodes theRoot ) + #( theRoot.controller.vertical,theRoot.controller.Horizontal,theRoot.controller.turning )
	)
	
	
		fn BipRootSel =
	(
		theBip = Undefined
		for obj in selection while  (theBip == Undefined) where (classof obj.baseobject == Biped_Object ) do ( theBip = Obj )
		if theBip != Undefined then theBip.controller.rootNode else undefined
	)
	
	
		fn setTcb k = -------------------------------------VALUES SPINNER
	(
		k.EaseTo = spnEaseTo.value
		k.EaseFrom = SpnEaseFrom.value
		k.Tension = SpnTension.value
		k.Continuity = SpnContinuity.value
		k.Bias = SpnBias.value
	)
	
	fn resetspinnervalues = 
		
	(
		
	    spnEaseTo.value = 0
		SpnEaseFrom.value = 0
		SpnTension.value = 25
		SpnContinuity.value = 25
		SpnBias.value = 25

	)
	
	
	
		
	-------------------------------------------------------------------------------------------------------------------------------------------------- KEYING
	
				on btnKey_Free Pressed do 
	(
		undo on (

					try
			(
				 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			try (
				
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				try (
				
				k = biped.addNewKey obj.controller sliderTime
			
				biped.setFreeKey obj
				
				setTcb k
				
				) catch()
			)
		) catch()
				

		)	
				
		) catch()
	)
)
		
	
	
						on btnKey_Sliding Pressed do 
	(
		undo on (

					try
			(
				 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
			
				biped.setslidingKey obj
				
				setTcb k
				
				
			)
				

		)	
				
		) catch()
	)
)
		
	

	
	
	
					on btnKey_Planted Pressed do 
	(
		undo on (

					try
			(
				 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
			
				biped.setPlantedKey obj
				
				setTcb k
				
				
			)
				

		)	
				
		) catch()
	)
)
	
	
	
	
	-------------------------------------------------------- fn resets 
	
	fn ResetAllBipKeys = 
		
	(
		
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
		k.EaseFrom = 0
		k.Tension = 25
		k.Continuity = 25
		k.Bias = 25
				
				resetspinnervalues ()
				
			)
		)
	)
	
		fn ResetEaseFromKey = 
		
	(
		
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				

		k.EaseFrom = 0
		SpnEaseFrom.value = 0
		

				
			)
		)
	)
	
			fn ResetEaseToKey = 
		
	(
		
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
			
		SpnEaseTo.value = 0


				
			)
		)
	)
	
			fn ResetLinearKey = 
		
	(
		
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				

		k.Continuity = 25
		SpnContinuity.value = 25

				
			)
		)
	)
	

				fn ResetBiasKey = 
		
	(
		
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				

		k.Bias = 25
		spnBias.value = 25
				
			)
		)
	)
	
					fn ResetTensionKey = 
		
	(
		
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				

		k.Tension = 25
		spnTension.value = 25
				
			)
		)
	)
	
	
	-------------------------------------------- Spinner color change when value changes
	
	
-- 	
	  on SpnEaseTo changed val do
    (
		
	
        if val != 0 then
        (
			
			img_spnEaseTo.bitmap = Color2b -- change color when enabled
			
        )
		
		else 
		
		(
			
			img_spnEaseTo.bitmap = Color1b
			
		)
	
	
	)
	
	
		  on SpnEaseFrom changed val do
    (
		
	
        if val != 0 then
        (
			
			img_spnEaseFrom.bitmap = Color2b -- change color when enabled
			
        )
		
		else 
		
		(
			
			img_spnEaseFrom.bitmap = Color1b
			
		)
	
	
	)

	
		  on Spntension changed val do
    (
		
	
        if val != 25 then
        (
			
			img_spnTension.bitmap = Color2b -- change color when enabled
			
        )
		
		else 
		
		(
			
			img_spnTension.bitmap = Color1b
			
		)
	
	
	)

	
		  on SpnContinuity changed val do
    (
		
	
        if val != 25 then
        (
			
			img_spnContinuity.bitmap = Color2b -- change color when enabled
			
        )
		
		else 
		
		(
			
			img_spnContinuity.bitmap = Color1b
			
		)
	
	
	)


		  on SpnBias changed val do
    (
		
	
        if val != 25 then
        (
			
			img_spnBias.bitmap = Color2b -- change color when enabled
			
        )
		
		else 
		
		(
			
			img_spnBias.bitmap = Color1b
			
		)
	
	
	)



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	---------------------------------------------Key All
	
	
		on btnKey Pressed do 
	(
		undo on (
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				--print obj
				k = biped.addNewKey obj.controller sliderTime
				setTcb k
			)
		)
	)
	)
	
	on btnDel Pressed do 
	(
		undo on (
		theRoot = BipRootSel()
		if theRoot != undefined do
		(
			undo "delete bip keys" on
			(
				for obj in ( AllctrlNodesBip theRoot  ) do
				(
					i = getKeyIndex obj.controller sliderTime
					if i > 0 then deleteKey  obj.controller  i 
					--k = biped.addNewKey obj.controller sliderTime
					--setTcb k
				)
			)
		)
	)
	)
	
	
-----------------------------------------------------------------------KEYS
------------------------------------------------------ RESETS
	
		on btnKey_ResetAll Pressed do 
	(
		undo on (
			
ResetAllBipKeys()
			
			img_spnBias.bitmap = Color1b
img_spnContinuity.bitmap = Color1b	
img_spnTension.bitmap = Color1b	
img_spnEaseFrom.bitmap = Color1b
img_spnEaseTo.bitmap = Color1b


			)
		)
	
		
		
				on btnKey_ResetEaseTo Pressed do 
	(
		undo on (
			
ResetEaseToKey()
			

img_spnEaseTo.bitmap = Color1b
			
			

			)
		)
	
						on btnKey_ResetEaseFrom Pressed do 
	(
		undo on (
			
ResetEaseFromKey()
			

img_spnEaseFrom.bitmap = Color1b


			

			)
		)
	
						on btnKey_ResetLinear Pressed do 
	(
		undo on (
			
ResetLinearKey()
			

img_spnContinuity.bitmap = Color1b	

			

			)
		)
	
						on btnKey_ResetBias Pressed do 
	(
		undo on (
			
ResetBiasKey()
			
			img_spnBias.bitmap = Color1b

			
			

			)
		)

	
		
										on btnKey_ResetTension Pressed do 
	(
		undo on (
			
ResetTensionKey()
		

img_spnTension.bitmap = Color1b	

			

			)
		)
		
		
		
		
		

	------------------------------------------------------ EASE TO
	
				on btnKey_EaseTo Pressed do (
					undo on (
				 if AdditiveMode.state == true then 
					 (
					 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 50
				spnEaseTo.value = 50
			
img_spnEaseTo.bitmap = Color2b
			)
		)
	)
   else
			(
				
theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 50
		k.EaseFrom = 0
		k.Tension = 25
		k.Continuity = 25
		k.Bias = 25
								spnEaseTo.value = 50
				   
		SpnEaseFrom.value = 0
		SpnTension.value = 25
		SpnContinuity.value = 25
		SpnBias.value = 25
			
img_spnEaseTo.bitmap = Color2b
img_spnBias.bitmap = Color1b
img_spnContinuity.bitmap = Color1b	
img_spnTension.bitmap = Color1b	
img_spnEaseFrom.bitmap = Color1b

				
			)
		)
				 
		)
	)
)
	
	
	
------------------------------------------------------ EASE FROM
	

	
				on btnKey_EaseFrom Pressed do (
					
					undo on (
				 if AdditiveMode.state == true then 
					 (
					 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseFrom = 50
				spnEaseFrom.value = 50
				

img_spnEaseFrom.bitmap = Color2b

				
				
			)
		)
	)
	
   else
			(
				
theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
		k.EaseFrom = 50
		k.Tension = 25
		k.Continuity = 25
		k.Bias = 25
				
		spnEaseFrom.value = 50
				    spnEaseTo.value = 0
		
		SpnTension.value = 25
		SpnContinuity.value = 25
		SpnBias.value = 25
				

img_spnEaseFrom.bitmap = Color2b
img_spnBias.bitmap = Color1b
img_spnContinuity.bitmap = Color1b	
img_spnTension.bitmap = Color1b	
img_spnEaseTo.bitmap = Color1b
				
			)
		)
				 
		)
	)
)
	
	------------------------------------------------------ BIAS 0
	
				on btnKey_Bias0 Pressed do (
					undo on (
					
				 if AdditiveMode.state == true then 
					 (
					 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.Bias = 0
				spnbias.value = 0
				
								img_spnBias.bitmap = Color2b

				
			)
		)
	)
   else
			(
				
theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
		k.EaseFrom = 0
		k.Tension = 25
		k.Continuity = 25
		k.Bias = 0
				
				spnbias.value = 0
				    spnEaseTo.value = 0
		SpnEaseFrom.value = 0
		SpnTension.value = 25
		SpnContinuity.value = 25
	
				
								img_spnBias.bitmap = Color2b
							
img_spnContinuity.bitmap = Color1b	
img_spnTension.bitmap = Color1b	
img_spnEaseFrom.bitmap = Color1b
img_spnEaseTo.bitmap = Color1b
	
			)
		)
				 
		)
	)
)
	
	
	
	------------------------------------------------------ BIAS 50
	
				on btnKey_Bias50 Pressed do (
					
					undo on (
					
				 if AdditiveMode.state == true then 
					 (
					 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.Bias = 50
				spnBias.value = 50
				
				
								img_spnBias.bitmap = Color2b

			)
		)
	)
   else
			(
				
theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
		k.EaseFrom = 0
		k.Tension = 25
		k.Continuity = 25
		k.Bias = 50
							spnBias.value = 50
				    spnEaseTo.value = 0
		SpnEaseFrom.value = 0
		SpnTension.value = 25
		SpnContinuity.value = 25
		
				
				
								img_spnBias.bitmap = Color2b
						
img_spnContinuity.bitmap = Color1b	
img_spnTension.bitmap = Color1b	
img_spnEaseFrom.bitmap = Color1b
img_spnEaseTo.bitmap = Color1b
				
			)
		)
				 
		)
	)
)
	
		------------------------------------------------------ LINEAR
	
				on btnKey_ContinuityLinear Pressed do (
					
					undo on (
					
				 if AdditiveMode.state == true then 
					 (
					 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.Continuity = 0
				spnContinuity.value = 0
				
				
					
img_spnContinuity.bitmap = Color2b	

			)
		)
	)


   else
			(
				
theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
		k.EaseFrom = 0
		k.Tension = 25
		k.Continuity = 0
		k.Bias = 25
				
								spnContinuity.value = 0
				    spnEaseTo.value = 0
		SpnEaseFrom.value = 0
		SpnTension.value = 25
	
		SpnBias.value = 25
				
				
					
img_spnContinuity.bitmap = Color2b	
img_spnBias.bitmap = Color1b
img_spnTension.bitmap = Color1b	
img_spnEaseFrom.bitmap = Color1b
img_spnEaseTo.bitmap = Color1b
				
			)
		)
				 
		)
	)
)


	------------------------------------------------------ Tension
	
				on btnKey_Tension Pressed do (
					undo on (
				 if AdditiveMode.state == true then 
					 (
					 theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.Tension = 50
				spnTension.value = 50
				

img_spnTension.bitmap = Color2b	

			)
		)
	)
   else
			(
				
theRoot = BipRootSel()
		if theRoot != undefined do
		(
			for obj in ( AllctrlNodesBip theRoot  ) do
			(
				
				k = biped.addNewKey obj.controller sliderTime
				
        k.EaseTo = 0
		k.EaseFrom = 0
		k.Tension = 50
		k.Continuity = 25
		k.Bias = 25
				
spnTension.value = 50
				    spnEaseTo.value = 0
		SpnEaseFrom.value = 0
	
		SpnContinuity.value = 25
		SpnBias.value = 25
				

img_spnTension.bitmap = Color2b	
img_spnBias.bitmap = Color1b
img_spnContinuity.bitmap = Color1b	
img_spnEaseFrom.bitmap = Color1b
img_spnEaseTo.bitmap = Color1b

				
				
				
			)
		)
				 
		)
	)
)
	




			)
			
			
			
			
			
    ---------------------------------------------------------------------------------------------------------------------------------------	
	---------------------------------------------------------------------------------------------------------------------------------------				
------------------------------------------------------------------------------------------------------------------------------------------------HELPERS
		
		rollout gui_rolloutHelpers "Helpers" (
			
			
			label HelpersLbl "Helpers:" pos:[5,5] width:100 height:20
			button  EnableHelpers "ENABLE" across:2 width:80 height:30 offset:[0,0] align:#left tooltip:"Enable the selection of Biped parts with the helpers."
			button  DisableHelpers "DISABLE" width:80 height:30 offset:[0,0] align:#Right tooltip:"Disable the helpers."
			local Color1 = bitmap 15 6 color:gray
	        local Color2 = bitmap 15 6 color:Green
			imgtag img_tag3 "imgtag" bitmap:Color1 offset:[32,0]
		    checkbutton HideUnhideHelpers "Hide Primary"  width:80 height:25 offset:[0,-10] align:#Right tooltip:"Hide/Unhide side primary helpers."
			checkbutton HideUnhideHelpersCOM "COM"  across:2 width:40 height:25 offset:[45,0] align:#Right  tooltip:"Hide/Unhide side COM helper."
			checkbutton HideUnhideHelpersSmall "Unhide"  width:40 height:25 offset:[0,0] checked:true align:#Right tooltip:"Hide/Unhide side foot roll helpers, Auto sliding key will be set on the foot while using these helpers."
			
			
			

------------------------------------ HIDE/UNHIDE and button states on checkboxes to prevent both being pressed at the same time.

			on HideUnhideHelpers changed state do
    (
			    (
        if state then(
			
				try
				(					
	
				
            HideUnhideHelpers.text = "Unhide Primary"
			
			a = $ptctrlm*
            g = hide a
		
			) catch()
			
		)
		
        else
		(
				try
				(	
            HideUnhideHelpers.text = "Hide Primary"
				a = $ptctrlm*
            g = unhide a
						) catch()
		
			
		)
    )
		
	)
	
				on HideUnhideHelpersSmall changed state do
    (
			    (
        if state then(
			
			try
				(	
            HideUnhideHelpersSmall.text = "Unhide"
					a = $ptctrlr*
            g = hide a
		
			) catch()
		)
        else(
			
			try
				(	
            HideUnhideHelpersSmall.text = "Rolls"
						a = $ptctrlr*
            g = unhide a
) catch()
		)
    )
		
	)
			
			
				on HideUnhideHelpersCOM changed state do
    (
			    (
        if state then(
			try
				(	
			
            HideUnhideHelpersCOM.text = "Unhide"
					a = $ptctrlmc_BipCom
            g = hide a
		) catch()
			
		)
        else(
			
			try
				(	
            HideUnhideHelpersCOM.text = "COM"
						a = $ptctrlmc_BipCom
            g = unhide a
					
					) catch()

		)
    )
		
	)
	
-----------------------------------------------------------------------
		
------------------------------------- Foot Left
global ptAnkle_L = "ptctrlm_Ankle_l"
global ptBack_L = "ptctrlm_Back_l" 
global ptFront_L = "ptctrlm_Front_l" 
global ptToe_L = "ptctrlm_Toe_l"
global ptFrontR_L = "ptctrlr_FrontR_l"
global ptFrontL_L = "ptctrlr_FrontL_l"
global ptBackL_L = "ptctrlr_BackL_l"
global ptBackR_L = "ptctrlr_BackR_l"


------------------------------------- Foot Right
global ptAnkle_R = "ptctrlm_Ankle_r"
global ptBack_R = "ptctrlm_Back_r" 
global ptFront_R = "ptctrlm_Front_r" 
global ptToe_R = "ptctrlm_Toe_r"
global ptFrontR_R = "ptctrlr_FrontR_r"
global ptFrontL_R = "ptctrlr_FrontL_r"
global ptBackL_R = "ptctrlr_BackL_r"
global ptBackR_R = "ptctrlr_BackR_r"

------------------------------------- bip com
global bipcom = "ptctrlmc_BipCom"
		


fn onSelectionChange =
(

	
	
	
    if selection.count > 0 do
    (                                     
        local selectedNode = selection[1]
		

		
		
		
		----------------------------------------------------------------------------------------------------------------------------- RIGHT FOOT Start
		
        if isValidNode selectedNode and selectedNode.name == ptAnkle_R then
        (
			
	y = numKeys $.controller

    if y > 0 then (
	
	select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 1
	
)

else

( 
		select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 1
	
)
			
		
			
        
		)
		
	 -----------------
		
	
		        if isValidNode selectedNode and selectedNode.name == ptBack_R then
        (
			
	y = numKeys $.controller

    if y > 0 then (
	
			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 3
)

else

( 
        
			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 3
	
	
	
	)
		)
		
	 -----------------
		
			        if isValidNode selectedNode and selectedNode.name == ptFront_R then
        (
			

	y = numKeys $.controller

    if y > 0 then (
	
			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 6
)

else

( 
        
			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 6
	
	
	
	)
		)
		
	 -----------------

				        if isValidNode selectedNode and selectedNode.name == ptToe_R then
        (
			

			select $.parent
			a = biped.getNode $ #rtoes link:1
			select a
			--biped.setFreeKey a
-- 			
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 8

        
		)
		
	 -----------------
		
			        if isValidNode selectedNode and selectedNode.name == ptFrontR_R then
        (
			

			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 7

        
		)
		
	 -----------------
		
		
					        if isValidNode selectedNode  and selectedNode.name == ptFrontL_R then
        (
			

        
			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 5

        )
		
		
	 -----------------

					        if isValidNode selectedNode  and selectedNode.name == ptBackL_R then
        (
			

			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 2

        
		)
		
	 -----------------

		
					        if isValidNode selectedNode and selectedNode.name == ptBackR_R then
        (
			
	
			select $.parent
			a = biped.getNode $ #rleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 4

        )
		
		
	 --------------------------------------------------------------------------------------------------------------------------- RIGHT FOOT END
	
----------------------------------------------------------------------------------------------------------------------------- LEFT FOOT Start
	

		
        if isValidNode selectedNode  and selectedNode.name == ptAnkle_L then
        (
			
	
	y = numKeys $.controller

    if y > 0 then (
	
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 1
)

else

( 
        
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 1
	
	
	
	)
		)
		
	 -----------------
		
	
		        if isValidNode selectedNode and selectedNode.name == ptBack_L then
        (
			

		y = numKeys $.controller

    if y > 0 then (
	
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 3
)

else

( 
        
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 3
	
	
	
	)
		)
		
	 -----------------
		
			        if isValidNode selectedNode  and selectedNode.name == ptFront_L then
        (
			

		y = numKeys $.controller

    if y > 0 then (
	
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 6
)

else

( 
        
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			--biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 6
	
	
	
	)
        )
		
		
	 -----------------

				        if isValidNode selectedNode and selectedNode.name == ptToe_L then
        (
			
	
			select $.parent
			a = biped.getNode $ #ltoes link:1
			select a
			--biped.setFreeKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 8

        
		)
		
	 -----------------
		
			        if isValidNode selectedNode  and selectedNode.name == ptFrontR_L then
        (
			
	
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 7

        
		)
		
	 -----------------
		
		
					        if isValidNode selectedNode  and selectedNode.name == ptFrontL_L then
        (
			
	
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 5

        
		)
		
	 -----------------

					        if isValidNode selectedNode and selectedNode.name == ptBackL_L then
        (
			

			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 2

        
		)
		
	 -----------------

		
					        if isValidNode selectedNode and selectedNode.name == ptBackR_L then
        (
			
	
			select $.parent
			a = biped.getNode $ #lleg link:3
			select a
			biped.setSlidingKey a
			k = biped.getKey $.controller 1
			k.ikPivotIndex = 4

        
		)
		
	 --------------------------------------------------------------------------------------------------------------------------- Left FOOT END
	
		
						if isValidNode selectedNode  and selectedNode.name == bipcom then  ---------------- Pelvis 
        (

		    select $.parent

        )
		
		
    
	))
	

		
			on EnableHelpers pressed do (
		
		
		img_tag3.bitmap = Color2 -- change color when enabled
				
				-- Register the callback
		
				callbacks.addScript #selectionSetChanged onSelectionChange id:#helperSelect persistent:false 
		
		)
		
		
		
		on DisableHelpers pressed do (
		
		
		img_tag3.bitmap = Color1 -- change color back when disabled

-- UnRegister the callback
		  
callbacks.removeScripts id:#helperSelect
		
		)
		

)
----------------------end of rollout helpers
		

		
		
		
    ---------------------------------------------------------------------------------------------------------------------------------------	
	---------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------- Rollout Bake Keys start


	rollout KeyBaking "Baking" (
		
		
		button  btn_BakeSlidingKey "Bake Sliding" across:2 width:80 height:30 offset:[0,0] align:#left tooltip:"Bake Sliding Keys every frame on Selected Biped part(s) at Timeline Range (esc to cancel)."
		button  btn_BakeFreeKey "Bake Free" width:80 height:30 offset:[0,0] align:#Right tooltip:"Bake Free Keys every frame on Selected Biped part(s) at Timeline Range (esc to cancel)."
		


fn BakeToSliding  =
	(
	if selection.count > 0 do
	(
			for obj in (selection as array) do
			(
				try
				(					
					for i = animationRange.start to animationRange.end while not keyboard.escPressed do
					(
						at time i						
						sliderTime = i
						biped.setSlidingKey obj
					)
					
					sliderTime = animationRange.start
					
				) catch()
			)
		)
	)
	
	fn BakeToFree  =
	(
	if selection.count > 0 do
	(
			for obj in (selection as array) do
			(
				try
				(					
					for i = animationRange.start to animationRange.end while not keyboard.escPressed do
					(
						at time i						
						sliderTime = i
						biped.setFreeKey obj
					)
					
					sliderTime = animationRange.start
					
				) catch()
			)
		)
	)
	
	on btn_BakeSlidingKey pressed do
		(
			try
			(
				BakeToSliding()
				
			)catch()
		)
	
	on btn_BakeFreeKey pressed do
		(
			try
			(
				BakeToFree()
				
			)catch()
		)



)-----------------------------End of rollout bake keys








-------------------------------------------------------------------------------------------------------------------------------------------- HELPER SETUP
		
		
		rollout HelpersSetup "Set up Helpers" ( -----Start Rollout HELPERS SETUP
			

		
		button btnCreateHelpers "Create Helpers" height:30 width:125 tooltip:"Select any Biped part and press Create to set up the helpers. You can at any point set the checkbox to - DISABLE - and adjust the position/scale of the helpers, Then Set -ENABLE- Whenever you want to use them in practice."
		button btnDelHelpers "Delete All Helpers" height:25 width:100 tooltip:"Delete all helpers from the scene."
	
			on btnDelHelpers pressed do
			
					(
			

-- UnRegister the callback
		  
callbacks.removeScripts id:#helperSelect
		
			
			undo on (
				
				
				delete $ptctrl*
				
				fn deleteLayerByName layerName = 
(
	--set 0-layer to be current
	(layermanager.getlayer 0).current = true
	--find layer that you need to delate
	layerToDelete = LayerManager.getLayerFromName layerName
	if layerToDelete == undefined then (messagebox ("Layer "+layerName+" is created and helpers placed in it.") title:"DeleteLayerByName" beep:false) else
	(
		layerToDelete.nodes &theNodes -- check if layer is empty then delete it
		if theNodes.count != 0 then (messagebox ("Layer "+layerName+" is not empty, new helpers will be placed under default.") title:"DeleteLayerByName" beep:false)
		else (LayerManager.deleteLayerbyname layerName)
	)
)
deleteLayerByName "BipAnimator_Helpers"
				
				
			)
		)
				
			
			on btnCreateHelpers pressed do 
			
		(
			

-- UnRegister the callback
		  
callbacks.removeScripts id:#helperSelect
		
			
			undo on (
				

				
 if selection.count == 0 then
    (
        messageBox "Please select any part of a Biped."
    )
    else
    (
        local isBiped = false
        for obj in selection do (
            if classof obj == Biped_Object then isBiped = true
        )

        if isBiped then (
			
			
		

global ptAnkle_L = "ptctrlm_Ankle_l"
global ptBack_L = "ptctrlm_Back_l" 
global ptFront_L = "ptctrlm_Front_l" 
global ptToe_L = "ptctrlm_Toe_l"
global ptFrontR_L = "ptctrlr_FrontR_l"
global ptFrontL_L = "ptctrlr_FrontL_l"
global ptBackL_L = "ptctrlr_BackL_l"
global ptBackR_L = "ptctrlr_BackR_l"

global ptAnkle_R = "ptctrlm_Ankle_r"
global ptBack_R = "ptctrlm_Back_r" 
global ptFront_R = "ptctrlm_Front_r" 
global ptToe_R = "ptctrlm_Toe_r"
global ptFrontR_R = "ptctrlr_FrontR_r"
global ptFrontL_R = "ptctrlr_FrontL_r"
global ptBackL_R = "ptctrlr_BackL_r"
global ptBackR_R = "ptctrlr_BackR_r"

global bipcom = "ptctrlmc_BipCom"
		
		
			rleg = biped.getNode $ #rleg link:3
			lleg = biped.getNode $ #lleg link:3
			rtoes = biped.getNode $ #rtoes link:1
			ltoes = biped.getNode $ #ltoes link:1
			ptcom = biped.getNode $ #vertical
		
ptcom.controller.figureMode = true ------- set biped to figure mode
		
pt_ptctrlm_Ankle_r = point size:16 box:off cross:on axistripod:off wirecolor:yellow name:"ptctrlm_Ankle_r"
pt_ptctrlm_Ankle_l = point size:16 box:off cross:on axistripod:off wirecolor:yellow name:"ptctrlm_Ankle_l"
pt_ptctrlm_Toe_r = point size:14 box:off cross:on axistripod:off wirecolor:red name:"ptctrlm_Toe_r"
pt_ptctrlm_Toe_l = point size:14 box:off cross:on axistripod:off wirecolor:red name:"ptctrlm_Toe_l"
	
pt_ptctrlm_Front_l = point size:16 box:off cross:on axistripod:off wirecolor:yellow name:"ptctrlm_Front_l"
pt_ptctrlm_Front_r = point size:16 box:off cross:on axistripod:off wirecolor:yellow name:"ptctrlm_Front_r"
	

pt_ptctrlmc_BipCom = point size:85 box:off cross:on axistripod:off wirecolor:yellow name:"ptctrlmc_BipCom"



pt_ptctrlm_Ankle_r.transform = rleg.transform
pt_ptctrlm_Ankle_l.transform = lleg.transform
pt_ptctrlm_Toe_r.transform = rtoes.transform
pt_ptctrlm_Toe_l.transform = ltoes.transform
pt_ptctrlmc_BipCom.transform = ptcom.transform
pt_ptctrlm_Toe_l.transform = ltoes.transform


pt_ptctrlm_Front_l.transform = ltoes.transform
pt_ptctrlm_Front_r.transform = rtoes.transform

pt_ptctrlm_Front_l.parent = lleg
pt_ptctrlm_Front_r.parent = rleg

pt_ptctrlm_Ankle_r.parent = rleg
pt_ptctrlm_Ankle_l.parent = lleg
pt_ptctrlm_Toe_r.parent = rtoes
pt_ptctrlm_Toe_l.parent = ltoes
pt_ptctrlmc_BipCom.parent = ptcom

-----move toe helpers forward a bit

in coordsys local pt_ptctrlm_Toe_r.pos.x = 4
in coordsys local pt_ptctrlm_Toe_l.pos.x = 4
	
---------------START CREATION OF SECONDARY HELPERS ------ RIGHT FOOT
------------------------------------------------------------Create bounding box orient it first to 90 and then back to preserve vertex order.

x = snapshot rleg
x.parent = undefined


x.rotation.controller[1].controller.value = 90 ----------rotate 1
x.rotation.controller[2].controller.value = 90
x.rotation.controller[3].controller.value = 0

    local theBox = Box()
    theBox.name = "RightFootR_BB"   
	theBox.width = x.boundingBox.max.x - x.boundingBox.min.x 
    theBox.length = x.boundingBox.max.y - x.boundingBox.min.y
    theBox.height = x.boundingBox.max.z - x.boundingBox.min.z
	theBox.pos = x.boundingBox.center
	t = theBox.height /2
	theBox.pos.z = theBox.pos.z - t
	theBox.Scale.Y = theBox.Scale.y * 1.5
	
thebox.parent = x
x.transform = rleg.transform    --------------- rotate back

delete x

--------------------------- CREATE spline from bounding box and then create HELPERS ON VERTICES

select thebox
convertToPoly thebox

 thebox.EditablePoly.SetSelection #Edge #{1..4}
splinereff =  thebox.EditablePoly.createShape "splinereff" off $


for o in 1 to 4 do
(
pt = point size:2 box:on cross:on axistripod:off wirecolor:green name:(uniqueName "ptEbipFootR_")
pt.pos = getknotpoint $splinereff 1 o ) 

delete thebox
delete $splinereff

local FootEdgeRollFR = $ptEbipFootR_001
FootEdgeRollFR.name = "ptctrlr_BackR_r" 
	
local FootEdgeRollFL = $ptEbipFootR_002
FootEdgeRollFL.name = "ptctrlr_BackL_r"
	
local FootEdgeRollBR = $ptEbipFootR_003
FootEdgeRollBR.name = "ptctrlr_FrontL_r" 
	
local FootEdgeRollBL = $ptEbipFootR_004
FootEdgeRollBL.name = "ptctrlr_FrontR_r"

-----------------------------------------Create new helpers in between two helpers

helperA = FootEdgeRollFR
helperB = FootEdgeRollFL

-- Calculate midpoint position
midPos = (helperA.position + helperB.position) / 2

-- Create a new Point helper at the midpoint
midHelper = Point name:"ptctrlm_Back_r" pos:midPos wirecolor:Yellow box:off size:15

midHelper.parent = rleg


---------------------------------- Prent the nodes to foot
	
select FootEdgeRollFR
selectmore FootEdgeRollFL
selectmore FootEdgeRollBR
selectmore FootEdgeRollBL


for obj in selection do (
    if isValidNode obj then (
		obj.parent = rleg
    )
)



------------------------------------------------position the nodes better

in coordsys parent FootEdgeRollFR.pos.y = 0.05
in coordsys parent FootEdgeRollFL.pos.y = 0.05
in coordsys parent FootEdgeRollBR.pos.y = 9
in coordsys parent FootEdgeRollBL.pos.y = 9


---------------START CREATION OF SECONDARY HELPERS ------ LEFT FOOT
------------------------------------------------------------Create bounding box orient it first to 90 and then back to preserve vertex order.

x = snapshot lleg
x.parent = undefined


x.rotation.controller[1].controller.value = 90 ----------rotate 1
x.rotation.controller[2].controller.value = 90
x.rotation.controller[3].controller.value = 0

    local theBox = Box()
    theBox.name = "RightFootR_BB"   
	theBox.width = x.boundingBox.max.x - x.boundingBox.min.x 
    theBox.length = x.boundingBox.max.y - x.boundingBox.min.y
    theBox.height = x.boundingBox.max.z - x.boundingBox.min.z
	theBox.pos = x.boundingBox.center
	t = theBox.height /2
	theBox.pos.z = theBox.pos.z - t
	theBox.Scale.Y = theBox.Scale.y * 1.5
	
thebox.parent = x
x.transform = lleg.transform    --------------- rotate back

delete x

--------------------------- CREATE spline from bounding box and then create HELPERS ON VERTICES

select thebox
convertToPoly thebox

 thebox.EditablePoly.SetSelection #Edge #{1..4}
splinereff =  thebox.EditablePoly.createShape "splinereff" off $


for o in 1 to 4 do
(
pt = point size:2 box:on cross:on axistripod:off wirecolor:green name:(uniqueName "ptEbipFootR_")
pt.pos = getknotpoint $splinereff 1 o ) 

delete thebox
delete $splinereff

local FootEdgeRollFR2 = $ptEbipFootR_001
FootEdgeRollFR2.name = "ptctrlr_BackR_l" 
	
local FootEdgeRollFL2 = $ptEbipFootR_002
FootEdgeRollFL2.name = "ptctrlr_BackL_l"
	
local FootEdgeRollBR2 = $ptEbipFootR_003
FootEdgeRollBR2.name = "ptctrlr_FrontL_l" 
	
local FootEdgeRollBL2 = $ptEbipFootR_004
FootEdgeRollBL2.name = "ptctrlr_FrontR_l"

-----------------------------------------Create new helpers in between two helpers


helperA = FootEdgeRollFR2
helperB = FootEdgeRollFL2

-- Calculate midpoint position
midPos = (helperA.position + helperB.position) / 2

-- Create a new Point helper at the midpoint
midHelper = Point name:"ptctrlm_Back_l" pos:midPos wirecolor:Yellow box:off size:15

midHelper.parent = lleg



---------------------------------- Prent the nodes to foot
	
select FootEdgeRollFR2
selectmore FootEdgeRollFL2
selectmore FootEdgeRollBR2
selectmore FootEdgeRollBL2


for obj in selection do (
    if isValidNode obj then (
		obj.parent = lleg
    )
)

------------------------------------------------position the nodes better

in coordsys parent FootEdgeRollFR2.pos.y = 0.05
in coordsys parent FootEdgeRollFL2.pos.y = 0.05
in coordsys parent FootEdgeRollBR2.pos.y = 9
in coordsys parent FootEdgeRollBL2.pos.y = 9

--------------------------------------------------
				arolls = $ptctrlr* ------------------------------hide the rolls
				hide arolls

ptcom.controller.figureMode = false  ----------set biped out of figure mode
------------------------------------------------------------------------------- put in layers


fn deleteLayerByName layerName = 
(
	--set 0-layer to be current
	(layermanager.getlayer 0).current = true
	--find layer that you need to delate
	layerToDelete = LayerManager.getLayerFromName layerName
	if layerToDelete == undefined then (messagebox ("Layer "+layerName+" is created and helpers placed in it.") title:"DeleteLayerByName" beep:false) else
	(
		layerToDelete.nodes &theNodes -- check if layer is empty then delete it
		if theNodes.count != 0 then (messagebox ("Layer "+layerName+" is not empty, new helpers will be placed under default.") title:"DeleteLayerByName" beep:false)
		else (LayerManager.deleteLayerbyname layerName)
	)
)
deleteLayerByName "BipAnimator_Helpers"


select $ptctrl*

FindLayer = LayerManager.getLayerFromName "BipAnimator_Helpers"
If Findlayer == undefined then (  
NL = LayerManager.newLayerFromName "BipAnimator_Helpers"
for obj in selection do NL.addNode obj
)

deselect $ptctrl*

        )------ IS BIPED THEN
        )------ ELSE
        )----- UNDO ON
		) ------- ON BUTTON PRESSED
     	) ------- END ROLLOUT HELPERS SETUP
		
	
		gui_handle = newRolloutFloater "Bip.Animator v.1.0" 210 600
		addRollout gui_rollout3 gui_handle rolledUp:true  border:true 
		addRollout gui_rollout1 gui_handle rolledUp:false border:false
		addRollout gui_rolloutHelpers gui_handle rolledUp:false border:false
		addRollout KeyBaking gui_handle rolledUp:false border:true
		addRollout HelpersSetup gui_handle rolledUp:true border:true 
		cui.RegisterDialogBar gui_handle minSize:[210, 600] maxSize:[210, 600] style:#(#style_titlebar, #cui_floatable, #cui_dock_left, #cui_dock_right, #cui_handles) escapeEnable:false
		cui.dockDialogBar gui_handle #cui_floatable

)
)