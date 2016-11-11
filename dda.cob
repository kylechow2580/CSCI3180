      *CSCI3180 Principles of Programming Languages
      *--- Declaration ---
      *I declare that the assignment here submitted is original except for source *material explicitly
      *acknowledged. I also acknowledge that I am aware of University policy and *regulations on
      *honesty in academic work, and of the disciplinary guidelines and procedures applicable to
      *breaches of such policy and regulations, as contained in the website
      *http://www.cuhk.edu.hk/policy/academichonesty/
      *Assignment 1
      *Name: Chow Wai Kwong,Kyle
      *Student ID: 1155074568
      *Email Addr: 1155074568@link.cuhk.edu.hk



       IDENTIFICATION DIVISION.
       PROGRAM-ID.   ASSIGNMENT     

      *THIS PROGRAM IS (y,x) COORDDINATION.
      
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO DISK
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS FILE-STATUS.
           SELECT OUTPUT-FILE ASSIGN TO DISK
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD OUTPUT-FILE
           LABEL RECORDS IS STANDARD
           DATA RECORD IS OUTPUT-TABLE
           VALUE OF FILE-ID IS "output.txt".
       01 OUTPUT-TABLE.
           03 ROW PIC X(79).
       FD INPUT-FILE
           LABEL RECORDS ARE STANDARD
           DATA RECORD IS COORD
           VALUE OF FILE-ID IS "input.txt".
       01 COORD.
           03 X-COORD PIC 99.
           03 SEP PIC X.
           03 Y-COORD PIC 99.
                  
       WORKING-STORAGE SECTION.
           01 FILE-STATUS PIC XX.
           01 NUM-OF-POINTS PIC 99 VALUE 0.
           01 SLOPE PIC 99V999 VALUE 0.
           01 XCAL PIC 99 VALUE 0.
           01 YCAL PIC 99 VALUE 0.
           01 LOOP-COUNT PIC 99 VALUE 0.
           01 LOOP-COUNT-S PIC 99 VALUE 0.
           01 LOOP-END PIC 99 VALUE 0.
           01 FUNC-LOOP-COUNT PIC 99 VALUE 0.
           01 FUNC-LOOP-END PIC 99 VALUE 0.
           01 XCOORD PIC 99 VALUE 0.
           01 YCOORD PIC 99 VALUE 0.
           01 PASTXCOORD PIC 99 VALUE 0.
           01 PASTYCOORD PIC 99 VALUE 0.
           01 INNERX PIC 99 VALUE 0.
           01 INNERY PIC 99 VALUE 0.
           01 OUTERX PIC 99 VALUE 0.
           01 OUTERY PIC 99 VALUE 0.
           01 EVENT PIC 9 VALUE 0.
           01 STEP PIC 99V999 VALUE 0.
           01 ANS PIC 99 VALUE 0.
           01 NORMAL PIC 99 VALUE 0.
           01 TMP-PART PIC 99V99 VALUE 0.
           01 DIGIT-NUM PIC 99 VALUE 0.
           01 CHECK-TABLE.
               03 Y-CHECK OCCURS 23.
                   05 X-CHECK PIC X OCCURS 79.                  
	         01 TMP.
               03 DIGIT PIC 9 OCCURS 2.
           01 TMP-SEP.
               03 TEMP PIC 9 OCCURS 5.
     
       PROCEDURE DIVISION.
       MAIN-PARAGRAPH.
           OPEN INPUT INPUT-FILE.
           OPEN OUTPUT OUTPUT-FILE.
             

           IF(FILE-STATUS NOT EQUAL 00 )
              DISPLAY "FAIL TO OPEN FILE. ERROR: " FILE-STATUS
              STOP RUN.
      *Initialize the content of 2d-table
           MOVE 0 TO LOOP-COUNT.
           PERFORM FOR-LOOP-INIT.

      *Read the content in the 1st row in the input.txt
           READ INPUT-FILE.       
           MOVE X-COORD IN COORD TO TMP.
           MOVE DIGIT(2) TO DIGIT-NUM.
           IF DIGIT(1) NOT EQUAL SPACE
               MOVE TMP TO DIGIT-NUM.        
           MOVE DIGIT-NUM TO NUM-OF-POINTS.

      *Read the first coordination in the input.txt
      *And mark it into the 2d-table      
           READ INPUT-FILE.
           MOVE X-COORD IN COORD TO TMP.
           MOVE DIGIT(2) TO PASTXCOORD.
           IF DIGIT(1) NOT EQUAL SPACE
               MOVE TMP TO PASTXCOORD.
           MOVE Y-COORD IN COORD TO TMP.
           MOVE DIGIT(2) TO PASTYCOORD.
           IF DIGIT(1) NOT EQUAL SPACE
               MOVE TMP TO PASTYCOORD.           
           ADD 1 TO PASTYCOORD.
           ADD 1 TO PASTXCOORD.
           MOVE 1 TO X-CHECK(PASTYCOORD, PASTXCOORD).
           SUBTRACT 1 FROM PASTYCOORD.
           SUBTRACT 1 FROM PASTXCOORD.

      *Start reading the remaining coordination in the input.txt
           MOVE 1 TO LOOP-COUNT.
           MOVE NUM-OF-POINTS TO LOOP-END.
           PERFORM FOR-LOOP-READ.

      *Process which charactors are needed to output.
           MOVE 0 TO LOOP-COUNT.
           PERFORM FOR-LOOP-PROCESS.

      *Write the data to output.txt
           MOVE 23 TO LOOP-COUNT.
           PERFORM FOR-LOOP-WRITE.
           
           CLOSE OUTPUT-FILE.
           CLOSE INPUT-FILE.
           STOP RUN.

      *The following function simulate nested for loop initialize 2d table
       FOR-LOOP-INIT.
           ADD 1 TO LOOP-COUNT.
           MOVE 0 TO LOOP-COUNT-S.
           PERFORM FOR-LOOP-INIT2.
           IF(LOOP-COUNT < 23)
           GO TO FOR-LOOP-INIT.

       FOR-LOOP-INIT2.
           ADD 1 TO LOOP-COUNT-S.
           MOVE 0 TO X-CHECK(LOOP-COUNT, LOOP-COUNT-S).
           IF(LOOP-COUNT-S < 79)
           GO TO FOR-LOOP-INIT2.

       FOR-LOOP-READ.
           ADD 1 TO LOOP-COUNT.     
           READ INPUT-FILE.
           MOVE X-COORD IN COORD TO TMP.
           MOVE DIGIT(2) TO XCOORD.
           IF DIGIT(1) NOT EQUAL SPACE
               MOVE TMP TO XCOORD.
           MOVE Y-COORD IN COORD TO TMP.
           MOVE DIGIT(2) TO YCOORD.
           IF DIGIT(1) NOT EQUAL SPACE
               MOVE TMP TO YCOORD.           
           ADD 1 TO XCOORD.
           ADD 1 TO YCOORD.
           ADD 1 TO PASTYCOORD.
           ADD 1 TO PASTXCOORD.
           MOVE 1 TO X-CHECK(YCOORD, XCOORD).
           
           COMPUTE XCAL = (XCOORD - PASTXCOORD).
           COMPUTE YCAL = (YCOORD - PASTYCOORD).
           COMPUTE SLOPE = YCAL / XCAL.
           
           MOVE 0 TO INNERX.
           MOVE 0 TO INNERY.
           MOVE 0 TO OUTERX.
           MOVE 0 TO OUTERY.
           MOVE 0 TO EVENT.

      *The following 6 if-statement determine the position for calculation
           IF(XCOORD > PASTXCOORD AND YCOORD > PASTYCOORD OR SLOPE = 0)
               MOVE 1 TO EVENT
               MOVE XCOORD TO OUTERX
               MOVE YCOORD TO OUTERY
               MOVE PASTXCOORD TO INNERX
               MOVE PASTYCOORD TO INNERY.
           IF(XCOORD < PASTXCOORD AND YCOORD < PASTYCOORD OR SLOPE = 0)
               MOVE 1 TO EVENT
               MOVE PASTXCOORD TO OUTERX
               MOVE PASTYCOORD TO OUTERY
               MOVE XCOORD TO INNERX
               MOVE YCOORD TO INNERY. 
           IF(YCAL > XCAL AND YCOORD > PASTYCOORD AND SLOPE = 0)
               MOVE XCOORD TO OUTERX
               MOVE YCOORD TO OUTERY
               MOVE PASTXCOORD TO INNERX
               MOVE PASTYCOORD TO INNERY.
           IF(YCAL > XCAL AND YCOORD < PASTYCOORD AND SLOPE = 0)
               MOVE XCOORD TO INNERX
               MOVE YCOORD TO INNERY
               MOVE PASTXCOORD TO OUTERX
               MOVE PASTYCOORD TO OUTERY.
           IF(XCOORD < PASTXCOORD AND YCOORD > PASTYCOORD)
               MOVE 2 TO EVENT
               MOVE XCOORD TO OUTERX
               MOVE YCOORD TO OUTERY
               MOVE PASTXCOORD TO INNERX
               MOVE PASTYCOORD TO INNERY.
           IF(XCOORD > PASTXCOORD AND YCOORD < PASTYCOORD)
               MOVE 2 TO EVENT
               MOVE XCOORD TO INNERX
               MOVE YCOORD TO INNERY
               MOVE PASTXCOORD TO OUTERX
               MOVE PASTYCOORD TO OUTERY.

      *The following 5 if-statement mark the point in the 2d-table               
           IF(YCAL > XCAL AND SLOPE = 0)
               MOVE 0 TO FUNC-LOOP-COUNT
               COMPUTE FUNC-LOOP-END = OUTERY - INNERY
               PERFORM LEFT-TO-RIGHT-CASE2.
           IF((SLOPE < 1 OR SLOPE = 1) AND EVENT = 2)
               MOVE 0 TO FUNC-LOOP-COUNT
               COMPUTE FUNC-LOOP-END = INNERX - OUTERX
               PERFORM RIGHT-TO-LEFT-CASE1.
           IF(SLOPE > 1 AND EVENT = 2)
               MOVE 0 TO FUNC-LOOP-COUNT
               COMPUTE FUNC-LOOP-END = OUTERY - INNERY
               PERFORM RIGHT-TO-LEFT-CASE2.
           IF((SLOPE < 1 OR SLOPE = 1) AND EVENT = 1)
               MOVE 0 TO FUNC-LOOP-COUNT
               COMPUTE FUNC-LOOP-END = OUTERX - INNERX
               PERFORM LEFT-TO-RIGHT-CASE1.         
           IF(SLOPE > 1 AND EVENT = 1)
               MOVE 0 TO FUNC-LOOP-COUNT
               COMPUTE FUNC-LOOP-END = OUTERY - INNERY
               PERFORM LEFT-TO-RIGHT-CASE2.   

           SUBTRACT 1 FROM PASTYCOORD.
           SUBTRACT 1 FROM PASTXCOORD.
           SUBTRACT 1 FROM YCOORD.
           SUBTRACT 1 FROM XCOORD.
           MOVE XCOORD TO PASTXCOORD.
           MOVE YCOORD TO PASTYCOORD.   
           IF(LOOP-COUNT < LOOP-END)
           GO TO FOR-LOOP-READ.

      *The following 2 function filter the charactors
       FOR-LOOP-PROCESS.
           ADD 1 TO LOOP-COUNT.           
           IF(X-CHECK(1, 1) EQUAL 0)
               MOVE "+" TO X-CHECK(1, 1).
           MOVE 0 TO LOOP-COUNT-S.
           PERFORM FOR-LOOP-PROCESS2.          
           IF(LOOP-COUNT < 23)
           GO TO FOR-LOOP-PROCESS.
       FOR-LOOP-PROCESS2.
           ADD 1 TO LOOP-COUNT-S.
           IF(X-CHECK(LOOP-COUNT, 1) EQUAL 0)
               MOVE "|" TO X-CHECK(LOOP-COUNT, 1).
           IF(X-CHECK(1, LOOP-COUNT-S) EQUAL 0)
               MOVE "-" TO X-CHECK(1, LOOP-COUNT-S).
           IF(X-CHECK(LOOP-COUNT, LOOP-COUNT-S) EQUAL "1")
               MOVE "*" TO X-CHECK(LOOP-COUNT, LOOP-COUNT-S).
           IF(X-CHECK(LOOP-COUNT, LOOP-COUNT-S) EQUAL 0)
               MOVE " " TO X-CHECK(LOOP-COUNT, LOOP-COUNT-S).                     
           IF(LOOP-COUNT-S < 79)
           GO TO FOR-LOOP-PROCESS2.

      *The following 4 function is based on direction and slope
       RIGHT-TO-LEFT-CASE1.
           ADD 1 TO FUNC-LOOP-COUNT.
           COMPUTE STEP  = SLOPE * FUNC-LOOP-COUNT.
           COMPUTE ANS ROUNDED = STEP + INNERY.
           COMPUTE NORMAL = INNERX - FUNC-LOOP-COUNT.
           MOVE "*" TO X-CHECK(ANS, NORMAL).       
           IF(FUNC-LOOP-COUNT < FUNC-LOOP-END)
           GO TO RIGHT-TO-LEFT-CASE1.

       RIGHT-TO-LEFT-CASE2.
           ADD 1 TO FUNC-LOOP-COUNT.
           COMPUTE STEP = 1 / SLOPE * FUNC-LOOP-COUNT.
           COMPUTE ANS ROUNDED = INNERX - STEP.
           COMPUTE NORMAL = INNERY + FUNC-LOOP-COUNT.
           MOVE "*" TO X-CHECK(NORMAL, ANS).          
           IF(FUNC-LOOP-COUNT < FUNC-LOOP-END)
           GO TO RIGHT-TO-LEFT-CASE2.

       LEFT-TO-RIGHT-CASE1.
           ADD 1 TO FUNC-LOOP-COUNT.
           COMPUTE STEP = SLOPE * FUNC-LOOP-COUNT.
           COMPUTE ANS ROUNDED = STEP + INNERY.
           COMPUTE NORMAL = INNERX + FUNC-LOOP-COUNT.
           MOVE "*" TO X-CHECK(ANS, NORMAL).           
           IF(FUNC-LOOP-COUNT < FUNC-LOOP-END)
           GO TO LEFT-TO-RIGHT-CASE1.

       LEFT-TO-RIGHT-CASE2.
           ADD 1 TO FUNC-LOOP-COUNT.
           COMPUTE STEP = 1 / SLOPE * FUNC-LOOP-COUNT.
           COMPUTE ANS ROUNDED = STEP + INNERX.
           COMPUTE NORMAL = INNERY + FUNC-LOOP-COUNT.
           MOVE "*" TO X-CHECK(NORMAL, ANS).           
           IF(FUNC-LOOP-COUNT < FUNC-LOOP-END)
           GO TO LEFT-TO-RIGHT-CASE2.
           
       FOR-LOOP-WRITE.
           IF(LOOP-COUNT > 0)
           MOVE Y-CHECK(LOOP-COUNT) TO ROW
           WRITE OUTPUT-TABLE
           SUBTRACT 1 FROM LOOP-COUNT
           GO TO FOR-LOOP-WRITE.   


