	.file	"matmul_1024.vy.c"
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "vyne: out of memory\12\0"
	.text
	.p2align 4
	.def	arena_alloc.part.0;	.scl	3;	.type	32;	.endef
	.seh_proc	arena_alloc.part.0
arena_alloc.part.0:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.p2align 4
	.def	vyne_index_get;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_index_get
vyne_index_get:
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movq	(%rdx), %rax
	movq	8(%rdx), %r10
	movq	(%r8), %rdx
	movq	8(%r8), %r8
	cmpl	$4, %eax
	movq	%rcx, %r9
	je	.L34
	cmpl	$10, %eax
	je	.L35
	cmpl	$3, %eax
	jne	.L7
	cmpl	$2, %edx
	je	.L36
.L7:
	movq	$0, (%r9)
	movq	$0, 8(%r9)
.L3:
	movq	%r9, %rax
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L34:
	cmpl	$2, %edx
	jne	.L7
	testl	%r8d, %r8d
	js	.L7
	cmpl	8(%r10), %r8d
	jge	.L7
	movslq	%r8d, %r8
	salq	$4, %r8
	addq	(%r10), %r8
	movq	(%r8), %rax
	movq	8(%r8), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L36:
	movq	%rcx, 112(%rsp)
	movq	%r10, %rcx
	movq	%r8, 40(%rsp)
	movq	%r10, 48(%rsp)
	call	strlen
	movq	40(%rsp), %r8
	movq	112(%rsp), %r9
	testl	%r8d, %r8d
	js	.L7
	cmpl	%eax, %r8d
	jge	.L7
	movl	_vyne_char_pool_ready(%rip), %eax
	leaq	_vyne_char_pool(%rip), %rcx
	movq	48(%rsp), %r10
	testl	%eax, %eax
	jne	.L13
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L14:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L14
	movl	$1, _vyne_char_pool_ready(%rip)
.L13:
	movslq	%r8d, %r8
	movq	$3, (%r9)
	movzbl	(%r10,%r8), %eax
	leaq	(%rcx,%rax,2), %rax
	movq	%rax, 8(%r9)
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L35:
	cmpl	$3, %edx
	jne	.L7
	movl	8(%r10), %edx
	testl	%edx, %edx
	je	.L7
	movzbl	(%r8), %eax
	movl	12(%r10), %ebx
	testb	%al, %al
	je	.L15
	movq	%r8, %rdx
	movl	$-2128831035, %r11d
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L10:
	addq	$1, %rdx
	xorl	%eax, %r11d
	movzbl	(%rdx), %eax
	imull	$16777619, %r11d, %r11d
	testb	%al, %al
	jne	.L10
.L9:
	testl	%ebx, %ebx
	jle	.L7
	leal	-1(%rbx), %eax
	movq	(%r10), %rsi
	xorl	%r10d, %r10d
	movl	%eax, %r14d
	andl	%eax, %r11d
	jmp	.L12
	.p2align 4,,10
	.p2align 3
.L38:
	cmpq	$1, %rcx
	je	.L11
	movq	%r8, %rdx
	movq	%r9, 112(%rsp)
	movl	%r10d, 60(%rsp)
	movl	%r11d, 48(%rsp)
	movq	%r8, 40(%rsp)
	call	strcmp
	movq	40(%rsp), %r8
	testl	%eax, %eax
	movl	48(%rsp), %r11d
	movl	60(%rsp), %r10d
	movq	112(%rsp), %r9
	je	.L37
.L11:
	addl	$1, %r11d
	addl	$1, %r10d
	andl	%r14d, %r11d
	cmpl	%r10d, %ebx
	je	.L7
.L12:
	movl	%r11d, %eax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rsi,%rax,8), %rax
	movq	(%rax), %rcx
	movq	%rax, %rdi
	testq	%rcx, %rcx
	jne	.L38
	jmp	.L7
.L37:
	movq	8(%rdi), %rax
	movq	16(%rdi), %rdx
	movq	%rax, (%r9)
	movq	%rdx, 8(%r9)
	jmp	.L3
.L15:
	movl	$-2128831035, %r11d
	jmp	.L9
	.seh_endproc
	.p2align 4
	.def	vyne_values_equal.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_values_equal.isra.0
vyne_values_equal.isra.0:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	cmpl	%r8d, %ecx
	movq	%rdx, %r10
	movq	%r9, %rbx
	je	.L40
	leal	-1(%rcx), %edx
	xorl	%eax, %eax
	cmpl	$1, %edx
	ja	.L39
	leal	-1(%r8), %edx
	cmpl	$1, %edx
	jbe	.L85
.L39:
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L40:
	cmpl	$10, %ecx
	ja	.L68
	leaq	.L47(%rip), %rdx
	movl	%ecx, %ecx
	movslq	(%rdx,%rcx,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L47:
	.long	.L65-.L47
	.long	.L50-.L47
	.long	.L48-.L47
	.long	.L49-.L47
	.long	.L68-.L47
	.long	.L48-.L47
	.long	.L68-.L47
	.long	.L68-.L47
	.long	.L68-.L47
	.long	.L68-.L47
	.long	.L46-.L47
	.text
	.p2align 4,,10
	.p2align 3
.L85:
	cmpl	$1, %ecx
	movq	%r10, %xmm1
	je	.L43
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r10, %xmm1
.L43:
	cmpl	$1, %r8d
	movq	%rbx, %xmm0
	je	.L45
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L45:
	ucomisd	%xmm0, %xmm1
	movl	$0, %edx
	setnp	%al
	cmovne	%edx, %eax
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L46:
	cmpq	%r9, %r10
	je	.L65
	movl	8(%r10), %ecx
	xorl	%eax, %eax
	cmpl	8(%r9), %ecx
	movl	%ecx, 56(%rsp)
	jne	.L39
	movl	12(%r10), %eax
	testl	%eax, %eax
	movl	%eax, 60(%rsp)
	jle	.L65
	testl	%ecx, %ecx
	jle	.L65
	movq	(%r10), %rbp
	xorl	%r13d, %r13d
	xorl	%r12d, %r12d
	.p2align 4,,10
	.p2align 3
.L58:
	movq	0(%rbp), %rax
	cmpq	$1, %rax
	movq	%rax, %r15
	jbe	.L52
	movq	%rax, %rdx
	movzbl	(%rax), %eax
	movl	$-2128831035, %r8d
	movl	12(%rbx), %esi
	testb	%al, %al
	je	.L53
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L54:
	addq	$1, %rdx
	xorl	%eax, %r8d
	movzbl	(%rdx), %eax
	imull	$16777619, %r8d, %r8d
	testb	%al, %al
	jne	.L54
.L53:
	testl	%esi, %esi
	jle	.L68
	leal	-1(%rsi), %eax
	movq	(%rbx), %rdi
	xorl	%r9d, %r9d
	movl	%eax, %r14d
	andl	%eax, %r8d
	jmp	.L57
	.p2align 4,,10
	.p2align 3
.L87:
	cmpq	$1, %rcx
	je	.L55
	movq	%r15, %rdx
	movl	%r9d, 44(%rsp)
	movl	%r8d, 40(%rsp)
	movq	%r10, 48(%rsp)
	call	strcmp
	movl	40(%rsp), %r8d
	testl	%eax, %eax
	movl	44(%rsp), %r9d
	movq	48(%rsp), %r10
	je	.L86
.L55:
	addl	$1, %r8d
	addl	$1, %r9d
	andl	%r14d, %r8d
	cmpl	%r9d, %esi
	je	.L68
.L57:
	movl	%r8d, %eax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rdi,%rax,8), %r10
	movq	(%r10), %rcx
	testq	%rcx, %rcx
	jne	.L87
	.p2align 4,,10
	.p2align 3
.L68:
	xorl	%eax, %eax
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L48:
	cmpq	%r9, %r10
	sete	%al
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L86:
	movq	16(%rbp), %rdx
	movl	8(%rbp), %ecx
	movq	16(%r10), %r9
	movl	8(%r10), %r8d
	call	vyne_values_equal.isra.0
	testb	%al, %al
	je	.L39
	addl	$1, %r13d
.L52:
	leal	1(%r12), %eax
	addq	$24, %rbp
	cmpl	%eax, 60(%rsp)
	movl	%eax, %r12d
	jle	.L65
	cmpl	%r13d, 56(%rsp)
	jg	.L58
	.p2align 4,,10
	.p2align 3
.L65:
	movl	$1, %eax
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L50:
	movq	%r10, %xmm2
	movq	%r9, %xmm3
	movl	$0, %edx
	ucomisd	%xmm3, %xmm2
	setnp	%al
	cmovne	%edx, %eax
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L49:
	movq	%r9, %rdx
	movq	%r10, %rcx
	call	strcmp
	testl	%eax, %eax
	sete	%al
	jmp	.L39
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "true\0"
.LC2:
	.ascii "false\0"
.LC3:
	.ascii "null\0"
.LC4:
	.ascii "%lld\0"
.LC5:
	.ascii "%s\0"
.LC6:
	.ascii "%g\0"
.LC7:
	.ascii ", \0"
.LC8:
	.ascii "\"%s\": \0"
.LC9:
	.ascii "%s { \0"
.LC10:
	.ascii " }\0"
.LC11:
	.ascii "%s: \0"
.LC12:
	.ascii "<unknown>\0"
	.text
	.p2align 4
	.def	_vyne_print_internal.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	_vyne_print_internal.isra.0
_vyne_print_internal.isra.0:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	addq	$-128, %rsp
	.seh_stackalloc	128
	.seh_endprologue
	cmpl	$10, %ecx
	movq	%rdx, %rbx
	ja	.L89
	leaq	.L91(%rip), %rdx
	movl	%ecx, %ecx
	movslq	(%rdx,%rcx,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L91:
	.long	.L98-.L91
	.long	.L97-.L91
	.long	.L96-.L91
	.long	.L95-.L91
	.long	.L94-.L91
	.long	.L93-.L91
	.long	.L92-.L91
	.long	.L89-.L91
	.long	.L89-.L91
	.long	.L89-.L91
	.long	.L90-.L91
	.text
	.p2align 4,,10
	.p2align 3
.L89:
	leaq	.LC12(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L98:
	leaq	.LC3(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L97:
	leaq	.LC6(%rip), %rdx
	movq	%rbx, %r8
	movq	%rbx, %xmm2
	leaq	64(%rsp), %rcx
	call	sprintf
	leaq	64(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L207
.L101:
	leaq	64(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	nop
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L96:
	leaq	.LC4(%rip), %rcx
	movq	%rbx, %rdx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L95:
	leaq	.LC3(%rip), %rdx
	testq	%rbx, %rbx
	cmovne	%rbx, %rdx
.L205:
	leaq	.LC5(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L94:
	movl	$91, %ecx
	xorl	%edi, %edi
	call	putchar
	movl	8(%rbx), %r14d
	testl	%r14d, %r14d
	jle	.L133
.L103:
	movq	%rdi, %rax
	salq	$4, %rax
	addq	(%rbx), %rax
	cmpl	$10, (%rax)
	movq	8(%rax), %rsi
	ja	.L104
	movl	(%rax), %eax
	leaq	.L106(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L106:
	.long	.L113-.L106
	.long	.L112-.L106
	.long	.L111-.L106
	.long	.L110-.L106
	.long	.L109-.L106
	.long	.L108-.L106
	.long	.L107-.L106
	.long	.L104-.L106
	.long	.L104-.L106
	.long	.L104-.L106
	.long	.L105-.L106
	.text
	.p2align 4,,10
	.p2align 3
.L93:
	leaq	.LC2(%rip), %rdx
	testq	%rbx, %rbx
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	jmp	.L205
	.p2align 4,,10
	.p2align 3
.L92:
	movq	(%rbx), %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	16(%rbx), %r8d
	testl	%r8d, %r8d
	jle	.L208
	leaq	.LC10(%rip), %r15
	xorl	%edi, %edi
	leaq	.LC11(%rip), %r14
.L139:
	movq	8(%rbx), %rax
	movq	%rdi, %rsi
	movq	%r14, %rcx
	salq	$5, %rsi
	movq	8(%rax,%rsi), %rdx
	call	printf
	movq	8(%rbx), %rax
	addq	%rsi, %rax
	cmpl	$10, 16(%rax)
	movq	24(%rax), %rsi
	ja	.L140
	movl	16(%rax), %eax
	leaq	.L142(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L142:
	.long	.L149-.L142
	.long	.L148-.L142
	.long	.L147-.L142
	.long	.L146-.L142
	.long	.L145-.L142
	.long	.L144-.L142
	.long	.L143-.L142
	.long	.L140-.L142
	.long	.L140-.L142
	.long	.L140-.L142
	.long	.L141-.L142
	.text
	.p2align 4,,10
	.p2align 3
.L90:
	movl	$123, %ecx
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	putchar
	movl	12(%rbx), %eax
	xorl	%r8d, %r8d
	testl	%eax, %eax
	jle	.L137
.L134:
	cmpl	%edi, 8(%rbx)
	jle	.L137
	movq	(%rbx), %rdx
	movq	(%rdx,%rsi), %rdx
	cmpq	$1, %rdx
	jbe	.L135
	testl	%edi, %edi
	jne	.L209
.L136:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 32(%rsp)
	addl	$1, %edi
	call	printf
	movq	(%rbx), %rax
	addq	%rsi, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	12(%rbx), %eax
	movl	32(%rsp), %r8d
.L135:
	addl	$1, %r8d
	addq	$24, %rsi
	cmpl	%eax, %r8d
	jl	.L134
.L137:
	movl	$125, %ecx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	putchar
	.p2align 4,,10
	.p2align 3
.L104:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L114:
	movl	8(%rbx), %eax
	leal	-1(%rax), %edx
	cmpl	%edi, %edx
	jg	.L210
	addq	$1, %rdi
	cmpl	%edi, %eax
	jg	.L103
.L133:
	movl	$93, %ecx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	putchar
	.p2align 4,,10
	.p2align 3
.L209:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 40(%rsp)
	movq	%rdx, 32(%rsp)
	call	printf
	movl	40(%rsp), %r8d
	movq	32(%rsp), %rdx
	jmp	.L136
	.p2align 4,,10
	.p2align 3
.L140:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L150:
	movl	16(%rbx), %eax
	leal	-1(%rax), %edx
	cmpl	%edi, %edx
	jg	.L211
	addq	$1, %rdi
	cmpl	%edi, %eax
	jg	.L139
.L169:
	movq	%r15, %rcx
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	popq	%r15
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L141:
	movl	$123, %ecx
	call	putchar
	movl	12(%rsi), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	testl	%eax, %eax
	jle	.L161
.L158:
	cmpl	%r9d, 8(%rsi)
	jle	.L161
	movq	(%rsi), %rdx
	movq	(%rdx,%r8), %rdx
	cmpq	$1, %rdx
	jbe	.L159
	testl	%r9d, %r9d
	jne	.L212
.L160:
	leaq	.LC8(%rip), %rcx
	movq	%r8, 32(%rsp)
	movl	%r9d, 52(%rsp)
	movl	%r10d, 40(%rsp)
	call	printf
	movq	32(%rsp), %rax
	addq	(%rsi), %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	52(%rsp), %r9d
	movl	12(%rsi), %eax
	movl	40(%rsp), %r10d
	movq	32(%rsp), %r8
	addl	$1, %r9d
.L159:
	addl	$1, %r10d
	addq	$24, %r8
	cmpl	%eax, %r10d
	jl	.L158
.L161:
	movl	$125, %ecx
	call	putchar
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L143:
	movq	(%rsi), %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	16(%rsi), %eax
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L166
.L163:
	movq	8(%rsi), %rax
	movq	%r9, %r8
	movq	%r14, %rcx
	movq	%r9, 40(%rsp)
	salq	$5, %r8
	movq	%r8, 32(%rsp)
	movq	8(%rax,%r8), %rdx
	call	printf
	movq	32(%rsp), %r8
	addq	8(%rsi), %r8
	movq	24(%r8), %rdx
	movl	16(%r8), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rsi), %eax
	movq	40(%rsp), %r9
	leal	-1(%rax), %edx
	cmpl	%r9d, %edx
	jg	.L213
	addq	$1, %r9
	cmpl	%r9d, %eax
	jg	.L163
.L166:
	movq	%r15, %rcx
	call	printf
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L144:
	leaq	.LC2(%rip), %rdx
	testq	%rsi, %rsi
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L145:
	movl	$91, %ecx
	call	putchar
	movl	8(%rsi), %edx
	xorl	%r8d, %r8d
	testl	%edx, %edx
	jle	.L157
.L154:
	movq	%r8, %rax
	movq	%r8, 32(%rsp)
	salq	$4, %rax
	addq	(%rsi), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rsi), %eax
	movq	32(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L214
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L154
.L157:
	movl	$93, %ecx
	call	putchar
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L146:
	leaq	.LC3(%rip), %rdx
	testq	%rsi, %rsi
	cmovne	%rsi, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L108:
	leaq	.LC2(%rip), %rdx
	testq	%rsi, %rsi
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L109:
	movl	$91, %ecx
	call	putchar
	movl	8(%rsi), %r11d
	xorl	%r8d, %r8d
	testl	%r11d, %r11d
	jle	.L121
.L118:
	movq	%r8, %rax
	movq	%r8, 32(%rsp)
	salq	$4, %rax
	addq	(%rsi), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rsi), %eax
	movq	32(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L215
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L118
.L121:
	movl	$93, %ecx
	call	putchar
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L110:
	leaq	.LC3(%rip), %rdx
	testq	%rsi, %rsi
	cmovne	%rsi, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L111:
	leaq	.LC4(%rip), %rcx
	movq	%rsi, %rdx
	call	printf
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L112:
	leaq	.LC6(%rip), %rdx
	movq	%rsi, %r8
	movq	%rsi, %xmm2
	leaq	64(%rsp), %rcx
	call	sprintf
	leaq	64(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L216
.L117:
	leaq	64(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L113:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L149:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L105:
	movl	$123, %ecx
	call	putchar
	movl	12(%rsi), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	testl	%eax, %eax
	jle	.L125
.L122:
	cmpl	%r9d, 8(%rsi)
	jle	.L125
	movq	(%rsi), %rdx
	movq	(%rdx,%r8), %rdx
	cmpq	$1, %rdx
	jbe	.L123
	testl	%r9d, %r9d
	jne	.L217
.L124:
	leaq	.LC8(%rip), %rcx
	movq	%r8, 32(%rsp)
	movl	%r9d, 52(%rsp)
	movl	%r10d, 40(%rsp)
	call	printf
	movq	32(%rsp), %rax
	addq	(%rsi), %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	52(%rsp), %r9d
	movl	12(%rsi), %eax
	movl	40(%rsp), %r10d
	movq	32(%rsp), %r8
	addl	$1, %r9d
.L123:
	addl	$1, %r10d
	addq	$24, %r8
	cmpl	%eax, %r10d
	jl	.L122
.L125:
	movl	$125, %ecx
	call	putchar
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L107:
	movq	(%rsi), %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	16(%rsi), %r10d
	xorl	%r9d, %r9d
	testl	%r10d, %r10d
	jle	.L130
.L127:
	movq	8(%rsi), %rax
	movq	%r9, %r8
	movq	%r9, 40(%rsp)
	leaq	.LC11(%rip), %rcx
	salq	$5, %r8
	movq	%r8, 32(%rsp)
	movq	8(%rax,%r8), %rdx
	call	printf
	movq	32(%rsp), %r8
	addq	8(%rsi), %r8
	movq	24(%r8), %rdx
	movl	16(%r8), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rsi), %eax
	movq	40(%rsp), %r9
	leal	-1(%rax), %edx
	cmpl	%r9d, %edx
	jg	.L218
	addq	$1, %r9
	cmpl	%r9d, %eax
	jg	.L127
.L130:
	leaq	.LC10(%rip), %rcx
	call	printf
	jmp	.L114
	.p2align 4,,10
	.p2align 3
.L147:
	leaq	.LC4(%rip), %rcx
	movq	%rsi, %rdx
	call	printf
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L148:
	leaq	.LC6(%rip), %rdx
	movq	%rsi, %r8
	movq	%rsi, %xmm2
	leaq	64(%rsp), %rcx
	call	sprintf
	leaq	64(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L219
.L153:
	leaq	64(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L150
	.p2align 4,,10
	.p2align 3
.L210:
	leaq	.LC7(%rip), %rcx
	addq	$1, %rdi
	call	printf
	cmpl	%edi, 8(%rbx)
	jg	.L103
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L211:
	leaq	.LC7(%rip), %rcx
	addq	$1, %rdi
	call	printf
	cmpl	%edi, 16(%rbx)
	jg	.L139
	jmp	.L169
	.p2align 4,,10
	.p2align 3
.L213:
	leaq	.LC7(%rip), %rcx
	movq	%r9, 32(%rsp)
	call	printf
	movq	32(%rsp), %r9
	addq	$1, %r9
	cmpl	%r9d, 16(%rsi)
	jg	.L163
	jmp	.L166
	.p2align 4,,10
	.p2align 3
.L214:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	32(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 8(%rsi)
	jg	.L154
	jmp	.L157
	.p2align 4,,10
	.p2align 3
.L218:
	leaq	.LC7(%rip), %rcx
	movq	%r9, 32(%rsp)
	call	printf
	movq	32(%rsp), %r9
	addq	$1, %r9
	cmpl	%r9d, 16(%rsi)
	jg	.L127
	jmp	.L130
	.p2align 4,,10
	.p2align 3
.L215:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	32(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 8(%rsi)
	jg	.L118
	jmp	.L121
	.p2align 4,,10
	.p2align 3
.L217:
	leaq	.LC7(%rip), %rcx
	movq	%r8, 56(%rsp)
	movl	%r9d, 52(%rsp)
	movl	%r10d, 40(%rsp)
	movq	%rdx, 32(%rsp)
	call	printf
	movq	56(%rsp), %r8
	movl	52(%rsp), %r9d
	movl	40(%rsp), %r10d
	movq	32(%rsp), %rdx
	jmp	.L124
	.p2align 4,,10
	.p2align 3
.L212:
	leaq	.LC7(%rip), %rcx
	movq	%r8, 56(%rsp)
	movl	%r9d, 52(%rsp)
	movl	%r10d, 40(%rsp)
	movq	%rdx, 32(%rsp)
	call	printf
	movq	56(%rsp), %r8
	movl	52(%rsp), %r9d
	movl	40(%rsp), %r10d
	movq	32(%rsp), %rdx
	jmp	.L160
	.p2align 4,,10
	.p2align 3
.L207:
	leaq	64(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L101
	leaq	64(%rsp), %rcx
	movl	$12334, %r15d
	call	strlen
	movw	%r15w, 64(%rsp,%rax)
	movb	$0, 66(%rsp,%rax)
	jmp	.L101
	.p2align 4,,10
	.p2align 3
.L208:
	leaq	.LC10(%rip), %r15
	jmp	.L169
	.p2align 4,,10
	.p2align 3
.L216:
	leaq	64(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L117
	leaq	64(%rsp), %rcx
	movl	$12334, %esi
	call	strlen
	movw	%si, 64(%rsp,%rax)
	movb	$0, 66(%rsp,%rax)
	jmp	.L117
	.p2align 4,,10
	.p2align 3
.L219:
	leaq	64(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L153
	leaq	64(%rsp), %rcx
	call	strlen
	movl	$12334, %ecx
	movw	%cx, 64(%rsp,%rax)
	movb	$0, 66(%rsp,%rax)
	jmp	.L153
	.seh_endproc
	.p2align 4
	.def	vyne_out.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_out.isra.0
vyne_out.isra.0:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$152, %rsp
	.seh_stackalloc	152
	.seh_endprologue
	cmpl	$10, %ecx
	movq	%rdx, %rbx
	ja	.L221
	leaq	.L223(%rip), %rdx
	movl	%ecx, %ecx
	movslq	(%rdx,%rcx,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L223:
	.long	.L230-.L223
	.long	.L229-.L223
	.long	.L228-.L223
	.long	.L227-.L223
	.long	.L226-.L223
	.long	.L225-.L223
	.long	.L224-.L223
	.long	.L221-.L223
	.long	.L221-.L223
	.long	.L221-.L223
	.long	.L222-.L223
	.text
	.p2align 4,,10
	.p2align 3
.L221:
	leaq	.LC12(%rip), %rcx
	call	printf
.L231:
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	addq	$152, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	fflush
	.p2align 4,,10
	.p2align 3
.L230:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L229:
	leaq	.LC6(%rip), %rdx
	movq	%rbx, %r8
	movq	%rbx, %xmm2
	leaq	80(%rsp), %rcx
	call	sprintf
	leaq	80(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L561
.L234:
	leaq	80(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L228:
	leaq	.LC4(%rip), %rcx
	movq	%rbx, %rdx
	call	printf
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L227:
	leaq	.LC3(%rip), %rdx
	testq	%rbx, %rbx
	cmovne	%rbx, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L226:
	movl	$91, %ecx
	xorl	%edi, %edi
	call	putchar
	movl	8(%rbx), %r11d
	testl	%r11d, %r11d
	jle	.L346
.L235:
	movq	%rdi, %rax
	salq	$4, %rax
	addq	(%rbx), %rax
	cmpl	$10, (%rax)
	movq	8(%rax), %rsi
	ja	.L236
	movl	(%rax), %eax
	leaq	.L238(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L238:
	.long	.L245-.L238
	.long	.L244-.L238
	.long	.L243-.L238
	.long	.L242-.L238
	.long	.L241-.L238
	.long	.L240-.L238
	.long	.L239-.L238
	.long	.L236-.L238
	.long	.L236-.L238
	.long	.L236-.L238
	.long	.L237-.L238
	.text
	.p2align 4,,10
	.p2align 3
.L225:
	leaq	.LC2(%rip), %rdx
	testq	%rbx, %rbx
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L224:
	movq	(%rbx), %rdx
	leaq	.LC9(%rip), %rax
	movq	%rax, %rcx
	movq	%rax, 48(%rsp)
	call	printf
	movl	16(%rbx), %edi
	testl	%edi, %edi
	jle	.L562
	leaq	.LC10(%rip), %rax
	xorl	%edi, %edi
	movq	%rax, 40(%rsp)
	leaq	.LC11(%rip), %r14
.L379:
	movq	8(%rbx), %rax
	movq	%rdi, %rsi
	movq	%r14, %rcx
	salq	$5, %rsi
	movq	8(%rax,%rsi), %rdx
	call	printf
	movq	8(%rbx), %rax
	addq	%rsi, %rax
	cmpl	$10, 16(%rax)
	movq	24(%rax), %rsi
	ja	.L380
	movl	16(%rax), %eax
	leaq	.L382(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L382:
	.long	.L389-.L382
	.long	.L388-.L382
	.long	.L387-.L382
	.long	.L386-.L382
	.long	.L385-.L382
	.long	.L384-.L382
	.long	.L383-.L382
	.long	.L380-.L382
	.long	.L380-.L382
	.long	.L380-.L382
	.long	.L381-.L382
	.text
	.p2align 4,,10
	.p2align 3
.L222:
	movl	$123, %ecx
	xorl	%edi, %edi
	xorl	%ebp, %ebp
	call	putchar
	movl	12(%rbx), %eax
	xorl	%r12d, %r12d
	testl	%eax, %eax
	jle	.L377
.L347:
	cmpl	%ebp, 8(%rbx)
	jle	.L377
	movq	(%rbx), %rdx
	movq	(%rdx,%rdi), %rsi
	cmpq	$1, %rsi
	jbe	.L348
	testl	%ebp, %ebp
	jne	.L563
.L349:
	leaq	.LC8(%rip), %rcx
	movq	%rsi, %rdx
	call	printf
	movq	(%rbx), %rax
	addq	%rdi, %rax
	cmpl	$10, 8(%rax)
	movq	16(%rax), %rsi
	ja	.L350
	movl	8(%rax), %eax
	leaq	.L352(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L352:
	.long	.L359-.L352
	.long	.L358-.L352
	.long	.L357-.L352
	.long	.L356-.L352
	.long	.L355-.L352
	.long	.L354-.L352
	.long	.L353-.L352
	.long	.L350-.L352
	.long	.L350-.L352
	.long	.L350-.L352
	.long	.L351-.L352
	.text
	.p2align 4,,10
	.p2align 3
.L350:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L360:
	movl	12(%rbx), %eax
	addl	$1, %ebp
.L348:
	addl	$1, %r12d
	addq	$24, %rdi
	cmpl	%eax, %r12d
	jl	.L347
.L377:
	movl	$125, %ecx
	call	putchar
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L236:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L246:
	movl	8(%rbx), %eax
	leal	-1(%rax), %edx
	cmpl	%edi, %edx
	jg	.L564
	addq	$1, %rdi
	cmpl	%edi, %eax
	jg	.L235
.L346:
	movl	$93, %ecx
	call	putchar
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L563:
	leaq	.LC7(%rip), %rcx
	call	printf
	jmp	.L349
	.p2align 4,,10
	.p2align 3
.L380:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L390:
	movl	16(%rbx), %eax
	leal	-1(%rax), %edx
	cmpl	%edi, %edx
	jg	.L565
	addq	$1, %rdi
	cmpl	%edi, %eax
	jg	.L379
.L463:
	movq	40(%rsp), %rcx
	call	printf
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L383:
	movq	48(%rsp), %rcx
	xorl	%r13d, %r13d
	movq	(%rsi), %rdx
	call	printf
	movl	16(%rsi), %ecx
	testl	%ecx, %ecx
	jle	.L460
.L430:
	movq	8(%rsi), %rax
	movq	%r13, %rbp
	movq	%r14, %rcx
	salq	$5, %rbp
	movq	8(%rax,%rbp), %rdx
	call	printf
	movq	8(%rsi), %rax
	addq	%rbp, %rax
	cmpl	$10, 16(%rax)
	movq	24(%rax), %rbp
	ja	.L431
	movl	16(%rax), %eax
	leaq	.L433(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L433:
	.long	.L440-.L433
	.long	.L439-.L433
	.long	.L438-.L433
	.long	.L437-.L433
	.long	.L436-.L433
	.long	.L435-.L433
	.long	.L434-.L433
	.long	.L431-.L433
	.long	.L431-.L433
	.long	.L431-.L433
	.long	.L432-.L433
	.text
	.p2align 4,,10
	.p2align 3
.L384:
	leaq	.LC2(%rip), %rdx
	testq	%rsi, %rsi
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L381:
	movl	$123, %ecx
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	call	putchar
	movl	12(%rsi), %eax
	xorl	%r8d, %r8d
	testl	%eax, %eax
	jle	.L428
.L425:
	cmpl	%r12d, 8(%rsi)
	jle	.L428
	movq	(%rsi), %rdx
	movq	(%rdx,%rbp), %rdx
	cmpq	$1, %rdx
	jbe	.L426
	testl	%r12d, %r12d
	jne	.L566
.L427:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 56(%rsp)
	addl	$1, %r12d
	call	printf
	movq	(%rsi), %rax
	addq	%rbp, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	12(%rsi), %eax
	movl	56(%rsp), %r8d
.L426:
	addl	$1, %r8d
	addq	$24, %rbp
	cmpl	%eax, %r8d
	jl	.L425
.L428:
	movl	$125, %ecx
	call	putchar
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L385:
	movl	$91, %ecx
	xorl	%r13d, %r13d
	call	putchar
	movl	8(%rsi), %r11d
	testl	%r11d, %r11d
	jle	.L424
.L394:
	movq	%r13, %rax
	salq	$4, %rax
	addq	(%rsi), %rax
	cmpl	$10, (%rax)
	movq	8(%rax), %rbp
	ja	.L395
	movl	(%rax), %eax
	leaq	.L397(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L397:
	.long	.L404-.L397
	.long	.L403-.L397
	.long	.L402-.L397
	.long	.L401-.L397
	.long	.L400-.L397
	.long	.L399-.L397
	.long	.L398-.L397
	.long	.L395-.L397
	.long	.L395-.L397
	.long	.L395-.L397
	.long	.L396-.L397
	.text
	.p2align 4,,10
	.p2align 3
.L386:
	leaq	.LC3(%rip), %rdx
	testq	%rsi, %rsi
	cmovne	%rsi, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L240:
	leaq	.LC2(%rip), %rdx
	testq	%rsi, %rsi
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L241:
	movl	$91, %ecx
	xorl	%r13d, %r13d
	call	putchar
	movl	8(%rsi), %r9d
	testl	%r9d, %r9d
	jle	.L280
.L250:
	movq	%r13, %rax
	salq	$4, %rax
	addq	(%rsi), %rax
	cmpl	$10, (%rax)
	movq	8(%rax), %rbp
	ja	.L251
	movl	(%rax), %eax
	leaq	.L253(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L253:
	.long	.L260-.L253
	.long	.L259-.L253
	.long	.L258-.L253
	.long	.L257-.L253
	.long	.L256-.L253
	.long	.L255-.L253
	.long	.L254-.L253
	.long	.L251-.L253
	.long	.L251-.L253
	.long	.L251-.L253
	.long	.L252-.L253
	.text
	.p2align 4,,10
	.p2align 3
.L242:
	leaq	.LC3(%rip), %rdx
	testq	%rsi, %rsi
	cmovne	%rsi, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L243:
	leaq	.LC4(%rip), %rcx
	movq	%rsi, %rdx
	call	printf
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L244:
	leaq	.LC6(%rip), %rdx
	movq	%rsi, %r8
	movq	%rsi, %xmm2
	leaq	80(%rsp), %rcx
	call	sprintf
	leaq	80(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L567
.L249:
	leaq	80(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L245:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L389:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L237:
	movl	$123, %ecx
	xorl	%r13d, %r13d
	call	putchar
	movl	12(%rsi), %eax
	movl	$0, 48(%rsp)
	movl	$0, 40(%rsp)
	testl	%eax, %eax
	jle	.L311
.L281:
	movl	48(%rsp), %edx
	cmpl	%edx, 8(%rsi)
	jle	.L311
	movq	(%rsi), %rdx
	movq	(%rdx,%r13), %rbp
	cmpq	$1, %rbp
	jbe	.L282
	movl	48(%rsp), %edx
	testl	%edx, %edx
	jne	.L568
.L283:
	leaq	.LC8(%rip), %rcx
	movq	%rbp, %rdx
	call	printf
	movq	(%rsi), %rax
	addq	%r13, %rax
	cmpl	$10, 8(%rax)
	movq	16(%rax), %rbp
	ja	.L284
	movl	8(%rax), %eax
	leaq	.L286(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L286:
	.long	.L293-.L286
	.long	.L292-.L286
	.long	.L291-.L286
	.long	.L290-.L286
	.long	.L289-.L286
	.long	.L288-.L286
	.long	.L287-.L286
	.long	.L284-.L286
	.long	.L284-.L286
	.long	.L284-.L286
	.long	.L285-.L286
	.text
	.p2align 4,,10
	.p2align 3
.L239:
	movq	(%rsi), %rdx
	leaq	.LC9(%rip), %rax
	movq	%rax, %rcx
	movq	%rax, 48(%rsp)
	call	printf
	movl	16(%rsi), %eax
	testl	%eax, %eax
	jle	.L569
	leaq	.LC10(%rip), %rax
	xorl	%r13d, %r13d
	movq	%rax, 40(%rsp)
	leaq	.LC11(%rip), %r14
.L313:
	movq	8(%rsi), %rax
	movq	%r13, %rbp
	movq	%r14, %rcx
	salq	$5, %rbp
	movq	8(%rax,%rbp), %rdx
	call	printf
	movq	8(%rsi), %rax
	addq	%rbp, %rax
	cmpl	$10, 16(%rax)
	movq	24(%rax), %rbp
	ja	.L314
	movl	16(%rax), %eax
	leaq	.L316(%rip), %rcx
	movslq	(%rcx,%rax,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L316:
	.long	.L323-.L316
	.long	.L322-.L316
	.long	.L321-.L316
	.long	.L320-.L316
	.long	.L319-.L316
	.long	.L318-.L316
	.long	.L317-.L316
	.long	.L314-.L316
	.long	.L314-.L316
	.long	.L314-.L316
	.long	.L315-.L316
	.text
	.p2align 4,,10
	.p2align 3
.L387:
	leaq	.LC4(%rip), %rcx
	movq	%rsi, %rdx
	call	printf
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L388:
	leaq	.LC6(%rip), %rdx
	movq	%rsi, %r8
	movq	%rsi, %xmm2
	leaq	80(%rsp), %rcx
	call	sprintf
	leaq	80(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L570
.L393:
	leaq	80(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L351:
	movl	$123, %ecx
	call	putchar
	movl	12(%rsi), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	testl	%eax, %eax
	jle	.L371
.L368:
	cmpl	%r9d, 8(%rsi)
	jle	.L371
	movq	(%rsi), %rdx
	movq	(%rdx,%r8), %rdx
	cmpq	$1, %rdx
	jbe	.L369
	testl	%r9d, %r9d
	jne	.L571
.L370:
	leaq	.LC8(%rip), %rcx
	movq	%r8, 40(%rsp)
	movl	%r9d, 56(%rsp)
	movl	%r10d, 48(%rsp)
	call	printf
	movq	40(%rsp), %rax
	addq	(%rsi), %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	56(%rsp), %r9d
	movl	12(%rsi), %eax
	movl	48(%rsp), %r10d
	movq	40(%rsp), %r8
	addl	$1, %r9d
.L369:
	addl	$1, %r10d
	addq	$24, %r8
	cmpl	%eax, %r10d
	jl	.L368
.L371:
	movl	$125, %ecx
	call	putchar
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L356:
	leaq	.LC3(%rip), %rdx
	testq	%rsi, %rsi
	cmovne	%rsi, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L357:
	leaq	.LC4(%rip), %rcx
	movq	%rsi, %rdx
	call	printf
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L358:
	leaq	.LC6(%rip), %rdx
	movq	%rsi, %r8
	movq	%rsi, %xmm2
	leaq	80(%rsp), %rcx
	call	sprintf
	leaq	80(%rsp), %rcx
	movl	$46, %edx
	call	strchr
	testq	%rax, %rax
	je	.L572
.L363:
	leaq	80(%rsp), %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L359:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L354:
	leaq	.LC2(%rip), %rdx
	testq	%rsi, %rsi
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L355:
	movl	$91, %ecx
	call	putchar
	movl	8(%rsi), %r14d
	xorl	%r8d, %r8d
	testl	%r14d, %r14d
	jle	.L367
.L364:
	movq	%r8, %rax
	movq	%r8, 40(%rsp)
	salq	$4, %rax
	addq	(%rsi), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rsi), %eax
	movq	40(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L573
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L364
.L367:
	movl	$93, %ecx
	call	putchar
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L353:
	movq	(%rsi), %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	16(%rsi), %r13d
	xorl	%r9d, %r9d
	testl	%r13d, %r13d
	jle	.L376
.L373:
	movq	8(%rsi), %rax
	movq	%r9, %r8
	movq	%r9, 48(%rsp)
	leaq	.LC11(%rip), %rcx
	salq	$5, %r8
	movq	%r8, 40(%rsp)
	movq	8(%rax,%r8), %rdx
	call	printf
	movq	40(%rsp), %r8
	addq	8(%rsi), %r8
	movq	24(%r8), %rdx
	movl	16(%r8), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rsi), %eax
	movq	48(%rsp), %r9
	leal	-1(%rax), %edx
	cmpl	%r9d, %edx
	jg	.L574
	addq	$1, %r9
	cmpl	%r9d, %eax
	jg	.L373
.L376:
	leaq	.LC10(%rip), %rcx
	call	printf
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L251:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L261:
	movl	8(%rsi), %eax
	leal	-1(%rax), %edx
	cmpl	%r13d, %edx
	jg	.L575
	leaq	1(%r13), %rdx
	cmpl	%edx, %eax
	movq	%rdx, %r13
	jg	.L250
.L280:
	movl	$93, %ecx
	call	putchar
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L314:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L324:
	movl	16(%rsi), %eax
	leal	-1(%rax), %edx
	cmpl	%r13d, %edx
	jg	.L576
	leaq	1(%r13), %rcx
	cmpl	%ecx, %eax
	movq	%rcx, %r13
	jg	.L313
.L343:
	movq	40(%rsp), %rcx
	call	printf
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L395:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L405:
	movl	8(%rsi), %eax
	leal	-1(%rax), %edx
	cmpl	%r13d, %edx
	jg	.L577
	leaq	1(%r13), %rdx
	cmpl	%edx, %eax
	movq	%rdx, %r13
	jg	.L394
.L424:
	movl	$93, %ecx
	call	putchar
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L431:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L441:
	movl	16(%rsi), %eax
	leal	-1(%rax), %edx
	cmpl	%r13d, %edx
	jg	.L578
	leaq	1(%r13), %rcx
	cmpl	%ecx, %eax
	movq	%rcx, %r13
	jg	.L430
.L460:
	movq	40(%rsp), %rcx
	call	printf
	jmp	.L390
	.p2align 4,,10
	.p2align 3
.L284:
	leaq	.LC12(%rip), %rcx
	call	printf
	.p2align 4,,10
	.p2align 3
.L294:
	addl	$1, 48(%rsp)
	movl	12(%rsi), %eax
.L282:
	addl	$1, 40(%rsp)
	addq	$24, %r13
	cmpl	%eax, 40(%rsp)
	jl	.L281
.L311:
	movl	$125, %ecx
	call	putchar
	jmp	.L246
	.p2align 4,,10
	.p2align 3
.L255:
	leaq	.LC2(%rip), %rdx
	testq	%rbp, %rbp
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L256:
	movl	$91, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	8(%rbp), %r8d
	testl	%r8d, %r8d
	jle	.L268
.L265:
	movq	%r12, %rax
	salq	$4, %rax
	addq	0(%rbp), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rbp), %eax
	leal	-1(%rax), %edx
	cmpl	%r12d, %edx
	jg	.L579
	addq	$1, %r12
	cmpl	%r12d, %eax
	jg	.L265
.L268:
	movl	$93, %ecx
	call	putchar
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L257:
	leaq	.LC3(%rip), %rdx
	testq	%rbp, %rbp
	cmovne	%rbp, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L258:
	leaq	.LC4(%rip), %rcx
	movq	%rbp, %rdx
	call	printf
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L259:
	leaq	.LC6(%rip), %rdx
	movq	%rbp, %r8
	leaq	80(%rsp), %rbp
	movq	%r8, %xmm2
	movq	%rbp, %rcx
	movq	%rbp, %r15
	call	sprintf
	movl	$46, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	je	.L580
.L264:
	leaq	.LC5(%rip), %rcx
	movq	%r15, %rdx
	call	printf
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L260:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L399:
	leaq	.LC2(%rip), %rdx
	testq	%rbp, %rbp
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L400:
	movl	$91, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	8(%rbp), %r10d
	testl	%r10d, %r10d
	jle	.L412
.L409:
	movq	%r12, %rax
	salq	$4, %rax
	addq	0(%rbp), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rbp), %eax
	leal	-1(%rax), %edx
	cmpl	%r12d, %edx
	jg	.L581
	addq	$1, %r12
	cmpl	%r12d, %eax
	jg	.L409
.L412:
	movl	$93, %ecx
	call	putchar
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L401:
	leaq	.LC3(%rip), %rdx
	testq	%rbp, %rbp
	cmovne	%rbp, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L402:
	leaq	.LC4(%rip), %rcx
	movq	%rbp, %rdx
	call	printf
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L403:
	leaq	.LC6(%rip), %rdx
	movq	%rbp, %r8
	leaq	80(%rsp), %rbp
	movq	%r8, %xmm2
	movq	%rbp, %rcx
	movq	%rbp, %r15
	call	sprintf
	movl	$46, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	je	.L582
.L408:
	leaq	.LC5(%rip), %rcx
	movq	%r15, %rdx
	call	printf
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L404:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L252:
	movl	$123, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	12(%rbp), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L272
.L269:
	cmpl	%r8d, 8(%rbp)
	jle	.L272
	movq	0(%rbp), %rdx
	movq	(%rdx,%r12), %rdx
	cmpq	$1, %rdx
	jbe	.L270
	testl	%r8d, %r8d
	jne	.L583
.L271:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 48(%rsp)
	movl	%r9d, 40(%rsp)
	call	printf
	movq	0(%rbp), %rax
	addq	%r12, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	48(%rsp), %r8d
	movl	12(%rbp), %eax
	movl	40(%rsp), %r9d
	addl	$1, %r8d
.L270:
	addl	$1, %r9d
	addq	$24, %r12
	cmpl	%eax, %r9d
	jl	.L269
.L272:
	movl	$125, %ecx
	call	putchar
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L254:
	movq	0(%rbp), %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	16(%rbp), %ecx
	xorl	%r8d, %r8d
	testl	%ecx, %ecx
	jle	.L277
.L274:
	movq	8(%rbp), %rax
	movq	%r8, %r12
	movq	%r8, 40(%rsp)
	leaq	.LC11(%rip), %rcx
	salq	$5, %r12
	movq	8(%rax,%r12), %rdx
	call	printf
	addq	8(%rbp), %r12
	movq	24(%r12), %rdx
	movl	16(%r12), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rbp), %eax
	movq	40(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L584
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L274
.L277:
	leaq	.LC10(%rip), %rcx
	call	printf
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L432:
	movl	$123, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	12(%rbp), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L452
.L449:
	cmpl	%r8d, 8(%rbp)
	jle	.L452
	movq	0(%rbp), %rdx
	movq	(%rdx,%r12), %rdx
	cmpq	$1, %rdx
	jbe	.L450
	testl	%r8d, %r8d
	jne	.L585
.L451:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 64(%rsp)
	movl	%r9d, 56(%rsp)
	call	printf
	movq	0(%rbp), %rax
	addq	%r12, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	64(%rsp), %r8d
	movl	12(%rbp), %eax
	movl	56(%rsp), %r9d
	addl	$1, %r8d
.L450:
	addl	$1, %r9d
	addq	$24, %r12
	cmpl	%eax, %r9d
	jl	.L449
.L452:
	movl	$125, %ecx
	call	putchar
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L434:
	movq	0(%rbp), %rdx
	movq	48(%rsp), %rcx
	call	printf
	movl	16(%rbp), %eax
	xorl	%r8d, %r8d
	testl	%eax, %eax
	jle	.L457
.L454:
	movq	8(%rbp), %rax
	movq	%r8, %r12
	movq	%r14, %rcx
	movq	%r8, 56(%rsp)
	salq	$5, %r12
	movq	8(%rax,%r12), %rdx
	call	printf
	addq	8(%rbp), %r12
	movq	24(%r12), %rdx
	movl	16(%r12), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rbp), %eax
	movq	56(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L586
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L454
.L457:
	movq	40(%rsp), %rcx
	call	printf
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L322:
	leaq	.LC6(%rip), %rdx
	movq	%rbp, %r8
	leaq	80(%rsp), %rbp
	movq	%r8, %xmm2
	movq	%rbp, %rcx
	movq	%rbp, %r15
	call	sprintf
	movl	$46, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	je	.L587
.L327:
	leaq	.LC5(%rip), %rcx
	movq	%r15, %rdx
	call	printf
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L323:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L437:
	leaq	.LC3(%rip), %rdx
	testq	%rbp, %rbp
	cmovne	%rbp, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L438:
	leaq	.LC4(%rip), %rcx
	movq	%rbp, %rdx
	call	printf
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L439:
	leaq	.LC6(%rip), %rdx
	movq	%rbp, %r8
	leaq	80(%rsp), %rbp
	movq	%r8, %xmm2
	movq	%rbp, %rcx
	movq	%rbp, %r15
	call	sprintf
	movl	$46, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	je	.L588
.L444:
	leaq	.LC5(%rip), %rcx
	movq	%r15, %rdx
	call	printf
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L440:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L396:
	movl	$123, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	12(%rbp), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L416
.L413:
	cmpl	%r8d, 8(%rbp)
	jle	.L416
	movq	0(%rbp), %rdx
	movq	(%rdx,%r12), %rdx
	cmpq	$1, %rdx
	jbe	.L414
	testl	%r8d, %r8d
	jne	.L589
.L415:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 64(%rsp)
	movl	%r9d, 56(%rsp)
	call	printf
	movq	0(%rbp), %rax
	addq	%r12, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	64(%rsp), %r8d
	movl	12(%rbp), %eax
	movl	56(%rsp), %r9d
	addl	$1, %r8d
.L414:
	addl	$1, %r9d
	addq	$24, %r12
	cmpl	%eax, %r9d
	jl	.L413
.L416:
	movl	$125, %ecx
	call	putchar
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L315:
	movl	$123, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	12(%rbp), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L335
.L332:
	cmpl	%r8d, 8(%rbp)
	jle	.L335
	movq	0(%rbp), %rdx
	movq	(%rdx,%r12), %rdx
	cmpq	$1, %rdx
	jbe	.L333
	testl	%r8d, %r8d
	jne	.L590
.L334:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 64(%rsp)
	movl	%r9d, 56(%rsp)
	call	printf
	movq	0(%rbp), %rax
	addq	%r12, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	64(%rsp), %r8d
	movl	12(%rbp), %eax
	movl	56(%rsp), %r9d
	addl	$1, %r8d
.L333:
	addl	$1, %r9d
	addq	$24, %r12
	cmpl	%eax, %r9d
	jl	.L332
.L335:
	movl	$125, %ecx
	call	putchar
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L317:
	movq	0(%rbp), %rdx
	movq	48(%rsp), %rcx
	call	printf
	movl	16(%rbp), %eax
	xorl	%r8d, %r8d
	testl	%eax, %eax
	jle	.L340
.L337:
	movq	8(%rbp), %rax
	movq	%r8, %r12
	movq	%r14, %rcx
	movq	%r8, 56(%rsp)
	salq	$5, %r12
	movq	8(%rax,%r12), %rdx
	call	printf
	addq	8(%rbp), %r12
	movq	24(%r12), %rdx
	movl	16(%r12), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rbp), %eax
	movq	56(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L591
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L337
.L340:
	movq	40(%rsp), %rcx
	call	printf
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L398:
	movq	0(%rbp), %rdx
	movq	48(%rsp), %rcx
	call	printf
	movl	16(%rbp), %r9d
	xorl	%r8d, %r8d
	testl	%r9d, %r9d
	jle	.L421
.L418:
	movq	8(%rbp), %rax
	movq	%r8, %r12
	movq	%r14, %rcx
	movq	%r8, 56(%rsp)
	salq	$5, %r12
	movq	8(%rax,%r12), %rdx
	call	printf
	addq	8(%rbp), %r12
	movq	24(%r12), %rdx
	movl	16(%r12), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rbp), %eax
	movq	56(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L592
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L418
.L421:
	movq	40(%rsp), %rcx
	call	printf
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L318:
	leaq	.LC2(%rip), %rdx
	testq	%rbp, %rbp
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L319:
	movl	$91, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	8(%rbp), %eax
	testl	%eax, %eax
	jle	.L331
.L328:
	movq	%r12, %rax
	salq	$4, %rax
	addq	0(%rbp), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rbp), %eax
	leal	-1(%rax), %edx
	cmpl	%r12d, %edx
	jg	.L593
	addq	$1, %r12
	cmpl	%r12d, %eax
	jg	.L328
.L331:
	movl	$93, %ecx
	call	putchar
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L435:
	leaq	.LC2(%rip), %rdx
	testq	%rbp, %rbp
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L436:
	movl	$91, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	8(%rbp), %edx
	testl	%edx, %edx
	jle	.L448
.L445:
	movq	%r12, %rax
	salq	$4, %rax
	addq	0(%rbp), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rbp), %eax
	leal	-1(%rax), %edx
	cmpl	%r12d, %edx
	jg	.L594
	addq	$1, %r12
	cmpl	%r12d, %eax
	jg	.L445
.L448:
	movl	$93, %ecx
	call	putchar
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L320:
	leaq	.LC3(%rip), %rdx
	testq	%rbp, %rbp
	cmovne	%rbp, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L321:
	leaq	.LC4(%rip), %rcx
	movq	%rbp, %rdx
	call	printf
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L290:
	leaq	.LC3(%rip), %rdx
	testq	%rbp, %rbp
	cmovne	%rbp, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L291:
	leaq	.LC4(%rip), %rcx
	movq	%rbp, %rdx
	call	printf
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L292:
	leaq	.LC6(%rip), %rdx
	movq	%rbp, %r8
	leaq	80(%rsp), %rbp
	movq	%r8, %xmm2
	movq	%rbp, %rcx
	movq	%rbp, %r15
	call	sprintf
	movl	$46, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	je	.L595
.L297:
	leaq	.LC5(%rip), %rcx
	movq	%r15, %rdx
	call	printf
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L293:
	leaq	.LC3(%rip), %rcx
	call	printf
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L285:
	movl	$123, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	12(%rbp), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L305
.L302:
	cmpl	%r8d, 8(%rbp)
	jle	.L305
	movq	0(%rbp), %rdx
	movq	(%rdx,%r12), %rdx
	cmpq	$1, %rdx
	jbe	.L303
	testl	%r8d, %r8d
	jne	.L596
.L304:
	leaq	.LC8(%rip), %rcx
	movl	%r8d, 64(%rsp)
	movl	%r9d, 56(%rsp)
	call	printf
	movq	0(%rbp), %rax
	addq	%r12, %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	64(%rsp), %r8d
	movl	12(%rbp), %eax
	movl	56(%rsp), %r9d
	addl	$1, %r8d
.L303:
	addl	$1, %r9d
	addq	$24, %r12
	cmpl	%eax, %r9d
	jl	.L302
.L305:
	movl	$125, %ecx
	call	putchar
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L287:
	movq	0(%rbp), %rdx
	leaq	.LC9(%rip), %rcx
	call	printf
	movl	16(%rbp), %eax
	xorl	%r8d, %r8d
	testl	%eax, %eax
	jle	.L310
.L307:
	movq	8(%rbp), %rax
	movq	%r8, %r12
	movq	%r8, 56(%rsp)
	leaq	.LC11(%rip), %rcx
	salq	$5, %r12
	movq	8(%rax,%r12), %rdx
	call	printf
	addq	8(%rbp), %r12
	movq	24(%r12), %rdx
	movl	16(%r12), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rbp), %eax
	movq	56(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L597
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L307
.L310:
	leaq	.LC10(%rip), %rcx
	call	printf
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L288:
	leaq	.LC2(%rip), %rdx
	testq	%rbp, %rbp
	leaq	.LC1(%rip), %rax
	cmovne	%rax, %rdx
	leaq	.LC5(%rip), %rcx
	call	printf
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L289:
	movl	$91, %ecx
	xorl	%r12d, %r12d
	call	putchar
	movl	8(%rbp), %eax
	testl	%eax, %eax
	jle	.L301
.L298:
	movq	%r12, %rax
	salq	$4, %rax
	addq	0(%rbp), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rbp), %eax
	leal	-1(%rax), %edx
	cmpl	%r12d, %edx
	jg	.L598
	addq	$1, %r12
	cmpl	%r12d, %eax
	jg	.L298
.L301:
	movl	$93, %ecx
	call	putchar
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L565:
	leaq	.LC7(%rip), %rcx
	addq	$1, %rdi
	call	printf
	cmpl	%edi, 16(%rbx)
	jg	.L379
	jmp	.L463
	.p2align 4,,10
	.p2align 3
.L564:
	leaq	.LC7(%rip), %rcx
	addq	$1, %rdi
	call	printf
	cmpl	%edi, 8(%rbx)
	jg	.L235
	jmp	.L346
	.p2align 4,,10
	.p2align 3
.L577:
	leaq	.LC7(%rip), %rcx
	call	printf
	leaq	1(%r13), %rax
	cmpl	%eax, 8(%rsi)
	movq	%rax, %r13
	jg	.L394
	jmp	.L424
	.p2align 4,,10
	.p2align 3
.L578:
	leaq	.LC7(%rip), %rcx
	call	printf
	leaq	1(%r13), %rax
	cmpl	%eax, 16(%rsi)
	movq	%rax, %r13
	jg	.L430
	jmp	.L460
	.p2align 4,,10
	.p2align 3
.L576:
	leaq	.LC7(%rip), %rcx
	call	printf
	leaq	1(%r13), %rax
	cmpl	%eax, 16(%rsi)
	movq	%rax, %r13
	jg	.L313
	jmp	.L343
	.p2align 4,,10
	.p2align 3
.L575:
	leaq	.LC7(%rip), %rcx
	call	printf
	leaq	1(%r13), %rax
	cmpl	%eax, 8(%rsi)
	movq	%rax, %r13
	jg	.L250
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L574:
	leaq	.LC7(%rip), %rcx
	movq	%r9, 40(%rsp)
	call	printf
	movq	40(%rsp), %r9
	addq	$1, %r9
	cmpl	%r9d, 16(%rsi)
	jg	.L373
	jmp	.L376
	.p2align 4,,10
	.p2align 3
.L573:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	40(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 8(%rsi)
	jg	.L364
	jmp	.L367
	.p2align 4,,10
	.p2align 3
.L566:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 64(%rsp)
	movq	%rdx, 56(%rsp)
	call	printf
	movl	64(%rsp), %r8d
	movq	56(%rsp), %rdx
	jmp	.L427
	.p2align 4,,10
	.p2align 3
.L568:
	leaq	.LC7(%rip), %rcx
	call	printf
	jmp	.L283
	.p2align 4,,10
	.p2align 3
.L561:
	leaq	80(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L234
	leaq	80(%rsp), %rcx
	movl	$12334, %ebx
	call	strlen
	movw	%bx, 80(%rsp,%rax)
	movb	$0, 82(%rsp,%rax)
	jmp	.L234
	.p2align 4,,10
	.p2align 3
.L571:
	leaq	.LC7(%rip), %rcx
	movq	%r8, 64(%rsp)
	movl	%r9d, 56(%rsp)
	movl	%r10d, 48(%rsp)
	movq	%rdx, 40(%rsp)
	call	printf
	movq	64(%rsp), %r8
	movl	56(%rsp), %r9d
	movl	48(%rsp), %r10d
	movq	40(%rsp), %rdx
	jmp	.L370
	.p2align 4,,10
	.p2align 3
.L562:
	leaq	.LC10(%rip), %rax
	movq	%rax, 40(%rsp)
	jmp	.L463
	.p2align 4,,10
	.p2align 3
.L591:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	56(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 16(%rbp)
	jg	.L337
	jmp	.L340
	.p2align 4,,10
	.p2align 3
.L579:
	leaq	.LC7(%rip), %rcx
	addq	$1, %r12
	call	printf
	cmpl	%r12d, 8(%rbp)
	jg	.L265
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L592:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	56(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 16(%rbp)
	jg	.L418
	jmp	.L421
	.p2align 4,,10
	.p2align 3
.L594:
	leaq	.LC7(%rip), %rcx
	addq	$1, %r12
	call	printf
	cmpl	%r12d, 8(%rbp)
	jg	.L445
	jmp	.L448
	.p2align 4,,10
	.p2align 3
.L581:
	leaq	.LC7(%rip), %rcx
	addq	$1, %r12
	call	printf
	cmpl	%r12d, 8(%rbp)
	jg	.L409
	jmp	.L412
	.p2align 4,,10
	.p2align 3
.L584:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	40(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 16(%rbp)
	jg	.L274
	jmp	.L277
	.p2align 4,,10
	.p2align 3
.L593:
	leaq	.LC7(%rip), %rcx
	addq	$1, %r12
	call	printf
	cmpl	%r12d, 8(%rbp)
	jg	.L328
	jmp	.L331
	.p2align 4,,10
	.p2align 3
.L586:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	56(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 16(%rbp)
	jg	.L454
	jmp	.L457
	.p2align 4,,10
	.p2align 3
.L585:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 76(%rsp)
	movl	%r9d, 64(%rsp)
	movq	%rdx, 56(%rsp)
	call	printf
	movl	76(%rsp), %r8d
	movl	64(%rsp), %r9d
	movq	56(%rsp), %rdx
	jmp	.L451
	.p2align 4,,10
	.p2align 3
.L589:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 76(%rsp)
	movl	%r9d, 64(%rsp)
	movq	%rdx, 56(%rsp)
	call	printf
	movl	76(%rsp), %r8d
	movl	64(%rsp), %r9d
	movq	56(%rsp), %rdx
	jmp	.L415
	.p2align 4,,10
	.p2align 3
.L583:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 56(%rsp)
	movl	%r9d, 48(%rsp)
	movq	%rdx, 40(%rsp)
	call	printf
	movl	56(%rsp), %r8d
	movl	48(%rsp), %r9d
	movq	40(%rsp), %rdx
	jmp	.L271
	.p2align 4,,10
	.p2align 3
.L590:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 76(%rsp)
	movl	%r9d, 64(%rsp)
	movq	%rdx, 56(%rsp)
	call	printf
	movl	76(%rsp), %r8d
	movl	64(%rsp), %r9d
	movq	56(%rsp), %rdx
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L598:
	leaq	.LC7(%rip), %rcx
	addq	$1, %r12
	call	printf
	cmpl	%r12d, 8(%rbp)
	jg	.L298
	jmp	.L301
	.p2align 4,,10
	.p2align 3
.L597:
	leaq	.LC7(%rip), %rcx
	call	printf
	movq	56(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 16(%rbp)
	jg	.L307
	jmp	.L310
	.p2align 4,,10
	.p2align 3
.L567:
	leaq	80(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L249
	leaq	80(%rsp), %rcx
	call	strlen
	movl	$12334, %r10d
	movw	%r10w, 80(%rsp,%rax)
	movb	$0, 82(%rsp,%rax)
	jmp	.L249
	.p2align 4,,10
	.p2align 3
.L570:
	leaq	80(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L393
	leaq	80(%rsp), %rcx
	movl	$12334, %esi
	call	strlen
	movw	%si, 80(%rsp,%rax)
	movb	$0, 82(%rsp,%rax)
	jmp	.L393
	.p2align 4,,10
	.p2align 3
.L596:
	leaq	.LC7(%rip), %rcx
	movl	%r8d, 76(%rsp)
	movl	%r9d, 64(%rsp)
	movq	%rdx, 56(%rsp)
	call	printf
	movl	76(%rsp), %r8d
	movl	64(%rsp), %r9d
	movq	56(%rsp), %rdx
	jmp	.L304
.L569:
	leaq	.LC10(%rip), %rax
	movq	%rax, 40(%rsp)
	jmp	.L343
.L572:
	leaq	80(%rsp), %rcx
	movl	$101, %edx
	call	strchr
	testq	%rax, %rax
	jne	.L363
	leaq	80(%rsp), %rcx
	movl	$12334, %r15d
	call	strlen
	movw	%r15w, 80(%rsp,%rax)
	movb	$0, 82(%rsp,%rax)
	jmp	.L363
.L580:
	movl	$101, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L264
	movq	%rbp, %rcx
	call	strlen
	movw	$12334, 0(%rbp,%rax)
	movb	$0, 2(%rbp,%rax)
	jmp	.L264
.L582:
	movl	$101, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L408
	movq	%rbp, %rcx
	call	strlen
	movw	$12334, 0(%rbp,%rax)
	movb	$0, 2(%rbp,%rax)
	jmp	.L408
.L587:
	movl	$101, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L327
	movq	%rbp, %rcx
	call	strlen
	movw	$12334, 0(%rbp,%rax)
	movb	$0, 2(%rbp,%rax)
	jmp	.L327
.L588:
	movl	$101, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L444
	movq	%rbp, %rcx
	call	strlen
	movw	$12334, 0(%rbp,%rax)
	movb	$0, 2(%rbp,%rax)
	jmp	.L444
.L595:
	movl	$101, %edx
	movq	%rbp, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L297
	movq	%rbp, %rcx
	call	strlen
	movw	$12334, 0(%rbp,%rax)
	movb	$0, 2(%rbp,%rax)
	jmp	.L297
	.seh_endproc
	.p2align 4
	.def	vyne_to_string;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_to_string
vyne_to_string:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$360, %rsp
	.seh_stackalloc	360
	.seh_endprologue
	movq	8(%rdx), %r12
	movq	%rcx, %rbx
	movq	(%rdx), %rcx
	cmpl	$10, %ecx
	ja	.L600
	leaq	.L602(%rip), %rdx
	movl	%ecx, %eax
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L602:
	.long	.L609-.L602
	.long	.L608-.L602
	.long	.L607-.L602
	.long	.L606-.L602
	.long	.L605-.L602
	.long	.L604-.L602
	.long	.L603-.L602
	.long	.L600-.L602
	.long	.L600-.L602
	.long	.L600-.L602
	.long	.L601-.L602
	.text
	.p2align 4,,10
	.p2align 3
.L600:
	movabsq	$6734116630053416795, %rax
	movb	$0, 104(%rsp)
	movq	%rax, 96(%rsp)
	leaq	96(%rsp), %rdi
.L610:
	movq	%rdi, %rcx
	call	strlen
	movq	g_arena_cur(%rip), %rcx
	leaq	8(%rax), %rsi
	movq	%rax, %rbp
	andq	$-8, %rsi
	testq	%rcx, %rcx
	je	.L660
	movq	g_arena_end(%rip), %rax
	subq	%rcx, %rax
	cmpq	%rsi, %rax
	jb	.L660
	leaq	(%rcx,%rsi), %rax
	addq	8+g_arena(%rip), %rsi
	movq	%rax, g_arena_cur(%rip)
.L663:
	leaq	1(%rbp), %r8
	movq	%rdi, %rdx
	movq	%rsi, 8+g_arena(%rip)
	call	memcpy
	movq	$3, (%rbx)
	movq	%rax, 8(%rbx)
.L599:
	movq	%rbx, %rax
	addq	$360, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L609:
	movl	$1819047278, 96(%rsp)
	leaq	96(%rsp), %rdi
	movb	$0, 100(%rsp)
	jmp	.L610
	.p2align 4,,10
	.p2align 3
.L605:
	movl	8(%r12), %edi
	movl	$8, %esi
	testl	%edi, %edi
	jle	.L613
	leaq	64(%rsp), %rbp
	xorl	%edi, %edi
	movl	$2, %esi
.L615:
	leaq	80(%rsp), %rcx
	movq	%rdi, %rax
	movq	%rbp, %rdx
	salq	$4, %rax
	addq	(%r12), %rax
	movdqu	(%rax), %xmm1
	movaps	%xmm1, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	addq	%rax, %rsi
	testq	%rdi, %rdi
	leaq	2(%rsi), %rax
	cmovne	%rax, %rsi
	addq	$1, %rdi
	cmpl	%edi, 8(%r12)
	jg	.L615
	addq	$8, %rsi
	andq	$-8, %rsi
.L613:
	movq	g_arena_cur(%rip), %rdi
	testq	%rdi, %rdi
	je	.L616
	movq	g_arena_end(%rip), %rax
	subq	%rdi, %rax
	cmpq	%rsi, %rax
	jb	.L616
	leaq	(%rdi,%rsi), %rbp
	addq	8+g_arena(%rip), %rsi
	movq	%rbp, g_arena_cur(%rip)
.L620:
	movq	%rsi, 8+g_arena(%rip)
	movb	$91, (%rdi)
	movl	8(%r12), %esi
	testl	%esi, %esi
	jle	.L621
	leaq	64(%rsp), %rbp
	xorl	%esi, %esi
	movl	$1, %r14d
.L623:
	testq	%rsi, %rsi
	je	.L622
	movzwl	.LC13(%rip), %edx
	leaq	(%rdi,%r14), %rax
	addq	$2, %r14
	movw	%dx, (%rax)
.L622:
	leaq	80(%rsp), %rcx
	movq	%rsi, %rax
	movq	%rbp, %rdx
	salq	$4, %rax
	addq	(%r12), %rax
	addq	$1, %rsi
	movdqu	(%rax), %xmm3
	movaps	%xmm3, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	movq	88(%rsp), %rdx
	leaq	(%rdi,%r14), %rcx
	movq	%rax, %r8
	addq	%rax, %r14
	call	memcpy
	cmpl	%esi, 8(%r12)
	jg	.L623
	movq	g_arena_cur(%rip), %rbp
	movb	$93, (%rdi,%r14)
	movb	$0, 1(%rdi,%r14)
	jmp	.L745
	.p2align 4,,10
	.p2align 3
.L604:
	leaq	.LC2(%rip), %rdx
	testq	%r12, %r12
	leaq	.LC1(%rip), %rax
	leaq	96(%rsp), %rdi
	cmovne	%rax, %rdx
	movq	%rdi, %rcx
	call	strcpy
	jmp	.L610
	.p2align 4,,10
	.p2align 3
.L603:
	movq	(%r12), %rcx
	call	strlen
	movl	16(%r12), %r11d
	leaq	4(%rax), %rsi
	testl	%r11d, %r11d
	jle	.L647
	leaq	64(%rsp), %rbp
	xorl	%r14d, %r14d
.L648:
	movq	%r14, %rdi
	addq	$1, %r14
	salq	$5, %rdi
	addq	8(%r12), %rdi
	movq	8(%rdi), %rcx
	call	strlen
	movdqu	16(%rdi), %xmm4
	movq	%rbp, %rdx
	leaq	80(%rsp), %rcx
	movq	%rax, %r15
	movaps	%xmm4, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	leaq	4(%r15,%rax), %rax
	addq	%rax, %rsi
	cmpl	%r14d, 16(%r12)
	jg	.L648
.L647:
	movq	g_arena_cur(%rip), %rdi
	addq	$7, %rsi
	andq	$-8, %rsi
	testq	%rdi, %rdi
	je	.L649
	movq	g_arena_end(%rip), %rax
	subq	%rdi, %rax
	cmpq	%rsi, %rax
	jb	.L649
	leaq	(%rdi,%rsi), %rbp
	addq	8+g_arena(%rip), %rsi
	movq	%rbp, g_arena_cur(%rip)
.L652:
	movq	%rsi, 8+g_arena(%rip)
	movq	(%r12), %rsi
	movq	%rsi, %rcx
	call	strlen
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movq	%rax, %r8
	call	memcpy
	movq	(%r12), %rcx
	call	strlen
	movl	$31520, %r9d
	movw	%r9w, (%rdi,%rax)
	leaq	3(%rax), %rsi
	movb	$32, 2(%rdi,%rax)
	movl	16(%r12), %r10d
	testl	%r10d, %r10d
	jle	.L653
	leaq	64(%rsp), %rbp
	xorl	%r15d, %r15d
.L655:
	testq	%r15, %r15
	je	.L654
	movzwl	.LC13(%rip), %edx
	leaq	(%rdi,%rsi), %rax
	addq	$2, %rsi
	movw	%dx, (%rax)
.L654:
	movq	8(%r12), %rax
	movq	%r15, %r14
	addq	$1, %r15
	salq	$5, %r14
	movq	8(%rax,%r14), %rdx
	movq	%rdx, %rcx
	movq	%rdx, 40(%rsp)
	call	strlen
	movq	40(%rsp), %rdx
	leaq	(%rdi,%rsi), %rcx
	movq	%rax, %r8
	movq	%rax, 32(%rsp)
	call	memcpy
	addq	32(%rsp), %rsi
	movq	%rbp, %rdx
	movzwl	.LC16(%rip), %eax
	leaq	80(%rsp), %rcx
	movw	%ax, (%rdi,%rsi)
	movq	8(%r12), %rax
	movdqu	16(%rax,%r14), %xmm5
	movaps	%xmm5, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	movq	88(%rsp), %rdx
	leaq	2(%rdi,%rsi), %rcx
	leaq	2(%rax,%rsi), %rsi
	movq	%rax, %r8
	call	memcpy
	cmpl	%r15d, 16(%r12)
	jg	.L655
	movq	g_arena_cur(%rip), %rbp
	movl	$32032, %r8d
	movb	$0, 2(%rdi,%rsi)
	movw	%r8w, (%rdi,%rsi)
.L745:
	movq	%rdi, %rcx
	call	strlen
	leaq	8(%rax), %rsi
	movq	%rax, %r13
	andq	$-8, %rsi
	testq	%rbp, %rbp
	je	.L656
.L667:
	movq	g_arena_end(%rip), %rax
	subq	%rbp, %rax
	cmpq	%rsi, %rax
	jb	.L656
	leaq	0(%rbp,%rsi), %rax
	addq	8+g_arena(%rip), %rsi
	movq	%rax, g_arena_cur(%rip)
.L659:
	leaq	1(%r13), %r8
	movq	%rdi, %rdx
	movq	%rbp, %rcx
	movq	%rsi, 8+g_arena(%rip)
	call	memcpy
	movq	$3, (%rbx)
	movq	%rbp, 8(%rbx)
	jmp	.L599
	.p2align 4,,10
	.p2align 3
.L601:
	movslq	8(%r12), %rax
	movl	$16, %r14d
	movq	g_arena_cur(%rip), %rbp
	movq	%rax, %rsi
	salq	$4, %rax
	testl	%esi, %esi
	cmovg	%rax, %r14
	testq	%rbp, %rbp
	je	.L630
	movq	g_arena_end(%rip), %rax
	movq	%rax, %rcx
	subq	%rbp, %rcx
	cmpq	%r14, %rcx
	jb	.L630
	movq	8+g_arena(%rip), %rdx
	leaq	0(%rbp,%r14), %rdi
	movq	%rdi, g_arena_cur(%rip)
	addq	%r14, %rdx
.L633:
	movslq	%esi, %r14
	movl	$8, %ecx
	movq	%rdx, 8+g_arena(%rip)
	salq	$3, %r14
	testl	%esi, %esi
	cmovle	%rcx, %r14
	subq	%rdi, %rax
	cmpq	%r14, %rax
	jb	.L747
	leaq	(%rdi,%r14), %r13
	addq	%rdx, %r14
	movq	%r13, g_arena_cur(%rip)
.L636:
	movl	12(%r12), %edx
	movq	%r14, 8+g_arena(%rip)
	testl	%edx, %edx
	jle	.L671
	testl	%esi, %esi
	jle	.L671
	leaq	80(%rsp), %rax
	xorl	%r13d, %r13d
	movl	$3, %r8d
	movq	%rax, 48(%rsp)
	leaq	64(%rsp), %rax
	xorl	%r15d, %r15d
	movq	%rax, 56(%rsp)
.L639:
	movq	(%r12), %rcx
	leaq	0(%r13,%r13,2), %rax
	leaq	(%rcx,%rax,8), %rcx
	movq	(%rcx), %rax
	cmpq	$1, %rax
	jbe	.L638
	movslq	%r15d, %rdx
	movq	%r8, 40(%rsp)
	addl	$1, %r15d
	movq	%rax, (%rdi,%rdx,8)
	salq	$4, %rdx
	movdqu	8(%rcx), %xmm2
	leaq	0(%rbp,%rdx), %r14
	movq	48(%rsp), %rcx
	movq	%rax, 32(%rsp)
	movq	56(%rsp), %rdx
	movaps	%xmm2, 64(%rsp)
	call	vyne_to_string
	movq	32(%rsp), %rcx
	movdqu	80(%rsp), %xmm0
	movups	%xmm0, (%r14)
	call	strlen
	movq	8(%r14), %rcx
	movq	%rax, 32(%rsp)
	call	strlen
	movq	32(%rsp), %rdx
	movq	40(%rsp), %r8
	leaq	8(%r8,%rdx), %r14
	movl	12(%r12), %edx
	leaq	(%rax,%r14), %r8
.L638:
	leal	1(%r13), %eax
	cmpl	%edx, %eax
	setl	%cl
	cmpl	%esi, %r15d
	setl	%al
	addq	$1, %r13
	testb	%al, %cl
	jne	.L639
	movq	g_arena_cur(%rip), %r13
	leaq	7(%r8), %r14
	andq	$-8, %r14
	testq	%r13, %r13
	je	.L640
.L637:
	movq	g_arena_end(%rip), %rax
	subq	%r13, %rax
	cmpq	%r14, %rax
	jb	.L640
	leaq	0(%r13,%r14), %rax
	addq	8+g_arena(%rip), %r14
	movq	%rax, g_arena_cur(%rip)
.L643:
	testl	%esi, %esi
	movq	%r14, 8+g_arena(%rip)
	movb	$123, 0(%r13)
	jle	.L672
	movb	$34, 1(%r13)
	movq	(%rdi), %r14
	movq	%r14, %rcx
	call	strlen
	leaq	2(%r13), %rcx
	movq	%r14, %rdx
	movq	%rax, %r8
	movq	%rax, %r12
	call	memcpy
	movzwl	.LC14(%rip), %r14d
	movb	$32, 4(%r13,%r12)
	movw	%r14w, 2(%r13,%r12)
	movq	8(%rbp), %rdx
	movq	%rdx, %rcx
	movq	%rdx, 32(%rsp)
	call	strlen
	movq	32(%rsp), %rdx
	leaq	5(%r13,%r12), %rcx
	leaq	5(%rax,%r12), %r12
	movq	%rax, %r8
	call	memcpy
	cmpl	$1, %esi
	je	.L645
	movzwl	.LC13(%rip), %r9d
	movl	$1, %r15d
.L646:
	movw	%r9w, 0(%r13,%r12)
	movb	$34, 2(%r13,%r12)
	movq	(%rdi,%r15,8), %rdx
	movq	%rdx, %rcx
	movq	%rdx, 40(%rsp)
	call	strlen
	movq	40(%rsp), %rdx
	leaq	3(%r13,%r12), %rcx
	movq	%rax, %r8
	movq	%rax, 32(%rsp)
	call	memcpy
	movq	32(%rsp), %r8
	movq	%r15, %rax
	addq	$1, %r15
	salq	$4, %rax
	leaq	3(%r12,%r8), %r12
	movw	%r14w, 0(%r13,%r12)
	movb	$32, 2(%r13,%r12)
	movq	8(%rbp,%rax), %rdx
	movq	%rdx, %rcx
	movq	%rdx, 40(%rsp)
	call	strlen
	movq	40(%rsp), %rdx
	leaq	3(%r13,%r12), %rcx
	movq	%rax, %r8
	movq	%rax, 32(%rsp)
	call	memcpy
	movq	32(%rsp), %r8
	cmpl	%r15d, %esi
	movzwl	.LC13(%rip), %r9d
	leaq	3(%r12,%r8), %r12
	jg	.L646
.L645:
	leaq	1(%r12), %rax
.L644:
	movb	$125, 0(%r13,%r12)
	movq	$3, (%rbx)
	movb	$0, 0(%r13,%rax)
	movq	%r13, 8(%rbx)
	jmp	.L599
	.p2align 4,,10
	.p2align 3
.L607:
	leaq	96(%rsp), %rdi
	movq	%r12, %r8
	leaq	.LC4(%rip), %rdx
	movq	%rdi, %rcx
	call	sprintf
	jmp	.L610
	.p2align 4,,10
	.p2align 3
.L608:
	leaq	96(%rsp), %rdi
	movq	%r12, %r8
	movq	%r12, %xmm2
	leaq	.LC6(%rip), %rdx
	movq	%rdi, %rcx
	call	sprintf
	movl	$46, %edx
	movq	%rdi, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L610
	movl	$101, %edx
	movq	%rdi, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L610
	movq	%rdi, %rcx
	movl	$12334, %ebp
	call	strlen
	movw	%bp, (%rdi,%rax)
	movb	$0, 2(%rdi,%rax)
	jmp	.L610
	.p2align 4,,10
	.p2align 3
.L606:
	movq	%rcx, (%rbx)
	movq	%r12, 8(%rbx)
	jmp	.L599
	.p2align 4,,10
	.p2align 3
.L660:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L740
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rcx
	movq	%rax, (%r12)
	je	.L627
	movq	g_arena(%rip), %rax
	movq	%rsi, 8(%r12)
	movq	$8388608, 16(%r12)
	movq	%r12, g_arena(%rip)
	movq	%rax, 24(%r12)
	leaq	(%rcx,%rsi), %rax
	addq	8+g_arena(%rip), %rsi
	movq	%rax, g_arena_cur(%rip)
	leaq	8388608(%rcx), %rax
	movq	%rax, g_arena_end(%rip)
	jmp	.L663
	.p2align 4,,10
	.p2align 3
.L656:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L740
	movl	$8388608, %edx
	cmpq	%rdx, %rsi
	cmovnb	%rsi, %rdx
	movq	%rdx, %rcx
	movq	%rdx, %r14
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rbp
	movq	%rax, (%r12)
	je	.L627
	leaq	0(%rbp,%r14), %rdx
	movq	%rsi, %xmm0
	movq	%r14, %xmm2
	movq	g_arena(%rip), %rax
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%r12)
	movq	%rax, 24(%r12)
	leaq	0(%rbp,%rsi), %rax
	addq	8+g_arena(%rip), %rsi
	movq	%r12, g_arena(%rip)
	movq	%rax, g_arena_cur(%rip)
	movq	%rdx, g_arena_end(%rip)
	jmp	.L659
	.p2align 4,,10
	.p2align 3
.L621:
	movl	$93, %ecx
	movw	%cx, 1(%rdi)
.L746:
	movq	%rdi, %rcx
	call	strlen
	leaq	8(%rax), %rsi
	movq	%rax, %r13
	andq	$-8, %rsi
	jmp	.L667
	.p2align 4,,10
	.p2align 3
.L653:
	movl	$32032, %edx
	movb	$0, 5(%rdi,%rax)
	movw	%dx, 3(%rdi,%rax)
	jmp	.L746
	.p2align 4,,10
	.p2align 3
.L671:
	movl	$8, %r14d
	jmp	.L637
	.p2align 4,,10
	.p2align 3
.L649:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L740
	movl	$8388608, %eax
	cmpq	%rax, %rsi
	cmovnb	%rsi, %rax
	movq	%rax, %rcx
	movq	%rax, %r13
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rdi
	movq	%rax, 0(%rbp)
	je	.L627
	movq	g_arena(%rip), %rax
	movq	%rsi, %xmm0
	movq	%r13, %xmm2
	movq	%rbp, g_arena(%rip)
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%rbp)
	movq	%rax, 24(%rbp)
	leaq	(%rdi,%rsi), %rbp
	addq	8+g_arena(%rip), %rsi
	movq	%rbp, g_arena_cur(%rip)
	leaq	(%rdi,%r13), %rax
	movq	%rax, g_arena_end(%rip)
	jmp	.L652
	.p2align 4,,10
	.p2align 3
.L747:
	movl	$32, %ecx
	movq	%rdx, 32(%rsp)
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L740
	movl	$8388608, %r15d
	cmpq	%r15, %r14
	cmovnb	%r14, %r15
	movq	%r15, %rcx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rdi
	movq	%rax, 0(%r13)
	je	.L627
	movq	g_arena(%rip), %rax
	movq	%r14, %xmm0
	movq	%r15, %xmm2
	addq	%rdi, %r15
	movq	%r13, g_arena(%rip)
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%r13)
	movq	%r15, g_arena_end(%rip)
	movq	%rax, 24(%r13)
	leaq	(%rdi,%r14), %r13
	addq	32(%rsp), %r14
	movq	%r13, g_arena_cur(%rip)
	jmp	.L636
	.p2align 4,,10
	.p2align 3
.L630:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rdi
	je	.L740
	movl	$8388608, %eax
	cmpq	%rax, %r14
	cmovnb	%r14, %rax
	movq	%rax, %rcx
	movq	%rax, %r13
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rbp
	movq	%rax, (%rdi)
	je	.L627
	movq	g_arena(%rip), %rax
	movq	%r14, %xmm0
	movq	%r13, %xmm2
	movq	%rdi, g_arena(%rip)
	movq	8+g_arena(%rip), %rdx
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%rdi)
	movq	%rax, 24(%rdi)
	leaq	0(%rbp,%r14), %rdi
	leaq	0(%rbp,%r13), %rax
	movq	%rdi, g_arena_cur(%rip)
	addq	%r14, %rdx
	movq	%rax, g_arena_end(%rip)
	jmp	.L633
	.p2align 4,,10
	.p2align 3
.L616:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L740
	movl	$8388608, %r13d
	cmpq	%r13, %rsi
	cmovnb	%rsi, %r13
	movq	%r13, %rcx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rdi
	movq	%rax, 0(%rbp)
	je	.L627
	movq	g_arena(%rip), %rax
	movq	%rsi, %xmm0
	movq	%r13, %xmm2
	addq	%rdi, %r13
	movq	%rbp, g_arena(%rip)
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%rbp)
	movq	%r13, g_arena_end(%rip)
	movq	%rax, 24(%rbp)
	leaq	(%rdi,%rsi), %rbp
	addq	8+g_arena(%rip), %rsi
	movq	%rbp, g_arena_cur(%rip)
	jmp	.L620
	.p2align 4,,10
	.p2align 3
.L640:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L740
	movl	$8388608, %eax
	cmpq	%rax, %r14
	cmovnb	%r14, %rax
	movq	%rax, %rcx
	movq	%rax, %r15
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r13
	movq	%rax, (%r12)
	je	.L627
	movq	g_arena(%rip), %rax
	movq	%r14, %xmm0
	movq	%r15, %xmm2
	movq	%r12, g_arena(%rip)
	punpcklqdq	%xmm2, %xmm0
	movups	%xmm0, 8(%r12)
	movq	%rax, 24(%r12)
	leaq	0(%r13,%r14), %rax
	addq	8+g_arena(%rip), %r14
	movq	%rax, g_arena_cur(%rip)
	leaq	0(%r13,%r15), %rax
	movq	%rax, g_arena_end(%rip)
	jmp	.L643
	.p2align 4,,10
	.p2align 3
.L672:
	movl	$2, %eax
	movl	$1, %r12d
	jmp	.L644
.L627:
	call	arena_alloc.part.0
.L740:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC18:
	.ascii "Int64\0"
.LC19:
	.ascii "Unknown\0"
.LC20:
	.ascii "Float64\0"
.LC21:
	.ascii "Boolean\0"
.LC22:
	.ascii "Array\0"
.LC23:
	.ascii "Map\0"
.LC24:
	.ascii "Struct\0"
.LC25:
	.ascii "Null\0"
	.align 8
.LC29:
	.ascii "Runtime error: Invalid operation between %s and %s\12\0"
	.text
	.p2align 4
	.def	vyne_binop.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_binop.constprop.0
vyne_binop.constprop.0:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	.seh_endprologue
	movq	(%rdx), %rax
	movq	8(%rdx), %r11
	movq	8(%r8), %r10
	movq	(%r8), %rdx
	cmpl	$2, %eax
	movq	%rcx, %r9
	jne	.L749
	cmpl	$2, %edx
	jne	.L750
	addq	%r11, %r10
	movq	$2, (%rcx)
	movq	%r10, 8(%rcx)
.L748:
	movq	%r9, %rax
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L749:
	cmpl	$1, %edx
	jne	.L752
	cmpl	$1, %eax
	jne	.L752
	movq	%r11, %xmm2
	movq	%r10, %xmm3
	movq	$1, (%rcx)
	addsd	%xmm3, %xmm2
	movq	%xmm2, 8(%r9)
	jmp	.L748
	.p2align 4,,10
	.p2align 3
.L750:
	cmpl	$3, %edx
	jne	.L888
.L754:
	leaq	112(%rsp), %rcx
	movq	%r10, 32(%rsp)
	leaq	96(%rsp), %rdx
	movq	%r9, 208(%rsp)
	movq	%rax, 96(%rsp)
	movq	%r11, 104(%rsp)
	call	vyne_to_string
	movq	120(%rsp), %rcx
	movq	120(%rsp), %r15
	call	strlen
	movq	32(%rsp), %r10
	movq	208(%rsp), %r9
	movq	%rax, %rdi
.L756:
	movq	%r10, %rcx
	movq	%r9, 208(%rsp)
	movq	%r10, %r14
	call	strlen
	movq	208(%rsp), %r9
	movq	%rax, %rsi
.L758:
	movq	g_arena_cur(%rip), %r10
	leaq	(%rsi,%rdi), %r11
	leaq	8(%r11), %rdx
	andq	$-8, %rdx
	testq	%r10, %r10
	je	.L759
	movq	g_arena_end(%rip), %rax
	subq	%r10, %rax
	cmpq	%rdx, %rax
	jb	.L759
	leaq	(%r10,%rdx), %rax
	addq	8+g_arena(%rip), %rdx
	movq	%rax, g_arena_cur(%rip)
.L763:
	movq	%r10, %rcx
	movq	%rdi, %r8
	movq	%rdx, 8+g_arena(%rip)
	movq	%r15, %rdx
	movq	%r9, 208(%rsp)
	movq	%r11, 48(%rsp)
	call	memcpy
	movq	%rsi, %r8
	movq	%r14, %rdx
	leaq	(%rdi,%rax), %rcx
	movq	%rax, 32(%rsp)
	call	memcpy
	movq	32(%rsp), %r10
	movq	208(%rsp), %r9
	movq	48(%rsp), %r11
	movq	$3, (%r9)
	movb	$0, (%r10,%r11)
	movq	%r10, 8(%r9)
	jmp	.L748
	.p2align 4,,10
	.p2align 3
.L752:
	cmpl	$3, %eax
	jne	.L889
	movq	%r11, %rcx
	movq	%r10, 48(%rsp)
	movq	%r11, %r15
	movq	%rdx, 32(%rsp)
	movq	%r9, 208(%rsp)
	call	strlen
	movq	32(%rsp), %rdx
	movq	208(%rsp), %r9
	movq	%rax, %rdi
	movq	48(%rsp), %r10
	cmpl	$3, %edx
	je	.L756
	leaq	112(%rsp), %rcx
	movq	%rdx, 96(%rsp)
	leaq	96(%rsp), %rdx
	movq	%r9, 208(%rsp)
	movq	%r10, 104(%rsp)
	call	vyne_to_string
	movq	120(%rsp), %rcx
	movq	120(%rsp), %r14
	call	strlen
	movq	208(%rsp), %r9
	movq	%rax, %rsi
	jmp	.L758
.L888:
	cmpl	$1, %edx
	je	.L890
.L801:
	cmpl	$10, %edx
	ja	.L806
	leaq	.L808(%rip), %rcx
	movl	%edx, %edx
	movslq	(%rcx,%rdx,4), %rdx
	addq	%rcx, %rdx
	jmp	*%rdx
	.section .rdata,"dr"
	.align 4
.L808:
	.long	.L812-.L808
	.long	.L806-.L808
	.long	.L842-.L808
	.long	.L806-.L808
	.long	.L811-.L808
	.long	.L810-.L808
	.long	.L809-.L808
	.long	.L806-.L808
	.long	.L806-.L808
	.long	.L806-.L808
	.long	.L807-.L808
	.text
.L806:
	leaq	.LC19(%rip), %r9
.L800:
	cmpl	$10, %eax
	ja	.L813
	leaq	.L815(%rip), %rdx
	movl	%eax, %eax
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L815:
	.long	.L820-.L815
	.long	.L819-.L815
	.long	.L818-.L815
	.long	.L813-.L815
	.long	.L767-.L815
	.long	.L843-.L815
	.long	.L816-.L815
	.long	.L813-.L815
	.long	.L813-.L815
	.long	.L813-.L815
	.long	.L814-.L815
	.text
.L813:
	leaq	.LC19(%rip), %r8
	.p2align 4,,10
	.p2align 3
.L817:
	movq	%r9, 48(%rsp)
	movl	$2, %ecx
	movq	%r8, 32(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	48(%rsp), %r9
	leaq	.LC29(%rip), %rdx
	movq	32(%rsp), %r8
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
.L814:
	leaq	.LC23(%rip), %r8
	jmp	.L817
.L816:
	leaq	.LC24(%rip), %r8
	jmp	.L817
.L820:
	leaq	.LC25(%rip), %r8
	jmp	.L817
.L843:
	leaq	.LC21(%rip), %r8
	jmp	.L817
.L818:
	leaq	.LC18(%rip), %r8
	jmp	.L817
.L842:
	leaq	.LC18(%rip), %r9
	jmp	.L800
.L811:
	leaq	.LC22(%rip), %r9
	jmp	.L800
.L807:
	leaq	.LC23(%rip), %r9
	jmp	.L800
.L812:
	leaq	.LC25(%rip), %r9
	jmp	.L800
.L809:
	leaq	.LC24(%rip), %r9
	jmp	.L800
.L810:
	leaq	.LC21(%rip), %r9
	jmp	.L800
.L844:
	leaq	.LC19(%rip), %r9
.L819:
	leaq	.LC20(%rip), %r8
	jmp	.L817
.L759:
	movl	$32, %ecx
	movq	%r9, 208(%rsp)
	movq	%rdx, 48(%rsp)
	movq	%r11, 32(%rsp)
	call	malloc
	movq	32(%rsp), %r11
	testq	%rax, %rax
	movq	48(%rsp), %rdx
	movq	208(%rsp), %r9
	je	.L792
	movq	%rax, 64(%rsp)
	movl	$8388608, %eax
	cmpq	%rax, %rdx
	movq	%r9, 208(%rsp)
	cmovnb	%rdx, %rax
	movq	%r11, 48(%rsp)
	movq	%rdx, 32(%rsp)
	movq	%rax, %rcx
	movq	%rax, %rbx
	call	malloc
	movq	64(%rsp), %r8
	testq	%rax, %rax
	movq	32(%rsp), %rdx
	movq	%rax, %r10
	movq	48(%rsp), %r11
	movq	208(%rsp), %r9
	movq	%rax, (%r8)
	je	.L772
	movq	g_arena(%rip), %rax
	movq	%rdx, %xmm0
	movq	%rbx, %xmm5
	movq	%r8, g_arena(%rip)
	punpcklqdq	%xmm5, %xmm0
	movups	%xmm0, 8(%r8)
	movq	%rax, 24(%r8)
	leaq	(%r10,%rdx), %rax
	addq	8+g_arena(%rip), %rdx
	movq	%rax, g_arena_cur(%rip)
	leaq	(%r10,%rbx), %rax
	movq	%rax, g_arena_end(%rip)
	jmp	.L763
.L833:
	leaq	.LC19(%rip), %r9
.L767:
	leaq	.LC22(%rip), %r8
	jmp	.L817
.L890:
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r11, %xmm1
.L802:
	movq	%r10, %xmm0
.L805:
	addsd	%xmm1, %xmm0
	movq	$1, (%r9)
	movq	%xmm0, 8(%r9)
	jmp	.L748
.L889:
	cmpl	$3, %edx
	je	.L754
	cmpl	$4, %eax
	jne	.L765
	cmpl	$4, %edx
	je	.L766
	leaq	.LC20(%rip), %r9
	cmpl	$1, %edx
	je	.L767
	cmpl	$10, %edx
	ja	.L833
	leaq	.L834(%rip), %rcx
	movl	%edx, %edx
	movslq	(%rcx,%rdx,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L834:
	.long	.L832-.L834
	.long	.L833-.L834
	.long	.L835-.L834
	.long	.L833-.L834
	.long	.L830-.L834
	.long	.L829-.L834
	.long	.L845-.L834
	.long	.L833-.L834
	.long	.L833-.L834
	.long	.L833-.L834
	.long	.L831-.L834
	.text
.L845:
	leaq	.LC24(%rip), %r9
	jmp	.L767
.L829:
	leaq	.LC21(%rip), %r9
	jmp	.L767
.L830:
	leaq	.LC22(%rip), %r9
	jmp	.L767
.L835:
	leaq	.LC18(%rip), %r9
	jmp	.L767
.L831:
	leaq	.LC23(%rip), %r9
	jmp	.L767
.L832:
	leaq	.LC25(%rip), %r9
	jmp	.L767
	.p2align 4,,10
	.p2align 3
.L765:
	cmpl	$1, %eax
	jne	.L891
	leal	-1(%rdx), %eax
	cmpl	$1, %eax
	jbe	.L892
	cmpl	$10, %edx
	ja	.L844
	leaq	.L824(%rip), %rcx
	movl	%edx, %edx
	movslq	(%rcx,%rdx,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L824:
	.long	.L828-.L824
	.long	.L844-.L824
	.long	.L844-.L824
	.long	.L844-.L824
	.long	.L827-.L824
	.long	.L826-.L824
	.long	.L825-.L824
	.long	.L844-.L824
	.long	.L844-.L824
	.long	.L844-.L824
	.long	.L823-.L824
	.text
.L826:
	leaq	.LC21(%rip), %r9
	jmp	.L819
.L827:
	leaq	.LC22(%rip), %r9
	jmp	.L819
.L825:
	leaq	.LC24(%rip), %r9
	jmp	.L819
.L823:
	leaq	.LC23(%rip), %r9
	jmp	.L819
.L828:
	leaq	.LC25(%rip), %r9
	jmp	.L819
.L766:
	movq	g_arena_cur(%rip), %rsi
	testq	%rsi, %rsi
	movq	%rsi, %rdi
	je	.L769
	movq	g_arena_end(%rip), %rcx
	movq	%rcx, %rax
	subq	%rsi, %rax
	cmpq	$15, %rax
	jbe	.L769
	leaq	16(%rsi), %rax
	movq	%rax, %r14
	movq	%rax, g_arena_cur(%rip)
	movq	8+g_arena(%rip), %rax
	leaq	16(%rax), %rdx
.L773:
	subq	%r14, %rcx
	movq	%rdx, 8+g_arena(%rip)
	cmpq	$63, %rcx
	jbe	.L893
	leaq	64(%r14), %rcx
	addq	$64, %rdx
	movq	%rcx, g_arena_cur(%rip)
.L775:
	movq	%rdx, 8+g_arena(%rip)
	movq	.LC28(%rip), %rdx
	movl	$4, %r12d
	movq	%rdi, %r13
	movq	%r14, (%rdi)
	movq	%rdx, 8(%rdi)
	cmpl	$0, 8(%r11)
	jle	.L788
	movq	%r9, 208(%rsp)
	movq	%r10, %rbp
	movl	$4, %eax
	xorl	%edx, %edx
	xorl	%r9d, %r9d
	movq	%r14, %r10
	jmp	.L776
.L839:
	movslq	%ecx, %rdx
.L776:
	movq	%r9, %rcx
	salq	$4, %rcx
	addq	(%r11), %rcx
	cmpl	%edx, %eax
	movdqu	(%rcx), %xmm0
	jle	.L894
.L779:
	leal	1(%rdx), %ecx
	addq	$1, %r9
	salq	$4, %rdx
	movl	%ecx, 8(%rdi)
	cmpl	%r9d, 8(%r11)
	movups	%xmm0, (%r10,%rdx)
	jg	.L839
	movq	208(%rsp), %r9
	movq	%rbp, %r10
.L788:
	cmpl	$0, 8(%r10)
	jle	.L778
	movl	12(%rdi), %eax
	movq	%r9, 208(%rsp)
	xorl	%r11d, %r11d
	movslq	8(%rdi), %r8
	movq	(%rdi), %rdx
	movl	%eax, %r9d
	jmp	.L798
.L840:
	movslq	%eax, %r8
.L798:
	movq	%r11, %rax
	salq	$4, %rax
	addq	(%r10), %rax
	cmpl	%r8d, %r9d
	movdqu	(%rax), %xmm0
	jle	.L895
.L789:
	leal	1(%r8), %eax
	addq	$1, %r11
	salq	$4, %r8
	movl	%eax, 8(%rdi)
	cmpl	%r11d, 8(%r10)
	movups	%xmm0, (%rdx,%r8)
	jg	.L840
	movq	208(%rsp), %r9
.L778:
	movq	%r12, 32(%rsp)
	movq	%r13, 40(%rsp)
	movdqa	32(%rsp), %xmm4
	movups	%xmm4, (%r9)
	jmp	.L748
.L892:
	subl	$1, %edx
	movq	%r11, %xmm1
	je	.L802
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r10, %xmm0
	jmp	.L805
.L895:
	leal	(%r9,%r9), %eax
	movq	g_arena_cur(%rip), %rcx
	movl	%eax, %r15d
	cltq
	salq	$4, %rax
	testq	%rdx, %rdx
	movq	%rax, %rsi
	je	.L790
	movslq	%r9d, %rax
	salq	$4, %rax
	leaq	(%rdx,%rax), %r9
	cmpq	%r9, %rcx
	je	.L896
.L790:
	testq	%rcx, %rcx
	je	.L794
.L791:
	movq	g_arena_end(%rip), %rax
	subq	%rcx, %rax
	cmpq	%rsi, %rax
	jb	.L794
	leaq	(%rcx,%rsi), %rax
	movq	%rax, g_arena_cur(%rip)
	movq	8+g_arena(%rip), %rax
	leaq	g_arena(%rip), %r9
	addq	%rsi, %rax
.L796:
	cmpq	%rdx, %rcx
	movq	%rax, 8(%r9)
	je	.L797
	salq	$4, %r8
	movq	%r10, 64(%rsp)
	movq	%r11, 48(%rsp)
	movaps	%xmm0, 32(%rsp)
	call	memcpy
	movq	64(%rsp), %r10
	movq	48(%rsp), %r11
	movq	%rax, %rcx
	movdqa	32(%rsp), %xmm0
.L797:
	movslq	8(%rdi), %r8
	movq	%rcx, (%rdi)
	movl	%r15d, %r9d
	movq	%rcx, %rdx
	movl	%r15d, 12(%rdi)
	jmp	.L789
.L894:
	leal	(%rax,%rax), %esi
	movq	g_arena_cur(%rip), %rcx
	movslq	%esi, %r8
	movl	%esi, %r15d
	salq	$4, %r8
	testq	%r10, %r10
	je	.L780
	salq	$4, %rax
	leaq	(%r10,%rax), %rsi
	cmpq	%rsi, %rcx
	je	.L897
.L780:
	testq	%rcx, %rcx
	je	.L784
.L781:
	movq	g_arena_end(%rip), %rax
	subq	%rcx, %rax
	cmpq	%r8, %rax
	jb	.L784
	leaq	(%rcx,%r8), %rax
	addq	8+g_arena(%rip), %r8
	movq	%rax, g_arena_cur(%rip)
	leaq	g_arena(%rip), %rax
.L786:
	cmpq	%r10, %rcx
	movq	%r8, 8(%rax)
	je	.L787
	salq	$4, %rdx
	movq	%r11, 64(%rsp)
	movq	%rdx, %r8
	movq	%r10, %rdx
	movq	%r9, 48(%rsp)
	movaps	%xmm0, 32(%rsp)
	call	memcpy
	movq	64(%rsp), %r11
	movq	48(%rsp), %r9
	movq	%rax, %rcx
	movdqa	32(%rsp), %xmm0
.L787:
	movslq	%r15d, %rax
	movslq	8(%rdi), %rdx
	movq	%rcx, (%rdi)
	movq	%rcx, %r10
	movl	%eax, 12(%rdi)
	jmp	.L779
.L893:
	movl	$32, %ecx
	movq	%r10, 64(%rsp)
	movq	%r11, 48(%rsp)
	movq	%r9, 208(%rsp)
	movq	%rdx, 32(%rsp)
	call	malloc
	movq	32(%rsp), %rdx
	testq	%rax, %rax
	movq	208(%rsp), %r9
	movq	48(%rsp), %r11
	movq	64(%rsp), %r10
	je	.L792
	movl	$8388608, %ecx
	movq	%rax, 72(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 48(%rsp)
	movq	%r9, 208(%rsp)
	movq	%rdx, 32(%rsp)
	call	malloc
	movq	72(%rsp), %r8
	testq	%rax, %rax
	movq	%rax, %r14
	movq	%rax, (%r8)
	je	.L772
	movq	g_arena(%rip), %rcx
	movq	%r8, g_arena(%rip)
	movq	32(%rsp), %rdx
	movdqa	.LC27(%rip), %xmm0
	movq	208(%rsp), %r9
	movq	%rcx, 24(%r8)
	leaq	64(%rax), %rcx
	movq	48(%rsp), %r11
	movq	%rcx, g_arena_cur(%rip)
	leaq	8388608(%rax), %rcx
	movq	64(%rsp), %r10
	addq	$64, %rdx
	movups	%xmm0, 8(%r8)
	movq	%rcx, g_arena_end(%rip)
	jmp	.L775
.L769:
	movl	$32, %ecx
	movq	%r10, 48(%rsp)
	movq	%r11, 32(%rsp)
	movq	%r9, 208(%rsp)
	call	malloc
	movq	208(%rsp), %r9
	testq	%rax, %rax
	movq	32(%rsp), %r11
	movq	48(%rsp), %r10
	je	.L792
	movl	$8388608, %ecx
	movq	%rax, 64(%rsp)
	movq	%r10, 48(%rsp)
	movq	%r11, 32(%rsp)
	movq	%r9, 208(%rsp)
	call	malloc
	movq	64(%rsp), %rdx
	testq	%rax, %rax
	movq	%rax, %rbx
	movq	%rax, %rdi
	movq	%rax, (%rdx)
	je	.L772
	movq	g_arena(%rip), %rax
	leaq	16(%rbx), %rsi
	movq	%rdx, g_arena(%rip)
	leaq	8388608(%rbx), %rcx
	movdqa	.LC26(%rip), %xmm0
	movq	%rsi, %r14
	movq	%rsi, g_arena_cur(%rip)
	movq	208(%rsp), %r9
	movq	%rcx, g_arena_end(%rip)
	movups	%xmm0, 8(%rdx)
	movq	32(%rsp), %r11
	movq	%rax, 24(%rdx)
	movq	8+g_arena(%rip), %rax
	movq	48(%rsp), %r10
	leaq	16(%rax), %rdx
	jmp	.L773
.L784:
	movl	$32, %ecx
	movq	%r9, 80(%rsp)
	movq	%r10, 72(%rsp)
	movl	%edx, 64(%rsp)
	movaps	%xmm0, 48(%rsp)
	movq	%r8, 32(%rsp)
	movq	%r11, 88(%rsp)
	call	malloc
	movq	32(%rsp), %r8
	testq	%rax, %rax
	movl	64(%rsp), %edx
	movq	%rax, %rsi
	movq	72(%rsp), %r10
	movq	80(%rsp), %r9
	movdqa	48(%rsp), %xmm0
	je	.L792
	cmpq	$8388608, %r8
	movl	$8388608, %ebx
	movq	%r9, 80(%rsp)
	cmovnb	%r8, %rbx
	movq	%r10, 72(%rsp)
	movl	%edx, 64(%rsp)
	movq	%rbx, %rcx
	movaps	%xmm0, 48(%rsp)
	movq	%r8, 32(%rsp)
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rcx
	movq	%rax, (%rsi)
	je	.L772
	movq	32(%rsp), %r8
	movq	%rbx, %xmm4
	addq	%rcx, %rbx
	movq	g_arena(%rip), %rdx
	movq	%rsi, g_arena(%rip)
	leaq	g_arena(%rip), %rax
	movq	72(%rsp), %r10
	movq	%rbx, g_arena_end(%rip)
	movq	80(%rsp), %r9
	movq	%r8, %xmm1
	movq	88(%rsp), %r11
	movq	%rdx, 24(%rsi)
	punpcklqdq	%xmm4, %xmm1
	movslq	64(%rsp), %rdx
	movups	%xmm1, 8(%rsi)
	leaq	(%rcx,%r8), %rsi
	movdqa	48(%rsp), %xmm0
	addq	8+g_arena(%rip), %r8
	movq	%rsi, g_arena_cur(%rip)
	jmp	.L786
.L897:
	subq	%rax, 8+g_arena(%rip)
	movq	%r10, g_arena_cur(%rip)
	movq	%r10, %rcx
	jmp	.L781
.L794:
	movl	$32, %ecx
	movq	%r11, 72(%rsp)
	movq	%rdx, 64(%rsp)
	movl	%r8d, 48(%rsp)
	movaps	%xmm0, 32(%rsp)
	movq	%r10, 80(%rsp)
	call	malloc
	movl	48(%rsp), %r8d
	testq	%rax, %rax
	movq	64(%rsp), %rdx
	movq	%rax, %r14
	movq	72(%rsp), %r11
	movdqa	32(%rsp), %xmm0
	je	.L792
	movl	$8388608, %eax
	movq	%r11, 72(%rsp)
	movq	%rsi, %rbx
	cmpq	%rax, %rsi
	movq	%rdx, 64(%rsp)
	cmovnb	%rsi, %rax
	movl	%r8d, 48(%rsp)
	movaps	%xmm0, 32(%rsp)
	movq	%rax, %rcx
	movq	%rax, %rsi
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rcx
	movq	%rax, (%r14)
	je	.L772
	movq	%rbx, %xmm1
	movq	%rsi, %xmm4
	movslq	48(%rsp), %r8
	punpcklqdq	%xmm4, %xmm1
	movq	64(%rsp), %rdx
	movups	%xmm1, 8(%r14)
	leaq	g_arena(%rip), %r9
	movq	g_arena(%rip), %rax
	movq	%r14, g_arena(%rip)
	movq	72(%rsp), %r11
	movq	80(%rsp), %r10
	movdqa	32(%rsp), %xmm0
	movq	%rax, 24(%r14)
	leaq	(%rcx,%rbx), %rax
	addq	8+g_arena(%rip), %rbx
	movq	%rax, g_arena_cur(%rip)
	leaq	(%rcx,%rsi), %rax
	movq	%rax, g_arena_end(%rip)
	movq	%rbx, %rax
	jmp	.L796
.L896:
	subq	%rax, 8+g_arena(%rip)
	movq	%rdx, g_arena_cur(%rip)
	movq	%rdx, %rcx
	jmp	.L791
.L891:
	cmpl	$1, %edx
	jne	.L801
	leaq	.LC20(%rip), %r9
	jmp	.L800
.L772:
	call	arena_alloc.part.0
.L792:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC31:
	.ascii "config=\0"
.LC32:
	.ascii " N=\0"
.LC33:
	.ascii " iters=\0"
	.align 8
.LC34:
	.ascii "Runtime error: vmem.checkpoint() stack overflow (>%d)\12\0"
.LC37:
	.ascii "checksum: \0"
	.align 8
.LC38:
	.ascii "Runtime error: invalid or already-rewound checkpoint handle %lld\12\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%r15
	.seh_pushreg	%r15
	movl	$33554840, %eax
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	call	___chkstk_ms
	subq	%rax, %rsp
	.seh_stackalloc	33554840
	movaps	%xmm6, 33554784(%rsp)
	.seh_savexmm	%xmm6, 33554784
	movaps	%xmm7, 33554800(%rsp)
	.seh_savexmm	%xmm7, 33554800
	movaps	%xmm8, 33554816(%rsp)
	.seh_savexmm	%xmm8, 33554816
	.seh_endprologue
	leaq	336(%rsp), %rbx
	movq	%r10, 32(%rsp)
	leaq	320(%rsp), %r15
	movq	%r11, 40(%rsp)
	call	__main
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movabsq	$1442695040888963407, %rax
	leaq	304(%rsp), %r14
	movq	%rax, _vmath_rng_inc(%rip)
	movq	$42, _vmath_rng_state(%rip)
	movq	$0, v_CONFIG(%rip)
	movq	$1024, v_N(%rip)
	movq	$10, v_ITERS(%rip)
	movq	%rbx, 160(%rsp)
	movq	$2, 320(%rsp)
	movq	$0, 328(%rsp)
	movq	%r15, 136(%rsp)
	call	vyne_to_string
	movq	%r14, %r8
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movdqu	336(%rsp), %xmm6
	leaq	.LC31(%rip), %rax
	movq	$3, 320(%rsp)
	movq	%rax, 328(%rsp)
	movaps	%xmm6, 304(%rsp)
	movq	%r14, 128(%rsp)
	call	vyne_binop.constprop.0
	movq	%r14, %r8
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movdqu	336(%rsp), %xmm7
	leaq	.LC32(%rip), %rax
	movq	$3, 304(%rsp)
	movq	%rax, 312(%rsp)
	movaps	%xmm7, 320(%rsp)
	call	vyne_binop.constprop.0
	movq	v_N(%rip), %rax
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movq	336(%rsp), %rsi
	movq	$2, 320(%rsp)
	movq	344(%rsp), %rdi
	movq	%rax, 328(%rsp)
	call	vyne_to_string
	movq	%r14, %r8
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movdqu	336(%rsp), %xmm6
	movq	%rsi, 320(%rsp)
	movq	%rdi, 328(%rsp)
	movaps	%xmm6, 304(%rsp)
	call	vyne_binop.constprop.0
	movq	%r14, %r8
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movdqu	336(%rsp), %xmm7
	leaq	.LC33(%rip), %rax
	movq	$3, 304(%rsp)
	movq	%rax, 312(%rsp)
	movaps	%xmm7, 320(%rsp)
	call	vyne_binop.constprop.0
	movq	v_ITERS(%rip), %rax
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movq	336(%rsp), %rsi
	movq	$2, 320(%rsp)
	movq	344(%rsp), %rdi
	movq	%rax, 328(%rsp)
	call	vyne_to_string
	movq	%r14, %r8
	movq	%r15, %rdx
	movq	%rbx, %rcx
	movdqu	336(%rsp), %xmm6
	movq	%rsi, 320(%rsp)
	movq	%rdi, 328(%rsp)
	movaps	%xmm6, 304(%rsp)
	call	vyne_binop.constprop.0
	movq	344(%rsp), %rdx
	movl	336(%rsp), %ecx
	call	vyne_out.isra.0
	movl	g_vmem_top(%rip), %eax
	movq	32(%rsp), %r10
	movq	40(%rsp), %r11
	cmpl	$63, %eax
	movl	%eax, 116(%rsp)
	jg	.L994
	movl	%eax, %edi
	movq	g_arena(%rip), %rdx
	leal	1(%rax), %eax
	movl	%eax, g_vmem_top(%rip)
	movslq	%edi, %rax
	movq	%rax, 88(%rsp)
	movq	g_arena_cur(%rip), %rax
	testq	%rax, %rax
	je	.L1029
	testq	%rdx, %rdx
	je	.L1029
	subq	(%rdx), %rax
	jmp	.L900
.L1029:
	xorl	%eax, %eax
.L900:
	movq	88(%rsp), %rcx
	leaq	g_vmem_slots(%rip), %rdi
	movq	%rax, %xmm0
	movhps	8+g_arena(%rip), %xmm0
	salq	$5, %rcx
	movq	%rdx, (%rdi,%rcx)
	movups	%xmm0, 8(%rdi,%rcx)
	movl	$1, 24(%rcx,%rdi)
	movq	v_N(%rip), %rcx
	movq	%rcx, %rax
	subq	$1, %rax
	js	.L901
	leaq	8388960(%rsp), %rbp
	movq	%r11, 56(%rsp)
	xorl	%r11d, %r11d
	movsd	.LC35(%rip), %xmm7
	movq	%rbp, %rbx
	movq	%rbp, 64(%rsp)
	movq	%rcx, %rbp
	movsd	.LC36(%rip), %xmm6
	leaq	352(%rsp), %rsi
	movq	%rbp, %rdx
	movabsq	$1442695040888963407, %r13
	movq	%rcx, 32(%rsp)
	leaq	_vmath_rng_state(%rip), %rdi
	subq	$1, %rdx
	movq	%r10, 48(%rsp)
	js	.L1160
.L902:
	movq	_vmath_rng_state(%rip), %rax
	xorl	%r12d, %r12d
	movq	%r11, %r14
	movabsq	$6364136223846793005, %r15
	jmp	.L911
	.p2align 4,,10
	.p2align 3
.L1163:
	movq	_vmath_rng_inc(%rip), %r10
.L905:
	movq	%rax, %r8
	movq	%rax, %rdx
	pxor	%xmm0, %xmm0
	imulq	%r15, %rdx
	shrq	$18, %r8
	xorq	%rax, %r8
	shrq	$59, %rax
	shrq	$27, %r8
	movl	%eax, %ecx
	rorl	%cl, %r8d
	cvtsi2sdq	%r8, %xmm0
	mulsd	%xmm7, %xmm0
	addq	%r10, %rdx
	testq	%rdx, %rdx
	movq	%rdx, _vmath_rng_state(%rip)
	addsd	%xmm0, %xmm0
	subsd	%xmm6, %xmm0
	movsd	%xmm0, (%rsi,%r12,8)
	je	.L1161
.L908:
	movq	%rdx, %r8
	movq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	movq	%rdx, %rax
	shrq	$18, %r8
	shrq	$59, %rcx
	imulq	%r15, %rax
	xorq	%rdx, %r8
	shrq	$27, %r8
	rorl	%cl, %r8d
	cvtsi2sdq	%r8, %xmm0
	mulsd	%xmm7, %xmm0
	addq	%r10, %rax
	movq	%rax, _vmath_rng_state(%rip)
	addsd	%xmm0, %xmm0
	subsd	%xmm6, %xmm0
	movsd	%xmm0, (%rbx,%r12,8)
	addq	$1, %r12
	cmpq	%rbp, %r12
	je	.L1162
.L911:
	testq	%rax, %rax
	jne	.L1163
	xorl	%ecx, %ecx
	call	_time64
	movq	%r13, _vmath_rng_inc(%rip)
	movq	%r13, %r10
	xorq	%rdi, %rax
	imulq	%r15, %rax
	addq	%r13, %rax
	jmp	.L905
	.p2align 4,,10
	.p2align 3
.L1161:
	xorl	%ecx, %ecx
	call	_time64
	movq	%r13, _vmath_rng_inc(%rip)
	movq	%r13, %r10
	xorq	%rdi, %rax
	movq	%rax, %rdx
	imulq	%r15, %rdx
	addq	%r13, %rdx
	jmp	.L908
.L1162:
	leaq	1(%r14), %r11
	cmpq	%r11, 32(%rsp)
	movq	v_N(%rip), %rbp
	je	.L912
	movq	%rbp, %rdx
	addq	$8192, %rbx
	addq	$8192, %rsi
	subq	$1, %rdx
	jns	.L902
.L1160:
	leaq	1(%r11), %r15
	cmpq	%r15, 32(%rsp)
	movq	64(%rsp), %rbp
	movq	48(%rsp), %r10
	movq	56(%rsp), %r11
	je	.L901
.L903:
	testq	%rdx, %rdx
	js	.L901
	leaq	1(%rdx), %rdi
	xorl	%r9d, %r9d
	leaq	16777568(%rsp), %r12
	movq	%rdi, %rax
	shrq	%rax
	salq	$14, %rax
	movq	%rax, %rsi
.L914:
	movq	%r9, %rbx
	salq	$10, %rbx
	testq	%rdx, %rdx
	je	.L1030
.L918:
	leaq	(%rsi,%r12), %r8
	movq	%rbp, %rcx
	movq	%r12, %rax
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L916:
	movsd	8(%rcx), %xmm0
	addq	$16384, %rax
	addq	$16, %rcx
	movsd	-16(%rcx), %xmm1
	movsd	%xmm0, -8192(%rax)
	movsd	%xmm1, -16384(%rax)
	cmpq	%rax, %r8
	jne	.L916
	testb	$1, %dil
	je	.L915
	movq	%rdi, %rax
	andq	$-2, %rax
.L919:
	movq	%rax, %rcx
	addq	%rbx, %rax
	addq	$8192, %rbp
	salq	$10, %rcx
	addq	$8, %r12
	movsd	8388960(%rsp,%rax,8), %xmm0
	addq	%r9, %rcx
	addq	$1, %r9
	movsd	%xmm0, 16777568(%rsp,%rcx,8)
	cmpq	%r9, %rdi
	jne	.L914
.L901:
	movq	v_CONFIG(%rip), %rax
	testq	%rax, %rax
	jne	.L952
	movq	v_ITERS(%rip), %rdi
	testq	%rdi, %rdi
	jle	.L924
	movdqa	.LC26(%rip), %xmm7
	movq	%rdi, %r14
	movl	$1, %ebx
	movq	%r10, 32(%rsp)
	movdqa	.LC27(%rip), %xmm6
	movq	%r11, 40(%rsp)
	movq	.LC28(%rip), %xmm8
.L923:
	movq	g_arena_cur(%rip), %rbp
	testq	%rbp, %rbp
	je	.L926
.L1171:
	movq	g_arena_end(%rip), %rcx
	movq	%rcx, %rax
	subq	%rbp, %rax
	cmpq	$15, %rax
	jbe	.L926
	leaq	g_arena(%rip), %rdi
	movq	%rdi, 72(%rsp)
	movq	8+g_arena(%rip), %rdi
	leaq	16(%rbp), %rax
	subq	%rax, %rcx
	movq	%rax, g_arena_cur(%rip)
	cmpq	$63, %rcx
	leaq	16(%rdi), %rdx
	movq	%rdx, 8+g_arena(%rip)
	jbe	.L1164
.L930:
	leaq	64(%rax), %rcx
	addq	$64, %rdx
	movq	%rcx, g_arena_cur(%rip)
.L933:
	movq	v_N(%rip), %r15
	movq	%rax, 0(%rbp)
	movq	72(%rsp), %rdi
	movq	%xmm8, 8(%rbp)
	movq	$4, 144(%rsp)
	movq	%rbp, 152(%rsp)
	testq	%r15, %r15
	movq	%rdx, 8(%rdi)
	jle	.L934
	movq	32(%rsp), %r10
	movq	%r14, %r12
	movq	%r15, %rdi
	xorl	%r9d, %r9d
	movq	40(%rsp), %r11
	leaq	352(%rsp), %rsi
	movq	%rbx, 168(%rsp)
	.p2align 4,,10
	.p2align 3
.L949:
	testq	%rdi, %rdi
	jle	.L935
	movq	%rdi, %rdx
	movq	%r9, 64(%rsp)
	movq	%rdi, %r9
	xorl	%edi, %edi
	leaq	16777568(%rsp), %rbx
	cmpq	$3, %rdx
	movq	%r12, %r13
	movq	%r15, %r12
	jle	.L1032
	.p2align 4,,10
	.p2align 3
.L1166:
	sarq	$2, %rdx
	pxor	%xmm1, %xmm1
	xorl	%eax, %eax
	movapd	%xmm1, %xmm2
	salq	$5, %rdx
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L937:
	movapd	(%rbx,%rax), %xmm0
	mulpd	(%rsi,%rax), %xmm0
	addpd	%xmm0, %xmm2
	movapd	16(%rbx,%rax), %xmm0
	mulpd	16(%rsi,%rax), %xmm0
	addq	$32, %rax
	cmpq	%rax, %rdx
	addpd	%xmm0, %xmm1
	jne	.L937
	movapd	%xmm1, %xmm4
	movapd	%xmm2, %xmm3
	unpckhpd	%xmm4, %xmm4
	movapd	%xmm4, %xmm0
	unpckhpd	%xmm3, %xmm3
	addsd	%xmm3, %xmm2
	addsd	%xmm1, %xmm0
	addsd	%xmm0, %xmm2
	movq	%xmm2, %r14
.L936:
	movslq	8(%rbp), %r8
	movl	$1, %r10d
	movq	%r14, %r15
	movslq	12(%rbp), %rax
	movq	%r10, %r14
	movq	0(%rbp), %rdx
	cmpl	%eax, %r8d
	jge	.L1165
.L938:
	leal	1(%r8), %eax
	addq	$1, %rdi
	salq	$4, %r8
	cmpq	%r9, %rdi
	movl	%eax, 8(%rbp)
	movq	%r14, (%rdx,%r8)
	movq	%r15, 8(%rdx,%r8)
	je	.L1139
	movq	v_N(%rip), %rdx
	addq	$8192, %rbx
	cmpq	$3, %rdx
	jg	.L1166
.L1032:
	xorl	%r14d, %r14d
	jmp	.L936
.L1140:
	movq	168(%rsp), %rbx
	movq	%r12, %r14
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
.L934:
	cmpq	%rbx, v_ITERS(%rip)
	je	.L1167
	addq	$1, %rbx
	cmpq	%rbx, %r14
	jge	.L923
.L1156:
	movq	v_CONFIG(%rip), %rax
.L952:
	cmpq	$1, %rax
	movq	%rax, 96(%rsp)
	je	.L1168
.L922:
	cmpq	$2, v_CONFIG(%rip)
	je	.L1169
.L924:
	cmpq	$0, 88(%rsp)
	js	.L954
	movslq	g_vmem_top(%rip), %rax
	movq	88(%rsp), %rdi
	movq	%rax, %rsi
	cmpq	%rax, %rdi
	jge	.L954
	movq	%rdi, %rax
	leaq	g_vmem_slots(%rip), %rdi
	salq	$5, %rax
	addq	%rdi, %rax
	movl	24(%rax), %r8d
	testl	%r8d, %r8d
	je	.L954
	movq	(%rax), %rbp
	movq	g_arena(%rip), %rbx
	cmpq	%rbp, %rbx
	jne	.L1016
	jmp	.L1017
	.p2align 4,,10
	.p2align 3
.L1019:
	movq	(%rbx), %rcx
	movq	24(%rbx), %rdi
	call	free
	movq	%rbx, %rcx
	call	free
	cmpq	%rbp, %rdi
	movq	%rdi, g_arena(%rip)
	je	.L1017
	movq	%rdi, %rbx
.L1016:
	testq	%rbx, %rbx
	jne	.L1019
.L1018:
	cmpl	%esi, 116(%rsp)
	jge	.L1024
	movq	88(%rsp), %rdi
	leaq	24+g_vmem_slots(%rip), %rcx
	movl	%esi, %eax
	subl	116(%rsp), %eax
	movq	%rdi, %rdx
	addq	%rdi, %rax
	salq	$5, %rdx
	salq	$5, %rax
	addq	%rcx, %rdx
	addq	%rcx, %rax
	movq	%rax, %rcx
	subq	%rdx, %rcx
	andl	$32, %ecx
	je	.L1023
	xorl	%ecx, %ecx
	addq	$32, %rdx
	movl	%ecx, -32(%rdx)
	cmpq	%rdx, %rax
	je	.L1024
.L1023:
	movl	$0, (%rdx)
	addq	$64, %rdx
	movl	$0, -32(%rdx)
	cmpq	%rdx, %rax
	jne	.L1023
.L1024:
	movl	116(%rsp), %eax
	testq	%rbx, %rbx
	movl	%eax, g_vmem_top(%rip)
	je	.L1022
.L1021:
	movq	%rbx, %rsi
	movq	24(%rbx), %rbx
	movq	(%rsi), %rcx
	call	free
	movq	%rsi, %rcx
	call	free
	testq	%rbx, %rbx
	jne	.L1021
.L1022:
	movq	g_commit_arena(%rip), %rbx
	movq	$0, g_arena(%rip)
	movq	$0, g_arena_cur(%rip)
	movq	$0, g_arena_end(%rip)
	movq	$0, 8+g_arena(%rip)
	testq	%rbx, %rbx
	je	.L1026
.L1025:
	movq	%rbx, %rsi
	movq	24(%rbx), %rbx
	movq	(%rsi), %rcx
	call	free
	movq	%rsi, %rcx
	call	free
	testq	%rbx, %rbx
	jne	.L1025
.L1026:
	movaps	33554784(%rsp), %xmm6
	xorl	%eax, %eax
	movq	$0, g_commit_arena(%rip)
	movaps	33554800(%rsp), %xmm7
	movq	$0, 8+g_commit_arena(%rip)
	movaps	33554816(%rsp), %xmm8
	addq	$33554840, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L915:
	addq	$1, %r9
	cmpq	%rdi, %r9
	je	.L901
	movq	%r9, %rbx
	addq	$8192, %rbp
	addq	$8, %r12
	salq	$10, %rbx
	jmp	.L918
.L1030:
	xorl	%eax, %eax
	jmp	.L919
.L912:
	leaq	-1(%rbp), %rdx
	movq	48(%rsp), %r10
	movq	64(%rsp), %rbp
	movq	56(%rsp), %r11
	jmp	.L903
	.p2align 4,,10
	.p2align 3
.L1139:
	movq	64(%rsp), %r9
	movq	%r12, %r15
	movq	%r13, %r12
.L935:
	addq	$1, %r9
	cmpq	%r9, %r15
	je	.L1140
	movq	v_N(%rip), %rdi
	addq	$8192, %rsi
	jmp	.L949
	.p2align 4,,10
	.p2align 3
.L1165:
	leal	(%rax,%rax), %ecx
	movl	%ecx, 80(%rsp)
	movslq	%ecx, %rcx
	salq	$4, %rcx
	testq	%rdx, %rdx
	movq	%rcx, 48(%rsp)
	movq	g_arena_cur(%rip), %rcx
	movq	%rcx, 32(%rsp)
	je	.L939
	salq	$4, %rax
	leaq	(%rdx,%rax), %rcx
	cmpq	%rcx, 32(%rsp)
	je	.L1170
.L939:
	cmpq	$0, 32(%rsp)
	je	.L943
.L940:
	movq	g_arena_end(%rip), %rax
	subq	32(%rsp), %rax
	cmpq	48(%rsp), %rax
	jb	.L943
	movq	48(%rsp), %rax
	movq	72(%rsp), %rcx
	addq	32(%rsp), %rax
	movq	%rax, g_arena_cur(%rip)
	movq	48(%rsp), %rax
	addq	8(%rcx), %rax
.L946:
	movq	%rax, 8(%rcx)
	movq	32(%rsp), %rcx
	cmpq	%rdx, %rcx
	je	.L947
	salq	$4, %r8
	movq	%r10, 96(%rsp)
	movq	%r11, 104(%rsp)
	movq	%r9, 48(%rsp)
	call	memcpy
	movslq	8(%rbp), %r8
	movq	96(%rsp), %r10
	movq	%rax, 32(%rsp)
	movq	104(%rsp), %r11
	movq	48(%rsp), %r9
.L947:
	movq	32(%rsp), %rdx
	movl	80(%rsp), %eax
	movq	%rdx, 0(%rbp)
	movl	%eax, 12(%rbp)
	jmp	.L938
.L1170:
	movq	72(%rsp), %rcx
	movq	%rdx, g_arena_cur(%rip)
	movq	%rdx, 32(%rsp)
	subq	%rax, 8(%rcx)
	jmp	.L940
.L943:
	movl	$32, %ecx
	movq	%r10, 224(%rsp)
	movq	%r11, 232(%rsp)
	movq	%r9, 192(%rsp)
	movq	%rdx, 120(%rsp)
	movl	%r8d, 32(%rsp)
	call	malloc
	movl	32(%rsp), %r8d
	testq	%rax, %rax
	movq	120(%rsp), %rdx
	movq	%rax, 96(%rsp)
	movq	192(%rsp), %r9
	movq	224(%rsp), %r10
	movq	232(%rsp), %r11
	je	.L974
	movq	48(%rsp), %rcx
	movl	$8388608, %eax
	movq	%r10, 240(%rsp)
	movq	%r11, 248(%rsp)
	movq	%r9, 256(%rsp)
	movq	%rdx, 224(%rsp)
	cmpq	%rax, %rcx
	movl	%r8d, 192(%rsp)
	cmovnb	%rcx, %rax
	movq	%rax, %rcx
	movq	%rax, 120(%rsp)
	call	malloc
	movslq	192(%rsp), %r8
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	movq	96(%rsp), %rax
	testq	%rcx, %rcx
	movq	224(%rsp), %rdx
	movq	256(%rsp), %r9
	movq	240(%rsp), %r10
	movq	248(%rsp), %r11
	movq	%rcx, (%rax)
	je	.L974
	movq	72(%rsp), %rcx
	movq	48(%rsp), %xmm0
	movhps	120(%rsp), %xmm0
	movups	%xmm0, 8(%rax)
	movq	(%rcx), %rax
	movq	96(%rsp), %rcx
	movq	%rax, 24(%rcx)
	movq	72(%rsp), %rcx
	movq	96(%rsp), %rax
	movq	%rax, (%rcx)
	movq	32(%rsp), %rax
	addq	48(%rsp), %rax
	movq	48(%rsp), %rcx
	movq	%rax, g_arena_cur(%rip)
	movq	120(%rsp), %rax
	addq	32(%rsp), %rax
	movq	%rax, g_arena_end(%rip)
	movq	72(%rsp), %rax
	addq	8(%rax), %rcx
	movq	%rcx, %rax
	movq	72(%rsp), %rcx
	jmp	.L946
.L1167:
	movq	136(%rsp), %rsi
	addq	$1, %rbx
	movq	$2, 304(%rsp)
	movq	160(%rsp), %rdi
	movq	$0, 312(%rsp)
	movq	128(%rsp), %r15
	movdqa	144(%rsp), %xmm3
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movaps	%xmm3, 320(%rsp)
	movq	%r15, %r8
	call	vyne_index_get
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movdqu	336(%rsp), %xmm4
	movaps	%xmm4, 320(%rsp)
	call	vyne_to_string
	movq	%r15, %r8
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movdqu	336(%rsp), %xmm3
	leaq	.LC37(%rip), %rax
	movq	$3, 320(%rsp)
	movq	%rax, 328(%rsp)
	movaps	%xmm3, 304(%rsp)
	call	vyne_binop.constprop.0
	movq	344(%rsp), %rdx
	movl	336(%rsp), %ecx
	call	vyne_out.isra.0
	cmpq	%rbx, %r14
	jl	.L1156
	movq	g_arena_cur(%rip), %rbp
	testq	%rbp, %rbp
	jne	.L1171
.L926:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rsi
	je	.L974
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rbp
	movq	%rax, (%rsi)
	je	.L932
	leaq	g_arena(%rip), %rax
	movq	8+g_arena(%rip), %rdi
	movups	%xmm7, 8(%rsi)
	movq	%rax, 72(%rsp)
	movq	g_arena(%rip), %rax
	leaq	8388608(%rbp), %rdx
	movq	%rdx, g_arena_end(%rip)
	movq	%rsi, g_arena(%rip)
	leaq	16(%rdi), %rdx
	movq	%rax, 24(%rsi)
	leaq	16(%rbp), %rax
	jmp	.L930
.L1164:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rsi
	je	.L974
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, (%rsi)
	je	.L932
	movq	g_arena(%rip), %rdx
	movups	%xmm6, 8(%rsi)
	movq	%rsi, g_arena(%rip)
	movq	%rdx, 24(%rsi)
	leaq	64(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rax), %rdx
	movq	%rdx, g_arena_end(%rip)
	leaq	80(%rdi), %rdx
	jmp	.L933
.L1168:
	movq	v_ITERS(%rip), %rcx
	testq	%rcx, %rcx
	jle	.L924
	movl	g_vmem_top(%rip), %edi
	cmpl	$63, %edi
	jg	.L994
	movslq	%edi, %rax
	movdqa	.LC27(%rip), %xmm7
	movl	%edi, %r14d
	movq	%rcx, 256(%rsp)
	movq	%rax, 120(%rsp)
	leal	1(%rdi), %esi
	salq	$5, %rax
	movdqa	.LC26(%rip), %xmm8
	movq	%rax, %r15
	movl	%esi, 224(%rsp)
	movq	.LC28(%rip), %xmm6
	leaq	24+g_vmem_slots(%rip), %rax
	movq	%r15, %rbx
	addq	%r15, %rax
	movq	%rax, 168(%rsp)
	leaq	g_arena(%rip), %r15
.L957:
	movq	g_arena_cur(%rip), %rbp
	movl	224(%rsp), %eax
	movq	(%r15), %rsi
	movq	8(%r15), %rdi
	testq	%rbp, %rbp
	movl	%eax, g_vmem_top(%rip)
	je	.L958
	testq	%rsi, %rsi
	je	.L958
	leaq	8+g_vmem_slots(%rip), %rcx
	movq	%rbp, %rax
	subq	(%rsi), %rax
	movq	%rdi, %xmm4
	movq	%rax, %xmm0
	leaq	g_vmem_slots(%rip), %rax
	punpcklqdq	%xmm4, %xmm0
	movq	%rsi, (%rax,%rbx)
	movups	%xmm0, (%rcx,%rbx)
	movl	$1, 24(%rax,%rbx)
.L959:
	movq	g_arena_end(%rip), %rdx
	movq	%rdx, %rax
	subq	%rbp, %rax
	cmpq	$15, %rax
	jbe	.L962
	leaq	16(%rbp), %rax
	addq	$16, %rdi
	movq	%rax, g_arena_cur(%rip)
.L964:
	subq	%rax, %rdx
	movq	%rdi, 8(%r15)
	cmpq	$63, %rdx
	jbe	.L1172
	leaq	64(%rax), %rdx
	addq	$64, %rdi
	movq	%rdx, g_arena_cur(%rip)
.L966:
	movq	%rdi, 8(%r15)
	movq	v_N(%rip), %rdi
	movq	%rax, 0(%rbp)
	movl	$4, %eax
	movq	%xmm6, 8(%rbp)
	movq	%rax, 192(%rsp)
	testq	%rdi, %rdi
	movq	%rbp, 200(%rsp)
	jle	.L967
	movq	208(%rsp), %r9
	movq	%rdi, 48(%rsp)
	movl	%r14d, %r12d
	xorl	%r11d, %r11d
	movq	216(%rsp), %r10
	leaq	352(%rsp), %rsi
	movq	%r15, 72(%rsp)
	movq	%rbx, 240(%rsp)
	.p2align 4,,10
	.p2align 3
.L981:
	testq	%rdi, %rdi
	jle	.L968
	movq	%rdi, %rdx
	xorl	%r14d, %r14d
	movq	%r11, 32(%rsp)
	movl	%r12d, %r11d
	leaq	16777568(%rsp), %rbx
	cmpq	$3, %rdx
	jle	.L1033
	.p2align 4,,10
	.p2align 3
.L1174:
	sarq	$2, %rdx
	pxor	%xmm1, %xmm1
	xorl	%eax, %eax
	movapd	%xmm1, %xmm2
	salq	$5, %rdx
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L970:
	movapd	(%rbx,%rax), %xmm0
	mulpd	(%rsi,%rax), %xmm0
	addpd	%xmm0, %xmm2
	movapd	16(%rbx,%rax), %xmm0
	mulpd	16(%rsi,%rax), %xmm0
	addq	$32, %rax
	cmpq	%rdx, %rax
	addpd	%xmm0, %xmm1
	jne	.L970
	movapd	%xmm2, %xmm5
	unpckhpd	%xmm5, %xmm5
	addsd	%xmm5, %xmm2
	movapd	%xmm1, %xmm5
	unpckhpd	%xmm5, %xmm5
	movapd	%xmm5, %xmm0
	addsd	%xmm1, %xmm0
	addsd	%xmm0, %xmm2
	movq	%xmm2, %r12
.L969:
	movslq	8(%rbp), %r15
	movl	$1, %r9d
	movq	%r12, %r13
	movslq	12(%rbp), %rax
	movq	%r9, %r12
	movq	0(%rbp), %rdx
	cmpl	%eax, %r15d
	jge	.L1173
.L971:
	leal	1(%r15), %eax
	addq	$1, %r14
	salq	$4, %r15
	cmpq	%rdi, %r14
	movl	%eax, 8(%rbp)
	movq	%r12, (%rdx,%r15)
	movq	%r13, 8(%rdx,%r15)
	je	.L1141
	movq	v_N(%rip), %rdx
	addq	$8192, %rbx
	cmpq	$3, %rdx
	jg	.L1174
.L1033:
	xorl	%r12d, %r12d
	jmp	.L969
.L1141:
	movl	%r11d, %r12d
	movq	32(%rsp), %r11
.L968:
	addq	$1, %r11
	cmpq	%r11, 48(%rsp)
	je	.L1142
	movq	v_N(%rip), %rdi
	addq	$8192, %rsi
	jmp	.L981
.L1173:
	leal	(%rax,%rax), %r8d
	movq	g_arena_cur(%rip), %rcx
	movl	%r8d, 80(%rsp)
	movslq	%r8d, %r8
	salq	$4, %r8
	testq	%rdx, %rdx
	movq	%r8, 64(%rsp)
	je	.L972
	salq	$4, %rax
	leaq	(%rdx,%rax), %r8
	cmpq	%r8, %rcx
	je	.L1175
.L972:
	testq	%rcx, %rcx
	je	.L976
.L973:
	movq	g_arena_end(%rip), %rax
	subq	%rcx, %rax
	cmpq	64(%rsp), %rax
	jb	.L976
	movq	64(%rsp), %rax
	movq	72(%rsp), %r8
	addq	%rcx, %rax
	movq	%rax, g_arena_cur(%rip)
	movq	64(%rsp), %rax
	addq	8(%r8), %rax
.L978:
	cmpq	%rdx, %rcx
	movq	%rax, 8(%r8)
	je	.L979
	movslq	%r15d, %r8
	movq	%r9, 144(%rsp)
	salq	$4, %r8
	movq	%r10, 152(%rsp)
	movl	%r11d, 64(%rsp)
	call	memcpy
	movslq	8(%rbp), %r15
	movq	144(%rsp), %r9
	movq	%rax, %rcx
	movq	152(%rsp), %r10
	movl	64(%rsp), %r11d
.L979:
	movl	80(%rsp), %eax
	movq	%rcx, 0(%rbp)
	movq	%rcx, %rdx
	movl	%eax, 12(%rbp)
	jmp	.L971
.L1175:
	movq	72(%rsp), %rcx
	movq	%rdx, g_arena_cur(%rip)
	subq	%rax, 8(%rcx)
	movq	%rdx, %rcx
	jmp	.L973
.L1142:
	movq	72(%rsp), %r15
	movl	%r12d, %r14d
	movq	%r9, 208(%rsp)
	movq	240(%rsp), %rbx
	movq	%r10, 216(%rsp)
.L967:
	movq	96(%rsp), %rax
	cmpq	%rax, v_ITERS(%rip)
	je	.L1176
.L982:
	movq	120(%rsp), %rdi
	testq	%rdi, %rdi
	js	.L983
	movslq	g_vmem_top(%rip), %rax
	cmpq	%rax, %rdi
	movq	%rax, %r12
	jge	.L983
	leaq	g_vmem_slots(%rip), %rax
	addq	%rbx, %rax
	movl	24(%rax), %r10d
	testl	%r10d, %r10d
	je	.L983
	movq	(%rax), %r13
	movq	(%r15), %rdi
	movq	8(%rax), %rsi
	movq	16(%rax), %rdx
	cmpq	%r13, %rdi
	je	.L990
	testq	%rdi, %rdi
	movq	%rdx, %rbp
	jne	.L985
	jmp	.L990
	.p2align 4,,10
	.p2align 3
.L1177:
	testq	%rdi, %rdi
	je	.L1144
.L985:
	movq	%rdi, %r10
	movq	24(%rdi), %rdi
	movq	(%r10), %rcx
	movq	%r10, 32(%rsp)
	call	free
	movq	32(%rsp), %rcx
	call	free
	cmpq	%rdi, %r13
	movq	%rdi, (%r15)
	jne	.L1177
.L1144:
	movq	%rbp, %rdx
.L990:
	testq	%r13, %r13
	je	.L1178
	movq	0(%r13), %rax
	addq	%rax, %rsi
	addq	16(%r13), %rax
	movq	%rax, %r13
.L988:
	cmpl	%r14d, %r12d
	movq	%r13, g_arena_end(%rip)
	movq	%rsi, g_arena_cur(%rip)
	movq	%rdx, 8(%r15)
	jle	.L993
	movl	%r12d, %edx
	movq	168(%rsp), %rdi
	leaq	24+g_vmem_slots(%rip), %rax
	subl	%r14d, %edx
	addq	120(%rsp), %rdx
	salq	$5, %rdx
	addq	%rax, %rdx
	movq	%rdi, %rax
	movq	%rdx, %rcx
	subq	%rdi, %rcx
	andl	$32, %ecx
	je	.L992
	addq	$32, %rax
	movl	$0, (%rdi)
	cmpq	%rax, %rdx
	je	.L993
.L992:
	movl	$0, (%rax)
	addq	$64, %rax
	movl	$0, -32(%rax)
	cmpq	%rax, %rdx
	jne	.L992
.L993:
	addq	$1, 96(%rsp)
	movl	%r14d, g_vmem_top(%rip)
	movq	96(%rsp), %rax
	cmpq	%rax, 256(%rsp)
	jge	.L957
	jmp	.L922
.L976:
	movl	$32, %ecx
	movq	%r9, 272(%rsp)
	movq	%r10, 280(%rsp)
	movl	%r11d, 264(%rsp)
	movq	%rdx, 144(%rsp)
	call	malloc
	movq	144(%rsp), %rdx
	testq	%rax, %rax
	movl	264(%rsp), %r11d
	movq	%rax, 208(%rsp)
	movq	272(%rsp), %r9
	movq	280(%rsp), %r10
	je	.L974
	movq	%r9, 288(%rsp)
	movq	64(%rsp), %r9
	movl	$8388608, %eax
	movl	%r11d, 272(%rsp)
	movq	%r10, 296(%rsp)
	movq	%rdx, 264(%rsp)
	cmpq	%rax, %r9
	cmovnb	%r9, %rax
	movq	%rax, %rcx
	movq	%rax, 144(%rsp)
	call	malloc
	movq	208(%rsp), %r11
	testq	%rax, %rax
	movq	%rax, %rcx
	movq	%rax, (%r11)
	je	.L932
	movq	72(%rsp), %r10
	movq	64(%rsp), %r9
	movq	144(%rsp), %rdx
	movq	72(%rsp), %r8
	movq	(%r10), %rax
	movq	%r11, (%r10)
	movq	%r9, %xmm0
	movq	%rdx, %xmm4
	punpcklqdq	%xmm4, %xmm0
	movups	%xmm0, 8(%r11)
	movq	%rax, 24(%r11)
	leaq	(%rcx,%r9), %rax
	movl	272(%rsp), %r11d
	movq	%rax, g_arena_cur(%rip)
	leaq	(%rcx,%rdx), %rax
	movq	264(%rsp), %rdx
	movq	%rax, g_arena_end(%rip)
	movq	8(%r10), %rax
	movq	296(%rsp), %r10
	addq	%r9, %rax
	movq	288(%rsp), %r9
	jmp	.L978
.L958:
	leaq	g_vmem_slots(%rip), %rax
	testq	%rbp, %rbp
	movq	%rsi, (%rax,%rbx)
	movq	$0, 8(%rax,%rbx)
	movq	%rdi, 16(%rax,%rbx)
	movl	$1, 24(%rax,%rbx)
	jne	.L959
.L962:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L974
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rbp
	movq	%rax, (%r12)
	je	.L932
	leaq	16(%rax), %rax
	movq	%rsi, 24(%r12)
	addq	$16, %rdi
	movq	%r12, %rsi
	leaq	8388608(%rbp), %rdx
	movups	%xmm8, 8(%r12)
	movq	%r12, (%r15)
	movq	%rax, g_arena_cur(%rip)
	movq	%rdx, g_arena_end(%rip)
	jmp	.L964
.L1178:
	xorl	%esi, %esi
	jmp	.L988
.L1176:
	movq	136(%rsp), %rsi
	xorl	%r11d, %r11d
	movq	$2, 304(%rsp)
	movq	160(%rsp), %rdi
	movq	%r11, 312(%rsp)
	movq	128(%rsp), %rbp
	movdqa	192(%rsp), %xmm3
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movaps	%xmm3, 320(%rsp)
	movq	%rbp, %r8
	call	vyne_index_get
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movdqu	336(%rsp), %xmm4
	movaps	%xmm4, 320(%rsp)
	call	vyne_to_string
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movq	%rbp, %r8
	movdqu	336(%rsp), %xmm3
	leaq	.LC37(%rip), %rax
	movq	$3, 320(%rsp)
	movq	%rax, 328(%rsp)
	movaps	%xmm3, 304(%rsp)
	call	vyne_binop.constprop.0
	movq	344(%rsp), %rdx
	movl	336(%rsp), %ecx
	call	vyne_out.isra.0
	jmp	.L982
.L1172:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L974
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, (%r12)
	je	.L932
	leaq	64(%rax), %rdx
	movups	%xmm7, 8(%r12)
	addq	$64, %rdi
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rax), %rdx
	movq	%rsi, 24(%r12)
	movq	%r12, (%r15)
	movq	%rdx, g_arena_end(%rip)
	jmp	.L966
.L1169:
	movq	v_ITERS(%rip), %rax
	testq	%rax, %rax
	movq	%rax, 80(%rsp)
	jle	.L924
	movl	g_vmem_top(%rip), %r12d
	cmpl	$63, %r12d
	jg	.L994
	leal	1(%r12), %ecx
	movslq	%r12d, %rax
	movslq	%r12d, %r10
	movl	%r12d, 32(%rsp)
	salq	$5, %rax
	movl	%ecx, 120(%rsp)
	movl	$1, %r13d
	leaq	24+g_vmem_slots(%rip), %rdi
	movq	%rax, 96(%rsp)
	leaq	g_vmem_slots(%rip), %rcx
	leaq	(%rax,%rdi), %rbp
	leaq	(%rcx,%rax), %rbx
	leaq	g_arena(%rip), %rdi
.L995:
	movl	120(%rsp), %eax
	movq	(%rdi), %rdx
	movl	%eax, g_vmem_top(%rip)
	movq	g_arena_cur(%rip), %rax
	testq	%rax, %rax
	je	.L1034
	testq	%rdx, %rdx
	je	.L1034
	subq	(%rdx), %rax
.L996:
	movq	96(%rsp), %rcx
	movq	%rax, %xmm0
	movq	%rdx, (%rbx)
	movhps	8(%rdi), %xmm0
	leaq	8+g_vmem_slots(%rip), %rax
	movups	%xmm0, (%rax,%rcx)
	movq	v_N(%rip), %rax
	movl	$1, 24(%rbx)
	testq	%rax, %rax
	jle	.L997
	movq	%rax, %r14
	movq	%rax, %r15
	salq	$13, %rax
	sarq	$2, %r14
	salq	$10, %r15
	xorl	%r9d, %r9d
	leaq	25166176(%rsp), %rsi
	movq	%r14, %r8
	leaq	352(%rsp), %rcx
	salq	$5, %r8
	leaq	16777568(%rsp,%rax), %r11
	.p2align 4,,10
	.p2align 3
.L998:
	testq	%r14, %r14
	movq	%rsi, %r12
	movq	%rsi, %rax
	leaq	16777568(%rsp), %rdx
	je	.L1000
	.p2align 4,,10
	.p2align 3
.L1002:
	pxor	%xmm1, %xmm1
	xorl	%eax, %eax
	movapd	%xmm1, %xmm2
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L1001:
	movapd	(%rcx,%rax), %xmm0
	mulpd	(%rdx,%rax), %xmm0
	addpd	%xmm0, %xmm2
	movapd	16(%rcx,%rax), %xmm0
	mulpd	16(%rdx,%rax), %xmm0
	addq	$32, %rax
	cmpq	%r8, %rax
	addpd	%xmm0, %xmm1
	jne	.L1001
	movapd	%xmm2, %xmm6
	movapd	%xmm1, %xmm7
	addq	$8192, %rdx
	unpckhpd	%xmm6, %xmm6
	movapd	%xmm6, %xmm0
	unpckhpd	%xmm7, %xmm7
	addsd	%xmm7, %xmm1
	addsd	%xmm2, %xmm0
	addq	$8, %r12
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%r12)
	cmpq	%r11, %rdx
	jne	.L1002
.L999:
	addq	$1024, %r9
	addq	$8192, %rsi
	addq	$8192, %rcx
	cmpq	%r9, %r15
	jne	.L998
.L997:
	cmpq	%r13, v_ITERS(%rip)
	je	.L1179
.L1003:
	testq	%r10, %r10
	js	.L1004
	movslq	g_vmem_top(%rip), %rdx
	cmpq	%rdx, %r10
	movq	%rdx, %rax
	jge	.L1004
	movl	24(%rbx), %r9d
	testl	%r9d, %r9d
	je	.L1004
	movq	(%rdi), %rsi
	movq	(%rbx), %r12
	movq	8(%rbx), %r14
	movq	16(%rbx), %r8
	testq	%rsi, %rsi
	je	.L1011
	cmpq	%rsi, %r12
	je	.L1011
	movq	%rbx, 72(%rsp)
	movl	%edx, %r15d
	movq	%rsi, %rbx
	movq	%r10, 64(%rsp)
	movq	%r8, 48(%rsp)
	jmp	.L1006
.L1180:
	testq	%rbx, %rbx
	je	.L1149
.L1006:
	movq	%rbx, %rsi
	movq	24(%rbx), %rbx
	movq	(%rsi), %rcx
	call	free
	movq	%rsi, %rcx
	call	free
	cmpq	%rbx, %r12
	movq	%rbx, (%rdi)
	jne	.L1180
.L1149:
	movq	64(%rsp), %r10
	movl	%r15d, %eax
	movq	48(%rsp), %r8
	movq	72(%rsp), %rbx
.L1011:
	testq	%r12, %r12
	je	.L1181
	movq	(%r12), %rcx
	addq	%rcx, %r14
	addq	16(%r12), %rcx
	movq	%rcx, %r12
.L1009:
	cmpl	32(%rsp), %eax
	movq	%r12, g_arena_end(%rip)
	movq	%r14, g_arena_cur(%rip)
	movq	%r8, 8(%rdi)
	jle	.L1014
	movl	%eax, %edx
	subl	32(%rsp), %edx
	leaq	24+g_vmem_slots(%rip), %rax
	addq	%r10, %rdx
	salq	$5, %rdx
	addq	%rax, %rdx
	movq	%rbp, %rax
	movq	%rdx, %rcx
	subq	%rbp, %rcx
	andl	$32, %ecx
	je	.L1013
	leaq	32(%rbp), %rax
	movl	$0, 0(%rbp)
	cmpq	%rax, %rdx
	je	.L1014
.L1013:
	movl	$0, (%rax)
	addq	$64, %rax
	movl	$0, -32(%rax)
	cmpq	%rax, %rdx
	jne	.L1013
.L1014:
	movl	32(%rsp), %eax
	addq	$1, %r13
	cmpq	%r13, 80(%rsp)
	movl	%eax, g_vmem_top(%rip)
	jge	.L995
	jmp	.L924
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L1000:
	leaq	8192(%rdx), %r12
	movq	$0x000000000, (%rax)
	cmpq	%r11, %r12
	je	.L999
	addq	$16384, %rdx
	movq	$0x000000000, 8(%rax)
	addq	$16, %rax
	cmpq	%rdx, %r11
	jne	.L1000
	jmp	.L999
.L1034:
	xorl	%eax, %eax
	jmp	.L996
.L1181:
	xorl	%r14d, %r14d
	jmp	.L1009
.L1179:
	movq	25166176(%rsp), %rdx
	movq	$1, 176(%rsp)
	movq	136(%rsp), %r15
	movq	%r10, 64(%rsp)
	movq	160(%rsp), %rsi
	movq	176(%rsp), %rax
	movq	%rdx, 328(%rsp)
	movq	%r15, %rdx
	movq	%rsi, %rcx
	movq	%rax, 320(%rsp)
	call	vyne_to_string
	movq	128(%rsp), %r8
	movq	%r15, %rdx
	movq	%rsi, %rcx
	movdqu	336(%rsp), %xmm7
	leaq	.LC37(%rip), %rax
	movq	$3, 320(%rsp)
	movq	%rax, 328(%rsp)
	movaps	%xmm7, 304(%rsp)
	call	vyne_binop.constprop.0
	movq	344(%rsp), %rdx
	movl	336(%rsp), %ecx
	call	vyne_out.isra.0
	movq	64(%rsp), %r10
	jmp	.L1003
.L1017:
	movq	%rbp, %rbx
	jmp	.L1018
.L974:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L932:
	call	arena_alloc.part.0
.L983:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	120(%rsp), %r8
.L1158:
	leaq	.LC38(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
.L1004:
	movq	%r10, %r15
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%r15, %r8
	jmp	.L1158
.L954:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	88(%rsp), %r8
	jmp	.L1158
.L994:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$64, %r8d
	leaq	.LC34(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.globl	v_ITERS
	.bss
	.align 8
v_ITERS:
	.space 8
	.globl	v_N
	.align 8
v_N:
	.space 8
	.globl	v_CONFIG
	.align 8
v_CONFIG:
	.space 8
.lcomm _vmath_rng_inc,8,8
.lcomm _vmath_rng_state,8,8
.lcomm g_vmem_top,4,4
.lcomm g_vmem_slots,2048,32
.lcomm _vyne_char_pool_ready,4,4
.lcomm _vyne_char_pool,512,32
.lcomm g_commit_arena,16,16
.lcomm g_arena_end,8,8
.lcomm g_arena_cur,8,8
.lcomm g_arena,16,16
	.section .rdata,"dr"
	.align 2
.LC13:
	.byte	44
	.byte	32
	.align 2
.LC14:
	.byte	34
	.byte	58
	.align 2
.LC16:
	.byte	58
	.byte	32
	.align 16
.LC26:
	.quad	16
	.quad	8388608
	.align 16
.LC27:
	.quad	64
	.quad	8388608
	.align 8
.LC28:
	.long	0
	.long	4
	.align 8
.LC35:
	.long	0
	.long	1039138816
	.align 8
.LC36:
	.long	0
	.long	1072693248
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 15.2.0"
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	exit;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	strcmp;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	sprintf;	.scl	2;	.type	32;	.endef
	.def	strchr;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	fflush;	.scl	2;	.type	32;	.endef
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	strcpy;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
