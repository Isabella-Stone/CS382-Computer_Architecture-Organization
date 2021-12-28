//I pledge my honor that I have abided by the Stevens Honor System. -Isabella Stone
.text
.global _start
.extern printf 
.extern scanf

_start:
        adr x22, arr        //put base of array in x22
        ldr x27, len        //x27 is len
        mov x12, x27         
        sub x12, x12, 1     //x12 = len-1
        mov x11, 0          //x11 is i counter, starts at 0
        mov x8, 0           //to use to check loop1
        bl sort_func
        mov x1, x22   
        bl binary_search      
        bl sort_end  

sort_func:
            sub sp, sp, 8      //Allocate
	    stur lr, [sp, 0]
loop1:      sub x8, x11, x12
            cbz x8, exit        //check i <= len-1, if x11-x12=0, done so exit
            mov x20, x11        //x20=min index, and initially holds i
            bl find_min
            bl swap
            add x11, x11, 1     //i+=1
            b loop1
exit:	    ldur lr, [sp, 0]
            add sp, sp, 8
            br lr

find_min:
        sub sp, sp, 8
stur lr, [sp, 0]
        add x9, x11, 1       //x9 is j var and = i + 1
loop2:  cmp x9, x27          //cmp j and len
        b.ge done            //if j >= len, done
        lsl x13, x9, 3       //shift j var 
        add x13, x13, x22
        lsl x14, x20, 3      //shift min idex var
        add x14, x14, x22
        ldur x10, [x13, 0]
        ldur x19, [x14, 0]
        cmp x10, x19        
        b.ge else           //if arr[j] >= arr[min_index], go to else
        mov x20, x9         //if x10 < x19, min index = j
else:   add x9, x9, 1       //j++
        b loop2
done:   ldur lr, [sp, 0]
        add sp, sp, 8
        br lr

swap:
        sub sp, sp, 8
        stur lr, [sp, 0]
        lsl x23, x20, 3         //lsl the min idex 3 times
        add x23, x23, x22
        lsl x24, x11, 3         //lsl the i value 3 times
        add x24, x24, x22
        ldur x25, [x23, 0]
	ldur x26, [x24, 0]
	stur x25, [x24, 0]
	stur x26, [x23, 0]
        ldur lr, [sp, 0]
        add sp, sp, 8
        br lr                   //return to line where called	
		
binary_search:
        sub sp, sp, 8
        stur lr, [sp, 0]
        ///////
        ldr x0, =input
        ldr x1, =num
        bl scanf
        ldr x1, =num
        ldur x1, [x1, 0]
        mov x28, x1
        ///////
        //mov x28, 15        //x28 will be x
        mov x20, 0           //x20 is m
        mov x11, 0           //x11 = l
        mov x16, len         //x16 = r
loop4:  cmp x11, x16         //while l <= r
        b.gt leave2          //if x11 == x16, meaning l !<= r
        sub x20, x16, x11    //x20 = x16-x11, m = r-l
        lsr x20, x20, 1      //x20/2
        add x20, x20, x11    //x20 += x11, m+=l
        lsl x21, x20, 3      //shift x20/m
        add x21, x21, x22    //add base of array at x22
        ldur x23, [x21, 0]   //x23 is arr[m]
        sub x14, x23, x28
        cbz x14, leave       //x20 will be index of answer!!!!
        cmp x23, x28
        b.lt less            //if x23/arr[m] < x28/x
        b els
less:   add x11, x20, 1      //x11 = x20+1, l=m+1
        b loop4
els:    sub x16, x20, 1      //x16=x20-1, r=m-1
        b loop4
leave:  ldur lr, [sp, 0]
        add sp, sp, 8
        br lr       
leave2: mov x20, -1        //to show its not found   
        ldur lr, [sp, 0]
        add sp, sp, 8
        br lr 

sort_end:
        mov x1, x20
        cmp x20, 0
        b.lt not 
found:
        adr x0, print_found
        bl printf
        bl finish
not:
        adr x0, print_not_found
        bl printf
        bl finish
finish: 
        mov x0, #0
        mov w8, #93
        svc #0

	
.data
arr:
	.dword 14,13,12,11,10,9,8,7,6,5,4,3,2,1
len:
	.quad 14
num:
        .dword 0
input:
        .string "%d"


print_found:
	.ascii "Found at index %d\n\0"

print_not_found:
        .ascii "Not found\n"
         


.end
