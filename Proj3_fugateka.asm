TITLE Data Validation, Looping, and Constants	(Proj3_fugateka.asm)

; AUTHOR: Kaden Fugate
; LAST MODIFIED: July 21th, 2023
; OSU EMAIL ADDRESS: fugateka@oregonstate.edu
; COURSE NUMBER/SECTION: CS 271 SECTION 400
; PROJECT NUMBER: 3 	DUE DATE: July 23th, 2023
; DESCRIPTION: This program will begin by displaying the programs title and programmer name (Kaden Fugate)
; after this it will ask for the users name. After getting the users name, the program will ask the user for 
; numbers within [-200,-100], [-50,-1] range until they enter a non-negative number. The program will number
; the line while getting each user input for EXTRA CREDIT. After a non-negative number has been entered
; the program will display the amount of valid numbers entered by the user, the max valid number, the min
; valid number, the average rounded to the nearest whole number and as EXTRA CREDIT, the number rounded
; to the nearest 2 digits. The program will then give an outgoing message including the users name. 

; EC: THIS PROGRAM CONTAINS TWO EXTRA CREDIT OPTIONS:

; 1. The program will number the lines when getting user input. For example, 'Enter number 1', 'Enter number 2', 
; etc. For my program I opted for 'Enter your 1st number', 'Enter your 2nd number', etc. for formatting reasons. 
; Because of this, there is some extra work done in the program labeled '__get_postfix'. [1 POINT]

; 2. The program will get the average number to 2 decimal place accuracy. For example, 'Average: 20.01', 'Average: 59.91', 
; 'Average: 0.02'. As noted in the assignment, this is achieved without using the FPU. To do this, it involves moving the 
; average to the left by two digits (multiply by 100). Along with this, some math magic with remainders is used. Along with 
; this, the program will still determine the average rounded to the nearest integer. [2 POINTS]


INCLUDE Irvine32.inc

.data

	; Below are the messages that the program will have to display to fully funtion
	intro_message					BYTE 	"Welcome to the Integer Accumulator by Kaden Fugate",0
	description_message 			BYTE 	"We will be accumulating user-input negative integers between the specified bounds, then displaying statistics of the input values including minimum, maximum, and average values values, total sum, and total number of valid inputs.",0
	get_name_message 				BYTE 	"What is your name?: ",0
	greet_message 					BYTE 	"Hello there, ",0
	range_instruction_message 		BYTE 	"Please enter numbers in [-200, -100] or [-50, -1].",0
	get_results_instruction_message BYTE 	"Enter a non-negative number when you are finished to see results.",0
	get_num_message_1 				BYTE 	"Enter your ",0
	get_num_message_2				BYTE 	"number: ",0
	st_postfix						BYTE	"st ",0				; all_postfix will be used for numbering lines for EXTRA CREDIT
	nd_postfix						BYTE	"nd ",0
	rd_postfix						BYTE	"rd ",0
	th_postfix						BYTE	"th ",0
	invalid_number_message 			BYTE 	"Number Invalid!",0
	num_counter_message_1 			BYTE 	"You entered ",0	; First half of # of valid num output
	num_counter_message_2 			BYTE 	" valid numbers:",0 ; Second half of # of valid num output
	max_message 					BYTE 	"The maximum valid number is: ",0
	min_message 					BYTE 	"The minimum valid number is: ",0
	sum_message 					BYTE 	"The sum of your valid numbers is: ",0
	round_avg_message 				BYTE 	"The rounded average is ",0
	dec_avg_message					BYTE	"The average rounded to two decimals is: ",0
	decimal_point					BYTE	".",0
	exclamation_point				BYTE	"!",0
	outro_message 					BYTE 	"Thanks for checking out my program! Have a good day, ",0
	zero_valid_num_message_1		BYTE	"Sorry, ",0
	zero_valid_num_message_2		BYTE	" You didn't enter any valid numbers so no results can be displayed!",0
	extra_credit_message_1			BYTE	"EC: THIS PROGRAM CONTAINS TWO EXTRA CREDIT OPTIONS:",0
	extra_credit_message_2_1		BYTE	"1. The program will number the lines when getting user input. For example, 'Enter number 1', 'Enter number 2', etc. For my program I opted for 'Enter your 1st number',",0
    extra_credit_message_2_2        BYTE    "'Enter your 2nd number', etc. for formatting reasons. Because of this, there is some extra work done in the program labeled '__get_postfix'. [1 POINT]",0
	extra_credit_message_3_1		BYTE	"2. The program will get the average number to 2 decimal place accuracy. For example, 'Average: 20.01', 'Average: 59.91', 'Average: 0.02'. As noted in the assignment,",0
    extra_credit_message_3_2        BYTE    " this is achieved without using the FPU. To do this, it involves moving the average to the left by two digits (multiply by 100). Along with this, some math magic with",0 
    extra_credit_message_3_3        BYTE    "remainders is used. Along with this, the program will still determine the average rounded to the nearest integer. [2 POINTS]",0

	; Below are the bounds in which the user can enter valid numbers
	; Bounds are constants.
	BOTTOM_RANGE_LOWER 				= 		-200
	BOTTOM_RANGE_UPPER				=		-100
	TOP_RANGE_LOWER					=		-50
	TOP_RANGE_UPPER					=		-1

	; Below are variables that are used in the program to dynamically store data
	user_name 						BYTE 	101 	DUP(?) 		; Will be used to store the name that the user enters
	sum  							SDWORD	0 					; Will be used to sum of all valid numbers
	valid_nums						DWORD 	0 					; Will be used to count num of valid nums
	round_avg						SDWORD	?					; Will hold the rounded average
	ceil_avg						SDWORD	?					; Will hold average before decimal point for EXTRA CREDIT
	after_dec						DWORD	?					; Will hold 2 decimals for EXTRA CREDIT
	max								SDWORD	-201				; Will hold max, initialized to -201 because min valid num is -200
	min								SDWORD	0					; Will hold min, initialized to 0 because max valid num is -1

.code
main PROC

	; Output intro message to user
	MOV		EDX,	OFFSET	intro_message
    CALL    WriteString
	CALL	CrLf

	; Output program description to user
	MOV		EDX, 	OFFSET	description_message
	CALL 	WriteString
	CALL	CrLf
	CALL 	CrLf

	; DISPLAY EXTRA CREDIT PART 1!
	MOV		EDX,	OFFSET 	extra_credit_message_1
	CALL 	WriteString
	CALL	CrLf
    Call    CrLf

    ; DISPLAY EXTRA CREDIT PART 2!
	MOV		EDX,	OFFSET	extra_credit_message_2_1
	CALL	WriteString
	MOV		EDX,	OFFSET	extra_credit_message_2_2
	CALL	WriteString
	CALL	CrLf
    CALL    CrLf

    ; DISPLAY EXTRA CREDIT PART 3!
	MOV		EDX,	OFFSET	extra_credit_message_3_1
	CALL	WriteString
    MOV		EDX,	OFFSET	extra_credit_message_3_2
	CALL	WriteString
    MOV		EDX,	OFFSET	extra_credit_message_3_3
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

	; Ask for users name
	MOV		EDX, 	OFFSET	get_name_message
	CALL 	WriteString

	; Get users name
	MOV		EDX, 	OFFSET	user_name 					; Load user_name into EDX so it can hold users input
	MOV 	ECX, 	100									; Load 100 to ECX because max of 100 chars can be passed as user's name
	CALL 	ReadString 									; Read user input with max len of val stored in ECX and store val in EDX

	; Greet user
	MOV 	EDX, 	OFFSET	greet_message 				; Write first half of output
	CALL 	WriteString
	MOV 	EDX, 	OFFSET	user_name 					; Write users name for second half
	CALL	WriteString
	CALL 	CrLf
	CALL 	CrLf

	; Give program instructions
	; RANGE INSTRUCTION
	MOV		EDX, 	OFFSET	range_instruction_message 	; Instructions about range
	CALL 	WriteString
	CALL CrLf
	
	; GET PROGRAM RESULT INSCRUCTION
	MOV 	EDX, 	OFFSET	get_results_instruction_message
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf
;------------------------------------------------------------------------------------------------------------
;	__num_loop

;	This section of code will be jumped to after the user has successfully entered a valid number and after
;	the program has added the new number to the average. Along with this, this section of code will start
;	by getting the users number. As EXTRA CREDIT, this section will also increment the line number during 
;	user input (i.e. "please enter the 3rd number: ", "please enter the 1st number: ", etc.). 
;------------------------------------------------------------------------------------------------------------
__num_loop:

	; Print first half of message
	MOV		EDX,	OFFSET	get_num_message_1
	CALL	WriteString

	JMP 	__get_postfix 							; Get postfix (valid nums + 1) for numbering line EXTRA CREDIT
__got_postfix: 										; Jump back here when done getting postfix

	; Write the values gotten in __get_postfix
	; One will be an unsigned decimal in EAX and the other a string in EDX
	CALL 	WriteDec 					
	CALL 	WriteString 				

	; Finish printing message to get user number
	MOV 	EDX, 	OFFSET	get_num_message_2
	CALL 	WriteString

	CALL	ReadInt 								; Get users number, stores in EAX
	JMP		__check_num								; Check if num valid

__num_valid:

	; Add new valid num to sum, increment valid_num counter
	ADD		sum,	EAX								; sum += EAX

	JMP		__check_min

__min_max_checked:

	MOV		EAX,	valid_nums
	INC		EAX
	MOV		valid_nums,	EAX 						; valid_nums++

	JMP		__num_loop								; get next num

;------------------------------------------------------------------------------------------------------------
;	__get_postfix
;
;	This section of code will determine what string to put after the numbered line for EXTRA CREDIT. The
;	"postfix" name is being used to label the "st", "nd", "rd", and "th" parts of 1st, 2nd, 3rd, and 4th.
;	This section is basically purely for output formatting.
;------------------------------------------------------------------------------------------------------------
__get_postfix:

	; will get postfix
	MOV		EAX,	valid_nums 						; Get valid nums
	INC		EAX 									; increment to valid nums + 1
		
	; Will check if valid nums + 1 is greater than or equal to 4
	; If true, postfix for current num will be "th"
	CMP		EAX,	4 								; Compare 4 to valid nums + 1
	MOV		EDX,	OFFSET	th_postfix 				; Move "th" to edx to be printed
	JGE 	__got_postfix 							; If 4 >= valid nums + 1 jump back to getting user num

	; Will check if valid nums + 1 is equal to 3
	; If true, postfix for current num will be "rd"
	CMP 	EAX, 	3
	MOV		EDX,	OFFSET	rd_postfix
	JE 		__got_postfix 							

	; Will check if valid nums + 1 is equal to 2
	; If true, postfix for current num will be "nd"
	CMP		EAX, 	2
	MOV		EDX,	OFFSET	nd_postfix
	JE		__got_postfix							

	; Postfix will be set to "st"
	MOV		EDX,	OFFSET	st_postfix
	JMP		__got_postfix 							
;------------------------------------------------------------------------------------------------------------
;	__check_num
;
;	This section of code will determine if the number entered by the user is valid. When entering this section
;	of code, EAX holds the value of the last entered user num.
;------------------------------------------------------------------------------------------------------------
__check_num:
	CMP		EAX,	0
	JNS		__display_results						; If NOT sign flag (num >= 0), display results.

	CMP		EAX,	BOTTOM_RANGE_LOWER
	JL		__invalid_num							; if num < -200, num is invalid

	CMP		EAX,	BOTTOM_RANGE_UPPER
	JLE		__num_valid								; Num is valid because bottom_range_lower <= num <= bottom_range_upper
	JG		__gt_bottom_range_upper					; Jump to check second range
;------------------------------------------------------------------------------------------------------------
;	__gt_bottom_range_upper
;
;	This section of code will determine if the number is in the second given range. i.e. it will determine
;	if the val <= [-50,-1] part of the [-200,-100] <= val <= [-50,-1] statement is true.
;------------------------------------------------------------------------------------------------------------
__gt_bottom_range_upper:
	CMP		EAX,	TOP_RANGE_LOWER					; CMP EAX to -50
	JL		__invalid_num							; if val < -50, then invalid because its in -99 to -51 range

	CMP		EAX,	TOP_RANGE_UPPER					; CMP EAX to -1
	JLE		__num_valid								; if val <= -1, then num is in -50 to -1 range
__invalid_num:

	; Write invalid num message to output
	MOV		EDX,	OFFSET	invalid_number_message
	CALL	WriteString
	CALL	CrLf

	JMP		__num_loop								; Get new user num without incrementing valid num

;------------------------------------------------------------------------------------------------------------
;	__check_min, __set_min, __check_max, __set_max
;
;	The sections listed above will take care of identifying if a valid number is either a new max OR a new
;	min number. Each time checking min will also check max due to the fact that a number that is entered
;	can be both a max and min number.
;------------------------------------------------------------------------------------------------------------
__check_min:

	CMP		EAX,	min
	JGE		__check_max								; Jump to checking max if EAX >= min

	MOV		min,	EAX								; If EAX < min, set new min

__check_max:

	CMP		EAX,	max		
	JLE		__min_max_checked						; If EAX <= max, no new max found

	MOV		max,	EAX
	JMP		__min_max_checked
;------------------------------------------------------------------------------------------------------------
;	__display_results
;
;	This section of code will display the results for the user. These results include valid_nums, max, min
;	round_avg, and decimal_avg. After this, it will display the ending message containing the users name.
;------------------------------------------------------------------------------------------------------------
__display_results:

    CALL    CrLf
	
	; Check if there are zero valid entered numbers
	MOV		EAX, 	valid_nums
	CMP		EAX,	0
	JE		__zero_valid_num_display				; Output special message if zero valid numbers

	JMP		__get_results
__got_results:										; Jump here after results are gotten

	; This code will write the amount of valid numbers entered
    MOV     EDX,    OFFSET  num_counter_message_1
    MOV     EAX,    valid_nums

    CALL    WriteString
    CALL    WriteDec

    MOV     EDX,    OFFSET  num_counter_message_2

    CALL    WriteString
    CALL    CrLf
    CALL    CrLf

	; This code will write the max valid number
	MOV		EDX,	OFFSET	max_message
	MOV		EAX,	max

	CALL	WriteString
	CALL	WriteInt
    CALL    CrLf

	; This code will write the min valid number
	MOV		EDX,	OFFSET	min_message
	MOV		EAX,	min

	CALL	WriteString
	CALL	WriteInt
    CALL    CrLf

	; This code will write the sum to the user
	MOV		EDX,	OFFSET	sum_message
	MOV		EAX,	sum
	
	CALL	WriteString
	CALL	WriteInt
	CALL	CrLf

	; This code will write the users rounded average
	MOV		EDX,	OFFSET	round_avg_message
	MOV		EAX,	round_avg

	CALL	WriteString
	CALL	WriteInt
	CALL	CrLf

	; This code will write the users average to 2 decimal places as EXTRA CREDIT
	MOV		EDX,	OFFSET	dec_avg_message
	MOV		EAX,	ceil_avg

	CALL	WriteString
	CALL	WriteInt

	MOV		EDX,	OFFSET	decimal_point
	MOV		EAX,	after_dec

	CALL	WriteString
	CALL	WriteDec
	CALL	CrLf
    CALL    CrLf

	; Display goodbye message to user
	MOV		EDX,	OFFSET	outro_message
	CALL	WriteString

	MOV		EDX,	OFFSET	user_name
	CALL	WriteString

	MOV		EDX,	OFFSET	exclamation_point
	CALL	WriteString

	JMP		__end_program

__zero_valid_num_display:

	; Display special goodbye message to user
	MOV 	EDX,	OFFSET	zero_valid_num_message_1
	CALL	WriteString

	MOV		EDX,	OFFSET	user_name
	CALL	WriteString

	MOV		EDX,	OFFSET	exclamation_point
	CALL	WriteString

	MOV		EDX,	OFFSET	zero_valid_num_message_2
	CALL	WriteString

	JMP		__end_program

;------------------------------------------------------------------------------------------------------------
;	__get_results
;
;	This section of code will get the average of the valid numbers entered. Along with this, as EXTRA CREDIT,
;	the program will round to the nearest 2 decimals
;------------------------------------------------------------------------------------------------------------
__get_results:
    
	; Get average rounded to 2 decimal places (i.e. 100.32, 20.51, 30.20) for EXTRA CREDIT
	MOV 	EAX,	sum
	MOV     EBX,    100

	MUL		EBX          				    		; Multiply sum by 100 to move whole number to left by 2 decimal places

    CDQ												; EDX:EAX
	IDIV	valid_nums								; Gets average moved to left by 2 decimal places (x.xx) for 2 decimals
    
    CDQ												; EDX:EAX
	IDIV 	EBX										; 2 decimal precision stored in EDX, average rounded towards 0 stored in EAX

	; Store the details of average number
	MOV		ceil_avg,	EAX							
    MOV		after_dec,	EDX
    NEG     after_dec								; Remaider is negative, negate to get true 2 point precision decimal

	; The following code will get the rounded average using the previously found average
    MOV     EDX,    after_dec
	CMP		EDX,	50

	MOV		round_avg,	EAX							; Store CEILING(average) in round_avg for now
	JLE		__got_results							; If numbers after decimal <= 50, CEILING(average) is correct

	DEC		EAX										
	MOV		round_avg,	EAX							; ELSE, round down

	JMP		__got_results

__end_program:
	Invoke 	ExitProcess, 0  						; exit to operating system
main ENDP

END main