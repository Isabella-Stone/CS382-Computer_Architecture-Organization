//I pledge my honor that I have abided by the Stevens Honor System. -Isabella Stone
.text
.global _start

_start:
	mov x19, #0   //loop variable
	mov x8, #63
	mov x18, #0
	mov x9, #0    //total sum
	mov x10, #10  //to use digit 10

loop:
	//load the data
	//set the nbyte number
	//systemcall
	//compare the input character; branch back to loop if character is not '\n' (10), (use ASCII value to do the comparison)
	mov x0, 0
	adr x1, buf
	add x1, x1, x19
	mov x2, 1
	svc 0
	ldr x4, [x1, 0]           //takes in ASCII
	cmp x4, 10
	b.eq done
	sub x4, x4, 48
	mul x9, x9, x10
	add x9, x9, x4
	add x19, x19, 1           //increment x19 before heading back to loop again
	b loop
	adr x1, buf     
done: mul x9, x9, x9          //square final answer
	mov x13, 0                //use as i for next loop implementation

implementation:
	udiv x25, x9, x10         //x25 is final answer divided by 10
	mul  x3, x25, x10         //X3 = x25 * x10
	sub  x26, x9, x3          //gets remainder in x26
	add x26, x26, 48          //gets back to ascii
	adr x1, buf
	add x1, x1, x13
	mov x2, 1
	lsl x27, x13, 3
	add x28, x27, x1
	stur x26, [x28, 0]         //takes in ASCII
	add x13, x13, 1
	mov x9, x25                //update 'final' number
	cmp x25, 0
	b.ne implementation

//x/10cb &buf, use to print once you get to the breakpoint you made at exit

exit:
		lsl x10, x13, 3        //left shift
		add x11, x10, x1
		mov x12, x1
		sub x12, x12, 8
		mov x1, x11
p_loop:	sub x22, x1, x12
		cmp x22, 0
		b.lt leave
		mov x2, 1
		mov x0, 1
		mov x8, 64
		svc 0
		sub x1, x1, 1
		b p_loop
leave:  mov x0, 0
		mov x8, 93
		svc 0

.bss	
buf: .skip 1000

.end







