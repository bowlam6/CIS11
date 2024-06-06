; CIS11 Project
; Team Members: Jamal Mansouri, Enrique Hernandez, Bowie Lam
.ORIG x3000
; Origination address
; Display welcome message
LEA R0, WEL
PUTS
WEL .STRINGZ "Enter 5 scores: (0 - 99)"
; Use appropriate labels and comments
LD R0, NEWLINE
OUT
; Get user input for 5 test scores and store in array
; Use subroutine calls and branching for control
JSR GET_GRADE
LEA R6, GRADES
STR R3, R6, #0
JSR GET_LETTER
JSR POP
LD R0, NEWLINE
OUT
JSR GET_GRADE
LEA R6, GRADES
STR R3, R6, #1
JSR GET_LETTER
JSR POP
LD R0, NEWLINE
OUT
JSR GET_GRADE
LEA R6, GRADES
STR R3, R6, #2
JSR GET_LETTER
JSR POP
LD R0, NEWLINE
OUT
JSR GET_GRADE
LEA R6, GRADES
STR R3, R6, #3
JSR GET_LETTER
JSR POP
LD R0, NEWLINE
OUT
JSR GET_GRADE
LEA R6, GRADES
STR R3, R6, #4
JSR GET_LETTER
JSR POP
LD R0, NEWLINE
OUT
; Calculate maximum score
CALCULATE_MAX
LD R1, NUM_TESTS
LEA R2, GRADES
LD R4, GRADES
ST R4, MAX_GRADE
ADD R2, R2, #1
LOOP1 LDR R5, R2, #0
NOT R4, R4
ADD R4, R4, #1
ADD R5, R5, R4
BRp NEXT1
LEA R0, MAX
PUTS
LD R3, MAX_GRADE
AND R1, R1, #0
JSR BREAK_INT
LD R0, SPACE
OUT
LD R0, NEWLINE
OUT
JSR CLEAR_REG
; Calculate minimum score
CALCULATE_MIN
LD R1, NUM_TESTS
LEA R2, GRADES
LD R4, GRADES
ST R4, MIN_GRADE
ADD R2, R2, #1
ADD R1, R1, #-1
LOOP2 LDR R5, R2, #0
NOT R4, R4
ADD R4, R4, #1
ADD R5, R5, R4
BRn NEXT2
ADD R2, R2, #1
LD R4, GRADES
AND R5, R5,#0
ADD R1,R1,#-1
BRp LOOP2
LEA R0, MIN
PUTS
LD R3, MIN_GRADE
AND R1, R1, #0
JSR BREAK_INT
LD R0, SPACE
OUT
JSR CLEAR_REG
LD R0, NEWLINE
OUT
; Calculate average score
CALC_AVG
LD R1, NUM_TESTS
LEA R2, GRADES
GEN_SUM LDR R4, R2, #0
ADD R3, R3, R4
ADD R2, R2, #1
ADD R1, R1, #-1
BRp GEN_SUM
LD R1, NUM_TESTS
NOT R1, R1
ADD R1, R1, #1
ADD R4, R3, #0
LOOP3 ADD R4, R4, #0
BRnz DONE_AVG
ADD R6, R6, #1
ADD R4, R4, R1
BRp LOOP3
DONE_AVE
ST R6, AVERAGE_SCORE
LEA R0, AVG
PUTS
AND R3, R3, #0
AND R1, R1, #0
AND R4, R4, #0
ADD R3, R3, R6
JSR BREAK_INT
; Restart program if desired
JSR RESTART_PROG
HALT
; Use appropriate system call directives
; Fill addresses and data storage
NEWLINE .FILL xA
SPACE .FILL X20
DECODE_DEC .FILL #-48
DECODE_SYM .FILL #48
DECODE_THIRTY .FILL #-30
NUM_TESTS .FILL #5
RESTART2 .FILL x3000
MAX_GRADE .BLKW #1
MIN_GRADE .BLKW #1
DONE_AVG .BLKW #1
AVERAGE_SCORE .BLKW #1
; Branches for calculating min and max
NEXT2
LDR R4, R2, #0
ST R4, MIN_GRADE
ADD R2, R2, #1
ADD R1, R1, #-1
BRnzp LOOP2
NEXT1
LDR R4, R2, #0
ST R4, MAX_GRADE
ADD R2, R2, #1
ADD R1, R1, #-1
BRp LOOP1
; Array to store test scores
GRADES .BLKW #5
; Messages for displaying results
MIN .STRINGZ "MIN "
MAX .STRINGZ "MAX "
AVG .STRINGZ "AVG "
; Subroutine to restart the program
RESTART_PROG
ST R7, SAVELOC1
LD R1, LOWER_Y
LD R3, UPPER_Y
LD R2, ORIGIN
LD R0, NEWLINE
OUT
LEA R0 RESTARTPROG_STR
PUTS
LD R0, NEWLINE
OUT
GETC
ADD R1, R1, R0
BRz RESTART_TRUE
ADD R3, R3, R0
BRz RESTART_TRUE
HALT
RESTART_TRUE
JMP R2
RESTARTPROG_STR .STRINGZ "PROGRAM FINISHED, DO YOU WANT TO RUN THIS PROGRAM AGAIN? Y/N "
LOWER_Y .FILL xFF87
UPPER_Y .FILL xFFA7
ORIGIN .FILL x3000
; Data storage for subroutines
SAVELOC1 .FILL X0
SAVELOC2 .FILL X0
SAVELOC3 .FILL X0
SAVELOC4 .FILL X0
SAVELOC5 .FILL X0
; Subroutine to get user input for a test score
GET_GRADE ST R7, SAVELOC1
JSR CLEAR_REG
LD R4, DECODE_DEC
GETC
JSR VALIDA
OUT
ADD R1, R0, #0
ADD R1, R1, R4
ADD R2, R2, #10
MULT10 ADD R3, R3, R1
ADD R2, R2, #-1
BRp MULT10
GETC
JSR VALIDA
OUT
ADD R0, R0, R4
ADD R3, R3, R0
LD R0, SPACE
OUT
LD R7, SAVELOC1
RET
; Subroutine to break an integer into two digits for printing
BREAK_INT
ST R7, SAVELOC1
LD R5, DECODE_SYM
ADD R4, R3, #0
DIV1 ADD R1, R1, #1
ADD R4, R4, #-10
BRp DIV1
ADD R1, R1 #-1
ADD R4, R4, #10
ADD R6, R4, #-10
BRnp POS
NEG ADD R1, R1, #1
ADD R4, R4, #-10
POS ST R1, Q
ST R4, R
LD R0, Q
ADD R0, R0, R5
OUT
LD R0, R
ADD R0, R0, R5
OUT
LD R7, SAVELOC1
RET
R .FILL X0
Q .FILL X0
; Subroutine to push a value onto the stack
PUSH ST R7, SAVELOC2
JSR CLEAR_REG
LD R6, POINTER
ADD R6, R6, #0
BRnz STACK_ERROR
ADD R6, R6, #-1
STR R0, R6, #0
ST R6, POINTER
LD R7, SAVELOC2
RET
POINTER .FILL X4000
; Subroutine to pop a value from the stack
POP LD R6, POINTER
ST R1, SAVELOC5
LD R1, BASELINE
ADD R1, R1, R6
BRzp STACK_ERROR
LD R1, SAVELOC5
LDR R0, R6, #0
ST R7, SAVELOC4
OUT
LD R0, SPACE
OUT
ADD R6, R6, #1
ST R6, POINTER
LD R7, SAVELOC4
RET
STACK_ERROR LEA R0, ERROR
PUTS
HALT
BASELINE .FILL xC000
ERROR .STRINGZ "STACK UNDERFLOW OR UNDERFLOW. HALTING PROGRAM"
; Subroutine to determine the letter grade based on the numeric score
GET_LETTER
AND R2, R2, #0
A_GRADE LD R0, A_NUM
LD R1, A_LET
ADD R2, R3, R0
BRzp STR_GRADE
B_GRADE AND R2, R2, #0
LD R0, B_NUM
LD R1, B_LET
ADD R2, R3, R0
BRzp STR_GRADE
C_GRADE AND R2, R2, #0
LD R0, C_NUM
LD R1, C_LET
ADD R2, R3, R0
BRzp STR_GRADE
D_GRADE AND R2, R2, #0
LD R0, D_NUM
LD R1, D_LET
ADD R2, R3, R0
BRzp STR_GRADE
F_GRADE AND R2, R2, #0
LD R0, F_NUM
LD R1, F_LET
ADD R2, R3, R0
BRNZP STR_GRADE
RET
STR_GRADE ST R7, SAVELOC1
AND R0, R0, #0
ADD R0, R1, #0
JSR PUSH
LD R7, SAVELOC1
RET
; Constants for letter grade ranges
A_NUM .FILL #-90
A_LET .FILL X41
B_NUM .FILL #-80
B_LET .FILL X42
C_NUM .FILL #-70
C_LET .FILL X43
D_NUM .FILL #-60
D_LET .FILL X44
F_NUM .FILL #-50
F_LET .FILL X46
; Subroutine to clear registers R1-R6
CLEAR_REG AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
RET
; Subroutine for data validation of user input
VALIDA ST R1, SAVELOC5
ST R2, SAVELOC4
ST R3, SAVELOC3
LD R1, DATA_MIN
ADD R2, R0, R1
BRN FAIL
LD R1, DATA_MAX
ADD R3, R0, R1
BRP FAIL
LD R1, SAVELOC5
LD R2, SAVELOC4
LD R3, SAVELOC3
RET
; Branch for invalid input
FAIL LEA R0, FAIL_STR
PUTS
LD R0, NEWLINE2
OUT
LD R7, RESTART
JMP R7
FAIL_STR .STRINGZ "INVALID ENTRY, RESTARTING..."
RESTART .FILL X3000
DATA_MIN .FILL #-48
DATA_MAX .FILL #-57
NEWLINE2 .FILL XA
.END