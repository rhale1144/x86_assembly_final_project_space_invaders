TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc
.data
	;Static Data
		scorestr db "Score: ",0h
		livestr db "Lives: ",0h
		askusername db "Please enter name (10 chars or less)", 0h
		framesizex db 80 
		framesizey db 50
		invadersizeX db 4
		invadersizeY db 2
		cannonsizeX db 3
		cannonsizeY db 2
		username db 10 DUP(0)

	;Splash Data
	    sb1 db " _______________________________________________________ ",0h
		sb2 db "/  ___________________________________________________  \",0h
		sb3 db "| /  _______   _______   _______   _______  _______   \ |",0h
		sp1 db "||  /  ___  \ |  ___  \ /  ___  \ /  ___  \ |  ____|   ||",0h
		sp2 db "||  | |   |_| | |   | | | |   | | | |   |_| | |__      ||",0h
		sp3 db "||  | |_____  | |___| | | |___| | | |       |  __|     ||",0h
		sp4 db "||  \_____  \ |  _____/ |  ___  | | |       | |        ||",0h
		sp5 db "||   _    | | | |       | |   | | | |    _  | |        ||",0h
		sp6 db "||  | |___| | | |       | |   | | | |___| | | |____    ||",0h
		sp7 db "||  \_______/ |_|       |_|   |_| \_______/ |______|   ||",0h
		sp8 db "||                                                     ||",0h
		sp9 db "||  |  |\  |  \    /    /\    | \    / \   | \   / \   ||",0h
		so1 db "||  |  | \ |   \  /    /__\   |  |  |___|  |__|  \_    ||",0h
		so2 db "||  |  |  \|    \/    /    \  |_/    \__   |  \  \__\  ||",0h
		so3 db "||                                                     ||",0h
		so4 db "| \____________________ANNIVERSARY____________________/ |",0h
		so5 db "\_______________________________________________________/",0h
		so6 db "                   Press ENTER to Start                  ",0h

	;Win Data
		win1 db " __________________________________________ ",0h
		win2 db "/  ______________________________________  \",0h
		win3 db "| /                                      \ |",0h
		win4 db "||              Level Won!                ||",0h
	    win5 db "||      Press ENTER for Next Level        ||",0h
		win6 db "| \______________________________________/ |",0h
		win7 db "\__________________________________________/",0h

	;Lose Data
		los1 db " __________________________________________ ",0h
		los2 db "/  ______________________________________  \",0h
		los3 db "| /                                      \ |",0h
		los4 db "||              Game Over!                ||",0h
	    los5 db "||         Press ENTER to EXIT            ||",0h
		los6 db "| \______________________________________/ |",0h
		los7 db "\__________________________________________/",0h
		los8 db "       High Score for ",0h
		los9 db " : ",0

		inv1 db "{**}"
		inv2 db "/\/\"

		upperexplode db "\|/",0
		midexplode db "-*-",0
		lowerexplode db "/|\",0
		erasearea db "   ",0
		spawnarea db "===",0

	;Location Data
		projectilesX db 100 DUP(0)
		projectilesY db 100 DUP(0)
		userprojX db 100 DUP(0)
		userprojY db 100 DUP(0)
		numuproj dd 0
		numinvscore db 0
		invaderlist db 45 DUP(0) ;1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
		barrlist db 10,10,10,10
		invaderhor db 45 DUP(0)
		invadervert db 13,13,13,13,13,13,13,13,13,18,18,18,18,18,18,18,18,18,23,23,23,23,23,23,23,23,23,28,28,28,28,28,28,28,28,28,33,33,33,33,33,33,33,33,33
		invaderlocsX db 1,8,16,23,30,37,44,51,58,1,8,16,23,30,37,44,51,58,1,8,16,23,30,37,44,51,58,1,8,16,23,30,37,44,51,58,1,8,16,23,30,37,44,51,58
		invaderlocsY db 5,5,5,5,5,5,5,5,5,10,10,10,10,10,10,10,10,10,15,15,15,15,15,15,15,15,15,20,20,20,20,20,20,20,20,20,25,25,25,25,25,25,25,25,25
		barrierlocsX db 5,25,45,65
		barrierlocsY db 40,40,40,40
		cannonlocX db 38
		cannonlocY db 45

	;Visualization Data
		invaderop db 0h
		cannonop db 0h
		barrierop db 0h
		clearbhp db "   ",0h

	;Logic Data
		
		unitworkproj dd 0
		invdirection db 1
		killswitch db 0
		numalive db 45
		userlives db 3
		userscore dd 0
		scorethisround dd 0
		storeloop db 0
		storetimeprojs dd 0
		storetimeproje dd 0
		storetimenow dd 0
		storetimeend dd 0
		reachedbottom db 0
		colorsc db 1111b, 1110b, 1010b, 1011b, 1100b, 1101b
		currentcol db 0b

		whitec db 1111b
		yellowc db 1110b
		greenc db 1010b
		cyanc db 1011b
		redc db 1100b
		purpc db 1101b

		
		lastalive db 60

		updtcnt dd 0
		updtoff dd 0

.code
main PROC


;initialize the game
initialize:
	Call splashscreen
	Call randomize
	Call getname
;re-start gameboard, maintaining score
GAMESTART:
	Call reinitialize
	Call clrscr
	mov eax, 0
	mov eax, 5
	Call RandomRange
	mov esi, offset colorsc
	add esi, eax
	mov eax, 0
	mov al, [esi]
	mov currentcol, al
	Call SetTextColor
	Call drawinvaders
	Call drawbarriers
	Call drawcannon

	mov eax, 0h
	Call getmseconds
	mov storetimenow, eax ;time now
	mov storetimeprojs, eax
	add eax, 100d
	mov storetimeproje, eax
	add eax, 900d
	mov storetimeend, eax


MAINLOOP:
	Call moveship
	mov esi, storetimenow
	mov edi, storetimeend
	cmp esi, edi
	JLE UPDATESLAB
	Call getmseconds
	add eax, 1000d
	sub eax, scorethisround
	mov storetimeend, eax
	Call generateproj
	Call removeinvaders
	Call updateinvaders
	Call drawinvaders
	Call updateproj
	Call updateuserproj
	Call drawbarriers
	jmp RESTOFMAIN

	UPDATESLAB:
	mov esi, storetimeprojs
	mov edi, storetimeproje
	cmp esi, edi
	JLE RESTOFMAIN
	Call getmseconds
	mov storetimeprojs, eax
	add eax, 100d
	mov storetimeproje, eax
	Call updateproj
	Call updateuserproj

	RESTOFMAIN:
	Call userprojcheck
	Call projectilecheck
	Call barrprojcheck
	Call userbarrcheck
	Call getmseconds
	mov storetimenow, eax
	mov storetimeprojs, eax

	movzx eax, killswitch
	cmp eax, 1
	je LOSECONDMET

	mov dh, 1
	mov dl, 5
	Call gotoxy
	mov edx, offset livestr
	mov eax, green+(white*16)
	Call SetTextColor
	Call Writestring
	mov eax, 0h
	mov al, userlives
	Call Writeint

	mov dh, 1
	mov dl, 60
	Call gotoxy
	mov edx, offset scorestr
	Call Writestring
	mov eax, 0h
	mov eax, userscore
	Call Writeint

	mov eax, 0
	mov al, currentcol
	Call SetTextColor

	mov eax, 0
	mov al, numinvscore
	CMP al, 45
	JE WINCONDMET

	movzx eax, userlives
	cmp eax, 0
	jle LOSECONDMET

JMP MAINLOOP

	mov dl, 1
	mov dh, 45
	;Call gotoxy
	;Call getmseconds
	;Call Writeint

WINCONDMET: 
	Call wingame
	JMP GAMESTART

LOSECONDMET:
	Call losegame

exitgame:
	mov dh, 1
	mov dl, 25
	Call gotoxy
	exit
main ENDP

getname PROC ;get name from user
	Call clrscr
	mov edx, 0
	mov dl, 14
	mov dh, 20
	Call gotoxy
	mov edx, offset askusername
	Call Writestring

	mov dl, 20
	mov dh, 21
	Call gotoxy

	mov ecx, 10
	mov edx, offset username
	Call Readstring

ret
getname ENDP

reinitialize PROC ;reinitialize all the data (except score and a couple other fields)

;reset projectile data
	mov ecx, 0
	ZEROCLEAR:
		mov eax, 0

		mov esi, offset projectilesX ; clearing projectiles
		mov edi, offset projectilesY
		add esi, ecx
		add edi, ecx

		mov [esi], al
		mov [edi], al

		mov esi, offset userprojX ; clearing user proj
		mov edi, offset userprojY
		add esi, ecx
		add edi, ecx

		mov [esi], al
		mov [edi], al

		inc ecx
		CMP ecx, 100
		JL ZEROCLEAR

	mov numuproj, 0
	mov numinvscore, 0

;Reset invaderlist
	mov esi, offset invaderlist
	mov ecx, 0
	INVADERLISTRESET:
		mov eax, 0
		mov al, 1
		mov [esi], al
		inc esi
		inc ecx
		CMP ecx, 45
		JL INVADERLISTRESET

;Reset Barrier health pools (barrlist)
	mov eax, 0
	mov al, 10
	mov esi, offset barrlist
	mov [esi], al 
	inc esi
	mov [esi], al 
	inc esi
	mov [esi], al 
	inc esi
	mov [esi], al 

;Reset relative horizontal invader positions (invaderhor)
	mov ecx, 0
	mov esi, offset invaderhor
	mov eax, 0
	INVADERHORRESET:
		mov [esi], al
		inc esi
		inc ecx
		CMP ecx, 45
		JL INVADERHORRESET

;Reset relative vertical invader positions (invadervert)
	mov ecx, 0
	mov esi, offset invadervert
	mov eax, 0
	mov eax, 13
	mov ebx, 0
	INVADERVERTRESET:
		mov [esi], al
		inc esi
		inc ecx
		inc ebx
		CMP ebx, 9
		JE NEXTINVADERVERTRESET
		JMP ENDINVADERVERTRESET

		NEXTINVADERVERTRESET:
			add eax, 5
			mov ebx, 0
			JMP ENDINVADERVERTRESET

		ENDINVADERVERTRESET:
		CMP ecx, 45
		JL INVADERVERTRESET

;Reset invaderlocsX
	mov ecx, 0
	mov esi, offset invaderlocsX
	RESETINVADERLOCSX:
		mov eax, 0
		mov al, 1
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi
		add al, 8
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi
		add al, 7
		mov [esi], al
		inc esi

		inc ecx
		CMP ecx, 5
		JL RESETINVADERLOCSX


;Reset invaderlocsY 
	mov ecx, 0
	mov esi, offset invaderlocsY
	mov eax, 0
	mov eax, 5
	mov ebx, 0
	INVADERLOCYRESET:
		mov [esi], al
		inc esi
		inc ecx
		inc ebx
		CMP ebx, 9
		JE NEXTINVADERLOCYRESET
		JMP ENDINVADERLOCYRESET

		NEXTINVADERLOCYRESET:
			add eax, 5
			mov ebx, 0
			JMP ENDINVADERLOCYRESET

		ENDINVADERLOCYRESET:
		CMP ecx, 45
		JL INVADERLOCYRESET

;Reset barrierlocsX
	mov esi, offset barrierlocsX
	mov eax, 0
	mov al, 5
	mov [esi], al
	inc esi
	add al, 20
	mov [esi], al
	inc esi
	add al, 20
	mov [esi], al
	inc esi
	add al, 20
	mov [esi], al

;Reset barrierlocsY
	mov esi, offset barrierlocsY
	mov eax, 0
	mov al, 40
	mov [esi], al
	inc esi
	mov [esi], al
	inc esi
	mov [esi], al
	inc esi
	mov [esi], al

;Reset cannon posisition
	mov cannonlocX, 38
	mov cannonlocY, 45

;Reset Logical and Vis Single Value Data
	mov invaderop, 0h
	mov cannonop, 0h
	mov barrierop, 0h
	mov unitworkproj, 0
	mov invdirection, 1
	mov killswitch, 0
	mov numalive, 45
	
	mov eax, 0
	mov al, userlives
	CMP al, 3
	JE NOINC
	inc userlives
	NOINC:

	mov scorethisround, 0
	mov storeloop, 0
	mov storetimeprojs, 0
	mov storetimeproje, 0
	mov storetimenow, 0
	mov storetimeend, 0
	mov reachedbottom, 0
	mov lastalive, 60
	mov updtcnt, 0
	mov updtoff, 0

ret
reinitialize ENDP

splashscreen PROC ; procedure to show the splashscreen
	mov ebx, 0
	mov bl, 12
	mov bh, 15
	mov edx, 0
	mov dl, bl
	mov dh, bh
	Call gotoxy

	mov eax, 0
	mov al, 1010b
	Call SetTextColor
	inc bh

	mov edx, offset sb1
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sb2
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sb3
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp1
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp2
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp3
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp4
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp5
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp6
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp7
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp8
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset sp9
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset so1
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset so2
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset so3
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	inc bh

	mov edx, offset so4
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	add bh, 5

	mov edx, offset so5
	Call Writestring
	mov dl, bl
	mov dh, bh
	Call gotoxy
	
	mov edx, offset so6
	Call Writestring

	Call Readchar

ret
splashscreen ENDP

wingame PROC ; procedure called if user wins game, will display score, prompt for next level
	mov edx, 0
	mov ebx, 0
	mov bl, 16
	mov bh, 20
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win1
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win2
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win3
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win4
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win5
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win6
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset win7
	Call Writestring

	Call Readstring
ret
wingame ENDP

losegame PROC ; procedure called if user loses game, will display score
	Call clrscr
	mov edx, 0
	mov ebx, 0
	mov bl, 16
	mov bh, 20
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los1
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los2
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los3
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los4
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los5
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los6
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los7
	Call Writestring

	inc bh
	mov dl, bl
	mov dh, bh
	Call gotoxy
	mov edx, offset los8
	Call Writestring
	mov edx, offset username
	Call Writestring
	mov edx, offset los9
	Call Writestring

	mov eax, 0
	mov eax, userscore
	Call Writeint

	Call Readstring
ret
losegame ENDP

;Update Invaders Procedure
;Updates the locations of all invaders
updateinvaders PROC
	mov ecx, 0
	UPDATELOOP:
		mov eax, 0
		mov ebx, 0
		mov edx, 0

		mov esi, offset invaderlist
		add esi, ecx
		mov al, [esi]
		CMP al, 0
		JE SKIP

		mov eax, 0

		mov esi, offset invaderhor
		mov edi, offset invadervert
		add esi, ecx
		add edi, ecx

		mov bl, [esi]
		mov bh, [edi]

		mov esi, offset invaderlocsX
		mov edi, offset invaderlocsY
		add esi, ecx
		add edi, ecx

		mov al, [esi]
		mov ah, [edi]

		mov dl, invdirection

		CMP bh, 46
		JE GAMEOVER
		CMP bl, 1
		JE DOWNRIGHT
		CMP bl, 13
		JE DOWNLEFT
		CMP dl, 0
		JE LEFT
		JMP RIGHT

		DOWNRIGHT:
			mov invdirection, 1
			add ah, 1
			mov [edi], ah
			add bh, 1
			mov edi, offset invadervert
			add edi, ecx
			mov [edi], bh
			JMP RIGHT

		DOWNLEFT:
			mov invdirection, 0
			add ah, 1
			mov [edi], ah
			mov edi, offset invadervert
			add edi, ecx
			add bh, 1
			mov [edi], bh
			JMP LEFT
			
		LEFT:
			sub al, 1
			mov [esi], al
			mov esi, offset invaderhor
			add esi, ecx
			sub bl, 1
			mov [esi], bl
			JMP SKIP

		RIGHT:
			add al, 1
			mov [esi], al
			mov esi, offset invaderhor
			add esi, ecx
			add bl, 1
			mov [esi], bl
			JMP SKIP

		SKIP:
			inc ecx
			CMP ecx, 45
			JL UPDATELOOP
			JMP EXITSTMT
		
		GAMEOVER:
			mov killswitch, 1
		EXITSTMT:
	ret
updateinvaders ENDP

;Lose Life Procedure
;Reduces number of lives by 1 and redraws the ship
;at the origin location.
loselife PROC
	sub userlives, 1
	Call removecannon
	mov eax, 0
	mov edx, 0
	
	mov dl, cannonlocX
	inc dl
	mov dh, cannonlocY
	Call gotoxy
	mov al, '*'
	Call writechar
	mov eax, 400
	Call delay
	sub dl, 1
	dec dh
	push edx
	push edx
	Call gotoxy
	mov edx, OFFSET upperexplode
	Call writestring
	pop edx
	inc dh
	push edx
	push edx
	Call gotoxy
	mov edx, OFFSET midexplode
	Call writestring
	pop edx
	inc dh
	push edx
	Call gotoxy
	mov edx, OFFSET lowerexplode
	Call writestring
	Call delay
	pop edx
	Call gotoxy
	mov edx, OFFSET erasearea
	Call writestring
	pop edx
	Call gotoxy
	mov edx, OFFSET erasearea
	Call writestring
	pop edx
	Call gotoxy
	mov edx, OFFSET erasearea
	Call writestring
	
	mov eax, 100
	mov cannonlocX, 38
	mov cannonlocY, 45
	
Spawn_Animation:

	CMP userlives, 0
	JE Final_Death
	mov dl, cannonlocX
	mov dh, cannonlocY
	inc dh
	inc dh
	push edx
	push edx
	push edx
	Call gotoxy
	mov edx, OFFSET spawnarea
	Call writestring
	Call delay
	pop edx
	dec dh
	push edx
	Call gotoxy
	mov edx, OFFSET spawnarea
	Call writestring
	Call delay
	pop edx
	dec dh
	Call gotoxy
	mov edx, OFFSET spawnarea
	Call writestring
	Call delay
	pop edx
	Call gotoxy
	mov edx, OFFSET erasearea
	Call writestring
	Call delay
	pop edx
	dec dh
	push edx
	Call gotoxy
	mov edx, OFFSET erasearea
	Call writestring
	Call delay
	pop edx
	dec dh
	Call gotoxy
	mov edx, OFFSET erasearea
	Call writestring
	Call delay
	
Final_Death:
	mov eax, 0
	Call drawcannon
	ret
loselife ENDP

barrprojcheck PROC ; check for projectile collisions with the barriers
	mov ecx, 0
	mov updtcnt, 0
	CHECKLOOP:
		CMP updtcnt, 4
		JE RTSTMT
		mov esi, offset barrlist
		add esi, updtcnt
		mov eax, 0
		mov al, [esi]
		CMP al, 0
		JE LOOPCHECK ; loop to next barrier if this one is dead

		mov esi, offset barrierlocsX
		mov edi, offset barrierlocsY
		add esi, updtcnt
		add edi, updtcnt

		mov eax, 0
		mov al, [esi]
		mov ah, [edi]
		mov ecx, 0

		INVADERLOOP:
			mov esi, offset barrlist
			add esi, updtcnt
			mov edx, 0
			mov dl, [esi]
			CMP dl, 0
			JE LOOPCHECK ; loop to next barrier if this one becomes dead

			CMP ecx, 45
			JE LOOPCHECK
			mov esi, offset projectilesX
			mov edi, offset projectilesY
			add esi, ecx
			add edi, ecx

			mov ebx, 0
			mov bl, [esi]
			mov bh, [edi]

			CMP bh, 0 ; no match if no projectile
			JE NOMATCH

			CMP bl, al
			JGE X1MATCH
			JMP NOMATCH

		X1MATCH:
			add al, 5
			CMP bl, al
			JLE Y1MATCH
			sub al, 5
			JMP NOMATCH

		Y1MATCH:
			sub al, 5
			CMP bh, ah
			JGE Y2MATCH
			JMP NOMATCH
			
		Y2MATCH:
			add ah, 2
			CMP bh, ah
			JLE MATCH
			sub ah, 2
			JMP NOMATCH

		MATCH:
			sub ah, 2 ; remove projectile
			mov edx, 0
			mov dl, bl
			mov dh, bh
			Call gotoxy
			mov edx, eax
			mov eax, 0
			mov eax, '='
			Call Writechar
			mov eax, edx
			mov ebx, 0
			mov [esi], bl
			mov [edi], bl

			mov esi, offset barrlist ; sub barrier health
			add esi, updtcnt
			mov edx, 0
			mov dl, [esi]
			sub dl, 1
			mov [esi], dl
			JMP NOMATCH

		NOMATCH:
			inc ecx
			JMP INVADERLOOP

	LOOPCHECK:
		inc updtcnt
		JMP CHECKLOOP
	RTSTMT:
	mov updtcnt, 0
ret
barrprojcheck ENDP

userbarrcheck PROC ; check for user projectile collisions with barriers
	mov ecx, 0
	mov updtcnt, 0
	CHECKLOOP:
		CMP updtcnt, 4
		JE RTSTMT
		mov esi, offset barrlist
		add esi, updtcnt
		mov eax, 0
		mov al, [esi]
		CMP al, 0
		JE LOOPCHECK ; loop to next barrier if this one is dead

		mov esi, offset barrierlocsX
		mov edi, offset barrierlocsY
		add esi, updtcnt
		add edi, updtcnt

		mov eax, 0
		mov al, [esi]
		mov ah, [edi]
		mov ecx, 0

		INVADERLOOP:
			CMP ecx, 45
			JE LOOPCHECK
			mov esi, offset userprojX
			mov edi, offset userprojY
			add esi, ecx
			add edi, ecx

			mov ebx, 0
			mov bl, [esi]
			mov bh, [edi]

			CMP bh, 0 ; no match if no projectile
			JE NOMATCH

			CMP bl, al
			JGE X1MATCH
			JMP NOMATCH

		X1MATCH:
			add al, 5
			CMP bl, al
			JLE Y1MATCH
			sub al, 5
			JMP NOMATCH

		Y1MATCH:
			sub al, 5
			CMP bh, ah
			JGE Y2MATCH
			JMP NOMATCH
			
		Y2MATCH:
			add ah, 2
			CMP bh, ah
			JLE MATCH
			sub ah, 2
			JMP NOMATCH

		MATCH:
			sub ah, 2 ; remove projectile
			mov edx, 0
			mov dl, bl
			mov dh, bh
			Call gotoxy
			mov edx, eax
			mov eax, 0
			mov eax, '='
			Call Writechar
			mov eax, edx
			mov ebx, 0
			mov [esi], bl
			mov [edi], bl

			JMP NOMATCH

		NOMATCH:
			inc ecx
			JMP INVADERLOOP

	LOOPCHECK:
		inc updtcnt
		JMP CHECKLOOP
	RTSTMT:
	mov updtcnt, 0
ret
userbarrcheck ENDP

;Projectile Check Procedure
;Checks to see if any invader projectiles have hit
;the laser cannon. If they any have, the loselife 
;procedure is called.
projectilecheck PROC
	mov esi, offset projectilesX
	mov edi, offset projectilesY
	mov ecx, 100d
	mov bh, 0

	STARTCHECK:
		CMP ecx, 0h
		JE ENDCHECK
		mov al, [esi]
		mov bl, [edi]
		push ecx		;preserve the 100 count
		mov ah, cannonlocX	;precaution to preserve the variable value
		mov ecx, 3		;loop 3 times to check the full front y axis for impact
	LOCATION_ADJUST:

		CMP al, ah
		JE XMATCH
		inc ah			;adjust y axis
		loop LOCATION_ADJUST
		JMP NOMATCH

	XMATCH:
		CMP bl, cannonlocY
		JE MATCH
		inc ah			;redundant adjust y axis if je xmatch was triggered, otherwise wouldn't
		JMP NOMATCH

	MATCH:
		mov ah, [edi]
		mov al, [esi]
		Call gotoxy
		mov al, ' '
		Call writechar
		mov [esi], bh
		mov [edi], bh
		Call loselife
		pop ecx			;restore 100 and free stack for correct eip pop on ret
		JMP ENDCHECK

	NOMATCH:
		pop ecx			;restore 100 and free stack for correct eip pop on ret
		inc esi
		inc edi
		dec ecx
		JMP STARTCHECK

	ENDCHECK:
	ret
projectilecheck ENDP

userprojcheck PROC ; check if any user projectiles have hit invaders
	mov ecx, 45
	mov updtcnt, 100d

	STARTCHECK:
		CMP updtcnt, 0
		JE ENDCHECK
		mov ecx, 45
		mov esi, offset userprojX
		mov edi, offset userprojY
		mov eax, 0
		mov eax, updtcnt
		sub eax, 1
		add esi, eax
		add edi, eax
		mov eax, 0
		mov al, [esi]
		mov ah, [edi]
		CMP ah, 0
		JE ENDINNER

		INNERLOOP:
			CMP ecx, 0
			JE ENDINNER
			mov esi, offset invaderlist
			add esi, ecx
			sub esi, 1
			mov edx, 0
			mov dl, [esi]
			CMP edx, 0
			JE NOMATCH

			mov esi, offset invaderlocsX
			mov edi, offset invaderlocsY
			add esi, ecx
			dec esi
			add edi, ecx
			dec edi
			mov ebx, 0
			mov bl, [esi]
			mov bh, [edi]
			CMP al, bl
			JGE X2MATCH

			JMP NOMATCH

	X2MATCH:
		add bl, 3
		CMP al, bl
		JLE Y1MATCH
		JMP NOMATCH

	Y1MATCH:
		sub bl, 3
		CMP ah, bh
		JGE Y2MATCH
		JMP NOMATCH

	Y2MATCH:
		add bh, 1
		CMP ah, bh
		JLE MATCH
		JMP NOMATCH

	MATCH:
		sub bh, 1
		mov invaderop, cl ; remove the invader
		sub invaderop, 1
		Call removeinvader
		mov esi, offset invaderlist
		mov eax, 0
		mov al, invaderop
		add esi, eax
		mov eax, 0
		mov [esi], al

		mov esi, offset userprojX ;remove projectile
		mov edi, offset userprojY
		mov eax, 0d
		mov eax, updtcnt
		sub eax, 1
		add esi, eax
		add edi, eax
		mov dl, [esi]
		mov dh, [edi]
		Call gotoxy
		mov eax, ' '
		Call Writechar
		mov eax, 0
		mov [esi], al
		mov [edi], al

		add userscore, 10
		add scorethisround, 10
		inc numinvscore

		dec updtcnt
		JMP STARTCHECK

	NOMATCH:
		dec ecx
		JMP INNERLOOP

	ENDINNER:
		dec updtcnt
		JMP STARTCHECK

	ENDCHECK:
	mov updtcnt, 0
	ret
userprojcheck ENDP

;Update Projectiles Procedure
;Updates the positions of all projectiles currently
;in the projectilesX and projectilesY. 
updateproj PROC
	mov ecx, 0h ; loop count
	mov eax, 0h ; clear out a for printing
	mov ecx, 100

	mov esi, offset projectilesX ; array offset
	mov edi, offset projectilesY

	mov edx, 0h ; clear out d

	UPDATEPROJ1:
		mov dl, [esi] ; clear the spot the projectile was in
		mov dh, [edi]
		CMP dl, 0h
		JE GONEXT
		mov al, ' '
		Call gotoxy
		Call Writechar

		inc dh ; go down a line to print the projectile
		CMP dh, 47
		JE RMVPROJ

		mov al, '*'
		Call gotoxy
		Call Writechar

		mov [edi], dh ; update logical position

	GONEXT:
		inc edi
		inc esi
		JMP LOOPUPD

	RMVPROJ:
		mov bl, 0h
		mov [edi], bl
		mov [esi], bl
		inc edi
		inc esi

	LOOPUPD:
			
	Loop UPDATEPROJ1
	ret
updateproj ENDP

updateuserproj PROC ; update the user's projectiles
	mov ecx, 0h ; loop count
	mov eax, 0h ; clear out a for printing
	mov ecx, 100

	mov esi, offset userprojX ; array offset
	mov edi, offset userprojY

	mov edx, 0h ; clear out d

	UPDATEPROJ1:
		mov dl, [esi] ; clear the spot the projectile was in
		mov dh, [edi]
		CMP dh, 0h
		JE GONEXT

		mov al, ' '
		Call gotoxy
		Call Writechar
		

		dec dh ; go down a line to print the projectile
		CMP dh, 1
		JE RMVPROJ

		mov al, '|'
		Call gotoxy
		Call Writechar

		mov [edi], dh ; update logical position

	GONEXT:
		inc edi
		inc esi
		JMP LOOPUPD

	RMVPROJ:
		mov ebx, 0
		mov bl, 0
		mov [edi], bl
		mov [esi], bl
		inc edi
		inc esi

	LOOPUPD:
			
	Loop UPDATEPROJ1
	ret
updateuserproj ENDP

generateuserproj PROC ; generate a projectile for the user
		mov esi, offset userprojX
		mov edi, offset userprojY
		mov edx, 0h
		mov dl, cannonlocX
		mov dh, cannonlocY
		dec dh
		inc dl
		Call gotoxy
		mov eax, 0h
		mov al, '|'
		Call Writechar
		mov ebx, 0h

		CHECKLOC:
			mov bl, [esi]
			CMP bl, 0
			JE EMPTYLOC
			JMP FILLEDLOC

		FILLEDLOC: 
			inc esi
			inc edi
			JMP CHECKLOC

		EMPTYLOC:
			mov [esi], dl
			mov [edi], dh
	ret
generateuserproj ENDP


;Generate Projectiles Procedure
;Generates two projectile based on the positions of
;two invaders chosen at random. They start at the X/Y
;location of their respective invader
generateproj PROC
	mov esi, offset invaderlocsX
	mov edi, offset invaderlocsY

	GETINVADER:
	mov eax, 0h
	mov eax, 45
	Call RandomRange
	mov ebx, offset invaderlist
	add ebx, eax
	mov cl, [ebx]
	CMP cl, 0
	JE GETINVADER

	mov unitworkproj, eax

	add esi, eax
	add edi, eax

	mov ebx, 0h
	mov eax, 0h
	mov al, [esi]
	mov ebx, 0h
	mov bl, [edi]


	mov esi, offset projectilesX
	mov edi, offset projectilesY

	CHECKEMPTY:
		mov ah, [esi]
		mov bh, [edi]
		CMP ah, 0h
		JE EMPTY
		inc esi
		inc edi
		JMP CHECKEMPTY
	
	EMPTY:

		mov [esi], al
		mov [edi], bl

		mov edx, 0h
		mov dl, [esi]
		mov dh, [edi]

		Call gotoxy
		mov al, '*'
		Call Writechar

	toomany:
	ret
generateproj ENDP

moveship PROC ; checks for user input, move ship, exit game, pause, shoot
	mov eax, 50
	Call delay
	Call readkey
	JZ moveshipend
	cmp al, 97
	JE moveshipa
	cmp al, 100
	JE moveshipd
	cmp al, 32
	JE shoot
	cmp al, 112
	JE pausegame
	cmp al, 27
	JE moveshipexit
	JMP moveshipend

	shoot:
		Call generateuserproj
		JMP moveshipend

	moveshipa:
		mov eax, 0h
		mov al, cannonlocX
		sub al, 1
		cmp al, 0
		JLE moveshipend
		Call removecannon
		sub cannonlocX, 1
		Call drawcannon
		JMP moveshipend

	moveshipd:
		mov eax, 0h
		mov al, cannonlocX
		add al, 3
		cmp al, framesizeX
		JGE moveshipend
		Call removecannon
		inc cannonlocX
		Call drawcannon
		JMP moveshipend

	pausegame:
		mov eax, 0
		Call Readchar
		CMP al, 112
		JNE pausegame
		JMP moveshipend

	moveshipexit:
		add killswitch, 1

	moveshipend:
	ret
moveship ENDP

drawinvaders PROC ; draw invaders at appropriate locations
	mov ecx, 0h
	mov ecx, 45d
	mov invaderop, cl
	sub invaderop,1
	INITINV:
		mov esi, 0
		mov esi, offset invaderlist
		mov eax, 0
		mov al, invaderop
		add esi, eax
		mov eax, 0
		mov al, [esi]
		cmp eax, 0
		JE initinv1 ; if that invader is dead, don't draw it
		mov storeloop, cl
		Call drawinvader
		mov cl, storeloop
		initinv1:
		sub invaderop, 1
	Loop INITINV
	ret
drawinvaders ENDP

drawinvader PROC ; draw single invader using invaderop as an index
	mov eax, 0h
	mov al, invaderop
	mov esi, offset invaderlocsX
	mov edi, offset invaderlocsY
	mov edx, 0h
	
	;add correct invaderop number
	add edi, eax
	add esi, eax

	;go to correct spot to draw
	mov dl, [esi]
	mov dh, [edi]
	Call gotoxy

	mov eax, 0h
	mov al, '{'
	Call Writechar

	inc dl
	Call gotoxy
	mov al, '*'
	Call Writechar

	inc dl
	Call gotoxy
	mov al, '*'
	Call Writechar

	inc dl
	Call gotoxy
	mov al, '}'
	Call Writechar

	sub dl, 3
	inc dh
	Call gotoxy
	mov al, '/'
	Call Writechar

	inc dl
	Call gotoxy
	mov al, 'Y'
	Call Writechar

	inc dl
	Call gotoxy
	mov al, 'Y'
	Call Writechar

	inc dl
	Call gotoxy
	mov al, '\'
	Call Writechar
	ret
drawinvader ENDP

removeinvaders PROC ; removes all invaders
	mov ecx, 0h
	mov ecx, 45d
	mov invaderop, cl
	sub invaderop,1
	INITINV:
		mov esi, 0h
		mov esi, offset invaderlist
		movzx eax, invaderop
		add esi, eax
		mov eax, 0h
		mov al, [esi]
		cmp eax, 0
		JE initinv1 ; if that invader is dead, don't draw it
		mov storeloop, cl
		Call removeinvader
		mov cl, storeloop
		initinv1:
		sub invaderop, 1
	Loop INITINV
	ret
removeinvaders ENDP

removeinvader PROC ; remove invader at invaderop index
	mov eax, 0h
	mov al, invaderop
	mov edi, offset invaderlocsX
	mov esi, offset invaderlocsY
	mov edx, 0h
	
	;add correct invaderop number
	add edi, eax
	add esi, eax

	;go to correct spot to draw
	mov dl, [edi]
	mov dh, [esi]
	Call gotoxy

	mov eax, 0h
	mov al, ' '
	Call Writechar

	inc dl
	Call gotoxy
	mov al, ' '
	Call Writechar

	inc dl
	Call gotoxy
	mov al, ' '
	Call Writechar

	inc dl
	Call gotoxy
	mov al, ' '
	Call Writechar

	sub dl, 3
	inc dh
	Call gotoxy
	mov al, ' '
	Call Writechar

	inc dl
	Call gotoxy
	mov al, ' '
	Call Writechar

	inc dl
	Call gotoxy
	mov al, ' '
	Call Writechar

	inc dl
	Call gotoxy
	mov al, ' '
	Call Writechar
	ret
removeinvader ENDP

drawcannon PROC ; draw cannon at correct position
	mov eax, 0h
	mov al, cannonop
	mov edi, offset cannonlocX
	mov esi, offset cannonlocY
	mov edx, 0h

	;add correct cannonop number
	add edi, eax
	add esi, eax

	;go to correct spot to draw
	mov dl, [edi]
	mov dh, [esi]

	;Draw
	mov eax, 0h
	mov al, '<'
	inc dh
	Call gotoxy
	Call Writechar

	mov al, 'W'
	inc dl
	Call gotoxy
	Call Writechar

	mov al, '>'
	inc dl
	Call gotoxy
	Call Writechar

	dec dh
	sub dl, 1
	mov al, 'A'
	Call gotoxy
	Call Writechar
	ret
drawcannon ENDP

removecannon PROC ; remove cannon from screen
	mov eax, 0h
	mov al, cannonop
	mov edi, offset cannonlocX
	mov esi, offset cannonlocY
	mov edx, 0h

	;add correct cannonop number
	add edi, eax
	add esi, eax

	;go to correct spot to draw
	mov dl, [edi]
	mov dh, [esi]

	;Draw
	mov eax, 0h
	mov al, ' '
	inc dh
	Call gotoxy
	Call Writechar

	mov al, ' '
	inc dl
	Call gotoxy
	Call Writechar

	mov al, ' '
	inc dl
	Call gotoxy
	Call Writechar

	dec dh
	sub dl, 1
	mov al, ' '
	Call gotoxy
	Call Writechar
	ret
removecannon ENDP

drawbarriers PROC ; draw all barriers that are alive
	mov ecx, 4d
	mov barrierop, cl
	sub barrierop, 1
	INITBARR:
		mov esi, 0h
		mov esi, offset barrlist
		movzx eax, barrierop
		add esi, eax
		mov eax, 0h
		mov al, [esi]
		cmp eax, 0
		JE rmvbarr1 ; if that barrier is destroyed, clear it
		mov storeloop, cl
		Call drawbarrier
		mov cl, storeloop
		JMP initbarr1

		rmvbarr1:
		mov storeloop, cl
		Call removebarrier
		mov cl, storeloop

		initbarr1:
		sub barrierop, 1
	Loop INITBARR
	ret
drawbarriers ENDP

removebarrier PROC ; remove single barrier at barrierop index
	mov eax, 0h
	mov al, barrierop
	mov edi, offset barrierlocsX
	mov esi, offset barrierlocsY
	mov edx, 0h

	;add correct barrierop number
	add edi, eax
	add esi, eax

	;go to correct spot to draw
	mov dl, [edi]
	mov dh, [esi]
	Call gotoxy

	mov eax, 0h
	mov al, ' '
	mov ecx, 0h
	mov cl, 6d
	TOPBARR:
		Call Writechar
		inc dl
		Call gotoxy

	Loop TOPBARR

	sub dl, 6
	inc dh
	mov cl, 6d
	Call gotoxy
	MIDBARR:
		Call Writechar
		inc dl
		Call gotoxy

	Loop MIDBARR

	sub dl, 6
	inc dh
	mov cl, 2d
	Call gotoxy
	BOTBARR:
		Call Writechar
		add dl, 5
		Call gotoxy

	Loop BOTBARR

	sub dl, 9
	mov cl, 4d
	mov al, ' '
	Call gotoxy
	SPACELP:
		Call Writechar
		inc dl
		Call gotoxy

	Loop SPACELP

	ret
removebarrier ENDP

drawbarrier PROC ; draw single barrier at barrierop index
	mov eax, 0h
	mov al, barrierop
	mov edi, offset barrierlocsX
	mov esi, offset barrierlocsY
	mov edx, 0h

	;add correct barrierop number
	add edi, eax
	add esi, eax

	;go to correct spot to draw
	mov dl, [edi]
	mov dh, [esi]
	Call gotoxy

	mov eax, 0h
	mov al, '='
	mov ecx, 0h
	mov cl, 6d
	TOPBARR:
		Call Writechar
		inc dl
		Call gotoxy

	Loop TOPBARR

	sub dl, 6
	inc dh
	mov cl, 6d
	Call gotoxy
	MIDBARR:
		Call Writechar
		inc dl
		Call gotoxy

	Loop MIDBARR

	sub dl, 6
	inc dh
	mov cl, 2d
	Call gotoxy
	BOTBARR:
		Call Writechar
		add dl, 5
		Call gotoxy

	Loop BOTBARR

	sub dl, 9
	mov cl, 4d
	mov al, ' '
	Call gotoxy
	SPACELP:
		Call Writechar
		inc dl
		Call gotoxy
	Loop SPACELP

	sub dl, 4
	mov esi, offset barrlist
	mov eax, 0
	mov al, barrierop
	add esi, eax
	Call gotoxy
	mov eax, 0
	mov al, [esi]
	Call Writeint

ret
drawbarrier ENDP

END main