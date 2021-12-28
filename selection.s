//I pledge my honor that I have abided by the Stevens Honor System. -Isabella Stone
.text
.global _start
.extern printf 

_start:
        adr x22, arr        //put base of array in x22
        ldr x27, len        //x27 is len
        mov x12, x27         
        sub x12, x12, 1     //x12 = len-1
        mov x11, 0          //x11 is i counter, starts at 0
        mov x8, 0           //to use to check loop1
        bl sort_func
        mov x1, x22         
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
		

sort_end:
        //ldr x0, =print_num
        mov x28, 0          //x28 is i var
        mov x29, x12
loop3:  cmp x28, x29        //compare i var to len-1, loop to print sorted array
        b.gt end            //if x28 > len-1, go to end 
        lsl x23, x28, 3     //shift i to get index
        add x23, x23, x22   //add base of array
        ldur x1, [x23, 0]   //load into x1 to print
        adr x0, print_num
        bl printf
        add x28, x28, 1     //i++
        b loop3
end:    mov x0, #0
        mov w8, #93
        svc #0
	
	
	
.data
arr:
	.dword 8,3,4,7,11,12,14,21,15,9,13,20,1,17,18
len:
	.quad 15
	
	
	
print_num:
	.ascii "%d\n\0"
	.end
