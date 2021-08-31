.data

VIDEO:		.string "video.bin"
JAP:		.string "jap.bin"
PT:		.string "pt.bin"

.text
		li a7, 1024		# open
		la a0, VIDEO		# open VIDEO
		li a1, 0
		ecall
		mv s0,a0		# s0 = video (file descriptor)
	
		la a0, JAP		# open JAP subtitles
		ecall
		mv s1,a0		# s1 = jap (file descriptor)
	
		la a0, PT		# open PT subtitles
		ecall
		mv s2,a0		# s2 = pt (file descriptor)

		li s3,1			# s3 = subtitle mode (0 = sem, 1 = jap, 2 = pt)
		li s4,0			# s4 = sub frame number

LOOP:		li a7,63		# read
		mv a0,s0		# video file descriptor
		li a1,0xFF000000	# frame 0 address
		li a2,76800		# 320 * 240
		ecall
		
		call SUB_INPUT
		beq s3,zero,LOOP_CONT	# if s3 == 0 continue ELSE check for sub

		li t0,1
		bne s3,t0,NOJAP		# if s3 != 1 continue ELSE print jap subtitles
	
		li a7,62		# seek
		mv a0,s1		# jap subtitles file descriptor
		mv a1,s4		# offset pra saber em qual frame ta
		li a2,0
		ecall

		li a7,63		# read
		mv a0,s1		# jap subtitles file descriptor
		li a1,0xFF00E380	# offset de 182 linhas pra baixo
		li a2,18560		# imprimir sï¿½ 58 linhas (58 * 320)
		ecall
		
		j LOOP

NOJAP:		li t0,2
		bne s3,t0,LOOP_CONT	# if s3 != 2 continue ELSE print pt subtitles
	
		li a7,62		# seek
		mv a0,s2		# pt subtitles file descriptor
		mv a1,s4
		li a2,0
		ecall
		
		li a7,63		# read
		mv a0,s2		# pt subtitles file descriptor
		li a1,0xFF00E380	# offset de 182 linhas pra baixo
		li a2,18560		# imprimir so 58 linhas (58 * 320)
		ecall

LOOP_CONT:	blez a0,END		# EOF

		li a7,32		# sleep
		li a0,20		# 32ms per frame
		ecall
	
		li t0,18560
		add s4,s4,t0		# frame number += 18560
		
		j LOOP			# repeat loop

END:		li a7,57		# close
		mv a0,s0		# close s0 (VIDEO file descriptor)
		ecall

		mv a0,s1		# close s1 (JAP file descriptor)
		ecall
	
		mv a0,s2		# close s2 (PT file descriptor)
		ecall
	
		li a7,10
		ecall

SUB_INPUT:	li t1,0xFF200000	# endereço onde diz se tem input do teclado
		lw t0,0(t1)		
		andi t0,t0,0x0001	
  	 	beq t0,zero,SUB_RETURN	# se nao tiver input, retorna
  		lw t0,4(t1)		# caso contrario, pega o valor que ta no buffer
  		
  		# compara pra saber qual input foi
  		li t1,'s'
  		beq t0,t1,SUB_REM
  		li t1,'j'
 		beq t0,t1,SUB_JAP
 		li t1,'p'
 		beq t0,t1,SUB_PT
 
SUB_RETURN:	ret

SUB_REM:	mv s3,zero
		ret

SUB_JAP:	li s3,1
		ret

SUB_PT:		li s3,2
		ret

