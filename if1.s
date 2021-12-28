//I pledge my honor that I have abided by the Stevens Honor Systsem. -Isabella Stone
.text
.global _start

_start:
	.global if1_func
	
if1_func: 
		ldr x6, =in1
		ldr x5, [x6]
		ldr x12, =in2
		ldr x2, [x12]
		sub x9, x5, #4
		cbnz x9, else
		add x1, x2, #1
		b done
else:	sub x1, x2, #2
done:

if1_end:
	ldr x0, =print_num
	bl printf
	mov x0, #0
	mov w8, #93
	svc #0
	.data

in1:
	.quad 3
in2:
	.quad 15
	
print_num:
	.ascii "%d\n\0"	
	.end
