ORG 0000H

MOV P3, #00H  ; Initialiser P3 (afficheur dizaines, cathode commune)
MOV P2, #00H  ; Initialiser P2 (afficheur unités, cathode commune)
MOV P0, #0FFH ; Initialiser P0 (configurer P0.0 comme entrée)
MOV A, #00H   ; Initialiser l'accumulateur A
MOV R0, #00H  ; Initialiser le registre R0 pour les unités
MOV R1, #00H  ; Initialiser le registre R1 pour les dizaines

MAIN_LOOP:
    JNB P0.0, MAIN_LOOP  ; Si P0.0 est haute, reboucler

INCREMENT:
    INC R0               ; Incrémenter les unités
    MOV A, R0            ; Charger la valeur des unités dans A
    CJNE A, #0AH, CONTINUE_INCREMENT ; Si A est différent de 10, continuer
    MOV R0, #00H         ; Sinon, réinitialiser les unités à 0
    INC R1               ; Incrémenter les dizaines
    CJNE R1, #0AH, CONTINUE_INCREMENT ; Si R1 est différent de 10, continuer
    MOV R1, #00H         ; Sinon, réinitialiser les dizaines à 0
CONTINUE_INCREMENT:
    ACALL AFFICHER       ; Appeler la sous-routine d'affichage
    AJMP WAIT_RELEASE    ; Aller à la boucle d'attente de relâchement

WAIT_RELEASE:
    JB P0.0, WAIT_RELEASE ; Attendre que P0.0 soit relâché
    SJMP MAIN_LOOP       ; Reboucler au début

AFFICHER:
    ; Afficher les unités
    MOV A, R0            ; Charger la valeur des unités dans A
    ACALL SEGMENT_CODES  ; Récupérer le code 7 segments des unités
    MOV P2, A            ; Déplacer le code 7 segments des unités vers P2

    ; Afficher les dizaines
    MOV A, R1            ; Charger la valeur des dizaines dans A
    ACALL SEGMENT_CODES  ; Récupérer le code 7 segments des dizaines
    MOV P3, A            ; Déplacer le code 7 segments des dizaines vers P3

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