//I pledge my honor that I have abided by the Stevens Honor System. -Isabella Stone
.text
.global _start
.extern printf 

_start:
        adr x0, tol
	ldur d0, [x0]
	fmov d1, d0            //put tol into d1
        adr x0, a
	ldur d0, [x0]
	fmov d2, d0            //put a into d2
        adr x0, b
	ldur d0, [x0]
	fmov d22, d0           //put b into d22
        adr x14, coeff
        ldr x13, N             //x13 is highest coeff of array
        fmov d10, d2           //initalize c as a; will be final answer***
        mov x10, 0

        adr x16, zero
        ldur d26, [x16]
        fmov d25, d2           //put a(d2) into func(uses d25)
        bl _func
        fmov d12, d26

        adr x16, zero
        ldur d26, [x16]
        fmov d25, d22          //put b(d22) into func(uses d25)
        bl _func
        fmov d13, d26 

        //error checking
        fmul d14, d12, d13    //d14=d12*d13; d14=f(a)*f(b)
        adr x16, zero
        ldur d21, [x16]
        fcmp d14, d21         //compare f(a)*f(b) to 0
        b.ge _error

        bl _bisection
        bl _end

_bisection:
        sub sp, sp, 8          //Allocate
	stur lr, [sp, 0]
while:  fsub d20, d22, d2      //d20=d22-d2; d20=b-a
        fcmp d20, d1
        //b.lt _end            /if less than d1(tolerance), break
        b.lt quit              //if less than, quit

        bl find_mid            //find middle point and set c to it, d10

        adr x16, zero
        ldur d26, [x16]
        fmov d25, d10          //put c(d10) into func(uses d25)
        bl _func
         
        fcmp d26, 0            //check if f(c)==0 (d26 is now f(c))
        b.eq _end              //if ==0 --> done (root is found) ***exit

skip:   fmov d17, d26          //put f(c) into d17
        adr x16, zero
        ldur d26, [x16]
        fmov d25, d2           //put a into d25 for func to use
        bl _func
        fmov d18, d26          //put f(a) into d18
        fmul d19, d17, d18     //d19=d17*d18, d19=f(a)*f(c)
        //fcmp d19, 0
        adr x19, zero
        ldur d16, [x19]
        fcmp d19, d16          //d16 is 0.0***
        b.ge else
        fmov d22, d10          //d22=d10; b=c
        b while
else:   fmov d2, d10           //d2=d10; a=c
        b while
quit:   ldur lr, [sp, 0]
        add sp, sp, 8
        br lr

find_mid: 
        sub sp, sp, 8          //Allocate
	stur lr, [sp, 0]
        //puts mid into d10
        fmov d29, 2
        fadd d10, d2, d22      //d10=d2+d22; c=a+b
        fdiv d10, d10, d29     //d10=d10/d29; c=c/2
        ldur lr, [sp, 0]
        add sp, sp, 8
        br lr



_func: 
//put into register d25 always, then transfer , uses d25 as x, puts value of fucntion into d26
        sub sp, sp, 8          //Allocate
	stur lr, [sp, 0]
        mov x1, 0              //x1 is i starting at 0, and x13 is n
outer:  cmp x1, x13
        b.gt done              //if x1 > x13, i > N, done
        lsl x10, x1, 3         //lsl i value
        add x10, x10, x14      //add base of array
        ldur d15, [x10]        //load coeff at index i into d15******
        mov x2, 2              //start j variable at 2
        cmp x1, 0
        b.eq if
els:    cmp x1, 1
        b.gt branch            //if > 1 (so minimum 2, go to inner func)  
        fmov d23, d25          //if coeff is 1, put x in innersum and skip call to inner func   
        b skp
if:     fmov d23, 1            //if coeff is 0, put 1 in innersum and skip call to inner func
        b skp
branch: bl _func_inner
skp:    fmul d15, d15, d23     //d15=d15*d23, coeff=coeff*innersum
        fadd d26, d26, d15     //d26=d26+d15, final = final+(coeff*innersum)
        cmp x1, x13
        b.eq done              //if x1 == x13, i == N, done ****
        add x1, x1, 1          //increment i by 1 ****
        b outer                //go back to outer loop
done:   ldur lr, [sp, 0]
        add sp, sp, 8
        br lr


_func_inner:  
        sub sp, sp, 8          //Allocate
	stur lr, [sp, 0]
        fmov d23, d25          //d23 now holds x
l2:     cmp x2, x1             //if x2 > x1, if j > exponent(i var), done
        b.gt d_in 
        fmul d23, d23, d25     //sum*=x
        add x2, x2, 1          //increment j by 1 before returing to inner loop
        b l2
d_in:   ldur lr, [sp, 0]
        add sp, sp, 8
        br lr 

_error:
        adr x0, str2            //print error message         
	bl printf
        mov x0, #0
        mov w8, #93
        svc #0

_end:
        adr x0, str            //print c
        fmov d0, d10           //c register
	bl printf
        adr x0, s              //print f(c)
        fmov d0, d26           
	bl printf
        mov x0, #0
        mov w8, #93
        svc #0
	
	
	
.data
coeff:  .double 0.2, 3.1, -0.3, 1.9, 0.2 //-.0625
N:      .quad 4
a:      .double -1
b:      .double 1
tol:    .double .01
zero:   .quad 0

//extra test cases:
//coeff: .double -.7, .5, -2, 2, 0.8  //.871
//coeff:  .double -0.2, 3.1, -0.3, 1.9, 0.2 //.0625
//coeff:  .double -.24, 2, -2.3, -5.4, 3, -7, -9 //-.7109
//coeff:  .double -.24, 2, -2.3, -5.4, 3, -7, 9 //-.578
//coeff:  .double -.24, 2, -2.3, -5.4, 3, -7 //-.619
//coeff:  .double -3.4, 2, 0.0, -5.4 //-1
//coeff:  .double 10, 0.0, 0.0, 0.0, 0.0, 5 //-1.148
//coeff:  .double 1, 7, 0.0, -22, 1  //.63
//coeff:  .double 0.0, 7, -8, 9, 1 //0
//coeff:  .double 5, 7, -8, 9, -2 //-.41
//coeff:  .double -.5, 7.2, 0.0, -5.4 //-.07
//coeff:  .double 5.3,0.0,2.9,-3.1 //1.6
//coeff:  .double 0.25, 1  //-.25

str:    .ascii "The root is: x = %lf\n\0"
s:      .ascii "The value of the function at x is: %lf\n\0"
str2:   .ascii "A and B values must be of opposite signs.\n\0"

	
.end

