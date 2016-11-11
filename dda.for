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


      PROGRAM Helloworld
      IMPLICIT NONE

*-----------------------------------
      INTEGER INPUT
      INTEGER LOOPCOUNT
      INTEGER LOOPCOUNTY
      INTEGER FUNCOUNT
      INTEGER LOOPEND
      INTEGER PASTX
      INTEGER PASTY
      INTEGER COORDX
      INTEGER COORDY
      INTEGER XCAL
      INTEGER YCAL
      INTEGER MERGE
      INTEGER IOS
      DOUBLE PRECISION SLOPE
      CHARACTER*1 XSIGN
      CHARACTER*1 YSIGN
      CHARACTER ARR(1:79,1:23)


*-----------------------------------
      
      OPEN(UNIT=10, IOSTAT=ios, FILE='input.txt', STATUS='OLD')
      If (ios.ne.00) GOTO 689


*2D array initization
      LOOPCOUNT = 1
      LOOPCOUNTY = 1
 100  ARR(LOOPCOUNT, LOOPCOUNTY) = ' '
      LOOPCOUNT = LOOPCOUNT + 1
      IF(LOOPCOUNT .LE. 79) GOTO 100
      LOOPCOUNT = 1
      LOOPCOUNTY = LOOPCOUNTY + 1
      IF(LOOPCOUNTY .LE. 23) GOTO 100


*Read the first input from input.txt
      READ(10,1) INPUT
 1    FORMAT(I2)


*Mark the first coordination and store
 3    FORMAT(I2,X,I2)
      READ(10,3) PASTX,PASTY
      ARR(PASTX + 1, PASTY + 1) = '*'

*Start Read the remained points           
      LOOPCOUNT = 1
 301  READ(10,3) COORDX,COORDY
      ARR(COORDX + 1, COORDY + 1) = '*'


*Calculate the slope of each 2 points
      IF(COORDX .LE. PASTX) GOTO 302
          GOTO 303  
 302  XCAL = PASTX - COORDX
      XSIGN = '-'
      GOTO 111
 303  XCAL = COORDX - PASTX
      XSIGN = '+'
 111  IF(COORDY .LE. PASTY) GOTO 304
          GOTO 305
 304  YCAL = PASTY - COORDY
      YSIGN = '-'
      GOTO 112
 305  YCAL = COORDY - PASTY
      YSIGN = '+' 

 112  SLOPE = DBLE(YCAL)/DBLE(XCAL)
*     WRITE(*,306) XSIGN,XCAL,YSIGN,YCAL, SLOPE
 306  FORMAT("X:",A1,I2," Y:",A1,I2, " SLOPE:",F9.5)


*Start dda algorithm based on slope
      IF(SLOPE .LE. 1) GOTO 501
          GOTO 502

*Read the point from top-right to bottom-left
 501  IF(COORDX .GT. PASTX .AND. COORDY .GE. PASTY) GOTO 601
          GOTO 602
 601  FUNCOUNT = 1
      LOOPEND = XCAL
 701  ARR(PASTX + FUNCOUNT + 1, NINT(FUNCOUNT*SLOPE+PASTY) + 1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 701
      GOTO 603

*Read the point from bottom-left to top-right 
 602  IF(COORDX .LT. PASTX .AND. COORDY .LE. PASTY) GOTO 604
          GOTO 603
 604  FUNCOUNT = 1
      LOOPEND = XCAL
 702  ARR(COORDX + FUNCOUNT + 1, NINT(FUNCOUNT*SLOPE+COORDY) + 1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 702
      GOTO 603

*Merge point of if-else like function
 603  MERGE = 1

*Read the point from bottom-right to top-left
      IF(COORDX .GT. PASTX .AND. COORDY .LT. PASTY) GOTO 605
          GOTO 606
 605  FUNCOUNT = 1
      LOOPEND = XCAL
 703  ARR(COORDX - FUNCOUNT + 1, NINT(FUNCOUNT*SLOPE+COORDY) + 1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 703
      GOTO 609

*Read the point from top-left to bottom-right
 606  IF(COORDX .LT. PASTX .AND. COORDY .GT. PASTY) GOTO 607
          GOTO 609
 607  FUNCOUNT = 1
      LOOPEND = XCAL
 704  ARR(COORDX + FUNCOUNT + 1, NINT(COORDY-FUNCOUNT*SLOPE) + 1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 704
      GOTO 609

*Merge point of if-else like function
 609  MERGE = 1
      GOTO 503



*Read the point from top-right to bottom-left
 502  IF(COORDX .GE. PASTX .AND. COORDY .GT. PASTY) GOTO 11
          GOTO 12
 11   FUNCOUNT = 1
      LOOPEND = YCAL
      WRITE(*,1) 2
 21   ARR(NINT(FUNCOUNT/SLOPE+PASTX) + 1, PASTY+FUNCOUNT+1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 21
      GOTO 14
 

*Read the point from bottom-left to top-right
 12   IF(COORDX .LE. PASTX .AND. COORDY .LT. PASTY) GOTO 13
          GOTO 14
 13   FUNCOUNT = 1
      LOOPEND = YCAL
 22   ARR(NINT(FUNCOUNT/SLOPE+COORDX) + 1, COORDY+FUNCOUNT+1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 22
      GOTO 14

*Read the point from top-left to bottom-right
 14   IF(COORDX .GT. PASTX .AND. COORDY .LT. PASTY) GOTO 15
          GOTO 16
 15   FUNCOUNT = 1
      LOOPEND = YCAL
 23   ARR(NINT(FUNCOUNT/SLOPE+PASTX) + 1, PASTY-FUNCOUNT+1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 23
      GOTO 17

*Read the point from bottom-right to top-left
 16   IF(COORDX .LT. PASTX .AND. COORDY .GT. PASTY) GOTO 71
          GOTO 17
 71   FUNCOUNT = 1
      LOOPEND = YCAL
 24   ARR(NINT(FUNCOUNT/SLOPE+COORDX) + 1, COORDY-FUNCOUNT+1) = '*'
      FUNCOUNT = FUNCOUNT + 1
      IF(FUNCOUNT .LT. LOOPEND) GOTO 24
      GOTO 17
 
*Merge point of if-else like function
 17   GOTO 503
 503  MERGE = 1
      
      PASTX = COORDX
      PASTY = COORDY
      LOOPCOUNT = LOOPCOUNT + 1
      IF(LOOPCOUNT .LT. INPUT) GOTO 301


     
*Process the needed data for printing      
      LOOPCOUNT = 1
      IF(ARR(LOOPCOUNT, 1) .EQ. '*') GOTO 901
          ARR(LOOPCOUNT, 1) = '+'
 901  LOOPCOUNT = LOOPCOUNT + 1
      LOOPCOUNT = 2
 903  IF(ARR(LOOPCOUNT, 1) .EQ. '*') GOTO 902
          ARR(LOOPCOUNT, 1) = '-'
 902  LOOPCOUNT = LOOPCOUNT + 1
      IF(LOOPCOUNT .LT. 79) GOTO 903
      LOOPCOUNT = 2
 905  IF(ARR(1, LOOPCOUNT) .EQ. '*') GOTO 904
          ARR(1,LOOPCOUNT) = '|'
 904  LOOPCOUNT = LOOPCOUNT + 1
      IF(LOOPCOUNT .LT. 23) GOTO 905

*Print the information to the screen
      LOOPCOUNT = 1
      LOOPCOUNTY = 23
 999  WRITE(*,99) ARR(LOOPCOUNT, LOOPCOUNTY)
 99   FORMAT(A1,$)
      LOOPCOUNT = LOOPCOUNT + 1
      IF(LOOPCOUNT .LE. 79) GOTO 999
      LOOPCOUNT = 1
      LOOPCOUNTY = LOOPCOUNTY - 1
      IF(LOOPCOUNTY .GE. 1) GOTO 999

      CLOSE(10)
      GOTO 404
 689  WRITE(*,444)
 444  FORMAT("File opend failed!")
 404  STOP
 911  END













