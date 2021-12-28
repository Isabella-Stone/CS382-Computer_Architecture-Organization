//I pledge my honor that I have abided by the Stevens Honor System. -Isabella Stone
.text
.global _start
.extern printf 
.extern scanf

_start:
	adr x0, a
	ldur d0, [x0]
	fmov d1, d0      //put a into d1
	adr x0, b
	ldur d0, [x0]
	fmov d5, d0      //put b into d5
	adr x0, n
	ldur d0, [x0]
	fmov d2, d0      //put n into d2
	adr x0, sum
	ldur d0, [x0]
	fmov d10, d0     //put sum into d10***will be final answer***
	adr x0, fx
	ldur d0, [x0]
	fmov d11, d0     //put fx into d11
	adr x0, w
	ldur d0, [x0]
	fmov d21, d0     //put w into d21
	adr x0, actual
	ldur d0, [x0]
	fmov d23, d0     //put w into d23
	

	fmov d12, 1      //i var********
	fmov d9, 1       //to increment i

	//holders to calculate f(x)
	fmov d17, 1      //put s1 into d17
	fmov d18, 1      //put s2 into d18
	fmov d19, 1      //put s3 into d19

	//fmov d5, 5     //b variable
	fmov d13, 2.5    //put 2.5 into d13
	fmov d16, 15.5   //put 15.5 into d16
	fmov d20, 20     //put 20 into d20
	fmov d15, 15     //put 15 into d15

	bl rectangle_func
	bl rectangle_end

rectangle_func:
    sub sp, sp, 8       //Allocate
	stur lr, [sp, 0]

	fsub d21, d5, d1    //d21=d5-d1, w=(b-a)/n
	fdiv d21, d21, d2   //divide by n

l1: fcmp d12, d2        //check i ... n
	b.gt ex             //if i > n, then exit
	fmov d22, d12       //d22 is i
	fsub d22, d22, d9   //newi-1
	fmul d22, d22, d21  //d22*=d21, newi*=w
	fadd d22, d22, d1   //d22+=d1, newi+=a
    bl find_fx          //calculate f(x) //
	fmul d11, d11, d21  //d11*=d21, fx*=w //answer*=w
	fadd d10, d10, d11  //add f(x) to sum
	fadd d12, d12, d9   //i++
	b l1                //go back to top of loop
ex:	ldur lr, [sp, 0]
    add sp, sp, 8
	br lr

find_fx:
	//y = 2.5x^3 − 15.5x^2 + 20x + 15, needs to fill d11 with f(x). where x is d22
	sub sp, sp, 8         //Allocate
	stur lr, [sp, 0]
	fmul d17, d22, d22    //d17 = d22*d22
	fmul d17, d17, d22    //d17 now holds d12^3
	fmul d17, d17, d13    //d17 is now 2.5x^3
	fmul d18, d22, d22    //d18 now holds x^2
	fmul d18, d18, d16    //d18 now holds 15.5x^2
	fmul d19, d20, d22    //d19 now holds 20x
	fsub d11, d17, d18    //d10=d17-d18, sum = 2.5x^3-15.5x^2
	fadd d11, d11, d19    //d10+=d19, sum += 20x
	fadd d11, d11, d15    //d10+=d15, sum += 15
	ldur lr, [sp, 0]
    add sp, sp, 8
	br lr
            
rectangle_end:
	adr x0, str          //print approximation
	fmov d0, d10
	bl printf
	adr x0, str2         //print actual
	fmov d0, d23
	bl printf
	fsub d23, d23, d10   //print difference
	adr x0, str3         
	fmov d0, d23
	bl printf
	mov x0, #0
    mov w8, #93
    svc #0
   

.data
a:      .double -.5  
b:		.double 5      
n:		.double 1000000     
w: 		.double 0
sum:    .double 0
fx:     .double 0
actual: .double 74.106978

str:    .ascii "approximation: %lf\n\0"
str2:   .ascii "actual value:  %lf\n\0"
str3:   .ascii "difference:    %lf\n\0"

.end
