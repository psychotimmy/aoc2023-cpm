       INTEGER JDX
       STRING CH$, BUF$
       REAL TOTAL

       PRINT "Advent of Code 2023 Day 1, part 1":PRINT

       TOTAL = 0
       OPEN "DAY1IN.TXT" AS 8 LOCKED

PROCF: READ #8; LINE BUF$
       IF END #8 THEN FIN
       
       REM *** Process the buffer forwards
       JDX = 1
       CH$ = MID$(BUF$,JDX,1)
       WHILE ((CH$ < "1") OR (CH$ > "9")) AND (CH$ <> "")
         JDX = JDX+1
         CH$ = MID$(BUF$,JDX,1)
       WEND
       
       TOTAL = TOTAL+(ASC(CH$)-48)*10

       REM *** Process the buffer backwards
       JDX = LEN(BUF$)
       CH$ = MID$(BUF$,JDX,1)
       WHILE ((CH$ < "1") OR (CH$ > "9")) AND (CH$ <> "")
         JDX = JDX-1
         CH$ = MID$(BUF$,JDX,1)
       WEND

       TOTAL = TOTAL+ASC(CH$)-48

       REM *** Read next line from file
       GOTO PROCF
      
FIN:   CLOSE 8
       PRINT "Sum of calibration values is ";TOTAL

       END
