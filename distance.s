//I pledge my honor that I have abided by the Stevens Honor System. -Isabella Stone
.text
.global _start
.extern printf

_start:
	mov x8,  #0        /* outer index i*/
	mov	x9,  #0	       /* inner index j*/

	adr	x0, max
	ldur	d10, [x0]
	fmov	d9, d10  	/*load max to d9*/
	adr	x0, min
	ldur	d10, [x0]
	fmov	d18, d10  	/*load min to d18*/
	adr 	x0, x
	adr	x2, y
	mov	x3, #0
	mov	x4, #1

	mov	x5, #0          //for min
	mov	x6, #1          //for min

	bl outer_loop

outer_loop:             //loops through every element  
l1:	cmp x8, #8          //compare i and size
	b.ge exit           //if i >= size, done so go to exit to print
	bl inner            //go to inner loop for each element
ret:add x8, x8, 1       //i++
	add x9, x8, 1       //j = i + 1 (dont want to start at same index)
	b l1                //branch back to l1

inner:
	mov	x11, #8
	mul	x10, x8, x11
	ldr	d10, [x0, x10]   /* load xi*/
	ldr	d11, [x2, x10]   /* load yi*/
	
	mul	x10, x9,x11
	ldr	d12, [x0, x10]   /* load xj*/
	ldr	d13, [x2, x10]   /* load yi*/
	cmp	x9, #8
	b.ge ret             //need to update i again
	bl 	distance

innerindex:
	add	x9, x9, #1
	bl 	inner


distance:
	fsub	d10, d10, d12
	fmul	d10, d10, d10
	fsub	d11, d11, d13
	fmul	d11, d11, d11
	fadd 	d11, d10, d11

	fcmp d11, d9              //if d11 >= d9 (max)
	b.ge	updatemax     

	fcmp d11, d18             //if d11 <= d18 (min)
	b.le updatemin

	bl	innerindex

updatemax:
	fmov d9, d11
	mov	x3, x8
	mov	x4, x9
	bl innerindex

updatemin:
	fmov d18, d11
	mov	x5, x8
	mov	x6, x9
	bl	innerindex

exit:
	ldr x0, =printarr
	mov	x1, x3
	mov	x2, x4
	mov	x3, x5
	mov	x4, x6
	bl printf

	mov x0, 0
	mov x8, 93
	svc 0
	
.data
N:
	.dword 7
max: 
	.double 0.0
min:
	.double 10000000000000000000000000000.0
x:
	.double  0.0, 0.4140, 1.4949, 5.0014, 6.5163, 10.9303, 8.4813, 2.6505
y:
	.double 0.0, 3.9862, 6.1488, 1.047, 4.6102, 11.4057, 5.0371, 4.1196
printarr:
	.ascii "Largest distance: x,y index is: %d %d \nSmallest distance: x,y index is: %d %d \n\0"

.end














