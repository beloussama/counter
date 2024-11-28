ORG 00H
MOV P1,#11111111B   // initializes P1 as input port
MOV P0,#00000000B   // initializes P0 as output port
MOV P3,#00000000B   // initializes P3 as output port
MOV DPTR,#LABEL     // loads the address of "LABEL" to DPTR
MAIN: MOV R4,#250D  // loads register R4 with 250D
      CLR P3.7      // makes Cs=0
      SETB P3.6     // makes RD high
      CLR P3.5      // makes WR low
      SETB P3.5     // low to high pulse to WR for starting conversion
WAIT: JB P3.4,WAIT  // polls until INTR=0
      CLR P3.7      // ensures CS=0
      CLR P3.6      // high to low pulse to RD for reading the data from ADC
      MOV A,P1      // moves the digital output of ADC to accumulator A
      MOV B,#10D    // load B with 10D
      DIV AB        // divides the content of A with that in B
      MOV R6,A      // moves the quotient to R6
      MOV R7,B      // moves the remainder to R7
DLOOP:SETB P3.2     // sets P3.2 which activates LED segment 1
      MOV A,R6      // moves the quotient to A
      ACALL DISPLAY // calls DISPLAY subroutine
      MOV P0,A      // moves the content of A to P0
      ACALL DELAY   // calls the DELAY subroutine
      CLR A         // clears A
      MOV A,R7      // moves the remainder to A
      CLR P3.2      // deactivates LED segment 1
      SETB P3.1     // activates LED segment 2
      ACALL DISPLAY
      MOV P0,A
      ACALL DELAY
      CLR A
      CLR P3.1      // deactivates LED segment 2
      DJNZ R4,DLOOP // repeats the loop "DLOOP" until R4=0
      SJMP MAIN     // jumps back to the main loop
DELAY: MOV R3,#255D // produces around 0.8mS delay
LABEL1: DJNZ R3,LABEL1
        RET
DISPLAY: MOVC A,@A+DPTR // converts A's content to corresponding digit drive pattern
         RET
LABEL: DB 3FH       // LUT (look up table) starts here
       DB 06H
       DB 5BH
       DB 4FH
       DB 66H
       DB 6DH
       DB 7DH
       DB 07H
       DB 7FH
       DB 6FH
END 