//I pledge my honor that I have abided by the Stevens Honor Systsem. -Isabella Stone
.text
.global _start

_start:
	.global if2_func
	
if2_func: 
		ldr x11, =in1
		ldr x2, [x11]
		ldr x12, =in2
		ldr x3, [x12]
		add x5, x2, x3
		sub x6, x5, #14
		cbnz x6, else
		mov x1, #3
		b done
else:	mov x1, #-2
done:


if2_end:
	ldr x0, =print_num
	bl printf
	mov x0, #0
	mov w8, #93
	svc #0
	.data

in1:
	.quad 9
in2:
	.quad 11
	
print_num:
	.ascii "%d\n\0"	
	.end
