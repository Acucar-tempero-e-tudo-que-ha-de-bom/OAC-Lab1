.data
.LANCHOR0: .word 9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78,54,23,1,54,2,65,3,6,55,31

.text

show:
         mv     t0,a0 
         mv     t1,a1 
         mv     t2,zero 
loop1:  beq     t2,t1,fim1 
        li      a7,1 
        lw      a0,0(t0) 
        ecall 
        li      a7,11 
        li      a0,9 
        ecall 
        addi    t0,t0,4 
        addi    t2,t2,1 
        j       loop1 
fim1:   li      a7,11 
        li      a0,10 
        ecall 

        ret
swap:
        slli    a1,a1,2
        addi    a5,a1,4
        add     a5,a0,a5
        lw      a3,0(a5)
        add     a1,a0,a1
        lw      a4,0(a1)
        sw      a3,0(a1)
        sw      a4,0(a5)
        ret
sort:
        li      a5,1
        addi    t1,a1,-1
        li      a7,0
        li      a6,-1
        ble     a1,a5,.L14
.L8:
        mv      a4,a7
        mv      a5,a0
        j       .L7
.L9:
        sw      a3,0(a5)
        sw      a2,4(a5)
        addi    a5,a5,-4
        beq     a4,a6,.L10
.L7:
        lw      a2,0(a5)
        lw      a3,4(a5)
        addi    a4,a4,-1
        bgt     a2,a3,.L9
.L10:
        addi    a7,a7,1
        addi    a0,a0,4
        bne     t1,a7,.L8
        ret
.L14:
        ret
main:
        addi    sp,sp,-16
        lui     a0,%hi(.LANCHOR0)
        sw      s0,8(sp)
        sw      s1,4(sp)
        sw      ra,12(sp)
        addi    s0,a0,%lo(.LANCHOR0)
        li      s1,30
         mv     t0,s0 
         mv     t1,s1 
         mv     t2,zero 
loop1:  beq     t2,t1,fim1 
        li      a7,1 
        lw      a0,0(t0) 
        ecall 
        li      a7,11 
        li      a0,9 
        ecall 
        addi    t0,t0,4 
        addi    t2,t2,1 
        j       loop1 
fim1:   li      a7,11 
        li      a0,10 
        ecall 

        li      a1,30
        addi    a0,a0,%lo(.LANCHOR0)
        call    sort
         mv     t0,s0 
         mv     t1,s1 
         mv     t2,zero 
loop1:  beq     t2,t1,fim1 
        li      a7,1 
        lw      a0,0(t0) 
        ecall 
        li      a7,11 
        li      a0,9 
        ecall 
        addi    t0,t0,4 
        addi    t2,t2,1 
        j       loop1 
fim1:   li      a7,11 
        li      a0,10 
        ecall 

        lw      ra,12(sp)
        lw      s0,8(sp)
        lw      s1,4(sp)
        li      a0,0
        addi    sp,sp,16
        jr      ra