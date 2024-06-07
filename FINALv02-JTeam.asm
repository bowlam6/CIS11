; CIS 11 Final Project
; Test Score Calculator
; Programmers: Enrique Hernandez, Bowie Lam, Jamal Mansouri
;
; Program Purpose: LC-3 program that displays the minimum, maximum and average grade of 5 test
; scores and displays the letter grade associated with the test scores.
;
; DATE: 06/06/2024

.ORIG x3000         ; Origination address

; Display welcome message 
    LEA R0, WEL              ; Load address of welcome message
    PUTS                    ; Print welcome message
WEL .STRINGZ "\nEnter 5 test scores: *scores can range from 0 to 99\n"

; Use appropriate labels and comments
    LD R0, LINER
    OUT

; Get 5 user input for 5 test scores and store in array
; Use subroutine calls and branching for control

; 1st score
    JSR CONVERT_INPUT           ; Call subroutine to get user input for a grade
    LEA R6, ARRAY_GRADE          ; Load address of ARRAY_GRADE array
    STR R3, R6, #0          ; Store the grade in the first element of the array
    JSR CONVERT_TO_LETTER          ; Call subroutine to determine the letter grade
    JSR POP                 ; Pop the letter grade from the stack and print it
    LD R0, LINER
    OUT

; 2nd score
    JSR CONVERT_INPUT
    LEA R6, ARRAY_GRADE
    STR R3, R6, #1          ; Store the grade in the second element of the array
    JSR CONVERT_TO_LETTER
    JSR POP
    LD R0, LINER
    OUT

; 3rd score
    JSR CONVERT_INPUT
    LEA R6, ARRAY_GRADE
    STR R3, R6, #2          ; Store the grade in the third element of the array
    JSR CONVERT_TO_LETTER
    JSR POP
    LD R0, LINER
    OUT

; 4th score
    JSR CONVERT_INPUT
    LEA R6, ARRAY_GRADE
    STR R3, R6, #3          ; Store the grade in the fourth element of the array
    JSR CONVERT_TO_LETTER
    JSR POP
    LD R0, LINER
    OUT

; 5th score
    JSR CONVERT_INPUT
    LEA R6, ARRAY_GRADE
    STR R3, R6, #4          ; Store the grade in the fifth element of the array
    JSR CONVERT_TO_LETTER
    JSR POP
    LD R0, LINER
    OUT

; Calculate maximum score
FIND_MAX
    LD R1, ITERATOR_COUNTER        ; Load the number of tests
    LEA R2, ARRAY_GRADE          ; Load address of ARRAY_GRADE array
    LD R4, ARRAY_GRADE           ; Load the first grade as the initial maximum
    ST R4, SCORE_MAX        ; Store the initial maximum grade
    ADD R2, R2, #1          ; Move to the next grade in the array
    LOOP_MAX LDR R5, R2, #0    ; Load the current grade
    NOT R4, R4              ; Negate the current maximum grade
    ADD R4, R4, #1
    ADD R5, R5, R4          ; Compare the current grade with the maximum grade
    BRp CURR_MAX               ; If the current grade is greater, update the maximum
    LEA R0, STRING_MAX             ; Load address of "Maximum Score: " message
    PUTS                    ; Print the message
    LD R3, SCORE_MAX        ; Load the maximum grade
    AND R1, R1, #0
    JSR PRINTER_INT           ; Call subroutine to break the integer into digits and print it
    LD R0, SPACE
    OUT
    LD R0, LINER
    OUT
    JSR EMPTY_R           ; Call subroutine to clear registers R1-R6

; Calculate minimum score
FIND_MIN
    LD R1, ITERATOR_COUNTER
    LEA R2, ARRAY_GRADE
    LD R4, ARRAY_GRADE           ; Load the first grade as the initial minimum
    ST R4, SCORE_MIN        ; Store the initial minimum grade
    ADD R2, R2, #1          ; Move to the next grade in the array
    ADD R1, R1, #-1         ; Decrement the loop counter
    LOOP_MIN LDR R5, R2, #0    ; Load the current grade
    NOT R4, R4              ; Negate the current minimum grade
    ADD R4, R4, #1
    ADD R5, R5, R4          ; Compare the current grade with the minimum grade
    BRn CURR_MIN               ; If the current grade is smaller, update the minimum
    ADD R2, R2, #1          ; Move to the next grade in the array
    LD R4, ARRAY_GRADE           ; Reset the minimum grade to the first grade
    AND R5, R5,#0
    ADD R1,R1,#-1           ; Decrement the loop counter
    BRp LOOP_MIN               ; If there are more grades to compare, continue the loop
    LEA R0, STRING_MIN             ; Load address of "Minimum Score: " message
    PUTS                    ; Print the message
    LD R3, SCORE_MIN        ; Load the minimum grade
    AND R1, R1, #0
    JSR PRINTER_INT           ; Call subroutine to break the integer into digits and print it
    LD R0, SPACE
    OUT
    JSR EMPTY_R
    LD R0, LINER
    OUT

; Calculate average score
CALC_AVG
    LD R1, ITERATOR_COUNTER        ; Load the number of tests
    LEA R2, ARRAY_GRADE          ; Load address of ARRAY_GRADE array
    SUMMARY LDR R4, R2, #0  ; Load the current grade
    ADD R3, R3, R4          ; Add the current grade to the sum
    ADD R2, R2, #1          ; Move to the next grade in the array
    ADD R1, R1, #-1         ; Decrement the loop counter
    BRp SUMMARY             ; If there are more grades to add, continue the loop
    LD R1, ITERATOR_COUNTER        ; Load the number of tests
    NOT R1, R1              ; Negate the number of tests
    ADD R1, R1, #1
    ADD R4, R3, #0          ; Copy the sum to R4
    LOOP_AVG ADD R4, R4, #0    ; Check if the sum is divisible by the number of tests
    BRnz AVG_COMPLETE           ; If the sum is not divisible, skip the division
    ADD R6, R6, #1          ; Increment the quotient (average)
    ADD R4, R4, R1          ; Subtract the number of tests from the sum
    BRp LOOP_AVG               ; If the sum is still positive, continue the loop
    DONE_AVE
    ST R6, SCORE_AVG    ; Store the average score
    LEA R0, STRING_AVG             ; Load address of "Average Score: " message
    PUTS                    ; Print the message
    AND R3, R3, #0
    AND R1, R1, #0
    AND R4, R4, #0
    ADD R3, R3, R6          ; Load the average score
    JSR PRINTER_INT           ; Call subroutine to break the integer into digits and print it

; Restart program if desired
    JSR RESTART_PROG        ; Call subroutine to prompt the user to restart the program
    HALT

; Using appropriate system call directives
; Fill addresses and data storage
LINER .FILL xA
SPACE .FILL X20
DECODER1 .FILL #-48
DECODER2 .FILL #48
ITERATOR_COUNTER .FILL #5
RESTART2 .FILL x3000
SCORE_MAX .BLKW #1          ; Reserve memory for storing the maximum grade
SCORE_MIN .BLKW #1          ; Reserve memory for storing the minimum grade
AVG_COMPLETE .BLKW #1
SCORE_AVG .BLKW #1      ; Reserve memory for storing the average score

; Branches for calculating min and max
CURR_MIN
LDR R4, R2, #0              ; Load the current grade
ST R4, SCORE_MIN            ; Update the minimum grade
ADD R2, R2, #1              ; Move to the next grade in the array
ADD R1, R1, #-1             ; Decrement the loop counter
BRnzp LOOP_MIN                 ; Continue the loop
CURR_MAX
LDR R4, R2, #0              ; Load the current grade
ST R4, SCORE_MAX            ; Update the maximum grade
ADD R2, R2, #1              ; Move to the next grade in the array
ADD R1, R1, #-1             ; Decrement the loop counter
BRp LOOP_MAX                   ; Continue the loop

; Array to store test scores
ARRAY_GRADE .BLKW #5             ; Reserve memory for storing 5 test scores

; Messages for displaying results
STRING_MIN .STRINGZ "Minimum Score: "
STRING_MAX .STRINGZ "Maximum Score: "
STRING_AVG .STRINGZ "Average Score: "

; Subroutine to restart the program
RESTART_PROG
ST R7, RETADDRESS1             ; Save the return address
LD R1, Y_LOW              ; Load the ASCII value of lowercase 'y'
LD R3, Y_UP              ; Load the ASCII value of uppercase 'Y'
LD R2, ADD_RESTART               ; Load the address to jump to for restarting the program
LD R0, LINER
OUT
LEA R0 RESTARTPROG_STR      ; Load address of the prompt message
PUTS                        ; Print the prompt message
LEA R0 RESTARTPROG_STR2
PUTS
LD R0, LINER
OUT
GETC                        ; Get a character from the user
ADD R1, R1, R0              ; Compare the input with lowercase 'y'
BRz RESTART_TRUE            ; If the input is 'y', restart the program
ADD R3, R3, R0              ; Compare the input with uppercase 'Y'
BRz RESTART_TRUE            ; If the input is 'Y', restart the program
HALT                        ; If the input is neither 'y' nor 'Y', halt the program
RESTART_TRUE
JMP R2                      ; Jump to the address for restarting the program
RESTARTPROG_STR .STRINGZ  "The results are displayed above. Would you like to run this program again?\n "
RESTARTPROG_STR2 .STRINGZ "If Yes press Y. If No press N."
Y_LOW .FILL xFF87         ; ASCII value of lowercase 'y'
Y_UP .FILL xFFA7         ; ASCII value of uppercase 'Y'
ADD_RESTART .FILL x3000          ; Address to jump to for restarting the program

; Data storage for subroutines
RETADDRESS1 .FILL X0           ; Storage for saving return address
RETADDRESS2 .FILL X0           ; Storage for saving return address
REGVAL1 .FILL X0           ; Storage for saving register values
REGVAL2 .FILL X0           ; Storage for saving register values
REGVAL3 .FILL X0           ; Storage for saving register values

; Subroutine to get user input for a test score
CONVERT_INPUT ST R7, RETADDRESS1   ; Save the return address
JSR EMPTY_R               ; Call subroutine to clear registers R1-R6
LD R4, DECODER1           ; Load the value for decoding ASCII digits
GETC                        ; Get the first digit of the grade
JSR DATA_VALID                  ; Call subroutine to validate the input
OUT                         ; Echo the input
ADD R1, R0, #0              ; Move the input to R1
ADD R1, R1, R4              ; Convert the ASCII digit to its numeric value
ADD R2, R2, #10             ; Set the loop counter for multiplying by 10
MULTIPLY ADD R3, R3, R1       ; Multiply the previous value by 10 and add the current digit
ADD R2, R2, #-1             ; Decrement the loop counter
BRp MULTIPLY                  ; If the loop counter is positive, continue the loop
GETC                        ; Get the second digit of the grade
JSR DATA_VALID                  ; Call subroutine to validate the input
OUT                         ; Echo the input
ADD R0, R0, R4              ; Convert the ASCII digit to its numeric value
ADD R3, R3, R0              ; Add the second digit to the grade
LD R0, SPACE
OUT                         ; Print a space
LD R7, RETADDRESS1             ; Restore the return address
RET                         ; Return from the subroutine

; Subroutine to break an integer into two digits for printing
PRINTER_INT
ST R7, RETADDRESS1             ; Save the return address
LD R5, DECODER2           ; Load the value for encoding digits as ASCII
ADD R4, R3, #0              ; Copy the integer to R4
DIV1 ADD R1, R1, #1         ; Increment the quotient
ADD R4, R4, #-10            ; Subtract 10 from the integer
BRp DIV1                    ; If the result is positive, continue the division loop
ADD R1, R1 #-1              ; Decrement the quotient to get the correct value
ADD R4, R4, #10             ; Add 10 back to the remainder
ADD R6, R4, #-10            ; Check if the remainder is negative
BRnp POS                    ; If the remainder is non-negative, skip the NEG block
NEG ADD R1, R1, #1          ; If the remainder is negative, increment the quotient
ADD R4, R4, #-10            ; Subtract 10 from the remainder
POS ST R1, Q                ; Store the quotient
ST R4, R                    ; Store the remainder
LD R0, Q                    ; Load the quotient
ADD R0, R0, R5              ; Convert the quotient to ASCII
OUT                         ; Print the quotient
LD R0, R                    ; Load the remainder
ADD R0, R0, R5              ; Convert the remainder to ASCII
OUT                         ; Print the remainder
LD R7, RETADDRESS1             ; Restore the return address
RET                         ; Return from the subroutine
R .FILL X0                  ; Storage for the remainder
Q .FILL X0                  ; Storage for the quotient

; Subroutine to push a value onto the stack
PUSH ST R7, RETADDRESS2        ; Save the return address
JSR EMPTY_R               ; Call subroutine to clear registers R1-R6
LD R6, INITIAL_VAL              ; Load the stack INITIAL_VAL
ADD R6, R6, #0              ; Check if the stack INITIAL_VAL is zero
BRnz ERRORS            ; If the stack INITIAL_VAL is zero or negative, jump to the error block
ADD R6, R6, #-1             ; Decrement the stack INITIAL_VAL
STR R0, R6, #0              ; Store the value at the top of the stack
ST R6, INITIAL_VAL              ; Update the stack INITIAL_VAL
LD R7, RETADDRESS2             ; Restore the return address
RET                         ; Return from the subroutine
INITIAL_VAL .FILL X4000         ; Initial value of the stack INITIAL_VAL

; Subroutine to pop a value from the stack
POP LD R6, INITIAL_VAL          ; Load the stack INITIAL_VAL
ST R1, REGVAL3             ; Save the value of R1
LD R1, STARTER_ADDRESS             ; Load the base address of the stack
ADD R1, R1, R6              ; Check if the stack is empty
BRzp ERRORS            ; If the stack is empty, jump to the error block
LD R1, REGVAL3             ; Restore the value of R1
LDR R0, R6, #0              ; Load the value from the top of the stack
ST R7, REGVAL2             ; Save the return address
OUT                         ; Print the value
                    
ADD R6, R6, #1              ; Increment the stack INITIAL_VAL
ST R6, INITIAL_VAL              ; Update the stack INITIAL_VAL
LD R7, REGVAL2             ; Restore the return address
RET                         ; Return from the subroutine
ERRORS LEA R0, ERROR   ; Load address of the error message
PUTS                        ; Print the error message
HALT                        ; Halt the program
STARTER_ADDRESS .FILL xC000        ; Base address of the stack
ERROR .STRINGZ "STACK UNDERFLOW OR UNDERFLOW. HALTING PROGRAM"

; Subroutine to determine the letter grade based on the numeric score
CONVERT_TO_LETTER
AND R2, R2, #0
A_GRADE LD R0, GRADE_NUM_A  ; Load the minimum score for an 'A' grade
LD R1, GRADE_LETTER_A       ; Load the ASCII value for 'A'
ADD R2, R3, R0              ; Compare the score with the minimum score for 'A'
BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'A'
B_GRADE AND R2, R2, #0
LD R0, GRADE_NUM_B          ; Load the minimum score for a 'B' grade
LD R1, GRADE_LETTER_B        ; Load the ASCII value for 'B'
ADD R2, R3, R0              ; Compare the score with the minimum score for 'B'
BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'B'
C_GRADE AND R2, R2, #0
LD R0, GRADE_NUM_C          ; Load the minimum score for a 'C' grade
LD R1, GRADE_LETTER_C       ; Load the ASCII value for 'C'
ADD R2, R3, R0              ; Compare the score with the minimum score for 'C'
BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'C'
D_GRADE AND R2, R2, #0
LD R0, GRADE_NUM_D          ; Load the minimum score for a 'D' grade
LD R1, GRADE_LETTER_D       ; Load the ASCII value for 'D'
ADD R2, R3, R0              ; Compare the score with the minimum score for 'D'
BRzp STR_GRADE              ; If the score is greater than or equal to the minimum, store 'D'
F_GRADE AND R2, R2, #0
LD R0, GRADE_NUM_F          ; Load the minimum score for an 'F' grade
LD R1, GRADE_LETTER_F       ; Load the ASCII value for 'F'
ADD R2, R3, R0              ; Compare the score with the minimum score for 'F'
BRNZP STR_GRADE             ; Store 'F' for any score below the minimum for 'D'
RET
STR_GRADE ST R7, RETADDRESS1   ; Save the return address
AND R0, R0, #0
ADD R0, R1, #0              ; Move the letter grade to R0
JSR PUSH                    ; Push the letter grade onto the stack
LD R7, RETADDRESS1             ; Restore the return address
RET                         ; Return from the subroutine

; Constants for letter grade ranges
GRADE_NUM_A .FILL #-90            ; Minimum score for an 'A' grade (90)
GRADE_LETTER_A .FILL X41          ; ASCII value for 'A'
GRADE_NUM_B .FILL #-80            ; Minimum score for a 'B' grade (80)
GRADE_LETTER_B .FILL X42          ; ASCII value for 'B'
GRADE_NUM_C .FILL #-70            ; Minimum score for a 'C' grade (70)
GRADE_LETTER_C .FILL X43          ; ASCII value for 'C'
GRADE_NUM_D .FILL #-60            ; Minimum score for a 'D' grade (60)
GRADE_LETTER_D .FILL X44          ; ASCII value for 'D'
GRADE_NUM_F .FILL #-50            ; Minimum score for an 'F' grade (50)
GRADE_LETTER_F .FILL X46          ; ASCII value for 'F'

; Subroutine to clear registers R1-R6
EMPTY_R AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
RET                         ; Return from the subroutine

; Subroutine for data validation of user input
DATA_VALID ST R1, REGVAL3      ; Save the value of R1
ST R2, REGVAL2             ; Save the value of R2
ST R3, REGVAL1             ; Save the value of R3
LD R1, MINVAL             ; Load the minimum valid ASCII value ('0')
ADD R2, R0, R1              ; Compare the input with the minimum valid value
BRN INVALIDF                    ; If the input is less than the minimum, jump to the INVALIDF block
LD R1, MAXVAL             ; Load the maximum valid ASCII value ('9')
ADD R3, R0, R1              ; Compare the input with the maximum valid value
BRP INVALIDF                    ; If the input is greater than the maximum, jump to the INVALIDF block
LD R1, REGVAL3             ; Restore the value of R1
LD R2, REGVAL2             ; Restore the value of R2
LD R3, REGVAL1             ; Restore the value of R3
RET                         ; Return from the subroutine

; Branch for invalid input
INVALIDF LEA R0, FAIL_MSG       ; Load address of the failure message
PUTS                        ; Print the failure message
LD R0, LINEVAL
OUT                         ; Print a newline
LD R7, RESTART              ; Load the address for restarting the program
JMP R7                      ; Jump to the restart address
FAIL_MSG .STRINGZ "INVALID INPUT! RESTARTING PROGRAM..."
RESTART .FILL X3000         ; Address for restarting the program
MINVAL .FILL #-48         ; ASCII value for '0'
MAXVAL .FILL #-57         ; ASCII value for '9'
LINEVAL .FILL XA           ; ASCII value for newline
.END                        ; End of the program