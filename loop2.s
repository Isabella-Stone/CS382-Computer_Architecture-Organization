//I pledge my honor that I have abided by the Stevens Honor Systsem. -Isabella Stone 
.text
.global _start

_start:
	.global loop2_func
	
loop2_func:         
		ldr x19, =in1
		ldr x20, [x19]             //x20 holds original id
		mov x1, #0
		mov x10, #10
		mov x8, #0                 //counter
Loop:	sub x9, x8, #8             //x9 = x8 - 8, will be 0 when loop is done
		cbz x9, Exit               //exit when x9 == 0
		mov x18, x20               //x18 = id
		sdiv x20, x20, x10             
		mul x20, x20, x10          //temporarily makes last digit 0
		sub x2, x18, x20           //finds last digit
		add x1, x1, x2             //adds digit
		sdiv x20, x20, x10         //permanently gets rid of last digit
		add x8, x8, #1             //increments counter by 1
		b Loop
Exit: 
		

loop2_end:
	ldr x0, =print_num
	bl printf
	mov x0, #0
	mov w8, #93
	svc #0
	.data
	
	

in1:
	.quad 12602471
	
	
print_num:
	.ascii "%d\n\0"	
	.end


