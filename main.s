	.file	"main.c"
	.option nopic
	.text
	.align	1
	.globl	add
	.type	add, @function
add:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	mv	a5,a0
	mv	a4,a1
	sw	a5,-20(s0)
	mv	a5,a4
	sw	a5,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	addw	a5,a4,a5
	sext.w	a5,a5
	mv	a0,a5
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	add, .-add
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	li	a5,1
	sw	a5,-20(s0)
	li	a5,2
	sw	a5,-24(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	mv	a1,a4
	mv	a0,a5
	call	add
	mv	a5,a0
	sw	a5,-28(s0)
	li	a0,0
	call	exit
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
