ORG 0000H

MOV P3, #3FH  ; Initialiser P3 (afficheur unit�s, cathode commune)
MOV P2, #3FH  ; Initialiser P2 (afficheur dizaines, cathode commune)
MOV P0, #0FFH ; Initialiser P1 (configurer P1.0 comme entr�e)
MOV A, #00H  ; Initialiser l'accumulateur A
MOV R1, #00H ; Initialiser le registre R1 pour les dizaines

MAIN_LOOP:
    JNB P0.0, MAIN_LOOP  ; Si P1.0 est haute, reboucler

INCREMENT:
    INC R1               ; Incr�menter les dizaines
    MOV A, R1            ; D�placer R1 dans A
	MOV B, A             ; Sauvegarder la valeur de A dans B
    ANL A, #0FH          ; Masquer les bits sup�rieurs de A
    CJNE A, #0AH, CHECK_UNITS ; V�rifier si les unit�s d�passent 9
	MOV A,B
    ADDC A, #06H   	; Ajouter 6 pour passer au nombre d�cimal suivant
	MOV R1,A
	MOV B,A
	SJMP CHECK_UNITS 
CHECK_UNITS:
    ACALL AFFICHER       ; Appeler la sous-routine d'affichage
    AJMP WAIT_RELEASE    ; Aller � la boucle d'attente de rel�chement

WAIT_RELEASE:
    JB P0.0, WAIT_RELEASE ; Attendre que P1.0 soit rel�ch�
    SJMP MAIN_LOOP       ; Reboucler au d�but

AFFICHER:
    MOV A,B
	ANL A, #0FH          ; Masquer les bits sup�rieurs de A
    ACALL SEGMENT_CODES  ; R�cup�rer le code 7 segments des unit�s
    MOV P2, A            ; D�placer le code 7 segments des unit�s vers P2

    MOV A, B             ; Charger la valeur originale de A
    SWAP A               ; �changer les nibbles de A pour obtenir les dizaines
    ANL A, #0FH          ; Masquer les bits sup�rieurs de A pour les dizaines
    ACALL SEGMENT_CODES  ; R�cup�rer le code 7 segments des dizaines
    MOV P3, A            ; D�placer le code 7 segments des dizaines vers P3

    RET                  ; Retourner de la sous-routine

SEGMENT_CODES:
    CJNE A, #00, CODE_1
    MOV A, #3FH
    RET

CODE_1:
    CJNE A, #01, CODE_2
    MOV A, #06H
    RET

CODE_2:
    CJNE A, #02, CODE_3
    MOV A, #5BH
    RET

CODE_3:
    CJNE A, #03, CODE_4
    MOV A, #4FH
    RET

CODE_4:
    CJNE A, #04, CODE_5
    MOV A, #66H
    RET

CODE_5:
    CJNE A, #05, CODE_6
    MOV A, #6DH
    RET

CODE_6:
    CJNE A, #06, CODE_7
    MOV A, #7DH
    RET

CODE_7:
    CJNE A, #07, CODE_8
    MOV A, #07H
    RET

CODE_8:
    CJNE A, #08, CODE_9
    MOV A, #7FH
    RET

CODE_9:
    CJNE A, #09, END_CODES
    MOV A, #6FH
    RET

END_CODES:
    RET

END