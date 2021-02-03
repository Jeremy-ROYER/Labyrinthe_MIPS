	#main
	.data
	
# /!\ /!\ /!\ Vous devez indiquer le chemin /!\ ABSOLU /!\ du répertoire du projet avant le nom du fichier /!\ /!\ /!\

# Ex : "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_dif1.txt"

fich1: .asciiz "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_dif1.txt"
fich2: .asciiz "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_dif2.txt"
fich3: .asciiz "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_dif3.txt"
fich4: .asciiz "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_dif4.txt"
fich5: .asciiz "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_dif5.txt"
fich0: .asciiz "/home/polytech/Archi/Projet/Labyrinthe_MIPS/laby_courant.txt"

buffer: .space 900
buffer2: .space 900
espace: .space 900

messDebut: .asciiz "Bienvenue dans\n\n-------------------------------------------------------------------------- \n  ||      ||||  |||||| ||  || |||||| |||||| |||  || |||||| ||  || ||||||   \n  ||     ||  || ||  ||  ||||  ||  ||   ||   |||| ||   ||   ||  || ||       \n  ||     |||||| |||||    ||   ||||||   ||   || | ||   ||   |||||| ||||     \n  ||     ||  || ||  ||  ||    || ||    ||   || ||||   ||   ||  || ||       \n  |||||| ||  || |||||| ||     ||  || |||||| ||  |||   ||   ||  || ||||||   \n-------------------------------------------------------------------------- \n\n"
messRegle: .asciiz "Les règles sont simples, vous devez sortir du labyrinthe.\nPour se déplacer utiliser les touches Z S Q D pour respectivement Haut Bas Gauche Droite (comme beaucoup de jeu)\nLa sortie du labyrinthe se trouve au point A \n\n"
mess: .asciiz "Entrer le niveau souhaité (1 à 5) \n"
mess1: .asciiz "\nVous êtes arrivé !\n"
mess2: .asciiz "\nMouvement interdit\n"
mess3: .asciiz "\nMouvement souhaité :\n"
mess4: .asciiz "\nTouche interdite\n"
mess5: .asciiz "\n Fichier inexistant !\n"


	.text

main:
#allocation du bloc de pile de la fonction main()	
 addiu $sp,$sp,-64
 addiu $fp,$fp, 64
 
#affichage des messages pour l'utilisateur
	la $a0,messDebut
	ori $v0,$zero,4
	syscall
	
	la $a0,messRegle
	ori $v0,$zero,4
	syscall
	
	la $a0,mess
	ori $v0,$zero,4
	syscall
	
	ori $v0,$zero,5
	syscall
	sw $v0,0($sp)		#sauvegarde de $v0
	jal case_ouv		#appel de la fonction case_ouv
	lw $v0,0($sp)
	
	sw $s2,0($sp)		#sauvegarde de $s2
	sw $s4,4($sp)		#sauvegarde de $s4
	sw $v0,8($sp)		#sauvegarde de $v0
	sw $s0,12($sp)		#sauvegarde de $s0
	sw $s3,16($sp)		#sauvegarde de $s3
	jal deplacement		#appel de la fonction deplacement
	lw $s2,0($sp)		#restitution de $s2
	lw $s4,4($sp) 		#restitution de $s4
	lw $v0,8($sp)		#restitution de $v0
	lw $s0,12($sp)		#restitution de $s0
	lw $s3,16($sp)		#restitution de $s3
	
exit:	ori $v0,$zero,10	#Fin 
	syscall
	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	

#fonction permettant d'ouvrir le fichier demandé par l'utilisateur	
case_ouv:	
# entrée :$v0 contient le niveau choisi
# sortie : $a0 contient le fichier à afficher

	addiu $sp, $sp, -8 	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp
	
	j case_1

case_1: addi $t2, $zero,1 	# case_1: fixe $t2 à 1
            beq $v0, $t2, C1	# si $t6 et $t2 sont égaux alors on jump à C1
		 j case_2
		 
case_2: addi $t2, $zero,2  	# case_1: fixe $t2 à 2
            beq $v0, $t2, C2 	# si $t6 et $t2 sont égaux alors on jump à C2
		 j case_3
		 
case_3: addi $t2, $zero,3  	# case_1: fixe $t2 à 3
            beq $v0, $t2, C3 	# si $t6 et $t2 sont égaux alors on jump à C3
		 j case_4
		 
case_4: addi $t2, $zero,4  	# case_1: fixe $t2 à 4
            beq $v0, $t2, C4	# si $t6 et $t2 sont égaux alors on jump à C4
		 j case_5
		 
case_5: addi $t2, $zero,5  	# case_1: fixe $t2 à 5
            beq $v0, $t2, C5 	# si $t6 et $t2 sont égaux alors on jump à C5
            bne $v0,$t2,Default
		 j end

C1: la $t3,fich1 		#stockage de l'adresse du fichier dans $t3
	j end

C2: la $t3,fich2 		#stockage de l'adresse du fichier dans $t3
	j end

C3: la $t3,fich3 		#stockage de l'adresse du fichier dans $t3
	j end

C4: la $t3,fich4 		#stockage de l'adresse du fichier dans $t3
	j end

C5: la $t3,fich5 		#stockage de l'adresse du fichier dans $t3
	j end

Default: la $a0,mess5
	ori $v0,$zero,4
	syscall
	j main

end: add $s0,$t3,$zero
	

	li  $a1, 0  		#ouverture du fichier en mode lecture   
	add $a0,$zero,$s0 
	jal ouvertureFichier
	jal lectureFichier

	jal affichageFichier
	la $a0,buffer
	jal fermeture
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	
 
ouvertureFichier:

#entrée : $s0 contient l'adresse du fichier
#sortie: $s1 contient descripteur fichier

	addiu $sp, $sp, -8 	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp


			#corps de la fonction	
	li   $v0, 13      
	li   $a2, 0
	syscall            
	move $s1,$v0  		#$s1 contient le descripteur de fichier    
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra

 #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	
  
#lecture du fichier
lectureFichier:
	
	addiu $sp, $sp, -8 	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp
	
	li   $v0, 14  		#$v0 contient le nombre d'octet lu
	move $a0, $s1    
	la   $a1, buffer
	li   $a2, 900   
	syscall   
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra         

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	

affichageFichier:
	addiu $sp, $sp, -8 	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp
	
			#affichage du buffer
	li $v0,4
	la $a0,buffer
	syscall
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	

fermeture:
	addiu $sp, $sp, -8 	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp

		#corps de la fonction
	ori $v0,$zero,16
	syscall
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	

deplacement:
#s0 contient fichier à afficher 

	addiu $sp, $sp, -8	# PRO : ajustement de $sp	
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $sp, $sp, 8	# PRO : ajustement de $sp	

	la $s2,buffer		#adresse du fichier sauvegardé est sauvegardé dans $s2
	ori $t0,$zero,'D'  	#$t0 contient code ASCII de D
  	ori $t1,$zero,'A'	#$t1 contient code ASCII de A
  	ori $t2,$zero,'#'	#$t2 contient code ASCII de #
  	ori $t4,$zero,'J'	#$t4 contient code ASCII de J
  	li $t5,0		#initialisation de i à 0
	j initialisation
	
	
initialisation:
	addu $t3,$s2,$t5	# $t3 contient adresse + constante => $t3 == tableau [i]
	lb $t7,0($t3) 		# $t7 contient la valeur du caractère examiné
	beq $t7,$t0,depart 	# si $t7 == $t0 alors nous sommes arrivés à la case départ 
	addu $t5,$t5,1 		# sinon on incrémente
	j initialisation
	
		
depart:
	sb $t4,0($t3)		#on décharge la valeur de $t4 (J) dans la case que l'on visite 
	move $s4,$s2		
	jal ecrireFichier	#appel de la fonction ecrireFichier
	j mouvement			#on saute à l'étiquette "mouvement"
		
mouvement:
	addu $t3,$s2,$t5	#on se place au départ donc on cherche l'adresse où se trouve "J" 
	lb $t7,0($t3)		#chargement de la valeur contenu dans la case visitée dans $t7
	beq $t7,$t4,continue	#si la case visitée contient un "J" alors on saute à continue
	beq $t7,$t1,recommence	#si $t3 == "A" alors on a visité toute les cases sans trouver "J" donc on recommence 
	add $t5,$t5,1 		#sinon on incrémente i
	j mouvement			#ou sinon on répète la boucle
	
recommence:
	li $t5,0		#on réinitialise $t5 pour recommencer la boucle
	la $s2,buffer		#on réinitialise $s2 pour recommencer la boucle
	j mouvement
	
continue:
	jal case_dep		#appel de la fonction case_dep
  	ori $t2,$zero,'#'
  	ori $t1,$zero,'A'
	addu $t9,$t3,$s3	#$t9 prend la valeur de l'adresse de la case où le joueur se situe + le décalage induit par le choix du déplacement
	lb $t8,0($t9)		#on charge la valeur contenu à l'adresse $t0 dans $t8
	beq $t8,$t1,arrivee	#si $t8 == "A" alors on a finit le labyrinthe
	beq $t8,$t2,obstacle	#si $t8 == "#" alors on opère pas le déplacement du joueur
	bne $t8,$t2,dep 	#si $t8 != "#" alors on opère le déplacement du joueur 
	j mouvement

dep:	
	li $t0,' '
	sb $t4,0($t9)		#notre nouvel position prend la lettre 'J'
	sb $t0,0($t3)		#notre ancienne position prend le caractères ' '
	move $s4,$s2
	jal ecrireFichier
	j mouvement

arrivee:
	sb $t0,0($t3)		#notre ancienne position prend le caractères ' '	
	move $s4,$s2
	ori $v0,$zero,4		#affichage de mess1
	la $a0,mess1
	syscall
	la $a0,($s4)	
	jal ecrireFichier
	j exit
	

obstacle:
	ori $v0,$zero,4		#affichage de mess2
	la $a0,mess2
	syscall
	move $t9,$t3		#on reste à la position que l'on avait avant avant l'obstacle rencontré ('#')
	j dep_obstacle
	
dep_obstacle:
	sb $t4,0($t9)		#on charge la lettre 
	move $s4,$s2
	jal ecrireFichier	#on ecris dans le nouveau buffer 
	j mouvement
			
	
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra

	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#			
			
case_dep:

	addiu $sp, $sp, -8	# PRO : ajustement de $sp	
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp)
	addiu $fp, $sp, 8	# maj/ajustement de $fp
	
	
	li $s3,0 		#initialisation de $s3
	ori $v0,$zero,4		#affichage de mess3
	la $a0,mess3
	syscall
	
	ori $v0,$zero,12	#entrer la lettre correspondant au déplacement voulu; le caractère entré est stocké dans $v0
	syscall	
	
	
		j case_z

	
case_z:
	li $t2,'z'  		# case_z: fixe $t2 au code ASCII z
            beq $v0,$t2, Cz 	# si $t6 et $t2 sont égaux alors on jump à Cz
		 j case_Z
case_Z:
	li $t2,'Z'  		# case_Z: fixe $t2 au code ASCII Z
            beq $v0,$t2, Cz 	# si $t6 et $t2 sont égaux alors on jump à Cz
		 j case_s

case_s: 
	li $t2,'s'  		# case_s: fixe $t2 au code ASCII s
            beq $v0, $t2, Cs 	# si $t6 et $t2 sont égaux alors on jump à Cs
		 j case_S
case_S: 
	li $t2,'S'  		# case_S: fixe $t2 au code ASCII S
            beq $v0, $t2, Cs 	# si $t6 et $t2 sont égaux alors on jump à Cs
		 j case_d


case_d:
	li $t2,'d'  		# case_d: fixe $t2 au code ASCII d
            beq $v0, $t2, Cd 	# si $t6 et $t2 sont égaux alors on jump à Cd

		 j case_D
case_D:
	li $t2,'D' 
  		# case_d: fixe $t2 au code ASCII D
            beq $v0, $t2, Cd 	# si $t6 et $t2 sont égaux alors on jump à Cd

		 j case_q

case_q:
	li $t2,'q'  		# case_q: fixe $t2 au code ASCII q

            beq $v0, $t2, Cq 	# si $t6 et $t2 sont égaux alors on jump à Cq
		 j case_Q
		 
case_Q:
	li $t2,'Q'  		# case_q: fixe $t2 au code ASCII Q

            beq $v0, $t2, Cq 	# si $t6 et $t2 sont égaux alors on jump à Cq 
		 j case_e
		 
case_e: li $t2,'e'		# case_e: fixe $t2 au code ASCII e
	beq $v0,$t2,Ce
		j case_E

case_E: li $t2,'E'		# case_e: fixe $t2 au code ASCII e
	bne $v0,$t2,default
	beq $v0,$t2,Ce
		j end2
	

Cz: addi $t2,$zero,-42		#$s3 prend la valeur -42 et donc notre joueur "monte"
	j end2

Cs: addi $t2,$zero,42		#$s3 prend la valeur 42 et donc notre joueur "descend"
	j end2
	
Cd: addi $t2,$zero,1		#$s3 prend la valeur 1 et donc déplacement du joueur "à droite"
	j end2

Cq: addi $t2,$zero,-1		#$s3 prend la valeur -1 et donc déplacement du joueur " à gauche"
	j end2

Ce: j save_exit 			# si on entre la lettre 'e' alors le programme se termine

default:
	ori $v0,$zero,4		#affichage de mess4 si la touche appuyée ne correspond pas à une touche permise 
	la $a0,mess4
	syscall
	j obstacle


end2: addu $s3,$t2,$zero


	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp) 		# restitution de $fp
	addiu $sp, $sp,8
	jr $ra

	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	

ecrireFichier:
	addiu $sp, $sp, -8	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp

	la $a0,fich0
	li $a1,1		#$a1= 1 :ouverture du fichier en mode écriture
	jal ouvertureFichier
	
#écriture
	li $v0,15	
	la $a0,buffer		#$a0 contient le descripteur de fichier 	
	la $a1,buffer2		#$a1 contient l'adresse du buffer
	li $a2,900   		#$a2 contient le nombre maximal de lettre écrite
	syscall
	
	la $a0,($s4)
	jal affichageFichier
	la $a0,($s4)
	jal fermeture		#appel de la fonction fermeture
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp)  		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	
save_exit:
	addiu $sp, $sp, -8	# PRO : ajustement de $sp
	sw $ra, 0($sp) 		# sauv. de $ra
	sw $fp, 4($sp) 		# sauv. de $fp
	addiu $fp, $sp, 8 	# maj/ajustement de $fp

	li $v0,13
	la $a0,fich0
	li $a1,1		#$a1= 1 :ouverture du fichier en mode écriture
	li $a2,0
	syscall
	move $s1,$v0

#écriture
	li $v0,15	
	move $a0,$s1	
	la $a1,buffer		#$a1 contient l'adresse du buffer
	li $a2,900   		#$a2 contient le nombre maximal de lettre écrite
	syscall
	
	li $v0,16
	move $a0,$s1	
	syscall
	j exit
	
	lw $ra, 0($sp) 		# EPI : restitution de $ra
	lw $fp, 4($sp)  		# restitution de $fp
	addiu $sp, $sp, 8
	jr $ra
		



 
