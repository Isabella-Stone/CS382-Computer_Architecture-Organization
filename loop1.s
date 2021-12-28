//I pledge my honor that I have abided by the Stevens Honor Systsem. -Isabella Stone 
.text
.global _start

_start:
	.global loop1_func
	
loop1_func:           
		mov x10, #1                //initialize i var to 1
		mov x1, #0                 //initialize counter to 0
Loop:   sub x11, x10, #11          //x11 = i - 11, will be 0 when loop is done
		cbz x11, Exit              //check that X11 is not 0
		add x1, x1, x10            //X1 += X10 / i
		add x10, x10, #1           //increment X10 by 1
		b Loop                     //go back to loop
Exit:


loop1_end:
	ldr x0, =print_num
	bl printf
	mov x0, #0
	mov w8, #93
	svc #0
	.data
	
print_num:
	.ascii "%d\n\0"	
	.end


