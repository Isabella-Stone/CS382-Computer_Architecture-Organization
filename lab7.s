//I pledge my honor that I have abided by the Stevens Honor Systsem. -Isabella Stone
.text
.global _start



_start:
	adr x22, arr       //put base of array in x22
	ldr x1, len        //x1 is len
	bl max_func
	mov x1, x0
	bl max_end  
	
	
	

max_func:
		sub sp, sp, 16     
		stur lr, [sp, 8]
		stur x1,[sp, 0]
		cbz x1, x              //base case so return
		sub x1, x1, 1          //i = i-1
		bl max_func            //recursive call
		b y
x:		lsl x15, x1, 3         //shift i to get a[i]
		add x15, x15, x22       //add shift to base address to get a[i]
		mov x0, x15
		ldur x0, [x0, 0]       //x0 now holds it
		br lr
y:		ldur x1, [sp, 0]       //i
		lsl x13, x1, 3         //shift i
		add x13, x13, x22      //add shift to base address
		mov x19, x13
		ldur x14, [x19, 0]     //x14 has a[i] now
		sub x18, x0, x14
		cmp x18, 0             //check if new element is greater, if so go to z branch
		b.gt z
		mov x0, x14	
z:		ldur lr, [sp, 8]   
		add sp, sp, 16      
		br lr
		
		
max_end:
	ldr x0, =print_num
	bl printf
	mov x0, #0
	mov w8, #93
	svc #0
	
	
	
.data
arr:
	.dword 1025,3,2988,700,9,100,200
len:
	.quad 7
	
	
	
print_num:
	.ascii "%d\n\0"	
	.end

