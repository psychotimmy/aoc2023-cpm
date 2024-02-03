       INTEGER JDX, FDX, SPOS, EPOS, ANSS, ANSE, LLEN
       STRING CH$, BUF$, RBUF$, FWD$, BCK$
       REAL TOTAL

       DIM FWD$(18), BCK$(18)

       PRINT "Advent of Code 2023 Day 1, part 2":PRINT

       REM *** Set up forwards and backwards arrays of digits 1..9 and one..nine
       FOR JDX = 1 TO 9 
         FWD$(JDX) = CHR$(JDX+48)
         BCK$(JDX) = CHR$(JDX+48)
       NEXT JDX
       FWD$(10) = "one": BCK$(10) = "eno"
       FWD$(11) = "two": BCK$(11) = "owt"
       FWD$(12) = "three": BCK$(12) = "eerht"
       FWD$(13) = "four": BCK$(13) = "ruof"
       FWD$(14) = "five": BCK$(14) = "evif"
       FWD$(15) = "six": BCK$(15) = "xis"
       FWD$(16) = "seven": BCK$(16) = "neves"
       FWD$(17) = "eight": BCK$(17) = "thgie"
       FWD$(18) = "nine": BCK$(18) = "enin"

       TOTAL = 0: PROC = 0
       OPEN "DAY1IN.TXT" AS 8 LOCKED

PROCF: READ #8; LINE BUF$
       IF END #8 THEN FIN

       REM *** Reverse the buffer
       RBUF$=""
       LLEN = LEN(BUF$)
       FOR JDX = 1 TO LLEN
         CH$ = MID$(BUF$,JDX,1)
         RBUF$ = CH$+RBUF$
       NEXT JDX

       REM *** Save the buffer length
       SPOS = LLEN
       EPOS = LLEN
       JDX = 1

       REM *** Process the string forwards and backwards
       WHILE ((( SPOS > 1) OR (EPOS > 1)) AND (JDX <= 18))
         IF (SPOS > 1) THEN \
           FDX = MATCH(FWD$(JDX),BUF$,1): \
           IF (FDX <> 0) THEN \
             IF (FDX <= SPOS) THEN \
               SPOS = FDX: ANSS = JDX
         IF (EPOS > 1) THEN \
           FDX = MATCH(BCK$(JDX),RBUF$,1): \
           IF (FDX <> 0) THEN \
             IF (FDX <= EPOS) THEN \
               EPOS = FDX: ANSE = JDX
         JDX = JDX+1
       WEND

       IF (ANSS >= 10) THEN \
         TOTAL = TOTAL+(ANSS-9)*10 \
       ELSE \
         TOTAL = TOTAL+ANSS*10

       IF (ANSE >=10) THEN \
         TOTAL = TOTAL+ANSE-9 \
       ELSE \
         TOTAL = TOTAL+ANSE

       PROC = PROC+1

       IF MOD(PROC,100) = 0 THEN \ 
         PRINT "Running total after ";PROC;" processed is ";TOTAL

       REM *** Read next line from file
       GOTO PROCF
      
FIN:   CLOSE 8
       PRINT:PRINT "Sum of calibration values is ";TOTAL

       END
