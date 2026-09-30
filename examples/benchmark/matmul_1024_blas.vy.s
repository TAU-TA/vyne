	.file	"matmul_1024_blas.vy.c"
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
	.def	arena_alloc;	.scl	3;	.type	32;	.endef
	.seh_proc	arena_alloc
arena_alloc:
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movq	g_arena_cur(%rip), %rax
	leaq	7(%rcx), %rdx
	andq	$-8, %rdx
	testq	%rax, %rax
	je	.L4
	movq	g_arena_end(%rip), %rcx
	subq	%rax, %rcx
	cmpq	%rdx, %rcx
	jb	.L4
	leaq	(%rax,%rdx), %rcx
	addq	8+g_arena(%rip), %rdx
	movq	%rcx, g_arena_cur(%rip)
	movq	%rdx, 8+g_arena(%rip)
	addq	$72, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	movl	$32, %ecx
	movq	%rdx, 40(%rsp)
	call	malloc
	movq	40(%rsp), %rdx
	testq	%rax, %rax
	je	.L12
	movl	$8388608, %ecx
	movq	%rdx, 48(%rsp)
	cmpq	%rcx, %rdx
	movq	%rax, 56(%rsp)
	cmovnb	%rdx, %rcx
	movq	%rcx, 40(%rsp)
	call	malloc
	movq	56(%rsp), %r8
	movq	40(%rsp), %rcx
	testq	%rax, %rax
	movq	48(%rsp), %rdx
	movq	%rax, (%r8)
	je	.L13
	movq	g_arena(%rip), %r9
	vmovq	%rdx, %xmm1
	movq	%r8, g_arena(%rip)
	vpinsrq	$1, %rcx, %xmm1, %xmm0
	addq	%rax, %rcx
	movq	%r9, 24(%r8)
	vmovdqu	%xmm0, 8(%r8)
	leaq	(%rax,%rdx), %r8
	addq	8+g_arena(%rip), %rdx
	movq	%r8, g_arena_cur(%rip)
	movq	%rcx, g_arena_end(%rip)
	movq	%rdx, 8+g_arena(%rip)
	addq	$72, %rsp
	ret
.L12:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L13:
	call	arena_alloc.part.0
	nop
	.seh_endproc
	.p2align 4
	.def	vyne_to_float;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_to_float
vyne_to_float:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	%rcx, %rax
	movq	%rdx, %rcx
	movq	(%rdx), %rdx
	movq	8(%rcx), %rcx
	cmpl	$1, %edx
	je	.L19
	cmpl	$2, %edx
	je	.L20
	cmpl	$3, %edx
	je	.L21
	movq	$1, (%rax)
	movq	$0, 8(%rax)
.L14:
	addq	$40, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L19:
	movq	%rdx, (%rax)
	movq	%rcx, 8(%rax)
	addq	$40, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L20:
	vxorps	%xmm0, %xmm0, %xmm0
	movq	$1, (%rax)
	vcvtsi2sdq	%rcx, %xmm0, %xmm0
	vmovq	%xmm0, 8(%rax)
	addq	$40, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L21:
	movq	%rax, 48(%rsp)
	call	atof
	movq	48(%rsp), %rax
	movq	$1, (%rax)
	vmovq	%xmm0, 8(%rax)
	jmp	.L14
	.seh_endproc
	.p2align 4
	.def	arena_alloc.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	arena_alloc.constprop.0
arena_alloc.constprop.0:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	g_arena_cur(%rip), %rax
	testq	%rax, %rax
	je	.L23
	movq	g_arena_end(%rip), %rdx
	subq	%rax, %rdx
	cmpq	$23, %rdx
	jbe	.L23
	movq	8+g_arena(%rip), %rcx
	leaq	24(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	24(%rcx), %rdx
	movq	%rdx, 8+g_arena(%rip)
	addq	$56, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L23:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	je	.L31
	movl	$8388608, %ecx
	movq	%rax, 40(%rsp)
	call	malloc
	movq	40(%rsp), %rdx
	testq	%rax, %rax
	movq	%rax, (%rdx)
	je	.L32
	movq	g_arena(%rip), %rcx
	vmovdqa	.LC2(%rip), %xmm0
	movq	%rdx, g_arena(%rip)
	movq	%rcx, 24(%rdx)
	movq	8+g_arena(%rip), %rcx
	vmovdqu	%xmm0, 8(%rdx)
	leaq	24(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rax), %rdx
	movq	%rdx, g_arena_end(%rip)
	leaq	24(%rcx), %rdx
	movq	%rdx, 8+g_arena(%rip)
	addq	$56, %rsp
	ret
.L31:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L32:
	call	arena_alloc.part.0
	nop
	.seh_endproc
	.p2align 4
	.def	arena_alloc.constprop.1;	.scl	3;	.type	32;	.endef
	.seh_proc	arena_alloc.constprop.1
arena_alloc.constprop.1:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	g_arena_cur(%rip), %rax
	testq	%rax, %rax
	je	.L34
	movq	g_arena_end(%rip), %rdx
	subq	%rax, %rdx
	cmpq	$31, %rdx
	jbe	.L34
	movq	8+g_arena(%rip), %rcx
	leaq	32(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	32(%rcx), %rdx
	movq	%rdx, 8+g_arena(%rip)
	addq	$56, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L34:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	je	.L42
	movl	$8388608, %ecx
	movq	%rax, 40(%rsp)
	call	malloc
	movq	40(%rsp), %rdx
	testq	%rax, %rax
	movq	%rax, (%rdx)
	je	.L43
	movq	g_arena(%rip), %rcx
	vmovdqa	.LC3(%rip), %xmm0
	movq	%rdx, g_arena(%rip)
	movq	%rcx, 24(%rdx)
	movq	8+g_arena(%rip), %rcx
	vmovdqu	%xmm0, 8(%rdx)
	leaq	32(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rax), %rdx
	movq	%rdx, g_arena_end(%rip)
	leaq	32(%rcx), %rdx
	movq	%rdx, 8+g_arena(%rip)
	addq	$56, %rsp
	ret
.L42:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L43:
	call	arena_alloc.part.0
	nop
	.seh_endproc
	.p2align 4
	.def	arena_alloc.constprop.2;	.scl	3;	.type	32;	.endef
	.seh_proc	arena_alloc.constprop.2
arena_alloc.constprop.2:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	g_arena_cur(%rip), %rax
	testq	%rax, %rax
	je	.L45
	movq	g_arena_end(%rip), %rdx
	subq	%rax, %rdx
	cmpq	$15, %rdx
	jbe	.L45
	movq	8+g_arena(%rip), %rcx
	leaq	16(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	16(%rcx), %rdx
	movq	%rdx, 8+g_arena(%rip)
	addq	$56, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L45:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	je	.L53
	movl	$8388608, %ecx
	movq	%rax, 40(%rsp)
	call	malloc
	movq	40(%rsp), %rdx
	testq	%rax, %rax
	movq	%rax, (%rdx)
	je	.L54
	movq	g_arena(%rip), %rcx
	vmovdqa	.LC4(%rip), %xmm0
	movq	%rdx, g_arena(%rip)
	movq	%rcx, 24(%rdx)
	movq	8+g_arena(%rip), %rcx
	vmovdqu	%xmm0, 8(%rdx)
	leaq	16(%rax), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rax), %rdx
	movq	%rdx, g_arena_end(%rip)
	leaq	16(%rcx), %rdx
	movq	%rdx, 8+g_arena(%rip)
	addq	$56, %rsp
	ret
.L53:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$20, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L54:
	call	arena_alloc.part.0
	nop
	.seh_endproc
	.p2align 4
	.def	vyne_array_create.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_array_create.constprop.0
vyne_array_create.constprop.0:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	%rcx, %rbx
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movq	%rax, %rsi
	call	arena_alloc
	movq	$4, (%rbx)
	movq	%rax, (%rsi)
	movq	.LC5(%rip), %rax
	movq	%rsi, 8(%rbx)
	movq	%rax, 8(%rsi)
	movq	%rbx, %rax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC6:
	.ascii "Int64\0"
.LC7:
	.ascii "Float64\0"
.LC8:
	.ascii "String\0"
.LC9:
	.ascii "Boolean\0"
.LC10:
	.ascii "Array\0"
.LC11:
	.ascii "Array<Float64>\0"
.LC12:
	.ascii "Array<Int64>\0"
.LC13:
	.ascii "Map\0"
.LC14:
	.ascii "Struct\0"
.LC15:
	.ascii "Null\0"
.LC16:
	.ascii "Unknown\0"
	.text
	.p2align 4
	.def	vyne_get_type_name.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_get_type_name.isra.0
vyne_get_type_name.isra.0:
	.seh_endprologue
	cmpl	$12, %ecx
	ja	.L57
	leaq	.L59(%rip), %rdx
	movl	%ecx, %ecx
	movslq	(%rdx,%rcx,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L59:
	.long	.L68-.L59
	.long	.L69-.L59
	.long	.L66-.L59
	.long	.L65-.L59
	.long	.L64-.L59
	.long	.L63-.L59
	.long	.L62-.L59
	.long	.L57-.L59
	.long	.L57-.L59
	.long	.L57-.L59
	.long	.L61-.L59
	.long	.L60-.L59
	.long	.L58-.L59
	.text
	.p2align 4,,10
	.p2align 3
.L57:
	leaq	.LC16(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L68:
	leaq	.LC15(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L65:
	leaq	.LC8(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L64:
	leaq	.LC10(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L63:
	leaq	.LC9(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L62:
	leaq	.LC14(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L61:
	leaq	.LC13(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L60:
	leaq	.LC11(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L58:
	leaq	.LC12(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L69:
	leaq	.LC7(%rip), %rax
	ret
	.p2align 4,,10
	.p2align 3
.L66:
	leaq	.LC6(%rip), %rax
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC17:
	.ascii "true\0"
.LC18:
	.ascii "false\0"
.LC19:
	.ascii "null\0"
.LC20:
	.ascii "%lld\0"
.LC21:
	.ascii "%s\0"
.LC22:
	.ascii "%g\0"
.LC23:
	.ascii ", \0"
.LC24:
	.ascii "\"%s\": \0"
.LC25:
	.ascii "%s { \0"
.LC26:
	.ascii " }\0"
.LC27:
	.ascii "%s: \0"
.LC28:
	.ascii "<unknown>\0"
	.text
	.p2align 4
	.def	_vyne_print_internal.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	_vyne_print_internal.isra.0
_vyne_print_internal.isra.0:
	pushq	%rbx
	.seh_pushreg	%rbx
	addq	$-128, %rsp
	.seh_stackalloc	128
	.seh_endprologue
	cmpl	$12, %ecx
	movq	%rdx, %rbx
	ja	.L71
	leaq	.L73(%rip), %rdx
	movl	%ecx, %ecx
	movslq	(%rdx,%rcx,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L73:
	.long	.L82-.L73
	.long	.L81-.L73
	.long	.L80-.L73
	.long	.L79-.L73
	.long	.L78-.L73
	.long	.L77-.L73
	.long	.L76-.L73
	.long	.L71-.L73
	.long	.L71-.L73
	.long	.L71-.L73
	.long	.L75-.L73
	.long	.L74-.L73
	.long	.L72-.L73
	.text
	.p2align 4,,10
	.p2align 3
.L71:
	leaq	.LC28(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L82:
	leaq	.LC19(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L81:
	movq	%rbx, %r8
	vmovq	%rbx, %xmm2
	leaq	64(%rsp), %rcx
	leaq	.LC22(%rip), %rdx
	call	sprintf
	movl	$46, %edx
	leaq	64(%rsp), %rcx
	call	strchr
	testq	%rax, %rax
	je	.L120
.L85:
	leaq	64(%rsp), %rdx
	leaq	.LC21(%rip), %rcx
	call	printf
	nop
	subq	$-128, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L80:
	movq	%rbx, %rdx
	leaq	.LC20(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L79:
	testq	%rbx, %rbx
	leaq	.LC19(%rip), %rdx
	cmovne	%rbx, %rdx
.L119:
	leaq	.LC21(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L78:
	movl	$91, %ecx
	call	putchar
	movl	8(%rbx), %edx
	xorl	%r8d, %r8d
	testl	%edx, %edx
	jle	.L90
.L87:
	movq	%r8, %rax
	movq	%r8, 32(%rsp)
	salq	$4, %rax
	addq	(%rbx), %rax
	movq	8(%rax), %rdx
	movl	(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	8(%rbx), %eax
	movq	32(%rsp), %r8
	leal	-1(%rax), %edx
	cmpl	%r8d, %edx
	jg	.L121
	addq	$1, %r8
	cmpl	%r8d, %eax
	jg	.L87
.L90:
	movl	$93, %ecx
	subq	$-128, %rsp
	popq	%rbx
	jmp	putchar
	.p2align 4,,10
	.p2align 3
.L77:
	testq	%rbx, %rbx
	leaq	.LC18(%rip), %rdx
	leaq	.LC17(%rip), %rax
	cmovne	%rax, %rdx
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L76:
	movq	(%rbx), %rdx
	leaq	.LC25(%rip), %rcx
	call	printf
	movl	16(%rbx), %eax
	xorl	%r9d, %r9d
	testl	%eax, %eax
	jle	.L105
.L102:
	movq	%r9, %r8
	movq	8(%rbx), %rax
	movq	%r9, 40(%rsp)
	leaq	.LC27(%rip), %rcx
	salq	$5, %r8
	movq	8(%rax,%r8), %rdx
	movq	%r8, 32(%rsp)
	call	printf
	movq	32(%rsp), %r8
	addq	8(%rbx), %r8
	movq	24(%r8), %rdx
	movl	16(%r8), %ecx
	call	_vyne_print_internal.isra.0
	movl	16(%rbx), %eax
	movq	40(%rsp), %r9
	leal	-1(%rax), %edx
	cmpl	%r9d, %edx
	jg	.L122
	addq	$1, %r9
	cmpl	%r9d, %eax
	jg	.L102
.L105:
	leaq	.LC26(%rip), %rcx
	subq	$-128, %rsp
	popq	%rbx
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L75:
	movl	$123, %ecx
	call	putchar
	movl	12(%rbx), %eax
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	testl	%eax, %eax
	jle	.L100
.L97:
	cmpl	%r9d, 8(%rbx)
	jle	.L100
	movq	(%rbx), %rdx
	movq	(%rdx,%r8), %rdx
	cmpq	$1, %rdx
	jbe	.L98
	testl	%r9d, %r9d
	jne	.L123
.L99:
	leaq	.LC24(%rip), %rcx
	movq	%r8, 32(%rsp)
	movl	%r9d, 52(%rsp)
	movl	%r10d, 40(%rsp)
	call	printf
	movq	32(%rsp), %rax
	addq	(%rbx), %rax
	movq	16(%rax), %rdx
	movl	8(%rax), %ecx
	call	_vyne_print_internal.isra.0
	movl	52(%rsp), %r9d
	movl	12(%rbx), %eax
	movl	40(%rsp), %r10d
	movq	32(%rsp), %r8
	addl	$1, %r9d
.L98:
	addl	$1, %r10d
	addq	$24, %r8
	cmpl	%eax, %r10d
	jl	.L97
.L100:
	movl	$125, %ecx
	subq	$-128, %rsp
	popq	%rbx
	jmp	putchar
	.p2align 4,,10
	.p2align 3
.L74:
	movl	$91, %ecx
	call	putchar
	cmpq	$0, 8(%rbx)
	jle	.L90
	xorl	%r8d, %r8d
.L93:
	movq	(%rbx), %rax
	movl	$1, %ecx
	movq	%r8, 32(%rsp)
	movq	(%rax,%r8,8), %rdx
	call	_vyne_print_internal.isra.0
	movq	8(%rbx), %rax
	movq	32(%rsp), %r8
	leaq	-1(%rax), %rdx
	cmpq	%r8, %rdx
	jg	.L124
	addq	$1, %r8
	cmpq	%r8, %rax
	jg	.L93
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L72:
	movl	$91, %ecx
	call	putchar
	cmpq	$0, 8(%rbx)
	jle	.L90
	xorl	%r8d, %r8d
.L96:
	movq	(%rbx), %rax
	movl	$2, %ecx
	movq	%r8, 32(%rsp)
	movq	(%rax,%r8,8), %rdx
	call	_vyne_print_internal.isra.0
	movq	8(%rbx), %rax
	movq	32(%rsp), %r8
	leaq	-1(%rax), %rdx
	cmpq	%r8, %rdx
	jg	.L125
	addq	$1, %r8
	cmpq	%r8, %rax
	jg	.L96
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L121:
	leaq	.LC23(%rip), %rcx
	call	printf
	movq	32(%rsp), %r8
	addq	$1, %r8
	cmpl	%r8d, 8(%rbx)
	jg	.L87
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L125:
	leaq	.LC23(%rip), %rcx
	call	printf
	movq	32(%rsp), %r8
	addq	$1, %r8
	cmpq	8(%rbx), %r8
	jl	.L96
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L124:
	leaq	.LC23(%rip), %rcx
	call	printf
	movq	32(%rsp), %r8
	addq	$1, %r8
	cmpq	8(%rbx), %r8
	jl	.L93
	jmp	.L90
	.p2align 4,,10
	.p2align 3
.L122:
	leaq	.LC23(%rip), %rcx
	movq	%r9, 32(%rsp)
	call	printf
	movq	32(%rsp), %r9
	addq	$1, %r9
	cmpl	%r9d, 16(%rbx)
	jg	.L102
	jmp	.L105
	.p2align 4,,10
	.p2align 3
.L123:
	leaq	.LC23(%rip), %rcx
	movq	%r8, 56(%rsp)
	movl	%r9d, 52(%rsp)
	movl	%r10d, 40(%rsp)
	movq	%rdx, 32(%rsp)
	call	printf
	movq	56(%rsp), %r8
	movl	52(%rsp), %r9d
	movl	40(%rsp), %r10d
	movq	32(%rsp), %rdx
	jmp	.L99
	.p2align 4,,10
	.p2align 3
.L120:
	movl	$101, %edx
	leaq	64(%rsp), %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L85
	leaq	64(%rsp), %rcx
	call	strlen
	movw	$12334, 64(%rsp,%rax)
	movb	$0, 66(%rsp,%rax)
	jmp	.L85
	.seh_endproc
	.p2align 4
	.def	vyne_out.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_out.isra.0
vyne_out.isra.0:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	addq	$40, %rsp
	jmp	fflush
	.seh_endproc
	.p2align 4
	.def	vyne_struct_call.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_struct_call.isra.0
vyne_struct_call.isra.0:
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
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	cmpl	$6, %edx
	movq	%rcx, %r12
	movq	%r9, %r13
	jne	.L130
	movl	g_method_count(%rip), %edi
	testl	%edi, %edi
	jle	.L130
	movq	(%r8), %rbp
	leaq	g_method_table(%rip), %rbx
	xorl	%esi, %esi
	.p2align 4,,10
	.p2align 3
.L132:
	movq	(%rbx), %rcx
	movq	%rbp, %rdx
	call	strcmp
	testl	%eax, %eax
	jne	.L131
	movq	8(%rbx), %rcx
	movq	%r13, %rdx
	call	strcmp
	testl	%eax, %eax
	je	.L134
.L131:
	addl	$1, %esi
	addq	$24, %rbx
	cmpl	%esi, %edi
	jne	.L132
.L130:
	movq	%r12, %rax
	movq	$0, (%r12)
	movq	$0, 8(%r12)
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L134:
	movslq	%esi, %rsi
	movq	136(%rsp), %r8
	movq	%r12, %rcx
	movl	128(%rsp), %edx
	leaq	(%rsi,%rsi,2), %rax
	leaq	g_method_table(%rip), %rdi
	call	*16(%rdi,%rax,8)
	movq	%r12, %rax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.seh_endproc
	.p2align 4
	.def	vyne_array_push.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_array_push.isra.0
vyne_array_push.isra.0:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movq	(%r8), %r11
	movq	8(%r8), %r10
	cmpl	$4, %ecx
	movq	%rdx, %r9
	je	.L161
	cmpl	$11, %ecx
	movq	%r10, %rbx
	je	.L162
	cmpl	$12, %ecx
	je	.L163
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
	.p2align 3
.L161:
	movslq	8(%rdx), %rax
	movslq	12(%rdx), %rdx
	cmpl	%edx, %eax
	jge	.L137
	movq	(%r9), %rcx
.L138:
	leal	1(%rax), %edx
	salq	$4, %rax
	movl	%edx, 8(%r9)
	movq	%r11, (%rcx,%rax)
	movq	%r10, 8(%rcx,%rax)
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
	.p2align 3
.L163:
	movq	8(%rdx), %rax
	movq	16(%rdx), %rcx
	movq	(%rdx), %rdx
	cmpq	%rcx, %rax
	jge	.L164
.L152:
	cmpl	$2, %r11d
	je	.L157
	xorl	%ebx, %ebx
	cmpl	$1, %r11d
	jne	.L157
	vmovq	%r10, %xmm1
	vcvttsd2siq	%xmm1, %rcx
	movq	%rcx, %rbx
.L157:
	leaq	1(%rax), %rcx
	movq	%rcx, 8(%r9)
	movq	%rbx, (%rdx,%rax,8)
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
	.p2align 3
.L162:
	movq	8(%rdx), %rax
	movq	16(%rdx), %rcx
	movq	(%rdx), %rdx
	cmpq	%rcx, %rax
	jge	.L165
.L145:
	cmpl	$1, %r11d
	vmovq	%r10, %xmm0
	je	.L151
	cmpl	$2, %r11d
	vxorpd	%xmm0, %xmm0, %xmm0
	jne	.L151
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%r10, %xmm0, %xmm0
.L151:
	leaq	1(%rax), %rcx
	movq	%rcx, 8(%r9)
	vmovsd	%xmm0, (%rdx,%rax,8)
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
	.p2align 3
.L137:
	movq	(%r9), %r8
	leal	(%rdx,%rdx), %eax
	movslq	%eax, %rcx
	movl	%eax, %esi
	salq	$4, %rcx
	testq	%r8, %r8
	movq	%r8, %rbx
	je	.L166
	salq	$4, %rdx
	leaq	(%r8,%rdx), %rax
	cmpq	%rax, g_arena_cur(%rip)
	jne	.L141
	subq	%rdx, 8+g_arena(%rip)
	movq	%r8, g_arena_cur(%rip)
.L141:
	movq	%r10, 48(%rsp)
	movq	%r11, 40(%rsp)
	movq	%r9, 104(%rsp)
	call	arena_alloc
	movq	104(%rsp), %r9
	movq	40(%rsp), %r11
	cmpq	%rax, %rbx
	movq	48(%rsp), %r10
	movq	%rax, %rcx
	jne	.L140
.L142:
	movq	%rcx, (%r9)
	movslq	8(%r9), %rax
	movl	%esi, 12(%r9)
	jmp	.L138
	.p2align 4,,10
	.p2align 3
.L165:
	movq	%rcx, %rax
	leaq	(%rcx,%rcx), %rsi
	salq	$4, %rax
	testq	%rdx, %rdx
	je	.L167
	salq	$3, %rcx
	leaq	(%rdx,%rcx), %r8
	cmpq	%r8, g_arena_cur(%rip)
	jne	.L148
	subq	%rcx, 8+g_arena(%rip)
	movq	%rdx, g_arena_cur(%rip)
.L148:
	movq	%rax, %rcx
	movq	%r10, 56(%rsp)
	movq	%r11, 48(%rsp)
	movq	%r9, 104(%rsp)
	movq	%rdx, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %rdx
	movq	104(%rsp), %r9
	movq	48(%rsp), %r11
	movq	56(%rsp), %r10
	movq	%rax, %rcx
	cmpq	%rdx, %rax
	jne	.L147
.L149:
	movq	%rdx, (%r9)
	movq	8(%r9), %rax
	movq	%rsi, 16(%r9)
	jmp	.L145
	.p2align 4,,10
	.p2align 3
.L164:
	movq	%rcx, %rax
	leaq	(%rcx,%rcx), %rsi
	salq	$4, %rax
	testq	%rdx, %rdx
	je	.L168
	salq	$3, %rcx
	leaq	(%rdx,%rcx), %r8
	cmpq	%r8, g_arena_cur(%rip)
	jne	.L155
	subq	%rcx, 8+g_arena(%rip)
	movq	%rdx, g_arena_cur(%rip)
.L155:
	movq	%rax, %rcx
	movq	%r10, 56(%rsp)
	movq	%r11, 48(%rsp)
	movq	%r9, 104(%rsp)
	movq	%rdx, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %rdx
	movq	104(%rsp), %r9
	movq	48(%rsp), %r11
	movq	56(%rsp), %r10
	movq	%rax, %rcx
	cmpq	%rdx, %rax
	jne	.L154
.L156:
	movq	%rdx, (%r9)
	movq	8(%r9), %rax
	movq	%rsi, 16(%r9)
	jmp	.L152
.L166:
	movq	%r10, 48(%rsp)
	movq	%r11, 40(%rsp)
	movq	%r9, 104(%rsp)
	call	arena_alloc
	movq	104(%rsp), %r9
	movq	40(%rsp), %r11
	movq	48(%rsp), %r10
	movq	%rax, %rcx
.L140:
	movslq	8(%r9), %r8
	movq	%rbx, %rdx
	movq	%r10, 48(%rsp)
	movq	%r11, 40(%rsp)
	salq	$4, %r8
	movq	%r9, 104(%rsp)
	call	memcpy
	movq	48(%rsp), %r10
	movq	40(%rsp), %r11
	movq	104(%rsp), %r9
	movq	%rax, %rcx
	jmp	.L142
.L167:
	movq	%rax, %rcx
	movq	%r10, 56(%rsp)
	movq	%r11, 48(%rsp)
	movq	%r9, 104(%rsp)
	movq	%rdx, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %rdx
	movq	104(%rsp), %r9
	movq	48(%rsp), %r11
	movq	56(%rsp), %r10
	movq	%rax, %rcx
.L147:
	movq	8(%r9), %r8
	movq	%r10, 48(%rsp)
	movq	%r11, 40(%rsp)
	salq	$3, %r8
	movq	%r9, 104(%rsp)
	call	memcpy
	movq	48(%rsp), %r10
	movq	40(%rsp), %r11
	movq	104(%rsp), %r9
	movq	%rax, %rdx
	jmp	.L149
.L168:
	movq	%rax, %rcx
	movq	%r10, 56(%rsp)
	movq	%r11, 48(%rsp)
	movq	%r9, 104(%rsp)
	movq	%rdx, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %rdx
	movq	104(%rsp), %r9
	movq	48(%rsp), %r11
	movq	56(%rsp), %r10
	movq	%rax, %rcx
.L154:
	movq	8(%r9), %r8
	movq	%r10, 48(%rsp)
	movq	%r11, 40(%rsp)
	salq	$3, %r8
	movq	%r9, 104(%rsp)
	call	memcpy
	movq	48(%rsp), %r10
	movq	40(%rsp), %r11
	movq	104(%rsp), %r9
	movq	%rax, %rdx
	jmp	.L156
	.seh_endproc
	.p2align 4
	.def	vyne_array_set.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_array_set.isra.0
vyne_array_set.isra.0:
	.seh_endprologue
	movq	40(%rsp), %rax
	movq	(%rax), %r10
	movq	8(%rax), %rax
	cmpl	$2, %r8d
	jne	.L181
	cmpl	$4, %ecx
	je	.L182
	cmpl	$11, %ecx
	movq	%rax, %r8
	je	.L183
	testq	%r9, %r9
	js	.L181
	cmpl	$12, %ecx
	je	.L184
.L181:
	ret
	.p2align 4,,10
	.p2align 3
.L182:
	testq	%r9, %r9
	js	.L181
	movslq	8(%rdx), %rcx
	cmpq	%r9, %rcx
	jle	.L181
	salq	$4, %r9
	addq	(%rdx), %r9
	movq	%r10, (%r9)
	movq	%rax, 8(%r9)
	ret
	.p2align 4,,10
	.p2align 3
.L183:
	testq	%r9, %r9
	js	.L181
	cmpq	%r9, 8(%rdx)
	jle	.L181
	cmpl	$1, %r10d
	vmovq	%rax, %xmm0
	je	.L174
	cmpl	$2, %r10d
	vxorpd	%xmm0, %xmm0, %xmm0
	jne	.L174
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rax, %xmm0, %xmm0
.L174:
	movq	(%rdx), %rax
	vmovsd	%xmm0, (%rax,%r9,8)
	ret
	.p2align 4,,10
	.p2align 3
.L184:
	cmpq	%r9, 8(%rdx)
	jle	.L181
	cmpl	$2, %r10d
	je	.L175
	xorl	%r8d, %r8d
	cmpl	$1, %r10d
	jne	.L175
	vmovq	%rax, %xmm1
	vcvttsd2siq	%xmm1, %r8
.L175:
	movq	(%rdx), %rax
	movq	%r8, (%rax,%r9,8)
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_shape
	.def	fn_vlin_Types_Matrix_shape;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_shape
fn_vlin_Types_Matrix_shape:
	pushq	%r14
	.seh_pushreg	%r14
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
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L186
	movl	(%r8), %r14d
	movq	8(%r8), %r12
	movl	$4, %esi
	call	arena_alloc.constprop.2
	movl	$32, %ecx
	movq	%rax, %rbp
	call	arena_alloc
	movq	.LC29(%rip), %rcx
	cmpl	$6, %r14d
	movq	%rbp, %rdi
	movq	%rax, 0(%rbp)
	movq	%rcx, 8(%rbp)
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movq	$0, 16(%rax)
	movq	$0, 24(%rax)
	jne	.L187
	movslq	16(%r12), %rax
	testl	%eax, %eax
	jle	.L204
	movq	8(%r12), %r11
	salq	$5, %rax
	leaq	(%rax,%r11), %r10
	movq	%r11, %rax
	jmp	.L193
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L191:
	addq	$32, %rax
	cmpq	%r10, %rax
	je	.L205
.L193:
	cmpl	$107, (%rax)
	jne	.L191
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L192:
	leaq	64(%rsp), %r12
	movq	%rdx, 72(%rsp)
	xorl	%r9d, %r9d
	movl	$2, %r8d
	movq	%r12, 32(%rsp)
	movq	%rbp, %rdx
	movl	$4, %ecx
	movq	%r10, 56(%rsp)
	movq	%rax, 64(%rsp)
	call	vyne_array_set.isra.0
	movq	56(%rsp), %r10
	jmp	.L197
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L196:
	addq	$32, %r11
	cmpq	%r11, %r10
	je	.L195
.L197:
	cmpl	$109, (%r11)
	jne	.L196
	movq	16(%r11), %rax
	movq	24(%r11), %rdx
	jmp	.L190
	.p2align 4,,10
	.p2align 3
.L186:
	call	arena_alloc.constprop.2
	movl	$32, %ecx
	movl	$4, %esi
	movq	%rax, %rbp
	call	arena_alloc
	movq	.LC29(%rip), %rdx
	movq	%rbp, %rdi
	movq	%rax, 0(%rbp)
	movq	%rdx, 8(%rbp)
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movq	$0, 16(%rax)
	movq	$0, 24(%rax)
.L187:
	leaq	64(%rsp), %r12
	movq	%rbp, %rdx
	xorl	%r9d, %r9d
	movl	$4, %ecx
	movq	%r12, 32(%rsp)
	movl	$2, %r8d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_array_set.isra.0
	xorl	%eax, %eax
	xorl	%edx, %edx
.L190:
	movq	%r12, 32(%rsp)
	movl	$1, %r9d
	movl	$4, %ecx
	movl	$2, %r8d
	movq	%rdx, 72(%rsp)
	movq	%rbp, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_array_set.isra.0
	movq	%rbx, %rax
	movq	%rsi, (%rbx)
	movq	%rdi, 8(%rbx)
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r14
	ret
.L204:
	leaq	64(%rsp), %r12
	xorl	%r9d, %r9d
	movq	%rbp, %rdx
	movl	$4, %ecx
	movq	%r12, 32(%rsp)
	movl	$2, %r8d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_array_set.isra.0
	.p2align 4,,10
	.p2align 3
.L195:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L190
	.p2align 4,,10
	.p2align 3
.L205:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L192
	.seh_endproc
	.p2align 4
	.def	_vyne_array_elem_at.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	_vyne_array_elem_at.isra.0
_vyne_array_elem_at.isra.0:
	.seh_endprologue
	cmpl	$4, %edx
	movq	%rcx, %rax
	je	.L212
	cmpl	$11, %edx
	je	.L213
	cmpl	$12, %edx
	je	.L214
.L208:
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	ret
	.p2align 4,,10
	.p2align 3
.L213:
	testq	%r9, %r9
	js	.L208
	cmpq	8(%r8), %r9
	jge	.L208
	movq	(%r8), %rdx
	movq	$1, (%rax)
	movq	(%rdx,%r9,8), %rcx
	movq	%rcx, 8(%rax)
	ret
	.p2align 4,,10
	.p2align 3
.L212:
	testq	%r9, %r9
	js	.L208
	movslq	8(%r8), %rdx
	cmpq	%rdx, %r9
	jge	.L208
	salq	$4, %r9
	addq	(%r8), %r9
	movq	(%r9), %r8
	movq	8(%r9), %r9
	movq	%r8, (%rcx)
	movq	%r9, 8(%rcx)
	ret
	.p2align 4,,10
	.p2align 3
.L214:
	testq	%r9, %r9
	js	.L208
	cmpq	8(%r8), %r9
	jge	.L208
	movq	(%r8), %rdx
	movq	$2, (%rax)
	movq	(%rdx,%r9,8), %rcx
	movq	%rcx, 8(%rax)
	ret
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
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	(%rdx), %rax
	movq	8(%rdx), %rbx
	movq	8(%r8), %r9
	leal	-11(%rax), %edx
	movl	%eax, %r11d
	cmpl	$1, %edx
	movq	%rcx, %r10
	movq	(%r8), %rcx
	jbe	.L229
	cmpl	$4, %eax
	je	.L229
	cmpl	$10, %eax
	je	.L248
	cmpl	$2, %ecx
	jne	.L221
	cmpl	$3, %eax
	je	.L249
.L221:
	movq	$0, (%r10)
	movq	$0, 8(%r10)
.L215:
	movq	%r10, %rax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L229:
	cmpl	$2, %ecx
	jne	.L221
	movq	%rbx, %r8
	movl	%r11d, %edx
	movq	%r10, %rcx
	call	_vyne_array_elem_at.isra.0
	movq	%r10, %rax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L248:
	cmpl	$3, %ecx
	jne	.L221
	movl	8(%rbx), %edx
	testl	%edx, %edx
	je	.L221
	movzbl	(%r9), %eax
	movl	12(%rbx), %esi
	testb	%al, %al
	je	.L228
	movq	%r9, %rdx
	movl	$-2128831035, %r8d
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L223:
	addq	$1, %rdx
	xorl	%eax, %r8d
	movzbl	(%rdx), %eax
	imull	$16777619, %r8d, %r8d
	testb	%al, %al
	jne	.L223
.L222:
	testl	%esi, %esi
	jle	.L221
	leal	-1(%rsi), %eax
	movq	(%rbx), %rbx
	xorl	%r11d, %r11d
	movl	%eax, %r14d
	andl	%eax, %r8d
	jmp	.L225
	.p2align 4,,10
	.p2align 3
.L224:
	addl	$1, %r8d
	addl	$1, %r11d
	andl	%r14d, %r8d
	cmpl	%r11d, %esi
	je	.L221
.L225:
	movl	%r8d, %eax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rbx,%rax,8), %rax
	movq	(%rax), %rcx
	movq	%rax, %rdi
	testq	%rcx, %rcx
	je	.L221
	cmpq	$1, %rcx
	je	.L224
	movq	%r9, %rdx
	movq	%r10, 96(%rsp)
	movl	%r11d, 44(%rsp)
	movl	%r8d, 40(%rsp)
	movq	%r9, 32(%rsp)
	call	strcmp
	movq	32(%rsp), %r9
	movl	40(%rsp), %r8d
	testl	%eax, %eax
	movl	44(%rsp), %r11d
	movq	96(%rsp), %r10
	jne	.L224
	movq	8(%rdi), %rax
	movq	16(%rdi), %rdx
	movq	%rax, (%r10)
	movq	%rdx, 8(%r10)
	jmp	.L215
	.p2align 4,,10
	.p2align 3
.L249:
	movq	%rbx, %rcx
	movq	%r9, 32(%rsp)
	movq	%r10, 96(%rsp)
	call	strlen
	movq	32(%rsp), %r9
	movq	96(%rsp), %r10
	testl	%r9d, %r9d
	js	.L221
	cmpl	%eax, %r9d
	jge	.L221
	movl	_vyne_char_pool_ready(%rip), %eax
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L226
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L227:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L227
	movl	$1, _vyne_char_pool_ready(%rip)
.L226:
	movslq	%r9d, %r9
	movq	$3, (%r10)
	movzbl	(%rbx,%r9), %eax
	leaq	(%rcx,%rax,2), %rax
	movq	%rax, 8(%r10)
	jmp	.L215
.L228:
	movl	$-2128831035, %r8d
	jmp	.L222
	.seh_endproc
	.p2align 4
	.def	vyne_index_set;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_index_set
vyne_index_set:
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	.seh_endprologue
	movq	(%rcx), %rax
	movq	8(%rcx), %r10
	movq	8(%rdx), %r9
	movq	(%rdx), %rcx
	leal	-11(%rax), %edx
	vmovdqu	(%r8), %xmm0
	movl	%eax, %r11d
	cmpl	$1, %edx
	jbe	.L279
	cmpl	$4, %eax
	je	.L279
	cmpl	$10, %eax
	je	.L296
.L295:
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L279:
	leaq	112(%rsp), %rax
	movl	%ecx, %r8d
	movq	%r10, %rdx
	movl	%r11d, %ecx
	movq	%rax, 32(%rsp)
	vmovdqa	%xmm0, 112(%rsp)
	call	vyne_array_set.isra.0
	nop
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L296:
	cmpl	$3, %ecx
	jne	.L295
	movl	8(%r10), %ecx
	movl	16(%r10), %eax
	movl	12(%r10), %edx
	addl	%ecx, %eax
	leal	0(,%rax,4), %r11d
	leal	(%rdx,%rdx,2), %eax
	cmpl	%eax, %r11d
	leal	-1(%rdx), %ebx
	jl	.L268
	addl	%ecx, %ecx
	leal	(%rdx,%rdx), %r11d
	movq	(%r10), %rax
	movq	%r9, 104(%rsp)
	cmpl	%ecx, %edx
	movl	%edx, 96(%rsp)
	cmovge	%edx, %r11d
	movq	%rax, %rsi
	movq	%r10, 64(%rsp)
	vmovdqa	%xmm0, 80(%rsp)
	movslq	%r11d, %rax
	movl	%r11d, 60(%rsp)
	leaq	(%rax,%rax,2), %rcx
	salq	$3, %rcx
	movq	%rcx, 48(%rsp)
	call	arena_alloc
	movl	60(%rsp), %r11d
	movq	48(%rsp), %rcx
	movq	64(%rsp), %r10
	movslq	96(%rsp), %rdx
	movq	%rax, %r8
	addq	%rax, %rcx
	testl	%r11d, %r11d
	vmovdqa	80(%rsp), %xmm0
	movq	104(%rsp), %r9
	movq	%rax, (%r10)
	movl	%r11d, 12(%r10)
	movl	$0, 8(%r10)
	movl	$0, 16(%r10)
	jle	.L261
	movq	%rcx, %rbx
	subq	%rax, %rbx
	andl	$8, %ebx
	je	.L260
	movq	$0, (%rax)
	leaq	24(%rax), %rax
	cmpq	%rcx, %rax
	je	.L261
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L260:
	movq	$0, (%rax)
	addq	$48, %rax
	movq	$0, -24(%rax)
	cmpq	%rcx, %rax
	jne	.L260
.L261:
	testl	%edx, %edx
	leal	-1(%r11), %ebx
	jle	.L268
	leaq	(%rdx,%rdx,2), %rax
	movq	%rsi, %rcx
	leaq	(%rsi,%rax,8), %rsi
	jmp	.L267
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L262:
	addq	$24, %rcx
	cmpq	%rsi, %rcx
	je	.L268
.L267:
	movq	(%rcx), %r11
	cmpq	$1, %r11
	movq	%r11, %rdi
	jbe	.L262
	movzbl	(%r11), %edx
	movl	$-2128831035, %eax
	testb	%dl, %dl
	je	.L263
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L264:
	addq	$1, %r11
	xorl	%edx, %eax
	movzbl	(%r11), %edx
	imull	$16777619, %eax, %eax
	testb	%dl, %dl
	jne	.L264
	jmp	.L263
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L297:
	addl	$1, %eax
.L263:
	andl	%ebx, %eax
	movl	%eax, %edx
	leaq	(%rdx,%rdx,2), %rdx
	leaq	(%r8,%rdx,8), %rdx
	cmpq	$0, (%rdx)
	jne	.L297
	vmovdqu	8(%rcx), %xmm1
	movq	%rdi, (%rdx)
	vmovdqu	%xmm1, 8(%rdx)
	addl	$1, 8(%r10)
	jmp	.L262
	.p2align 4,,10
	.p2align 3
.L268:
	movzbl	(%r9), %eax
	testb	%al, %al
	je	.L278
	movq	%r9, %rdx
	movl	$-2128831035, %r8d
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L270:
	addq	$1, %rdx
	xorl	%eax, %r8d
	movzbl	(%rdx), %eax
	imull	$16777619, %r8d, %r8d
	testb	%al, %al
	jne	.L270
.L269:
	andl	%ebx, %r8d
	movq	(%r10), %rcx
	movl	%r8d, %eax
	leaq	(%rax,%rax,2), %rax
	movq	%rcx, %rdi
	leaq	(%rcx,%rax,8), %rax
	movq	(%rax), %rcx
	movq	%rax, %rsi
	testq	%rcx, %rcx
	je	.L271
	movl	$-1, %r14d
	jmp	.L272
	.p2align 4,,10
	.p2align 3
.L273:
	movq	%r9, %rdx
	movq	%r10, 96(%rsp)
	movl	%r8d, 60(%rsp)
	movq	%r9, 48(%rsp)
	vmovdqa	%xmm0, 64(%rsp)
	call	strcmp
	movq	48(%rsp), %r9
	movl	60(%rsp), %r8d
	testl	%eax, %eax
	vmovdqa	64(%rsp), %xmm0
	movq	96(%rsp), %r10
	je	.L298
.L274:
	addl	$1, %r8d
	andl	%ebx, %r8d
	movl	%r8d, %eax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rdi,%rax,8), %rax
	movq	(%rax), %rcx
	movq	%rax, %rsi
	testq	%rcx, %rcx
	je	.L299
.L272:
	cmpq	$1, %rcx
	jne	.L273
	movl	%r14d, %eax
	testl	%r14d, %r14d
	cmovs	%r8d, %eax
	movl	%eax, %r14d
	jmp	.L274
.L299:
	testl	%r14d, %r14d
	js	.L271
	movslq	%r14d, %rax
	leaq	(%rax,%rax,2), %rax
	movq	%r9, (%rdi,%rax,8)
	vmovdqu	%xmm0, 8(%rdi,%rax,8)
	subl	$1, 16(%r10)
	jmp	.L295
.L298:
	vmovdqu	%xmm0, 8(%rsi)
	jmp	.L295
.L271:
	addl	$1, 8(%r10)
	movq	%r9, (%rsi)
	vmovdqu	%xmm0, 8(%rsi)
	jmp	.L295
.L278:
	movl	$-2128831035, %r8d
	jmp	.L269
	.seh_endproc
	.p2align 4
	.def	vyne_value_to_array_f64.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_value_to_array_f64.isra.0
vyne_value_to_array_f64.isra.0:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	cmpl	$11, %edx
	movq	%rcx, %rbx
	movq	%r8, %r9
	je	.L317
	cmpl	$12, %edx
	je	.L318
	cmpl	$4, %edx
	jne	.L319
	movslq	8(%r8), %r10
	testq	%r10, %r10
	jle	.L309
	leaq	0(,%r10,8), %r8
	movq	%r10, 40(%rsp)
	movq	%r8, %rcx
	movq	%r9, 80(%rsp)
	movq	%r8, 32(%rsp)
	call	arena_alloc
	movq	32(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	80(%rsp), %r9
	movq	40(%rsp), %r10
	vxorps	%xmm1, %xmm1, %xmm1
	movq	%rax, %r11
	movq	%rax, %rcx
	movq	(%r9), %rdx
	movq	%r10, %r9
	salq	$4, %r9
	addq	%rdx, %r9
	jmp	.L310
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L312:
	addq	$16, %rdx
	vcvtsi2sdq	%r8, %xmm1, %xmm0
	vmovlpd	%xmm0, (%rcx)
	cmpq	%rdx, %r9
	je	.L314
.L313:
	addq	$8, %rcx
.L310:
	cmpl	$1, (%rdx)
	movq	8(%rdx), %r8
	jne	.L312
	addq	$16, %rdx
	movq	%r8, (%rcx)
	cmpq	%r9, %rdx
	jne	.L313
.L314:
	movq	%r10, %rax
.L311:
	vmovq	%r10, %xmm3
	movq	%r11, (%rbx)
	vpinsrq	$1, %rax, %xmm3, %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, 8(%rbx)
	addq	$48, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L319:
	movl	$32, %ecx
	call	arena_alloc
	vmovdqa	.LC30(%rip), %xmm0
	movq	%rax, (%rbx)
	vmovdqu	%xmm0, 8(%rbx)
.L300:
	movq	%rbx, %rax
	addq	$48, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L317:
	movq	16(%r8), %rax
	vmovdqu	(%r8), %xmm4
	movq	%rax, 16(%rcx)
	movq	%rbx, %rax
	vmovdqu	%xmm4, (%rcx)
	addq	$48, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L309:
	movl	$32, %ecx
	movq	%r10, 32(%rsp)
	call	arena_alloc
	movq	32(%rsp), %r10
	movq	%rax, %r11
	movl	$4, %eax
	jmp	.L311
	.p2align 4,,10
	.p2align 3
.L318:
	movq	8(%r8), %r10
	movq	%r8, 80(%rsp)
	testq	%r10, %r10
	jle	.L304
	leaq	0(,%r10,8), %r8
	movq	%r10, 40(%rsp)
	movq	%r8, %rcx
	movq	%r8, 32(%rsp)
	call	arena_alloc
	movq	32(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	40(%rsp), %r10
	movq	80(%rsp), %r9
	vxorps	%xmm1, %xmm1, %xmm1
	movq	%rax, %rcx
	movq	%r10, %rax
.L305:
	movq	8(%r9), %rdx
	vmovq	%r10, %xmm5
	vpinsrq	$1, %rax, %xmm5, %xmm2
	testq	%rdx, %rdx
	jle	.L306
	movq	(%r9), %r8
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L307:
	vcvtsi2sdq	(%r8,%rax,8), %xmm1, %xmm0
	vmovlpd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L307
.L306:
	movq	%rcx, (%rbx)
	vmovdqu	%xmm2, 8(%rbx)
	jmp	.L300
	.p2align 4,,10
	.p2align 3
.L304:
	movl	$32, %ecx
	movq	%r10, 32(%rsp)
	call	arena_alloc
	movq	80(%rsp), %r9
	movq	32(%rsp), %r10
	vxorps	%xmm1, %xmm1, %xmm1
	movq	%rax, %rcx
	movl	$4, %eax
	jmp	.L305
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_flatten
	.def	fn_vlin_Types_Matrix_flatten;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_flatten
fn_vlin_Types_Matrix_flatten:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L326
	cmpl	$6, (%r8)
	jne	.L326
	movq	8(%r8), %rax
	movslq	16(%rax), %rdx
	testl	%edx, %edx
	jle	.L326
	movq	8(%rax), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L323
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L322:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L326
.L323:
	cmpl	$116, (%rax)
	jne	.L322
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L321
	.p2align 4,,10
	.p2align 3
.L326:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L321:
	leaq	32(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	call	arena_alloc.constprop.0
	movq	32(%rsp), %rdx
	vmovdqu	40(%rsp), %xmm0
	movq	$11, (%rbx)
	movq	%rax, 8(%rbx)
	movq	%rdx, (%rax)
	vmovdqu	%xmm0, 8(%rax)
	movq	%rbx, %rax
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC33:
	.ascii "vlin.Types.Matrix\0"
.LC34:
	.ascii "row\0"
.LC35:
	.ascii "col\0"
.LC36:
	.ascii "data\0"
	.text
	.p2align 4
	.def	vyne_blas_matmul.constprop.0.isra.0;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_blas_matmul.constprop.0.isra.0
vyne_blas_matmul.constprop.0.isra.0:
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
	subq	$200, %rsp
	.seh_stackalloc	200
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	.seh_endprologue
	cmpl	$6, %edx
	movl	%r9d, %r15d
	movq	%rcx, %rbx
	movl	%edx, %r11d
	movq	304(%rsp), %r9
	jne	.L329
	movslq	16(%r8), %rcx
	testl	%ecx, %ecx
	jle	.L330
	movq	8(%r8), %rax
	movq	%rcx, %rsi
	salq	$5, %rsi
	movq	%rax, %rdx
	addq	%rax, %rsi
	movq	%rax, %r10
	jmp	.L333
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L331:
	addq	$32, %r10
	cmpq	%rsi, %r10
	je	.L382
.L333:
	cmpl	$107, (%r10)
	jne	.L331
	movq	24(%r10), %rbp
	movl	%ebp, 124(%rsp)
	jmp	.L337
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L334:
	addq	$32, %rdx
	cmpq	%rsi, %rdx
	je	.L383
.L337:
	cmpl	$109, (%rdx)
	jne	.L334
	cmpl	$6, %r15d
	movl	24(%rdx), %edi
	je	.L336
.L366:
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	jmp	.L335
	.p2align 4,,10
	.p2align 3
.L329:
	cmpl	$6, %r15d
	jne	.L339
	movl	16(%r9), %r10d
	xorl	%edi, %edi
	xorl	%ebp, %ebp
	movl	$0, 124(%rsp)
	testl	%r10d, %r10d
	jle	.L384
.L340:
	movq	8(%r9), %rax
	xorl	%edx, %edx
	jmp	.L348
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L346:
	addl	$1, %edx
	addq	$32, %rax
	cmpl	%r10d, %edx
	jge	.L385
.L348:
	cmpl	$109, (%rax)
	jne	.L346
	movq	24(%rax), %r12
	movq	%r12, %r13
	movl	%r12d, %esi
	imulq	%rbp, %r13
	cmpl	$6, %r11d
	jne	.L349
.L391:
	movslq	16(%r8), %rcx
	testl	%ecx, %ecx
	jle	.L349
	movq	8(%r8), %rax
.L335:
	salq	$5, %rcx
	addq	%rax, %rcx
	jmp	.L353
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L350:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L349
.L353:
	cmpl	$116, (%rax)
	jne	.L350
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	cmpl	$11, %edx
	je	.L386
	cmpl	$4, %edx
	jne	.L349
	movq	(%r8), %rax
	cmpq	_vyne_blas_a_key(%rip), %rax
	je	.L387
	leaq	144(%rsp), %rcx
	movl	$4, %edx
	movq	%r9, 304(%rsp)
	movq	%rax, _vyne_blas_a_key(%rip)
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	movq	304(%rsp), %r9
	movq	%rax, _vyne_blas_a_cache(%rip)
	movq	%rax, %r14
	movq	152(%rsp), %rax
	movq	%rax, 8+_vyne_blas_a_cache(%rip)
	movq	160(%rsp), %rax
	movq	%rax, 16+_vyne_blas_a_cache(%rip)
	jmp	.L354
	.p2align 4,,10
	.p2align 3
.L339:
	movl	$32, %ecx
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	xorl	%esi, %esi
	call	arena_alloc
	movl	$32, %ecx
	xorl	%edi, %edi
	movq	%rax, %r14
	call	arena_alloc
	movl	$0, 124(%rsp)
	vpxor	%xmm6, %xmm6, %xmm6
	movq	%rax, 128(%rsp)
.L342:
	movl	$32, %ecx
	movl	$4, %r13d
	call	arena_alloc
	movq	%rax, %r15
.L365:
	movl	%esi, 104(%rsp)
	movl	124(%rsp), %r9d
	movl	$111, %r8d
	movl	$111, %edx
	movl	%esi, 80(%rsp)
	movl	$101, %ecx
	vpinsrq	$1, %r13, %xmm6, %xmm6
	movq	128(%rsp), %rax
	movl	%edi, 64(%rsp)
	movq	%rax, 72(%rsp)
	movq	.LC32(%rip), %rax
	movl	%edi, 40(%rsp)
	movq	%rax, 48(%rsp)
	movl	%esi, 32(%rsp)
	movq	%r15, 96(%rsp)
	movq	$0x000000000, 88(%rsp)
	movq	%r14, 56(%rsp)
	call	cblas_dgemm
	movl	$40, %ecx
	call	arena_alloc
	movl	$96, %ecx
	movq	%rax, %rdi
	leaq	.LC33(%rip), %rax
	movq	%rax, (%rdi)
	movl	$3, 16(%rdi)
	call	arena_alloc
	movq	$0, 24(%rdi)
	movq	%rax, 8(%rdi)
	movq	%rax, %rsi
	movl	$0, 32(%rdi)
	movl	$107, (%rax)
	leaq	.LC34(%rip), %rax
	movq	%rax, 8(%rsi)
	leaq	.LC35(%rip), %rax
	movq	%rax, 40(%rsi)
	leaq	.LC36(%rip), %rax
	movq	$2, 16(%rsi)
	movq	%rbp, 24(%rsi)
	movl	$109, 32(%rsi)
	movq	$2, 48(%rsi)
	movq	%r12, 56(%rsi)
	movl	$116, 64(%rsi)
	movq	%rax, 72(%rsi)
	call	arena_alloc.constprop.0
	movl	$6, (%rbx)
	movq	%r15, (%rax)
	vmovdqu	%xmm6, 8(%rax)
	movq	%rdi, 8(%rbx)
	movq	%rax, 88(%rsi)
	movq	%rbx, %rax
	movq	$11, 80(%rsi)
	vmovaps	176(%rsp), %xmm6
	addq	$200, %rsp
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
.L383:
	xorl	%edi, %edi
	cmpl	$6, %r15d
	jne	.L366
.L336:
	movl	16(%r9), %r10d
	testl	%r10d, %r10d
	jg	.L340
	jmp	.L366
	.p2align 4,,10
	.p2align 3
.L386:
	movq	(%r8), %r14
.L354:
	cmpl	$6, %r15d
	jne	.L357
.L344:
	movslq	16(%r9), %rdx
	testl	%edx, %edx
	jle	.L357
.L341:
	movq	8(%r9), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L361
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L358:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L357
.L361:
	cmpl	$116, (%rax)
	jne	.L358
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	cmpl	$11, %edx
	je	.L388
	cmpl	$4, %edx
	jne	.L357
	movq	(%r8), %rax
	cmpq	_vyne_blas_b_key(%rip), %rax
	je	.L389
	leaq	144(%rsp), %rcx
	movl	$4, %edx
	movq	%rax, _vyne_blas_b_key(%rip)
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	testq	%r13, %r13
	movq	%rax, %r15
	movq	%rax, _vyne_blas_b_cache(%rip)
	movq	152(%rsp), %rax
	movq	%r15, 128(%rsp)
	movq	%rax, 8+_vyne_blas_b_cache(%rip)
	movq	160(%rsp), %rax
	movq	%rax, 16+_vyne_blas_b_cache(%rip)
	jg	.L390
.L371:
	vmovq	%r13, %xmm6
	jmp	.L342
	.p2align 4,,10
	.p2align 3
.L388:
	movq	(%r8), %rax
	movq	%rax, 128(%rsp)
.L362:
	testq	%r13, %r13
	jle	.L371
.L390:
	leaq	0(,%r13,8), %r8
	movq	%r8, %rcx
	movq	%r8, 136(%rsp)
	call	arena_alloc
	movq	136(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	movq	%rax, %r15
	call	memset
	vmovq	%r13, %xmm6
	jmp	.L365
	.p2align 4,,10
	.p2align 3
.L382:
	movl	$0, 124(%rsp)
	xorl	%ebp, %ebp
	jmp	.L337
	.p2align 4,,10
	.p2align 3
.L385:
	xorl	%esi, %esi
	xorl	%r13d, %r13d
	xorl	%r12d, %r12d
	cmpl	$6, %r11d
	je	.L391
.L349:
	movl	$32, %ecx
	movq	%r9, 304(%rsp)
	call	arena_alloc
	movq	304(%rsp), %r9
	movq	%rax, %r14
	jmp	.L354
	.p2align 4,,10
	.p2align 3
.L389:
	movq	_vyne_blas_b_cache(%rip), %rax
	movq	%rax, 128(%rsp)
	jmp	.L362
	.p2align 4,,10
	.p2align 3
.L387:
	movq	_vyne_blas_a_cache(%rip), %r14
	jmp	.L354
.L330:
	cmpl	$6, %r15d
	jne	.L343
	movl	16(%r9), %r10d
	xorl	%edi, %edi
	xorl	%ebp, %ebp
	movl	$0, 124(%rsp)
	testl	%r10d, %r10d
	jg	.L340
	movl	$32, %ecx
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	movq	%r9, 304(%rsp)
	call	arena_alloc
	movq	304(%rsp), %r9
	movq	%rax, %r14
	jmp	.L344
	.p2align 4,,10
	.p2align 3
.L384:
	movl	$32, %ecx
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	movq	%r9, 304(%rsp)
	call	arena_alloc
	movq	304(%rsp), %r9
	movq	%rax, %r14
	movslq	16(%r9), %rdx
	testl	%edx, %edx
	jg	.L341
	movl	$32, %ecx
	call	arena_alloc
	vpxor	%xmm6, %xmm6, %xmm6
	movq	%rax, 128(%rsp)
	jmp	.L342
	.p2align 4,,10
	.p2align 3
.L343:
	movl	$32, %ecx
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	call	arena_alloc
	movl	$0, 124(%rsp)
	xorl	%esi, %esi
	xorl	%edi, %edi
	movq	%rax, %r14
	.p2align 4,,10
	.p2align 3
.L357:
	movl	$32, %ecx
	call	arena_alloc
	movq	%rax, 128(%rsp)
	jmp	.L362
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
	movq	%rdx, %r11
	movq	%r9, %r10
	je	.L393
	leal	-1(%rcx), %edx
	xorl	%eax, %eax
	cmpl	$1, %edx
	ja	.L392
	leal	-1(%r8), %edx
	cmpl	$1, %edx
	jbe	.L491
.L392:
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
.L393:
	cmpl	$12, %ecx
	ja	.L461
	leaq	.L400(%rip), %rdx
	movl	%ecx, %ecx
	movslq	(%rdx,%rcx,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L400:
	.long	.L458-.L400
	.long	.L405-.L400
	.long	.L403-.L400
	.long	.L404-.L400
	.long	.L461-.L400
	.long	.L403-.L400
	.long	.L461-.L400
	.long	.L461-.L400
	.long	.L461-.L400
	.long	.L461-.L400
	.long	.L402-.L400
	.long	.L401-.L400
	.long	.L399-.L400
	.text
	.p2align 4,,10
	.p2align 3
.L491:
	cmpl	$1, %ecx
	vxorps	%xmm0, %xmm0, %xmm0
	vmovq	%r11, %xmm1
	je	.L396
	vcvtsi2sdq	%r11, %xmm0, %xmm1
.L396:
	cmpl	$1, %r8d
	je	.L492
	vcvtsi2sdq	%r10, %xmm0, %xmm0
.L398:
	vucomisd	%xmm0, %xmm1
	movl	$0, %edx
	setnp	%al
	cmovne	%edx, %eax
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L402:
	cmpq	%r9, %r11
	je	.L458
	movl	8(%r11), %ecx
	xorl	%eax, %eax
	cmpl	8(%r9), %ecx
	movl	%ecx, %r13d
	jne	.L392
	movl	12(%r11), %eax
	testl	%eax, %eax
	movl	%eax, 60(%rsp)
	jle	.L458
	testl	%ecx, %ecx
	jle	.L458
	movq	(%r11), %r15
	xorl	%r12d, %r12d
	xorl	%ebp, %ebp
	.p2align 4,,10
	.p2align 3
.L427:
	movq	(%r15), %rax
	cmpq	$1, %rax
	movq	%rax, %r14
	jbe	.L421
	movq	%rax, %rdx
	movzbl	(%rax), %eax
	movl	12(%r10), %ebx
	movl	$-2128831035, %r8d
	testb	%al, %al
	je	.L422
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L423:
	addq	$1, %rdx
	xorl	%eax, %r8d
	movzbl	(%rdx), %eax
	imull	$16777619, %r8d, %r8d
	testb	%al, %al
	jne	.L423
.L422:
	testl	%ebx, %ebx
	jle	.L461
	leal	-1(%rbx), %eax
	movq	(%r10), %rsi
	xorl	%r9d, %r9d
	movl	%eax, %edi
	andl	%eax, %r8d
	jmp	.L426
	.p2align 4,,10
	.p2align 3
.L494:
	cmpq	$1, %rcx
	je	.L424
	movq	%r14, %rdx
	movq	%r10, 168(%rsp)
	movl	%r9d, 56(%rsp)
	movl	%r8d, 44(%rsp)
	movq	%r11, 48(%rsp)
	call	strcmp
	movl	44(%rsp), %r8d
	movl	56(%rsp), %r9d
	testl	%eax, %eax
	movq	168(%rsp), %r10
	movq	48(%rsp), %r11
	je	.L493
.L424:
	addl	$1, %r8d
	addl	$1, %r9d
	andl	%edi, %r8d
	cmpl	%r9d, %ebx
	je	.L461
.L426:
	movl	%r8d, %eax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rsi,%rax,8), %r11
	movq	(%r11), %rcx
	testq	%rcx, %rcx
	jne	.L494
	.p2align 4,,10
	.p2align 3
.L461:
	xorl	%eax, %eax
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L493:
	movq	16(%r15), %rdx
	movl	8(%r15), %ecx
	movq	16(%r11), %r9
	movl	8(%r11), %r8d
	call	vyne_values_equal.isra.0
	movq	168(%rsp), %r10
	testb	%al, %al
	je	.L392
	addl	$1, %r12d
.L421:
	leal	1(%rbp), %eax
	addq	$24, %r15
	cmpl	%eax, 60(%rsp)
	movl	%eax, %ebp
	jle	.L458
	cmpl	%r12d, %r13d
	jg	.L427
	.p2align 4,,10
	.p2align 3
.L458:
	movl	$1, %eax
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L492:
	vmovq	%r10, %xmm0
	jmp	.L398
	.p2align 4,,10
	.p2align 3
.L403:
	cmpq	%r9, %r11
	sete	%al
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L404:
	movq	%r9, %rdx
	movq	%r11, %rcx
	call	strcmp
	testl	%eax, %eax
	sete	%al
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L401:
	movq	8(%r11), %r9
	xorl	%eax, %eax
	cmpq	8(%r10), %r9
	jne	.L392
	testq	%r9, %r9
	jle	.L458
	leaq	-1(%r9), %rax
	movq	(%r11), %rcx
	movq	(%r10), %r8
	cmpq	$3, %rax
	jbe	.L435
	movq	%r8, %rax
	orq	%rcx, %rax
	testb	$31, %al
	jne	.L435
	movq	%r9, %r10
	vmovdqa	.LC37(%rip), %ymm1
	xorl	%eax, %eax
	xorl	%edx, %edx
	vpbroadcastq	.LC39(%rip), %ymm2
	shrq	$2, %r10
	jmp	.L410
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L408:
	addq	$1, %rdx
	addq	$32, %rax
	vpaddq	%ymm2, %ymm1, %ymm1
	cmpq	%r10, %rdx
	je	.L495
.L410:
	vmovapd	(%rcx,%rax), %ymm0
	vcmpneqpd	(%r8,%rax), %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	je	.L408
	vmovq	%xmm1, %rax
.L409:
	vmovsd	(%rcx,%rax,8), %xmm0
	vucomisd	(%r8,%rax,8), %xmm0
	jp	.L453
	jne	.L453
	leaq	1(%rax), %rdx
	cmpq	%rdx, %r9
	jle	.L454
	vmovsd	8(%rcx,%rax,8), %xmm0
	vucomisd	8(%r8,%rax,8), %xmm0
	jp	.L453
	jne	.L453
	leaq	2(%rax), %rdx
	cmpq	%rdx, %r9
	jle	.L454
	vmovsd	16(%rcx,%rax,8), %xmm0
	vucomisd	16(%r8,%rax,8), %xmm0
	jp	.L453
	jne	.L453
	leaq	3(%rax), %rdx
	cmpq	%rdx, %r9
	jle	.L454
	vmovsd	24(%r8,%rax,8), %xmm0
	vucomisd	24(%rcx,%rax,8), %xmm0
	movl	$0, %edx
	setnp	%al
	cmovne	%edx, %eax
	vzeroupper
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L399:
	movq	8(%r11), %r9
	xorl	%eax, %eax
	cmpq	8(%r10), %r9
	jne	.L392
	testq	%r9, %r9
	jle	.L458
	leaq	-1(%r9), %rax
	movq	(%r11), %rcx
	movq	(%r10), %r8
	cmpq	$4, %rax
	jbe	.L447
	movq	%r8, %rax
	orq	%rcx, %rax
	testb	$31, %al
	jne	.L447
	movq	%r9, %r10
	vmovdqa	.LC37(%rip), %ymm1
	xorl	%eax, %eax
	xorl	%edx, %edx
	vpbroadcastq	.LC39(%rip), %ymm2
	shrq	$2, %r10
	vpxor	%xmm3, %xmm3, %xmm3
	jmp	.L419
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L417:
	addq	$1, %rdx
	addq	$32, %rax
	vpaddq	%ymm2, %ymm1, %ymm1
	cmpq	%rdx, %r10
	je	.L496
.L419:
	vmovdqa	(%r8,%rax), %ymm0
	vpcmpeqq	(%rcx,%rax), %ymm0, %ymm0
	vpcmpeqq	%ymm3, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	je	.L417
	vmovq	%xmm1, %rdx
.L418:
	movq	(%r8,%rdx,8), %rax
	cmpq	%rax, (%rcx,%rdx,8)
	jne	.L453
	leaq	1(%rdx), %rax
	cmpq	%rax, %r9
	jle	.L454
	movq	8(%r8,%rdx,8), %rax
	cmpq	%rax, 8(%rcx,%rdx,8)
	jne	.L453
	leaq	2(%rdx), %rax
	cmpq	%rax, %r9
	jle	.L454
	movq	16(%r8,%rdx,8), %rax
	cmpq	%rax, 16(%rcx,%rdx,8)
	jne	.L453
	leaq	3(%rdx), %rax
	cmpq	%rax, %r9
	jle	.L454
	movq	24(%r8,%rdx,8), %rax
	cmpq	%rax, 24(%rcx,%rdx,8)
	sete	%al
	vzeroupper
	jmp	.L392
	.p2align 4,,10
	.p2align 3
.L405:
	vmovq	%r11, %xmm4
	vmovq	%r9, %xmm5
	movl	$0, %edx
	vucomisd	%xmm5, %xmm4
	setnp	%al
	cmovne	%edx, %eax
	jmp	.L392
.L495:
	testb	$3, %r9b
	movl	$1, %eax
	je	.L488
	movq	%r9, %rax
	andq	$-4, %rax
	jmp	.L409
.L496:
	movq	%r9, %rdx
	movl	$1, %eax
	andq	$-4, %rdx
	testb	$3, %r9b
	jne	.L418
.L488:
	vzeroupper
	jmp	.L392
.L435:
	xorl	%eax, %eax
	jmp	.L415
	.p2align 4,,10
	.p2align 3
.L497:
	addq	$1, %rax
	cmpq	%rax, %r9
	je	.L458
.L415:
	vmovsd	(%r8,%rax,8), %xmm0
	vucomisd	(%rcx,%rax,8), %xmm0
	jp	.L461
	je	.L497
	xorl	%eax, %eax
	jmp	.L392
.L447:
	xorl	%eax, %eax
	jmp	.L420
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L498:
	addq	$1, %rax
	cmpq	%rax, %r9
	je	.L458
.L420:
	movq	(%rcx,%rax,8), %rdx
	cmpq	%rdx, (%r8,%rax,8)
	je	.L498
	xorl	%eax, %eax
	jmp	.L392
.L453:
	xorl	%eax, %eax
	vzeroupper
	jmp	.L392
.L454:
	movl	$1, %eax
	vzeroupper
	jmp	.L392
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
	movq	8(%rdx), %rsi
	movq	%rcx, %rbx
	movq	(%rdx), %rcx
	cmpl	$12, %ecx
	ja	.L500
	leaq	.L502(%rip), %rdx
	movl	%ecx, %eax
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L502:
	.long	.L511-.L502
	.long	.L510-.L502
	.long	.L509-.L502
	.long	.L508-.L502
	.long	.L507-.L502
	.long	.L506-.L502
	.long	.L505-.L502
	.long	.L500-.L502
	.long	.L500-.L502
	.long	.L500-.L502
	.long	.L504-.L502
	.long	.L503-.L502
	.long	.L501-.L502
	.text
	.p2align 4,,10
	.p2align 3
.L500:
	movabsq	$6734116630053416795, %rax
	movb	$0, 104(%rsp)
	leaq	96(%rsp), %rdi
	movq	%rax, 96(%rsp)
.L512:
	movq	%rdi, %rcx
	call	strlen
	leaq	1(%rax), %rsi
	movq	%rsi, %rcx
	call	arena_alloc
	cmpl	$8, %esi
	jnb	.L550
	testb	$4, %sil
	jne	.L593
	testl	%esi, %esi
	je	.L551
	movzbl	96(%rsp), %edx
	testb	$2, %sil
	movb	%dl, (%rax)
	jne	.L594
.L551:
	movq	$3, (%rbx)
	movq	%rax, 8(%rbx)
.L499:
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
.L511:
	movl	$1819047278, 96(%rsp)
	leaq	96(%rsp), %rdi
	movb	$0, 100(%rsp)
	jmp	.L512
	.p2align 4,,10
	.p2align 3
.L510:
	leaq	96(%rsp), %rdi
	movq	%rsi, %r8
	vmovq	%rsi, %xmm2
	leaq	.LC22(%rip), %rdx
	movq	%rdi, %rcx
	call	sprintf
	movl	$46, %edx
	movq	%rdi, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L512
	movl	$101, %edx
	movq	%rdi, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L512
	movq	%rdi, %rcx
	call	strlen
	movw	$12334, (%rdi,%rax)
	movb	$0, 2(%rdi,%rax)
	jmp	.L512
	.p2align 4,,10
	.p2align 3
.L509:
	leaq	96(%rsp), %rdi
	movq	%rsi, %r8
	leaq	.LC20(%rip), %rdx
	movq	%rdi, %rcx
	call	sprintf
	jmp	.L512
	.p2align 4,,10
	.p2align 3
.L508:
	movq	%rcx, (%rbx)
	movq	%rsi, 8(%rbx)
	jmp	.L499
	.p2align 4,,10
	.p2align 3
.L507:
	movl	8(%rsi), %r8d
	movl	$3, %ecx
	testl	%r8d, %r8d
	jle	.L515
	xorl	%ebp, %ebp
	movl	$2, %edi
.L517:
	movq	%rbp, %rax
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	salq	$4, %rax
	addq	(%rsi), %rax
	vmovdqu	(%rax), %xmm0
	vmovdqa	%xmm0, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	addq	%rax, %rdi
	testq	%rbp, %rbp
	leaq	2(%rdi), %rax
	cmovne	%rax, %rdi
	addq	$1, %rbp
	cmpl	%ebp, 8(%rsi)
	jg	.L517
	leaq	1(%rdi), %rcx
.L515:
	call	arena_alloc
	movb	$91, (%rax)
	movl	8(%rsi), %ecx
	movq	%rax, %r14
	testl	%ecx, %ecx
	jle	.L558
	xorl	%ebp, %ebp
	movl	$1, %edi
.L520:
	testq	%rbp, %rbp
	je	.L519
	movzwl	.LC40(%rip), %edx
	leaq	(%r14,%rdi), %rax
	addq	$2, %rdi
	movw	%dx, (%rax)
.L519:
	movq	%rbp, %rax
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	addq	$1, %rbp
	salq	$4, %rax
	addq	(%rsi), %rax
	vmovdqu	(%rax), %xmm1
	vmovdqa	%xmm1, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	movq	88(%rsp), %rdx
	leaq	(%r14,%rdi), %rcx
	movq	%rax, %r8
	movq	%rax, 32(%rsp)
	call	memcpy
	addq	32(%rsp), %rdi
	cmpl	%ebp, 8(%rsi)
	jg	.L520
	leaq	1(%rdi), %rax
.L518:
	movb	$93, (%r14,%rdi)
	movq	%r14, %rcx
	movb	$0, (%r14,%rax)
	call	strlen
	leaq	1(%rax), %rsi
	movq	%rsi, %rcx
	call	arena_alloc
	movq	%rsi, %r8
	movq	%r14, %rdx
	movq	%rax, %rcx
	call	memcpy
	movq	$3, (%rbx)
	movq	%rax, 8(%rbx)
	jmp	.L499
	.p2align 4,,10
	.p2align 3
.L506:
	testq	%rsi, %rsi
	leaq	.LC18(%rip), %rdx
	leaq	96(%rsp), %rdi
	leaq	.LC17(%rip), %rax
	movq	%rdi, %rcx
	cmovne	%rax, %rdx
	call	strcpy
	jmp	.L512
	.p2align 4,,10
	.p2align 3
.L505:
	movq	(%rsi), %rcx
	call	strlen
	movl	16(%rsi), %edx
	leaq	4(%rax), %r8
	testl	%edx, %edx
	jle	.L545
	xorl	%ebp, %ebp
.L546:
	movq	%rbp, %rdi
	movq	%r8, 32(%rsp)
	addq	$1, %rbp
	salq	$5, %rdi
	addq	8(%rsi), %rdi
	movq	8(%rdi), %rcx
	call	strlen
	vmovdqu	16(%rdi), %xmm3
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%rax, %r14
	vmovdqa	%xmm3, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	movq	32(%rsp), %r8
	leaq	4(%r14,%rax), %rax
	addq	%rax, %r8
	cmpl	%ebp, 16(%rsi)
	jg	.L546
.L545:
	movq	%r8, %rcx
	call	arena_alloc
	movq	(%rsi), %rdi
	movq	%rax, %rbp
	movq	%rdi, %rcx
	call	strlen
	movq	%rdi, %rdx
	movq	%rbp, %rcx
	movq	%rax, %r8
	call	memcpy
	movq	(%rsi), %rcx
	call	strlen
	movw	$31520, 0(%rbp,%rax)
	leaq	3(%rax), %rdi
	movb	$32, 2(%rbp,%rax)
	movl	16(%rsi), %eax
	testl	%eax, %eax
	jle	.L547
	xorl	%r9d, %r9d
.L549:
	testq	%r9, %r9
	je	.L548
	movzwl	.LC40(%rip), %edx
	leaq	0(%rbp,%rdi), %rax
	addq	$2, %rdi
	movw	%dx, (%rax)
.L548:
	movq	%r9, %r10
	movq	8(%rsi), %rax
	movq	%r9, 56(%rsp)
	salq	$5, %r10
	movq	8(%rax,%r10), %rdx
	movq	%r10, 48(%rsp)
	movq	%rdx, %rcx
	movq	%rdx, 40(%rsp)
	call	strlen
	movq	40(%rsp), %rdx
	leaq	0(%rbp,%rdi), %rcx
	movq	%rax, %r8
	movq	%rax, 32(%rsp)
	call	memcpy
	addq	32(%rsp), %rdi
	movq	48(%rsp), %r10
	leaq	64(%rsp), %rdx
	movzwl	.LC43(%rip), %eax
	leaq	80(%rsp), %rcx
	movw	%ax, 0(%rbp,%rdi)
	movq	8(%rsi), %rax
	vmovdqu	16(%rax,%r10), %xmm4
	vmovdqa	%xmm4, 64(%rsp)
	call	vyne_to_string
	movq	88(%rsp), %rcx
	call	strlen
	movq	88(%rsp), %rdx
	leaq	2(%rbp,%rdi), %rcx
	movq	%rax, %r8
	movq	%rax, 32(%rsp)
	call	memcpy
	movq	56(%rsp), %r9
	movq	32(%rsp), %r8
	addq	$1, %r9
	cmpl	%r9d, 16(%rsi)
	leaq	2(%rdi,%r8), %rdi
	jg	.L549
.L547:
	movw	$32032, 0(%rbp,%rdi)
	movq	%rbp, %rcx
	movb	$0, 2(%rbp,%rdi)
	call	strlen
	leaq	1(%rax), %rsi
	movq	%rsi, %rcx
	call	arena_alloc
	movq	%rsi, %r8
	movq	%rbp, %rdx
	movq	%rax, %rcx
	call	memcpy
	movq	$3, (%rbx)
	movq	%rax, 8(%rbx)
	jmp	.L499
	.p2align 4,,10
	.p2align 3
.L504:
	movl	8(%rsi), %eax
	testl	%eax, %eax
	movl	%eax, %r14d
	jle	.L536
	movslq	%eax, %rdi
	movq	%rdi, %rcx
	salq	$4, %rcx
	call	arena_alloc
	leaq	0(,%rdi,8), %rcx
	movq	%rax, %r15
	call	arena_alloc
	movl	12(%rsi), %edx
	movq	%rax, 32(%rsp)
	testl	%edx, %edx
	jle	.L595
	leaq	80(%rsp), %rax
	xorl	%edi, %edi
	movl	$3, %r8d
	xorl	%ebp, %ebp
	movq	%rax, 48(%rsp)
	leaq	64(%rsp), %rax
	movq	%rax, 56(%rsp)
.L537:
	movq	(%rsi), %rcx
	leaq	(%rdi,%rdi,2), %rax
	leaq	(%rcx,%rax,8), %rax
	movq	(%rax), %r13
	cmpq	$1, %r13
	jbe	.L540
	movq	32(%rsp), %rcx
	movslq	%ebp, %rdx
	movq	%r8, 40(%rsp)
	addl	$1, %ebp
	movq	%r13, (%rcx,%rdx,8)
	salq	$4, %rdx
	vmovdqu	8(%rax), %xmm5
	leaq	(%r15,%rdx), %r12
	movq	48(%rsp), %rcx
	movq	56(%rsp), %rdx
	vmovdqa	%xmm5, 64(%rsp)
	call	vyne_to_string
	vmovdqu	80(%rsp), %xmm5
	movq	%r13, %rcx
	vmovdqu	%xmm5, (%r12)
	call	strlen
	movq	8(%r12), %rcx
	movq	%rax, %r13
	call	strlen
	movq	40(%rsp), %r8
	movl	12(%rsi), %edx
	leaq	8(%r8,%r13), %r12
	leaq	(%rax,%r12), %r8
.L540:
	leal	1(%rdi), %eax
	cmpl	%edx, %eax
	setl	%cl
	cmpl	%r14d, %ebp
	setl	%al
	addq	$1, %rdi
	testb	%al, %cl
	jne	.L537
	movq	%r8, %rcx
	call	arena_alloc
	movb	$123, (%rax)
	movq	%rax, %rsi
.L542:
	movq	32(%rsp), %rax
	movb	$34, 1(%rsi)
	movq	(%rax), %rbp
	movq	%rbp, %rcx
	call	strlen
	movq	%rbp, %rdx
	leaq	2(%rsi), %rcx
	movq	%rax, %r8
	movq	%rax, %rdi
	call	memcpy
	movzwl	.LC41(%rip), %eax
	movb	$32, 4(%rsi,%rdi)
	movw	%ax, 2(%rsi,%rdi)
	movq	8(%r15), %r12
	movq	%r12, %rcx
	call	strlen
	leaq	5(%rsi,%rdi), %rcx
	movq	%r12, %rdx
	movq	%rax, %r8
	movq	%rax, %rbp
	call	memcpy
	cmpl	$1, %r14d
	leaq	5(%rdi,%rbp), %rdi
	je	.L543
	movl	$1, %ebp
.L544:
	movzwl	.LC40(%rip), %eax
	movb	$34, 2(%rsi,%rdi)
	movw	%ax, (%rsi,%rdi)
	movq	32(%rsp), %rax
	movq	(%rax,%rbp,8), %r13
	movq	%r13, %rcx
	call	strlen
	movq	%r13, %rdx
	leaq	3(%rsi,%rdi), %rcx
	movq	%rax, %r8
	leaq	3(%rax,%rdi), %rdi
	call	memcpy
	movzwl	.LC41(%rip), %eax
	movb	$32, 2(%rsi,%rdi)
	movw	%ax, (%rsi,%rdi)
	movq	%rbp, %rax
	addq	$1, %rbp
	salq	$4, %rax
	movq	8(%r15,%rax), %r13
	movq	%r13, %rcx
	call	strlen
	leaq	3(%rsi,%rdi), %rcx
	movq	%r13, %rdx
	movq	%rax, %r8
	leaq	3(%rax,%rdi), %rdi
	call	memcpy
	cmpl	%ebp, %r14d
	jg	.L544
.L543:
	leaq	1(%rdi), %rax
.L539:
	movb	$125, (%rsi,%rdi)
	movq	$3, (%rbx)
	movb	$0, (%rsi,%rax)
	movq	%rsi, 8(%rbx)
	jmp	.L499
	.p2align 4,,10
	.p2align 3
.L503:
	movq	8(%rsi), %rax
	leaq	(%rax,%rax,2), %rdx
	testq	%rax, %rax
	movl	$3, %eax
	leaq	3(,%rdx,8), %rcx
	cmovle	%rax, %rcx
	call	arena_alloc
	movb	$91, (%rax)
	cmpq	$0, 8(%rsi)
	movq	%rax, %r13
	jle	.L560
	xorl	%ebp, %ebp
	movl	$1, %r12d
	leaq	96(%rsp), %rdi
	jmp	.L531
	.p2align 4,,10
	.p2align 3
.L599:
	testb	$4, %dl
	jne	.L596
	testl	%edx, %edx
	je	.L525
	movzbl	(%rdi), %ecx
	testb	$2, %dl
	movb	%cl, (%rax)
	jne	.L597
.L525:
	addq	%r12, %rdx
	addq	$1, %rbp
	cmpq	%rbp, 8(%rsi)
	jle	.L530
	movzwl	.LC40(%rip), %eax
	leaq	2(%rdx), %r12
	movw	%ax, 0(%r13,%rdx)
.L531:
	movq	(%rsi), %rax
	leaq	.LC22(%rip), %rdx
	movq	%rdi, %rcx
	movq	(%rax,%rbp,8), %r8
	vmovq	%r8, %xmm2
	call	sprintf
	movl	$46, %edx
	movq	%rdi, %rcx
	call	strchr
	testq	%rax, %rax
	je	.L598
.L523:
	movq	%rdi, %rcx
	call	strlen
	movq	%rax, %rdx
	leaq	0(%r13,%r12), %rax
	cmpl	$8, %edx
	jb	.L599
	movq	(%rdi), %rcx
	movq	%rdi, %r10
	movq	%rcx, (%rax)
	movl	%edx, %ecx
	movq	-8(%rdi,%rcx), %r8
	movq	%r8, -8(%rax,%rcx)
	leaq	8(%rax), %rcx
	andq	$-8, %rcx
	subq	%rcx, %rax
	subq	%rax, %r10
	addl	%edx, %eax
	andl	$-8, %eax
	cmpl	$8, %eax
	jb	.L525
	andl	$-8, %eax
	xorl	%r8d, %r8d
.L528:
	movl	%r8d, %r9d
	addl	$8, %r8d
	movq	(%r10,%r9), %r11
	cmpl	%eax, %r8d
	movq	%r11, (%rcx,%r9)
	jb	.L528
	jmp	.L525
	.p2align 4,,10
	.p2align 3
.L501:
	movq	8(%rsi), %rax
	movl	$1, %ebp
	leaq	(%rax,%rax,2), %rdx
	testq	%rax, %rax
	movl	$3, %eax
	leaq	3(,%rdx,8), %rcx
	cmovle	%rax, %rcx
	xorl	%edi, %edi
	call	arena_alloc
	movb	$91, (%rax)
	cmpq	$0, 8(%rsi)
	movq	%rax, %r12
	jle	.L590
	movzwl	.LC40(%rip), %r13d
	jmp	.L533
	.p2align 4,,10
	.p2align 3
.L600:
	movw	%r13w, (%r12,%rax)
	leaq	2(%rax), %rbp
.L533:
	movq	(%rsi), %rax
	leaq	(%r12,%rbp), %rcx
	movl	$24, %edx
	leaq	.LC20(%rip), %r8
	movq	(%rax,%rdi,8), %r9
	addq	$1, %rdi
	call	snprintf
	cltq
	addq	%rbp, %rax
	cmpq	%rdi, 8(%rsi)
	jg	.L600
	leaq	(%r12,%rax), %rdx
	addq	$1, %rax
.L534:
	movb	$93, (%rdx)
	movq	$3, (%rbx)
	movb	$0, (%r12,%rax)
	movq	%r12, 8(%rbx)
	jmp	.L499
	.p2align 4,,10
	.p2align 3
.L550:
	movq	96(%rsp), %rdx
	movq	%rdx, (%rax)
	movl	%esi, %edx
	movq	-8(%rdi,%rdx), %rcx
	movq	%rcx, -8(%rax,%rdx)
	leaq	8(%rax), %rdx
	movq	%rax, %rcx
	andq	$-8, %rdx
	subq	%rdx, %rcx
	addl	%ecx, %esi
	subq	%rcx, %rdi
	andl	$-8, %esi
	cmpl	$8, %esi
	jb	.L551
	andl	$-8, %esi
	xorl	%ecx, %ecx
.L554:
	movl	%ecx, %r8d
	addl	$8, %ecx
	movq	(%rdi,%r8), %r9
	cmpl	%esi, %ecx
	movq	%r9, (%rdx,%r8)
	jb	.L554
	jmp	.L551
	.p2align 4,,10
	.p2align 3
.L598:
	movl	$101, %edx
	movq	%rdi, %rcx
	call	strchr
	testq	%rax, %rax
	jne	.L523
	movq	%rdi, %rcx
	call	strlen
	movw	$12334, (%rdi,%rax)
	movb	$0, 2(%rdi,%rax)
	jmp	.L523
	.p2align 4,,10
	.p2align 3
.L530:
	leaq	1(%rdx), %rax
.L522:
	movb	$93, 0(%r13,%rdx)
	movq	$3, (%rbx)
	movb	$0, 0(%r13,%rax)
	movq	%r13, 8(%rbx)
	jmp	.L499
	.p2align 4,,10
	.p2align 3
.L536:
	movl	$16, %ecx
	movl	$1, %edi
	call	arena_alloc
	movl	$8, %ecx
	call	arena_alloc
	movl	$3, %ecx
	call	arena_alloc
	movb	$123, (%rax)
	movq	%rax, %rsi
	movl	$2, %eax
	jmp	.L539
	.p2align 4,,10
	.p2align 3
.L596:
	movl	(%rdi), %ecx
	movl	%ecx, (%rax)
	movl	%edx, %ecx
	movl	-4(%rdi,%rcx), %r8d
	movl	%r8d, -4(%rax,%rcx)
	jmp	.L525
	.p2align 4,,10
	.p2align 3
.L593:
	movl	96(%rsp), %edx
	movl	%esi, %esi
	movl	%edx, (%rax)
	movl	-4(%rdi,%rsi), %edx
	movl	%edx, -4(%rax,%rsi)
	jmp	.L551
	.p2align 4,,10
	.p2align 3
.L558:
	movl	$2, %eax
	movl	$1, %edi
	jmp	.L518
	.p2align 4,,10
	.p2align 3
.L597:
	movl	%edx, %ecx
	movzwl	-2(%rdi,%rcx), %r8d
	movw	%r8w, -2(%rax,%rcx)
	jmp	.L525
	.p2align 4,,10
	.p2align 3
.L594:
	movl	%esi, %esi
	movzwl	-2(%rdi,%rsi), %edx
	movw	%dx, -2(%rax,%rsi)
	jmp	.L551
.L590:
	leaq	1(%rax), %rdx
	movl	$2, %eax
	jmp	.L534
.L560:
	movl	$2, %eax
	movl	$1, %edx
	jmp	.L522
.L595:
	movl	$3, %ecx
	call	arena_alloc
	movb	$123, (%rax)
	movq	%rax, %rsi
	jmp	.L542
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC45:
	.ascii "Runtime error: Division by zero!\12\0"
	.align 8
.LC46:
	.ascii "Runtime error: Modulo by zero!\12\0"
	.align 8
.LC47:
	.ascii "Runtime error: Invalid operation between %s and %s\12\0"
	.text
	.p2align 4
	.def	vyne_binop_slow;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_binop_slow
vyne_binop_slow:
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
	subq	$120, %rsp
	.seh_stackalloc	120
	.seh_endprologue
	vxorps	%xmm0, %xmm0, %xmm0
	movq	(%rdx), %rax
	movq	(%r8), %r10
	movq	8(%r8), %r11
	movq	8(%rdx), %rdx
	movl	%eax, %esi
	movl	%r10d, %r8d
	cmpl	$29, %r9d
	movq	%rcx, %rbx
	je	.L688
	cmpl	$50, %r9d
	je	.L689
	cmpl	$1, %eax
	je	.L690
	cmpl	$1, %r10d
	je	.L691
.L641:
	cmpl	$43, %r9d
	je	.L692
	cmpl	$44, %r9d
	jne	.L612
	movq	%r11, %r9
	movl	%r10d, %r8d
	movl	%esi, %ecx
	call	vyne_values_equal.isra.0
	movq	$5, (%rbx)
	xorl	$1, %eax
	movzbl	%al, %eax
	movq	%rax, 8(%rbx)
.L601:
	movq	%rbx, %rax
	addq	$120, %rsp
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
.L688:
	cmpl	$3, %eax
	je	.L603
	cmpl	$3, %r10d
	je	.L693
	cmpl	$4, %eax
	je	.L694
	cmpl	$11, %eax
	je	.L685
	cmpl	$12, %eax
	je	.L685
	cmpl	$1, %eax
	je	.L695
	cmpl	$1, %r10d
	je	.L696
.L612:
	movl	%r8d, %ecx
	call	vyne_get_type_name.isra.0
	movl	%esi, %ecx
	movq	%rax, 32(%rsp)
	call	vyne_get_type_name.isra.0
	movl	$2, %ecx
	movq	%rax, %rbx
	call	*__imp___acrt_iob_func(%rip)
	movq	32(%rsp), %r9
	movq	%rbx, %r8
	leaq	.LC47(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
	.p2align 4,,10
	.p2align 3
.L689:
	testl	%eax, %eax
	je	.L628
	cmpl	$5, %eax
	je	.L670
	cmpl	$2, %eax
	je	.L670
	cmpl	$1, %eax
	movl	$1, %ecx
	je	.L697
.L632:
	movq	$5, (%rbx)
	movq	%rcx, 8(%rbx)
	jmp	.L601
	.p2align 4,,10
	.p2align 3
.L691:
	cmpl	$2, %eax
	jne	.L641
	vcvtsi2sdq	%rdx, %xmm0, %xmm0
	vmovapd	%xmm0, %xmm2
.L643:
	vmovq	%r11, %xmm1
	.p2align 4,,10
	.p2align 3
.L644:
	subl	$29, %r9d
	cmpl	$19, %r9d
	ja	.L645
	leaq	.L647(%rip), %rdx
	movslq	(%rdx,%r9,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L647:
	.long	.L638-.L647
	.long	.L657-.L647
	.long	.L656-.L647
	.long	.L655-.L647
	.long	.L645-.L647
	.long	.L645-.L647
	.long	.L645-.L647
	.long	.L654-.L647
	.long	.L653-.L647
	.long	.L645-.L647
	.long	.L645-.L647
	.long	.L645-.L647
	.long	.L645-.L647
	.long	.L645-.L647
	.long	.L652-.L647
	.long	.L651-.L647
	.long	.L650-.L647
	.long	.L649-.L647
	.long	.L648-.L647
	.long	.L646-.L647
	.text
	.p2align 4,,10
	.p2align 3
.L697:
	vmovq	%rdx, %xmm4
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$1, %edx
	vucomisd	%xmm0, %xmm4
	setp	%al
	cmovne	%edx, %eax
.L631:
	testb	%al, %al
	movl	$1, %ecx
	jne	.L632
.L628:
	xorl	%ecx, %ecx
	testl	%r10d, %r10d
	je	.L632
	cmpl	$5, %r10d
	je	.L671
	cmpl	$2, %r10d
	je	.L671
	cmpl	$1, %r10d
	movl	$1, %ecx
	jne	.L632
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%r11, %xmm5
	movl	$1, %eax
	vucomisd	%xmm0, %xmm5
	setp	%cl
	cmovne	%eax, %ecx
.L635:
	movzbl	%cl, %ecx
	jmp	.L632
	.p2align 4,,10
	.p2align 3
.L685:
	cmpq	$0, 8(%rdx)
	jle	.L612
.L611:
	cmpl	$4, %r10d
	je	.L698
	cmpl	$11, %r10d
	je	.L686
	cmpl	$12, %r10d
	jne	.L612
.L686:
	movq	8(%r11), %rcx
.L616:
	testq	%rcx, %rcx
	jle	.L612
	leaq	96(%rsp), %rcx
	movq	%r11, 72(%rsp)
	movq	%r10, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movq	%rax, 48(%rsp)
	movl	%r8d, 40(%rsp)
	call	vyne_array_create.constprop.0
	movq	96(%rsp), %rax
	cmpl	$4, 48(%rsp)
	movq	104(%rsp), %rdi
	movl	40(%rsp), %r8d
	movq	%rax, 32(%rsp)
	movq	56(%rsp), %rdx
	movl	%eax, %r15d
	movq	64(%rsp), %r10
	movq	72(%rsp), %r11
	je	.L699
	movq	8(%rdx), %rax
.L619:
	testq	%rax, %rax
	jle	.L623
	movl	%r8d, 40(%rsp)
	movl	%esi, %r14d
	movq	%rax, %rbp
	movq	%rdx, %r12
	movq	%r10, 48(%rsp)
	movq	%r11, 56(%rsp)
	movq	%rbx, 192(%rsp)
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L620:
	movq	%rbx, %r9
	movq	%r12, %r8
	movl	%r14d, %edx
	addq	$1, %rbx
	leaq	96(%rsp), %rcx
	call	_vyne_array_elem_at.isra.0
	leaq	96(%rsp), %r8
	movq	%rdi, %rdx
	movl	%r15d, %ecx
	call	vyne_array_push.isra.0
	cmpq	%rbp, %rbx
	jne	.L620
	movl	40(%rsp), %r8d
	movq	192(%rsp), %rbx
	movq	48(%rsp), %r10
	movq	56(%rsp), %r11
.L623:
	cmpl	$4, %r10d
	je	.L700
	movq	8(%r11), %rax
.L624:
	xorl	%esi, %esi
	testq	%rax, %rax
	jle	.L626
	movq	%rbx, 192(%rsp)
	movl	%r8d, %r14d
	movq	%rax, %rbp
	movq	%r11, %r12
	.p2align 4,,10
	.p2align 3
.L625:
	movq	%rsi, %r9
	movq	%r12, %r8
	movl	%r14d, %edx
	addq	$1, %rsi
	leaq	96(%rsp), %rcx
	call	_vyne_array_elem_at.isra.0
	leaq	96(%rsp), %r8
	movq	%rdi, %rdx
	movl	%r15d, %ecx
	call	vyne_array_push.isra.0
	cmpq	%rbp, %rsi
	jne	.L625
	movq	192(%rsp), %rbx
.L626:
	movq	32(%rsp), %rax
	movq	%rdi, 8(%rbx)
	movq	%rax, (%rbx)
	jmp	.L601
	.p2align 4,,10
	.p2align 3
.L603:
	movq	%rdx, %rcx
	movq	%r11, 40(%rsp)
	movq	%rdx, %r15
	movq	%r10, 32(%rsp)
	call	strlen
	movq	32(%rsp), %r10
	movq	40(%rsp), %r11
	movq	%rax, %rdi
	cmpl	$3, %r10d
	je	.L606
	leaq	96(%rsp), %rcx
	leaq	80(%rsp), %rdx
	movq	%r10, 80(%rsp)
	movq	%r11, 88(%rsp)
	call	vyne_to_string
	movq	104(%rsp), %rcx
	movq	104(%rsp), %r14
	call	strlen
	movq	%rax, %r10
.L608:
	leaq	(%r10,%rdi), %r11
	movq	%r10, 40(%rsp)
	leaq	1(%r11), %rcx
	movq	%r11, 32(%rsp)
	call	arena_alloc
	movq	%rdi, %r8
	movq	%r15, %rdx
	movq	%rax, %rcx
	movq	%rax, %rsi
	call	memcpy
	movq	40(%rsp), %r8
	leaq	(%rsi,%rdi), %rcx
	movq	%r14, %rdx
	call	memcpy
	movq	32(%rsp), %r11
	movq	$3, (%rbx)
	movq	%rsi, 8(%rbx)
	movb	$0, (%rsi,%r11)
	jmp	.L601
	.p2align 4,,10
	.p2align 3
.L693:
	movq	%rdx, 88(%rsp)
	leaq	96(%rsp), %rcx
	leaq	80(%rsp), %rdx
	movq	%r11, 32(%rsp)
	movq	%rax, 80(%rsp)
	call	vyne_to_string
	movq	104(%rsp), %rcx
	movq	104(%rsp), %r15
	call	strlen
	movq	32(%rsp), %r11
	movq	%rax, %rdi
.L606:
	movq	%r11, %rcx
	movq	%r11, %r14
	call	strlen
	movq	%rax, %r10
	jmp	.L608
	.p2align 4,,10
	.p2align 3
.L692:
	movq	%r11, %r9
	movl	%r10d, %r8d
	movl	%esi, %ecx
	call	vyne_values_equal.isra.0
	movq	$5, (%rbx)
	movzbl	%al, %eax
	movq	%rax, 8(%rbx)
	jmp	.L601
	.p2align 4,,10
	.p2align 3
.L694:
	movl	8(%rdx), %ecx
	testl	%ecx, %ecx
	jg	.L611
	jmp	.L612
	.p2align 4,,10
	.p2align 3
.L696:
	cmpl	$2, %eax
	jne	.L612
	vcvtsi2sdq	%rdx, %xmm0, %xmm0
	vmovapd	%xmm0, %xmm2
.L687:
	vmovq	%r11, %xmm1
.L638:
	vaddsd	%xmm2, %xmm1, %xmm1
	movq	$1, (%rbx)
	vmovq	%xmm1, 8(%rbx)
	jmp	.L601
	.p2align 4,,10
	.p2align 3
.L645:
	movq	$0, (%rbx)
	movq	$0, 8(%rbx)
	jmp	.L601
.L656:
	vmulsd	%xmm2, %xmm1, %xmm1
	movq	$1, (%rbx)
	vmovq	%xmm1, 8(%rbx)
	jmp	.L601
.L657:
	vsubsd	%xmm1, %xmm2, %xmm2
	movq	$1, (%rbx)
	vmovq	%xmm2, 8(%rbx)
	jmp	.L601
.L646:
	xorl	%eax, %eax
	vcomisd	%xmm2, %xmm1
	movq	$5, (%rbx)
	setnb	%al
	movq	%rax, 8(%rbx)
	jmp	.L601
.L648:
	xorl	%eax, %eax
	vcomisd	%xmm1, %xmm2
	movq	$5, (%rbx)
	setnb	%al
	movq	%rax, 8(%rbx)
	jmp	.L601
.L649:
	xorl	%eax, %eax
	vcomisd	%xmm2, %xmm1
	movq	$5, (%rbx)
	seta	%al
	movq	%rax, 8(%rbx)
	jmp	.L601
.L650:
	xorl	%eax, %eax
	vcomisd	%xmm1, %xmm2
	movq	$5, (%rbx)
	seta	%al
	movq	%rax, 8(%rbx)
	jmp	.L601
.L651:
	xorl	%eax, %eax
	vucomisd	%xmm2, %xmm1
	movl	$1, %edx
	movq	$5, (%rbx)
	setp	%al
	cmovne	%rdx, %rax
	movq	%rax, 8(%rbx)
	jmp	.L601
.L652:
	xorl	%eax, %eax
	vucomisd	%xmm2, %xmm1
	movl	$0, %edx
	movq	$5, (%rbx)
	setnp	%al
	cmovne	%rdx, %rax
	movq	%rax, 8(%rbx)
	jmp	.L601
.L653:
	vmovapd	%xmm2, %xmm0
	call	pow
	movq	$1, (%rbx)
	vmovq	%xmm0, 8(%rbx)
	jmp	.L601
.L654:
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm0, %xmm1
	jp	.L660
	je	.L701
.L660:
	vmovsd	%xmm1, 32(%rsp)
	fldl	32(%rsp)
	vmovsd	%xmm2, 32(%rsp)
	fldl	32(%rsp)
.L662:
	fprem
	fnstsw	%ax
	sahf
	jp	.L662
	fstp	%st(1)
	fstpl	32(%rsp)
	vmovsd	32(%rsp), %xmm3
	vucomisd	%xmm3, %xmm3
	jp	.L702
.L663:
	movq	$1, (%rbx)
	vmovq	%xmm3, 8(%rbx)
	jmp	.L601
.L655:
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm0, %xmm1
	jp	.L658
	je	.L703
.L658:
	vdivsd	%xmm1, %xmm2, %xmm2
	movq	$1, (%rbx)
	vmovq	%xmm2, 8(%rbx)
	jmp	.L601
	.p2align 4,,10
	.p2align 3
.L695:
	leal	-1(%r10), %eax
	cmpl	$1, %eax
	ja	.L612
	cmpl	$1, %r10d
	vmovq	%rdx, %xmm2
	je	.L687
.L637:
	vcvtsi2sdq	%r11, %xmm0, %xmm0
	vmovapd	%xmm0, %xmm1
	jmp	.L644
	.p2align 4,,10
	.p2align 3
.L690:
	leal	-1(%r10), %eax
	cmpl	$1, %eax
	ja	.L641
	cmpl	$1, %r10d
	vmovq	%rdx, %xmm2
	jne	.L637
	jmp	.L643
	.p2align 4,,10
	.p2align 3
.L670:
	testq	%rdx, %rdx
	setne	%al
	jmp	.L631
	.p2align 4,,10
	.p2align 3
.L671:
	testq	%r11, %r11
	setne	%cl
	jmp	.L635
	.p2align 4,,10
	.p2align 3
.L698:
	movslq	8(%r11), %rcx
	jmp	.L616
.L700:
	movslq	8(%r11), %rax
	jmp	.L624
.L699:
	movslq	8(%rdx), %rax
	jmp	.L619
.L702:
	vmovapd	%xmm2, %xmm0
	call	fmod
	vmovsd	32(%rsp), %xmm3
	jmp	.L663
.L701:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$31, %r8d
	movl	$1, %edx
	leaq	.LC46(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L703:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$33, %r8d
	movl	$1, %edx
	leaq	.LC45(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.p2align 4
	.def	vyne_binop;	.scl	3;	.type	32;	.endef
	.seh_proc	vyne_binop
vyne_binop:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$80, %rsp
	.seh_stackalloc	80
	.seh_endprologue
	movq	(%rdx), %r10
	movq	(%r8), %r11
	movq	8(%rdx), %rax
	movq	8(%r8), %r8
	cmpl	$2, %r10d
	jne	.L705
	cmpl	$2, %r11d
	jne	.L706
	leal	-29(%r9), %edx
	cmpl	$21, %edx
	ja	.L706
	leaq	.L708(%rip), %rbx
	movslq	(%rbx,%rdx,4), %rdx
	addq	%rbx, %rdx
	jmp	*%rdx
	.section .rdata,"dr"
	.align 4
.L708:
	.long	.L721-.L708
	.long	.L720-.L708
	.long	.L719-.L708
	.long	.L718-.L708
	.long	.L706-.L708
	.long	.L706-.L708
	.long	.L706-.L708
	.long	.L717-.L708
	.long	.L716-.L708
	.long	.L706-.L708
	.long	.L706-.L708
	.long	.L706-.L708
	.long	.L706-.L708
	.long	.L706-.L708
	.long	.L715-.L708
	.long	.L714-.L708
	.long	.L713-.L708
	.long	.L712-.L708
	.long	.L711-.L708
	.long	.L710-.L708
	.long	.L709-.L708
	.long	.L707-.L708
	.text
	.p2align 4,,10
	.p2align 3
.L706:
	movq	%r8, 56(%rsp)
	leaq	64(%rsp), %rdx
	leaq	48(%rsp), %r8
	movq	%rcx, 96(%rsp)
	movq	%r10, 64(%rsp)
	movq	%rax, 72(%rsp)
	movq	%r11, 48(%rsp)
	call	vyne_binop_slow
	movq	96(%rsp), %rcx
.L704:
	movq	%rcx, %rax
	addq	$80, %rsp
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L721:
	addq	%rax, %r8
	movq	$2, (%rcx)
	movq	%r8, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L720:
	subq	%r8, %rax
	movq	$2, (%rcx)
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L719:
	imulq	%rax, %r8
	movq	$2, (%rcx)
	movq	%r8, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L718:
	testq	%r8, %r8
	je	.L740
	cqto
	movq	$2, (%rcx)
	idivq	%r8
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L717:
	testq	%r8, %r8
	je	.L742
	cqto
	movq	$2, (%rcx)
	idivq	%r8
	movq	%rdx, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L716:
	movq	%rcx, 96(%rsp)
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	%rax, %xmm1, %xmm0
	vcvtsi2sdq	%r8, %xmm1, %xmm1
.L755:
	call	pow
	movq	96(%rsp), %rcx
	movq	$1, (%rcx)
	vmovq	%xmm0, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L715:
	cmpq	%rax, %r8
	movq	$5, (%rcx)
	sete	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L714:
	cmpq	%rax, %r8
	movq	$5, (%rcx)
	setne	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L713:
	cmpq	%rax, %r8
	movq	$5, (%rcx)
	setl	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L712:
	cmpq	%rax, %r8
	movq	$5, (%rcx)
	setg	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L711:
	cmpq	%rax, %r8
	movq	$5, (%rcx)
	setle	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L710:
	cmpq	%rax, %r8
	movq	$5, (%rcx)
	setge	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L709:
	testq	%rax, %rax
	movq	$5, (%rcx)
	setne	%dl
	xorl	%eax, %eax
	testq	%r8, %r8
	setne	%al
	andq	%rdx, %rax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L707:
	orq	%rax, %r8
	movq	$5, (%rcx)
	setne	%al
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
	.p2align 4,,10
	.p2align 3
.L705:
	cmpl	$1, %r10d
	jne	.L706
	cmpl	$1, %r11d
	jne	.L706
	leal	-29(%r9), %edx
	vmovq	%rax, %xmm0
	vmovq	%r8, %xmm1
	cmpl	$21, %edx
	ja	.L706
	leaq	.L726(%rip), %rbx
	movslq	(%rbx,%rdx,4), %rdx
	addq	%rbx, %rdx
	jmp	*%rdx
	.section .rdata,"dr"
	.align 4
.L726:
	.long	.L739-.L726
	.long	.L738-.L726
	.long	.L737-.L726
	.long	.L736-.L726
	.long	.L706-.L726
	.long	.L706-.L726
	.long	.L706-.L726
	.long	.L735-.L726
	.long	.L734-.L726
	.long	.L706-.L726
	.long	.L706-.L726
	.long	.L706-.L726
	.long	.L706-.L726
	.long	.L706-.L726
	.long	.L733-.L726
	.long	.L732-.L726
	.long	.L731-.L726
	.long	.L730-.L726
	.long	.L729-.L726
	.long	.L728-.L726
	.long	.L727-.L726
	.long	.L725-.L726
	.text
.L725:
	vxorpd	%xmm2, %xmm2, %xmm2
	movl	$1, %r8d
	movq	$5, (%rcx)
	vucomisd	%xmm2, %xmm0
	setp	%al
	cmovne	%r8d, %eax
	vucomisd	%xmm2, %xmm1
	setp	%dl
	cmovne	%r8d, %edx
	orl	%edx, %eax
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
.L727:
	vxorpd	%xmm2, %xmm2, %xmm2
	movl	$1, %r8d
	movq	$5, (%rcx)
	vucomisd	%xmm2, %xmm0
	setp	%al
	cmovne	%r8d, %eax
	vucomisd	%xmm2, %xmm1
	setp	%dl
	cmovne	%r8d, %edx
	andl	%edx, %eax
	movzbl	%al, %eax
	movq	%rax, 8(%rcx)
	jmp	.L704
.L728:
	xorl	%eax, %eax
	vcomisd	%xmm0, %xmm1
	movq	$5, (%rcx)
	setnb	%al
	movq	%rax, 8(%rcx)
	jmp	.L704
.L729:
	xorl	%eax, %eax
	vcomisd	%xmm1, %xmm0
	movq	$5, (%rcx)
	setnb	%al
	movq	%rax, 8(%rcx)
	jmp	.L704
.L730:
	xorl	%eax, %eax
	vcomisd	%xmm0, %xmm1
	movq	$5, (%rcx)
	seta	%al
	movq	%rax, 8(%rcx)
	jmp	.L704
.L731:
	xorl	%eax, %eax
	vcomisd	%xmm1, %xmm0
	movq	$5, (%rcx)
	seta	%al
	movq	%rax, 8(%rcx)
	jmp	.L704
.L732:
	xorl	%eax, %eax
	vucomisd	%xmm1, %xmm0
	movl	$1, %edx
	movq	$5, (%rcx)
	setp	%al
	cmovne	%rdx, %rax
	movq	%rax, 8(%rcx)
	jmp	.L704
.L733:
	xorl	%eax, %eax
	vucomisd	%xmm1, %xmm0
	movl	$0, %edx
	movq	$5, (%rcx)
	setnp	%al
	cmovne	%rdx, %rax
	movq	%rax, 8(%rcx)
	jmp	.L704
.L734:
	movq	%rcx, 96(%rsp)
	jmp	.L755
.L735:
	vxorpd	%xmm2, %xmm2, %xmm2
	vucomisd	%xmm2, %xmm1
	jp	.L747
	je	.L742
.L747:
	vmovsd	%xmm1, 40(%rsp)
	fldl	40(%rsp)
	vmovsd	%xmm0, 40(%rsp)
	fldl	40(%rsp)
.L744:
	fprem
	fnstsw	%ax
	sahf
	jp	.L744
	fstp	%st(1)
	fstpl	40(%rsp)
	vmovsd	40(%rsp), %xmm2
	vucomisd	%xmm2, %xmm2
	jp	.L756
.L745:
	movq	$1, (%rcx)
	vmovq	%xmm2, 8(%rcx)
	jmp	.L704
.L736:
	vxorpd	%xmm2, %xmm2, %xmm2
	vucomisd	%xmm2, %xmm1
	jp	.L746
	je	.L740
.L746:
	vdivsd	%xmm1, %xmm0, %xmm0
	movq	$1, (%rcx)
	vmovq	%xmm0, 8(%rcx)
	jmp	.L704
.L737:
	vmulsd	%xmm1, %xmm0, %xmm0
	movq	$1, (%rcx)
	vmovq	%xmm0, 8(%rcx)
	jmp	.L704
.L738:
	vsubsd	%xmm1, %xmm0, %xmm0
	movq	$1, (%rcx)
	vmovq	%xmm0, 8(%rcx)
	jmp	.L704
.L739:
	vaddsd	%xmm1, %xmm0, %xmm0
	movq	$1, (%rcx)
	vmovq	%xmm0, 8(%rcx)
	jmp	.L704
.L756:
	movq	%rcx, 96(%rsp)
	call	fmod
	movq	96(%rsp), %rcx
	vmovsd	40(%rsp), %xmm2
	jmp	.L745
.L742:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$31, %r8d
	movl	$1, %edx
	leaq	.LC46(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L740:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$33, %r8d
	movl	$1, %edx
	leaq	.LC45(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_is_vector
	.def	fn_vlin_Types_Matrix_is_vector;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_is_vector
fn_vlin_Types_Matrix_is_vector:
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
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L758
	movl	(%r8), %esi
	movq	8(%r8), %rbp
	movl	$2, %edx
	movl	$1, %eax
	cmpl	$6, %esi
	jne	.L759
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L762
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L767
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L765:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L762
.L767:
	cmpl	$107, (%rax)
	jne	.L765
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L766:
	leaq	64(%rsp), %r12
	leaq	32(%rsp), %r13
	movq	%rdx, 56(%rsp)
	movl	$43, %r9d
	leaq	48(%rsp), %rdi
	movq	%r12, %rcx
	movq	%r13, %r8
	movq	%rax, 48(%rsp)
	movq	$2, 32(%rsp)
	movq	%rdi, %rdx
	movq	$1, 40(%rsp)
	call	vyne_binop
	movq	64(%rsp), %rax
	movq	72(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L795
.L785:
	cmpl	$5, %edx
	je	.L788
	cmpl	$2, %edx
	je	.L788
	cmpl	$1, %edx
	je	.L796
.L782:
	movq	%rbx, %rax
	movq	$5, (%rbx)
	movq	$1, 8(%rbx)
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L758:
	movl	$2, %edx
	movl	$1, %eax
	xorl	%ebp, %ebp
	xorl	%esi, %esi
.L759:
	leaq	64(%rsp), %r12
	leaq	32(%rsp), %r13
	movq	%rdx, 32(%rsp)
	movl	$43, %r9d
	leaq	48(%rsp), %rdi
	movq	%r12, %rcx
	movq	%r13, %r8
	movq	%rax, 40(%rsp)
	movq	$0, 48(%rsp)
	movq	%rdi, %rdx
	movq	$0, 56(%rsp)
	call	vyne_binop
	movq	64(%rsp), %rax
	movq	72(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L785
	movl	$2, %r8d
	movl	$1, %ecx
.L786:
	xorl	%eax, %eax
	xorl	%edx, %edx
.L775:
	movq	%rdx, 56(%rsp)
	movl	$43, %r9d
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%r13, %r8
	movq	%rcx, 40(%rsp)
	movq	%r12, %rcx
	movq	%rax, 48(%rsp)
	call	vyne_binop
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	testl	%eax, %eax
	je	.L778
	cmpl	$5, %eax
	je	.L789
	cmpl	$2, %eax
	je	.L789
	cmpl	$1, %eax
	jne	.L782
	vmovq	%rdx, %xmm2
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$1, %edx
	vucomisd	%xmm0, %xmm2
	setp	%al
	cmovne	%edx, %eax
.L781:
	testb	%al, %al
	jne	.L782
.L778:
	movq	%rbx, %rax
	movq	$5, (%rbx)
	movq	$0, 8(%rbx)
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L788:
	testq	%rcx, %rcx
	setne	%al
.L770:
	testb	%al, %al
	jne	.L782
	cmpl	$6, %esi
	movl	$2, %r8d
	movl	$1, %ecx
	jne	.L786
.L783:
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L786
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L777
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L776:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L786
.L777:
	cmpl	$109, (%rax)
	jne	.L776
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L775
	.p2align 4,,10
	.p2align 3
.L762:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L766
	.p2align 4,,10
	.p2align 3
.L795:
	movl	$2, %r8d
	movl	$1, %ecx
	jmp	.L783
	.p2align 4,,10
	.p2align 3
.L789:
	testq	%rdx, %rdx
	setne	%al
	jmp	.L781
	.p2align 4,,10
	.p2align 3
.L796:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm1
	vucomisd	%xmm0, %xmm1
	setp	%al
	cmovne	%edx, %eax
	jmp	.L770
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Vector_slope
	.def	fn_vlin_Types_Vector_slope;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Vector_slope
fn_vlin_Types_Vector_slope:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$80, %rsp
	.seh_stackalloc	80
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L798
	cmpl	$6, (%r8)
	jne	.L798
	movq	8(%r8), %rax
	movslq	16(%rax), %rcx
	testl	%ecx, %ecx
	jle	.L813
	movq	8(%rax), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L804
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L802:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L814
.L804:
	cmpl	$148, (%rdx)
	jne	.L802
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L808
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L807:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L806
.L808:
	cmpl	$150, (%rax)
	jne	.L807
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L801
	.p2align 4,,10
	.p2align 3
.L798:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L801:
	movq	%rdx, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movq	%r8, 32(%rsp)
	leaq	32(%rsp), %r8
	movq	%r9, 40(%rsp)
	movl	$32, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	addq	$80, %rsp
	popq	%rbx
	ret
.L813:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L806:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L801
	.p2align 4,,10
	.p2align 3
.L814:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L808
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Vector_dot
	.def	fn_vlin_Types_Vector_dot;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Vector_dot
fn_vlin_Types_Vector_dot:
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
	subq	$104, %rsp
	.seh_stackalloc	104
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L816
	cmpl	$1, %edx
	movl	(%r8), %r13d
	movq	8(%r8), %r12
	je	.L840
	movl	16(%r8), %r15d
	movq	24(%r8), %r14
	cmpl	$6, %r15d
	jne	.L821
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L821
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L824
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L823:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L821
.L824:
	cmpl	$148, (%rax)
	jne	.L823
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L822:
	cmpl	$6, %r13d
	jne	.L826
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L826
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L830
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L829:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L826
.L830:
	cmpl	$148, (%rax)
	jne	.L829
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L828:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movq	%rdx, 56(%rsp)
	leaq	48(%rsp), %rdi
	movq	%r8, 32(%rsp)
	movq	%rsi, %rcx
	movq	%rbp, %r8
	movq	%r9, 40(%rsp)
	movq	%rdi, %rdx
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	cmpl	$6, %r15d
	vmovdqu	64(%rsp), %xmm6
	jne	.L819
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L819
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L834
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L833:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L819
.L834:
	cmpl	$150, (%rax)
	jne	.L833
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L832:
	cmpl	$6, %r13d
	jne	.L835
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L835
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L839
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L838:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L835
.L839:
	cmpl	$150, (%rax)
	jne	.L838
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L837:
	movq	%rdx, 56(%rsp)
	movq	%rsi, %rcx
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbp, %r8
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	movq	%rbp, %r8
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	vmovdqu	64(%rsp), %xmm0
	movl	$29, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	80(%rsp), %xmm6
	addq	$104, %rsp
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
.L840:
	xorl	%r15d, %r15d
	xorl	%r14d, %r14d
.L821:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L822
	.p2align 4,,10
	.p2align 3
.L835:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L837
	.p2align 4,,10
	.p2align 3
.L816:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	leaq	48(%rsp), %rdi
	movl	$31, %r9d
	movq	%rbp, %r8
	movq	%rsi, %rcx
	movq	$0, 48(%rsp)
	movq	%rdi, %rdx
	movq	$0, 56(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm6
.L819:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L832
	.p2align 4,,10
	.p2align 3
.L826:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L828
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Vector_cross_product
	.def	fn_vlin_Types_Vector_cross_product;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Vector_cross_product
fn_vlin_Types_Vector_cross_product:
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
	subq	$104, %rsp
	.seh_stackalloc	104
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L847
	cmpl	$1, %edx
	movl	(%r8), %r13d
	movq	8(%r8), %r12
	je	.L871
	movl	16(%r8), %r15d
	movq	24(%r8), %r14
	cmpl	$6, %r15d
	jne	.L852
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L852
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L855
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L854:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L852
.L855:
	cmpl	$150, (%rax)
	jne	.L854
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L853:
	cmpl	$6, %r13d
	jne	.L857
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L857
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L861
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L860:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L857
.L861:
	cmpl	$148, (%rax)
	jne	.L860
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L859:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movq	%rdx, 56(%rsp)
	leaq	48(%rsp), %rdi
	movq	%r8, 32(%rsp)
	movq	%rsi, %rcx
	movq	%rbp, %r8
	movq	%r9, 40(%rsp)
	movq	%rdi, %rdx
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	cmpl	$6, %r15d
	vmovdqu	64(%rsp), %xmm6
	jne	.L850
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L850
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L865
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L864:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L850
.L865:
	cmpl	$148, (%rax)
	jne	.L864
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L863:
	cmpl	$6, %r13d
	jne	.L866
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L866
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L870
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L869:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L866
.L870:
	cmpl	$150, (%rax)
	jne	.L869
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L868:
	movq	%rdx, 56(%rsp)
	movq	%rsi, %rcx
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbp, %r8
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	movq	%rbp, %r8
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	vmovdqu	64(%rsp), %xmm0
	movl	$30, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	80(%rsp), %xmm6
	addq	$104, %rsp
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
.L871:
	xorl	%r15d, %r15d
	xorl	%r14d, %r14d
.L852:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L853
	.p2align 4,,10
	.p2align 3
.L866:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L868
	.p2align 4,,10
	.p2align 3
.L847:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	leaq	48(%rsp), %rdi
	movl	$31, %r9d
	movq	%rbp, %r8
	movq	%rsi, %rcx
	movq	$0, 48(%rsp)
	movq	%rdi, %rdx
	movq	$0, 56(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm6
.L850:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L863
	.p2align 4,,10
	.p2align 3
.L857:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L859
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Vector_magnitude
	.def	fn_vlin_Types_Vector_magnitude;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Vector_magnitude
fn_vlin_Types_Vector_magnitude:
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
	subq	$96, %rsp
	.seh_stackalloc	96
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rdi
	jle	.L878
	cmpl	$6, (%r8)
	jne	.L878
	movq	8(%r8), %r12
	movslq	16(%r12), %rcx
	testl	%ecx, %ecx
	jle	.L941
	movq	8(%r12), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L884
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L882:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L942
.L884:
	cmpl	$148, (%rdx)
	jne	.L882
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L889
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L887:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L886
.L889:
	cmpl	$148, (%rax)
	jne	.L887
	vmovdqu	16(%rax), %xmm4
	leaq	64(%rsp), %rbp
	vmovdqa	%xmm4, 48(%rsp)
.L939:
	leaq	32(%rsp), %rbx
	leaq	48(%rsp), %rsi
	movq	%r8, 32(%rsp)
	movq	%rbp, %rcx
	movq	%r9, 40(%rsp)
	movq	%rbx, %r8
	movq	%rsi, %rdx
	movl	$31, %r9d
	call	vyne_binop
	movslq	16(%r12), %rcx
	vmovdqu	64(%rsp), %xmm6
	testl	%ecx, %ecx
	jle	.L890
	movq	8(%r12), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L893
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L891:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L943
.L893:
	cmpl	$150, (%rdx)
	jne	.L891
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L898
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L896:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L895
.L898:
	cmpl	$150, (%rax)
	jne	.L896
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L897:
	movq	%rdx, 56(%rsp)
	movq	%rbp, %rcx
	movq	%rsi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbx, %r8
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	movq	72(%rsp), %rdx
	movq	%rbp, %rcx
	movq	%rbx, %r8
	movq	64(%rsp), %rax
	movl	$29, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	movq	%rdx, 40(%rsp)
	movq	%rsi, %rdx
	movq	%rax, 32(%rsp)
	call	vyne_binop
	movslq	16(%r12), %rcx
	testl	%ecx, %ecx
	jle	.L944
	movq	8(%r12), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L901
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L899:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L945
.L901:
	cmpl	$148, (%rdx)
	jne	.L899
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L906
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L904:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L903
.L906:
	cmpl	$148, (%rax)
	jne	.L904
	vmovdqu	16(%rax), %xmm5
	vmovdqa	%xmm5, 48(%rsp)
.L940:
	movq	%r8, 32(%rsp)
	movq	%rbp, %rcx
	movq	%rbx, %r8
	movq	%rsi, %rdx
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	call	vyne_binop
	movslq	16(%r12), %rcx
	vmovdqu	64(%rsp), %xmm6
	testl	%ecx, %ecx
	jle	.L907
	movq	8(%r12), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L910
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L908:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L946
.L910:
	cmpl	$150, (%rdx)
	jne	.L908
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L914
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L913:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L912
.L914:
	cmpl	$150, (%rax)
	jne	.L913
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L881
	.p2align 4,,10
	.p2align 3
.L878:
	leaq	64(%rsp), %rbp
	leaq	32(%rsp), %rbx
	movl	$31, %r9d
	movq	$0, 48(%rsp)
	leaq	48(%rsp), %rsi
	movq	%rbx, %r8
	movq	%rbp, %rcx
	movq	$0, 56(%rsp)
	movq	$0, 32(%rsp)
	movq	%rsi, %rdx
	movq	$0, 40(%rsp)
	call	vyne_binop
	movq	%rbx, %r8
	movq	%rsi, %rdx
	movq	%rbp, %rcx
	movl	$31, %r9d
	vmovdqu	64(%rsp), %xmm6
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_binop
	movq	72(%rsp), %rdx
	movq	%rbx, %r8
	movq	%rbp, %rcx
	movq	64(%rsp), %rax
	movl	$29, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	movq	%rdx, 40(%rsp)
	movq	%rsi, %rdx
	movq	%rax, 32(%rsp)
	call	vyne_binop
	movq	%rbx, %r8
	movq	%rsi, %rdx
	movq	%rbp, %rcx
	movq	$0, 48(%rsp)
	movl	$31, %r9d
	movq	$0, 56(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm6
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	xorl	%r9d, %r9d
	xorl	%edx, %edx
.L881:
	movq	%rdx, 56(%rsp)
	movq	%rbp, %rcx
	movq	%rsi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbx, %r8
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	movq	%rbx, %r8
	movq	%rsi, %rdx
	movq	%rbp, %rcx
	vmovdqu	64(%rsp), %xmm2
	movl	$29, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop
	cmpl	$2, 64(%rsp)
	vmovsd	72(%rsp), %xmm0
	jne	.L916
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	72(%rsp), %xmm0, %xmm0
.L916:
	vxorpd	%xmm1, %xmm1, %xmm1
	vucomisd	%xmm0, %xmm1
	ja	.L936
	vsqrtsd	%xmm0, %xmm0, %xmm3
	vmovq	%xmm3, %rax
.L919:
	movq	%rax, 8(%rdi)
	movq	%rdi, %rax
	movq	$1, (%rdi)
	vmovaps	80(%rsp), %xmm6
	addq	$96, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	ret
.L907:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L912:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L881
.L941:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L886:
	movq	$0, 48(%rsp)
	leaq	64(%rsp), %rbp
	movq	$0, 56(%rsp)
	jmp	.L939
.L890:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L895:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L897
.L944:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L903:
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	jmp	.L940
	.p2align 4,,10
	.p2align 3
.L945:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L906
	.p2align 4,,10
	.p2align 3
.L946:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L914
	.p2align 4,,10
	.p2align 3
.L942:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L889
	.p2align 4,,10
	.p2align 3
.L943:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L898
.L936:
	call	sqrt
	vmovq	%xmm0, %rax
	jmp	.L919
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_row_at
	.def	fn_vlin_Types_Matrix_row_at;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_row_at
fn_vlin_Types_Matrix_row_at:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 288(%rsp)
	jle	.L985
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %rbp
	je	.L990
	movq	16(%r8), %rdi
	movq	%rdi, 72(%rsp)
	movq	24(%r8), %rdi
	movq	%rdi, 56(%rsp)
.L952:
	cmpl	$6, %eax
	jne	.L985
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L985
	movq	8(%rbp), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L958
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L955:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L963
.L958:
	cmpl	$109, (%rdx)
	jne	.L955
	cmpl	$2, 16(%rdx)
	jne	.L963
	cmpl	$109, (%rax)
	je	.L991
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L959:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L985
	cmpl	$109, (%rax)
	jne	.L959
.L991:
	movq	24(%rax), %rsi
	jmp	.L960
	.p2align 4,,10
	.p2align 3
.L985:
	leaq	160(%rsp), %rcx
	call	vyne_array_create.constprop.0
	movq	168(%rsp), %rax
	movq	160(%rsp), %rdx
	movq	%rax, 64(%rsp)
.L951:
	movq	288(%rsp), %rax
	movq	64(%rsp), %rdi
	movq	%rdx, (%rax)
	movq	%rdi, 8(%rax)
	addq	$216, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L962:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L985
.L963:
	cmpl	$109, (%rax)
	jne	.L962
	vcvttsd2siq	24(%rax), %rsi
.L960:
	leaq	160(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 48(%rsp)
	call	vyne_array_create.constprop.0
	movq	168(%rsp), %rax
	testq	%rsi, %rsi
	movq	160(%rsp), %rdx
	movq	%rax, 64(%rsp)
	jle	.L951
	movl	72(%rsp), %eax
	leaq	176(%rsp), %rdi
	movl	%edx, 84(%rsp)
	xorl	%ebx, %ebx
	movq	%rdx, 120(%rsp)
	movl	%eax, 80(%rsp)
	movq	56(%rsp), %rax
	movq	%rdi, 88(%rsp)
	imulq	%rsi, %rax
	movq	%rax, 96(%rsp)
	.p2align 4,,10
	.p2align 3
.L975:
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L976
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L968
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L967:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L976
.L968:
	cmpl	$116, (%rax)
	jne	.L967
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L966:
	movq	88(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$2, 80(%rsp)
	movq	72(%rsp), %r10
	movl	$2, %r8d
	jne	.L969
	movq	176(%rsp), %rdi
	movq	96(%rsp), %rcx
.L970:
	addq	%rbx, %rcx
.L988:
	salq	$3, %rcx
	movq	48(%rsp), %r8
	movl	$1, %eax
	addq	$1, %rbx
	movq	(%rdi,%rcx), %rdx
	movl	84(%rsp), %ecx
	movq	%rax, 160(%rsp)
	movq	%rdx, 168(%rsp)
	movq	64(%rsp), %rdx
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rsi
	jne	.L975
	movq	120(%rsp), %rdx
	jmp	.L951
.L990:
	movq	$0, 72(%rsp)
	movq	$0, 56(%rsp)
	jmp	.L952
	.p2align 4,,10
	.p2align 3
.L976:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L966
	.p2align 4,,10
	.p2align 3
.L969:
	movl	80(%rsp), %edx
	movq	%r10, %rax
	movq	48(%rsp), %rcx
	movabsq	$-4294967296, %rdi
	andq	%rdi, %rax
	movq	56(%rsp), %rdi
	movq	%r8, 128(%rsp)
	movl	$31, %r9d
	orq	%rdx, %rax
	leaq	128(%rsp), %r8
	leaq	144(%rsp), %rdx
	movq	%rsi, 136(%rsp)
	movq	%rax, 144(%rsp)
	movq	%rdi, 152(%rsp)
	movq	%rdx, 104(%rsp)
	movq	%r8, 112(%rsp)
	call	vyne_binop_slow
	movl	160(%rsp), %edx
	movq	112(%rsp), %r8
	movabsq	$-4294967296, %rax
	andq	160(%rsp), %rax
	movq	168(%rsp), %rcx
	movq	$2, 32(%rsp)
	orq	%rdx, %rax
	cmpl	$2, %edx
	movq	32(%rsp), %r10
	movq	176(%rsp), %rdi
	je	.L970
	movq	%rcx, 152(%rsp)
	movq	104(%rsp), %rdx
	movl	$29, %r9d
	movq	48(%rsp), %rcx
	movq	%rax, 144(%rsp)
	movq	%r10, 128(%rsp)
	movq	%rbx, 136(%rsp)
	call	vyne_binop_slow
	cmpl	$2, 160(%rsp)
	movq	168(%rsp), %rcx
	je	.L988
	vcvttsd2siq	168(%rsp), %rcx
	jmp	.L988
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_col_at
	.def	fn_vlin_Types_Matrix_col_at;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_col_at
fn_vlin_Types_Matrix_col_at:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 288(%rsp)
	jle	.L996
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %rdi
	je	.L994
	movq	16(%r8), %rsi
	movq	24(%r8), %rbp
	movq	%rsi, 72(%rsp)
.L995:
	cmpl	$6, %eax
	jne	.L996
	movslq	16(%rdi), %rax
	testl	%eax, %eax
	jle	.L996
	movq	8(%rdi), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L1000
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L997:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1039
.L1000:
	cmpl	$107, (%rcx)
	jne	.L997
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L998
.L1039:
	movq	%rdx, %rcx
	jmp	.L1004
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1003:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1040
.L1004:
	cmpl	$107, (%rcx)
	jne	.L1003
	vcvttsd2siq	24(%rcx), %rsi
	movq	%rsi, 80(%rsp)
	jmp	.L1002
	.p2align 4,,10
	.p2align 3
.L996:
	leaq	160(%rsp), %rcx
	call	vyne_array_create.constprop.0
	movq	160(%rsp), %rdx
	movq	168(%rsp), %rcx
.L1014:
	movq	288(%rsp), %rax
	movq	%rdx, (%rax)
	movq	%rcx, 8(%rax)
	addq	$216, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1001:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L1040
.L998:
	cmpl	$107, (%r8)
	jne	.L1001
	movq	24(%r8), %rsi
	movq	%rsi, 80(%rsp)
	jmp	.L1002
.L994:
	movq	$0, 72(%rsp)
	xorl	%ebp, %ebp
	jmp	.L995
.L1040:
	movq	$0, 80(%rsp)
.L1002:
	movq	%rdx, %rcx
	jmp	.L1008
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1005:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1013
.L1008:
	cmpl	$109, (%rcx)
	jne	.L1005
	cmpl	$2, 16(%rcx)
	jne	.L1013
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1006:
	cmpl	$109, (%rdx)
	je	.L1043
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L1006
.L1041:
	movq	$0, 104(%rsp)
.L1010:
	leaq	160(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 40(%rsp)
	call	vyne_array_create.constprop.0
	cmpq	$0, 80(%rsp)
	movq	160(%rsp), %rdx
	movq	168(%rsp), %rcx
	jle	.L1014
	movl	72(%rsp), %eax
	movl	%edx, 92(%rsp)
	xorl	%ebx, %ebx
	xorl	%esi, %esi
	movq	%rdx, 120(%rsp)
	movl	%eax, 88(%rsp)
	leaq	176(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	%rcx, 64(%rsp)
	.p2align 4,,10
	.p2align 3
.L1024:
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L1026
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1019
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1018:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L1026
.L1019:
	cmpl	$116, (%rax)
	jne	.L1018
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L1017:
	movq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	72(%rsp), %rax
	cmpl	$2, 88(%rsp)
	movq	%rbp, 56(%rsp)
	movq	176(%rsp), %r10
	movl	$2, %r8d
	movq	%rax, 48(%rsp)
	jne	.L1020
	leaq	0(%rbp,%rbx), %rax
.L1042:
	salq	$3, %rax
	movq	40(%rsp), %r8
	movl	92(%rsp), %ecx
	movl	$1, %r12d
	movq	(%r10,%rax), %rdx
	addq	$1, %rsi
	movq	%r12, 160(%rsp)
	movq	%rdx, 168(%rsp)
	movq	64(%rsp), %rdx
	call	vyne_array_push.isra.0
	addq	104(%rsp), %rbx
	cmpq	80(%rsp), %rsi
	jne	.L1024
	movq	120(%rsp), %rdx
	movq	64(%rsp), %rcx
	jmp	.L1014
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1011:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1041
.L1013:
	cmpl	$109, (%rdx)
	jne	.L1011
	vcvttsd2siq	24(%rdx), %rax
	movq	%rax, 104(%rsp)
	jmp	.L1010
	.p2align 4,,10
	.p2align 3
.L1026:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1017
	.p2align 4,,10
	.p2align 3
.L1020:
	movq	48(%rsp), %rax
	movl	88(%rsp), %edx
	movabsq	$-4294967296, %rcx
	movq	%r8, 144(%rsp)
	movl	$29, %r9d
	leaq	128(%rsp), %r8
	movq	%r10, 112(%rsp)
	andq	%rcx, %rax
	movq	40(%rsp), %rcx
	movq	%rbx, 152(%rsp)
	orq	%rdx, %rax
	leaq	144(%rsp), %rdx
	movq	%rbp, 136(%rsp)
	movq	%rax, 128(%rsp)
	call	vyne_binop_slow
	cmpl	$2, 160(%rsp)
	movq	112(%rsp), %r10
	movq	168(%rsp), %rax
	je	.L1042
	vcvttsd2siq	168(%rsp), %rax
	jmp	.L1042
.L1043:
	movq	24(%rdx), %rax
	movq	%rax, 104(%rsp)
	jmp	.L1010
	.seh_endproc
	.p2align 4
	.def	fn_vcolors_paint.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	fn_vcolors_paint.constprop.0
fn_vcolors_paint.constprop.0:
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	movq	(%rdx), %r9
	movq	8(%rdx), %r8
	movq	24(%rdx), %rax
	movq	%rcx, %r10
	movq	16(%rdx), %rcx
	cmpl	$2, %ecx
	jne	.L1045
	cmpl	$2, %r9d
	jne	.L1046
	movl	$2, %ecx
	addq	%rax, %r8
	movabsq	$-4294967296, %r9
	vmovdqa	v_RESET(%rip), %xmm2
	andq	%r9, %rcx
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1047:
	cmpl	$2, %r9d
	jne	.L1049
	addq	%r8, %rcx
	movl	$2, %eax
.L1050:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%r10)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%r10)
	movq	%r10, %rax
	addq	$88, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L1045:
	cmpl	$1, %r9d
	jne	.L1046
	cmpl	$1, %ecx
	jne	.L1046
	vmovq	%rax, %xmm1
	vmovq	%r8, %xmm3
	vmovdqa	v_RESET(%rip), %xmm2
	movl	v_RESET(%rip), %r9d
	vaddsd	%xmm3, %xmm1, %xmm0
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %eax
	movl	$1, %r11d
	vmovq	%xmm0, %r8
.L1048:
	cmpl	$1, %r9d
	jne	.L1049
	cmpl	$1, %r11d
	jne	.L1049
	vmovq	%rcx, %xmm5
	movl	$1, %eax
	vaddsd	%xmm5, %xmm0, %xmm4
	vmovq	%xmm4, %rcx
	jmp	.L1050
	.p2align 4,,10
	.p2align 3
.L1046:
	movq	%rcx, 48(%rsp)
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r9, 32(%rsp)
	movl	$29, %r9d
	movq	%r8, 40(%rsp)
	leaq	32(%rsp), %r8
	movq	%r10, 96(%rsp)
	movq	%rax, 56(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	vmovdqa	v_RESET(%rip), %xmm2
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	96(%rsp), %r10
	movq	%rdx, %r11
	je	.L1047
	jmp	.L1048
	.p2align 4,,10
	.p2align 3
.L1049:
	movq	%r8, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movl	$29, %r9d
	leaq	32(%rsp), %r8
	movq	%r10, 96(%rsp)
	movq	%rax, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movq	96(%rsp), %r10
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1050
	.seh_endproc
	.p2align 4
	.def	fn_vcolors_red.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	fn_vcolors_red.constprop.0
fn_vcolors_red.constprop.0:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vmovdqu	(%rdx), %xmm6
	movq	%rcx, %rbx
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_red(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_size
	.def	fn_vlin_Types_Matrix_size;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_size
fn_vlin_Types_Matrix_size:
	pushq	%r12
	.seh_pushreg	%r12
	subq	$80, %rsp
	.seh_stackalloc	80
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r10
	jle	.L1088
	cmpl	$6, (%r8)
	jne	.L1088
	movq	8(%r8), %rax
	movslq	16(%rax), %rcx
	testl	%ecx, %ecx
	jle	.L1088
	movq	8(%rax), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L1071
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1069:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L1092
.L1071:
	cmpl	$109, (%rdx)
	jne	.L1069
	movq	16(%rdx), %r9
	movq	24(%rdx), %rdx
	jmp	.L1077
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1074:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L1068
.L1077:
	cmpl	$107, (%rax)
	jne	.L1074
	movq	16(%rax), %r11
	movq	24(%rax), %rcx
	movl	%r9d, %r8d
	cmpl	$2, %r11d
	movq	%r11, %r12
	movq	%rcx, %rax
	jne	.L1093
	cmpl	$2, %r9d
	jne	.L1078
	imulq	%rdx, %rcx
	movl	$2, %r11d
.L1079:
	movl	%r8d, %edx
	movq	%r11, %rax
	movq	%rcx, 8(%r10)
	movabsq	$-4294967296, %r8
	andq	%r8, %rax
	orq	%rdx, %rax
	movq	%rax, (%r10)
	movq	%r10, %rax
	addq	$80, %rsp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L1088:
	xorl	%r9d, %r9d
	xorl	%edx, %edx
.L1068:
	xorl	%r12d, %r12d
	xorl	%eax, %eax
.L1078:
	movq	%r9, 32(%rsp)
	leaq	64(%rsp), %rcx
	leaq	32(%rsp), %r8
	movl	$31, %r9d
	movq	%rdx, 40(%rsp)
	leaq	48(%rsp), %rdx
	movq	%r10, 96(%rsp)
	movq	%r12, 48(%rsp)
	movq	%rax, 56(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %r11
	movq	72(%rsp), %r12
	movq	96(%rsp), %r10
	movl	%r11d, %r8d
	movq	%r12, %rcx
	jmp	.L1079
	.p2align 4,,10
	.p2align 3
.L1092:
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	jmp	.L1077
.L1093:
	cmpl	$1, %r11d
	jne	.L1078
	cmpl	$1, %r9d
	jne	.L1078
	vmovq	%rcx, %xmm1
	vmovq	%rdx, %xmm2
	movl	$1, %r11d
	vmulsd	%xmm2, %xmm1, %xmm0
	vmovq	%xmm0, %rcx
	jmp	.L1079
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_is_square
	.def	fn_vlin_Types_Matrix_is_square;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_is_square
fn_vlin_Types_Matrix_is_square:
	pushq	%r12
	.seh_pushreg	%r12
	subq	$80, %rsp
	.seh_stackalloc	80
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r10
	jle	.L1118
	cmpl	$6, (%r8)
	jne	.L1118
	movq	8(%r8), %rax
	movslq	16(%rax), %rcx
	testl	%ecx, %ecx
	jle	.L1118
	movq	8(%rax), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L1101
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1099:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L1122
.L1101:
	cmpl	$109, (%rdx)
	jne	.L1099
	movq	16(%rdx), %r8
	movq	24(%rdx), %rdx
	jmp	.L1107
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1104:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L1098
.L1107:
	cmpl	$107, (%rax)
	jne	.L1104
	movq	16(%rax), %rcx
	movq	24(%rax), %rax
	cmpl	$2, %ecx
	movq	%rcx, %r12
	movq	%rax, %r11
	jne	.L1123
	cmpl	$2, %r8d
	jne	.L1108
	xorl	%r8d, %r8d
	cmpq	%rdx, %rax
	movl	$5, %r11d
	movl	$5, %ecx
	sete	%r8b
.L1109:
	movl	%ecx, %edx
	movq	%r11, %rax
	movq	%r8, 8(%r10)
	movabsq	$-4294967296, %rcx
	andq	%rcx, %rax
	orq	%rdx, %rax
	movq	%rax, (%r10)
	movq	%r10, %rax
	addq	$80, %rsp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L1118:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L1098:
	xorl	%r12d, %r12d
	xorl	%r11d, %r11d
.L1108:
	movq	%r8, 32(%rsp)
	leaq	64(%rsp), %rcx
	leaq	32(%rsp), %r8
	movl	$43, %r9d
	movq	%rdx, 40(%rsp)
	leaq	48(%rsp), %rdx
	movq	%r10, 96(%rsp)
	movq	%r12, 48(%rsp)
	movq	%r11, 56(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %r11
	movq	72(%rsp), %r12
	movq	96(%rsp), %r10
	movl	%r11d, %ecx
	movq	%r12, %r8
	jmp	.L1109
	.p2align 4,,10
	.p2align 3
.L1122:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1107
.L1123:
	cmpl	$1, %ecx
	jne	.L1108
	cmpl	$1, %r8d
	jne	.L1108
	vmovq	%rax, %xmm0
	vmovq	%rdx, %xmm1
	xorl	%r8d, %r8d
	movl	$0, %eax
	vucomisd	%xmm1, %xmm0
	movl	$5, %r11d
	movl	$5, %ecx
	setnp	%r8b
	cmovne	%rax, %r8
	jmp	.L1109
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_get
	.def	fn_vlin_Types_Matrix_get;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_get
fn_vlin_Types_Matrix_get:
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$144, %rsp
	.seh_stackalloc	144
	vmovaps	%xmm6, 128(%rsp)
	.seh_savexmm	%xmm6, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1125
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %r9
	je	.L1157
	cmpl	$2, %edx
	movq	16(%r8), %rsi
	movq	24(%r8), %rdi
	je	.L1130
	vmovdqu	32(%r8), %xmm6
.L1131:
	cmpl	$6, %eax
	jne	.L1132
	movslq	16(%r9), %rdx
	testl	%edx, %edx
	jle	.L1134
	movq	8(%r9), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1137
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1135:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L1134
.L1137:
	cmpl	$116, (%rax)
	jne	.L1135
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	leaq	96(%rsp), %rcx
	movq	%r9, 32(%rsp)
	call	vyne_value_to_array_f64.isra.0
	movq	32(%rsp), %r9
.L1136:
	movslq	16(%r9), %rdx
	testl	%edx, %edx
	jle	.L1138
	movq	8(%r9), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1142
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1139:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L1138
.L1142:
	cmpl	$109, (%rax)
	jne	.L1139
	movq	16(%rax), %rcx
	movq	24(%rax), %rax
	cmpl	$2, %esi
	movq	%rsi, %r10
	movq	%rdi, %r9
	movq	%rcx, %r8
	movq	%rax, %rdx
	jne	.L1158
	cmpl	$2, %ecx
	jne	.L1128
	imulq	%rdi, %rax
	leaq	80(%rsp), %rcx
	leaq	48(%rsp), %r8
	leaq	64(%rsp), %rsi
	movq	%rax, %rdx
	movl	$2, %eax
.L1143:
	movq	%rdx, 72(%rsp)
	movl	$29, %r9d
	movq	%rsi, %rdx
	movq	%rax, 64(%rsp)
	vmovdqa	%xmm6, 48(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rax
	movq	96(%rsp), %rdx
	je	.L1156
	vmovq	%rax, %xmm0
	vcvttsd2siq	%xmm0, %rax
.L1156:
	salq	$3, %rax
	movq	$1, (%rbx)
	movq	(%rdx,%rax), %rax
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	vmovaps	128(%rsp), %xmm6
	addq	$144, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	ret
	.p2align 4,,10
	.p2align 3
.L1157:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L1130:
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.L1131
	.p2align 4,,10
	.p2align 3
.L1132:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	%rsi, %r10
	movq	%rdi, %r9
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L1128:
	leaq	64(%rsp), %rsi
	leaq	80(%rsp), %rcx
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%r8, 48(%rsp)
	leaq	48(%rsp), %r8
	movq	%rdx, 56(%rsp)
	movq	%rsi, %rdx
	movq	%r8, 40(%rsp)
	movq	%rcx, 32(%rsp)
	movq	%r10, 64(%rsp)
	call	vyne_binop_slow
	movq	80(%rsp), %rax
	movq	88(%rsp), %rdx
	movq	40(%rsp), %r8
	movq	32(%rsp), %rcx
	jmp	.L1143
	.p2align 4,,10
	.p2align 3
.L1125:
	xorl	%r8d, %r8d
	leaq	96(%rsp), %rcx
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%edx, %edx
	call	vyne_value_to_array_f64.isra.0
	xorl	%r10d, %r10d
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1128
	.p2align 4,,10
	.p2align 3
.L1134:
	leaq	96(%rsp), %rcx
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	movq	%r9, 32(%rsp)
	call	vyne_value_to_array_f64.isra.0
	movq	32(%rsp), %r9
	jmp	.L1136
	.p2align 4,,10
	.p2align 3
.L1138:
	movq	%rsi, %r10
	movq	%rdi, %r9
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1128
.L1158:
	cmpl	$1, %esi
	jne	.L1128
	cmpl	$1, %ecx
	jne	.L1128
	vmovq	%rdi, %xmm2
	vmovq	%rax, %xmm3
	leaq	80(%rsp), %rcx
	movl	$1, %eax
	vmulsd	%xmm3, %xmm2, %xmm1
	leaq	48(%rsp), %r8
	leaq	64(%rsp), %rsi
	vmovq	%xmm1, %rdi
	movq	%rdi, %rdx
	jmp	.L1143
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_paint
	.def	fn_vcolors_paint;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_paint
fn_vcolors_paint:
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r10
	jle	.L1160
	cmpl	$1, %edx
	movq	(%r8), %rcx
	movq	8(%r8), %r9
	je	.L1162
	movq	16(%r8), %rdx
	movq	24(%r8), %rax
	cmpl	$2, %edx
	movq	%rdx, %r11
	movq	%rax, %r8
	jne	.L1183
	cmpl	$2, %ecx
	jne	.L1165
	leaq	(%rax,%r9), %r8
	movl	$2, %ecx
	movabsq	$-4294967296, %r9
	vmovdqa	v_RESET(%rip), %xmm2
	andq	%r9, %rcx
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1166:
	cmpl	$2, %r9d
	jne	.L1168
	addq	%r8, %rcx
	movl	$2, %eax
.L1169:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%r10)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%r10)
	movq	%r10, %rax
	addq	$88, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L1160:
	xorl	%ecx, %ecx
	xorl	%r9d, %r9d
.L1162:
	xorl	%r11d, %r11d
	xorl	%r8d, %r8d
.L1165:
	movq	%r8, 56(%rsp)
	leaq	48(%rsp), %rdx
	leaq	32(%rsp), %r8
	movq	%rcx, 32(%rsp)
	leaq	64(%rsp), %rcx
	movq	%r9, 40(%rsp)
	movl	$29, %r9d
	movq	%r10, 96(%rsp)
	movq	%r11, 48(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	vmovdqa	v_RESET(%rip), %xmm2
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	96(%rsp), %r10
	movq	%rdx, %r11
	je	.L1166
	.p2align 4,,10
	.p2align 3
.L1167:
	cmpl	$1, %r9d
	jne	.L1168
	cmpl	$1, %r11d
	jne	.L1168
	vmovq	%rcx, %xmm5
	movl	$1, %eax
	vaddsd	%xmm5, %xmm0, %xmm4
	vmovq	%xmm4, %rcx
	jmp	.L1169
	.p2align 4,,10
	.p2align 3
.L1183:
	cmpl	$1, %ecx
	jne	.L1165
	cmpl	$1, %edx
	jne	.L1165
	vmovq	%rax, %xmm1
	vmovq	%r9, %xmm3
	vmovdqa	v_RESET(%rip), %xmm2
	movl	v_RESET(%rip), %r9d
	vaddsd	%xmm3, %xmm1, %xmm0
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %eax
	movl	$1, %r11d
	vmovq	%xmm0, %r8
	jmp	.L1167
	.p2align 4,,10
	.p2align 3
.L1168:
	movq	%r8, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movl	$29, %r9d
	leaq	32(%rsp), %r8
	movq	%r10, 96(%rsp)
	movq	%rax, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movq	96(%rsp), %r10
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1169
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_black
	.def	fn_vcolors_black;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_black
fn_vcolors_black:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1186
	vmovdqu	(%r8), %xmm6
.L1186:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_black(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_red
	.def	fn_vcolors_red;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_red
fn_vcolors_red:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1189
	vmovdqu	(%r8), %xmm6
.L1189:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_red(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_green
	.def	fn_vcolors_green;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_green
fn_vcolors_green:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1192
	vmovdqu	(%r8), %xmm6
.L1192:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_green(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_yellow
	.def	fn_vcolors_yellow;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_yellow
fn_vcolors_yellow:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1195
	vmovdqu	(%r8), %xmm6
.L1195:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_yellow(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_blue
	.def	fn_vcolors_blue;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_blue
fn_vcolors_blue:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1198
	vmovdqu	(%r8), %xmm6
.L1198:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_blue(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_magenta
	.def	fn_vcolors_magenta;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_magenta
fn_vcolors_magenta:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1201
	vmovdqu	(%r8), %xmm6
.L1201:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_magenta(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_cyan
	.def	fn_vcolors_cyan;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_cyan
fn_vcolors_cyan:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1204
	vmovdqu	(%r8), %xmm6
.L1204:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_cyan(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_white
	.def	fn_vcolors_white;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_white
fn_vcolors_white:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1207
	vmovdqu	(%r8), %xmm6
.L1207:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_white(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_gray
	.def	fn_vcolors_gray;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_gray
fn_vcolors_gray:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1210
	vmovdqu	(%r8), %xmm6
.L1210:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Palette_gray(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldBlack
	.def	fn_vcolors_boldBlack;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldBlack
fn_vcolors_boldBlack:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1213
	vmovdqu	(%r8), %xmm6
.L1213:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_black(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldRed
	.def	fn_vcolors_boldRed;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldRed
fn_vcolors_boldRed:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1216
	vmovdqu	(%r8), %xmm6
.L1216:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_red(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldGreen
	.def	fn_vcolors_boldGreen;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldGreen
fn_vcolors_boldGreen:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1219
	vmovdqu	(%r8), %xmm6
.L1219:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_green(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldYellow
	.def	fn_vcolors_boldYellow;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldYellow
fn_vcolors_boldYellow:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1222
	vmovdqu	(%r8), %xmm6
.L1222:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_yellow(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldBlue
	.def	fn_vcolors_boldBlue;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldBlue
fn_vcolors_boldBlue:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1225
	vmovdqu	(%r8), %xmm6
.L1225:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_blue(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldMagenta
	.def	fn_vcolors_boldMagenta;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldMagenta
fn_vcolors_boldMagenta:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1228
	vmovdqu	(%r8), %xmm6
.L1228:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_magenta(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldCyan
	.def	fn_vcolors_boldCyan;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldCyan
fn_vcolors_boldCyan:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1231
	vmovdqu	(%r8), %xmm6
.L1231:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_cyan(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_boldWhite
	.def	fn_vcolors_boldWhite;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_boldWhite
fn_vcolors_boldWhite:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1234
	vmovdqu	(%r8), %xmm6
.L1234:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_Bright_white(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onBlack
	.def	fn_vcolors_onBlack;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onBlack
fn_vcolors_onBlack:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1237
	vmovdqu	(%r8), %xmm6
.L1237:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_black(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onRed
	.def	fn_vcolors_onRed;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onRed
fn_vcolors_onRed:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1240
	vmovdqu	(%r8), %xmm6
.L1240:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_red(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onGreen
	.def	fn_vcolors_onGreen;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onGreen
fn_vcolors_onGreen:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1243
	vmovdqu	(%r8), %xmm6
.L1243:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_green(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onYellow
	.def	fn_vcolors_onYellow;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onYellow
fn_vcolors_onYellow:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1246
	vmovdqu	(%r8), %xmm6
.L1246:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_yellow(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onBlue
	.def	fn_vcolors_onBlue;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onBlue
fn_vcolors_onBlue:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1249
	vmovdqu	(%r8), %xmm6
.L1249:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_blue(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onMagenta
	.def	fn_vcolors_onMagenta;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onMagenta
fn_vcolors_onMagenta:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1252
	vmovdqu	(%r8), %xmm6
.L1252:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_magenta(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onCyan
	.def	fn_vcolors_onCyan;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onCyan
fn_vcolors_onCyan:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1255
	vmovdqu	(%r8), %xmm6
.L1255:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_cyan(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_onWhite
	.def	fn_vcolors_onWhite;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_onWhite
fn_vcolors_onWhite:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1258
	vmovdqu	(%r8), %xmm6
.L1258:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BG_white(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_bold
	.def	fn_vcolors_bold;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_bold
fn_vcolors_bold:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1261
	vmovdqu	(%r8), %xmm6
.L1261:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BOLD(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_dim
	.def	fn_vcolors_dim;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_dim
fn_vcolors_dim:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1264
	vmovdqu	(%r8), %xmm6
.L1264:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_DIM(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_italic
	.def	fn_vcolors_italic;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_italic
fn_vcolors_italic:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1267
	vmovdqu	(%r8), %xmm6
.L1267:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_ITALIC(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_underline
	.def	fn_vcolors_underline;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_underline
fn_vcolors_underline:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1270
	vmovdqu	(%r8), %xmm6
.L1270:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_UNDER(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_blink
	.def	fn_vcolors_blink;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_blink
fn_vcolors_blink:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1273
	vmovdqu	(%r8), %xmm6
.L1273:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_BLINK(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_reverse
	.def	fn_vcolors_reverse;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_reverse
fn_vcolors_reverse:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1276
	vmovdqu	(%r8), %xmm6
.L1276:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_REVERSE(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_hidden
	.def	fn_vcolors_hidden;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_hidden
fn_vcolors_hidden:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1279
	vmovdqu	(%r8), %xmm6
.L1279:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_HIDDEN(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_strikethrough
	.def	fn_vcolors_strikethrough;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_strikethrough
fn_vcolors_strikethrough:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1282
	vmovdqu	(%r8), %xmm6
.L1282:
	call	arena_alloc.constprop.1
	leaq	32(%rsp), %rcx
	vmovdqu	%xmm6, (%rax)
	vmovdqa	v_STRIKE(%rip), %xmm0
	movq	%rax, %rdx
	vmovdqu	%xmm0, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	vmovdqu	32(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC49:
	.ascii "\342\234\224 \0"
	.text
	.p2align 4
	.globl	fn_vcolors_success
	.def	fn_vcolors_success;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_success
fn_vcolors_success:
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
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1284
	movq	v_Bright_green(%rip), %rax
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movq	8+v_Bright_green(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	(%r8), %r13
	movq	8(%r8), %r12
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	movl	$29, %r9d
	movq	%rbp, %r8
	leaq	.LC49(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	movq	%r13, %r8
	movq	%r12, %rcx
	movq	72(%rsp), %rax
	cmpl	$2, %edx
	movl	%edx, %r9d
	jne	.L1305
	cmpl	$2, %r13d
	jne	.L1287
	movl	$2, %ecx
	leaq	(%rax,%r12), %r8
	movabsq	$-4294967296, %r9
	movq	v_RESET(%rip), %r10
	andq	%r9, %rcx
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1288:
	cmpl	$2, %r9d
	jne	.L1290
	addq	%r8, %rcx
	movl	$2, %eax
.L1291:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%rbx)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L1284:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movl	$29, %r9d
	movq	v_Bright_green(%rip), %rax
	movq	8+v_Bright_green(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	%rbp, %r8
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	leaq	.LC49(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	movq	72(%rsp), %rax
.L1287:
	movq	%rdx, 48(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbp, %r8
	movq	%rcx, 40(%rsp)
	movq	%rsi, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	%rdx, %r12
	je	.L1288
	.p2align 4,,10
	.p2align 3
.L1289:
	cmpl	$1, %r12d
	jne	.L1290
	cmpl	$1, %r9d
	jne	.L1290
	vmovq	%rcx, %xmm4
	movl	$1, %eax
	vaddsd	%xmm4, %xmm0, %xmm3
	vmovq	%xmm3, %rcx
	jmp	.L1291
	.p2align 4,,10
	.p2align 3
.L1290:
	movq	%r8, 56(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	movq	%rbp, %r8
	movq	%rax, 48(%rsp)
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1291
.L1305:
	subl	$1, %r13d
	jne	.L1287
	subl	$1, %r9d
	jne	.L1287
	vmovq	%rax, %xmm1
	vmovq	%r12, %xmm2
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	vaddsd	%xmm2, %xmm1, %xmm0
	movl	$1, %eax
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %r12d
	vmovq	%xmm0, %r8
	jmp	.L1289
	.seh_endproc
	.section .rdata,"dr"
.LC50:
	.ascii "\342\234\230 \0"
	.text
	.p2align 4
	.globl	fn_vcolors_error
	.def	fn_vcolors_error;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_error
fn_vcolors_error:
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
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1307
	movq	v_Bright_red(%rip), %rax
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movq	8+v_Bright_red(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	(%r8), %r13
	movq	8(%r8), %r12
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	movl	$29, %r9d
	movq	%rbp, %r8
	leaq	.LC50(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	movq	%r13, %r8
	movq	%r12, %rcx
	movq	72(%rsp), %rax
	cmpl	$2, %edx
	movl	%edx, %r9d
	jne	.L1328
	cmpl	$2, %r13d
	jne	.L1310
	movl	$2, %ecx
	leaq	(%rax,%r12), %r8
	movabsq	$-4294967296, %r9
	movq	v_RESET(%rip), %r10
	andq	%r9, %rcx
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1311:
	cmpl	$2, %r9d
	jne	.L1313
	addq	%r8, %rcx
	movl	$2, %eax
.L1314:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%rbx)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L1307:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movl	$29, %r9d
	movq	v_Bright_red(%rip), %rax
	movq	8+v_Bright_red(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	%rbp, %r8
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	leaq	.LC50(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	movq	72(%rsp), %rax
.L1310:
	movq	%rdx, 48(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbp, %r8
	movq	%rcx, 40(%rsp)
	movq	%rsi, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	%rdx, %r12
	je	.L1311
	.p2align 4,,10
	.p2align 3
.L1312:
	cmpl	$1, %r12d
	jne	.L1313
	cmpl	$1, %r9d
	jne	.L1313
	vmovq	%rcx, %xmm4
	movl	$1, %eax
	vaddsd	%xmm4, %xmm0, %xmm3
	vmovq	%xmm3, %rcx
	jmp	.L1314
	.p2align 4,,10
	.p2align 3
.L1313:
	movq	%r8, 56(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	movq	%rbp, %r8
	movq	%rax, 48(%rsp)
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1314
.L1328:
	subl	$1, %r13d
	jne	.L1310
	subl	$1, %r9d
	jne	.L1310
	vmovq	%rax, %xmm1
	vmovq	%r12, %xmm2
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	vaddsd	%xmm2, %xmm1, %xmm0
	movl	$1, %eax
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %r12d
	vmovq	%xmm0, %r8
	jmp	.L1312
	.seh_endproc
	.section .rdata,"dr"
.LC51:
	.ascii "\342\232\240 \0"
	.text
	.p2align 4
	.globl	fn_vcolors_warning
	.def	fn_vcolors_warning;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_warning
fn_vcolors_warning:
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
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1330
	movq	v_Bright_yellow(%rip), %rax
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movq	8+v_Bright_yellow(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	(%r8), %r13
	movq	8(%r8), %r12
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	movl	$29, %r9d
	movq	%rbp, %r8
	leaq	.LC51(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	movq	%r13, %r8
	movq	%r12, %rcx
	movq	72(%rsp), %rax
	cmpl	$2, %edx
	movl	%edx, %r9d
	jne	.L1351
	cmpl	$2, %r13d
	jne	.L1333
	movl	$2, %ecx
	leaq	(%rax,%r12), %r8
	movabsq	$-4294967296, %r9
	movq	v_RESET(%rip), %r10
	andq	%r9, %rcx
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1334:
	cmpl	$2, %r9d
	jne	.L1336
	addq	%r8, %rcx
	movl	$2, %eax
.L1337:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%rbx)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L1330:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movl	$29, %r9d
	movq	v_Bright_yellow(%rip), %rax
	movq	8+v_Bright_yellow(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	%rbp, %r8
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	leaq	.LC51(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	movq	72(%rsp), %rax
.L1333:
	movq	%rdx, 48(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbp, %r8
	movq	%rcx, 40(%rsp)
	movq	%rsi, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	%rdx, %r12
	je	.L1334
	.p2align 4,,10
	.p2align 3
.L1335:
	cmpl	$1, %r12d
	jne	.L1336
	cmpl	$1, %r9d
	jne	.L1336
	vmovq	%rcx, %xmm4
	movl	$1, %eax
	vaddsd	%xmm4, %xmm0, %xmm3
	vmovq	%xmm3, %rcx
	jmp	.L1337
	.p2align 4,,10
	.p2align 3
.L1336:
	movq	%r8, 56(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	movq	%rbp, %r8
	movq	%rax, 48(%rsp)
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1337
.L1351:
	subl	$1, %r13d
	jne	.L1333
	subl	$1, %r9d
	jne	.L1333
	vmovq	%rax, %xmm1
	vmovq	%r12, %xmm2
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	vaddsd	%xmm2, %xmm1, %xmm0
	movl	$1, %eax
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %r12d
	vmovq	%xmm0, %r8
	jmp	.L1335
	.seh_endproc
	.section .rdata,"dr"
.LC52:
	.ascii "\342\204\271 \0"
	.text
	.p2align 4
	.globl	fn_vcolors_info
	.def	fn_vcolors_info;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_info
fn_vcolors_info:
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
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L1353
	movq	v_Bright_blue(%rip), %rax
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movq	8+v_Bright_blue(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	(%r8), %r13
	movq	8(%r8), %r12
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	movl	$29, %r9d
	movq	%rbp, %r8
	leaq	.LC52(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	movq	%r13, %r8
	movq	%r12, %rcx
	movq	72(%rsp), %rax
	cmpl	$2, %edx
	movl	%edx, %r9d
	jne	.L1374
	cmpl	$2, %r13d
	jne	.L1356
	movl	$2, %ecx
	leaq	(%rax,%r12), %r8
	movabsq	$-4294967296, %r9
	movq	v_RESET(%rip), %r10
	andq	%r9, %rcx
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1357:
	cmpl	$2, %r9d
	jne	.L1359
	addq	%r8, %rcx
	movl	$2, %eax
.L1360:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%rbx)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L1353:
	leaq	64(%rsp), %rsi
	leaq	32(%rsp), %rbp
	movl	$29, %r9d
	movq	v_Bright_blue(%rip), %rax
	movq	8+v_Bright_blue(%rip), %rdx
	leaq	48(%rsp), %rdi
	movq	%rbp, %r8
	movq	%rsi, %rcx
	movq	%rax, 48(%rsp)
	leaq	.LC52(%rip), %rax
	movq	%rdx, 56(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 40(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rdx
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	movq	72(%rsp), %rax
.L1356:
	movq	%rdx, 48(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%r8, 32(%rsp)
	movq	%rbp, %r8
	movq	%rcx, 40(%rsp)
	movq	%rsi, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	%rdx, %r12
	je	.L1357
	.p2align 4,,10
	.p2align 3
.L1358:
	cmpl	$1, %r12d
	jne	.L1359
	cmpl	$1, %r9d
	jne	.L1359
	vmovq	%rcx, %xmm4
	movl	$1, %eax
	vaddsd	%xmm4, %xmm0, %xmm3
	vmovq	%xmm3, %rcx
	jmp	.L1360
	.p2align 4,,10
	.p2align 3
.L1359:
	movq	%r8, 56(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	movq	%rbp, %r8
	movq	%rax, 48(%rsp)
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1360
.L1374:
	subl	$1, %r13d
	jne	.L1356
	subl	$1, %r9d
	jne	.L1356
	vmovq	%rax, %xmm1
	vmovq	%r12, %xmm2
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	vaddsd	%xmm2, %xmm1, %xmm0
	movl	$1, %eax
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %r12d
	vmovq	%xmm0, %r8
	jmp	.L1358
	.seh_endproc
	.p2align 4
	.globl	fn_vcolors_hint
	.def	fn_vcolors_hint;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_hint
fn_vcolors_hint:
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r10
	jle	.L1376
	movl	v_Palette_gray(%rip), %ecx
	movq	(%r8), %rdx
	movq	8(%r8), %r8
	vmovdqa	v_Palette_gray(%rip), %xmm0
	cmpl	$2, %ecx
	movq	8+v_Palette_gray(%rip), %rax
	movq	%rdx, %r11
	movq	%r8, %r9
	jne	.L1397
	cmpl	$2, %edx
	jne	.L1379
	movl	$2, %ecx
	addq	%rax, %r8
	movabsq	$-4294967296, %r9
	vmovdqa	v_RESET(%rip), %xmm2
	andq	%r9, %rcx
	movl	v_RESET(%rip), %r9d
	orq	$2, %rcx
	movq	%rcx, %rax
	movq	8+v_RESET(%rip), %rcx
.L1380:
	cmpl	$2, %r9d
	jne	.L1382
	addq	%r8, %rcx
	movl	$2, %eax
.L1383:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%r10)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%r10)
	movq	%r10, %rax
	addq	$88, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L1376:
	vmovdqa	v_Palette_gray(%rip), %xmm0
	xorl	%r11d, %r11d
	xorl	%r9d, %r9d
.L1379:
	movq	%r9, 40(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movl	$29, %r9d
	leaq	32(%rsp), %r8
	movq	%r10, 96(%rsp)
	movq	%r11, 32(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	call	vyne_binop_slow
	movl	64(%rsp), %edx
	movabsq	$-4294967296, %rax
	andq	64(%rsp), %rax
	vmovsd	72(%rsp), %xmm0
	movq	72(%rsp), %r8
	orq	%rdx, %rax
	cmpl	$2, %edx
	vmovdqa	v_RESET(%rip), %xmm2
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	movq	96(%rsp), %r10
	movq	%rdx, %r11
	je	.L1380
	.p2align 4,,10
	.p2align 3
.L1381:
	cmpl	$1, %r9d
	jne	.L1382
	cmpl	$1, %r11d
	jne	.L1382
	vmovq	%rcx, %xmm5
	movl	$1, %eax
	vaddsd	%xmm5, %xmm0, %xmm4
	vmovq	%xmm4, %rcx
	jmp	.L1383
	.p2align 4,,10
	.p2align 3
.L1382:
	movq	%r8, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movl	$29, %r9d
	leaq	32(%rsp), %r8
	movq	%r10, 96(%rsp)
	movq	%rax, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movq	96(%rsp), %r10
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1383
.L1397:
	subl	$1, %edx
	jne	.L1379
	subl	$1, %ecx
	jne	.L1379
	vmovq	%rax, %xmm1
	vmovq	%r8, %xmm3
	vmovdqa	v_RESET(%rip), %xmm2
	movl	v_RESET(%rip), %r9d
	vaddsd	%xmm3, %xmm1, %xmm0
	movq	8+v_RESET(%rip), %rcx
	movl	$1, %eax
	movl	$1, %r11d
	vmovq	%xmm0, %r8
	jmp	.L1381
	.seh_endproc
	.section .rdata,"dr"
.LC53:
	.ascii "\33[38;2;\0"
.LC54:
	.ascii ";\0"
.LC55:
	.ascii "m\0"
	.text
	.p2align 4
	.globl	fn_vcolors_rgb
	.def	fn_vcolors_rgb;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_rgb
fn_vcolors_rgb:
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$144, %rsp
	.seh_stackalloc	144
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	vmovaps	%xmm8, 96(%rsp)
	.seh_savexmm	%xmm8, 96
	vmovaps	%xmm10, 112(%rsp)
	.seh_savexmm	%xmm10, 112
	vmovaps	%xmm12, 128(%rsp)
	.seh_savexmm	%xmm12, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L1399
	cmpl	$1, %edx
	movq	(%r8), %r10
	movq	8(%r8), %r11
	je	.L1408
	cmpl	$2, %edx
	vmovdqu	16(%r8), %xmm6
	je	.L1402
	cmpl	$3, %edx
	vmovdqu	32(%r8), %xmm8
	je	.L1405
	vmovdqu	48(%r8), %xmm10
.L1406:
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r10, 48(%rsp)
	movq	%r11, 56(%rsp)
	leaq	.LC54(%rip), %r14
	call	vyne_to_string
	vmovdqu	64(%rsp), %xmm0
	leaq	32(%rsp), %r8
	leaq	.LC53(%rip), %rax
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	movq	%rax, 56(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	movq	$3, 48(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm1
	leaq	32(%rsp), %r8
	movl	$29, %r9d
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r14, 40(%rsp)
	vmovdqa	%xmm1, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	vmovdqu	64(%rsp), %xmm12
	vmovdqa	%xmm6, 48(%rsp)
	call	vyne_to_string
	vmovdqu	64(%rsp), %xmm2
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	vmovdqa	%xmm12, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm3
	leaq	32(%rsp), %r8
	movl	$29, %r9d
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r14, 40(%rsp)
	vmovdqa	%xmm3, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	vmovdqu	64(%rsp), %xmm6
	vmovdqa	%xmm8, 48(%rsp)
	call	vyne_to_string
	vmovdqu	64(%rsp), %xmm4
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	vmovdqa	%xmm4, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm5
	leaq	32(%rsp), %r8
	leaq	.LC55(%rip), %rax
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	movq	%rax, 40(%rsp)
	vmovdqa	%xmm5, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm0
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	vmovdqa	%xmm10, 32(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm1
	movl	$29, %r9d
	vmovdqa	v_RESET(%rip), %xmm2
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	vmovdqa	%xmm1, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm3
	movq	%rbp, %rax
	vmovdqu	%xmm3, 0(%rbp)
	vmovaps	80(%rsp), %xmm6
	vmovaps	96(%rsp), %xmm8
	vmovaps	128(%rsp), %xmm12
	vmovaps	112(%rsp), %xmm10
	addq	$144, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L1408:
	vpxor	%xmm6, %xmm6, %xmm6
.L1402:
	vpxor	%xmm8, %xmm8, %xmm8
.L1405:
	vpxor	%xmm10, %xmm10, %xmm10
	jmp	.L1406
	.p2align 4,,10
	.p2align 3
.L1399:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.L1402
	.seh_endproc
	.section .rdata,"dr"
.LC56:
	.ascii "\33[48;2;\0"
	.text
	.p2align 4
	.globl	fn_vcolors_bgRgb
	.def	fn_vcolors_bgRgb;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_bgRgb
fn_vcolors_bgRgb:
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$144, %rsp
	.seh_stackalloc	144
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	vmovaps	%xmm8, 96(%rsp)
	.seh_savexmm	%xmm8, 96
	vmovaps	%xmm10, 112(%rsp)
	.seh_savexmm	%xmm10, 112
	vmovaps	%xmm12, 128(%rsp)
	.seh_savexmm	%xmm12, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L1410
	cmpl	$1, %edx
	movq	(%r8), %r10
	movq	8(%r8), %r11
	je	.L1419
	cmpl	$2, %edx
	vmovdqu	16(%r8), %xmm6
	je	.L1413
	cmpl	$3, %edx
	vmovdqu	32(%r8), %xmm8
	je	.L1416
	vmovdqu	48(%r8), %xmm10
.L1417:
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r10, 48(%rsp)
	movq	%r11, 56(%rsp)
	leaq	.LC54(%rip), %r14
	call	vyne_to_string
	vmovdqu	64(%rsp), %xmm0
	leaq	32(%rsp), %r8
	leaq	.LC56(%rip), %rax
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	movq	%rax, 56(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	movq	$3, 48(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm1
	leaq	32(%rsp), %r8
	movl	$29, %r9d
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r14, 40(%rsp)
	vmovdqa	%xmm1, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	vmovdqu	64(%rsp), %xmm12
	vmovdqa	%xmm6, 48(%rsp)
	call	vyne_to_string
	vmovdqu	64(%rsp), %xmm2
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	vmovdqa	%xmm12, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm3
	leaq	32(%rsp), %r8
	movl	$29, %r9d
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movq	%r14, 40(%rsp)
	vmovdqa	%xmm3, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	vmovdqu	64(%rsp), %xmm6
	vmovdqa	%xmm8, 48(%rsp)
	call	vyne_to_string
	vmovdqu	64(%rsp), %xmm4
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	vmovdqa	%xmm6, 48(%rsp)
	vmovdqa	%xmm4, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm5
	leaq	32(%rsp), %r8
	leaq	.LC55(%rip), %rax
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	movq	%rax, 40(%rsp)
	vmovdqa	%xmm5, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm0
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	movl	$29, %r9d
	vmovdqa	%xmm10, 32(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm1
	movl	$29, %r9d
	vmovdqa	v_RESET(%rip), %xmm2
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %rcx
	vmovdqa	%xmm1, 48(%rsp)
	vmovdqa	%xmm2, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm3
	movq	%rbp, %rax
	vmovdqu	%xmm3, 0(%rbp)
	vmovaps	80(%rsp), %xmm6
	vmovaps	96(%rsp), %xmm8
	vmovaps	128(%rsp), %xmm12
	vmovaps	112(%rsp), %xmm10
	addq	$144, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L1419:
	vpxor	%xmm6, %xmm6, %xmm6
.L1413:
	vpxor	%xmm8, %xmm8, %xmm8
.L1416:
	vpxor	%xmm10, %xmm10, %xmm10
	jmp	.L1417
	.p2align 4,,10
	.p2align 3
.L1410:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.L1413
	.seh_endproc
	.section .rdata,"dr"
.LC58:
	.ascii "\0"
	.text
	.p2align 4
	.globl	fn_vcolors_rainbow
	.def	fn_vcolors_rainbow;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_rainbow
fn_vcolors_rainbow:
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
	subq	$168, %rsp
	.seh_stackalloc	168
	vmovaps	%xmm6, 144(%rsp)
	.seh_savexmm	%xmm6, 144
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 240(%rsp)
	jle	.L1421
	movq	(%r8), %rax
	movq	8(%r8), %r12
	movq	%rax, 80(%rsp)
	movl	%eax, %ebp
	movq	%r12, 88(%rsp)
.L1422:
	call	arena_alloc.constprop.2
	movl	$96, %ecx
	leaq	128(%rsp), %rbx
	subl	$3, %ebp
	movq	%rax, %rsi
	call	arena_alloc
	movq	.LC57(%rip), %rdx
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%r9d, %r9d
	movq	%rax, (%rsi)
	movl	$2, %r8d
	movl	$4, %ecx
	movq	%rdx, 8(%rsi)
	vmovdqa	v_Palette_red(%rip), %xmm1
	movq	%rsi, %rdx
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	%ymm0, 64(%rax)
	movl	$4, %eax
	movq	%rbx, 32(%rsp)
	movq	%rax, 64(%rsp)
	movq	%rsi, 72(%rsp)
	movl	$2, %esi
	vmovdqa	%xmm1, 128(%rsp)
	call	vyne_array_set.isra.0
	movq	%rbx, 32(%rsp)
	movl	$4, %ecx
	vmovdqa	v_Palette_yellow(%rip), %xmm1
	movl	$1, %r9d
	movl	$2, %r8d
	vmovdqa	%xmm1, 128(%rsp)
	call	vyne_array_set.isra.0
	movq	%rbx, 32(%rsp)
	movl	$4, %ecx
	vmovdqa	v_Palette_green(%rip), %xmm2
	movl	$2, %r9d
	movl	$2, %r8d
	vmovdqa	%xmm2, 128(%rsp)
	call	vyne_array_set.isra.0
	movq	%rbx, 32(%rsp)
	movl	$4, %ecx
	vmovdqa	v_Palette_cyan(%rip), %xmm3
	movl	$3, %r9d
	movl	$2, %r8d
	vmovdqa	%xmm3, 128(%rsp)
	call	vyne_array_set.isra.0
	movq	%rbx, 32(%rsp)
	movl	$4, %ecx
	vmovdqa	v_Palette_blue(%rip), %xmm4
	movl	$4, %r9d
	movl	$2, %r8d
	vmovdqa	%xmm4, 128(%rsp)
	call	vyne_array_set.isra.0
	movq	%rbx, 32(%rsp)
	movl	$4, %ecx
	vmovdqa	v_Palette_magenta(%rip), %xmm5
	movl	$5, %r9d
	movl	$2, %r8d
	vmovdqa	%xmm5, 128(%rsp)
	call	vyne_array_set.isra.0
	cmpl	$9, %ebp
	movl	$3, %r9d
	leaq	.LC58(%rip), %rdx
	ja	.L1438
	leaq	.L1425(%rip), %rcx
	movslq	(%rcx,%rbp,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L1425:
	.long	.L1430-.L1425
	.long	.L1427-.L1425
	.long	.L1438-.L1425
	.long	.L1428-.L1425
	.long	.L1438-.L1425
	.long	.L1438-.L1425
	.long	.L1438-.L1425
	.long	.L1427-.L1425
	.long	.L1424-.L1425
	.long	.L1424-.L1425
	.text
	.p2align 4,,10
	.p2align 3
.L1427:
	movslq	8(%r12), %rbp
	vzeroupper
.L1423:
	movq	%rdx, 48(%rsp)
	movq	%rbp, %r10
	movl	$2, %r12d
	xorl	%eax, %eax
	movl	$2, %r11d
	movq	%r9, %rbp
.L1436:
	movabsq	$-4294967296, %rdi
	movl	%r11d, %edx
	andq	%rdi, %rsi
	movq	%rax, %rdi
	orq	%rdx, %rsi
	cmpl	$2, %r11d
	jne	.L1431
	cmpq	%rax, %r10
	jle	.L1444
.L1432:
	movq	80(%rsp), %rax
	leaq	96(%rsp), %r8
	leaq	112(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%r10, 56(%rsp)
	movq	%rax, 112(%rsp)
	movq	88(%rsp), %rax
	movq	%rsi, 96(%rsp)
	movq	%rax, 120(%rsp)
	movq	%rdi, 104(%rsp)
	call	vyne_index_get
	movl	$36, %r9d
	leaq	96(%rsp), %r8
	movq	%rbx, %rcx
	leaq	112(%rsp), %rdx
	movq	%rsi, 112(%rsp)
	vmovdqu	128(%rsp), %xmm6
	movq	%rdi, 120(%rsp)
	movq	$2, 96(%rsp)
	movq	$6, 104(%rsp)
	call	vyne_binop
	vmovdqa	64(%rsp), %xmm2
	leaq	96(%rsp), %r8
	movq	%rbx, %rcx
	vmovdqu	128(%rsp), %xmm3
	leaq	112(%rsp), %rdx
	vmovdqa	%xmm2, 112(%rsp)
	vmovdqa	%xmm3, 96(%rsp)
	call	vyne_index_get
	movq	48(%rsp), %rax
	movl	$29, %r9d
	movq	%rbx, %rcx
	leaq	96(%rsp), %r8
	leaq	112(%rsp), %rdx
	movq	%rbp, 112(%rsp)
	vmovdqu	128(%rsp), %xmm4
	movq	%rax, 120(%rsp)
	vmovdqa	%xmm4, 96(%rsp)
	call	vyne_binop
	movl	$29, %r9d
	leaq	96(%rsp), %r8
	movq	%rbx, %rcx
	vmovdqu	128(%rsp), %xmm5
	leaq	112(%rsp), %rdx
	vmovdqa	%xmm6, 96(%rsp)
	vmovdqa	%xmm5, 112(%rsp)
	call	vyne_binop
	movq	136(%rsp), %rax
	movl	$29, %r9d
	movq	%rbx, %rcx
	leaq	96(%rsp), %r8
	leaq	112(%rsp), %rdx
	movq	%rsi, 112(%rsp)
	movq	128(%rsp), %rbp
	movq	%rax, 48(%rsp)
	movq	%rdi, 120(%rsp)
	movq	$2, 96(%rsp)
	movq	$1, 104(%rsp)
	call	vyne_binop
	movq	128(%rsp), %rsi
	movq	56(%rsp), %r10
	movl	128(%rsp), %r11d
	movq	136(%rsp), %rax
	jmp	.L1436
	.p2align 4,,10
	.p2align 3
.L1424:
	movq	8(%r12), %rbp
	vzeroupper
	jmp	.L1423
	.p2align 4,,10
	.p2align 3
.L1438:
	movl	$8, %ebp
	vzeroupper
	jmp	.L1423
	.p2align 4,,10
	.p2align 3
.L1421:
	movq	$0, 80(%rsp)
	xorl	%r12d, %r12d
	xorl	%ebp, %ebp
	movq	$0, 88(%rsp)
	jmp	.L1422
	.p2align 4,,10
	.p2align 3
.L1431:
	movl	$46, %r9d
	leaq	96(%rsp), %r8
	leaq	112(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rax, 120(%rsp)
	movq	%r10, 56(%rsp)
	movq	%rsi, 112(%rsp)
	movq	%r12, 96(%rsp)
	movq	%r10, 104(%rsp)
	call	vyne_binop_slow
	movq	128(%rsp), %rax
	vmovq	136(%rsp), %xmm0
	testl	%eax, %eax
	je	.L1444
	cmpl	$5, %eax
	movq	56(%rsp), %r10
	je	.L1439
	cmpl	$2, %eax
	je	.L1439
	cmpl	$1, %eax
	jne	.L1432
	vxorpd	%xmm1, %xmm1, %xmm1
	vucomisd	%xmm1, %xmm0
	jp	.L1432
	jne	.L1432
.L1444:
	movq	48(%rsp), %rdx
	vmovdqa	v_RESET(%rip), %xmm6
	leaq	96(%rsp), %r8
	movq	%rbx, %rcx
	movl	$29, %r9d
	movq	%rbp, 112(%rsp)
	movq	%rdx, 120(%rsp)
	leaq	112(%rsp), %rdx
	vmovdqa	%xmm6, 96(%rsp)
	call	vyne_binop
	movq	240(%rsp), %rax
	vmovdqu	128(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	vmovaps	144(%rsp), %xmm6
	addq	$168, %rsp
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
.L1430:
	movq	%rdx, 56(%rsp)
	movq	%r12, %rcx
	movq	%r9, 48(%rsp)
	vzeroupper
	call	strlen
	movq	48(%rsp), %r9
	movq	56(%rsp), %rdx
	movq	%rax, %rbp
	jmp	.L1423
	.p2align 4,,10
	.p2align 3
.L1428:
	movslq	16(%r12), %rbp
	vzeroupper
	jmp	.L1423
.L1439:
	vmovq	%xmm0, %rax
	testq	%rax, %rax
	jne	.L1432
	jmp	.L1444
	.seh_endproc
	.section .rdata,"dr"
.LC60:
	.ascii "-\0"
.LC61:
	.ascii "+\0"
.LC62:
	.ascii "\12\0"
.LC63:
	.ascii "|\0"
.LC64:
	.ascii "  \0"
	.text
	.p2align 4
	.globl	fn_vcolors_box
	.def	fn_vcolors_box;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_box
fn_vcolors_box:
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
	subq	$168, %rsp
	.seh_stackalloc	168
	vmovaps	%xmm6, 128(%rsp)
	.seh_savexmm	%xmm6, 128
	vmovaps	%xmm8, 144(%rsp)
	.seh_savexmm	%xmm8, 144
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 240(%rsp)
	jle	.L1446
	movq	(%r8), %rax
	movq	8(%r8), %rbx
	movq	%rax, 64(%rsp)
	subl	$3, %eax
	cmpl	$9, %eax
	movq	%rbx, 56(%rsp)
	ja	.L1447
	leaq	.L1449(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L1449:
	.long	.L1454-.L1449
	.long	.L1451-.L1449
	.long	.L1447-.L1449
	.long	.L1452-.L1449
	.long	.L1447-.L1449
	.long	.L1447-.L1449
	.long	.L1447-.L1449
	.long	.L1451-.L1449
	.long	.L1448-.L1449
	.long	.L1448-.L1449
	.text
	.p2align 4,,10
	.p2align 3
.L1451:
	movq	56(%rsp), %rax
	movslq	8(%rax), %rax
	leaq	4(%rax), %r15
.L1455:
	movl	$3, %r14d
	leaq	.LC58(%rip), %r13
	leaq	112(%rsp), %rbx
	xorl	%ebp, %ebp
	movl	$2, %r12d
.L1461:
	leaq	96(%rsp), %rdx
	movl	$46, %r9d
	leaq	80(%rsp), %r8
	movq	$2, 32(%rsp)
	movq	32(%rsp), %rax
	movq	%rbx, %rcx
	movq	%r12, 96(%rsp)
	movq	%rbp, 104(%rsp)
	movq	%rax, 80(%rsp)
	movq	%r15, 88(%rsp)
	call	vyne_binop
	movq	112(%rsp), %rax
	movq	120(%rsp), %rdx
	testl	%eax, %eax
	je	.L1456
	cmpl	$5, %eax
	je	.L1462
	cmpl	$2, %eax
	je	.L1462
	cmpl	$1, %eax
	je	.L1465
.L1459:
	leaq	.LC60(%rip), %rax
	movl	$29, %r9d
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movq	%r14, 96(%rsp)
	movq	%r13, 104(%rsp)
	movq	%rax, 88(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	movl	$29, %r9d
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movq	%r12, 96(%rsp)
	movq	112(%rsp), %r14
	movq	%rbp, 104(%rsp)
	movq	120(%rsp), %r13
	movq	$2, 80(%rsp)
	movq	$1, 88(%rsp)
	call	vyne_binop
	movq	112(%rsp), %r12
	movq	120(%rsp), %rbp
	jmp	.L1461
	.p2align 4,,10
	.p2align 3
.L1448:
	movq	56(%rsp), %rax
	movq	8(%rax), %rax
	movq	%rax, 72(%rsp)
	leaq	4(%rax), %r15
	jmp	.L1455
	.p2align 4,,10
	.p2align 3
.L1446:
	movq	$0, 64(%rsp)
	movq	$0, 56(%rsp)
.L1447:
	movl	$12, %r15d
	jmp	.L1455
	.p2align 4,,10
	.p2align 3
.L1465:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rdx, %xmm6
	vucomisd	%xmm0, %xmm6
	jp	.L1459
	jne	.L1459
.L1456:
	vmovdqa	v_Palette_cyan(%rip), %xmm1
	leaq	.LC61(%rip), %r15
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	$3, 80(%rsp)
	leaq	.LC62(%rip), %rbp
	vmovdqa	%xmm1, 96(%rsp)
	leaq	.LC63(%rip), %r12
	movq	%r15, 88(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm2
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%r13, 88(%rsp)
	vmovdqa	%xmm2, 96(%rsp)
	movq	%r14, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm3
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%r15, 88(%rsp)
	vmovdqa	%xmm3, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm4
	leaq	80(%rsp), %r8
	vmovdqa	v_RESET(%rip), %xmm5
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	vmovdqa	%xmm5, 80(%rsp)
	vmovdqa	%xmm4, 96(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm0
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%rbp, 88(%rsp)
	vmovdqa	%xmm0, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqa	v_Palette_cyan(%rip), %xmm1
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	vmovdqu	112(%rsp), %xmm8
	movq	%r12, 88(%rsp)
	vmovdqa	%xmm1, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm2
	leaq	80(%rsp), %r8
	vmovdqa	v_RESET(%rip), %xmm3
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	vmovdqa	%xmm3, 80(%rsp)
	vmovdqa	%xmm2, 96(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm4
	leaq	80(%rsp), %r8
	leaq	.LC64(%rip), %rax
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	movq	%rax, 88(%rsp)
	vmovdqa	%xmm4, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	movq	64(%rsp), %rcx
	vmovdqu	112(%rsp), %xmm5
	leaq	80(%rsp), %r8
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%rcx, 80(%rsp)
	movq	56(%rsp), %rcx
	vmovdqa	%xmm5, 96(%rsp)
	movq	%rcx, 88(%rsp)
	movq	%rbx, %rcx
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm6
	leaq	80(%rsp), %r8
	leaq	.LC64(%rip), %rax
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	movq	%rax, 88(%rsp)
	vmovdqa	%xmm6, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm0
	leaq	80(%rsp), %r8
	vmovdqa	v_Palette_cyan(%rip), %xmm1
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	vmovdqa	%xmm1, 80(%rsp)
	vmovdqa	%xmm0, 96(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm2
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%r12, 88(%rsp)
	vmovdqa	%xmm2, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm3
	leaq	80(%rsp), %r8
	vmovdqa	v_RESET(%rip), %xmm4
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	vmovdqa	%xmm3, 96(%rsp)
	vmovdqa	%xmm4, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm5
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%rbp, 88(%rsp)
	vmovdqa	%xmm5, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqa	v_Palette_cyan(%rip), %xmm0
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	vmovdqu	112(%rsp), %xmm6
	movq	$3, 80(%rsp)
	vmovdqa	%xmm0, 96(%rsp)
	movq	%r15, 88(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm1
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%r13, 88(%rsp)
	vmovdqa	%xmm1, 96(%rsp)
	movq	%r14, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm2
	leaq	80(%rsp), %r8
	movq	%rbx, %rcx
	leaq	96(%rsp), %rdx
	movl	$29, %r9d
	movq	%r15, 88(%rsp)
	vmovdqa	%xmm2, 96(%rsp)
	movq	$3, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm3
	leaq	80(%rsp), %r8
	vmovdqa	v_RESET(%rip), %xmm4
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	vmovdqa	%xmm3, 96(%rsp)
	vmovdqa	%xmm4, 80(%rsp)
	call	vyne_binop
	leaq	80(%rsp), %r8
	leaq	96(%rsp), %rdx
	movq	%rbx, %rcx
	movl	$29, %r9d
	vmovdqa	%xmm8, 96(%rsp)
	movq	112(%rsp), %r12
	movq	120(%rsp), %r13
	vmovdqa	%xmm6, 80(%rsp)
	call	vyne_binop
	vmovdqu	112(%rsp), %xmm6
	movl	$29, %r9d
	movq	%rbx, %rcx
	leaq	80(%rsp), %r8
	leaq	96(%rsp), %rdx
	movq	%r12, 80(%rsp)
	vmovdqa	%xmm6, 96(%rsp)
	movq	%r13, 88(%rsp)
	call	vyne_binop
	movq	240(%rsp), %rax
	vmovdqu	112(%rsp), %xmm5
	vmovdqu	%xmm5, (%rax)
	vmovaps	128(%rsp), %xmm6
	vmovaps	144(%rsp), %xmm8
	addq	$168, %rsp
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
.L1462:
	testq	%rdx, %rdx
	jne	.L1459
	jmp	.L1456
	.p2align 4,,10
	.p2align 3
.L1452:
	movq	56(%rsp), %rax
	movslq	16(%rax), %rax
	leaq	4(%rax), %r15
	jmp	.L1455
	.p2align 4,,10
	.p2align 3
.L1454:
	movq	56(%rsp), %rcx
	call	strlen
	leaq	4(%rax), %r15
	jmp	.L1455
	.seh_endproc
	.section .rdata,"dr"
.LC65:
	.ascii ">>> \0"
.LC66:
	.ascii " <<<\0"
	.text
	.p2align 4
	.globl	fn_vcolors_banner
	.def	fn_vcolors_banner;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_banner
fn_vcolors_banner:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$104, %rsp
	.seh_stackalloc	104
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L1468
	vmovdqu	(%r8), %xmm6
.L1468:
	movl	v_Bright_cyan(%rip), %eax
	movq	v_Bright_cyan(%rip), %rsi
	movq	8+v_Bright_cyan(%rip), %rdi
	movq	8+v_Bright_cyan(%rip), %rcx
	cmpl	$2, %eax
	movq	v_BOLD(%rip), %r10
	movq	8+v_BOLD(%rip), %r11
	movl	v_BOLD(%rip), %r8d
	movq	8+v_BOLD(%rip), %rdx
	jne	.L1469
	cmpl	$2, %r8d
	jne	.L1470
	addq	%rdx, %rcx
	movl	$2, %eax
	leaq	64(%rsp), %rbx
	leaq	32(%rsp), %rdi
	leaq	48(%rsp), %rsi
.L1471:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 56(%rsp)
	movl	$29, %r9d
	movq	%rbx, %rcx
	movq	$3, 32(%rsp)
	andq	%rdx, %rax
	movq	%rsi, %rdx
	orq	%r8, %rax
	movq	%rdi, %r8
	movq	%rax, 48(%rsp)
	leaq	.LC65(%rip), %rax
	movq	%rax, 40(%rsp)
	call	vyne_binop_slow
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	vmovdqu	64(%rsp), %xmm0
	movl	$29, %r9d
	vmovdqa	%xmm6, 32(%rsp)
	vmovdqa	%xmm0, 48(%rsp)
	call	vyne_binop
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	vmovdqu	64(%rsp), %xmm1
	leaq	.LC66(%rip), %rax
	movl	$29, %r9d
	movq	$3, 32(%rsp)
	movq	%rax, 40(%rsp)
	vmovdqa	%xmm1, 48(%rsp)
	call	vyne_binop
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	vmovdqu	64(%rsp), %xmm2
	vmovdqa	v_RESET(%rip), %xmm3
	movl	$29, %r9d
	vmovdqa	%xmm2, 48(%rsp)
	vmovdqa	%xmm3, 32(%rsp)
	call	vyne_binop
	vmovdqu	64(%rsp), %xmm4
	movq	%rbp, %rax
	vmovdqu	%xmm4, 0(%rbp)
	vmovaps	80(%rsp), %xmm6
	addq	$104, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L1469:
	cmpl	$1, %r8d
	jne	.L1470
	cmpl	$1, %eax
	jne	.L1470
	vmovq	%rcx, %xmm5
	vmovq	%rdx, %xmm0
	movl	$1, %eax
	vaddsd	%xmm0, %xmm5, %xmm5
	leaq	64(%rsp), %rbx
	leaq	32(%rsp), %rdi
	leaq	48(%rsp), %rsi
	vmovq	%xmm5, %rcx
	jmp	.L1471
	.p2align 4,,10
	.p2align 3
.L1470:
	movq	%rsi, 48(%rsp)
	leaq	64(%rsp), %rbx
	leaq	48(%rsp), %rsi
	movl	$29, %r9d
	movq	%rdi, 56(%rsp)
	leaq	32(%rsp), %rdi
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	movq	%rdi, %r8
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movl	%eax, %r8d
	movq	%rdx, %rcx
	jmp	.L1471
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC67:
	.ascii "----------------------------------------\0"
	.text
	.p2align 4
	.globl	fn_vcolors_rule
	.def	fn_vcolors_rule;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vcolors_rule
fn_vcolors_rule:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	vmovdqa	v_Palette_gray(%rip), %xmm0
	leaq	.LC67(%rip), %rax
	movl	$29, %r9d
	leaq	32(%rsp), %rbp
	leaq	48(%rsp), %rdx
	movq	%rcx, %rbx
	movq	%rax, 40(%rsp)
	leaq	64(%rsp), %rcx
	movq	%rbp, %r8
	vmovdqa	%xmm0, 48(%rsp)
	movq	$3, 32(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movq	v_RESET(%rip), %r10
	movq	8+v_RESET(%rip), %r11
	cmpl	$2, %eax
	movl	v_RESET(%rip), %r9d
	movq	8+v_RESET(%rip), %rcx
	jne	.L1479
	cmpl	$2, %r9d
	jne	.L1480
	addq	%rdx, %rcx
	movl	$2, %eax
.L1481:
	movabsq	$-4294967296, %rdx
	movq	%rcx, 8(%rbx)
	andq	%rdx, %rax
	orq	%r9, %rax
	movq	%rax, (%rbx)
	movq	%rbx, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L1479:
	cmpl	$1, %r9d
	jne	.L1480
	cmpl	$1, %eax
	jne	.L1480
	vmovq	%rcx, %xmm3
	vmovq	%rdx, %xmm2
	movl	$1, %eax
	vaddsd	%xmm3, %xmm2, %xmm1
	vmovq	%xmm1, %rcx
	jmp	.L1481
	.p2align 4,,10
	.p2align 3
.L1480:
	movq	%rdx, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movq	%rbp, %r8
	movl	$29, %r9d
	movq	%rax, 48(%rsp)
	movq	%r10, 32(%rsp)
	movq	%r11, 40(%rsp)
	call	vyne_binop_slow
	movq	64(%rsp), %rax
	movq	72(%rsp), %rdx
	movl	%eax, %r9d
	movq	%rdx, %rcx
	jmp	.L1481
	.seh_endproc
	.p2align 4
	.globl	struct_vlin_Types_Matrix
	.def	struct_vlin_Types_Matrix;	.scl	2;	.type	32;	.endef
	.seh_proc	struct_vlin_Types_Matrix
struct_vlin_Types_Matrix:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$88, %rsp
	.seh_stackalloc	88
	vmovaps	%xmm6, 32(%rsp)
	.seh_savexmm	%xmm6, 32
	vmovaps	%xmm8, 48(%rsp)
	.seh_savexmm	%xmm8, 48
	vmovaps	%xmm10, 64(%rsp)
	.seh_savexmm	%xmm10, 64
	.seh_endprologue
	vmovdqu	(%rdx), %xmm10
	vmovdqu	(%r8), %xmm8
	vmovdqu	(%r9), %xmm6
	movq	%rcx, %rsi
	movl	$40, %ecx
	call	arena_alloc
	movl	$96, %ecx
	movq	%rax, %rbx
	leaq	.LC33(%rip), %rax
	movq	%rax, (%rbx)
	movl	$3, 16(%rbx)
	call	arena_alloc
	leaq	.LC34(%rip), %rdx
	movq	%rbx, 8(%rsi)
	leaq	.LC36(%rip), %rcx
	movq	%rax, 8(%rbx)
	movq	$0, 24(%rbx)
	movl	$0, 32(%rbx)
	movq	%rdx, 8(%rax)
	leaq	.LC35(%rip), %rdx
	movl	$107, (%rax)
	movl	$109, 32(%rax)
	movq	%rdx, 40(%rax)
	movl	$116, 64(%rax)
	movq	%rcx, 72(%rax)
	vmovdqu	%xmm10, 16(%rax)
	vmovdqu	%xmm8, 48(%rax)
	vmovdqu	%xmm6, 80(%rax)
	movq	%rsi, %rax
	movl	$6, (%rsi)
	vmovaps	32(%rsp), %xmm6
	vmovaps	48(%rsp), %xmm8
	vmovaps	64(%rsp), %xmm10
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_copy
	.def	fn_vlin_Types_Matrix_copy;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_copy
fn_vlin_Types_Matrix_copy:
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
	subq	$168, %rsp
	.seh_stackalloc	168
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 240(%rsp)
	jle	.L1491
	cmpl	$6, (%r8)
	jne	.L1491
	movq	8(%r8), %rbp
	movslq	16(%rbp), %rax
	testl	%eax, %eax
	jle	.L1491
	movq	8(%rbp), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L1495
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1492:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1535
.L1495:
	cmpl	$107, (%rcx)
	jne	.L1492
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L1493
.L1535:
	movq	%rdx, %rcx
	jmp	.L1499
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1498:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1536
.L1499:
	cmpl	$107, (%rcx)
	jne	.L1498
	vcvttsd2siq	24(%rcx), %rbx
	movq	%rbx, 40(%rsp)
	jmp	.L1497
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1496:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L1536
.L1493:
	cmpl	$107, (%r8)
	jne	.L1496
	movq	24(%r8), %rbx
	movq	%rbx, 40(%rsp)
	jmp	.L1497
	.p2align 4,,10
	.p2align 3
.L1491:
	leaq	112(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	call	vyne_array_create.constprop.0
	movq	112(%rsp), %r9
	movq	120(%rsp), %r12
	movq	$0, 40(%rsp)
	movq	$0, 48(%rsp)
.L1510:
	movq	40(%rsp), %rax
	movq	32(%rsp), %rcx
	movq	%r9, 64(%rsp)
	leaq	96(%rsp), %rdx
	leaq	64(%rsp), %r9
	leaq	80(%rsp), %r8
	movq	$2, 96(%rsp)
	movq	%rax, 104(%rsp)
	movq	48(%rsp), %rax
	movq	$2, 80(%rsp)
	movq	%rax, 88(%rsp)
	movq	%r12, 72(%rsp)
	call	struct_vlin_Types_Matrix
	movq	240(%rsp), %rax
	vmovdqu	112(%rsp), %xmm0
	vmovdqu	%xmm0, (%rax)
	addq	$168, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L1536:
	movq	$0, 40(%rsp)
.L1497:
	movq	%rdx, %rcx
	jmp	.L1503
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1500:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1508
.L1503:
	cmpl	$109, (%rcx)
	jne	.L1500
	cmpl	$2, 16(%rcx)
	jne	.L1508
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1501:
	cmpl	$109, (%rdx)
	je	.L1537
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L1501
.L1531:
	leaq	112(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	call	vyne_array_create.constprop.0
	movq	112(%rsp), %r9
	movq	120(%rsp), %r12
	movq	$0, 48(%rsp)
	jmp	.L1510
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1507:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1531
.L1508:
	cmpl	$109, (%rdx)
	jne	.L1507
	vcvttsd2siq	24(%rdx), %rax
	movq	40(%rsp), %r13
	movq	%rax, 48(%rsp)
	imulq	%rax, %r13
.L1505:
	leaq	112(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	call	vyne_array_create.constprop.0
	testq	%r13, %r13
	movq	112(%rsp), %r9
	movq	120(%rsp), %r12
	jle	.L1510
	movq	%r9, 56(%rsp)
	movl	%r9d, %r15d
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L1516:
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L1519
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1515
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1514:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L1519
.L1515:
	cmpl	$116, (%rax)
	jne	.L1514
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L1513:
	leaq	128(%rsp), %rcx
	movl	$1, %esi
	call	vyne_value_to_array_f64.isra.0
	movq	128(%rsp), %rax
	movq	32(%rsp), %r8
	movl	%r15d, %ecx
	movq	(%rax,%rbx,8), %rdx
	addq	$1, %rbx
	movq	%rsi, 112(%rsp)
	movq	%rdx, 120(%rsp)
	movq	%r12, %rdx
	call	vyne_array_push.isra.0
	cmpq	%r13, %rbx
	jne	.L1516
	movq	56(%rsp), %r9
	jmp	.L1510
	.p2align 4,,10
	.p2align 3
.L1519:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1513
.L1537:
	movq	24(%rdx), %rax
	movq	40(%rsp), %r13
	movq	%rax, 48(%rsp)
	imulq	%rax, %r13
	jmp	.L1505
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_negate
	.def	fn_vlin_Types_Matrix_negate;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_negate
fn_vlin_Types_Matrix_negate:
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
	subq	$184, %rsp
	.seh_stackalloc	184
	vmovaps	%xmm6, 160(%rsp)
	.seh_savexmm	%xmm6, 160
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 256(%rsp)
	jle	.L1540
	cmpl	$6, (%r8)
	jne	.L1540
	movq	8(%r8), %rbp
	movslq	16(%rbp), %rax
	testl	%eax, %eax
	jle	.L1540
	movq	8(%rbp), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L1544
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1541:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1584
.L1544:
	cmpl	$107, (%rcx)
	jne	.L1541
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L1542
.L1584:
	movq	%rdx, %rcx
	jmp	.L1548
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1547:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1585
.L1548:
	cmpl	$107, (%rcx)
	jne	.L1547
	vcvttsd2siq	24(%rcx), %rbx
	movq	%rbx, 40(%rsp)
	jmp	.L1546
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1545:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L1585
.L1542:
	cmpl	$107, (%r8)
	jne	.L1545
	movq	24(%r8), %rbx
	movq	%rbx, 40(%rsp)
	jmp	.L1546
	.p2align 4,,10
	.p2align 3
.L1540:
	leaq	112(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	call	vyne_array_create.constprop.0
	movq	112(%rsp), %r9
	movq	120(%rsp), %r12
	movq	$0, 40(%rsp)
	movq	$0, 48(%rsp)
.L1559:
	movq	40(%rsp), %rax
	movq	32(%rsp), %rcx
	movq	%r9, 64(%rsp)
	leaq	96(%rsp), %rdx
	leaq	64(%rsp), %r9
	leaq	80(%rsp), %r8
	movq	$2, 96(%rsp)
	movq	%rax, 104(%rsp)
	movq	48(%rsp), %rax
	movq	$2, 80(%rsp)
	movq	%rax, 88(%rsp)
	movq	%r12, 72(%rsp)
	call	struct_vlin_Types_Matrix
	movq	256(%rsp), %rax
	vmovdqu	112(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	vmovaps	160(%rsp), %xmm6
	addq	$184, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L1585:
	movq	$0, 40(%rsp)
.L1546:
	movq	%rdx, %rcx
	jmp	.L1552
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1549:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1557
.L1552:
	cmpl	$109, (%rcx)
	jne	.L1549
	cmpl	$2, 16(%rcx)
	jne	.L1557
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1550:
	cmpl	$109, (%rdx)
	je	.L1586
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L1550
.L1580:
	leaq	112(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	call	vyne_array_create.constprop.0
	movq	112(%rsp), %r9
	movq	120(%rsp), %r12
	movq	$0, 48(%rsp)
	jmp	.L1559
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1556:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1580
.L1557:
	cmpl	$109, (%rdx)
	jne	.L1556
	vcvttsd2siq	24(%rdx), %rax
	movq	40(%rsp), %r13
	movq	%rax, 48(%rsp)
	imulq	%rax, %r13
.L1554:
	leaq	112(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 32(%rsp)
	call	vyne_array_create.constprop.0
	testq	%r13, %r13
	movq	112(%rsp), %r9
	movq	120(%rsp), %r12
	jle	.L1559
	movq	%r9, 56(%rsp)
	movl	%r9d, %r15d
	xorl	%ebx, %ebx
	vxorpd	%xmm6, %xmm6, %xmm6
	.p2align 4,,10
	.p2align 3
.L1565:
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L1568
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1564
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1563:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L1568
.L1564:
	cmpl	$116, (%rax)
	jne	.L1563
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L1562:
	leaq	128(%rsp), %rcx
	movl	$1, %esi
	call	vyne_value_to_array_f64.isra.0
	movq	32(%rsp), %r8
	movq	%r12, %rdx
	movl	%r15d, %ecx
	movq	128(%rsp), %rax
	vsubsd	(%rax,%rbx,8), %xmm6, %xmm0
	addq	$1, %rbx
	movq	%rsi, 112(%rsp)
	vmovq	%xmm0, 120(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%r13, %rbx
	jne	.L1565
	movq	56(%rsp), %r9
	jmp	.L1559
	.p2align 4,,10
	.p2align 3
.L1568:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1562
.L1586:
	movq	24(%rdx), %rax
	movq	40(%rsp), %r13
	movq	%rax, 48(%rsp)
	imulq	%rax, %r13
	jmp	.L1554
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_add_scalar
	.def	fn_vlin_Types_Matrix_add_scalar;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_add_scalar
fn_vlin_Types_Matrix_add_scalar:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L1591
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %rdi
	je	.L1589
	movq	16(%r8), %rsi
	movq	24(%r8), %rbp
	movq	%rsi, 40(%rsp)
.L1590:
	cmpl	$6, %eax
	jne	.L1591
	movslq	16(%rdi), %rax
	testl	%eax, %eax
	jle	.L1591
	movq	8(%rdi), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L1595
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1592:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1638
.L1595:
	cmpl	$107, (%rcx)
	jne	.L1592
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L1593
.L1638:
	movq	%rdx, %rcx
	jmp	.L1599
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1598:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1639
.L1599:
	cmpl	$107, (%rcx)
	jne	.L1598
	vcvttsd2siq	24(%rcx), %rsi
	movq	%rsi, 112(%rsp)
	jmp	.L1597
	.p2align 4,,10
	.p2align 3
.L1591:
	leaq	176(%rsp), %rsi
	movq	%rsi, %rcx
	call	vyne_array_create.constprop.0
	movq	176(%rsp), %rax
	movq	$0, 112(%rsp)
	movq	184(%rsp), %r13
	movq	%rax, 104(%rsp)
.L1619:
	movq	$0, 120(%rsp)
.L1640:
	leaq	144(%rsp), %rax
	movq	%rax, 48(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 56(%rsp)
.L1610:
	movq	112(%rsp), %rax
	movq	48(%rsp), %r8
	movq	%rsi, %rcx
	leaq	128(%rsp), %r9
	movq	56(%rsp), %rdx
	movq	%r13, 136(%rsp)
	movq	%rax, 168(%rsp)
	movq	120(%rsp), %rax
	movq	$2, 160(%rsp)
	movq	%rax, 152(%rsp)
	movq	104(%rsp), %rax
	movq	$2, 144(%rsp)
	movq	%rax, 128(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	176(%rsp), %xmm3
	vmovdqu	%xmm3, (%rax)
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1596:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L1639
.L1593:
	cmpl	$107, (%r8)
	jne	.L1596
	movq	24(%r8), %rsi
	movq	%rsi, 112(%rsp)
	jmp	.L1597
.L1589:
	movq	$0, 40(%rsp)
	xorl	%ebp, %ebp
	jmp	.L1590
.L1639:
	movq	$0, 112(%rsp)
.L1597:
	movq	%rdx, %rcx
	jmp	.L1603
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1600:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1608
.L1603:
	cmpl	$109, (%rcx)
	jne	.L1600
	cmpl	$2, 16(%rcx)
	jne	.L1608
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1601:
	cmpl	$109, (%rdx)
	je	.L1642
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L1601
.L1633:
	leaq	176(%rsp), %rsi
	movq	%rsi, %rcx
	call	vyne_array_create.constprop.0
	movq	176(%rsp), %rax
	movq	184(%rsp), %r13
	movq	%rax, 104(%rsp)
	jmp	.L1619
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1607:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1633
.L1608:
	cmpl	$109, (%rdx)
	jne	.L1607
	vcvttsd2siq	24(%rdx), %rax
	movq	112(%rsp), %rsi
	imulq	%rax, %rsi
	movq	%rax, 120(%rsp)
	movq	%rsi, 64(%rsp)
.L1605:
	leaq	176(%rsp), %rsi
	movq	%rsi, %rcx
	call	vyne_array_create.constprop.0
	movq	176(%rsp), %rax
	cmpq	$0, 64(%rsp)
	movq	184(%rsp), %r13
	movq	%rax, 104(%rsp)
	jle	.L1640
	movl	104(%rsp), %eax
	movl	40(%rsp), %r12d
	xorl	%ebx, %ebx
	movl	%eax, 100(%rsp)
	leaq	192(%rsp), %rax
	movq	%rax, 72(%rsp)
	leaq	144(%rsp), %rax
	movq	%rax, 48(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L1618:
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L1621
.L1643:
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1615
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1614:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L1621
.L1615:
	cmpl	$116, (%rax)
	jne	.L1614
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L1613:
	movq	72(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$1, %r12d
	movq	40(%rsp), %r10
	movq	192(%rsp), %rax
	movl	$1, %r8d
	movq	(%rax,%rbx,8), %rcx
	movq	%rcx, %r9
	jne	.L1616
	vmovq	%rcx, %xmm1
	vmovq	%rbp, %xmm2
	movl	100(%rsp), %ecx
	movq	%rsi, %r8
	vaddsd	%xmm2, %xmm1, %xmm0
	movq	%r13, %rdx
	addq	$1, %rbx
	movq	$1, 80(%rsp)
	movq	80(%rsp), %rax
	vmovq	%xmm0, 184(%rsp)
	movq	%rax, 176(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, 64(%rsp)
	je	.L1610
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jg	.L1643
	.p2align 4,,10
	.p2align 3
.L1621:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1613
	.p2align 4,,10
	.p2align 3
.L1616:
	movq	%r10, %rax
	movl	%r12d, %edx
	movabsq	$-4294967296, %rcx
	movq	%r8, 160(%rsp)
	andq	%rcx, %rax
	movq	48(%rsp), %r8
	movq	%r9, 168(%rsp)
	movq	%rsi, %rcx
	orq	%rdx, %rax
	movq	56(%rsp), %rdx
	movl	$29, %r9d
	addq	$1, %rbx
	movq	%rax, 144(%rsp)
	movq	%rbp, 152(%rsp)
	call	vyne_binop_slow
	movl	100(%rsp), %ecx
	movq	%rsi, %r8
	movq	%r13, %rdx
	call	vyne_array_push.isra.0
	cmpq	64(%rsp), %rbx
	jne	.L1618
	jmp	.L1610
.L1642:
	movq	24(%rdx), %rax
	movq	112(%rsp), %rsi
	imulq	%rax, %rsi
	movq	%rax, 120(%rsp)
	movq	%rsi, 64(%rsp)
	jmp	.L1605
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_mul_scalar
	.def	fn_vlin_Types_Matrix_mul_scalar;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_mul_scalar
fn_vlin_Types_Matrix_mul_scalar:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L1648
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %rsi
	je	.L1646
	movq	16(%r8), %r12
	movq	24(%r8), %rdi
.L1647:
	cmpl	$6, %eax
	jne	.L1648
	movslq	16(%rsi), %rax
	testl	%eax, %eax
	jle	.L1648
	movq	8(%rsi), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L1652
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1649:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L1695
.L1652:
	cmpl	$107, (%rcx)
	jne	.L1649
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L1650
.L1695:
	movq	%rdx, %rcx
	jmp	.L1656
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1655:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1696
.L1656:
	cmpl	$107, (%rcx)
	jne	.L1655
	vcvttsd2siq	24(%rcx), %rbx
	movq	%rbx, 112(%rsp)
	jmp	.L1654
	.p2align 4,,10
	.p2align 3
.L1648:
	leaq	176(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_array_create.constprop.0
	movq	176(%rsp), %rax
	movq	$0, 112(%rsp)
	movq	184(%rsp), %rbp
	movq	%rax, 88(%rsp)
.L1676:
	movq	$0, 120(%rsp)
.L1697:
	leaq	144(%rsp), %rax
	movq	%rax, 96(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 104(%rsp)
.L1667:
	movq	112(%rsp), %rax
	movq	96(%rsp), %r8
	leaq	128(%rsp), %r9
	movq	$2, 160(%rsp)
	movq	104(%rsp), %rdx
	movq	56(%rsp), %rcx
	movq	$2, 144(%rsp)
	movq	%rax, 168(%rsp)
	movq	120(%rsp), %rax
	movq	%rbp, 136(%rsp)
	movq	%rax, 152(%rsp)
	movq	88(%rsp), %rax
	movq	%rax, 128(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	176(%rsp), %xmm2
	vmovdqu	%xmm2, (%rax)
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1653:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L1696
.L1650:
	cmpl	$107, (%r8)
	jne	.L1653
	movq	24(%r8), %rbx
	movq	%rbx, 112(%rsp)
	jmp	.L1654
.L1646:
	xorl	%r12d, %r12d
	xorl	%edi, %edi
	jmp	.L1647
.L1696:
	movq	$0, 112(%rsp)
.L1654:
	movq	%rdx, %rcx
	jmp	.L1660
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1657:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1665
.L1660:
	cmpl	$109, (%rcx)
	jne	.L1657
	cmpl	$2, 16(%rcx)
	jne	.L1665
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1658:
	cmpl	$109, (%rdx)
	je	.L1699
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L1658
.L1690:
	leaq	176(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_array_create.constprop.0
	movq	176(%rsp), %rax
	movq	184(%rsp), %rbp
	movq	%rax, 88(%rsp)
	jmp	.L1676
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1664:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1690
.L1665:
	cmpl	$109, (%rdx)
	jne	.L1664
	vcvttsd2siq	24(%rdx), %rax
	movq	112(%rsp), %r13
	movq	%rax, 120(%rsp)
	imulq	%rax, %r13
.L1662:
	leaq	176(%rsp), %rax
	movq	%rax, %rcx
	movq	%rax, 56(%rsp)
	call	vyne_array_create.constprop.0
	movq	176(%rsp), %rax
	testq	%r13, %r13
	movq	184(%rsp), %rbp
	movq	%rax, 88(%rsp)
	jle	.L1697
	movl	88(%rsp), %eax
	movl	%r12d, 80(%rsp)
	movq	%rdi, 64(%rsp)
	xorl	%edi, %edi
	movl	%eax, 84(%rsp)
	leaq	192(%rsp), %rax
	movq	%rax, 72(%rsp)
	leaq	144(%rsp), %rax
	movq	%rax, 96(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 104(%rsp)
.L1675:
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L1678
	.p2align 4,,10
	.p2align 3
.L1700:
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1672
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1671:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L1678
.L1672:
	cmpl	$116, (%rax)
	jne	.L1671
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L1670:
	movq	72(%rsp), %rcx
	movl	$1, %r14d
	call	vyne_value_to_array_f64.isra.0
	movq	192(%rsp), %rax
	cmpl	$1, 80(%rsp)
	vmovsd	(%rax,%rdi,8), %xmm0
	jne	.L1673
	movq	56(%rsp), %r8
	movl	84(%rsp), %ecx
	movq	%rbp, %rdx
	addq	$1, %rdi
	movq	$1, 32(%rsp)
	vmovsd	64(%rsp), %xmm3
	movq	32(%rsp), %rax
	vmulsd	%xmm3, %xmm0, %xmm1
	movq	%rax, 176(%rsp)
	vmovq	%xmm1, 184(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%r13, %rdi
	je	.L1667
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jg	.L1700
	.p2align 4,,10
	.p2align 3
.L1678:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1670
	.p2align 4,,10
	.p2align 3
.L1673:
	movq	64(%rsp), %rbx
	movl	80(%rsp), %edx
	movq	%r12, %rax
	addq	$1, %rdi
	movabsq	$-4294967296, %r8
	movl	$31, %r9d
	vmovq	%xmm0, 168(%rsp)
	andq	%r8, %rax
	movq	%rbx, 152(%rsp)
	movq	56(%rsp), %rbx
	orq	%rdx, %rax
	movq	96(%rsp), %r8
	movq	104(%rsp), %rdx
	movq	%r14, 160(%rsp)
	movq	%rbx, %rcx
	movq	%rax, 144(%rsp)
	call	vyne_binop_slow
	movl	84(%rsp), %ecx
	movq	%rbx, %r8
	movq	%rbp, %rdx
	call	vyne_array_push.isra.0
	cmpq	%rdi, %r13
	jne	.L1675
	jmp	.L1667
.L1699:
	movq	24(%rdx), %rax
	movq	112(%rsp), %r13
	movq	%rax, 120(%rsp)
	imulq	%rax, %r13
	jmp	.L1662
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC68:
	.ascii "Matrix Error: reshape size mismatch\0"
.LC69:
	.ascii "copy\0"
	.text
	.p2align 4
	.globl	fn_vlin_Types_Matrix_reshape
	.def	fn_vlin_Types_Matrix_reshape;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_reshape
fn_vlin_Types_Matrix_reshape:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 192(%rsp)
	.seh_savexmm	%xmm6, 192
	vmovaps	%xmm8, 208(%rsp)
	.seh_savexmm	%xmm8, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L1702
	vmovdqu	(%r8), %xmm1
	cmpl	$1, %edx
	movl	(%r8), %r12d
	movq	8(%r8), %r13
	vmovdqa	%xmm1, 48(%rsp)
	je	.L1763
	cmpl	$2, %edx
	vmovdqu	16(%r8), %xmm8
	je	.L1707
	vmovdqu	32(%r8), %xmm6
.L1708:
	cmpl	$6, %r12d
	jne	.L1742
	movslq	16(%r13), %rax
	testl	%eax, %eax
	jle	.L1742
	movq	8(%r13), %rcx
	salq	$5, %rax
	addq	%rcx, %rax
	movq	%rcx, %rdx
	jmp	.L1712
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1709:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1764
.L1712:
	cmpl	$107, (%rdx)
	jne	.L1709
	cmpl	$2, 16(%rdx)
	movq	%rcx, %rdx
	jne	.L1716
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1710:
	cmpl	$107, (%rdx)
	je	.L1765
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L1710
.L1762:
	xorl	%ebp, %ebp
.L1714:
	movq	%rcx, %rdx
	jmp	.L1720
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1717:
	addq	$32, %rdx
	cmpq	%rdx, %rax
	je	.L1725
.L1720:
	cmpl	$109, (%rdx)
	jne	.L1717
	cmpl	$2, 16(%rdx)
	jne	.L1725
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1718:
	cmpl	$109, (%rcx)
	je	.L1766
	addq	$32, %rcx
	cmpq	%rcx, %rax
	jne	.L1718
	leaq	112(%rsp), %r14
	leaq	128(%rsp), %r15
	xorl	%ebp, %ebp
	movl	$31, %r9d
	leaq	144(%rsp), %rbx
	movq	%r14, %r8
	movq	%r15, %rdx
	vmovdqa	%xmm8, 128(%rsp)
	movq	%rbx, %rcx
	vmovdqa	%xmm6, 112(%rsp)
	movq	%r14, 72(%rsp)
	movq	%r15, 80(%rsp)
	call	vyne_binop
	movq	152(%rsp), %rdx
	movq	%rbx, %rcx
	movq	144(%rsp), %rax
	movl	$44, %r9d
	movq	%r14, %r8
	movq	$2, 112(%rsp)
	movq	%rdx, 136(%rsp)
	movq	%r15, %rdx
	movq	%rax, 128(%rsp)
	movq	$0, 120(%rsp)
	call	vyne_binop
	movq	144(%rsp), %rax
	movq	152(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L1740
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	144(%rsp), %r9
	movq	152(%rsp), %r14
	jmp	.L1738
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1715:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L1762
.L1716:
	cmpl	$107, (%rdx)
	jne	.L1715
	vcvttsd2siq	24(%rdx), %rbp
	jmp	.L1714
.L1763:
	vpxor	%xmm8, %xmm8, %xmm8
.L1707:
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.L1708
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1724:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L1742
.L1725:
	cmpl	$109, (%rcx)
	jne	.L1724
	vcvttsd2siq	24(%rcx), %rax
	imulq	%rax, %rbp
	jmp	.L1722
	.p2align 4,,10
	.p2align 3
.L1702:
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm6, %xmm6, %xmm6
	xorl	%ebp, %ebp
	xorl	%r13d, %r13d
	movq	$0, 48(%rsp)
	xorl	%r12d, %r12d
	movq	$0, 56(%rsp)
.L1722:
	leaq	112(%rsp), %r14
	leaq	128(%rsp), %r15
	movl	$31, %r9d
	vmovdqa	%xmm8, 128(%rsp)
	leaq	144(%rsp), %rbx
	movq	%r14, %r8
	movq	%r15, %rdx
	vmovdqa	%xmm6, 112(%rsp)
	movq	%rbx, %rcx
	movq	%r14, 72(%rsp)
	movq	%r15, 80(%rsp)
	call	vyne_binop
	movq	%rbx, %rcx
	movq	%r14, %r8
	movq	%rbp, 120(%rsp)
	movq	152(%rsp), %rdx
	movl	$44, %r9d
	movq	144(%rsp), %rax
	movq	$2, 112(%rsp)
	movq	%rdx, 136(%rsp)
	movq	%r15, %rdx
	movq	%rax, 128(%rsp)
	call	vyne_binop
	movq	144(%rsp), %rax
	movq	152(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L1726
.L1740:
	cmpl	$5, %edx
	je	.L1746
	cmpl	$2, %edx
	je	.L1746
	cmpl	$1, %edx
	je	.L1767
.L1729:
	call	arena_alloc.constprop.2
	leaq	.LC68(%rip), %rdi
	movq	$3, (%rax)
	movq	(%rax), %rsi
	movq	%rdi, 8(%rax)
	movq	8(%rax), %rdi
	call	arena_alloc.constprop.1
	movq	%rbx, %rcx
	movq	%rsi, (%rax)
	movq	%rax, %rdx
	movq	%rdi, 8(%rax)
	vmovdqa	v_Palette_red(%rip), %xmm3
	vmovdqu	%xmm3, 16(%rax)
	call	fn_vcolors_paint.constprop.0
	movq	152(%rsp), %rdx
	movl	144(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	movq	48(%rsp), %rax
	movl	%r12d, %edx
	movabsq	$-4294967296, %rcx
	movq	%r13, 56(%rsp)
	andq	%rcx, %rax
	orq	%rdx, %rax
	xorl	%edx, %edx
	movq	%rax, 48(%rsp)
	xorl	%eax, %eax
	cmpl	$6, %r12d
	je	.L1768
.L1731:
	movq	304(%rsp), %rdi
	movq	%rdx, 8(%rdi)
	movq	%rax, (%rdi)
	movq	%rdi, %rax
.L1759:
	vmovaps	192(%rsp), %xmm6
	vmovaps	208(%rsp), %xmm8
	addq	$232, %rsp
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
.L1746:
	testq	%rcx, %rcx
	jne	.L1729
.L1726:
	movq	%rbx, %rcx
	xorl	%r15d, %r15d
	call	vyne_array_create.constprop.0
	testq	%rbp, %rbp
	movq	144(%rsp), %r9
	movq	152(%rsp), %r14
	leaq	160(%rsp), %rax
	jle	.L1738
	movl	%r9d, 48(%rsp)
	movq	%r9, 88(%rsp)
	movq	%rax, 64(%rsp)
	.p2align 4,,10
	.p2align 3
.L1737:
	cmpl	$6, %r12d
	jne	.L1745
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L1745
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L1736
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L1735:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L1745
.L1736:
	cmpl	$116, (%rax)
	jne	.L1735
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L1734:
	movq	64(%rsp), %rcx
	movl	$1, %esi
	call	vyne_value_to_array_f64.isra.0
	movq	160(%rsp), %rax
	movl	48(%rsp), %ecx
	movq	%rbx, %r8
	movq	(%rax,%r15,8), %rdx
	addq	$1, %r15
	movq	%rsi, 144(%rsp)
	movq	%rdx, 152(%rsp)
	movq	%r14, %rdx
	call	vyne_array_push.isra.0
	cmpq	%rbp, %r15
	jne	.L1737
	movq	88(%rsp), %r9
.L1738:
	movq	72(%rsp), %r8
	movq	80(%rsp), %rdx
	movq	%r9, 96(%rsp)
	movq	%rbx, %rcx
	leaq	96(%rsp), %r9
	movq	%r14, 104(%rsp)
	vmovdqa	%xmm8, 128(%rsp)
	vmovdqa	%xmm6, 112(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	144(%rsp), %xmm2
	vmovdqu	%xmm2, (%rax)
	jmp	.L1759
	.p2align 4,,10
	.p2align 3
.L1745:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L1734
	.p2align 4,,10
	.p2align 3
.L1742:
	xorl	%ebp, %ebp
	jmp	.L1722
	.p2align 4,,10
	.p2align 3
.L1764:
	movq	%rcx, %rdx
	jmp	.L1716
.L1768:
	call	arena_alloc.constprop.2
	movl	$6, %edx
	movq	%r13, %r8
	movq	%rbx, %rcx
	vmovdqa	48(%rsp), %xmm5
	leaq	.LC69(%rip), %r9
	vmovdqu	%xmm5, (%rax)
	movq	%rax, 40(%rsp)
	movl	$1, 32(%rsp)
	call	vyne_struct_call.isra.0
	movq	144(%rsp), %rax
	movq	152(%rsp), %rdx
	jmp	.L1731
.L1767:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm4
	vucomisd	%xmm0, %xmm4
	jp	.L1729
	jne	.L1729
	jmp	.L1726
	.p2align 4,,10
	.p2align 3
.L1765:
	movq	24(%rdx), %rbp
	jmp	.L1714
.L1766:
	imulq	24(%rcx), %rbp
	jmp	.L1722
	.seh_endproc
	.section .rdata,"dr"
.LC70:
	.ascii "vlin.Types.Vector\0"
.LC71:
	.ascii "x\0"
.LC72:
	.ascii "y\0"
	.text
	.p2align 4
	.globl	struct_vlin_Types_Vector
	.def	struct_vlin_Types_Vector;	.scl	2;	.type	32;	.endef
	.seh_proc	struct_vlin_Types_Vector
struct_vlin_Types_Vector:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	vmovaps	%xmm6, 32(%rsp)
	.seh_savexmm	%xmm6, 32
	vmovaps	%xmm8, 48(%rsp)
	.seh_savexmm	%xmm8, 48
	.seh_endprologue
	vmovdqu	(%rdx), %xmm8
	vmovdqu	(%r8), %xmm6
	movq	%rcx, %rsi
	movl	$40, %ecx
	call	arena_alloc
	movl	$64, %ecx
	movq	%rax, %rbx
	leaq	.LC70(%rip), %rax
	movq	%rax, (%rbx)
	movl	$2, 16(%rbx)
	call	arena_alloc
	leaq	.LC71(%rip), %rdx
	movq	%rbx, 8(%rsi)
	movq	%rax, 8(%rbx)
	movq	$0, 24(%rbx)
	movl	$0, 32(%rbx)
	movq	%rdx, 8(%rax)
	leaq	.LC72(%rip), %rdx
	movl	$148, (%rax)
	movl	$150, 32(%rax)
	movq	%rdx, 40(%rax)
	vmovdqu	%xmm8, 16(%rax)
	vmovdqu	%xmm6, 48(%rax)
	movq	%rsi, %rax
	movl	$6, (%rsi)
	vmovaps	32(%rsp), %xmm6
	vmovaps	48(%rsp), %xmm8
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_add
	.def	fn_vlin_k_add;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_add
fn_vlin_k_add:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 256(%rsp)
	.seh_savexmm	%xmm6, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rsi
	jle	.L1773
	movq	8(%r8), %rdi
	cmpl	$1, %edx
	movq	(%r8), %rax
	movq	%rdi, 136(%rsp)
	je	.L1773
	movq	24(%r8), %rbx
	cmpl	$2, %edx
	movq	16(%r8), %rdi
	movq	%rbx, 144(%rsp)
	je	.L1773
	cmpl	$3, %edx
	vmovdqu	32(%r8), %xmm6
	je	.L1773
	cmpl	$2, 48(%r8)
	je	.L1811
	vcvttsd2siq	56(%r8), %rbx
	movq	%rbx, 104(%rsp)
.L1775:
	cmpq	$0, 104(%rsp)
	jle	.L1773
	cmpl	$11, %edi
	movl	%eax, 156(%rsp)
	movabsq	$-4294967296, %rbx
	sete	%cl
	cmpl	$4, %edi
	movq	%rsi, 352(%rsp)
	sete	%dl
	orl	%edx, %ecx
	leal	-11(%rax), %edx
	cmpl	$1, %edx
	movb	%cl, 135(%rsp)
	setbe	%dl
	cmpl	$4, %eax
	sete	%al
	xorl	%r15d, %r15d
	orl	%eax, %edx
	leaq	240(%rsp), %rax
	movq	%rax, 80(%rsp)
	leaq	208(%rsp), %rax
	movq	%rax, 88(%rsp)
	leaq	224(%rsp), %rax
	movb	%dl, 134(%rsp)
	movq	%rax, 96(%rsp)
	.p2align 4,,10
	.p2align 3
.L1790:
	cmpb	$0, 135(%rsp)
	jne	.L1776
.L1814:
	cmpl	$12, %edi
	je	.L1812
	cmpl	$3, %edi
	jne	.L1778
	movq	144(%rsp), %rcx
	call	strlen
	testl	%r15d, %r15d
	js	.L1778
	cmpl	%eax, %r15d
	jge	.L1778
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%r15d, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L1783
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1784:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L1784
	movl	$1, _vyne_char_pool_ready(%rip)
.L1783:
	movq	144(%rsp), %rsi
	movslq	%r8d, %rax
	movl	$3, %r14d
	movq	$3, 160(%rsp)
	movq	160(%rsp), %r10
	movzbl	(%rsi,%rax), %eax
	leaq	(%rcx,%rax,2), %rsi
	movq	%rsi, %r11
	movq	%rsi, %rbp
	.p2align 4,,10
	.p2align 3
.L1782:
	movl	$2, %r8d
	movq	96(%rsp), %rdx
	movq	80(%rsp), %rcx
	movq	%r10, 64(%rsp)
	movq	%r8, 208(%rsp)
	movq	88(%rsp), %r8
	movq	%r11, 72(%rsp)
	movq	%r15, 216(%rsp)
	vmovdqa	%xmm6, 224(%rsp)
	call	vyne_index_get
	movq	64(%rsp), %rax
	movl	%r14d, %edx
	movq	240(%rsp), %r9
	movq	248(%rsp), %r8
	andq	%rbx, %rax
	movl	%r9d, %ecx
	orq	%rdx, %rax
	cmpl	$2, %r14d
	movq	%rax, %r10
	jne	.L1785
	cmpl	$2, %r9d
	jne	.L1786
	movq	$2, 48(%rsp)
	movq	48(%rsp), %rax
	addq	%rbp, %r8
.L1787:
	andq	%rbx, %rax
	orq	%rcx, %rax
	cmpb	$0, 134(%rsp)
	jne	.L1813
	addq	$1, %r15
	cmpq	%r15, 104(%rsp)
	jne	.L1790
.L1809:
	movq	352(%rsp), %rsi
.L1773:
	movq	$2, (%rsi)
	movq	%rsi, %rax
	movq	$0, 8(%rsi)
	vmovaps	256(%rsp), %xmm6
	addq	$280, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L1811:
	movq	56(%r8), %rbx
	movq	%rbx, 104(%rsp)
	jmp	.L1775
	.p2align 4,,10
	.p2align 3
.L1778:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%ebp, %ebp
	xorl	%esi, %esi
	xorl	%r14d, %r14d
	jmp	.L1782
	.p2align 4,,10
	.p2align 3
.L1813:
	movq	%rax, 240(%rsp)
	movq	80(%rsp), %rax
	movq	%r15, %r9
	addq	$1, %r15
	movq	136(%rsp), %rdx
	movl	156(%rsp), %ecx
	movq	%r8, 248(%rsp)
	movl	$2, %r8d
	movq	%rax, 32(%rsp)
	call	vyne_array_set.isra.0
	cmpq	%r15, 104(%rsp)
	je	.L1809
	cmpb	$0, 135(%rsp)
	je	.L1814
.L1776:
	cmpl	$4, %edi
	movq	144(%rsp), %rax
	je	.L1815
	cmpq	%r15, 8(%rax)
	jle	.L1778
	movq	(%rax), %rax
	movl	$1, %r14d
	movq	$1, 176(%rsp)
	movq	176(%rsp), %r10
	movq	(%rax,%r15,8), %rsi
	movq	%rsi, %r11
	movq	%rsi, %rbp
	jmp	.L1782
	.p2align 4,,10
	.p2align 3
.L1812:
	movq	144(%rsp), %rax
	cmpq	%r15, 8(%rax)
	jle	.L1778
	movq	(%rax), %rax
	movl	$2, %r14d
	movq	$2, 192(%rsp)
	movq	192(%rsp), %r10
	movq	(%rax,%r15,8), %rbp
	movq	%rbp, %r11
	movq	%rbp, %rsi
	jmp	.L1782
	.p2align 4,,10
	.p2align 3
.L1785:
	cmpl	$1, %r14d
	jne	.L1786
	cmpl	$1, %r9d
	jne	.L1786
	vmovq	%r8, %xmm2
	vmovq	%rsi, %xmm1
	movl	$1, %ecx
	movq	$1, 112(%rsp)
	vaddsd	%xmm2, %xmm1, %xmm0
	movq	112(%rsp), %rax
	vmovq	%xmm0, %r8
	jmp	.L1787
	.p2align 4,,10
	.p2align 3
.L1815:
	movslq	8(%rax), %rax
	cmpq	%r15, %rax
	jle	.L1778
	movq	144(%rsp), %rax
	movq	%r15, %rcx
	salq	$4, %rcx
	addq	(%rax), %rcx
	movq	8(%rcx), %rsi
	movq	(%rcx), %r10
	movq	8(%rcx), %r11
	movl	(%rcx), %r14d
	movq	%rsi, %rbp
	jmp	.L1782
	.p2align 4,,10
	.p2align 3
.L1786:
	movq	%r8, 216(%rsp)
	movq	96(%rsp), %rdx
	movq	88(%rsp), %r8
	movq	80(%rsp), %rcx
	movq	%r9, 208(%rsp)
	movl	$29, %r9d
	movq	%r10, 224(%rsp)
	movq	%rbp, 232(%rsp)
	call	vyne_binop_slow
	movq	240(%rsp), %rax
	movq	248(%rsp), %rdx
	movl	%eax, %ecx
	movq	%rdx, %r8
	jmp	.L1787
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_add_native
	.def	fn_vlin_k_add_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_add_native
fn_vlin_k_add_native:
	.seh_endprologue
	testq	%r9, %r9
	jle	.L1817
	cmpq	$1, %r9
	je	.L1827
	leaq	-8(%rcx), %rax
	movq	%rax, %r10
	subq	%rdx, %r10
	cmpq	$16, %r10
	jbe	.L1827
	subq	%r8, %rax
	cmpq	$16, %rax
	jbe	.L1827
	leaq	-1(%r9), %rax
	movq	%r9, %r10
	cmpq	$2, %rax
	jbe	.L1828
	shrq	$2, %r10
	xorl	%eax, %eax
	salq	$5, %r10
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1820:
	vmovupd	(%r8,%rax), %ymm0
	vaddpd	(%rdx,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%rax, %r10
	jne	.L1820
	movq	%r9, %rax
	andq	$-4, %rax
	cmpq	%rax, %r9
	movq	%rax, %r11
	je	.L1843
	subq	%rax, %r9
	cmpq	$1, %r9
	movq	%r9, %r10
	je	.L1845
	vzeroupper
.L1819:
	vmovupd	(%r8,%r11,8), %xmm0
	vaddpd	(%rdx,%r11,8), %xmm0, %xmm0
	testb	$1, %r10b
	vmovupd	%xmm0, (%rcx,%r11,8)
	je	.L1817
	andq	$-2, %r10
	addq	%r10, %rax
.L1822:
	vmovsd	(%rdx,%rax,8), %xmm0
	vaddsd	(%r8,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
.L1817:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L1843:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L1827:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1824:
	vmovsd	(%rdx,%rax,8), %xmm0
	vaddsd	(%r8,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r9
	jne	.L1824
	xorl	%eax, %eax
	ret
.L1828:
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.L1819
.L1845:
	vzeroupper
	jmp	.L1822
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_sub
	.def	fn_vlin_k_sub;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_sub
fn_vlin_k_sub:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 256(%rsp)
	.seh_savexmm	%xmm6, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rdi
	jle	.L1849
	movq	8(%r8), %rsi
	cmpl	$1, %edx
	movq	(%r8), %rax
	movq	%rsi, 136(%rsp)
	je	.L1849
	movq	24(%r8), %rsi
	cmpl	$2, %edx
	movq	16(%r8), %rbp
	movq	%rsi, 144(%rsp)
	je	.L1849
	cmpl	$3, %edx
	vmovdqu	32(%r8), %xmm6
	je	.L1849
	cmpl	$2, 48(%r8)
	je	.L1887
	vcvttsd2siq	56(%r8), %rsi
	movq	%rsi, 104(%rsp)
.L1851:
	cmpq	$0, 104(%rsp)
	jle	.L1849
	cmpl	$11, %ebp
	movl	%eax, 156(%rsp)
	movabsq	$-4294967296, %rsi
	sete	%cl
	cmpl	$4, %ebp
	movq	%rdi, 352(%rsp)
	sete	%dl
	orl	%edx, %ecx
	leal	-11(%rax), %edx
	cmpl	$1, %edx
	movb	%cl, 135(%rsp)
	setbe	%dl
	cmpl	$4, %eax
	sete	%al
	xorl	%r15d, %r15d
	orl	%eax, %edx
	leaq	240(%rsp), %rax
	movq	%rax, 80(%rsp)
	leaq	208(%rsp), %rax
	movq	%rax, 88(%rsp)
	leaq	224(%rsp), %rax
	movb	%dl, 134(%rsp)
	movq	%rax, 96(%rsp)
	.p2align 4,,10
	.p2align 3
.L1866:
	cmpb	$0, 135(%rsp)
	jne	.L1852
.L1890:
	cmpl	$12, %ebp
	je	.L1888
	cmpl	$3, %ebp
	jne	.L1854
	movq	144(%rsp), %rcx
	call	strlen
	testl	%r15d, %r15d
	js	.L1854
	cmpl	%eax, %r15d
	jge	.L1854
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%r15d, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L1859
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1860:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L1860
	movl	$1, _vyne_char_pool_ready(%rip)
.L1859:
	movq	144(%rsp), %rdi
	movslq	%r8d, %rax
	movl	$3, %r14d
	movq	$3, 160(%rsp)
	movq	160(%rsp), %r10
	movzbl	(%rdi,%rax), %eax
	leaq	(%rcx,%rax,2), %rdi
	movq	%rdi, %r11
	movq	%rdi, %rbx
	.p2align 4,,10
	.p2align 3
.L1858:
	movl	$2, %r8d
	movq	96(%rsp), %rdx
	movq	80(%rsp), %rcx
	movq	%r10, 64(%rsp)
	movq	%r8, 208(%rsp)
	movq	88(%rsp), %r8
	movq	%r11, 72(%rsp)
	movq	%r15, 216(%rsp)
	vmovdqa	%xmm6, 224(%rsp)
	call	vyne_index_get
	movq	64(%rsp), %rax
	movl	%r14d, %edx
	movq	240(%rsp), %r8
	movq	248(%rsp), %r9
	andq	%rsi, %rax
	movl	%r8d, %ecx
	orq	%rdx, %rax
	cmpl	$2, %r14d
	movq	%rax, %r10
	jne	.L1861
	cmpl	$2, %r8d
	jne	.L1862
	movq	$2, 48(%rsp)
	movq	48(%rsp), %rax
	subq	%r9, %rbx
.L1863:
	andq	%rsi, %rax
	orq	%rcx, %rax
	cmpb	$0, 134(%rsp)
	jne	.L1889
	addq	$1, %r15
	cmpq	%r15, 104(%rsp)
	jne	.L1866
.L1885:
	movq	352(%rsp), %rdi
.L1849:
	movq	$2, (%rdi)
	movq	%rdi, %rax
	movq	$0, 8(%rdi)
	vmovaps	256(%rsp), %xmm6
	addq	$280, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L1887:
	movq	56(%r8), %rsi
	movq	%rsi, 104(%rsp)
	jmp	.L1851
	.p2align 4,,10
	.p2align 3
.L1854:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%ebx, %ebx
	xorl	%edi, %edi
	xorl	%r14d, %r14d
	jmp	.L1858
	.p2align 4,,10
	.p2align 3
.L1889:
	movl	156(%rsp), %ecx
	movq	%rax, 240(%rsp)
	movq	%r15, %r9
	movl	$2, %r8d
	movq	80(%rsp), %rax
	movq	136(%rsp), %rdx
	movq	%rbx, 248(%rsp)
	addq	$1, %r15
	movq	%rax, 32(%rsp)
	call	vyne_array_set.isra.0
	cmpq	%r15, 104(%rsp)
	je	.L1885
	cmpb	$0, 135(%rsp)
	je	.L1890
.L1852:
	cmpl	$4, %ebp
	movq	144(%rsp), %rax
	je	.L1891
	cmpq	%r15, 8(%rax)
	jle	.L1854
	movq	(%rax), %rax
	movl	$1, %r14d
	movq	$1, 176(%rsp)
	movq	176(%rsp), %r10
	movq	(%rax,%r15,8), %rdi
	movq	%rdi, %r11
	movq	%rdi, %rbx
	jmp	.L1858
	.p2align 4,,10
	.p2align 3
.L1888:
	movq	144(%rsp), %rax
	cmpq	%r15, 8(%rax)
	jle	.L1854
	movq	(%rax), %rax
	movl	$2, %r14d
	movq	$2, 192(%rsp)
	movq	192(%rsp), %r10
	movq	(%rax,%r15,8), %rbx
	movq	%rbx, %r11
	movq	%rbx, %rdi
	jmp	.L1858
	.p2align 4,,10
	.p2align 3
.L1861:
	cmpl	$1, %r14d
	jne	.L1862
	cmpl	$1, %r8d
	jne	.L1862
	vmovq	%rdi, %xmm1
	vmovq	%r9, %xmm2
	movl	$1, %ecx
	movq	$1, 112(%rsp)
	vsubsd	%xmm2, %xmm1, %xmm0
	movq	112(%rsp), %rax
	vmovq	%xmm0, %rbx
	jmp	.L1863
	.p2align 4,,10
	.p2align 3
.L1891:
	movslq	8(%rax), %rax
	cmpq	%r15, %rax
	jle	.L1854
	movq	144(%rsp), %rax
	movq	%r15, %rcx
	salq	$4, %rcx
	addq	(%rax), %rcx
	movq	8(%rcx), %rdi
	movq	(%rcx), %r10
	movq	8(%rcx), %r11
	movl	(%rcx), %r14d
	movq	%rdi, %rbx
	jmp	.L1858
	.p2align 4,,10
	.p2align 3
.L1862:
	movq	%r8, 208(%rsp)
	movq	96(%rsp), %rdx
	movq	80(%rsp), %rcx
	movq	88(%rsp), %r8
	movq	%r9, 216(%rsp)
	movl	$30, %r9d
	movq	%rbx, 232(%rsp)
	movq	%r10, 224(%rsp)
	call	vyne_binop_slow
	movq	240(%rsp), %rax
	movq	248(%rsp), %rdx
	movl	%eax, %ecx
	movq	%rdx, %rbx
	jmp	.L1863
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_sub_native
	.def	fn_vlin_k_sub_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_sub_native
fn_vlin_k_sub_native:
	.seh_endprologue
	testq	%r9, %r9
	jle	.L1893
	cmpq	$1, %r9
	je	.L1903
	leaq	-8(%rcx), %rax
	movq	%rax, %r10
	subq	%rdx, %r10
	cmpq	$16, %r10
	jbe	.L1903
	subq	%r8, %rax
	cmpq	$16, %rax
	jbe	.L1903
	leaq	-1(%r9), %rax
	movq	%r9, %r10
	cmpq	$2, %rax
	jbe	.L1904
	shrq	$2, %r10
	xorl	%eax, %eax
	salq	$5, %r10
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1896:
	vmovupd	(%rdx,%rax), %ymm0
	vsubpd	(%r8,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%rax, %r10
	jne	.L1896
	movq	%r9, %rax
	andq	$-4, %rax
	cmpq	%rax, %r9
	movq	%rax, %r11
	je	.L1919
	subq	%rax, %r9
	cmpq	$1, %r9
	movq	%r9, %r10
	je	.L1921
	vzeroupper
.L1895:
	vmovupd	(%rdx,%r11,8), %xmm0
	vsubpd	(%r8,%r11,8), %xmm0, %xmm0
	testb	$1, %r10b
	vmovupd	%xmm0, (%rcx,%r11,8)
	je	.L1893
	andq	$-2, %r10
	addq	%r10, %rax
.L1898:
	vmovsd	(%rdx,%rax,8), %xmm0
	vsubsd	(%r8,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
.L1893:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L1919:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L1903:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1900:
	vmovsd	(%rdx,%rax,8), %xmm0
	vsubsd	(%r8,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r9
	jne	.L1900
	xorl	%eax, %eax
	ret
.L1904:
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.L1895
.L1921:
	vzeroupper
	jmp	.L1898
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_mul
	.def	fn_vlin_k_mul;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_mul
fn_vlin_k_mul:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	vmovaps	%xmm8, 256(%rsp)
	.seh_savexmm	%xmm8, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L1925
	cmpl	$1, %edx
	vmovdqu	(%r8), %xmm6
	je	.L1925
	cmpl	$2, %edx
	movq	16(%r8), %r15
	movq	24(%r8), %r10
	je	.L1925
	cmpl	$3, %edx
	vmovdqu	32(%r8), %xmm8
	je	.L1925
	cmpl	$2, 48(%r8)
	je	.L1960
	vcvttsd2siq	56(%r8), %rcx
.L1927:
	testq	%rcx, %rcx
	jle	.L1925
	cmpl	$11, %r15d
	leaq	224(%rsp), %rbp
	leaq	192(%rsp), %rdi
	movq	%rcx, 128(%rsp)
	sete	%dl
	cmpl	$4, %r15d
	movq	%r15, 96(%rsp)
	leaq	208(%rsp), %rsi
	sete	%al
	movq	%r13, 352(%rsp)
	xorl	%ebx, %ebx
	orl	%eax, %edx
	movq	%r10, 136(%rsp)
	movb	%dl, 111(%rsp)
	movq	%rdi, 48(%rsp)
	movq	%rsi, 56(%rsp)
	movq	%rbp, 64(%rsp)
	.p2align 4,,10
	.p2align 3
.L1940:
	cmpb	$0, 111(%rsp)
	jne	.L1928
	cmpl	$12, 96(%rsp)
	je	.L1961
	cmpl	$3, 96(%rsp)
	jne	.L1930
	movq	136(%rsp), %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L1930
	cmpl	%eax, %ebx
	jge	.L1930
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L1935
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1936:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L1936
	movl	$1, _vyne_char_pool_ready(%rip)
.L1935:
	movq	136(%rsp), %rdx
	movslq	%r8d, %rax
	movl	$3, %ebp
	movq	$3, 144(%rsp)
	movq	144(%rsp), %r9
	movzbl	(%rdx,%rax), %eax
	leaq	(%rcx,%rax,2), %r12
	movq	%r12, %r10
	movq	%r12, %r13
	.p2align 4,,10
	.p2align 3
.L1934:
	movq	48(%rsp), %r8
	movq	56(%rsp), %rdx
	movq	%r10, 88(%rsp)
	movl	$2, %r10d
	movq	64(%rsp), %rcx
	movq	%r9, 80(%rsp)
	movq	%r10, 192(%rsp)
	movq	%rbx, 200(%rsp)
	vmovdqa	%xmm8, 208(%rsp)
	call	vyne_index_get
	movq	80(%rsp), %rax
	movl	%ebp, %edx
	movabsq	$-4294967296, %r11
	movq	224(%rsp), %rcx
	movq	232(%rsp), %r8
	andq	%r11, %rax
	orq	%rdx, %rax
	cmpl	$2, %ebp
	movq	%rax, %r9
	jne	.L1937
	cmpl	$2, %ecx
	jne	.L1938
	movq	$2, 32(%rsp)
	imulq	%r8, %r13
	movq	32(%rsp), %r12
.L1939:
	movq	48(%rsp), %r8
	movq	56(%rsp), %rdx
	movl	$2, %eax
	movq	%rbx, 216(%rsp)
	movq	64(%rsp), %rcx
	movq	%rax, 208(%rsp)
	addq	$1, %rbx
	movq	%r12, 192(%rsp)
	movq	%r13, 200(%rsp)
	vmovdqa	%xmm6, 224(%rsp)
	call	vyne_index_set
	cmpq	%rbx, 128(%rsp)
	jne	.L1940
	movq	352(%rsp), %r13
.L1925:
	movq	$2, 0(%r13)
	movq	%r13, %rax
	movq	$0, 8(%r13)
	vmovaps	240(%rsp), %xmm6
	vmovaps	256(%rsp), %xmm8
	addq	$280, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L1960:
	movq	56(%r8), %rcx
	jmp	.L1927
	.p2align 4,,10
	.p2align 3
.L1930:
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	xorl	%r13d, %r13d
	xorl	%r12d, %r12d
	xorl	%ebp, %ebp
	jmp	.L1934
	.p2align 4,,10
	.p2align 3
.L1928:
	cmpl	$4, 96(%rsp)
	movq	136(%rsp), %rax
	je	.L1962
	cmpq	8(%rax), %rbx
	jge	.L1930
	movq	(%rax), %rax
	movl	$1, %ebp
	movq	$1, 160(%rsp)
	movq	160(%rsp), %r9
	movq	(%rax,%rbx,8), %r12
	movq	%r12, %r10
	movq	%r12, %r13
	jmp	.L1934
	.p2align 4,,10
	.p2align 3
.L1961:
	movq	136(%rsp), %rax
	cmpq	8(%rax), %rbx
	jge	.L1930
	movq	(%rax), %rax
	movl	$2, %ebp
	movq	$2, 176(%rsp)
	movq	176(%rsp), %r9
	movq	(%rax,%rbx,8), %r13
	movq	%r13, %r10
	movq	%r13, %r12
	jmp	.L1934
	.p2align 4,,10
	.p2align 3
.L1937:
	cmpl	$1, %ebp
	jne	.L1938
	cmpl	$1, %ecx
	jne	.L1938
	vmovq	%r12, %xmm1
	vmovq	%r8, %xmm2
	movq	$1, 112(%rsp)
	vmulsd	%xmm2, %xmm1, %xmm0
	vmovq	%xmm0, %r12
	movq	%r12, %r13
	movq	112(%rsp), %r12
	jmp	.L1939
	.p2align 4,,10
	.p2align 3
.L1962:
	movslq	8(%rax), %rax
	cmpq	%rax, %rbx
	jge	.L1930
	movq	136(%rsp), %rax
	movq	%rbx, %rcx
	salq	$4, %rcx
	addq	(%rax), %rcx
	movq	8(%rcx), %r12
	movq	(%rcx), %r9
	movq	8(%rcx), %r10
	movl	(%rcx), %ebp
	movq	%r12, %r13
	jmp	.L1934
	.p2align 4,,10
	.p2align 3
.L1938:
	movq	%rcx, 192(%rsp)
	movq	56(%rsp), %rdx
	movq	%r8, 200(%rsp)
	movq	64(%rsp), %rcx
	movq	48(%rsp), %r8
	movq	%r9, 208(%rsp)
	movl	$31, %r9d
	movq	%r13, 216(%rsp)
	call	vyne_binop_slow
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	jmp	.L1939
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_mul_native
	.def	fn_vlin_k_mul_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_mul_native
fn_vlin_k_mul_native:
	.seh_endprologue
	testq	%r9, %r9
	jle	.L1964
	cmpq	$1, %r9
	je	.L1974
	leaq	-8(%rcx), %rax
	movq	%rax, %r10
	subq	%rdx, %r10
	cmpq	$16, %r10
	jbe	.L1974
	subq	%r8, %rax
	cmpq	$16, %rax
	jbe	.L1974
	leaq	-1(%r9), %rax
	movq	%r9, %r10
	cmpq	$2, %rax
	jbe	.L1975
	shrq	$2, %r10
	xorl	%eax, %eax
	salq	$5, %r10
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1967:
	vmovupd	(%r8,%rax), %ymm0
	vmulpd	(%rdx,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%rax, %r10
	jne	.L1967
	movq	%r9, %rax
	andq	$-4, %rax
	cmpq	%rax, %r9
	movq	%rax, %r11
	je	.L1990
	subq	%rax, %r9
	cmpq	$1, %r9
	movq	%r9, %r10
	je	.L1992
	vzeroupper
.L1966:
	vmovupd	(%r8,%r11,8), %xmm0
	vmulpd	(%rdx,%r11,8), %xmm0, %xmm0
	testb	$1, %r10b
	vmovupd	%xmm0, (%rcx,%r11,8)
	je	.L1964
	andq	$-2, %r10
	addq	%r10, %rax
.L1969:
	vmovsd	(%rdx,%rax,8), %xmm0
	vmulsd	(%r8,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
.L1964:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L1990:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L1974:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L1971:
	vmovsd	(%rdx,%rax,8), %xmm0
	vmulsd	(%r8,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r9
	jne	.L1971
	xorl	%eax, %eax
	ret
.L1975:
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.L1966
.L1992:
	vzeroupper
	jmp	.L1969
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_div
	.def	fn_vlin_k_div;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_div
fn_vlin_k_div:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	vmovaps	%xmm8, 256(%rsp)
	.seh_savexmm	%xmm8, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L1996
	cmpl	$1, %edx
	vmovdqu	(%r8), %xmm6
	je	.L1996
	cmpl	$2, %edx
	movq	16(%r8), %r15
	movq	24(%r8), %r11
	je	.L1996
	cmpl	$3, %edx
	vmovdqu	32(%r8), %xmm8
	je	.L1996
	cmpl	$2, 48(%r8)
	je	.L2035
	vcvttsd2siq	56(%r8), %r10
.L1998:
	testq	%r10, %r10
	jle	.L1996
	cmpl	$11, %r15d
	leaq	224(%rsp), %rbp
	leaq	192(%rsp), %rdi
	movq	%r10, 128(%rsp)
	sete	%dl
	cmpl	$4, %r15d
	movq	%r15, 96(%rsp)
	leaq	208(%rsp), %r12
	sete	%al
	movq	%r11, 136(%rsp)
	orl	%eax, %edx
	movq	%rbp, 64(%rsp)
	movb	%dl, 111(%rsp)
	movq	%rdi, 72(%rsp)
	movq	%r13, 352(%rsp)
	xorl	%r13d, %r13d
	.p2align 4,,10
	.p2align 3
.L2014:
	cmpb	$0, 111(%rsp)
	jne	.L1999
	cmpl	$12, 96(%rsp)
	je	.L2036
	cmpl	$3, 96(%rsp)
	jne	.L2001
	movq	136(%rsp), %rcx
	call	strlen
	testl	%r13d, %r13d
	js	.L2001
	cmpl	%eax, %r13d
	jge	.L2001
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%r13d, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2006
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2007:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2007
	movl	$1, _vyne_char_pool_ready(%rip)
.L2006:
	movq	136(%rsp), %rbx
	movslq	%r8d, %rax
	movl	$3, %ebp
	movq	$3, 144(%rsp)
	movq	144(%rsp), %r14
	movzbl	(%rbx,%rax), %eax
	leaq	(%rcx,%rax,2), %rbx
	movq	%rbx, 80(%rsp)
	.p2align 4,,10
	.p2align 3
.L2005:
	movq	64(%rsp), %rcx
	movq	72(%rsp), %r8
	movl	$2, %eax
	movq	%r12, %rdx
	movq	%rax, 192(%rsp)
	movq	%r13, 200(%rsp)
	vmovdqa	%xmm8, 208(%rsp)
	call	vyne_index_get
	movl	%ebp, %edx
	movabsq	$-4294967296, %r9
	movq	224(%rsp), %rax
	andq	%r9, %r14
	movq	232(%rsp), %rcx
	orq	%rdx, %r14
	cmpl	$2, %ebp
	jne	.L2008
	cmpl	$2, %eax
	jne	.L2009
	testq	%rcx, %rcx
	je	.L2012
	movq	$2, 48(%rsp)
	movq	80(%rsp), %rax
	cqto
	idivq	%rcx
	movq	%rax, %rdx
	movq	48(%rsp), %rax
.L2011:
	movq	$2, 32(%rsp)
	movq	32(%rsp), %rcx
	movq	72(%rsp), %r8
	movq	%rdx, 200(%rsp)
	movq	%r12, %rdx
	movq	%rcx, 208(%rsp)
	movq	64(%rsp), %rcx
	movq	%r13, 216(%rsp)
	addq	$1, %r13
	movq	%rax, 192(%rsp)
	vmovdqa	%xmm6, 224(%rsp)
	call	vyne_index_set
	cmpq	%r13, 128(%rsp)
	jne	.L2014
	movq	352(%rsp), %r13
.L1996:
	movq	$2, 0(%r13)
	movq	%r13, %rax
	movq	$0, 8(%r13)
	vmovaps	240(%rsp), %xmm6
	vmovaps	256(%rsp), %xmm8
	addq	$280, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2035:
	movq	56(%r8), %r10
	jmp	.L1998
	.p2align 4,,10
	.p2align 3
.L2001:
	movq	$0, 80(%rsp)
	xorl	%r14d, %r14d
	xorl	%ebx, %ebx
	xorl	%ebp, %ebp
	jmp	.L2005
	.p2align 4,,10
	.p2align 3
.L1999:
	cmpl	$4, 96(%rsp)
	movq	136(%rsp), %rax
	je	.L2037
	cmpq	8(%rax), %r13
	jge	.L2001
	movq	(%rax), %rax
	movl	$1, %ebp
	movq	$1, 160(%rsp)
	movq	160(%rsp), %r14
	movq	(%rax,%r13,8), %rbx
	movq	%rbx, 80(%rsp)
	jmp	.L2005
	.p2align 4,,10
	.p2align 3
.L2036:
	movq	136(%rsp), %rax
	cmpq	8(%rax), %r13
	jge	.L2001
	movq	(%rax), %rax
	movl	$2, %ebp
	movq	$2, 176(%rsp)
	movq	176(%rsp), %r14
	movq	(%rax,%r13,8), %rbx
	movq	%rbx, 80(%rsp)
	jmp	.L2005
	.p2align 4,,10
	.p2align 3
.L2008:
	cmpl	$1, %ebp
	jne	.L2009
	cmpl	$1, %eax
	jne	.L2009
	vmovq	%rcx, %xmm0
	vxorpd	%xmm1, %xmm1, %xmm1
	vucomisd	%xmm1, %xmm0
	jp	.L2015
	je	.L2012
.L2015:
	movq	$1, 112(%rsp)
	vmovq	%rbx, %xmm3
	vdivsd	%xmm0, %xmm3, %xmm2
	vmovq	%xmm2, %rax
	movq	%rax, %rdx
	movq	112(%rsp), %rax
	jmp	.L2011
	.p2align 4,,10
	.p2align 3
.L2037:
	movslq	8(%rax), %rax
	cmpq	%rax, %r13
	jge	.L2001
	movq	136(%rsp), %rbx
	movq	%r13, %rax
	salq	$4, %rax
	addq	(%rbx), %rax
	movq	8(%rax), %rbx
	movq	(%rax), %r14
	movl	(%rax), %ebp
	movq	%rbx, 80(%rsp)
	jmp	.L2005
	.p2align 4,,10
	.p2align 3
.L2009:
	movq	%rcx, 200(%rsp)
	movq	80(%rsp), %rbx
	movq	%r12, %rdx
	movl	$32, %r9d
	movq	72(%rsp), %r8
	movq	64(%rsp), %rcx
	movq	%rax, 192(%rsp)
	movq	%r14, 208(%rsp)
	movq	%rbx, 216(%rsp)
	call	vyne_binop_slow
	movq	224(%rsp), %rax
	movq	232(%rsp), %rdx
	jmp	.L2011
.L2012:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$33, %r8d
	movl	$1, %edx
	leaq	.LC45(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_div_native
	.def	fn_vlin_k_div_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_div_native
fn_vlin_k_div_native:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	testq	%r9, %r9
	movq	%rcx, %rsi
	movq	%rdx, %rdi
	movq	%r8, %rbx
	jle	.L2083
	leaq	-1(%r9), %rdx
	cmpq	$5, %rdx
	jbe	.L2065
	leaq	-8(%rcx), %rax
	movq	%rax, %rcx
	subq	%rdi, %rcx
	cmpq	$16, %rcx
	jbe	.L2065
	subq	%r8, %rax
	cmpq	$16, %rax
	jbe	.L2065
	movq	%r8, %rax
	shrq	$3, %rax
	negq	%rax
	movq	%rax, %rcx
	andl	$3, %ecx
	leaq	4(%rcx), %r8
	cmpq	%r8, %rdx
	jb	.L2041
	testq	%rcx, %rcx
	je	.L2066
	vmovsd	(%rbx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm0, %xmm1
	jp	.L2069
	je	.L2043
.L2069:
	vmovsd	(%rdi), %xmm0
	testb	$2, %al
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi)
	je	.L2067
	vmovsd	8(%rbx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm0, %xmm1
	jp	.L2070
	je	.L2043
.L2070:
	vmovsd	8(%rdi), %xmm0
	cmpq	$3, %rcx
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, 8(%rsi)
	jne	.L2068
	vmovsd	16(%rbx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm0, %xmm1
	jp	.L2071
	je	.L2043
.L2071:
	movq	$3, 40(%rsp)
	vmovsd	16(%rdi), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, 16(%rsi)
.L2042:
	movq	%r9, %rbp
	vpbroadcastq	40(%rsp), %ymm2
	xorl	%eax, %eax
	xorl	%edx, %edx
	subq	%rcx, %rbp
	vpaddq	.LC37(%rip), %ymm2, %ymm2
	salq	$3, %rcx
	vxorpd	%xmm4, %xmm4, %xmm4
	movq	%rbp, %r8
	leaq	(%rdi,%rcx), %r11
	leaq	(%rbx,%rcx), %r10
	addq	%rsi, %rcx
	vpbroadcastq	.LC39(%rip), %ymm3
	shrq	$2, %r8
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2050:
	vmovapd	(%r10,%rax), %ymm1
	vcmpeqpd	%ymm4, %ymm1, %ymm0
	vptest	%ymm0, %ymm0
	jne	.L2095
	vmovupd	(%r11,%rax), %ymm0
	addq	$1, %rdx
	vpaddq	%ymm3, %ymm2, %ymm2
	vdivpd	%ymm1, %ymm0, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%rdx, %r8
	jne	.L2050
	testb	$3, %bpl
	je	.L2094
	movq	40(%rsp), %rax
	andq	$-4, %rbp
	addq	%rbp, %rax
.L2049:
	vmovsd	(%rbx,%rax,8), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	0(,%rax,8), %rdx
	vucomisd	%xmm0, %xmm1
	jp	.L2072
	je	.L2093
.L2072:
	vmovsd	(%rdi,%rdx), %xmm0
	leaq	1(%rax), %rcx
	cmpq	%rcx, %r9
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rdx)
	jle	.L2094
	vzeroupper
.L2061:
	vmovsd	8(%rbx,%rdx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	8(%rdx), %rcx
	vucomisd	%xmm0, %xmm1
	jp	.L2073
	je	.L2043
.L2073:
	vmovsd	(%rdi,%rcx), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rcx)
	leaq	2(%rax), %rcx
	cmpq	%rcx, %r9
	jle	.L2083
	vmovsd	16(%rbx,%rdx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	16(%rdx), %rcx
	vucomisd	%xmm0, %xmm1
	jp	.L2074
	je	.L2043
.L2074:
	vmovsd	(%rdi,%rcx), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rcx)
	leaq	3(%rax), %rcx
	cmpq	%rcx, %r9
	jle	.L2083
	vmovsd	24(%rbx,%rdx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	24(%rdx), %rcx
	vucomisd	%xmm0, %xmm1
	jp	.L2075
	je	.L2043
.L2075:
	vmovsd	(%rdi,%rcx), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rcx)
	leaq	4(%rax), %rcx
	cmpq	%rcx, %r9
	jle	.L2083
	vmovsd	32(%rbx,%rdx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	32(%rdx), %rcx
	vucomisd	%xmm0, %xmm1
	jp	.L2076
	je	.L2043
.L2076:
	vmovsd	(%rdi,%rcx), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rcx)
	leaq	5(%rax), %rcx
	cmpq	%rcx, %r9
	jle	.L2083
	vmovsd	40(%rbx,%rdx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	40(%rdx), %rcx
	vucomisd	%xmm0, %xmm1
	jp	.L2077
	je	.L2043
.L2077:
	vmovsd	(%rdi,%rcx), %xmm0
	addq	$6, %rax
	cmpq	%rax, %r9
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rcx)
	jle	.L2083
	vmovsd	48(%rbx,%rdx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	leaq	48(%rdx), %rax
	vucomisd	%xmm0, %xmm1
	jp	.L2078
	je	.L2043
.L2078:
	vmovsd	(%rdi,%rax), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rax)
.L2083:
	xorl	%eax, %eax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L2094:
	vzeroupper
	xorl	%eax, %eax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L2067:
	movq	$1, 40(%rsp)
	jmp	.L2042
	.p2align 4,,10
	.p2align 3
.L2065:
	xorl	%eax, %eax
	vxorpd	%xmm2, %xmm2, %xmm2
	.p2align 4,,10
	.p2align 3
.L2060:
	vmovsd	(%rbx,%rax,8), %xmm1
	vucomisd	%xmm2, %xmm1
	jp	.L2079
	je	.L2043
.L2079:
	vmovsd	(%rdi,%rax,8), %xmm0
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r9
	jne	.L2060
	xorl	%eax, %eax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L2066:
	movq	$0, 40(%rsp)
	jmp	.L2042
.L2068:
	movq	$2, 40(%rsp)
	jmp	.L2042
.L2041:
	vmovsd	(%rbx), %xmm1
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm0, %xmm1
	jp	.L2063
	je	.L2043
.L2063:
	vmovsd	(%rdi), %xmm0
	xorl	%eax, %eax
	xorl	%edx, %edx
	vdivsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi)
	jmp	.L2061
.L2093:
	vzeroupper
.L2043:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$33, %r8d
	movl	$1, %edx
	leaq	.LC45(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L2095:
	vmovq	%xmm2, %rax
	jmp	.L2049
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_scale
	.def	fn_vlin_k_scale;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_scale
fn_vlin_k_scale:
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
	subq	$184, %rsp
	.seh_stackalloc	184
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 256(%rsp)
	movl	%edx, %eax
	jle	.L2098
	movq	8(%r8), %rdi
	cmpl	$1, %eax
	movq	(%r8), %rdx
	movq	%rdi, 72(%rsp)
	je	.L2098
	cmpl	$2, %eax
	movq	16(%r8), %rdi
	movq	24(%r8), %r12
	je	.L2098
	cmpl	$1, 32(%r8)
	movq	40(%r8), %rbp
	je	.L2100
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rbp, %xmm0, %xmm0
	vmovq	%xmm0, %rbp
.L2100:
	cmpl	$3, %eax
	je	.L2098
	cmpl	$2, 48(%r8)
	je	.L2139
	vcvttsd2siq	56(%r8), %r13
.L2102:
	testq	%r13, %r13
	jle	.L2098
	cmpl	$11, %edi
	movl	%edx, 92(%rsp)
	movabsq	$-4294967296, %rsi
	sete	%cl
	cmpl	$4, %edi
	sete	%al
	orl	%eax, %ecx
	leal	-11(%rdx), %eax
	cmpl	$1, %eax
	movb	%cl, 71(%rsp)
	setbe	%cl
	cmpl	$4, %edx
	sete	%al
	xorl	%ebx, %ebx
	orl	%eax, %ecx
	leaq	160(%rsp), %rax
	movb	%cl, 70(%rsp)
	movq	%rax, 80(%rsp)
	.p2align 4,,10
	.p2align 3
.L2117:
	cmpb	$0, 71(%rsp)
	jne	.L2103
.L2142:
	cmpl	$12, %edi
	je	.L2140
	cmpl	$3, %edi
	jne	.L2105
	movq	%r12, %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2105
	cmpl	%eax, %ebx
	jge	.L2105
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2112
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2113:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2113
	movl	$1, _vyne_char_pool_ready(%rip)
.L2112:
	movslq	%r8d, %rax
	movl	$3, %edx
	movq	$3, 96(%rsp)
	movq	96(%rsp), %r10
	movzbl	(%r12,%rax), %eax
	leaq	(%rcx,%rax,2), %rax
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2109:
	andq	%rsi, %r10
	movl	$1, %r8d
	movq	%rbp, %r9
	orq	%rdx, %r10
	movq	%r10, %rax
.L2118:
	movq	%rcx, 152(%rsp)
	movq	80(%rsp), %rcx
	leaq	144(%rsp), %rdx
	movq	%r8, 128(%rsp)
	leaq	128(%rsp), %r8
	movq	%r9, 136(%rsp)
	movl	$31, %r9d
	movq	%rax, 144(%rsp)
	call	vyne_binop_slow
	movq	160(%rsp), %r9
	movq	168(%rsp), %r10
	movl	%r9d, %r8d
	movq	%r10, %rcx
	.p2align 4,,10
	.p2align 3
.L2114:
	movq	%r9, %rax
	movl	%r8d, %edx
	andq	%rsi, %rax
	orq	%rdx, %rax
	cmpb	$0, 70(%rsp)
	jne	.L2141
	addq	$1, %rbx
	cmpq	%rbx, %r13
	jne	.L2117
.L2098:
	movq	256(%rsp), %rax
	movq	$2, (%rax)
	movq	$0, 8(%rax)
	addq	$184, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2139:
	movq	56(%r8), %r13
	jmp	.L2102
	.p2align 4,,10
	.p2align 3
.L2105:
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	jmp	.L2109
	.p2align 4,,10
	.p2align 3
.L2141:
	movq	%rax, 160(%rsp)
	movq	80(%rsp), %rax
	movq	%rbx, %r9
	movl	$2, %r8d
	movq	%rcx, 168(%rsp)
	movq	72(%rsp), %rdx
	addq	$1, %rbx
	movq	%rax, 32(%rsp)
	movl	92(%rsp), %ecx
	call	vyne_array_set.isra.0
	cmpq	%rbx, %r13
	je	.L2098
	cmpb	$0, 71(%rsp)
	je	.L2142
.L2103:
	cmpl	$4, %edi
	je	.L2143
	cmpq	8(%r12), %rbx
	jge	.L2105
	movq	(%r12), %rax
	movq	(%rax,%rbx,8), %rcx
	.p2align 4,,10
	.p2align 3
.L2110:
	vmovq	%rcx, %xmm3
	vmovq	%rbp, %xmm2
	movl	$1, %r8d
	movq	$1, 48(%rsp)
	vmulsd	%xmm3, %xmm2, %xmm1
	movq	48(%rsp), %r9
	vmovq	%xmm1, %rcx
	jmp	.L2114
	.p2align 4,,10
	.p2align 3
.L2140:
	cmpq	8(%r12), %rbx
	jge	.L2105
	movq	(%r12), %rax
	movl	$2, %edx
	movq	$2, 112(%rsp)
	movq	112(%rsp), %r10
	movq	(%rax,%rbx,8), %rcx
	jmp	.L2109
	.p2align 4,,10
	.p2align 3
.L2143:
	movslq	8(%r12), %rax
	cmpq	%rax, %rbx
	jge	.L2105
	movq	%rbx, %rdx
	movl	$1, %r8d
	movq	%rbp, %r9
	salq	$4, %rdx
	addq	(%r12), %rdx
	movq	(%rdx), %rax
	movl	(%rdx), %r11d
	movq	8(%rdx), %rcx
	andq	%rsi, %rax
	orq	%r11, %rax
	cmpl	$1, %r11d
	je	.L2110
	jmp	.L2118
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_scale_native
	.def	fn_vlin_k_scale_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_scale_native
fn_vlin_k_scale_native:
	.seh_endprologue
	testq	%r9, %r9
	jle	.L2145
	cmpq	$1, %r9
	je	.L2155
	leaq	-8(%rcx), %rax
	subq	%rdx, %rax
	cmpq	$16, %rax
	jbe	.L2155
	leaq	-1(%r9), %rax
	movq	%r9, %r8
	cmpq	$2, %rax
	jbe	.L2156
	shrq	$2, %r8
	vbroadcastsd	%xmm2, %ymm1
	xorl	%eax, %eax
	salq	$5, %r8
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2148:
	vmulpd	(%rdx,%rax), %ymm1, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%r8, %rax
	jne	.L2148
	movq	%r9, %rax
	andq	$-4, %rax
	cmpq	%rax, %r9
	movq	%rax, %r10
	je	.L2165
	subq	%rax, %r9
	cmpq	$1, %r9
	movq	%r9, %r8
	je	.L2167
	vzeroupper
.L2147:
	vmovddup	%xmm2, %xmm0
	testb	$1, %r8b
	vmulpd	(%rdx,%r10,8), %xmm0, %xmm0
	vmovupd	%xmm0, (%rcx,%r10,8)
	je	.L2145
	andq	$-2, %r8
	addq	%r8, %rax
.L2150:
	vmulsd	(%rdx,%rax,8), %xmm2, %xmm2
	vmovsd	%xmm2, (%rcx,%rax,8)
.L2145:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2165:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2155:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2152:
	vmulsd	(%rdx,%rax,8), %xmm2, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r9
	jne	.L2152
	xorl	%eax, %eax
	ret
.L2156:
	xorl	%r10d, %r10d
	xorl	%eax, %eax
	jmp	.L2147
.L2167:
	vzeroupper
	jmp	.L2150
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_add_scalar
	.def	fn_vlin_k_add_scalar;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_add_scalar
fn_vlin_k_add_scalar:
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
	subq	$184, %rsp
	.seh_stackalloc	184
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 256(%rsp)
	movl	%edx, %eax
	jle	.L2170
	movq	8(%r8), %rdi
	cmpl	$1, %eax
	movq	(%r8), %rdx
	movq	%rdi, 72(%rsp)
	je	.L2170
	cmpl	$2, %eax
	movq	16(%r8), %rdi
	movq	24(%r8), %r12
	je	.L2170
	cmpl	$1, 32(%r8)
	movq	40(%r8), %rbp
	je	.L2172
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rbp, %xmm0, %xmm0
	vmovq	%xmm0, %rbp
.L2172:
	cmpl	$3, %eax
	je	.L2170
	cmpl	$2, 48(%r8)
	je	.L2211
	vcvttsd2siq	56(%r8), %r13
.L2174:
	testq	%r13, %r13
	jle	.L2170
	cmpl	$11, %edi
	movl	%edx, 92(%rsp)
	movabsq	$-4294967296, %rsi
	sete	%cl
	cmpl	$4, %edi
	sete	%al
	orl	%eax, %ecx
	leal	-11(%rdx), %eax
	cmpl	$1, %eax
	movb	%cl, 71(%rsp)
	setbe	%cl
	cmpl	$4, %edx
	sete	%al
	xorl	%ebx, %ebx
	orl	%eax, %ecx
	leaq	160(%rsp), %rax
	movb	%cl, 70(%rsp)
	movq	%rax, 80(%rsp)
	.p2align 4,,10
	.p2align 3
.L2189:
	cmpb	$0, 71(%rsp)
	jne	.L2175
.L2214:
	cmpl	$12, %edi
	je	.L2212
	cmpl	$3, %edi
	jne	.L2177
	movq	%r12, %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2177
	cmpl	%eax, %ebx
	jge	.L2177
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2184
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2185:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2185
	movl	$1, _vyne_char_pool_ready(%rip)
.L2184:
	movslq	%r8d, %rax
	movl	$3, %edx
	movq	$3, 96(%rsp)
	movq	96(%rsp), %r10
	movzbl	(%r12,%rax), %eax
	leaq	(%rcx,%rax,2), %rax
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2181:
	andq	%rsi, %r10
	movl	$1, %r8d
	movq	%rbp, %r9
	orq	%rdx, %r10
	movq	%r10, %rax
.L2190:
	movq	%rcx, 152(%rsp)
	movq	80(%rsp), %rcx
	leaq	144(%rsp), %rdx
	movq	%r8, 128(%rsp)
	leaq	128(%rsp), %r8
	movq	%r9, 136(%rsp)
	movl	$29, %r9d
	movq	%rax, 144(%rsp)
	call	vyne_binop_slow
	movq	160(%rsp), %r9
	movq	168(%rsp), %r10
	movl	%r9d, %r8d
	movq	%r10, %rcx
	.p2align 4,,10
	.p2align 3
.L2186:
	movq	%r9, %rax
	movl	%r8d, %edx
	andq	%rsi, %rax
	orq	%rdx, %rax
	cmpb	$0, 70(%rsp)
	jne	.L2213
	addq	$1, %rbx
	cmpq	%rbx, %r13
	jne	.L2189
.L2170:
	movq	256(%rsp), %rax
	movq	$2, (%rax)
	movq	$0, 8(%rax)
	addq	$184, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2211:
	movq	56(%r8), %r13
	jmp	.L2174
	.p2align 4,,10
	.p2align 3
.L2177:
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	jmp	.L2181
	.p2align 4,,10
	.p2align 3
.L2213:
	movq	%rax, 160(%rsp)
	movq	80(%rsp), %rax
	movq	%rbx, %r9
	movl	$2, %r8d
	movq	%rcx, 168(%rsp)
	movq	72(%rsp), %rdx
	addq	$1, %rbx
	movq	%rax, 32(%rsp)
	movl	92(%rsp), %ecx
	call	vyne_array_set.isra.0
	cmpq	%rbx, %r13
	je	.L2170
	cmpb	$0, 71(%rsp)
	je	.L2214
.L2175:
	cmpl	$4, %edi
	je	.L2215
	cmpq	8(%r12), %rbx
	jge	.L2177
	movq	(%r12), %rax
	movq	(%rax,%rbx,8), %rcx
	.p2align 4,,10
	.p2align 3
.L2182:
	vmovq	%rcx, %xmm3
	vmovq	%rbp, %xmm2
	movl	$1, %r8d
	movq	$1, 48(%rsp)
	vaddsd	%xmm3, %xmm2, %xmm1
	movq	48(%rsp), %r9
	vmovq	%xmm1, %rcx
	jmp	.L2186
	.p2align 4,,10
	.p2align 3
.L2212:
	cmpq	8(%r12), %rbx
	jge	.L2177
	movq	(%r12), %rax
	movl	$2, %edx
	movq	$2, 112(%rsp)
	movq	112(%rsp), %r10
	movq	(%rax,%rbx,8), %rcx
	jmp	.L2181
	.p2align 4,,10
	.p2align 3
.L2215:
	movslq	8(%r12), %rax
	cmpq	%rax, %rbx
	jge	.L2177
	movq	%rbx, %rdx
	movl	$1, %r8d
	movq	%rbp, %r9
	salq	$4, %rdx
	addq	(%r12), %rdx
	movq	(%rdx), %rax
	movl	(%rdx), %r11d
	movq	8(%rdx), %rcx
	andq	%rsi, %rax
	orq	%r11, %rax
	cmpl	$1, %r11d
	je	.L2182
	jmp	.L2190
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_add_scalar_native
	.def	fn_vlin_k_add_scalar_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_add_scalar_native
fn_vlin_k_add_scalar_native:
	.seh_endprologue
	testq	%r9, %r9
	jle	.L2217
	cmpq	$1, %r9
	je	.L2227
	leaq	-8(%rcx), %rax
	subq	%rdx, %rax
	cmpq	$16, %rax
	jbe	.L2227
	leaq	-1(%r9), %rax
	movq	%r9, %r8
	cmpq	$2, %rax
	jbe	.L2228
	shrq	$2, %r8
	vbroadcastsd	%xmm2, %ymm1
	xorl	%eax, %eax
	salq	$5, %r8
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2220:
	vaddpd	(%rdx,%rax), %ymm1, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%r8, %rax
	jne	.L2220
	movq	%r9, %rax
	andq	$-4, %rax
	cmpq	%rax, %r9
	movq	%rax, %r10
	je	.L2237
	subq	%rax, %r9
	cmpq	$1, %r9
	movq	%r9, %r8
	je	.L2239
	vzeroupper
.L2219:
	vmovddup	%xmm2, %xmm0
	vaddpd	(%rdx,%r10,8), %xmm0, %xmm0
	testb	$1, %r8b
	vmovupd	%xmm0, (%rcx,%r10,8)
	je	.L2217
	andq	$-2, %r8
	addq	%r8, %rax
.L2222:
	vaddsd	(%rdx,%rax,8), %xmm2, %xmm2
	vmovsd	%xmm2, (%rcx,%rax,8)
.L2217:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2237:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2227:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2224:
	vaddsd	(%rdx,%rax,8), %xmm2, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r9
	jne	.L2224
	xorl	%eax, %eax
	ret
.L2228:
	xorl	%r10d, %r10d
	xorl	%eax, %eax
	jmp	.L2219
.L2239:
	vzeroupper
	jmp	.L2222
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_fill
	.def	fn_vlin_k_fill;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_fill
fn_vlin_k_fill:
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
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L2242
	cmpl	$1, %edx
	movq	(%r8), %rax
	movq	8(%r8), %r14
	je	.L2242
	cmpl	$1, 16(%r8)
	movq	24(%r8), %rdi
	je	.L2244
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rdi, %xmm0, %xmm0
	vmovq	%xmm0, %rdi
.L2244:
	cmpl	$2, %edx
	je	.L2242
	cmpl	$2, 32(%r8)
	je	.L2265
	vcvttsd2siq	40(%r8), %rsi
.L2246:
	testq	%rsi, %rsi
	jle	.L2242
	leal	-11(%rax), %edx
	movl	%eax, %ebp
	cmpl	$1, %edx
	jbe	.L2247
	cmpl	$4, %eax
	je	.L2247
	xorl	%eax, %eax
	testb	$1, %sil
	je	.L2248
	cmpq	$1, %rsi
	movl	$1, %eax
	je	.L2242
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2248:
	addq	$2, %rax
	cmpq	%rax, %rsi
	jne	.L2248
.L2242:
	movq	%rbx, %rax
	movq	$2, (%rbx)
	movq	$0, 8(%rbx)
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
.L2247:
	xorl	%r15d, %r15d
	leaq	48(%rsp), %r13
	.p2align 4,,10
	.p2align 3
.L2250:
	movq	%r13, 32(%rsp)
	movl	$1, %eax
	movq	%r15, %r9
	movq	%r14, %rdx
	movl	$2, %r8d
	movl	%ebp, %ecx
	addq	$1, %r15
	movq	%rax, 48(%rsp)
	movq	%rdi, 56(%rsp)
	call	vyne_array_set.isra.0
	cmpq	%r15, %rsi
	jne	.L2250
	jmp	.L2242
	.p2align 4,,10
	.p2align 3
.L2265:
	movq	40(%r8), %rsi
	jmp	.L2246
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_fill_native
	.def	fn_vlin_k_fill_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_fill_native
fn_vlin_k_fill_native:
	.seh_endprologue
	testq	%r8, %r8
	jle	.L2267
	leaq	-1(%r8), %rax
	cmpq	$2, %rax
	jbe	.L2271
	movq	%r8, %r9
	vbroadcastsd	%xmm1, %ymm0
	movq	%rcx, %rax
	shrq	$2, %r9
	salq	$5, %r9
	leaq	(%r9,%rcx), %rdx
	andl	$32, %r9d
	je	.L2269
	leaq	32(%rcx), %rax
	vmovupd	%ymm0, (%rcx)
	cmpq	%rdx, %rax
	je	.L2278
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2269:
	vmovupd	%ymm0, (%rax)
	addq	$64, %rax
	vmovupd	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L2269
.L2278:
	movq	%r8, %rax
	andq	$-4, %rax
	testb	$3, %r8b
	je	.L2280
	vzeroupper
.L2268:
	leaq	1(%rax), %rdx
	vmovsd	%xmm1, (%rcx,%rax,8)
	cmpq	%rdx, %r8
	jle	.L2267
	leaq	2(%rax), %rdx
	vmovsd	%xmm1, 8(%rcx,%rax,8)
	cmpq	%rdx, %r8
	jle	.L2267
	vmovsd	%xmm1, 16(%rcx,%rax,8)
.L2267:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2280:
	vzeroupper
	xorl	%eax, %eax
	ret
.L2271:
	xorl	%eax, %eax
	jmp	.L2268
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_copy
	.def	fn_vlin_k_copy;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_copy
fn_vlin_k_copy:
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
	testl	%edx, %edx
	movq	%rcx, %r12
	jle	.L2283
	movq	8(%r8), %rsi
	cmpl	$1, %edx
	movq	(%r8), %rax
	movq	%rsi, 48(%rsp)
	je	.L2283
	cmpl	$2, %edx
	movq	16(%r8), %rbx
	movq	24(%r8), %r14
	je	.L2283
	cmpl	$2, 32(%r8)
	je	.L2310
	vcvttsd2siq	40(%r8), %rbp
.L2285:
	testq	%rbp, %rbp
	jle	.L2283
	cmpl	$11, %ebx
	movl	%eax, 60(%rsp)
	movabsq	$-4294967296, %r15
	sete	%dil
	cmpl	$4, %ebx
	sete	%dl
	orl	%edx, %edi
	leal	-11(%rax), %edx
	cmpl	$1, %edx
	setbe	%sil
	cmpl	$4, %eax
	sete	%al
	xorl	%r13d, %r13d
	orl	%eax, %esi
	.p2align 4,,10
	.p2align 3
.L2297:
	testb	%dil, %dil
	jne	.L2286
	cmpl	$12, %ebx
	je	.L2311
	cmpl	$3, %ebx
	jne	.L2288
	movq	%r14, %rcx
	call	strlen
	testl	%r13d, %r13d
	js	.L2288
	cmpl	%eax, %r13d
	jge	.L2288
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%r13d, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2293
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2294:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2294
	movl	$1, _vyne_char_pool_ready(%rip)
.L2293:
	movq	$3, 64(%rsp)
	movslq	%r8d, %rax
	movq	64(%rsp), %r10
	movl	$3, %r8d
	movzbl	(%r14,%rax), %eax
	leaq	(%rcx,%rax,2), %rcx
	.p2align 4,,10
	.p2align 3
.L2292:
	movq	%r10, %rax
	movl	%r8d, %edx
	andq	%r15, %rax
	orq	%rdx, %rax
	testb	%sil, %sil
	jne	.L2312
	addq	$1, %r13
	cmpq	%r13, %rbp
	jne	.L2297
.L2283:
	movq	%r12, %rax
	movq	$2, (%r12)
	movq	$0, 8(%r12)
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
.L2286:
	cmpl	$4, %ebx
	je	.L2313
	cmpq	8(%r14), %r13
	jl	.L2314
	.p2align 4,,10
	.p2align 3
.L2288:
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	jmp	.L2292
	.p2align 4,,10
	.p2align 3
.L2312:
	movq	%rax, 112(%rsp)
	leaq	112(%rsp), %rax
	movq	48(%rsp), %rdx
	movq	%r13, %r9
	movq	%rax, 32(%rsp)
	movl	$2, %r8d
	addq	$1, %r13
	movq	%rcx, 120(%rsp)
	movl	60(%rsp), %ecx
	call	vyne_array_set.isra.0
	cmpq	%r13, %rbp
	jne	.L2297
	jmp	.L2283
	.p2align 4,,10
	.p2align 3
.L2311:
	cmpq	8(%r14), %r13
	jge	.L2288
	movq	(%r14), %rax
	movl	$2, %r8d
	movq	$2, 96(%rsp)
	movq	96(%rsp), %r10
	movq	(%rax,%r13,8), %rcx
	jmp	.L2292
	.p2align 4,,10
	.p2align 3
.L2313:
	movslq	8(%r14), %rax
	cmpq	%rax, %r13
	jge	.L2288
	movq	%r13, %rcx
	salq	$4, %rcx
	addq	(%r14), %rcx
	movq	(%rcx), %r10
	movl	(%rcx), %r8d
	movq	8(%rcx), %rcx
	jmp	.L2292
	.p2align 4,,10
	.p2align 3
.L2314:
	movq	(%r14), %rax
	movl	$1, %r8d
	movq	$1, 80(%rsp)
	movq	80(%rsp), %r10
	movq	(%rax,%r13,8), %rcx
	jmp	.L2292
.L2310:
	movq	40(%r8), %rbp
	jmp	.L2285
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_copy_native
	.def	fn_vlin_k_copy_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_copy_native
fn_vlin_k_copy_native:
	.seh_endprologue
	testq	%r8, %r8
	jle	.L2316
	leaq	-1(%r8), %rax
	cmpq	$2, %rax
	jbe	.L2323
	leaq	-8(%rcx), %rax
	subq	%rdx, %rax
	cmpq	$16, %rax
	jbe	.L2323
	movq	%r8, %r9
	xorl	%eax, %eax
	shrq	$2, %r9
	salq	$5, %r9
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2318:
	vmovupd	(%rdx,%rax), %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%r9, %rax
	jne	.L2318
	movq	%r8, %rax
	andq	$-4, %rax
	testb	$3, %r8b
	je	.L2328
	vmovsd	(%rdx,%rax,8), %xmm0
	leaq	1(%rax), %r9
	cmpq	%r9, %r8
	vmovsd	%xmm0, (%rcx,%rax,8)
	jle	.L2328
	vmovsd	(%rdx,%r9,8), %xmm0
	addq	$2, %rax
	cmpq	%rax, %r8
	vmovsd	%xmm0, (%rcx,%r9,8)
	jle	.L2328
	vmovsd	8(%rdx,%r9,8), %xmm0
	vmovsd	%xmm0, 8(%rcx,%r9,8)
	vzeroupper
.L2316:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2328:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2323:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2320:
	vmovsd	(%rdx,%rax,8), %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r8
	jne	.L2320
	xorl	%eax, %eax
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_neg
	.def	fn_vlin_k_neg;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_neg
fn_vlin_k_neg:
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
	subq	$184, %rsp
	.seh_stackalloc	184
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L2331
	movq	8(%r8), %rdi
	cmpl	$1, %edx
	movq	(%r8), %rax
	movq	%rdi, 80(%rsp)
	je	.L2331
	cmpl	$2, %edx
	movq	16(%r8), %rdi
	movq	24(%r8), %rbp
	je	.L2331
	cmpl	$2, 32(%r8)
	je	.L2366
	vcvttsd2siq	40(%r8), %r15
.L2333:
	testq	%r15, %r15
	jle	.L2331
	cmpl	$11, %edi
	movl	%eax, 92(%rsp)
	movabsq	$-4294967296, %rsi
	sete	%r14b
	cmpl	$4, %edi
	sete	%dl
	orl	%edx, %r14d
	leal	-11(%rax), %edx
	cmpl	$1, %edx
	setbe	%r12b
	cmpl	$4, %eax
	sete	%al
	xorl	%ebx, %ebx
	orl	%eax, %r12d
	.p2align 4,,10
	.p2align 3
.L2348:
	testb	%r14b, %r14b
	jne	.L2334
	cmpl	$12, %edi
	je	.L2367
	cmpl	$3, %edi
	jne	.L2336
	movq	%rbp, %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2336
	cmpl	%eax, %ebx
	jge	.L2336
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2343
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2344:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2344
	movl	$1, _vyne_char_pool_ready(%rip)
.L2343:
	movslq	%r8d, %rax
	movl	$3, %edx
	movq	$3, 96(%rsp)
	movq	96(%rsp), %r8
	movzbl	0(%rbp,%rax), %eax
	leaq	(%rcx,%rax,2), %rax
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L2340:
	andq	%rsi, %r8
	movl	$1, %r11d
	movq	$0, 56(%rsp)
	orq	%rdx, %r8
	movq	%r8, %rax
.L2349:
	movq	%rcx, 136(%rsp)
	movl	$30, %r9d
	leaq	128(%rsp), %r8
	leaq	160(%rsp), %rcx
	leaq	144(%rsp), %rdx
	movq	%r11, 144(%rsp)
	movq	$0, 152(%rsp)
	movq	%rax, 128(%rsp)
	call	vyne_binop_slow
	movq	160(%rsp), %r9
	movq	168(%rsp), %r10
	movl	%r9d, %r8d
	movq	%r10, %rcx
	.p2align 4,,10
	.p2align 3
.L2345:
	movq	%r9, %rax
	movl	%r8d, %edx
	andq	%rsi, %rax
	orq	%rdx, %rax
	testb	%r12b, %r12b
	jne	.L2368
	addq	$1, %rbx
	cmpq	%rbx, %r15
	jne	.L2348
.L2331:
	movq	%r13, %rax
	movq	$2, 0(%r13)
	movq	$0, 8(%r13)
	addq	$184, %rsp
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
.L2334:
	cmpl	$4, %edi
	je	.L2369
	cmpq	8(%rbp), %rbx
	jl	.L2370
	.p2align 4,,10
	.p2align 3
.L2336:
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	jmp	.L2340
	.p2align 4,,10
	.p2align 3
.L2368:
	movq	%rax, 160(%rsp)
	leaq	160(%rsp), %rax
	movq	80(%rsp), %rdx
	movq	%rbx, %r9
	movq	%rax, 32(%rsp)
	movl	$2, %r8d
	addq	$1, %rbx
	movq	%rcx, 168(%rsp)
	movl	92(%rsp), %ecx
	call	vyne_array_set.isra.0
	cmpq	%rbx, %r15
	jne	.L2348
	jmp	.L2331
	.p2align 4,,10
	.p2align 3
.L2367:
	cmpq	8(%rbp), %rbx
	jge	.L2336
	movq	0(%rbp), %rax
	movl	$2, %edx
	movq	$2, 112(%rsp)
	movq	112(%rsp), %r8
	movq	(%rax,%rbx,8), %rcx
	jmp	.L2340
	.p2align 4,,10
	.p2align 3
.L2369:
	movslq	8(%rbp), %rax
	cmpq	%rax, %rbx
	jge	.L2336
	movq	%rbx, %rdx
	movl	$1, %r11d
	movq	$0, 56(%rsp)
	salq	$4, %rdx
	addq	0(%rbp), %rdx
	movq	(%rdx), %rax
	movl	(%rdx), %r10d
	movq	8(%rdx), %rcx
	andq	%rsi, %rax
	orq	%r10, %rax
	cmpl	$1, %r10d
	jne	.L2349
.L2341:
	vmovq	%rcx, %xmm2
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$1, %r8d
	movq	$1, 64(%rsp)
	vsubsd	%xmm2, %xmm0, %xmm1
	movq	64(%rsp), %r9
	vmovq	%xmm1, %rcx
	jmp	.L2345
	.p2align 4,,10
	.p2align 3
.L2370:
	movq	0(%rbp), %rax
	movq	(%rax,%rbx,8), %rcx
	jmp	.L2341
.L2366:
	movq	40(%r8), %r15
	jmp	.L2333
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_neg_native
	.def	fn_vlin_k_neg_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_neg_native
fn_vlin_k_neg_native:
	.seh_endprologue
	testq	%r8, %r8
	jle	.L2372
	cmpq	$1, %r8
	je	.L2382
	leaq	-8(%rcx), %rax
	subq	%rdx, %rax
	cmpq	$16, %rax
	jbe	.L2382
	leaq	-1(%r8), %rax
	movq	%r8, %r9
	cmpq	$2, %rax
	jbe	.L2383
	shrq	$2, %r9
	xorl	%eax, %eax
	vxorpd	%xmm1, %xmm1, %xmm1
	salq	$5, %r9
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2375:
	vsubpd	(%rdx,%rax), %ymm1, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%r9, %rax
	jne	.L2375
	movq	%r8, %rax
	andq	$-4, %rax
	cmpq	%rax, %r8
	movq	%rax, %r10
	je	.L2392
	subq	%rax, %r8
	cmpq	$1, %r8
	movq	%r8, %r9
	je	.L2394
	vzeroupper
.L2374:
	vxorpd	%xmm0, %xmm0, %xmm0
	vsubpd	(%rdx,%r10,8), %xmm0, %xmm0
	testb	$1, %r9b
	vmovupd	%xmm0, (%rcx,%r10,8)
	je	.L2372
	andq	$-2, %r9
	addq	%r9, %rax
.L2377:
	vxorpd	%xmm0, %xmm0, %xmm0
	vsubsd	(%rdx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
.L2372:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2392:
	vzeroupper
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L2382:
	xorl	%eax, %eax
	vxorpd	%xmm1, %xmm1, %xmm1
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2379:
	vsubsd	(%rdx,%rax,8), %xmm1, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r8
	jne	.L2379
	xorl	%eax, %eax
	ret
.L2383:
	xorl	%r10d, %r10d
	xorl	%eax, %eax
	jmp	.L2374
.L2394:
	vzeroupper
	jmp	.L2377
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_sum
	.def	fn_vlin_k_sum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_sum
fn_vlin_k_sum:
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
	vmovaps	%xmm6, 128(%rsp)
	.seh_savexmm	%xmm6, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L2398
	cmpl	$1, %edx
	movq	(%r8), %r12
	movq	8(%r8), %r13
	je	.L2398
	cmpl	$2, 16(%r8)
	je	.L2435
	vcvttsd2siq	24(%r8), %rax
	movq	%rax, 32(%rsp)
.L2400:
	cmpq	$0, 32(%rsp)
	jle	.L2398
	cmpl	$11, %r12d
	vxorps	%xmm6, %xmm6, %xmm6
	movq	%rbp, 224(%rsp)
	movabsq	$-4294967296, %rsi
	sete	%dil
	cmpl	$4, %r12d
	sete	%al
	xorl	%r8d, %r8d
	xorl	%ebp, %ebp
	orl	%eax, %edi
	.p2align 4,,10
	.p2align 3
.L2414:
	testb	%dil, %dil
	jne	.L2401
	cmpl	$12, %r12d
	je	.L2436
	cmpl	$3, %r12d
	jne	.L2403
	movq	%r13, %rcx
	movq	%r8, 40(%rsp)
	call	strlen
	testl	%ebp, %ebp
	movq	40(%rsp), %r8
	js	.L2403
	cmpl	%eax, %ebp
	jge	.L2403
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebp, %r9d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2410
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2411:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2411
	movl	$1, _vyne_char_pool_ready(%rip)
.L2410:
	movslq	%r9d, %rax
	movl	$3, %edx
	movq	$3, 48(%rsp)
	movq	48(%rsp), %r10
	movzbl	0(%r13,%rax), %eax
	leaq	(%rcx,%rax,2), %rax
	movq	%rax, %r9
	.p2align 4,,10
	.p2align 3
.L2407:
	andq	%rsi, %r10
	movl	$1, %ecx
	movq	%r8, %rbx
	orq	%rdx, %r10
	movq	%r10, %rax
.L2415:
	movq	%rcx, 96(%rsp)
	leaq	80(%rsp), %r8
	leaq	96(%rsp), %rdx
	movq	%r9, 88(%rsp)
	leaq	112(%rsp), %rcx
	movl	$29, %r9d
	movq	%rbx, 104(%rsp)
	movq	%rax, 80(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 112(%rsp)
	movq	120(%rsp), %r8
	je	.L2413
	vcvtsi2sdq	120(%rsp), %xmm6, %xmm0
	vmovq	%xmm0, %r8
.L2413:
	addq	$1, %rbp
	cmpq	%rbp, 32(%rsp)
	jne	.L2414
.L2434:
	movq	224(%rsp), %rbp
	jmp	.L2397
	.p2align 4,,10
	.p2align 3
.L2398:
	xorl	%r8d, %r8d
.L2397:
	movq	$1, 0(%rbp)
	movq	%rbp, %rax
	movq	%r8, 8(%rbp)
	vmovaps	128(%rsp), %xmm6
	addq	$152, %rsp
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
.L2437:
	movslq	8(%r13), %rax
	cmpq	%rax, %rbp
	jge	.L2403
	movq	%rbp, %rdx
	movl	$1, %ecx
	movq	%r8, %rbx
	salq	$4, %rdx
	addq	0(%r13), %rdx
	movq	(%rdx), %rax
	movl	(%rdx), %r11d
	movq	8(%rdx), %r9
	andq	%rsi, %rax
	orq	%r11, %rax
	cmpl	$1, %r11d
	jne	.L2415
.L2408:
	vmovq	%r8, %xmm3
	vmovq	%r9, %xmm4
	addq	$1, %rbp
	cmpq	%rbp, 32(%rsp)
	vaddsd	%xmm4, %xmm3, %xmm2
	vmovq	%xmm2, %r8
	je	.L2434
.L2401:
	cmpl	$4, %r12d
	je	.L2437
	cmpq	8(%r13), %rbp
	jge	.L2403
	movq	0(%r13), %rax
	movq	(%rax,%rbp,8), %r9
	jmp	.L2408
	.p2align 4,,10
	.p2align 3
.L2403:
	xorl	%r10d, %r10d
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	jmp	.L2407
	.p2align 4,,10
	.p2align 3
.L2436:
	cmpq	8(%r13), %rbp
	jge	.L2403
	movq	0(%r13), %rax
	movl	$2, %edx
	movq	$2, 64(%rsp)
	movq	64(%rsp), %r10
	movq	(%rax,%rbp,8), %r9
	jmp	.L2407
.L2435:
	movq	24(%r8), %rax
	movq	%rax, 32(%rsp)
	jmp	.L2400
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_sum_native
	.def	fn_vlin_k_sum_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_sum_native
fn_vlin_k_sum_native:
	.seh_endprologue
	testq	%rdx, %rdx
	movq	%rcx, %r8
	jle	.L2444
	leaq	-1(%rdx), %rax
	cmpq	$2, %rax
	jbe	.L2445
	movq	%rcx, %rax
	movq	%rdx, %rcx
	vxorpd	%xmm0, %xmm0, %xmm0
	shrq	$2, %rcx
	salq	$5, %rcx
	addq	%r8, %rcx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2441:
	vaddsd	(%rax), %xmm0, %xmm0
	addq	$32, %rax
	vaddsd	-24(%rax), %xmm0, %xmm0
	vaddsd	-16(%rax), %xmm0, %xmm0
	vaddsd	-8(%rax), %xmm0, %xmm0
	cmpq	%rcx, %rax
	jne	.L2441
	movq	%rdx, %rax
	andq	$-4, %rax
	testb	$3, %dl
	je	.L2438
.L2440:
	leaq	1(%rax), %rcx
	vaddsd	(%r8,%rax,8), %xmm0, %xmm0
	cmpq	%rcx, %rdx
	jle	.L2438
	leaq	2(%rax), %rcx
	vaddsd	8(%r8,%rax,8), %xmm0, %xmm0
	cmpq	%rcx, %rdx
	jle	.L2438
	vaddsd	16(%r8,%rax,8), %xmm0, %xmm0
.L2438:
	ret
	.p2align 4,,10
	.p2align 3
.L2444:
	vxorpd	%xmm0, %xmm0, %xmm0
	ret
.L2445:
	xorl	%eax, %eax
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L2440
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_dot
	.def	fn_vlin_k_dot;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_dot
fn_vlin_k_dot:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	vmovaps	%xmm7, 256(%rsp)
	.seh_savexmm	%xmm7, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L2450
	movq	8(%r8), %rax
	cmpl	$1, %edx
	movq	(%r8), %rcx
	movq	%rax, 136(%rsp)
	je	.L2450
	cmpl	$2, %edx
	vmovdqu	16(%r8), %xmm6
	je	.L2450
	cmpl	$2, 32(%r8)
	je	.L2489
	vcvttsd2siq	40(%r8), %rax
	movq	%rax, 120(%rsp)
.L2452:
	cmpq	$0, 120(%rsp)
	jle	.L2450
	cmpl	$11, %ecx
	movq	%rcx, 112(%rsp)
	vxorps	%xmm7, %xmm7, %xmm7
	leaq	224(%rsp), %r12
	sete	%dl
	cmpl	$4, %ecx
	movq	%rbp, 352(%rsp)
	movabsq	$-4294967296, %r13
	sete	%al
	movq	%r12, 96(%rsp)
	xorl	%ebx, %ebx
	xorl	%esi, %esi
	orl	%eax, %edx
	leaq	192(%rsp), %rax
	movb	%dl, 135(%rsp)
	movq	%rax, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L2470:
	cmpb	$0, 135(%rsp)
	jne	.L2453
	cmpl	$12, 112(%rsp)
	je	.L2490
	cmpl	$3, 112(%rsp)
	jne	.L2455
	movq	136(%rsp), %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2455
	cmpl	%eax, %ebx
	jge	.L2455
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2460
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2461:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2461
	movl	$1, _vyne_char_pool_ready(%rip)
.L2460:
	movq	136(%rsp), %rdx
	movslq	%r8d, %rax
	movl	$3, %r12d
	movq	$3, 144(%rsp)
	movq	144(%rsp), %r9
	movzbl	(%rdx,%rax), %eax
	leaq	(%rcx,%rax,2), %rbp
	movq	%rbp, 104(%rsp)
	movq	%rbp, %r10
	.p2align 4,,10
	.p2align 3
.L2459:
	movq	$2, 32(%rsp)
	movq	32(%rsp), %r8
	leaq	208(%rsp), %rdx
	movq	96(%rsp), %rcx
	movq	%r9, 80(%rsp)
	movq	%r8, 192(%rsp)
	movq	56(%rsp), %r8
	movq	%r10, 88(%rsp)
	movq	%rbx, 200(%rsp)
	vmovdqa	%xmm6, 208(%rsp)
	call	vyne_index_get
	movq	80(%rsp), %rax
	movl	%r12d, %edx
	movq	224(%rsp), %rcx
	movq	232(%rsp), %r8
	andq	%r13, %rax
	orq	%rdx, %rax
	cmpl	$2, %r12d
	movq	%rax, %r9
	jne	.L2462
	cmpl	$2, %ecx
	jne	.L2463
	movq	$2, 64(%rsp)
	movq	%rbp, %rcx
	movq	%rsi, %r9
	movq	64(%rsp), %rax
	imulq	%r8, %rcx
	movl	$1, %r8d
	movq	%rax, %r10
	andq	%r13, %r10
	orq	$2, %r10
	movq	%r10, %rax
.L2464:
	movq	%r8, 208(%rsp)
	movq	56(%rsp), %r8
	leaq	208(%rsp), %rdx
	movq	%rcx, 200(%rsp)
	movq	96(%rsp), %rcx
	movq	%r9, 216(%rsp)
	movl	$29, %r9d
	movq	%rax, 192(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 224(%rsp)
	movq	232(%rsp), %rsi
	je	.L2469
	vcvtsi2sdq	232(%rsp), %xmm7, %xmm0
	vmovq	%xmm0, %rsi
.L2469:
	addq	$1, %rbx
	cmpq	%rbx, 120(%rsp)
	jne	.L2470
	movq	352(%rsp), %rbp
	jmp	.L2449
	.p2align 4,,10
	.p2align 3
.L2450:
	xorl	%esi, %esi
.L2449:
	movq	$1, 0(%rbp)
	movq	%rbp, %rax
	movq	%rsi, 8(%rbp)
	vmovaps	240(%rsp), %xmm6
	vmovaps	256(%rsp), %xmm7
	addq	$280, %rsp
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
.L2463:
	movq	%rcx, 192(%rsp)
	movq	96(%rsp), %rcx
	leaq	208(%rsp), %rdx
	movq	%r8, 200(%rsp)
	movq	56(%rsp), %r8
	movq	%r9, 208(%rsp)
	movl	$31, %r9d
	movq	%rbp, 216(%rsp)
	call	vyne_binop_slow
	movq	224(%rsp), %rax
	movl	224(%rsp), %edx
	movq	%rsi, %r9
	vmovsd	232(%rsp), %xmm0
	movl	$1, %r8d
	andq	%r13, %rax
	orq	%rdx, %rax
	cmpl	$1, %edx
	jne	.L2466
.L2465:
	vmovq	%rsi, %xmm4
	vaddsd	%xmm0, %xmm4, %xmm3
	vmovq	%xmm3, %rsi
	jmp	.L2469
	.p2align 4,,10
	.p2align 3
.L2453:
	cmpl	$4, 112(%rsp)
	movq	136(%rsp), %rax
	je	.L2491
	cmpq	8(%rax), %rbx
	jl	.L2492
	.p2align 4,,10
	.p2align 3
.L2455:
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	movq	$0, 104(%rsp)
	jmp	.L2459
	.p2align 4,,10
	.p2align 3
.L2490:
	movq	136(%rsp), %rax
	cmpq	8(%rax), %rbx
	jge	.L2455
	movq	(%rax), %rax
	movl	$2, %r12d
	movq	$2, 176(%rsp)
	movq	176(%rsp), %r9
	movq	(%rax,%rbx,8), %rbp
	movq	%rbp, 104(%rsp)
	movq	%rbp, %r10
	jmp	.L2459
	.p2align 4,,10
	.p2align 3
.L2462:
	cmpl	$1, %ecx
	jne	.L2463
	cmpl	$1, %r12d
	jne	.L2463
	vmovq	%r8, %xmm2
	vmulsd	104(%rsp), %xmm2, %xmm0
	jmp	.L2465
	.p2align 4,,10
	.p2align 3
.L2491:
	movslq	8(%rax), %rax
	cmpq	%rax, %rbx
	jge	.L2455
	movq	136(%rsp), %rax
	movq	%rbx, %rcx
	salq	$4, %rcx
	addq	(%rax), %rcx
	movq	8(%rcx), %rax
	movq	(%rcx), %r9
	movq	8(%rcx), %r10
	movl	(%rcx), %r12d
	movq	%rax, 104(%rsp)
	movq	%rax, %rbp
	jmp	.L2459
	.p2align 4,,10
	.p2align 3
.L2492:
	movq	(%rax), %rax
	movl	$1, %r12d
	movq	$1, 160(%rsp)
	movq	160(%rsp), %r9
	movq	(%rax,%rbx,8), %rbp
	movq	%rbp, 104(%rsp)
	movq	%rbp, %r10
	jmp	.L2459
.L2489:
	movq	40(%r8), %rax
	movq	%rax, 120(%rsp)
	jmp	.L2452
.L2466:
	vmovq	%xmm0, %rcx
	jmp	.L2464
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_dot_native
	.def	fn_vlin_k_dot_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_dot_native
fn_vlin_k_dot_native:
	.seh_endprologue
	testq	%r8, %r8
	jle	.L2501
	leaq	-1(%r8), %rax
	cmpq	$2, %rax
	jbe	.L2502
	movq	%r8, %r9
	xorl	%eax, %eax
	vxorpd	%xmm0, %xmm0, %xmm0
	shrq	$2, %r9
	salq	$5, %r9
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2496:
	vmovupd	(%rdx,%rax), %ymm1
	vmulpd	(%rcx,%rax), %ymm1, %ymm1
	addq	$32, %rax
	cmpq	%rax, %r9
	vaddsd	%xmm1, %xmm0, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm2
	vextractf128	$0x1, %ymm1, %xmm1
	vaddsd	%xmm2, %xmm0, %xmm0
	vaddsd	%xmm1, %xmm0, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	jne	.L2496
	movq	%r8, %rax
	andq	$-4, %rax
	cmpq	%rax, %r8
	movq	%rax, %r9
	je	.L2511
	vzeroupper
.L2495:
	subq	%r9, %r8
	cmpq	$1, %r8
	je	.L2499
	vmovupd	(%rdx,%r9,8), %xmm1
	vmulpd	(%rcx,%r9,8), %xmm1, %xmm1
	testb	$1, %r8b
	vaddsd	%xmm1, %xmm0, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	je	.L2493
	andq	$-2, %r8
	addq	%r8, %rax
.L2499:
	vmovsd	(%rcx,%rax,8), %xmm4
	vfmadd231sd	(%rdx,%rax,8), %xmm4, %xmm0
.L2493:
	ret
	.p2align 4,,10
	.p2align 3
.L2511:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L2501:
	vxorpd	%xmm0, %xmm0, %xmm0
	ret
.L2502:
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L2495
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_norm_sq
	.def	fn_vlin_k_norm_sq;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_norm_sq
fn_vlin_k_norm_sq:
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
	subq	$264, %rsp
	.seh_stackalloc	264
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r9
	jle	.L2515
	movq	8(%r8), %rax
	cmpl	$1, %edx
	movq	(%r8), %rbp
	movq	%rax, 120(%rsp)
	je	.L2515
	cmpl	$2, 16(%r8)
	je	.L2551
	vcvttsd2siq	24(%r8), %rcx
.L2517:
	testq	%rcx, %rcx
	jle	.L2515
	cmpl	$11, %ebp
	leaq	224(%rsp), %r12
	leaq	208(%rsp), %rdi
	movq	%rcx, 136(%rsp)
	sete	%dl
	cmpl	$4, %ebp
	movq	%rdi, 64(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	sete	%al
	xorl	%ebx, %ebx
	xorl	%esi, %esi
	movq	%r9, 336(%rsp)
	orl	%eax, %edx
	movq	%r12, 72(%rsp)
	leaq	192(%rsp), %rax
	movabsq	$-4294967296, %r13
	movb	%dl, 135(%rsp)
	movq	%rax, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L2535:
	cmpb	$0, 135(%rsp)
	jne	.L2518
	cmpl	$12, %ebp
	je	.L2552
	cmpl	$3, %ebp
	jne	.L2520
	movq	120(%rsp), %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2520
	cmpl	%eax, %ebx
	jge	.L2520
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L2525
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2526:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2526
	movl	$1, _vyne_char_pool_ready(%rip)
.L2525:
	movq	120(%rsp), %rdi
	movslq	%r8d, %rax
	movl	$3, %r12d
	movq	$3, 144(%rsp)
	movq	144(%rsp), %r9
	movzbl	(%rdi,%rax), %eax
	leaq	(%rcx,%rax,2), %rdi
	movq	%rdi, 112(%rsp)
	movq	%rdi, %r10
	.p2align 4,,10
	.p2align 3
.L2524:
	movq	120(%rsp), %rax
	movq	64(%rsp), %rdx
	movq	%r9, 96(%rsp)
	movq	$2, 32(%rsp)
	movq	32(%rsp), %r8
	movq	72(%rsp), %rcx
	movq	%rax, 216(%rsp)
	movq	%r8, 192(%rsp)
	movq	56(%rsp), %r8
	movq	%r10, 104(%rsp)
	movq	%rbp, 208(%rsp)
	movq	%rbx, 200(%rsp)
	call	vyne_index_get
	movq	96(%rsp), %rax
	movl	%r12d, %edx
	movq	224(%rsp), %rcx
	movq	232(%rsp), %r8
	andq	%r13, %rax
	orq	%rdx, %rax
	cmpl	$2, %r12d
	movq	%rax, %r9
	jne	.L2527
	cmpl	$2, %ecx
	jne	.L2528
	movq	$2, 80(%rsp)
	imulq	%r8, %rdi
	movq	%rsi, %r9
	movq	80(%rsp), %rax
	movl	$1, %r8d
	movq	%rax, %r10
	andq	%r13, %r10
	movq	%rdi, %rcx
	orq	$2, %r10
	movq	%r10, %rax
.L2529:
	movq	%r8, 208(%rsp)
	movq	64(%rsp), %rdx
	movq	%rcx, 200(%rsp)
	movq	56(%rsp), %r8
	movq	72(%rsp), %rcx
	movq	%r9, 216(%rsp)
	movl	$29, %r9d
	movq	%rax, 192(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 224(%rsp)
	movq	232(%rsp), %rsi
	je	.L2534
	vcvtsi2sdq	232(%rsp), %xmm6, %xmm0
	vmovq	%xmm0, %rsi
.L2534:
	addq	$1, %rbx
	cmpq	%rbx, 136(%rsp)
	jne	.L2535
	movq	336(%rsp), %r9
	jmp	.L2514
	.p2align 4,,10
	.p2align 3
.L2515:
	xorl	%esi, %esi
.L2514:
	movq	$1, (%r9)
	movq	%r9, %rax
	movq	%rsi, 8(%r9)
	vmovaps	240(%rsp), %xmm6
	addq	$264, %rsp
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
.L2528:
	movq	%rcx, 192(%rsp)
	movq	64(%rsp), %rdx
	movq	%r8, 200(%rsp)
	movq	72(%rsp), %rcx
	movq	56(%rsp), %r8
	movq	%r9, 208(%rsp)
	movl	$31, %r9d
	movq	%rdi, 216(%rsp)
	call	vyne_binop_slow
	movq	224(%rsp), %rax
	movl	224(%rsp), %edx
	movq	%rsi, %r9
	vmovsd	232(%rsp), %xmm0
	movl	$1, %r8d
	andq	%r13, %rax
	orq	%rdx, %rax
	cmpl	$1, %edx
	jne	.L2531
.L2530:
	vmovq	%rsi, %xmm4
	vaddsd	%xmm0, %xmm4, %xmm3
	vmovq	%xmm3, %rsi
	jmp	.L2534
	.p2align 4,,10
	.p2align 3
.L2520:
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	xorl	%edi, %edi
	xorl	%r12d, %r12d
	movq	$0, 112(%rsp)
	jmp	.L2524
	.p2align 4,,10
	.p2align 3
.L2518:
	cmpl	$4, %ebp
	movq	120(%rsp), %rax
	je	.L2553
	cmpq	8(%rax), %rbx
	jge	.L2520
	movq	(%rax), %rax
	movl	$1, %r12d
	movq	$1, 160(%rsp)
	movq	160(%rsp), %r9
	movq	(%rax,%rbx,8), %rdi
	movq	%rdi, 112(%rsp)
	movq	%rdi, %r10
	jmp	.L2524
	.p2align 4,,10
	.p2align 3
.L2552:
	movq	120(%rsp), %rax
	cmpq	8(%rax), %rbx
	jge	.L2520
	movq	(%rax), %rax
	movl	$2, %r12d
	movq	$2, 176(%rsp)
	movq	176(%rsp), %r9
	movq	(%rax,%rbx,8), %rdi
	movq	%rdi, 112(%rsp)
	movq	%rdi, %r10
	jmp	.L2524
	.p2align 4,,10
	.p2align 3
.L2527:
	cmpl	$1, %ecx
	jne	.L2528
	cmpl	$1, %r12d
	jne	.L2528
	vmovq	%r8, %xmm2
	vmulsd	112(%rsp), %xmm2, %xmm0
	jmp	.L2530
	.p2align 4,,10
	.p2align 3
.L2553:
	movslq	8(%rax), %rax
	cmpq	%rax, %rbx
	jge	.L2520
	movq	120(%rsp), %rax
	movq	%rbx, %rcx
	salq	$4, %rcx
	addq	(%rax), %rcx
	movq	8(%rcx), %rax
	movq	(%rcx), %r9
	movq	8(%rcx), %r10
	movl	(%rcx), %r12d
	movq	%rax, 112(%rsp)
	movq	%rax, %rdi
	jmp	.L2524
.L2551:
	movq	24(%r8), %rcx
	jmp	.L2517
.L2531:
	vmovq	%xmm0, %rcx
	jmp	.L2529
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_norm_sq_native
	.def	fn_vlin_k_norm_sq_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_norm_sq_native
fn_vlin_k_norm_sq_native:
	.seh_endprologue
	testq	%rdx, %rdx
	jle	.L2560
	leaq	-1(%rdx), %rax
	cmpq	$2, %rax
	jbe	.L2561
	movq	%rdx, %r8
	movq	%rcx, %rax
	vxorpd	%xmm0, %xmm0, %xmm0
	shrq	$2, %r8
	salq	$5, %r8
	addq	%rcx, %r8
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2557:
	vmovupd	(%rax), %ymm1
	addq	$32, %rax
	cmpq	%r8, %rax
	vmulpd	%ymm1, %ymm1, %ymm1
	vaddsd	%xmm1, %xmm0, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm2
	vextractf128	$0x1, %ymm1, %xmm1
	vaddsd	%xmm2, %xmm0, %xmm0
	vaddsd	%xmm1, %xmm0, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	jne	.L2557
	movq	%rdx, %rax
	andq	$-4, %rax
	testb	$3, %dl
	je	.L2564
	vzeroupper
.L2556:
	vmovsd	(%rcx,%rax,8), %xmm1
	leaq	1(%rax), %r8
	cmpq	%r8, %rdx
	vfmadd231sd	%xmm1, %xmm1, %xmm0
	jle	.L2554
	vmovsd	8(%rcx,%rax,8), %xmm1
	leaq	2(%rax), %r8
	cmpq	%r8, %rdx
	vfmadd231sd	%xmm1, %xmm1, %xmm0
	jle	.L2554
	vmovsd	16(%rcx,%rax,8), %xmm1
	vfmadd231sd	%xmm1, %xmm1, %xmm0
.L2554:
	ret
	.p2align 4,,10
	.p2align 3
.L2564:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L2560:
	vxorpd	%xmm0, %xmm0, %xmm0
	ret
.L2561:
	xorl	%eax, %eax
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L2556
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_max
	.def	fn_vlin_k_max;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_max
fn_vlin_k_max:
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
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	vmovaps	%xmm7, 96(%rsp)
	.seh_savexmm	%xmm7, 96
	vmovaps	%xmm8, 112(%rsp)
	.seh_savexmm	%xmm8, 112
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L2568
	cmpl	$1, %edx
	vmovdqu	(%r8), %xmm8
	je	.L2568
	cmpl	$2, 16(%r8)
	je	.L2591
	vcvttsd2siq	24(%r8), %r12
.L2570:
	testq	%r12, %r12
	je	.L2568
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	movq	$2, 32(%rsp)
	vxorps	%xmm7, %xmm7, %xmm7
	leaq	64(%rsp), %rcx
	vmovdqa	%xmm8, 48(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_index_get
	cmpl	$1, 64(%rsp)
	je	.L2592
	vcvtsi2sdq	72(%rsp), %xmm7, %xmm6
.L2574:
	cmpq	$1, %r12
	movl	$1, %ebx
	jle	.L2573
	.p2align 4,,10
	.p2align 3
.L2572:
	movl	$2, %eax
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	movq	%rbx, 40(%rsp)
	leaq	64(%rsp), %rcx
	movq	%rax, 32(%rsp)
	vmovdqa	%xmm8, 48(%rsp)
	call	vyne_index_get
	cmpl	$1, 64(%rsp)
	je	.L2593
	vcvtsi2sdq	72(%rsp), %xmm7, %xmm0
	vmaxsd	%xmm6, %xmm0, %xmm1
	addq	$1, %rbx
	cmpq	%rbx, %r12
	vmovapd	%xmm1, %xmm6
	jne	.L2572
.L2573:
	movq	$1, 0(%rbp)
	vmovq	%xmm6, 8(%rbp)
	jmp	.L2567
	.p2align 4,,10
	.p2align 3
.L2568:
	movq	$1, 0(%rbp)
	movq	$0, 8(%rbp)
.L2567:
	vmovaps	80(%rsp), %xmm6
	vmovaps	96(%rsp), %xmm7
	movq	%rbp, %rax
	vmovaps	112(%rsp), %xmm8
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
.L2593:
	vmovsd	72(%rsp), %xmm1
	addq	$1, %rbx
	cmpq	%rbx, %r12
	vmaxsd	%xmm6, %xmm1, %xmm0
	vmovapd	%xmm0, %xmm6
	jne	.L2572
	movq	$1, 0(%rbp)
	vmovq	%xmm6, 8(%rbp)
	jmp	.L2567
	.p2align 4,,10
	.p2align 3
.L2592:
	vmovsd	72(%rsp), %xmm6
	jmp	.L2574
	.p2align 4,,10
	.p2align 3
.L2591:
	movq	24(%r8), %r12
	jmp	.L2570
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_max_native
	.def	fn_vlin_k_max_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_max_native
fn_vlin_k_max_native:
	.seh_endprologue
	vxorpd	%xmm0, %xmm0, %xmm0
	testq	%rdx, %rdx
	je	.L2594
	cmpq	$1, %rdx
	vmovsd	(%rcx), %xmm0
	jle	.L2594
	leaq	8(%rcx), %rax
	leaq	(%rcx,%rdx,8), %rdx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2596:
	vmovsd	(%rax), %xmm1
	addq	$8, %rax
	cmpq	%rax, %rdx
	vmaxsd	%xmm0, %xmm1, %xmm0
	jne	.L2596
.L2594:
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_min
	.def	fn_vlin_k_min;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_min
fn_vlin_k_min:
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
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	vmovaps	%xmm7, 96(%rsp)
	.seh_savexmm	%xmm7, 96
	vmovaps	%xmm8, 112(%rsp)
	.seh_savexmm	%xmm8, 112
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L2603
	cmpl	$1, %edx
	vmovdqu	(%r8), %xmm8
	je	.L2603
	cmpl	$2, 16(%r8)
	je	.L2620
	vcvttsd2siq	24(%r8), %r12
.L2605:
	testq	%r12, %r12
	je	.L2603
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	movq	$2, 32(%rsp)
	vxorps	%xmm7, %xmm7, %xmm7
	leaq	64(%rsp), %rcx
	vmovdqa	%xmm8, 48(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_index_get
	cmpl	$1, 64(%rsp)
	je	.L2621
	vcvtsi2sdq	72(%rsp), %xmm7, %xmm6
.L2609:
	cmpq	$1, %r12
	movl	$1, %ebx
	jle	.L2608
	.p2align 4,,10
	.p2align 3
.L2607:
	movl	$2, %eax
	leaq	32(%rsp), %r8
	leaq	48(%rsp), %rdx
	movq	%rbx, 40(%rsp)
	leaq	64(%rsp), %rcx
	movq	%rax, 32(%rsp)
	vmovdqa	%xmm8, 48(%rsp)
	call	vyne_index_get
	cmpl	$1, 64(%rsp)
	je	.L2622
	addq	$1, %rbx
	vcvtsi2sdq	72(%rsp), %xmm7, %xmm0
	vminsd	%xmm6, %xmm0, %xmm6
	cmpq	%rbx, %r12
	jne	.L2607
.L2608:
	movq	$1, 0(%rbp)
	vmovq	%xmm6, 8(%rbp)
	jmp	.L2602
	.p2align 4,,10
	.p2align 3
.L2603:
	movq	$1, 0(%rbp)
	movq	$0, 8(%rbp)
.L2602:
	vmovaps	80(%rsp), %xmm6
	vmovaps	96(%rsp), %xmm7
	movq	%rbp, %rax
	vmovaps	112(%rsp), %xmm8
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
.L2622:
	vmovsd	72(%rsp), %xmm1
	addq	$1, %rbx
	cmpq	%rbx, %r12
	vminsd	%xmm6, %xmm1, %xmm6
	jne	.L2607
	movq	$1, 0(%rbp)
	vmovq	%xmm6, 8(%rbp)
	jmp	.L2602
	.p2align 4,,10
	.p2align 3
.L2621:
	vmovsd	72(%rsp), %xmm6
	jmp	.L2609
	.p2align 4,,10
	.p2align 3
.L2620:
	movq	24(%r8), %r12
	jmp	.L2605
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_min_native
	.def	fn_vlin_k_min_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_min_native
fn_vlin_k_min_native:
	.seh_endprologue
	vxorpd	%xmm1, %xmm1, %xmm1
	testq	%rdx, %rdx
	je	.L2623
	cmpq	$1, %rdx
	vmovsd	(%rcx), %xmm1
	jle	.L2623
	leaq	8(%rcx), %rax
	leaq	(%rcx,%rdx,8), %rdx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2627:
	vmovsd	(%rax), %xmm2
	addq	$8, %rax
	cmpq	%rax, %rdx
	vminsd	%xmm1, %xmm2, %xmm0
	vmovapd	%xmm0, %xmm1
	jne	.L2627
.L2623:
	vmovapd	%xmm1, %xmm0
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_matmul
	.def	fn_vlin_k_matmul;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_matmul
fn_vlin_k_matmul:
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
	subq	$392, %rsp
	.seh_stackalloc	392
	vmovaps	%xmm6, 368(%rsp)
	.seh_savexmm	%xmm6, 368
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rsi
	movq	%r8, %rax
	jle	.L2635
	movq	(%r8), %rdi
	cmpl	$1, %edx
	movq	%rdi, 176(%rsp)
	movq	8(%r8), %rdi
	je	.L2635
	movq	16(%r8), %rbx
	cmpl	$2, %edx
	movq	%rbx, 88(%rsp)
	movq	24(%r8), %rbx
	movq	%rbx, 160(%rsp)
	je	.L2635
	movq	32(%r8), %rbx
	cmpl	$3, %edx
	movq	%rbx, 96(%rsp)
	movq	40(%r8), %rbx
	movq	%rbx, 136(%rsp)
	je	.L2635
	cmpl	$2, 48(%r8)
	je	.L2721
	vcvttsd2siq	56(%r8), %r8
.L2637:
	cmpl	$4, %edx
	je	.L2635
	cmpl	$2, 64(%rax)
	je	.L2722
	vcvttsd2siq	72(%rax), %rbx
	movq	%rbx, 120(%rsp)
.L2639:
	cmpl	$5, %edx
	je	.L2635
	cmpl	$2, 80(%rax)
	je	.L2723
	vcvttsd2siq	88(%rax), %rax
	movq	%rax, 112(%rsp)
.L2641:
	testq	%r8, %r8
	jle	.L2635
	cmpq	$0, 112(%rsp)
	jle	.L2635
	movq	%r8, 312(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%r13d, %r13d
	xorl	%ebx, %ebx
	movq	%rsi, 464(%rsp)
	movabsq	$-4294967296, %r14
	leaq	_vyne_char_pool(%rip), %r15
	movq	$0, 128(%rsp)
	movq	%rdi, 288(%rsp)
.L2643:
	movq	176(%rsp), %rax
	movq	%rbx, 296(%rsp)
	movq	%r13, %rsi
	movq	$0, 104(%rsp)
	cmpl	$11, %eax
	movq	%r13, 304(%rsp)
	sete	%dil
	cmpl	$4, %eax
	sete	%al
	orl	%eax, %edi
	movb	%dil, 191(%rsp)
	.p2align 4,,10
	.p2align 3
.L2682:
	xorl	%r13d, %r13d
	cmpq	$0, 120(%rsp)
	jle	.L2681
	movq	96(%rsp), %rax
	movq	%rsi, 168(%rsp)
	cmpl	$11, %eax
	sete	%dl
	cmpl	$4, %eax
	sete	%al
	orl	%eax, %edx
	movq	88(%rsp), %rax
	movb	%dl, 190(%rsp)
	cmpl	$11, %eax
	sete	%dl
	cmpl	$4, %eax
	sete	%al
	xorl	%r13d, %r13d
	xorl	%esi, %esi
	orl	%eax, %edx
	movb	%dl, 189(%rsp)
	.p2align 4,,10
	.p2align 3
.L2672:
	movq	128(%rsp), %rax
	cmpb	$0, 189(%rsp)
	leaq	(%rax,%rsi), %rbx
	jne	.L2644
	cmpl	$12, 88(%rsp)
	je	.L2724
	cmpl	$3, 88(%rsp)
	jne	.L2646
	movq	160(%rsp), %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2646
	cmpl	%eax, %ebx
	jge	.L2646
	movl	_vyne_char_pool_ready(%rip), %edx
	testl	%edx, %edx
	jne	.L2651
	movl	$1, %eax
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2652:
	leaq	1(%rax), %rdx
	movb	%al, (%r15,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%r15,%rdx,2)
	movb	%al, (%r15,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2652
	movl	$1, _vyne_char_pool_ready(%rip)
.L2651:
	movq	160(%rsp), %rax
	movslq	%ebx, %rbx
	movl	$3, %edi
	movq	$3, 192(%rsp)
	movzbl	(%rax,%rbx), %eax
	leaq	(%r15,%rax,2), %r12
	movq	192(%rsp), %rax
	movq	%r12, 72(%rsp)
	movq	%r12, %rbp
	movq	%rax, 64(%rsp)
	.p2align 4,,10
	.p2align 3
.L2650:
	movq	112(%rsp), %rbx
	imulq	%rsi, %rbx
	addq	104(%rsp), %rbx
	cmpb	$0, 190(%rsp)
	jne	.L2653
	cmpl	$12, 96(%rsp)
	je	.L2725
	cmpl	$3, 96(%rsp)
	jne	.L2655
	movq	136(%rsp), %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L2655
	cmpl	%eax, %ebx
	jge	.L2655
	movl	_vyne_char_pool_ready(%rip), %eax
	testl	%eax, %eax
	jne	.L2664
	movl	$1, %eax
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2665:
	leaq	1(%rax), %rdx
	movb	%al, (%r15,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%r15,%rdx,2)
	movb	%al, (%r15,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2665
	movl	$1, _vyne_char_pool_ready(%rip)
.L2664:
	movq	136(%rsp), %rax
	movslq	%ebx, %rbx
	movl	$3, %r10d
	movq	$3, 208(%rsp)
	movq	208(%rsp), %rcx
	movzbl	(%rax,%rbx), %eax
	leaq	(%r15,%rax,2), %r8
	movq	%r8, %r9
	.p2align 4,,10
	.p2align 3
.L2659:
	movq	64(%rsp), %rax
	andq	%r14, %rcx
	movl	%edi, %edx
	movl	%r10d, %r11d
	orq	%r11, %rcx
	andq	%r14, %rax
	orq	%rdx, %rax
	cmpl	$2, %edi
	je	.L2663
.L2661:
	cmpl	$1, %edi
	jne	.L2663
	cmpl	$1, %r10d
	jne	.L2663
	vmovq	%r12, %xmm2
	vmovq	%r8, %xmm3
	vmulsd	%xmm3, %xmm2, %xmm0
	.p2align 4,,10
	.p2align 3
.L2667:
	vmovq	%r13, %xmm5
	vaddsd	%xmm0, %xmm5, %xmm4
	vmovq	%xmm4, %r13
	.p2align 4,,10
	.p2align 3
.L2671:
	addq	$1, %rsi
	cmpq	%rsi, 120(%rsp)
	jg	.L2672
	movq	168(%rsp), %rsi
.L2681:
	cmpb	$0, 191(%rsp)
	movq	$1, 144(%rsp)
	movq	144(%rsp), %rax
	jne	.L2673
	cmpl	$12, 176(%rsp)
	je	.L2726
.L2674:
	addq	$1, 104(%rsp)
	addq	$1, %rsi
	movq	104(%rsp), %rax
	cmpq	%rax, 112(%rsp)
	jne	.L2682
	movq	296(%rsp), %rbx
	movq	304(%rsp), %r13
	movq	120(%rsp), %rsi
	addq	112(%rsp), %r13
	addq	%rsi, 128(%rsp)
	addq	$1, %rbx
	cmpq	%rbx, 312(%rsp)
	jne	.L2643
	movq	464(%rsp), %rsi
.L2635:
	movq	$2, (%rsi)
	movq	%rsi, %rax
	movq	$0, 8(%rsi)
	vmovaps	368(%rsp), %xmm6
	addq	$392, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2721:
	movq	56(%r8), %r8
	jmp	.L2637
	.p2align 4,,10
	.p2align 3
.L2727:
	movslq	8(%rax), %rax
	cmpq	%rax, %rbx
	jge	.L2655
	movq	136(%rsp), %rax
	salq	$4, %rbx
	movl	%edi, %edx
	movq	%rbx, %r11
	addq	(%rax), %r11
	movq	64(%rsp), %rax
	movq	(%r11), %rcx
	movl	(%r11), %ebx
	andq	%r14, %rax
	movq	8(%r11), %r9
	andq	%r14, %rcx
	orq	%rdx, %rax
	movq	%rbx, %r10
	orq	%rbx, %rcx
	cmpl	$2, %edi
	movq	%r9, %r8
	jne	.L2661
	cmpl	$2, %ebx
	je	.L2662
	.p2align 4,,10
	.p2align 3
.L2663:
	movq	%rbp, 344(%rsp)
	leaq	352(%rsp), %rdi
	leaq	320(%rsp), %r12
	leaq	336(%rsp), %rbp
	movq	%rcx, 320(%rsp)
	movq	%r12, %r8
	movq	%rdi, %rcx
	movq	%r9, 328(%rsp)
	movq	%rbp, %rdx
	movl	$31, %r9d
	movq	%rax, 336(%rsp)
	call	vyne_binop_slow
	movq	352(%rsp), %rcx
	movl	352(%rsp), %r9d
	movq	%r13, %r11
	movq	$1, 32(%rsp)
	movq	32(%rsp), %r10
	vmovsd	360(%rsp), %xmm0
	andq	%r14, %rcx
	orq	%r9, %rcx
	cmpl	$1, %r9d
	je	.L2667
	vmovq	%xmm0, %rax
	jmp	.L2666
	.p2align 4,,10
	.p2align 3
.L2655:
	xorl	%ecx, %ecx
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	xorl	%r10d, %r10d
	jmp	.L2659
	.p2align 4,,10
	.p2align 3
.L2646:
	movq	$0, 64(%rsp)
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	xorl	%edi, %edi
	movq	$0, 72(%rsp)
	jmp	.L2650
	.p2align 4,,10
	.p2align 3
.L2653:
	cmpl	$4, 96(%rsp)
	movq	136(%rsp), %rax
	je	.L2727
	cmpq	8(%rax), %rbx
	jge	.L2655
	movq	(%rax), %rax
	movl	$1, %r10d
	movq	$1, 240(%rsp)
	movq	240(%rsp), %rcx
	movq	(%rax,%rbx,8), %r8
	movq	%r8, %r9
	jmp	.L2659
	.p2align 4,,10
	.p2align 3
.L2644:
	cmpl	$4, 88(%rsp)
	movq	160(%rsp), %rax
	je	.L2728
	cmpq	8(%rax), %rbx
	jge	.L2646
	movq	(%rax), %rax
	movl	$1, %edi
	movq	$1, 224(%rsp)
	movq	(%rax,%rbx,8), %r12
	movq	224(%rsp), %rax
	movq	%r12, 72(%rsp)
	movq	%r12, %rbp
	movq	%rax, 64(%rsp)
	jmp	.L2650
	.p2align 4,,10
	.p2align 3
.L2724:
	movq	160(%rsp), %rax
	cmpq	8(%rax), %rbx
	jge	.L2646
	movq	(%rax), %rax
	movl	$2, %edi
	movq	$2, 256(%rsp)
	movq	(%rax,%rbx,8), %rbp
	movq	256(%rsp), %rax
	movq	%rbp, 72(%rsp)
	movq	%rbp, %r12
	movq	%rax, 64(%rsp)
	jmp	.L2650
	.p2align 4,,10
	.p2align 3
.L2725:
	movq	136(%rsp), %rax
	cmpq	8(%rax), %rbx
	jge	.L2655
	movq	(%rax), %rax
	movl	%edi, %edx
	movq	$2, 272(%rsp)
	movq	272(%rsp), %rcx
	movq	(%rax,%rbx,8), %r9
	movq	64(%rsp), %rax
	andq	%r14, %rcx
	andq	%r14, %rax
	orq	$2, %rcx
	orq	%rdx, %rax
	cmpl	$2, %edi
	jne	.L2663
	.p2align 4,,10
	.p2align 3
.L2662:
	movq	$2, 48(%rsp)
	movq	48(%rsp), %rcx
	movq	%r9, %rax
	movq	%r13, %r11
	movq	$1, 32(%rsp)
	movq	32(%rsp), %r10
	imulq	%rbp, %rax
	leaq	352(%rsp), %rdi
	movq	%rcx, %rdx
	leaq	320(%rsp), %r12
	leaq	336(%rsp), %rbp
	andq	%r14, %rdx
	orq	$2, %rdx
	movq	%rdx, %rcx
.L2666:
	movq	%rcx, 320(%rsp)
	movl	$29, %r9d
	movq	%r12, %r8
	movq	%rbp, %rdx
	movq	%rdi, %rcx
	movq	%r10, 336(%rsp)
	movq	%r11, 344(%rsp)
	movq	%rax, 328(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 352(%rsp)
	movq	360(%rsp), %r13
	je	.L2671
	vcvtsi2sdq	360(%rsp), %xmm6, %xmm0
	vmovq	%xmm0, %r13
	jmp	.L2671
	.p2align 4,,10
	.p2align 3
.L2728:
	movslq	8(%rax), %rax
	cmpq	%rax, %rbx
	jge	.L2646
	movq	160(%rsp), %rax
	salq	$4, %rbx
	addq	(%rax), %rbx
	vmovdqu	(%rbx), %xmm2
	movq	8(%rbx), %r12
	movl	(%rbx), %edi
	vmovdqa	%xmm2, 64(%rsp)
	movq	%r12, %rbp
	jmp	.L2650
	.p2align 4,,10
	.p2align 3
.L2673:
	cmpl	$4, 176(%rsp)
	je	.L2729
	movq	288(%rsp), %rax
	cmpq	%rsi, 8(%rax)
	jle	.L2674
	movq	(%rax), %rax
	movq	%r13, (%rax,%rsi,8)
	jmp	.L2674
	.p2align 4,,10
	.p2align 3
.L2726:
	movq	288(%rsp), %rax
	cmpq	%rsi, 8(%rax)
	jle	.L2674
	vmovq	%r13, %xmm3
	movq	(%rax), %rax
	vcvttsd2siq	%xmm3, %rdx
	movq	%rdx, (%rax,%rsi,8)
	jmp	.L2674
.L2729:
	movq	288(%rsp), %rdi
	movslq	8(%rdi), %rcx
	cmpq	%rsi, %rcx
	jle	.L2674
	movq	%rsi, %rcx
	salq	$4, %rcx
	addq	(%rdi), %rcx
	movq	%rax, (%rcx)
	movq	%r13, 8(%rcx)
	jmp	.L2674
.L2722:
	movq	72(%rax), %rbx
	movq	%rbx, 120(%rsp)
	jmp	.L2639
.L2723:
	movq	88(%rax), %rax
	movq	%rax, 112(%rsp)
	jmp	.L2641
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_matmul_native
	.def	fn_vlin_k_matmul_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_matmul_native
fn_vlin_k_matmul_native:
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
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	144(%rsp), %rbx
	testq	%r9, %r9
	movq	%rcx, 112(%rsp)
	movq	%rdx, %r12
	movq	%r8, %r13
	movq	%r9, 136(%rsp)
	movq	152(%rsp), %rcx
	jle	.L2731
	testq	%rcx, %rcx
	jle	.L2731
	movq	%rdx, %rbp
	movq	%rbx, %rdx
	movq	%rcx, %r9
	movq	%rbx, %rsi
	shrq	%rdx
	salq	$4, %r9
	xorl	%r14d, %r14d
	xorl	%r15d, %r15d
	salq	$4, %rdx
	leaq	0(,%rbx,8), %rax
	andq	$-2, %rsi
	movq	%rdx, 24(%rsp)
	movq	%rax, 16(%rsp)
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L2732:
	movq	112(%rsp), %rdi
	testq	%rbx, %rbx
	leaq	(%rdi,%rax,8), %rdi
	jle	.L2740
	movq	24(%rsp), %rdx
	movq	%r15, 8(%rsp)
	movq	%r13, %r11
	xorl	%r10d, %r10d
	movq	%rax, %r15
	leaq	(%rdx,%rbp), %r8
	.p2align 4,,10
	.p2align 3
.L2737:
	cmpq	$1, %rbx
	je	.L2739
	movq	%rsi, (%rsp)
.L2735:
	movq	%rbp, %rdx
	movq	%r11, %rax
	vxorpd	%xmm1, %xmm1, %xmm1
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2734:
	vmovsd	(%rax), %xmm0
	vmovhpd	(%rax,%rcx,8), %xmm0, %xmm0
	vmulpd	(%rdx), %xmm0, %xmm0
	addq	$16, %rdx
	addq	%r9, %rax
	cmpq	%rdx, %r8
	vaddsd	%xmm0, %xmm1, %xmm1
	vunpckhpd	%xmm0, %xmm0, %xmm0
	vaddsd	%xmm0, %xmm1, %xmm1
	jne	.L2734
	cmpq	%rsi, %rbx
	je	.L2748
	movq	(%rsp), %rdx
.L2733:
	movq	%rcx, %rax
	addq	$8, %r11
	imulq	%rdx, %rax
	addq	%r14, %rdx
	addq	%r10, %rax
	vmovsd	0(%r13,%rax,8), %xmm3
	vfmadd231sd	(%r12,%rdx,8), %xmm3, %xmm1
	vmovsd	%xmm1, (%rdi,%r10,8)
	addq	$1, %r10
	cmpq	%r10, %rcx
	jne	.L2737
.L2747:
	movq	%r15, %rax
	movq	8(%rsp), %r15
.L2736:
	addq	$1, %r15
	addq	%rcx, %rax
	addq	%rbx, %r14
	addq	16(%rsp), %rbp
	cmpq	%r15, 136(%rsp)
	jne	.L2732
.L2731:
	xorl	%eax, %eax
	addq	$40, %rsp
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
.L2748:
	vmovsd	%xmm1, (%rdi,%r10,8)
	addq	$1, %r10
	addq	$8, %r11
	cmpq	%r10, %rcx
	jne	.L2735
	jmp	.L2747
.L2739:
	xorl	%edx, %edx
	vxorpd	%xmm1, %xmm1, %xmm1
	jmp	.L2733
.L2740:
	xorl	%edx, %edx
.L2738:
	leaq	1(%rdx), %r8
	movq	$0x000000000, (%rdi,%rdx,8)
	cmpq	%rcx, %r8
	je	.L2736
	addq	$2, %rdx
	movq	$0x000000000, (%rdi,%r8,8)
	cmpq	%rdx, %rcx
	jne	.L2738
	jmp	.L2736
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_matmul_trans_b
	.def	fn_vlin_k_matmul_trans_b;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_matmul_trans_b
fn_vlin_k_matmul_trans_b:
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
	subq	$408, %rsp
	.seh_stackalloc	408
	vmovaps	%xmm6, 384(%rsp)
	.seh_savexmm	%xmm6, 384
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	movq	%r8, %rax
	jle	.L2752
	movq	(%r8), %rsi
	cmpl	$1, %edx
	movq	%rsi, 184(%rsp)
	movq	8(%r8), %rsi
	movq	%rsi, 304(%rsp)
	je	.L2752
	movq	16(%r8), %rsi
	cmpl	$2, %edx
	movq	%rsi, 96(%rsp)
	movq	24(%r8), %rsi
	movq	%rsi, 152(%rsp)
	je	.L2752
	movq	32(%r8), %rsi
	cmpl	$3, %edx
	movq	%rsi, 104(%rsp)
	movq	40(%r8), %rsi
	movq	%rsi, 144(%rsp)
	je	.L2752
	cmpl	$2, 48(%r8)
	je	.L2838
	vcvttsd2siq	56(%r8), %r14
.L2754:
	cmpl	$4, %edx
	je	.L2752
	cmpl	$2, 64(%rax)
	je	.L2839
	vcvttsd2siq	72(%rax), %rsi
.L2756:
	cmpl	$5, %edx
	je	.L2752
	cmpl	$2, 80(%rax)
	je	.L2840
	vcvttsd2siq	88(%rax), %r12
.L2758:
	testq	%r14, %r14
	jle	.L2752
	testq	%r12, %r12
	jle	.L2752
	movq	%r14, 320(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%r13d, %r13d
	movabsq	$-4294967296, %rbp
	movq	%r12, 328(%rsp)
	leaq	_vyne_char_pool(%rip), %r15
	xorl	%r12d, %r12d
	movq	$0, 200(%rsp)
	movq	%rbx, 480(%rsp)
	movq	%rsi, %rbx
.L2760:
	movq	184(%rsp), %rax
	movq	%rbx, 120(%rsp)
	movq	%r13, %rsi
	movq	%r12, 312(%rsp)
	cmpl	$11, %eax
	sete	%dl
	cmpl	$4, %eax
	sete	%al
	orl	%eax, %edx
	movq	328(%rsp), %rax
	movb	%dl, 199(%rsp)
	addq	%r13, %rax
	movq	%rax, 176(%rsp)
	.p2align 4,,10
	.p2align 3
.L2799:
	xorl	%r11d, %r11d
	testq	%rbx, %rbx
	jle	.L2798
	movq	104(%rsp), %rax
	movq	120(%rsp), %r14
	movq	%rbx, 160(%rsp)
	movq	$0x000000000, 56(%rsp)
	subq	%rbx, %r14
	cmpl	$11, %eax
	movq	%rsi, 168(%rsp)
	sete	%dl
	cmpl	$4, %eax
	sete	%al
	orl	%eax, %edx
	movq	96(%rsp), %rax
	movb	%dl, 198(%rsp)
	cmpl	$11, %eax
	sete	%dl
	cmpl	$4, %eax
	sete	%al
	orl	%eax, %edx
	movq	200(%rsp), %rax
	movb	%dl, 197(%rsp)
	movq	%rax, 112(%rsp)
	.p2align 4,,10
	.p2align 3
.L2789:
	cmpb	$0, 197(%rsp)
	jne	.L2761
	cmpl	$12, 96(%rsp)
	je	.L2841
	cmpl	$3, 96(%rsp)
	jne	.L2763
	movq	152(%rsp), %rcx
	call	strlen
	movq	112(%rsp), %rbx
	testl	%ebx, %ebx
	js	.L2763
	cmpl	%eax, %ebx
	jge	.L2763
	movl	_vyne_char_pool_ready(%rip), %edx
	movl	%ebx, %ecx
	testl	%edx, %edx
	jne	.L2768
	movl	$1, %eax
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2769:
	leaq	1(%rax), %rdx
	movb	%al, (%r15,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%r15,%rdx,2)
	movb	%al, (%r15,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2769
	movl	$1, _vyne_char_pool_ready(%rip)
.L2768:
	movq	152(%rsp), %rbx
	movslq	%ecx, %rax
	movl	$3, %esi
	movq	$3, 208(%rsp)
	movzbl	(%rbx,%rax), %eax
	leaq	(%r15,%rax,2), %r12
	movq	208(%rsp), %rax
	movq	%r12, 88(%rsp)
	movq	%r12, %rdi
	movq	%rax, 80(%rsp)
.L2767:
	cmpb	$0, 198(%rsp)
	jne	.L2770
.L2844:
	cmpl	$12, 104(%rsp)
	je	.L2842
	cmpl	$3, 104(%rsp)
	jne	.L2772
	movq	144(%rsp), %rcx
	call	strlen
	testl	%r14d, %r14d
	js	.L2772
	cmpl	%eax, %r14d
	jge	.L2772
	movl	_vyne_char_pool_ready(%rip), %eax
	movslq	%r14d, %rcx
	testl	%eax, %eax
	jne	.L2781
	movl	$1, %eax
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2782:
	leaq	1(%rax), %rdx
	movb	%al, (%r15,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%r15,%rdx,2)
	movb	%al, (%r15,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2782
	movl	$1, _vyne_char_pool_ready(%rip)
.L2781:
	movq	144(%rsp), %rax
	movl	$3, %r13d
	movq	$3, 224(%rsp)
	movq	224(%rsp), %r10
	movzbl	(%rax,%rcx), %eax
	leaq	(%r15,%rax,2), %r8
	movq	%r8, %r9
	.p2align 4,,10
	.p2align 3
.L2776:
	movq	80(%rsp), %rax
	andq	%rbp, %r10
	movl	%esi, %edx
	movl	%r13d, %ecx
	orq	%r10, %rcx
	andq	%rbp, %rax
	orq	%rdx, %rax
	cmpl	$2, %esi
	je	.L2780
.L2778:
	cmpl	$1, %esi
	jne	.L2780
	cmpl	$1, %r13d
	jne	.L2780
	vmovq	%r12, %xmm2
	vmovq	%r8, %xmm3
	vmulsd	%xmm3, %xmm2, %xmm0
	.p2align 4,,10
	.p2align 3
.L2784:
	vaddsd	56(%rsp), %xmm0, %xmm4
	vmovsd	%xmm4, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L2788:
	addq	$1, 112(%rsp)
	addq	$1, %r14
	cmpq	%r14, 120(%rsp)
	jne	.L2789
	movq	160(%rsp), %rbx
	movq	56(%rsp), %r11
	movq	168(%rsp), %rsi
.L2798:
	cmpb	$0, 199(%rsp)
	movq	$1, 128(%rsp)
	movq	128(%rsp), %rax
	jne	.L2790
	cmpl	$12, 184(%rsp)
	je	.L2843
.L2791:
	addq	%rbx, 120(%rsp)
	addq	$1, %rsi
	cmpq	%rsi, 176(%rsp)
	jne	.L2799
	movq	312(%rsp), %r12
	addq	%rbx, 200(%rsp)
	addq	$1, %r12
	cmpq	%r12, 320(%rsp)
	je	.L2837
	movq	176(%rsp), %r13
	jmp	.L2760
.L2837:
	movq	480(%rsp), %rbx
.L2752:
	movq	$2, (%rbx)
	movq	%rbx, %rax
	movq	$0, 8(%rbx)
	vmovaps	384(%rsp), %xmm6
	addq	$408, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2838:
	movq	56(%r8), %r14
	jmp	.L2754
	.p2align 4,,10
	.p2align 3
.L2845:
	movslq	8(%rax), %rax
	cmpq	%r14, %rax
	jle	.L2772
	movq	144(%rsp), %rax
	movq	%r14, %r10
	movl	%esi, %edx
	salq	$4, %r10
	addq	(%rax), %r10
	movq	80(%rsp), %rax
	movq	(%r10), %rcx
	movl	(%r10), %r11d
	andq	%rbp, %rax
	movq	8(%r10), %r9
	andq	%rbp, %rcx
	orq	%rdx, %rax
	movq	%r11, %r13
	orq	%r11, %rcx
	cmpl	$2, %esi
	movq	%r9, %r8
	jne	.L2778
	cmpl	$2, %r11d
	je	.L2779
	.p2align 4,,10
	.p2align 3
.L2780:
	movq	%rdi, 360(%rsp)
	leaq	368(%rsp), %rsi
	leaq	336(%rsp), %r12
	leaq	352(%rsp), %rdi
	movq	%rcx, 336(%rsp)
	movq	%r12, %r8
	movq	%rsi, %rcx
	movq	%r9, 344(%rsp)
	movq	%rdi, %rdx
	movl	$31, %r9d
	movq	%rax, 352(%rsp)
	call	vyne_binop_slow
	movq	368(%rsp), %rax
	movq	56(%rsp), %rbx
	movq	$1, 32(%rsp)
	movl	368(%rsp), %edx
	movq	32(%rsp), %rcx
	vmovsd	376(%rsp), %xmm0
	andq	%rbp, %rax
	orq	%rdx, %rax
	cmpl	$1, %edx
	je	.L2784
	vmovq	%xmm0, %r8
	jmp	.L2783
	.p2align 4,,10
	.p2align 3
.L2772:
	xorl	%r10d, %r10d
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	xorl	%r13d, %r13d
	jmp	.L2776
	.p2align 4,,10
	.p2align 3
.L2763:
	movq	$0, 80(%rsp)
	xorl	%edi, %edi
	xorl	%r12d, %r12d
	xorl	%esi, %esi
	cmpb	$0, 198(%rsp)
	movq	$0, 88(%rsp)
	je	.L2844
.L2770:
	cmpl	$4, 104(%rsp)
	movq	144(%rsp), %rax
	je	.L2845
	cmpq	%r14, 8(%rax)
	jle	.L2772
	movq	(%rax), %rax
	movl	$1, %r13d
	movq	$1, 256(%rsp)
	movq	256(%rsp), %r10
	movq	(%rax,%r14,8), %r8
	movq	%r8, %r9
	jmp	.L2776
	.p2align 4,,10
	.p2align 3
.L2761:
	cmpl	$4, 96(%rsp)
	movq	152(%rsp), %rax
	je	.L2846
	movq	112(%rsp), %rbx
	cmpq	%rbx, 8(%rax)
	jle	.L2763
	movq	(%rax), %rax
	movl	$1, %esi
	movq	$1, 240(%rsp)
	movq	(%rax,%rbx,8), %r12
	movq	240(%rsp), %rax
	movq	%r12, 88(%rsp)
	movq	%r12, %rdi
	movq	%rax, 80(%rsp)
	jmp	.L2767
	.p2align 4,,10
	.p2align 3
.L2841:
	movq	152(%rsp), %rax
	movq	112(%rsp), %rbx
	cmpq	%rbx, 8(%rax)
	jle	.L2763
	movq	(%rax), %rax
	movl	$2, %esi
	movq	$2, 272(%rsp)
	movq	(%rax,%rbx,8), %rdi
	movq	272(%rsp), %rax
	movq	%rdi, 88(%rsp)
	movq	%rdi, %r12
	movq	%rax, 80(%rsp)
	jmp	.L2767
	.p2align 4,,10
	.p2align 3
.L2842:
	movq	144(%rsp), %rax
	cmpq	%r14, 8(%rax)
	jle	.L2772
	movq	(%rax), %rax
	movl	%esi, %edx
	movq	$2, 288(%rsp)
	movq	288(%rsp), %r10
	movq	(%rax,%r14,8), %r9
	movq	80(%rsp), %rax
	movq	%r10, %rcx
	andq	%rbp, %rax
	andq	%rbp, %rcx
	orq	%rdx, %rax
	orq	$2, %rcx
	cmpl	$2, %esi
	jne	.L2780
	.p2align 4,,10
	.p2align 3
.L2779:
	movq	$2, 64(%rsp)
	movq	64(%rsp), %rax
	imulq	%r9, %rdi
	leaq	368(%rsp), %rsi
	movq	$1, 32(%rsp)
	movq	56(%rsp), %rbx
	leaq	336(%rsp), %r12
	movq	%rax, %r9
	movq	32(%rsp), %rcx
	andq	%rbp, %r9
	movq	%rdi, %r8
	leaq	352(%rsp), %rdi
	orq	$2, %r9
	movq	%r9, %rax
.L2783:
	movq	%rcx, 352(%rsp)
	movl	$29, %r9d
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	movq	%r8, 344(%rsp)
	movq	%r12, %r8
	movq	%rbx, 360(%rsp)
	movq	%rax, 336(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 368(%rsp)
	je	.L2847
	vcvtsi2sdq	376(%rsp), %xmm6, %xmm0
	vmovlpd	%xmm0, 56(%rsp)
	jmp	.L2788
	.p2align 4,,10
	.p2align 3
.L2847:
	vmovsd	376(%rsp), %xmm1
	vmovsd	%xmm1, 56(%rsp)
	jmp	.L2788
	.p2align 4,,10
	.p2align 3
.L2846:
	movslq	8(%rax), %rax
	cmpq	112(%rsp), %rax
	jle	.L2763
	movq	112(%rsp), %rax
	movq	152(%rsp), %rbx
	salq	$4, %rax
	addq	(%rbx), %rax
	vmovdqu	(%rax), %xmm2
	movq	8(%rax), %r12
	movl	(%rax), %esi
	vmovdqa	%xmm2, 80(%rsp)
	movq	%r12, %rdi
	jmp	.L2767
	.p2align 4,,10
	.p2align 3
.L2790:
	cmpl	$4, 184(%rsp)
	je	.L2848
	movq	304(%rsp), %rax
	cmpq	8(%rax), %rsi
	jge	.L2791
	movq	(%rax), %rax
	movq	%r11, (%rax,%rsi,8)
	jmp	.L2791
	.p2align 4,,10
	.p2align 3
.L2843:
	movq	304(%rsp), %rax
	cmpq	8(%rax), %rsi
	jge	.L2791
	vmovq	%r11, %xmm3
	movq	(%rax), %rax
	vcvttsd2siq	%xmm3, %rdx
	movq	%rdx, (%rax,%rsi,8)
	jmp	.L2791
.L2848:
	movq	304(%rsp), %rdi
	movslq	8(%rdi), %rcx
	cmpq	%rsi, %rcx
	jle	.L2791
	movq	%rsi, %rcx
	salq	$4, %rcx
	addq	(%rdi), %rcx
	movq	%rax, (%rcx)
	movq	%r11, 8(%rcx)
	jmp	.L2791
.L2839:
	movq	72(%rax), %rsi
	jmp	.L2756
.L2840:
	movq	88(%rax), %r12
	jmp	.L2758
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_matmul_trans_b_native
	.def	fn_vlin_k_matmul_trans_b_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_matmul_trans_b_native
fn_vlin_k_matmul_trans_b_native:
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
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	144(%rsp), %r11
	testq	%r9, %r9
	movq	%rcx, %r15
	movq	%rdx, %r13
	movq	%r8, %rsi
	movq	%r9, 136(%rsp)
	jle	.L2850
	cmpq	$0, 152(%rsp)
	jle	.L2850
	movq	152(%rsp), %rax
	movq	%r11, %rdx
	xorl	%edi, %edi
	xorl	%r9d, %r9d
	shrq	$2, %rdx
	leaq	-1(%r11), %r14
	xorl	%r10d, %r10d
	leaq	0(,%rax,8), %rbx
	salq	$5, %rdx
	movq	%rbx, 24(%rsp)
	leaq	(%rcx,%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L2851:
	testq	%r11, %r11
	leaq	(%r15,%r10,8), %r8
	jle	.L2859
	movq	%r10, 8(%rsp)
	leaq	0(%r13,%rdi,8), %rax
	xorl	%ebx, %ebx
	movq	%r9, 16(%rsp)
	.p2align 4,,10
	.p2align 3
.L2858:
	cmpq	$2, %r14
	jbe	.L2861
.L2855:
	leaq	(%rsi,%rbx,8), %r9
	xorl	%ecx, %ecx
	vxorpd	%xmm0, %xmm0, %xmm0
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L2853:
	vmovupd	(%rax,%rcx), %ymm1
	vmulpd	(%r9,%rcx), %ymm1, %ymm2
	addq	$32, %rcx
	cmpq	%rcx, %rdx
	vaddsd	%xmm2, %xmm0, %xmm0
	vunpckhpd	%xmm2, %xmm2, %xmm3
	vextractf128	$0x1, %ymm2, %xmm1
	vaddsd	%xmm0, %xmm3, %xmm3
	vaddsd	%xmm3, %xmm1, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	jne	.L2853
	movq	%r11, %rcx
	andq	$-4, %rcx
	cmpq	%r11, %rcx
	movq	%rcx, %r9
	je	.L2875
.L2852:
	movq	%r11, %r10
	subq	%r9, %r10
	cmpq	$1, %r10
	je	.L2856
	leaq	(%r9,%rdi), %r12
	addq	%rbx, %r9
	testb	$1, %r10b
	vmovupd	(%rsi,%r9,8), %xmm1
	vmulpd	0(%r13,%r12,8), %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	je	.L2857
	andq	$-2, %r10
	addq	%r10, %rcx
.L2856:
	leaq	(%rdi,%rcx), %r9
	addq	%rbx, %rcx
	vmovsd	0(%r13,%r9,8), %xmm4
	vfmadd231sd	(%rsi,%rcx,8), %xmm4, %xmm0
.L2857:
	vmovsd	%xmm0, (%r8)
	addq	$8, %r8
	addq	%r11, %rbx
	cmpq	%r8, %rbp
	jne	.L2858
.L2872:
	movq	8(%rsp), %r10
	movq	16(%rsp), %r9
.L2854:
	addq	$1, %r9
	addq	152(%rsp), %r10
	addq	24(%rsp), %rbp
	addq	%r11, %rdi
	cmpq	%r9, 136(%rsp)
	jne	.L2851
	vzeroupper
.L2850:
	xorl	%eax, %eax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2859:
	leaq	8(%r8), %rax
	movq	$0x000000000, (%r8)
	cmpq	%rax, %rbp
	je	.L2854
	movq	$0x000000000, 8(%r8)
	addq	$16, %r8
	cmpq	%rbp, %r8
	jne	.L2859
	jmp	.L2854
	.p2align 4,,10
	.p2align 3
.L2875:
	vmovsd	%xmm0, (%r8)
	addq	$8, %r8
	cmpq	%r8, %rbp
	je	.L2872
	addq	%r11, %rbx
	jmp	.L2855
.L2861:
	xorl	%r9d, %r9d
	xorl	%ecx, %ecx
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L2852
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_transpose
	.def	fn_vlin_k_transpose;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_transpose
fn_vlin_k_transpose:
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
	testl	%edx, %edx
	movq	%rcx, %rdi
	movl	%edx, %eax
	jle	.L2877
	movq	8(%r8), %rcx
	cmpl	$1, %edx
	movq	(%r8), %r14
	movq	%rcx, 48(%rsp)
	je	.L2877
	cmpl	$2, %edx
	movq	16(%r8), %rbp
	movq	24(%r8), %r10
	je	.L2877
	cmpl	$2, 32(%r8)
	je	.L2923
	vcvttsd2siq	40(%r8), %r13
.L2879:
	cmpl	$3, %eax
	je	.L2877
	cmpl	$2, 48(%r8)
	je	.L2924
	vcvttsd2siq	56(%r8), %r11
.L2881:
	testq	%r13, %r13
	jle	.L2877
	cmpl	$4, %ebp
	sete	%r8b
	cmpl	$11, %ebp
	sete	%al
	orl	%eax, %r8d
	cmpl	$4, %r14d
	sete	%r15b
	cmpl	$11, %r14d
	sete	%al
	orl	%eax, %r15d
	testq	%r11, %r11
	jle	.L2877
	leaq	(%r11,%r11), %rax
	movq	%r11, 80(%rsp)
	movq	%r11, %r12
	xorl	%edx, %edx
	movq	%rdi, 224(%rsp)
	leaq	_vyne_char_pool(%rip), %rbx
	movabsq	$-4294967296, %r9
	movq	%rax, 72(%rsp)
	movq	%r14, %rax
	movl	%r8d, %r14d
	movq	%rax, %r8
	.p2align 4,,10
	.p2align 3
.L2883:
	movq	%r12, %rax
	subq	80(%rsp), %rax
	movq	%rdx, 64(%rsp)
	movq	%rdx, %rdi
	movq	%rax, 56(%rsp)
	movq	%rax, %rsi
	.p2align 4,,10
	.p2align 3
.L2903:
	testb	%r14b, %r14b
	jne	.L2884
	cmpl	$12, %ebp
	je	.L2925
	cmpl	$3, %ebp
	jne	.L2886
	movq	%r10, %rcx
	movq	%r8, 88(%rsp)
	movq	%r10, 32(%rsp)
	call	strlen
	testl	%esi, %esi
	movq	32(%rsp), %r10
	movq	88(%rsp), %r8
	movabsq	$-4294967296, %r9
	js	.L2886
	cmpl	%eax, %esi
	jge	.L2886
	movl	_vyne_char_pool_ready(%rip), %eax
	movslq	%esi, %rcx
	testl	%eax, %eax
	jne	.L2891
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2892:
	leaq	1(%rax), %rdx
	movb	%al, (%rbx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rbx,%rdx,2)
	movb	%al, (%rbx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L2892
	movl	$1, _vyne_char_pool_ready(%rip)
.L2891:
	movzbl	(%r10,%rcx), %eax
	movl	$3, %r11d
	movq	$3, 96(%rsp)
	leaq	(%rbx,%rax,2), %rcx
	movq	96(%rsp), %rax
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	.p2align 4,,10
	.p2align 3
.L2890:
	movq	32(%rsp), %rax
	movl	%r11d, %edx
	movq	%rcx, 40(%rsp)
	andq	%r9, %rax
	orq	%rdx, %rax
	testb	%r15b, %r15b
	movq	%rax, 32(%rsp)
	jne	.L2893
	cmpl	$12, %r8d
	je	.L2926
.L2894:
	addq	$1, %rsi
	addq	%r13, %rdi
	cmpq	%rsi, %r12
	jne	.L2903
	movq	64(%rsp), %rdx
	movq	56(%rsp), %r12
	addq	72(%rsp), %r12
	addq	$1, %rdx
	cmpq	%rdx, %r13
	jne	.L2883
	movq	224(%rsp), %rdi
.L2877:
	movq	%rdi, %rax
	movq	$2, (%rdi)
	movq	$0, 8(%rdi)
	addq	$152, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2924:
	movq	56(%r8), %r11
	jmp	.L2881
	.p2align 4,,10
	.p2align 3
.L2886:
	movq	$0, 32(%rsp)
	xorl	%ecx, %ecx
	xorl	%r11d, %r11d
	movq	$0, 40(%rsp)
	jmp	.L2890
	.p2align 4,,10
	.p2align 3
.L2884:
	cmpl	$4, %ebp
	je	.L2927
	cmpq	%rsi, 8(%r10)
	jle	.L2886
	movq	(%r10), %rax
	movl	$1, %r11d
	movq	$1, 112(%rsp)
	movq	(%rax,%rsi,8), %rcx
	movq	112(%rsp), %rax
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	jmp	.L2890
	.p2align 4,,10
	.p2align 3
.L2893:
	cmpl	$4, %r8d
	movq	48(%rsp), %rax
	je	.L2928
	cmpq	%rdi, 8(%rax)
	jle	.L2894
	cmpl	$1, %r11d
	vmovq	%rcx, %xmm0
	je	.L2900
	cmpl	$2, %r11d
	vxorpd	%xmm0, %xmm0, %xmm0
	jne	.L2900
	vxorpd	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	%rcx, %xmm1, %xmm0
.L2900:
	movq	48(%rsp), %rax
	movq	(%rax), %rax
	vmovsd	%xmm0, (%rax,%rdi,8)
	jmp	.L2894
	.p2align 4,,10
	.p2align 3
.L2926:
	movq	48(%rsp), %rax
	cmpq	%rdi, 8(%rax)
	jle	.L2894
	cmpl	$2, %r11d
	movq	%rcx, %rax
	je	.L2902
	xorl	%eax, %eax
	cmpl	$1, %r11d
	jne	.L2902
	vmovq	%rcx, %xmm2
	vcvttsd2siq	%xmm2, %rax
.L2902:
	movq	48(%rsp), %rcx
	movq	(%rcx), %rdx
	movq	%rax, (%rdx,%rdi,8)
	jmp	.L2894
	.p2align 4,,10
	.p2align 3
.L2925:
	cmpq	%rsi, 8(%r10)
	jle	.L2886
	movq	(%r10), %rax
	movl	$2, %r11d
	movq	$2, 128(%rsp)
	movq	(%rax,%rsi,8), %rcx
	movq	128(%rsp), %rax
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	jmp	.L2890
	.p2align 4,,10
	.p2align 3
.L2927:
	movslq	8(%r10), %rax
	cmpq	%rsi, %rax
	jle	.L2886
	movq	%rsi, %rcx
	salq	$4, %rcx
	addq	(%r10), %rcx
	vmovdqu	(%rcx), %xmm3
	movl	(%rcx), %r11d
	movq	8(%rcx), %rcx
	vmovdqa	%xmm3, 32(%rsp)
	jmp	.L2890
	.p2align 4,,10
	.p2align 3
.L2928:
	movslq	8(%rax), %r11
	cmpq	%rdi, %r11
	jle	.L2894
	movq	%rdi, %r11
	salq	$4, %r11
	addq	(%rax), %r11
	movq	32(%rsp), %rax
	movq	%rcx, 8(%r11)
	movq	%rax, (%r11)
	jmp	.L2894
.L2923:
	movq	40(%r8), %r13
	jmp	.L2879
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_transposed
	.def	fn_vlin_Types_Matrix_transposed;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_transposed
fn_vlin_Types_Matrix_transposed:
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
	testl	%edx, %edx
	movq	%rcx, 224(%rsp)
	jle	.L2930
	cmpl	$6, (%r8)
	jne	.L2930
	movq	8(%r8), %rsi
	movslq	16(%rsi), %rax
	movq	%rsi, 40(%rsp)
	testl	%eax, %eax
	jle	.L2931
	movq	8(%rsi), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L2935
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2932:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L2972
.L2935:
	cmpl	$107, (%rcx)
	jne	.L2932
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L2933
.L2972:
	movq	%rdx, %rcx
	jmp	.L2939
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2938:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L2973
.L2939:
	cmpl	$107, (%rcx)
	jne	.L2938
	vcvttsd2siq	24(%rcx), %r14
	jmp	.L2937
	.p2align 4,,10
	.p2align 3
.L2930:
	leaq	96(%rsp), %rbx
	xorl	%r14d, %r14d
	xorl	%r15d, %r15d
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	96(%rsp), %r13
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	movq	104(%rsp), %rsi
.L2950:
	leaq	112(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movl	$64, %ecx
	call	arena_alloc
	movq	%r13, (%rax)
	movq	%rax, %rdi
	movq	%rsi, 8(%rax)
	call	arena_alloc.constprop.0
	movq	112(%rsp), %rdx
	movq	%rdi, %r8
	movq	%rbx, %rcx
	vmovdqu	120(%rsp), %xmm0
	movq	%rdx, (%rax)
	movl	$4, %edx
	vmovdqu	%xmm0, 8(%rax)
	movq	%rax, 24(%rdi)
	movq	$11, 16(%rdi)
	movq	$2, 32(%rdi)
	movq	%r14, 40(%rdi)
	movq	$2, 48(%rdi)
	movq	%r15, 56(%rdi)
	call	fn_vlin_k_transpose
	leaq	80(%rsp), %rdx
	leaq	48(%rsp), %r9
	movq	%rbx, %rcx
	leaq	64(%rsp), %r8
	movq	%r15, 88(%rsp)
	movq	$2, 80(%rsp)
	movq	$2, 64(%rsp)
	movq	%r14, 72(%rsp)
	movq	%r13, 48(%rsp)
	movq	%rsi, 56(%rsp)
	call	struct_vlin_Types_Matrix
	movq	224(%rsp), %rax
	vmovdqu	96(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	addq	$152, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2936:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L2973
.L2933:
	cmpl	$107, (%r8)
	jne	.L2936
	movq	24(%r8), %r14
	jmp	.L2937
	.p2align 4,,10
	.p2align 3
.L2973:
	xorl	%r14d, %r14d
.L2937:
	movq	%rdx, %rcx
	jmp	.L2943
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2940:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L2948
.L2943:
	cmpl	$109, (%rcx)
	jne	.L2940
	cmpl	$2, 16(%rcx)
	jne	.L2948
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2941:
	cmpl	$109, (%rdx)
	je	.L2974
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L2941
.L2970:
	leaq	96(%rsp), %rbx
	xorl	%r15d, %r15d
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	96(%rsp), %r13
	movq	104(%rsp), %rsi
	.p2align 4,,10
	.p2align 3
.L2951:
	movq	40(%rsp), %rax
	movslq	16(%rax), %rdx
	testl	%edx, %edx
	jle	.L2958
	movq	8(%rax), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L2955
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2954:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L2958
.L2955:
	cmpl	$116, (%rax)
	jne	.L2954
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L2950
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L2947:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L2970
.L2948:
	cmpl	$109, (%rdx)
	jne	.L2947
	vcvttsd2siq	24(%rdx), %r15
	movq	%r15, %rdi
	imulq	%r14, %rdi
.L2945:
	leaq	96(%rsp), %rbx
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	testq	%rdi, %rdi
	movq	96(%rsp), %r13
	movq	104(%rsp), %rsi
	jle	.L2951
	movl	%r13d, %ebp
	xorl	%r12d, %r12d
	.p2align 4,,10
	.p2align 3
.L2953:
	movq	%rbx, %r8
	movq	%rsi, %rdx
	movl	%ebp, %ecx
	addq	$1, %r12
	movq	$1, 96(%rsp)
	movq	$0, 104(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rdi, %r12
	jne	.L2953
	jmp	.L2951
	.p2align 4,,10
	.p2align 3
.L2958:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L2950
.L2974:
	movq	24(%rdx), %r15
	movq	%r15, %rdi
	imulq	%r14, %rdi
	jmp	.L2945
.L2931:
	leaq	96(%rsp), %rbx
	xorl	%r14d, %r14d
	xorl	%r15d, %r15d
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	96(%rsp), %r13
	movq	104(%rsp), %rsi
	jmp	.L2951
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_k_transpose_native
	.def	fn_vlin_k_transpose_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_k_transpose_native
fn_vlin_k_transpose_native:
	pushq	%rbx
	.seh_pushreg	%rbx
	.seh_endprologue
	testq	%r8, %r8
	movq	%r8, %rbx
	jle	.L2976
	testq	%r9, %r9
	jle	.L2976
	leaq	0(,%r9,8), %r8
	leaq	0(,%rbx,8), %r10
	xorl	%r11d, %r11d
	leaq	(%rdx,%r8), %r9
	.p2align 4,,10
	.p2align 3
.L2977:
	movq	%r9, %rax
	movq	%rcx, %rdx
	subq	%r8, %rax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L2978:
	vmovsd	(%rax), %xmm0
	addq	$8, %rax
	vmovsd	%xmm0, (%rdx)
	addq	%r10, %rdx
	cmpq	%r9, %rax
	jne	.L2978
	addq	$1, %r11
	addq	$8, %rcx
	addq	%r8, %r9
	cmpq	%r11, %rbx
	jne	.L2977
.L2976:
	xorl	%eax, %eax
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_zeros_f64
	.def	fn_vlin_zeros_f64;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_zeros_f64
fn_vlin_zeros_f64:
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
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r14
	jle	.L2981
	cmpl	$2, (%r8)
	je	.L2989
	vcvttsd2siq	8(%r8), %rdi
.L2983:
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movl	$4, %r12d
	movq	%rax, %rsi
	call	arena_alloc
	testq	%rdi, %rdi
	movq	%rsi, %r13
	movq	%rax, (%rsi)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rsi)
	jle	.L2985
	xorl	%ebx, %ebx
	leaq	32(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2984:
	movq	%rbp, %r8
	movq	%rsi, %rdx
	movl	$4, %ecx
	addq	$1, %rbx
	movq	$1, 32(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L2984
.L2985:
	movq	%r14, %rax
	movq	%r12, (%r14)
	movq	%r13, 8(%r14)
	addq	$48, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L2989:
	movq	8(%r8), %rdi
	jmp	.L2983
	.p2align 4,,10
	.p2align 3
.L2981:
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movl	$4, %r12d
	movq	%rax, %rbx
	call	arena_alloc
	movq	%rbx, %r13
	movq	%rax, (%rbx)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rbx)
	jmp	.L2985
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_zeros_f64_native
	.def	fn_vlin_zeros_f64_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_zeros_f64_native
fn_vlin_zeros_f64_native:
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
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rdx, %rdi
	movq	%rcx, %r12
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movq	%rax, %rsi
	call	arena_alloc
	testq	%rdi, %rdi
	movq	%rax, (%rsi)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rsi)
	jle	.L2991
	xorl	%ebx, %ebx
	leaq	32(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2992:
	movq	%rbp, %r8
	movq	%rsi, %rdx
	movl	$4, %ecx
	addq	$1, %rbx
	movq	$1, 32(%rsp)
	movq	$0, 40(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L2992
.L2991:
	movq	%rsi, %r8
	movl	$4, %edx
	movq	%r12, %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	%r12, %rax
	addq	$48, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_ones_f64
	.def	fn_vlin_ones_f64;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_ones_f64
fn_vlin_ones_f64:
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
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r14
	jle	.L2995
	cmpl	$2, (%r8)
	je	.L3003
	vcvttsd2siq	8(%r8), %rdi
.L2997:
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movl	$4, %r12d
	movq	%rax, %rsi
	call	arena_alloc
	testq	%rdi, %rdi
	movq	%rsi, %r13
	movq	%rax, (%rsi)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rsi)
	jle	.L2999
	vmovsd	.LC32(%rip), %xmm6
	xorl	%ebx, %ebx
	leaq	32(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2998:
	movq	%rbp, %r8
	movq	%rsi, %rdx
	movl	$4, %ecx
	addq	$1, %rbx
	movq	$1, 32(%rsp)
	vmovq	%xmm6, 40(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L2998
.L2999:
	movq	%r12, (%r14)
	movq	%r14, %rax
	movq	%r13, 8(%r14)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L3003:
	movq	8(%r8), %rdi
	jmp	.L2997
	.p2align 4,,10
	.p2align 3
.L2995:
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movl	$4, %r12d
	movq	%rax, %rbx
	call	arena_alloc
	movq	%rbx, %r13
	movq	%rax, (%rbx)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rbx)
	jmp	.L2999
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_ones_f64_native
	.def	fn_vlin_ones_f64_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_ones_f64_native
fn_vlin_ones_f64_native:
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
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	movq	%rdx, %rdi
	movq	%rcx, %r12
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movq	%rax, %rsi
	call	arena_alloc
	testq	%rdi, %rdi
	movq	%rax, (%rsi)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rsi)
	jle	.L3005
	vmovsd	.LC32(%rip), %xmm6
	xorl	%ebx, %ebx
	leaq	32(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L3006:
	movq	%rbp, %r8
	movq	%rsi, %rdx
	movl	$4, %ecx
	addq	$1, %rbx
	movq	$1, 32(%rsp)
	vmovq	%xmm6, 40(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L3006
.L3005:
	movq	%rsi, %r8
	movl	$4, %edx
	movq	%r12, %rcx
	call	vyne_value_to_array_f64.isra.0
	nop
	vmovaps	48(%rsp), %xmm6
	movq	%r12, %rax
	addq	$64, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_fill_f64
	.def	fn_vlin_fill_f64;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_fill_f64
fn_vlin_fill_f64:
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
	testl	%edx, %edx
	movq	%rcx, 144(%rsp)
	jle	.L3009
	cmpl	$2, (%r8)
	je	.L3021
	vcvttsd2siq	8(%r8), %r14
.L3011:
	xorl	%ebp, %ebp
	cmpl	$1, %edx
	je	.L3012
	cmpl	$1, 16(%r8)
	movq	24(%r8), %rbp
	je	.L3012
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rbp, %xmm0, %xmm0
	vmovq	%xmm0, %rbp
.L3012:
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movl	$4, %r12d
	movq	%rax, %rbx
	call	arena_alloc
	testq	%r14, %r14
	movq	%rbx, %r13
	movq	%rax, (%rbx)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rbx)
	jle	.L3015
	leaq	48(%rsp), %rax
	xorl	%r15d, %r15d
	movq	%rax, 40(%rsp)
	.p2align 4,,10
	.p2align 3
.L3014:
	movl	$1, %r8d
	movq	%rbx, %rdx
	movl	$4, %ecx
	addq	$1, %r15
	movq	%r8, 48(%rsp)
	movq	40(%rsp), %r8
	movq	%rbp, 56(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%r15, %r14
	jne	.L3014
.L3015:
	movq	144(%rsp), %rax
	movq	%r12, (%rax)
	movq	%r13, 8(%rax)
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
.L3021:
	movq	8(%r8), %r14
	jmp	.L3011
	.p2align 4,,10
	.p2align 3
.L3009:
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movl	$4, %r12d
	movq	%rax, %rbx
	call	arena_alloc
	movq	%rbx, %r13
	movq	%rax, (%rbx)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rbx)
	jmp	.L3015
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_fill_f64_native
	.def	fn_vlin_fill_f64_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_fill_f64_native
fn_vlin_fill_f64_native:
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
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	%rdx, %r12
	movq	%rcx, %r15
	vmovq	%xmm2, %r13
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movq	%rax, %rbp
	call	arena_alloc
	testq	%r12, %r12
	movq	%rax, 0(%rbp)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rbp)
	jle	.L3023
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L3024:
	movl	$1, %eax
	leaq	32(%rsp), %r8
	movq	%rbp, %rdx
	addq	$1, %rbx
	movl	$4, %ecx
	movq	%rax, 32(%rsp)
	movq	%r13, 40(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %r12
	jne	.L3024
.L3023:
	movq	%rbp, %r8
	movl	$4, %edx
	movq	%r15, %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	%r15, %rax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_clone_f64
	.def	fn_vlin_clone_f64;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_clone_f64
fn_vlin_clone_f64:
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
	subq	$120, %rsp
	.seh_stackalloc	120
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r9
	jle	.L3027
	cmpl	$1, %edx
	movq	(%r8), %rsi
	movq	8(%r8), %r15
	je	.L3027
	cmpl	$2, 16(%r8)
	je	.L3067
	vcvttsd2siq	24(%r8), %rdi
.L3031:
	leaq	96(%rsp), %rbp
	movq	%r9, 192(%rsp)
	movq	%rbp, %rcx
	call	vyne_array_create.constprop.0
	testq	%rdi, %rdi
	movq	96(%rsp), %rcx
	movq	104(%rsp), %r14
	movq	192(%rsp), %r9
	jle	.L3029
	cmpl	$11, %esi
	movq	%rcx, 40(%rsp)
	movl	%ecx, %r13d
	sete	%r12b
	cmpl	$4, %esi
	sete	%al
	xorl	%ebx, %ebx
	orl	%eax, %r12d
	.p2align 4,,10
	.p2align 3
.L3040:
	testb	%r12b, %r12b
	jne	.L3033
	cmpl	$12, %esi
	je	.L3052
	cmpl	$3, %esi
	jne	.L3036
.L3054:
	movq	%r15, %rcx
	call	strlen
	testl	%ebx, %ebx
	js	.L3036
	cmpl	%eax, %ebx
	jge	.L3036
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%ebx, %r8d
	leaq	_vyne_char_pool(%rip), %rcx
	testl	%eax, %eax
	jne	.L3044
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3045:
	leaq	1(%rax), %rdx
	movb	%al, (%rcx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rcx,%rdx,2)
	movb	%al, (%rcx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L3045
	movl	$1, _vyne_char_pool_ready(%rip)
.L3044:
	movq	$3, 48(%rsp)
	movslq	%r8d, %rax
	addq	$1, %rbx
	movq	%rbp, %r8
	movzbl	(%r15,%rax), %eax
	leaq	(%rcx,%rax,2), %rax
	movl	%r13d, %ecx
	movq	%rax, %rdx
	movq	48(%rsp), %rax
	movq	%rdx, 104(%rsp)
	movq	%r14, %rdx
	movq	%rax, 96(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L3054
.L3064:
	movq	192(%rsp), %r9
	movq	40(%rsp), %rcx
	jmp	.L3029
	.p2align 4,,10
	.p2align 3
.L3027:
	leaq	96(%rsp), %rcx
	movq	%r9, 192(%rsp)
	call	vyne_array_create.constprop.0
	movq	96(%rsp), %rcx
	movq	104(%rsp), %r14
	movq	192(%rsp), %r9
.L3029:
	movq	%r9, %rax
	movq	%rcx, (%r9)
	movq	%r14, 8(%r9)
	addq	$120, %rsp
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
.L3033:
	cmpl	$4, %esi
	je	.L3053
.L3038:
	cmpq	%rbx, 8(%r15)
	jle	.L3036
	movq	(%r15), %rax
	movq	%rbp, %r8
	movl	%r13d, %ecx
	movq	$1, 64(%rsp)
	movq	64(%rsp), %rdx
	movq	(%rax,%rbx,8), %rax
	addq	$1, %rbx
	xchgq	%rdx, %rax
	movq	%rdx, 104(%rsp)
	movq	%r14, %rdx
	movq	%rax, 96(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rdi, %rbx
	je	.L3064
	cmpl	$4, %esi
	jne	.L3038
	.p2align 4,,10
	.p2align 3
.L3053:
	movslq	8(%r15), %rax
	cmpq	%rbx, %rax
	jle	.L3036
.L3039:
	movq	%rbx, %rax
	movq	%rbp, %r8
	movl	%r13d, %ecx
	addq	$1, %rbx
	salq	$4, %rax
	addq	(%r15), %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movq	%rdx, 104(%rsp)
	movq	%r14, %rdx
	movq	%rax, 96(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	je	.L3064
	movslq	8(%r15), %rax
	cmpq	%rbx, %rax
	jg	.L3039
	.p2align 4,,10
	.p2align 3
.L3036:
	movq	%rbp, %r8
	movq	%r14, %rdx
	movl	%r13d, %ecx
	addq	$1, %rbx
	movq	$0, 96(%rsp)
	movq	$0, 104(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L3040
	movq	192(%rsp), %r9
	movq	40(%rsp), %rcx
	jmp	.L3029
	.p2align 4,,10
	.p2align 3
.L3052:
	cmpq	%rbx, 8(%r15)
	jle	.L3036
	movq	(%r15), %rax
	movq	%rbp, %r8
	movl	%r13d, %ecx
	movq	$2, 80(%rsp)
	movq	80(%rsp), %rdx
	movq	(%rax,%rbx,8), %rax
	addq	$1, %rbx
	xchgq	%rdx, %rax
	movq	%rdx, 104(%rsp)
	movq	%r14, %rdx
	movq	%rax, 96(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %rdi
	jne	.L3052
	jmp	.L3064
	.p2align 4,,10
	.p2align 3
.L3067:
	movq	24(%r8), %rdi
	jmp	.L3031
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_clone_f64_native
	.def	fn_vlin_clone_f64_native;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_clone_f64_native
fn_vlin_clone_f64_native:
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
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	%r8, %r12
	movq	%rcx, %r15
	movq	%rdx, %r13
	call	arena_alloc.constprop.2
	movl	$64, %ecx
	movq	%rax, %rbp
	call	arena_alloc
	testq	%r12, %r12
	movq	%rax, 0(%rbp)
	movq	.LC5(%rip), %rax
	movq	%rax, 8(%rbp)
	jle	.L3069
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L3070:
	movq	0(%r13,%rbx,8), %rdx
	movl	$1, %eax
	leaq	32(%rsp), %r8
	movl	$4, %ecx
	addq	$1, %rbx
	movq	%rax, 32(%rsp)
	movq	%rdx, 40(%rsp)
	movq	%rbp, %rdx
	call	vyne_array_push.isra.0
	cmpq	%rbx, %r12
	jne	.L3070
.L3069:
	movq	%rbp, %r8
	movl	$4, %edx
	movq	%r15, %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	%r15, %rax
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_zeros
	.def	fn_vlin_zeros;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_zeros
fn_vlin_zeros:
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
	vmovaps	%xmm6, 128(%rsp)
	.seh_savexmm	%xmm6, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L3077
	cmpl	$2, (%r8)
	je	.L3079
	cmpl	$1, %edx
	vcvttsd2siq	8(%r8), %rdi
	je	.L3078
.L3081:
	cmpl	$2, 16(%r8)
	je	.L3080
	vcvttsd2siq	24(%r8), %rsi
	movq	%rdi, %rdx
	imulq	%rsi, %rdx
.L3073:
	leaq	96(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movq	96(%rsp), %rbp
	vmovdqu	104(%rsp), %xmm6
	call	arena_alloc.constprop.0
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%rbp, (%rax)
	leaq	32(%rsp), %r9
	leaq	48(%rsp), %r8
	vmovdqu	%xmm6, 8(%rax)
	movq	%rax, 40(%rsp)
	movq	$2, 64(%rsp)
	movq	%rdi, 72(%rsp)
	movq	$2, 48(%rsp)
	movq	%rsi, 56(%rsp)
	movq	$11, 32(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	80(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	128(%rsp), %xmm6
	addq	$152, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L3079:
	cmpl	$1, %edx
	movq	8(%r8), %rdi
	jne	.L3081
.L3078:
	xorl	%edx, %edx
	xorl	%esi, %esi
	jmp	.L3073
	.p2align 4,,10
	.p2align 3
.L3077:
	xorl	%edx, %edx
	xorl	%edi, %edi
	xorl	%esi, %esi
	jmp	.L3073
	.p2align 4,,10
	.p2align 3
.L3080:
	movq	24(%r8), %rsi
	movq	%rdi, %rdx
	imulq	%rsi, %rdx
	jmp	.L3073
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_ones
	.def	fn_vlin_ones;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_ones
fn_vlin_ones:
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
	vmovaps	%xmm6, 128(%rsp)
	.seh_savexmm	%xmm6, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L3093
	cmpl	$2, (%r8)
	je	.L3094
	cmpl	$1, %edx
	vcvttsd2siq	8(%r8), %r15
	je	.L3095
.L3087:
	cmpl	$2, 16(%r8)
	je	.L3096
	vcvttsd2siq	24(%r8), %r14
.L3089:
	movq	%r15, %r12
	leaq	80(%rsp), %rsi
	imulq	%r14, %r12
	movq	%rsi, %rcx
	call	vyne_array_create.constprop.0
	movq	88(%rsp), %rbp
	movl	80(%rsp), %edi
	testq	%r12, %r12
	jle	.L3084
	vmovsd	.LC32(%rip), %xmm6
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L3091:
	movq	%rsi, %r8
	movq	%rbp, %rdx
	movl	%edi, %ecx
	addq	$1, %rbx
	movq	$1, 80(%rsp)
	vmovq	%xmm6, 88(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%rbx, %r12
	jne	.L3091
.L3084:
	leaq	96(%rsp), %rcx
	movq	%rbp, %r8
	movl	%edi, %edx
	call	vyne_value_to_array_f64.isra.0
	movq	96(%rsp), %rbx
	vmovdqu	104(%rsp), %xmm6
	call	arena_alloc.constprop.0
	leaq	64(%rsp), %rdx
	leaq	32(%rsp), %r9
	movq	%rsi, %rcx
	movq	%rbx, (%rax)
	leaq	48(%rsp), %r8
	vmovdqu	%xmm6, 8(%rax)
	movq	%rax, 40(%rsp)
	movq	$2, 64(%rsp)
	movq	%r15, 72(%rsp)
	movq	$2, 48(%rsp)
	movq	%r14, 56(%rsp)
	movq	$11, 32(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	80(%rsp), %xmm0
	movq	%r13, %rax
	vmovdqu	%xmm0, 0(%r13)
	vmovaps	128(%rsp), %xmm6
	addq	$152, %rsp
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
.L3094:
	cmpl	$1, %edx
	movq	8(%r8), %r15
	jne	.L3087
.L3095:
	leaq	80(%rsp), %rsi
	xorl	%r14d, %r14d
	movq	%rsi, %rcx
	call	vyne_array_create.constprop.0
	movq	88(%rsp), %rbp
	movl	80(%rsp), %edi
	jmp	.L3084
	.p2align 4,,10
	.p2align 3
.L3093:
	leaq	80(%rsp), %rsi
	xorl	%r14d, %r14d
	xorl	%r15d, %r15d
	movq	%rsi, %rcx
	call	vyne_array_create.constprop.0
	movq	88(%rsp), %rbp
	movl	80(%rsp), %edi
	jmp	.L3084
	.p2align 4,,10
	.p2align 3
.L3096:
	movq	24(%r8), %r14
	jmp	.L3089
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_full
	.def	fn_vlin_full;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_full
fn_vlin_full:
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
	subq	$168, %rsp
	.seh_stackalloc	168
	vmovaps	%xmm6, 144(%rsp)
	.seh_savexmm	%xmm6, 144
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 240(%rsp)
	jle	.L3111
	cmpl	$2, (%r8)
	je	.L3112
	vcvttsd2siq	8(%r8), %rax
	cmpl	$1, %edx
	movq	%rax, 32(%rsp)
	je	.L3113
.L3102:
	cmpl	$2, 16(%r8)
	je	.L3114
	vcvttsd2siq	24(%r8), %rax
	movq	%rax, 40(%rsp)
.L3104:
	cmpl	$2, %edx
	je	.L3109
	cmpl	$1, 32(%r8)
	movq	40(%r8), %r13
	je	.L3105
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%r13, %xmm0, %xmm0
	vmovq	%xmm0, %r13
.L3105:
	movq	32(%rsp), %r14
	imulq	40(%rsp), %r14
	leaq	96(%rsp), %rbx
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	104(%rsp), %r12
	movl	96(%rsp), %ebp
	testq	%r14, %r14
	jle	.L3099
	xorl	%r15d, %r15d
	.p2align 4,,10
	.p2align 3
.L3108:
	movl	$1, %r8d
	movq	%r12, %rdx
	movl	%ebp, %ecx
	addq	$1, %r15
	movq	%r8, 96(%rsp)
	movq	%rbx, %r8
	movq	%r13, 104(%rsp)
	call	vyne_array_push.isra.0
	cmpq	%r15, %r14
	jne	.L3108
.L3099:
	leaq	112(%rsp), %rcx
	movq	%r12, %r8
	movl	%ebp, %edx
	call	vyne_value_to_array_f64.isra.0
	movq	112(%rsp), %rsi
	vmovdqu	120(%rsp), %xmm6
	call	arena_alloc.constprop.0
	movq	32(%rsp), %rdi
	leaq	80(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, (%rax)
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	vmovdqu	%xmm6, 8(%rax)
	movq	%rdi, 88(%rsp)
	movq	40(%rsp), %rdi
	movq	%rax, 56(%rsp)
	movq	$2, 80(%rsp)
	movq	$2, 64(%rsp)
	movq	%rdi, 72(%rsp)
	movq	$11, 48(%rsp)
	call	struct_vlin_Types_Matrix
	movq	240(%rsp), %rax
	vmovdqu	96(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	vmovaps	144(%rsp), %xmm6
	addq	$168, %rsp
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
.L3112:
	movq	8(%r8), %rax
	cmpl	$1, %edx
	movq	%rax, 32(%rsp)
	jne	.L3102
.L3113:
	leaq	96(%rsp), %rbx
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	104(%rsp), %r12
	movl	96(%rsp), %ebp
	movq	$0, 40(%rsp)
	jmp	.L3099
	.p2align 4,,10
	.p2align 3
.L3111:
	leaq	96(%rsp), %rbx
	movq	%rbx, %rcx
	call	vyne_array_create.constprop.0
	movq	104(%rsp), %r12
	movl	96(%rsp), %ebp
	movq	$0, 40(%rsp)
	movq	$0, 32(%rsp)
	jmp	.L3099
	.p2align 4,,10
	.p2align 3
.L3114:
	movq	24(%r8), %rax
	movq	%rax, 40(%rsp)
	jmp	.L3104
.L3109:
	xorl	%r13d, %r13d
	jmp	.L3105
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_identity
	.def	fn_vlin_identity;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_identity
fn_vlin_identity:
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$144, %rsp
	.seh_stackalloc	144
	vmovaps	%xmm6, 128(%rsp)
	.seh_savexmm	%xmm6, 128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rsi
	jle	.L3123
	cmpl	$2, (%r8)
	je	.L3124
	vcvttsd2siq	8(%r8), %rbx
.L3119:
	movq	%rbx, %rdx
	leaq	96(%rsp), %rcx
	imulq	%rbx, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	96(%rsp), %rdi
	vmovdqu	104(%rsp), %xmm6
	jle	.L3117
	vmovsd	.LC32(%rip), %xmm0
	leaq	8(,%rbx,8), %rcx
	movq	%rdi, %rdx
	xorl	%eax, %eax
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3121:
	addq	$1, %rax
	vmovsd	%xmm0, (%rdx)
	addq	%rcx, %rdx
	cmpq	%rax, %rbx
	jne	.L3121
.L3117:
	call	arena_alloc.constprop.0
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%rdi, (%rax)
	leaq	32(%rsp), %r9
	leaq	48(%rsp), %r8
	vmovdqu	%xmm6, 8(%rax)
	movq	%rax, 40(%rsp)
	movq	$2, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	$2, 48(%rsp)
	movq	%rbx, 56(%rsp)
	movq	$11, 32(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	80(%rsp), %xmm1
	movq	%rsi, %rax
	vmovdqu	%xmm1, (%rsi)
	vmovaps	128(%rsp), %xmm6
	addq	$144, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	ret
	.p2align 4,,10
	.p2align 3
.L3124:
	movq	8(%r8), %rbx
	jmp	.L3119
	.p2align 4,,10
	.p2align 3
.L3123:
	leaq	96(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%ebx, %ebx
	call	fn_vlin_zeros_f64_native
	movq	96(%rsp), %rdi
	vmovdqu	104(%rsp), %xmm6
	jmp	.L3117
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_from_array
	.def	fn_vlin_from_array;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_from_array
fn_vlin_from_array:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 192(%rsp)
	.seh_savexmm	%xmm6, 192
	vmovaps	%xmm7, 208(%rsp)
	.seh_savexmm	%xmm7, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rsi
	jle	.L3126
	movq	(%r8), %rbx
	movq	8(%r8), %rbp
	leal	-3(%rbx), %eax
	movq	%rbp, %r12
	movl	%ebx, %edi
	cmpl	$9, %eax
	ja	.L3178
	leaq	.L3129(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L3129:
	.long	.L3134-.L3129
	.long	.L3131-.L3129
	.long	.L3178-.L3129
	.long	.L3132-.L3129
	.long	.L3178-.L3129
	.long	.L3178-.L3129
	.long	.L3178-.L3129
	.long	.L3131-.L3129
	.long	.L3128-.L3129
	.long	.L3128-.L3129
	.text
.L3131:
	movslq	8(%rbp), %rax
	movq	%rax, 32(%rsp)
.L3135:
	cmpq	$0, 32(%rsp)
	je	.L3207
.L3127:
	leaq	128(%rsp), %rax
	leaq	144(%rsp), %rcx
	movq	%rbx, 128(%rsp)
	leaq	112(%rsp), %r8
	movq	%rax, %rdx
	movq	%rcx, 88(%rsp)
	movq	%rax, 80(%rsp)
	movq	%rbp, 136(%rsp)
	movq	$2, 112(%rsp)
	movq	$0, 120(%rsp)
	movq	%r8, 72(%rsp)
	call	vyne_index_get
	movl	144(%rsp), %eax
	movq	152(%rsp), %rcx
	subl	$3, %eax
	cmpl	$9, %eax
	ja	.L3179
	leaq	.L3139(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section .rdata,"dr"
	.align 4
.L3139:
	.long	.L3144-.L3139
	.long	.L3141-.L3139
	.long	.L3179-.L3139
	.long	.L3142-.L3139
	.long	.L3179-.L3139
	.long	.L3179-.L3139
	.long	.L3179-.L3139
	.long	.L3141-.L3139
	.long	.L3138-.L3139
	.long	.L3138-.L3139
	.text
.L3128:
	movq	8(%rbp), %rax
	movq	%rax, 32(%rsp)
	cmpq	$0, 32(%rsp)
	jne	.L3127
.L3207:
	leaq	144(%rsp), %rcx
	call	vyne_array_create.constprop.0
	movq	152(%rsp), %r8
	movl	144(%rsp), %edx
	leaq	160(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	call	arena_alloc.constprop.0
	leaq	96(%rsp), %r9
	movq	160(%rsp), %rdx
	vmovdqu	168(%rsp), %xmm0
	leaq	112(%rsp), %r8
	leaq	144(%rsp), %rcx
	movq	%rdx, (%rax)
	leaq	128(%rsp), %rdx
	vmovdqu	%xmm0, 8(%rax)
	movq	$2, 128(%rsp)
	movq	$0, 136(%rsp)
	movq	$2, 112(%rsp)
	movq	$0, 120(%rsp)
	movq	$11, 96(%rsp)
	movq	%rax, 104(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	144(%rsp), %xmm4
	vmovdqu	%xmm4, (%rsi)
.L3136:
	vmovaps	192(%rsp), %xmm6
	movq	%rsi, %rax
	vmovaps	208(%rsp), %xmm7
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L3126:
	movq	$8, 32(%rsp)
	xorl	%ebx, %ebx
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	xorl	%edi, %edi
	jmp	.L3127
.L3141:
	movslq	8(%rcx), %r14
.L3137:
	movq	32(%rsp), %rbx
	leaq	160(%rsp), %rcx
	movq	%rbx, %rdx
	imulq	%r14, %rdx
	call	fn_vlin_zeros_f64_native
	movq	160(%rsp), %rbp
	testq	%rbx, %rbx
	vmovdqu	168(%rsp), %xmm7
	movq	%rbp, 64(%rsp)
	jle	.L3145
	testq	%r14, %r14
	jle	.L3145
	cmpl	$4, %edi
	leaq	0(,%r14,8), %rax
	vxorps	%xmm6, %xmm6, %xmm6
	movq	%r12, %r13
	sete	%r15b
	cmpl	$11, %edi
	movq	%rsi, 304(%rsp)
	leaq	_vyne_char_pool(%rip), %rbx
	movq	%rax, 56(%rsp)
	sete	%al
	xorl	%r12d, %r12d
	orl	%eax, %r15d
	.p2align 4,,10
	.p2align 3
.L3147:
	movq	%r12, %r10
	movq	%r12, %r8
	xorl	%esi, %esi
	salq	$4, %r10
	movq	%r10, %r12
	.p2align 4,,10
	.p2align 3
.L3177:
	testb	%r15b, %r15b
	jne	.L3148
	cmpl	$12, %edi
	je	.L3160
	cmpl	$3, %edi
	jne	.L3160
	movq	%r13, %rcx
	movq	%r8, 40(%rsp)
	call	strlen
	movq	40(%rsp), %r8
	testl	%r8d, %r8d
	js	.L3160
	cmpl	%eax, %r8d
	jge	.L3160
	movl	_vyne_char_pool_ready(%rip), %edx
	movl	%r8d, %ecx
	testl	%edx, %edx
	jne	.L3156
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3157:
	leaq	1(%rax), %rdx
	movb	%al, (%rbx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rbx,%rdx,2)
	movb	%al, (%rbx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L3157
	movl	$1, _vyne_char_pool_ready(%rip)
.L3156:
	movslq	%ecx, %rax
	movzbl	0(%r13,%rax), %eax
	leaq	(%rbx,%rax,2), %rcx
	.p2align 4,,10
	.p2align 3
.L3158:
	movq	%r8, 40(%rsp)
	movq	%rcx, 48(%rsp)
	call	strlen
	testl	%esi, %esi
	movq	40(%rsp), %r8
	js	.L3160
	cmpl	%eax, %esi
	jge	.L3160
	movl	_vyne_char_pool_ready(%rip), %eax
	movq	48(%rsp), %rcx
	movl	%esi, %r9d
	testl	%eax, %eax
	jne	.L3169
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3170:
	leaq	1(%rax), %rdx
	movb	%al, (%rbx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rbx,%rdx,2)
	movb	%al, (%rbx,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L3170
	movl	$1, _vyne_char_pool_ready(%rip)
.L3169:
	movslq	%r9d, %rax
	movzbl	(%rcx,%rax), %eax
	leaq	(%rbx,%rax,2), %rcx
.L3171:
	movq	%r8, 48(%rsp)
	movq	%rcx, 40(%rsp)
	call	atof
	movq	40(%rsp), %rcx
	call	atof
	movq	48(%rsp), %r8
	.p2align 4,,10
	.p2align 3
.L3164:
	vmovsd	%xmm0, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%r14, %rsi
	jne	.L3177
.L3206:
	movq	%r8, %r12
	addq	56(%rsp), %rbp
	addq	$1, %r12
	cmpq	32(%rsp), %r12
	jne	.L3147
	movq	304(%rsp), %rsi
.L3145:
	call	arena_alloc.constprop.0
	movq	64(%rsp), %rdi
	movq	72(%rsp), %r8
	leaq	96(%rsp), %r9
	movq	80(%rsp), %rdx
	movq	88(%rsp), %rcx
	vmovdqu	%xmm7, 8(%rax)
	movq	%rdi, (%rax)
	movq	32(%rsp), %rdi
	movq	$2, 128(%rsp)
	movq	%rdi, 136(%rsp)
	movq	$2, 112(%rsp)
	movq	%r14, 120(%rsp)
	movq	$11, 96(%rsp)
	movq	%rax, 104(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	144(%rsp), %xmm3
	vmovdqu	%xmm3, (%rsi)
	jmp	.L3136
.L3138:
	movq	8(%rcx), %r14
	jmp	.L3137
.L3179:
	movl	$8, %r14d
	jmp	.L3137
.L3134:
	movq	%rbp, %rcx
	call	strlen
	movq	%rax, 32(%rsp)
	jmp	.L3135
.L3132:
	movslq	16(%rbp), %rax
	movq	%rax, 32(%rsp)
	jmp	.L3135
.L3142:
	movslq	16(%rcx), %r14
	jmp	.L3137
.L3144:
	call	strlen
	movq	%rax, %r14
	jmp	.L3137
	.p2align 4,,10
	.p2align 3
.L3210:
	cmpl	$12, %eax
	je	.L3208
	cmpl	$10, %eax
	je	.L3160
	cmpl	$3, %eax
	je	.L3158
	.p2align 4,,10
	.p2align 3
.L3160:
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L3164
	.p2align 4,,10
	.p2align 3
.L3148:
	cmpl	$4, %edi
	jne	.L3160
.L3195:
	movslq	8(%r13), %rdx
	jmp	.L3175
	.p2align 4,,10
	.p2align 3
.L3198:
	movslq	8(%rcx), %rax
	cmpq	%rsi, %rax
	jle	.L3160
	movq	%rsi, %rax
	salq	$4, %rax
	addq	(%rcx), %rax
	movl	(%rax), %r9d
	movq	8(%rax), %rcx
	cmpl	$1, %r9d
	je	.L3209
	cmpl	$2, %r9d
	jne	.L3174
.L3168:
	vcvtsi2sdq	%rcx, %xmm6, %xmm0
	vmovlpd	%xmm0, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%rsi, %r14
	je	.L3206
.L3175:
	cmpq	%r8, %rdx
	jle	.L3160
	movq	0(%r13), %rcx
	addq	%r12, %rcx
	movl	(%rcx), %eax
	movq	8(%rcx), %rcx
	cmpl	$4, %eax
	je	.L3198
	cmpl	$11, %eax
	jne	.L3210
	cmpl	$4, %eax
	je	.L3198
	cmpq	%rsi, 8(%rcx)
	jle	.L3160
	movq	(%rcx), %rax
	vmovsd	(%rax,%rsi,8), %xmm0
.L3167:
	vmovsd	%xmm0, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%rsi, %r14
	jne	.L3195
	jmp	.L3206
	.p2align 4,,10
	.p2align 3
.L3208:
	cmpq	%rsi, 8(%rcx)
	jle	.L3160
	movq	(%rcx), %rax
	movq	(%rax,%rsi,8), %rcx
	jmp	.L3168
	.p2align 4,,10
	.p2align 3
.L3209:
	vmovq	%rcx, %xmm0
	jmp	.L3167
.L3178:
	movq	$8, 32(%rsp)
	jmp	.L3127
.L3174:
	cmpl	$3, %r9d
	je	.L3171
	movq	$0x000000000, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%rsi, %r14
	jne	.L3195
	jmp	.L3206
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_from_flat
	.def	fn_vlin_from_flat;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_from_flat
fn_vlin_from_flat:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 160(%rsp)
	.seh_savexmm	%xmm6, 160
	vmovaps	%xmm7, 176(%rsp)
	.seh_savexmm	%xmm7, 176
	vmovaps	%xmm8, 192(%rsp)
	.seh_savexmm	%xmm8, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 288(%rsp)
	jle	.L3223
	cmpl	$2, (%r8)
	je	.L3232
	vcvttsd2siq	8(%r8), %rax
	cmpl	$1, %edx
	movq	%rax, 40(%rsp)
	je	.L3224
.L3235:
	cmpl	$2, 16(%r8)
	je	.L3233
	vcvttsd2siq	24(%r8), %rax
	movq	%rax, 48(%rsp)
.L3216:
	movq	40(%rsp), %rbx
	imulq	48(%rsp), %rbx
	cmpl	$2, %edx
	je	.L3212
	vmovdqu	32(%r8), %xmm6
.L3217:
	leaq	128(%rsp), %rcx
	movq	%rbx, %rdx
	leaq	112(%rsp), %r12
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	128(%rsp), %rbp
	vmovdqu	136(%rsp), %xmm8
	leaq	80(%rsp), %r13
	leaq	96(%rsp), %r14
	jle	.L3222
	vxorps	%xmm7, %xmm7, %xmm7
	xorl	%r15d, %r15d
	leaq	112(%rsp), %r12
	leaq	80(%rsp), %r13
	leaq	96(%rsp), %r14
	jmp	.L3218
	.p2align 4,,10
	.p2align 3
.L3221:
	cmpl	$3, %eax
	vxorpd	%xmm0, %xmm0, %xmm0
	je	.L3234
.L3220:
	vmovsd	%xmm0, 0(%rbp,%r15,8)
	addq	$1, %r15
	cmpq	%rbx, %r15
	je	.L3222
.L3218:
	movl	$2, %eax
	movq	%r12, %rcx
	movq	%r13, %r8
	movq	%r14, %rdx
	movq	%rax, 80(%rsp)
	movq	%r15, 88(%rsp)
	vmovdqa	%xmm6, 96(%rsp)
	call	vyne_index_get
	movq	112(%rsp), %rax
	movq	120(%rsp), %rcx
	cmpl	$1, %eax
	vmovq	%rcx, %xmm0
	je	.L3220
	cmpl	$2, %eax
	jne	.L3221
	vcvtsi2sdq	%rcx, %xmm7, %xmm0
	vmovsd	%xmm0, 0(%rbp,%r15,8)
	addq	$1, %r15
	cmpq	%rbx, %r15
	jne	.L3218
.L3222:
	call	arena_alloc.constprop.0
	movq	40(%rsp), %rdi
	movq	%r13, %r8
	movq	%r14, %rdx
	movq	%rbp, (%rax)
	leaq	64(%rsp), %r9
	movq	%r12, %rcx
	vmovdqu	%xmm8, 8(%rax)
	movq	%rdi, 104(%rsp)
	movq	48(%rsp), %rdi
	movq	%rax, 72(%rsp)
	movq	$2, 96(%rsp)
	movq	$2, 80(%rsp)
	movq	%rdi, 88(%rsp)
	movq	$11, 64(%rsp)
	call	struct_vlin_Types_Matrix
	movq	288(%rsp), %rax
	vmovdqu	112(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	vmovaps	160(%rsp), %xmm6
	vmovaps	176(%rsp), %xmm7
	vmovaps	192(%rsp), %xmm8
	addq	$216, %rsp
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
.L3232:
	movq	8(%r8), %rax
	cmpl	$1, %edx
	movq	%rax, 40(%rsp)
	jne	.L3235
.L3224:
	movq	$0, 48(%rsp)
	xorl	%ebx, %ebx
.L3212:
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.L3217
	.p2align 4,,10
	.p2align 3
.L3234:
	movq	%rcx, 56(%rsp)
	call	atof
	movq	56(%rsp), %rcx
	call	atof
	jmp	.L3220
	.p2align 4,,10
	.p2align 3
.L3223:
	movq	$0, 48(%rsp)
	xorl	%ebx, %ebx
	vpxor	%xmm6, %xmm6, %xmm6
	movq	$0, 40(%rsp)
	jmp	.L3217
	.p2align 4,,10
	.p2align 3
.L3233:
	movq	24(%r8), %rax
	movq	%rax, 48(%rsp)
	jmp	.L3216
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_random_uniform
	.def	fn_vlin_random_uniform;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_random_uniform
fn_vlin_random_uniform:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 144(%rsp)
	.seh_savexmm	%xmm6, 144
	vmovaps	%xmm7, 160(%rsp)
	.seh_savexmm	%xmm7, 160
	vmovaps	%xmm8, 176(%rsp)
	.seh_savexmm	%xmm8, 176
	vmovaps	%xmm9, 192(%rsp)
	.seh_savexmm	%xmm9, 192
	vmovaps	%xmm10, 208(%rsp)
	.seh_savexmm	%xmm10, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L3258
	cmpl	$2, (%r8)
	je	.L3259
	cmpl	$1, %edx
	vcvttsd2siq	8(%r8), %rbp
	je	.L3260
.L3241:
	cmpl	$2, 16(%r8)
	je	.L3261
	vcvttsd2siq	24(%r8), %rax
	movq	%rax, 40(%rsp)
.L3243:
	cmpl	$2, %edx
	vxorps	%xmm8, %xmm8, %xmm8
	je	.L3254
	movq	40(%r8), %rax
	cmpl	$1, 32(%r8)
	vmovq	%rax, %xmm7
	je	.L3246
	vcvtsi2sdq	%rax, %xmm8, %xmm7
.L3246:
	cmpl	$3, %edx
	vxorpd	%xmm6, %xmm6, %xmm6
	je	.L3244
	movq	56(%r8), %rax
	cmpl	$1, 48(%r8)
	vmovq	%rax, %xmm6
	je	.L3244
	vcvtsi2sdq	%rax, %xmm8, %xmm6
.L3244:
	movq	40(%rsp), %r15
	leaq	112(%rsp), %rcx
	imulq	%rbp, %r15
	movq	%r15, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%r15, %r15
	movq	112(%rsp), %r14
	vmovdqu	120(%rsp), %xmm10
	jle	.L3238
	vsubsd	%xmm7, %xmm6, %xmm6
	movq	_vmath_rng_state(%rip), %r8
	xorl	%r12d, %r12d
	vmovsd	.LC73(%rip), %xmm9
	movabsq	$1442695040888963407, %rdi
	leaq	_vmath_rng_state(%rip), %rsi
	movabsq	$6364136223846793005, %r13
	jmp	.L3253
	.p2align 4,,10
	.p2align 3
.L3262:
	movq	_vmath_rng_inc(%rip), %rax
	movq	%r8, %rcx
.L3250:
	movq	%rcx, %r8
	imulq	%r13, %r8
	addq	%rax, %r8
	movq	%rcx, %rax
	shrq	$18, %rax
	movq	%r8, _vmath_rng_state(%rip)
	xorq	%rcx, %rax
	shrq	$59, %rcx
	shrq	$27, %rax
	rorl	%cl, %eax
	vcvtsi2sdq	%rax, %xmm8, %xmm0
	vmulsd	%xmm9, %xmm0, %xmm0
	vfmadd132sd	%xmm6, %xmm7, %xmm0
	vmovsd	%xmm0, (%r14,%r12,8)
	addq	$1, %r12
	cmpq	%r12, %r15
	je	.L3238
.L3253:
	testq	%r8, %r8
	jne	.L3262
	xorl	%ecx, %ecx
	call	_time64
	movq	%rdi, _vmath_rng_inc(%rip)
	xorq	%rsi, %rax
	movq	%rax, %rcx
	movabsq	$1442695040888963407, %rax
	imulq	%r13, %rcx
	addq	%rdi, %rcx
	jmp	.L3250
	.p2align 4,,10
	.p2align 3
.L3259:
	cmpl	$1, %edx
	movq	8(%r8), %rbp
	jne	.L3241
.L3260:
	leaq	112(%rsp), %rcx
	xorl	%edx, %edx
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r14
	vmovdqu	120(%rsp), %xmm10
	movq	$0, 40(%rsp)
.L3238:
	call	arena_alloc.constprop.0
	movq	40(%rsp), %rsi
	leaq	96(%rsp), %rcx
	leaq	80(%rsp), %rdx
	movq	%r14, (%rax)
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	vmovdqu	%xmm10, 8(%rax)
	movq	%rax, 56(%rsp)
	movq	$2, 80(%rsp)
	movq	%rbp, 88(%rsp)
	movq	$2, 64(%rsp)
	movq	%rsi, 72(%rsp)
	movq	$11, 48(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	144(%rsp), %xmm6
	vmovaps	160(%rsp), %xmm7
	vmovaps	176(%rsp), %xmm8
	vmovaps	192(%rsp), %xmm9
	vmovaps	208(%rsp), %xmm10
	addq	$232, %rsp
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
.L3258:
	leaq	112(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%ebp, %ebp
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r14
	vmovdqu	120(%rsp), %xmm10
	movq	$0, 40(%rsp)
	jmp	.L3238
	.p2align 4,,10
	.p2align 3
.L3261:
	movq	24(%r8), %rax
	movq	%rax, 40(%rsp)
	jmp	.L3243
.L3254:
	vxorpd	%xmm7, %xmm7, %xmm7
	vmovapd	%xmm7, %xmm6
	jmp	.L3244
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_xavier_init
	.def	fn_vlin_xavier_init;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_xavier_init
fn_vlin_xavier_init:
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
	subq	$112, %rsp
	.seh_stackalloc	112
	vmovaps	%xmm6, 96(%rsp)
	.seh_savexmm	%xmm6, 96
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rsi
	jle	.L3273
	cmpl	$2, (%r8)
	je	.L3277
	cmpl	$1, %edx
	vcvttsd2siq	8(%r8), %rbp
	je	.L3274
.L3279:
	cmpl	$2, 16(%r8)
	je	.L3278
	vcvttsd2siq	24(%r8), %r12
	leaq	0(%rbp,%r12), %r14
.L3264:
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%r14, 72(%rsp)
	movq	$2, 64(%rsp)
	call	vyne_to_float
	vmovdqu	80(%rsp), %xmm2
	leaq	48(%rsp), %r8
	movq	.LC74(%rip), %r13
	movl	$32, %r9d
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%r8, 40(%rsp)
	vmovdqa	%xmm2, 48(%rsp)
	movq	$1, 64(%rsp)
	movq	%r13, 72(%rsp)
	call	vyne_binop
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	$2, 64(%rsp)
	movq	%r14, 72(%rsp)
	call	vyne_to_float
	vmovdqu	80(%rsp), %xmm3
	movq	40(%rsp), %r8
	movl	$32, %r9d
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%r13, 72(%rsp)
	movq	$1, 64(%rsp)
	vmovdqa	%xmm3, 48(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	vmovsd	88(%rsp), %xmm6
	jne	.L3269
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	88(%rsp), %xmm0, %xmm0
	vmovapd	%xmm0, %xmm6
.L3269:
	vxorpd	%xmm1, %xmm1, %xmm1
	vucomisd	%xmm6, %xmm1
	ja	.L3276
	vsqrtsd	%xmm6, %xmm6, %xmm6
.L3272:
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$64, %ecx
	vsubsd	%xmm6, %xmm0, %xmm4
	vmovq	%xmm4, %rdi
	call	arena_alloc
	movl	$4, %edx
	leaq	80(%rsp), %rcx
	movq	%rbp, 8(%rax)
	movq	%rax, %r8
	movq	%r12, 24(%rax)
	movq	%rdi, 40(%rax)
	movq	$2, (%rax)
	movq	$2, 16(%rax)
	movq	$1, 32(%rax)
	movq	$1, 48(%rax)
	vmovq	%xmm6, 56(%rax)
	call	fn_vlin_random_uniform
	vmovdqu	80(%rsp), %xmm5
	movq	%rsi, %rax
	vmovdqu	%xmm5, (%rsi)
	vmovaps	96(%rsp), %xmm6
	addq	$112, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L3277:
	cmpl	$1, %edx
	movq	8(%r8), %rbp
	jne	.L3279
.L3274:
	movq	%rbp, %r14
	xorl	%r12d, %r12d
	jmp	.L3264
	.p2align 4,,10
	.p2align 3
.L3273:
	xorl	%r14d, %r14d
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	jmp	.L3264
	.p2align 4,,10
	.p2align 3
.L3278:
	movq	24(%r8), %r12
	leaq	0(%rbp,%r12), %r14
	jmp	.L3264
.L3276:
	vmovapd	%xmm6, %xmm0
	call	sqrt
	vmovapd	%xmm0, %xmm6
	jmp	.L3272
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_he_init
	.def	fn_vlin_he_init;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_he_init
fn_vlin_he_init:
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
	subq	$120, %rsp
	.seh_stackalloc	120
	vmovaps	%xmm6, 96(%rsp)
	.seh_savexmm	%xmm6, 96
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rsi
	jle	.L3290
	cmpl	$2, (%r8)
	je	.L3295
	vcvttsd2siq	8(%r8), %r12
.L3283:
	xorl	%ebp, %ebp
	cmpl	$1, %edx
	je	.L3281
	cmpl	$2, 16(%r8)
	je	.L3296
	vcvttsd2siq	24(%r8), %rbp
.L3281:
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%rbp, 72(%rsp)
	movq	$2, 64(%rsp)
	call	vyne_to_float
	vmovdqu	80(%rsp), %xmm2
	leaq	48(%rsp), %r8
	movq	.LC74(%rip), %r13
	movl	$32, %r9d
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%r8, 40(%rsp)
	vmovdqa	%xmm2, 48(%rsp)
	movq	$1, 64(%rsp)
	movq	%r13, 72(%rsp)
	call	vyne_binop
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	$2, 64(%rsp)
	movq	%rbp, 72(%rsp)
	call	vyne_to_float
	vmovdqu	80(%rsp), %xmm3
	movq	40(%rsp), %r8
	movl	$32, %r9d
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%r13, 72(%rsp)
	movq	$1, 64(%rsp)
	vmovdqa	%xmm3, 48(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	vmovsd	88(%rsp), %xmm6
	jne	.L3286
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	88(%rsp), %xmm0, %xmm0
	vmovapd	%xmm0, %xmm6
.L3286:
	vxorpd	%xmm1, %xmm1, %xmm1
	vucomisd	%xmm6, %xmm1
	ja	.L3294
	vsqrtsd	%xmm6, %xmm6, %xmm6
.L3289:
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$64, %ecx
	vsubsd	%xmm6, %xmm0, %xmm4
	vmovq	%xmm4, %rdi
	call	arena_alloc
	movl	$4, %edx
	leaq	80(%rsp), %rcx
	movq	%r12, 8(%rax)
	movq	%rax, %r8
	movq	%rbp, 24(%rax)
	movq	%rdi, 40(%rax)
	movq	$2, (%rax)
	movq	$2, 16(%rax)
	movq	$1, 32(%rax)
	movq	$1, 48(%rax)
	vmovq	%xmm6, 56(%rax)
	call	fn_vlin_random_uniform
	vmovdqu	80(%rsp), %xmm5
	movq	%rsi, %rax
	vmovdqu	%xmm5, (%rsi)
	vmovaps	96(%rsp), %xmm6
	addq	$120, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.p2align 4,,10
	.p2align 3
.L3295:
	movq	8(%r8), %r12
	jmp	.L3283
	.p2align 4,,10
	.p2align 3
.L3290:
	xorl	%r12d, %r12d
	xorl	%ebp, %ebp
	jmp	.L3281
	.p2align 4,,10
	.p2align 3
.L3296:
	movq	24(%r8), %rbp
	jmp	.L3281
.L3294:
	vmovapd	%xmm6, %xmm0
	call	sqrt
	vmovapd	%xmm0, %xmm6
	jmp	.L3289
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_random_init
	.def	fn_vlin_random_init;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_random_init
fn_vlin_random_init:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 144(%rsp)
	.seh_savexmm	%xmm6, 144
	vmovaps	%xmm7, 160(%rsp)
	.seh_savexmm	%xmm7, 160
	vmovaps	%xmm8, 176(%rsp)
	.seh_savexmm	%xmm8, 176
	vmovaps	%xmm9, 192(%rsp)
	.seh_savexmm	%xmm9, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L3312
	cmpl	$2, (%r8)
	je	.L3313
	cmpl	$1, %edx
	vcvttsd2siq	8(%r8), %rbp
	je	.L3314
.L3302:
	cmpl	$2, 16(%r8)
	je	.L3315
	vcvttsd2siq	24(%r8), %rax
	movq	%rax, 40(%rsp)
	movq	%rax, %r15
.L3304:
	imulq	%rbp, %r15
	leaq	112(%rsp), %rcx
	movq	%r15, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%r15, %r15
	movq	112(%rsp), %r14
	vmovdqu	120(%rsp), %xmm9
	jle	.L3299
	movq	_vmath_rng_state(%rip), %r8
	vmovsd	.LC73(%rip), %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	xorl	%r12d, %r12d
	vmovsd	.LC75(%rip), %xmm6
	movabsq	$1442695040888963407, %rdi
	leaq	_vmath_rng_state(%rip), %rsi
	movabsq	$6364136223846793005, %r13
	jmp	.L3310
	.p2align 4,,10
	.p2align 3
.L3316:
	movq	_vmath_rng_inc(%rip), %rax
	movq	%r8, %rcx
.L3307:
	movq	%rcx, %r8
	imulq	%r13, %r8
	addq	%rax, %r8
	movq	%rcx, %rax
	shrq	$18, %rax
	movq	%r8, _vmath_rng_state(%rip)
	xorq	%rcx, %rax
	shrq	$59, %rcx
	shrq	$27, %rax
	rorl	%cl, %eax
	vcvtsi2sdq	%rax, %xmm8, %xmm0
	vfmadd132sd	%xmm7, %xmm6, %xmm0
	vmovsd	%xmm0, (%r14,%r12,8)
	addq	$1, %r12
	cmpq	%r12, %r15
	je	.L3299
.L3310:
	testq	%r8, %r8
	jne	.L3316
	xorl	%ecx, %ecx
	call	_time64
	movq	%rdi, _vmath_rng_inc(%rip)
	xorq	%rsi, %rax
	movq	%rax, %rcx
	movabsq	$1442695040888963407, %rax
	imulq	%r13, %rcx
	addq	%rdi, %rcx
	jmp	.L3307
	.p2align 4,,10
	.p2align 3
.L3313:
	cmpl	$1, %edx
	movq	8(%r8), %rbp
	jne	.L3302
.L3314:
	leaq	112(%rsp), %rcx
	xorl	%edx, %edx
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r14
	vmovdqu	120(%rsp), %xmm9
	movq	$0, 40(%rsp)
.L3299:
	call	arena_alloc.constprop.0
	movq	40(%rsp), %rsi
	leaq	96(%rsp), %rcx
	leaq	80(%rsp), %rdx
	movq	%r14, (%rax)
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	vmovdqu	%xmm9, 8(%rax)
	movq	%rax, 56(%rsp)
	movq	$2, 80(%rsp)
	movq	%rbp, 88(%rsp)
	movq	$2, 64(%rsp)
	movq	%rsi, 72(%rsp)
	movq	$11, 48(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	144(%rsp), %xmm6
	vmovaps	160(%rsp), %xmm7
	vmovaps	176(%rsp), %xmm8
	vmovaps	192(%rsp), %xmm9
	addq	$216, %rsp
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
.L3312:
	leaq	112(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%ebp, %ebp
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r14
	vmovdqu	120(%rsp), %xmm9
	movq	$0, 40(%rsp)
	jmp	.L3299
	.p2align 4,,10
	.p2align 3
.L3315:
	movq	24(%r8), %rax
	movq	%rax, 40(%rsp)
	movq	%rax, %r15
	jmp	.L3304
	.seh_endproc
	.section .rdata,"dr"
.LC76:
	.ascii "vlin.add: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_add
	.def	fn_vlin_add;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_add
fn_vlin_add:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 208(%rsp)
	.seh_savexmm	%xmm6, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L3318
	cmpl	$1, %edx
	movl	(%r8), %r14d
	movq	8(%r8), %r12
	je	.L3399
	movl	16(%r8), %eax
	movq	24(%r8), %r13
	cmpl	$6, %eax
	movl	%eax, 44(%rsp)
	jne	.L3323
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3323
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3326
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3325:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3323
.L3326:
	cmpl	$107, (%rax)
	jne	.L3325
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L3324:
	cmpl	$6, %r14d
	jne	.L3328
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3328
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3332
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3331:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3328
.L3332:
	cmpl	$107, (%rax)
	jne	.L3331
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3330:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rsi
	movq	%rdx, 88(%rsp)
	leaq	80(%rsp), %rdi
	movq	%r8, 64(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movq	%rdi, %rdx
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$6, 44(%rsp)
	vmovdqu	96(%rsp), %xmm6
	jne	.L3321
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3321
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3336
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3335:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3321
.L3336:
	cmpl	$109, (%rax)
	jne	.L3335
	cmpl	$6, %r14d
	movq	16(%rax), %r8
	movq	24(%rax), %r9
	jne	.L3337
.L3446:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3339
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3344
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3342:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3339
.L3344:
	cmpl	$109, (%rax)
	jne	.L3342
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3343:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	movq	104(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	96(%rsp), %rax
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	movq	%rdx, 72(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L3396
.L3397:
	cmpl	$5, %edx
	je	.L3405
	cmpl	$2, %edx
	je	.L3405
	cmpl	$1, %edx
	je	.L3445
.L3348:
	call	arena_alloc.constprop.2
	leaq	.LC76(%rip), %rsi
	movq	%rbx, %rcx
	movq	$3, (%rax)
	movq	%rax, %rdx
	movq	%rsi, 8(%rax)
	call	fn_vcolors_red.constprop.0
	movq	104(%rsp), %rdx
	movl	96(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rbx, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	movq	304(%rsp), %rax
	vmovdqu	96(%rsp), %xmm2
	vmovdqu	%xmm2, (%rax)
.L3431:
	vmovaps	208(%rsp), %xmm6
	addq	$232, %rsp
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
.L3399:
	movl	$0, 44(%rsp)
	xorl	%r13d, %r13d
.L3323:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3324
	.p2align 4,,10
	.p2align 3
.L3318:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rsi
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	leaq	80(%rsp), %rdi
	movq	%rsi, %r8
	movq	%rbx, %rcx
	xorl	%r14d, %r14d
	movl	$44, %r9d
	movq	%rdi, %rdx
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	movl	$0, 44(%rsp)
	vmovdqu	96(%rsp), %xmm6
.L3321:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpl	$6, %r14d
	je	.L3446
.L3337:
	movq	%r8, 64(%rsp)
	movq	%rdi, %rdx
	movq	%rsi, %r8
	movq	%rbx, %rcx
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	call	vyne_binop
	movq	104(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	96(%rsp), %rax
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	movq	%rdx, 72(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L3397
.L3340:
	movl	$31, %r9d
	movq	%rsi, %r8
	movq	%rdi, %rdx
	movq	%rbx, %rcx
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbp
	je	.L3443
	vmovq	%rbp, %xmm4
	vcvttsd2siq	%xmm4, %rbp
.L3443:
	leaq	112(%rsp), %rcx
	movq	%rbp, %rdx
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r15
	vmovdqu	120(%rsp), %xmm6
.L3444:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3363:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, 44(%rsp)
	jne	.L3401
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3401
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3368
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3367:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3401
.L3368:
	cmpl	$116, (%rax)
	jne	.L3367
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3366
	.p2align 4,,10
	.p2align 3
.L3401:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3366:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rbp, %rbp
	jle	.L3376
	cmpq	$1, %rbp
	movq	176(%rsp), %rcx
	movq	144(%rsp), %rdx
	je	.L3403
	movq	$-8, %rax
	movq	%rax, %r8
	subq	%rdx, %r8
	addq	%r15, %r8
	cmpq	$16, %r8
	jbe	.L3403
	subq	%rcx, %rax
	addq	%r15, %rax
	cmpq	$16, %rax
	jbe	.L3403
	leaq	-1(%rbp), %rax
	movq	%rbp, %r8
	cmpq	$2, %rax
	jbe	.L3404
	shrq	$2, %r8
	xorl	%eax, %eax
	salq	$5, %r8
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3374:
	vmovupd	(%rcx,%rax), %ymm0
	vaddpd	(%rdx,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%r15,%rax)
	addq	$32, %rax
	cmpq	%rax, %r8
	jne	.L3374
	movq	%rbp, %rax
	andq	$-4, %rax
	cmpq	%rax, %rbp
	movq	%rax, %r11
	je	.L3440
	movq	%rbp, %r8
	subq	%rax, %r8
	cmpq	$1, %r8
	je	.L3447
	vzeroupper
.L3373:
	vmovupd	(%rcx,%r11,8), %xmm0
	vaddpd	(%rdx,%r11,8), %xmm0, %xmm0
	testb	$1, %r8b
	vmovupd	%xmm0, (%r15,%r11,8)
	je	.L3376
	andq	$-2, %r8
	addq	%r8, %rax
.L3378:
	vmovsd	(%rdx,%rax,8), %xmm0
	vaddsd	(%rcx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%r15,%rax,8)
.L3376:
	call	arena_alloc.constprop.0
	cmpl	$6, %r14d
	movl	$11, %r8d
	movq	%r15, (%rax)
	movq	%rax, %r9
	vmovdqu	%xmm6, 8(%rax)
	je	.L3448
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L3384:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rsi, %r8
	movq	%r9, 56(%rsp)
	leaq	48(%rsp), %r9
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	96(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	jmp	.L3431
	.p2align 4,,10
	.p2align 3
.L3328:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3330
	.p2align 4,,10
	.p2align 3
.L3448:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3449
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3387
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3385:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L3450
.L3387:
	cmpl	$109, (%rdx)
	jne	.L3385
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L3391
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3390:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3389
.L3391:
	cmpl	$107, (%rax)
	jne	.L3390
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L3384
	.p2align 4,,10
	.p2align 3
.L3405:
	testq	%rcx, %rcx
	setne	%al
.L3347:
	testb	%al, %al
	jne	.L3348
	cmpl	$6, %r14d
	jne	.L3340
.L3396:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3451
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3356
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3354:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L3452
.L3356:
	cmpl	$109, (%rdx)
	jne	.L3354
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L3361
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3359:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3358
.L3361:
	cmpl	$107, (%rax)
	jne	.L3359
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3360:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbp
	je	.L3442
	vmovq	%rbp, %xmm3
	vcvttsd2siq	%xmm3, %rbp
.L3442:
	movq	%rbp, %rdx
	leaq	112(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movslq	16(%r12), %rdx
	movq	112(%rsp), %r15
	vmovdqu	120(%rsp), %xmm6
	testl	%edx, %edx
	jle	.L3444
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3365
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3364:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3444
.L3365:
	cmpl	$116, (%rax)
	jne	.L3364
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3363
	.p2align 4,,10
	.p2align 3
.L3339:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3343
.L3449:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	.p2align 4,,10
	.p2align 3
.L3389:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3384
.L3451:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L3358:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3360
	.p2align 4,,10
	.p2align 3
.L3450:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L3391
	.p2align 4,,10
	.p2align 3
.L3452:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3361
	.p2align 4,,10
	.p2align 3
.L3403:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3380:
	vmovsd	(%rcx,%rax,8), %xmm0
	vaddsd	(%rdx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%r15,%rax,8)
	addq	$1, %rax
	cmpq	%rbp, %rax
	jne	.L3380
	jmp	.L3376
	.p2align 4,,10
	.p2align 3
.L3445:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	setp	%al
	cmovne	%edx, %eax
	jmp	.L3347
	.p2align 4,,10
	.p2align 3
.L3440:
	vzeroupper
	jmp	.L3376
.L3404:
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.L3373
.L3447:
	vzeroupper
	jmp	.L3378
	.seh_endproc
	.section .rdata,"dr"
.LC77:
	.ascii "vlin.subtract: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_subtract
	.def	fn_vlin_subtract;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_subtract
fn_vlin_subtract:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 208(%rsp)
	.seh_savexmm	%xmm6, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L3454
	cmpl	$1, %edx
	movl	(%r8), %r14d
	movq	8(%r8), %r12
	je	.L3535
	movl	16(%r8), %eax
	movq	24(%r8), %r13
	cmpl	$6, %eax
	movl	%eax, 44(%rsp)
	jne	.L3459
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3459
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3462
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3461:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3459
.L3462:
	cmpl	$107, (%rax)
	jne	.L3461
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L3460:
	cmpl	$6, %r14d
	jne	.L3464
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3464
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3468
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3467:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3464
.L3468:
	cmpl	$107, (%rax)
	jne	.L3467
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3466:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rsi
	movq	%rdx, 88(%rsp)
	leaq	80(%rsp), %rdi
	movq	%r8, 64(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movq	%rdi, %rdx
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$6, 44(%rsp)
	vmovdqu	96(%rsp), %xmm6
	jne	.L3457
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3457
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3472
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3471:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3457
.L3472:
	cmpl	$109, (%rax)
	jne	.L3471
	cmpl	$6, %r14d
	movq	16(%rax), %r8
	movq	24(%rax), %r9
	jne	.L3473
.L3582:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3475
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3480
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3478:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3475
.L3480:
	cmpl	$109, (%rax)
	jne	.L3478
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3479:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	movq	104(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	96(%rsp), %rax
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	movq	%rdx, 72(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L3532
.L3533:
	cmpl	$5, %edx
	je	.L3541
	cmpl	$2, %edx
	je	.L3541
	cmpl	$1, %edx
	je	.L3581
.L3484:
	call	arena_alloc.constprop.2
	leaq	.LC77(%rip), %rsi
	movq	%rbx, %rcx
	movq	$3, (%rax)
	movq	%rax, %rdx
	movq	%rsi, 8(%rax)
	call	fn_vcolors_red.constprop.0
	movq	104(%rsp), %rdx
	movl	96(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rbx, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	movq	304(%rsp), %rax
	vmovdqu	96(%rsp), %xmm2
	vmovdqu	%xmm2, (%rax)
.L3567:
	vmovaps	208(%rsp), %xmm6
	addq	$232, %rsp
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
.L3535:
	movl	$0, 44(%rsp)
	xorl	%r13d, %r13d
.L3459:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3460
	.p2align 4,,10
	.p2align 3
.L3454:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rsi
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	leaq	80(%rsp), %rdi
	movq	%rsi, %r8
	movq	%rbx, %rcx
	xorl	%r14d, %r14d
	movl	$44, %r9d
	movq	%rdi, %rdx
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	movl	$0, 44(%rsp)
	vmovdqu	96(%rsp), %xmm6
.L3457:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpl	$6, %r14d
	je	.L3582
.L3473:
	movq	%r8, 64(%rsp)
	movq	%rdi, %rdx
	movq	%rsi, %r8
	movq	%rbx, %rcx
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	call	vyne_binop
	movq	104(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	96(%rsp), %rax
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	movq	%rdx, 72(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L3533
.L3476:
	movl	$31, %r9d
	movq	%rsi, %r8
	movq	%rdi, %rdx
	movq	%rbx, %rcx
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbp
	je	.L3579
	vmovq	%rbp, %xmm4
	vcvttsd2siq	%xmm4, %rbp
.L3579:
	leaq	112(%rsp), %rcx
	movq	%rbp, %rdx
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r15
	vmovdqu	120(%rsp), %xmm6
.L3580:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3499:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, 44(%rsp)
	jne	.L3537
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3537
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3504
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3503:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3537
.L3504:
	cmpl	$116, (%rax)
	jne	.L3503
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3502
	.p2align 4,,10
	.p2align 3
.L3537:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3502:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rbp, %rbp
	jle	.L3512
	cmpq	$1, %rbp
	movq	176(%rsp), %rcx
	movq	144(%rsp), %rdx
	je	.L3539
	movq	$-8, %rax
	movq	%rax, %r8
	subq	%rdx, %r8
	addq	%r15, %r8
	cmpq	$16, %r8
	jbe	.L3539
	subq	%rcx, %rax
	addq	%r15, %rax
	cmpq	$16, %rax
	jbe	.L3539
	leaq	-1(%rbp), %rax
	movq	%rbp, %r8
	cmpq	$2, %rax
	jbe	.L3540
	shrq	$2, %r8
	xorl	%eax, %eax
	salq	$5, %r8
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3510:
	vmovupd	(%rdx,%rax), %ymm0
	vsubpd	(%rcx,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%r15,%rax)
	addq	$32, %rax
	cmpq	%rax, %r8
	jne	.L3510
	movq	%rbp, %rax
	andq	$-4, %rax
	cmpq	%rax, %rbp
	movq	%rax, %r11
	je	.L3576
	movq	%rbp, %r8
	subq	%rax, %r8
	cmpq	$1, %r8
	je	.L3583
	vzeroupper
.L3509:
	vmovupd	(%rdx,%r11,8), %xmm0
	vsubpd	(%rcx,%r11,8), %xmm0, %xmm0
	testb	$1, %r8b
	vmovupd	%xmm0, (%r15,%r11,8)
	je	.L3512
	andq	$-2, %r8
	addq	%r8, %rax
.L3514:
	vmovsd	(%rdx,%rax,8), %xmm0
	vsubsd	(%rcx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%r15,%rax,8)
.L3512:
	call	arena_alloc.constprop.0
	cmpl	$6, %r14d
	movl	$11, %r8d
	movq	%r15, (%rax)
	movq	%rax, %r9
	vmovdqu	%xmm6, 8(%rax)
	je	.L3584
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L3520:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rsi, %r8
	movq	%r9, 56(%rsp)
	leaq	48(%rsp), %r9
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	96(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	jmp	.L3567
	.p2align 4,,10
	.p2align 3
.L3464:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3466
	.p2align 4,,10
	.p2align 3
.L3584:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3585
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3523
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3521:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L3586
.L3523:
	cmpl	$109, (%rdx)
	jne	.L3521
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L3527
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3526:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3525
.L3527:
	cmpl	$107, (%rax)
	jne	.L3526
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L3520
	.p2align 4,,10
	.p2align 3
.L3541:
	testq	%rcx, %rcx
	setne	%al
.L3483:
	testb	%al, %al
	jne	.L3484
	cmpl	$6, %r14d
	jne	.L3476
.L3532:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3587
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3492
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3490:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L3588
.L3492:
	cmpl	$109, (%rdx)
	jne	.L3490
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L3497
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3495:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3494
.L3497:
	cmpl	$107, (%rax)
	jne	.L3495
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3496:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbp
	je	.L3578
	vmovq	%rbp, %xmm3
	vcvttsd2siq	%xmm3, %rbp
.L3578:
	movq	%rbp, %rdx
	leaq	112(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movslq	16(%r12), %rdx
	movq	112(%rsp), %r15
	vmovdqu	120(%rsp), %xmm6
	testl	%edx, %edx
	jle	.L3580
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3501
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3500:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3580
.L3501:
	cmpl	$116, (%rax)
	jne	.L3500
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3499
	.p2align 4,,10
	.p2align 3
.L3475:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3479
.L3585:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	.p2align 4,,10
	.p2align 3
.L3525:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3520
.L3587:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L3494:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3496
	.p2align 4,,10
	.p2align 3
.L3586:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L3527
	.p2align 4,,10
	.p2align 3
.L3588:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3497
	.p2align 4,,10
	.p2align 3
.L3539:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3516:
	vmovsd	(%rdx,%rax,8), %xmm0
	vsubsd	(%rcx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%r15,%rax,8)
	addq	$1, %rax
	cmpq	%rbp, %rax
	jne	.L3516
	jmp	.L3512
	.p2align 4,,10
	.p2align 3
.L3581:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	setp	%al
	cmovne	%edx, %eax
	jmp	.L3483
	.p2align 4,,10
	.p2align 3
.L3576:
	vzeroupper
	jmp	.L3512
.L3540:
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.L3509
.L3583:
	vzeroupper
	jmp	.L3514
	.seh_endproc
	.section .rdata,"dr"
.LC78:
	.ascii "vlin.hadamard: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_hadamard
	.def	fn_vlin_hadamard;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_hadamard
fn_vlin_hadamard:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 208(%rsp)
	.seh_savexmm	%xmm6, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L3590
	cmpl	$1, %edx
	movl	(%r8), %r14d
	movq	8(%r8), %r12
	je	.L3671
	movl	16(%r8), %eax
	movq	24(%r8), %r13
	cmpl	$6, %eax
	movl	%eax, 44(%rsp)
	jne	.L3595
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3595
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3598
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3597:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3595
.L3598:
	cmpl	$107, (%rax)
	jne	.L3597
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L3596:
	cmpl	$6, %r14d
	jne	.L3600
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3600
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3604
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3603:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3600
.L3604:
	cmpl	$107, (%rax)
	jne	.L3603
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3602:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rsi
	movq	%rdx, 88(%rsp)
	leaq	80(%rsp), %rdi
	movq	%r8, 64(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movq	%rdi, %rdx
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$6, 44(%rsp)
	vmovdqu	96(%rsp), %xmm6
	jne	.L3593
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3593
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3608
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3607:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3593
.L3608:
	cmpl	$109, (%rax)
	jne	.L3607
	cmpl	$6, %r14d
	movq	16(%rax), %r8
	movq	24(%rax), %r9
	jne	.L3609
.L3718:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3611
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3616
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3614:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3611
.L3616:
	cmpl	$109, (%rax)
	jne	.L3614
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3615:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	movq	104(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	96(%rsp), %rax
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	movq	%rdx, 72(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L3668
.L3669:
	cmpl	$5, %edx
	je	.L3677
	cmpl	$2, %edx
	je	.L3677
	cmpl	$1, %edx
	je	.L3717
.L3620:
	call	arena_alloc.constprop.2
	leaq	.LC78(%rip), %rsi
	movq	%rbx, %rcx
	movq	$3, (%rax)
	movq	%rax, %rdx
	movq	%rsi, 8(%rax)
	call	fn_vcolors_red.constprop.0
	movq	104(%rsp), %rdx
	movl	96(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rbx, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	movq	304(%rsp), %rax
	vmovdqu	96(%rsp), %xmm2
	vmovdqu	%xmm2, (%rax)
.L3703:
	vmovaps	208(%rsp), %xmm6
	addq	$232, %rsp
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
.L3671:
	movl	$0, 44(%rsp)
	xorl	%r13d, %r13d
.L3595:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3596
	.p2align 4,,10
	.p2align 3
.L3590:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rsi
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	leaq	80(%rsp), %rdi
	movq	%rsi, %r8
	movq	%rbx, %rcx
	xorl	%r14d, %r14d
	movl	$44, %r9d
	movq	%rdi, %rdx
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	movl	$0, 44(%rsp)
	vmovdqu	96(%rsp), %xmm6
.L3593:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpl	$6, %r14d
	je	.L3718
.L3609:
	movq	%r8, 64(%rsp)
	movq	%rdi, %rdx
	movq	%rsi, %r8
	movq	%rbx, %rcx
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	call	vyne_binop
	movq	104(%rsp), %rdx
	movq	%rbx, %rcx
	movq	%rsi, %r8
	movq	96(%rsp), %rax
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	movq	%rdx, 72(%rsp)
	movq	%rdi, %rdx
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L3669
.L3612:
	movl	$31, %r9d
	movq	%rsi, %r8
	movq	%rdi, %rdx
	movq	%rbx, %rcx
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbp
	je	.L3715
	vmovq	%rbp, %xmm4
	vcvttsd2siq	%xmm4, %rbp
.L3715:
	leaq	112(%rsp), %rcx
	movq	%rbp, %rdx
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %r15
	vmovdqu	120(%rsp), %xmm6
.L3716:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3635:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, 44(%rsp)
	jne	.L3673
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L3673
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3640
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3639:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3673
.L3640:
	cmpl	$116, (%rax)
	jne	.L3639
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3638
	.p2align 4,,10
	.p2align 3
.L3673:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3638:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rbp, %rbp
	jle	.L3648
	cmpq	$1, %rbp
	movq	176(%rsp), %rcx
	movq	144(%rsp), %rdx
	je	.L3675
	movq	$-8, %rax
	movq	%rax, %r8
	subq	%rdx, %r8
	addq	%r15, %r8
	cmpq	$16, %r8
	jbe	.L3675
	subq	%rcx, %rax
	addq	%r15, %rax
	cmpq	$16, %rax
	jbe	.L3675
	leaq	-1(%rbp), %rax
	movq	%rbp, %r8
	cmpq	$2, %rax
	jbe	.L3676
	shrq	$2, %r8
	xorl	%eax, %eax
	salq	$5, %r8
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3646:
	vmovupd	(%rcx,%rax), %ymm0
	vmulpd	(%rdx,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%r15,%rax)
	addq	$32, %rax
	cmpq	%rax, %r8
	jne	.L3646
	movq	%rbp, %rax
	andq	$-4, %rax
	cmpq	%rax, %rbp
	movq	%rax, %r11
	je	.L3712
	movq	%rbp, %r8
	subq	%rax, %r8
	cmpq	$1, %r8
	je	.L3719
	vzeroupper
.L3645:
	vmovupd	(%rcx,%r11,8), %xmm0
	vmulpd	(%rdx,%r11,8), %xmm0, %xmm0
	testb	$1, %r8b
	vmovupd	%xmm0, (%r15,%r11,8)
	je	.L3648
	andq	$-2, %r8
	addq	%r8, %rax
.L3650:
	vmovsd	(%rdx,%rax,8), %xmm0
	vmulsd	(%rcx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%r15,%rax,8)
.L3648:
	call	arena_alloc.constprop.0
	cmpl	$6, %r14d
	movl	$11, %r8d
	movq	%r15, (%rax)
	movq	%rax, %r9
	vmovdqu	%xmm6, 8(%rax)
	je	.L3720
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L3656:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rsi, %r8
	movq	%r9, 56(%rsp)
	leaq	48(%rsp), %r9
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	96(%rsp), %xmm1
	vmovdqu	%xmm1, (%rax)
	jmp	.L3703
	.p2align 4,,10
	.p2align 3
.L3600:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3602
	.p2align 4,,10
	.p2align 3
.L3720:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3721
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3659
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3657:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L3722
.L3659:
	cmpl	$109, (%rdx)
	jne	.L3657
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L3663
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3662:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3661
.L3663:
	cmpl	$107, (%rax)
	jne	.L3662
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L3656
	.p2align 4,,10
	.p2align 3
.L3677:
	testq	%rcx, %rcx
	setne	%al
.L3619:
	testb	%al, %al
	jne	.L3620
	cmpl	$6, %r14d
	jne	.L3612
.L3668:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3723
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3628
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3626:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L3724
.L3628:
	cmpl	$109, (%rdx)
	jne	.L3626
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L3633
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3631:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3630
.L3633:
	cmpl	$107, (%rax)
	jne	.L3631
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3632:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rsi, %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbp
	je	.L3714
	vmovq	%rbp, %xmm3
	vcvttsd2siq	%xmm3, %rbp
.L3714:
	movq	%rbp, %rdx
	leaq	112(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movslq	16(%r12), %rdx
	movq	112(%rsp), %r15
	vmovdqu	120(%rsp), %xmm6
	testl	%edx, %edx
	jle	.L3716
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3637
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3636:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3716
.L3637:
	cmpl	$116, (%rax)
	jne	.L3636
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3635
	.p2align 4,,10
	.p2align 3
.L3611:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3615
.L3721:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	.p2align 4,,10
	.p2align 3
.L3661:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3656
.L3723:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L3630:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3632
	.p2align 4,,10
	.p2align 3
.L3722:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L3663
	.p2align 4,,10
	.p2align 3
.L3724:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3633
	.p2align 4,,10
	.p2align 3
.L3675:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3652:
	vmovsd	(%rcx,%rax,8), %xmm0
	vmulsd	(%rdx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%r15,%rax,8)
	addq	$1, %rax
	cmpq	%rbp, %rax
	jne	.L3652
	jmp	.L3648
	.p2align 4,,10
	.p2align 3
.L3717:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	setp	%al
	cmovne	%edx, %eax
	jmp	.L3619
	.p2align 4,,10
	.p2align 3
.L3712:
	vzeroupper
	jmp	.L3648
.L3676:
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.L3645
.L3719:
	vzeroupper
	jmp	.L3650
	.seh_endproc
	.section .rdata,"dr"
.LC79:
	.ascii "vlin.multiply: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_multiply
	.def	fn_vlin_multiply;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_multiply
fn_vlin_multiply:
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
	subq	$264, %rsp
	.seh_stackalloc	264
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L3726
	cmpl	$1, %edx
	movl	(%r8), %r12d
	movq	8(%r8), %rdi
	je	.L3787
	movl	16(%r8), %r15d
	movq	24(%r8), %rbp
	cmpl	$6, %r15d
	jne	.L3731
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L3731
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3734
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3733:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3731
.L3734:
	cmpl	$107, (%rax)
	jne	.L3733
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L3732:
	cmpl	$6, %r12d
	jne	.L3729
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L3737
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3742
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3740:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3737
.L3742:
	cmpl	$109, (%rax)
	jne	.L3740
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3741:
	leaq	96(%rsp), %r13
	leaq	112(%rsp), %r14
	movq	%rdx, 120(%rsp)
	leaq	128(%rsp), %rsi
	movq	%r8, 96(%rsp)
	movq	%r14, %rdx
	movq	%r13, %r8
	movq	%r9, 104(%rsp)
	movq	%rsi, %rcx
	movl	$44, %r9d
	movq	%rax, 112(%rsp)
	call	vyne_binop
	movq	128(%rsp), %rax
	movq	136(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L3780
.L3781:
	cmpl	$5, %edx
	je	.L3796
	cmpl	$2, %edx
	je	.L3796
	cmpl	$1, %edx
	je	.L3820
.L3746:
	call	arena_alloc.constprop.2
	leaq	.LC79(%rip), %rdi
	movq	%rsi, %rcx
	movq	$3, (%rax)
	movq	%rax, %rdx
	movq	%rdi, 8(%rax)
	call	fn_vcolors_red.constprop.0
	movq	136(%rsp), %rdx
	movl	128(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rsi, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	vmovdqu	128(%rsp), %xmm4
	vmovdqu	%xmm4, (%rbx)
.L3814:
	vmovaps	240(%rsp), %xmm6
	movq	%rbx, %rax
	addq	$264, %rsp
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
.L3787:
	xorl	%ebp, %ebp
	xorl	%r15d, %r15d
.L3731:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L3732
	.p2align 4,,10
	.p2align 3
.L3726:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%r12d, %r12d
	xorl	%edi, %edi
	xorl	%ebp, %ebp
	xorl	%r15d, %r15d
.L3729:
	leaq	96(%rsp), %r13
	leaq	112(%rsp), %r14
	movq	%r8, 96(%rsp)
	leaq	128(%rsp), %rsi
	movq	%r9, 104(%rsp)
	movq	%r14, %rdx
	movq	%r13, %r8
	movq	%rsi, %rcx
	movl	$44, %r9d
	movq	$0, 112(%rsp)
	movq	$0, 120(%rsp)
	call	vyne_binop
	movq	128(%rsp), %rax
	movq	136(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L3781
.L3748:
	movq	$0, 64(%rsp)
	movq	$0, 48(%rsp)
.L3762:
	cmpl	$6, %r15d
	jne	.L3791
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L3791
	movq	8(%rbp), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L3769
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3766:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L3773
.L3769:
	cmpl	$109, (%rdx)
	jne	.L3766
	cmpl	$2, 16(%rdx)
	jne	.L3773
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3767:
	cmpl	$109, (%rax)
	je	.L3821
	addq	$32, %rax
	cmpq	%rax, %rcx
	jne	.L3767
	movq	$0, 72(%rsp)
	xorl	%edx, %edx
.L3771:
	leaq	144(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movq	144(%rsp), %rax
	cmpl	$6, %r12d
	vmovdqu	152(%rsp), %xmm6
	movq	%rax, 56(%rsp)
	jne	.L3819
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jg	.L3784
	.p2align 4,,10
	.p2align 3
.L3819:
	leaq	176(%rsp), %rcx
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	call	vyne_value_to_array_f64.isra.0
	.p2align 4,,10
	.p2align 3
.L3782:
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L3795
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3779
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3778:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3795
.L3779:
	cmpl	$116, (%rax)
	jne	.L3778
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3777
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3772:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3791
.L3773:
	cmpl	$109, (%rax)
	jne	.L3772
	vcvttsd2siq	24(%rax), %rax
	movq	48(%rsp), %rdx
	movq	%rax, 72(%rsp)
	imulq	%rax, %rdx
	jmp	.L3765
	.p2align 4,,10
	.p2align 3
.L3791:
	movq	$0, 72(%rsp)
	xorl	%edx, %edx
.L3765:
	leaq	144(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movq	144(%rsp), %rax
	cmpl	$6, %r12d
	vmovdqu	152(%rsp), %xmm6
	movq	%rax, 56(%rsp)
	jne	.L3793
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L3793
.L3784:
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3776
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3775:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3793
.L3776:
	cmpl	$116, (%rax)
	jne	.L3775
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3774
	.p2align 4,,10
	.p2align 3
.L3793:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3774:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	cmpl	$6, %r15d
	je	.L3782
.L3777:
	leaq	208(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	72(%rsp), %rdi
	movq	64(%rsp), %rax
	movq	48(%rsp), %rbp
	movq	56(%rsp), %r15
	movq	%rdi, 40(%rsp)
	movq	208(%rsp), %r8
	movq	%rax, 32(%rsp)
	movq	176(%rsp), %rdx
	movq	%rbp, %r9
	movq	%r15, %rcx
	call	fn_vlin_k_matmul_native
	vzeroupper
	call	arena_alloc.constprop.0
	leaq	80(%rsp), %r9
	movq	%r13, %r8
	movq	%r15, (%rax)
	movq	%r14, %rdx
	movq	%rsi, %rcx
	vmovdqu	%xmm6, 8(%rax)
	movq	$2, 112(%rsp)
	movq	%rbp, 120(%rsp)
	movq	$2, 96(%rsp)
	movq	%rdi, 104(%rsp)
	movq	$11, 80(%rsp)
	movq	%rax, 88(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	128(%rsp), %xmm2
	vmovdqu	%xmm2, (%rbx)
	jmp	.L3814
	.p2align 4,,10
	.p2align 3
.L3796:
	testq	%rcx, %rcx
	setne	%al
.L3745:
	testb	%al, %al
	jne	.L3746
	cmpl	$6, %r12d
	jne	.L3748
.L3780:
	movslq	16(%rdi), %rax
	testl	%eax, %eax
	jle	.L3788
	movq	8(%rdi), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L3752
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3749:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L3816
.L3752:
	cmpl	$107, (%rcx)
	jne	.L3749
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L3750
	jmp	.L3816
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3753:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L3817
.L3750:
	cmpl	$107, (%r8)
	jne	.L3753
	movq	24(%r8), %rcx
	movq	%rcx, 48(%rsp)
	jmp	.L3754
	.p2align 4,,10
	.p2align 3
.L3737:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3741
	.p2align 4,,10
	.p2align 3
.L3816:
	movq	%rdx, %rcx
	jmp	.L3756
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3755:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L3817
.L3756:
	cmpl	$107, (%rcx)
	jne	.L3755
	vcvttsd2siq	24(%rcx), %rcx
	movq	%rcx, 48(%rsp)
.L3754:
	movq	%rdx, %rcx
	jmp	.L3760
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3757:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L3764
.L3760:
	cmpl	$109, (%rcx)
	jne	.L3757
	cmpl	$2, 16(%rcx)
	jne	.L3764
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3758:
	cmpl	$109, (%rdx)
	je	.L3822
	addq	$32, %rdx
	cmpq	%rdx, %rax
	jne	.L3758
.L3818:
	movq	$0, 64(%rsp)
	movl	$6, %r12d
	jmp	.L3762
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3763:
	addq	$32, %rdx
	cmpq	%rdx, %rax
	je	.L3818
.L3764:
	cmpl	$109, (%rdx)
	jne	.L3763
	vcvttsd2siq	24(%rdx), %rax
	movl	$6, %r12d
	movq	%rax, 64(%rsp)
	jmp	.L3762
	.p2align 4,,10
	.p2align 3
.L3795:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L3777
	.p2align 4,,10
	.p2align 3
.L3817:
	movq	$0, 48(%rsp)
	jmp	.L3754
	.p2align 4,,10
	.p2align 3
.L3820:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	setp	%al
	cmovne	%edx, %eax
	jmp	.L3745
.L3821:
	movq	24(%rax), %rax
	movq	48(%rsp), %rdx
	movq	%rax, 72(%rsp)
	imulq	%rax, %rdx
	jmp	.L3771
.L3822:
	movq	24(%rdx), %rax
	movl	$6, %r12d
	movq	%rax, 64(%rsp)
	jmp	.L3762
.L3788:
	movl	$6, %r12d
	jmp	.L3748
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC80:
	.ascii "vlin.multiply_trans_b: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_multiply_trans_b
	.def	fn_vlin_multiply_trans_b;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_multiply_trans_b
fn_vlin_multiply_trans_b:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 256(%rsp)
	.seh_savexmm	%xmm6, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 352(%rsp)
	jle	.L3824
	cmpl	$1, %edx
	movl	(%r8), %ebp
	movq	8(%r8), %r12
	je	.L3896
	movl	16(%r8), %edi
	movq	24(%r8), %rsi
	cmpl	$6, %edi
	jne	.L3829
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L3829
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3832
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3831:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3829
.L3832:
	cmpl	$109, (%rax)
	jne	.L3831
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
.L3830:
	cmpl	$6, %ebp
	jne	.L3827
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3835
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3840
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3838:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3835
.L3840:
	cmpl	$109, (%rax)
	jne	.L3838
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L3839:
	movq	%rcx, 112(%rsp)
	leaq	112(%rsp), %r8
	leaq	144(%rsp), %r15
	movl	$44, %r9d
	movq	%rax, 128(%rsp)
	leaq	128(%rsp), %rax
	movq	%r15, %rcx
	movq	%rdx, 136(%rsp)
	movq	%rax, %rdx
	movq	%rax, 88(%rsp)
	movq	%r15, 72(%rsp)
	movq	%rbx, 120(%rsp)
	movq	%r8, 80(%rsp)
	call	vyne_binop
	movq	144(%rsp), %rax
	movq	152(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L3889
.L3890:
	cmpl	$5, %edx
	je	.L3906
	cmpl	$2, %edx
	je	.L3906
	cmpl	$1, %edx
	je	.L3947
.L3844:
	call	arena_alloc.constprop.2
	leaq	.LC80(%rip), %rdi
	movq	%rdi, 8(%rax)
	movq	72(%rsp), %rdi
	movq	%rax, %rdx
	movq	$3, (%rax)
	movq	%rdi, %rcx
	call	fn_vcolors_red.constprop.0
	movq	152(%rsp), %rdx
	movl	144(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rdi, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	movq	352(%rsp), %rax
	vmovdqu	144(%rsp), %xmm5
	vmovdqu	%xmm5, (%rax)
.L3935:
	vmovaps	256(%rsp), %xmm6
	addq	$280, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L3896:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L3829:
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
	jmp	.L3830
.L3824:
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
	xorl	%ebp, %ebp
	xorl	%r12d, %r12d
	xorl	%esi, %esi
	xorl	%edi, %edi
.L3827:
	movq	%rbx, 120(%rsp)
	leaq	112(%rsp), %r8
	leaq	144(%rsp), %rax
	movl	$44, %r9d
	leaq	128(%rsp), %rbx
	movq	%rcx, 112(%rsp)
	movq	%rax, %rcx
	movq	%rbx, %rdx
	movq	%rax, 72(%rsp)
	movq	$0, 128(%rsp)
	movq	$0, 136(%rsp)
	movq	%r8, 80(%rsp)
	movq	%rbx, 88(%rsp)
	call	vyne_binop
	movq	144(%rsp), %rax
	movq	152(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L3890
.L3846:
	xorl	%ebx, %ebx
	xorl	%r11d, %r11d
.L3860:
	cmpl	$6, %edi
	jne	.L3900
	movl	16(%rsi), %eax
	testl	%eax, %eax
	jle	.L3900
	movq	8(%rsi), %rdx
	movslq	%eax, %rcx
	salq	$5, %rcx
	addq	%rdx, %rcx
	movq	%rdx, %rax
	jmp	.L3867
.L3864:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L3871
.L3867:
	cmpl	$107, (%rax)
	jne	.L3864
	cmpl	$2, 16(%rax)
	jne	.L3871
.L3865:
	cmpl	$107, (%rdx)
	je	.L3948
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	jne	.L3865
	xorl	%edx, %edx
	xorl	%r15d, %r15d
.L3869:
	leaq	160(%rsp), %rcx
	movq	%r11, 32(%rsp)
	call	fn_vlin_zeros_f64_native
	movq	160(%rsp), %rax
	cmpl	$6, %ebp
	vmovdqu	168(%rsp), %xmm6
	movq	32(%rsp), %r11
	movq	%rax, 48(%rsp)
	jne	.L3892
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jg	.L3893
.L3946:
	leaq	192(%rsp), %rcx
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	call	vyne_value_to_array_f64.isra.0
	movq	32(%rsp), %r11
.L3891:
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L3904
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3877
.L3876:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3904
.L3877:
	cmpl	$116, (%rax)
	jne	.L3876
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3875
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3870:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L3900
.L3871:
	cmpl	$107, (%rdx)
	jne	.L3870
	vcvttsd2siq	24(%rdx), %r15
	movq	%r11, %rdx
	imulq	%r15, %rdx
	jmp	.L3863
.L3900:
	xorl	%edx, %edx
	xorl	%r15d, %r15d
.L3863:
	leaq	160(%rsp), %rcx
	movq	%r11, 32(%rsp)
	call	fn_vlin_zeros_f64_native
	movq	160(%rsp), %rax
	cmpl	$6, %ebp
	vmovdqu	168(%rsp), %xmm6
	movq	32(%rsp), %r11
	movq	%rax, 48(%rsp)
	jne	.L3902
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L3902
.L3893:
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3874
.L3873:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L3902
.L3874:
	cmpl	$116, (%rax)
	jne	.L3873
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L3872
.L3902:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L3872:
	leaq	192(%rsp), %rcx
	movq	%r11, 32(%rsp)
	call	vyne_value_to_array_f64.isra.0
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	cmpl	$6, %edi
	movq	32(%rsp), %r11
	je	.L3891
.L3875:
	leaq	224(%rsp), %rcx
	movq	%r11, 32(%rsp)
	call	vyne_value_to_array_f64.isra.0
	movq	32(%rsp), %r11
	testq	%r11, %r11
	jle	.L3878
	testq	%r15, %r15
	jle	.L3878
	movq	48(%rsp), %rax
	movq	%rbx, %rdx
	movq	%r11, 56(%rsp)
	xorl	%edi, %edi
	leaq	0(,%r15,8), %r9
	shrq	$2, %rdx
	leaq	-1(%rbx), %r14
	movq	224(%rsp), %rsi
	movq	%r9, 64(%rsp)
	leaq	(%r9,%rax), %rbp
	xorl	%r12d, %r12d
	salq	$5, %rdx
	movq	192(%rsp), %r13
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L3880:
	movq	48(%rsp), %rax
	testq	%rbx, %rbx
	leaq	(%rax,%r12,8), %r8
	jle	.L3888
	movq	%r12, 32(%rsp)
	leaq	0(%r13,%rdi,8), %rax
	xorl	%r10d, %r10d
	movq	%r9, 40(%rsp)
	.p2align 4,,10
	.p2align 3
.L3886:
	cmpq	$2, %r14
	jbe	.L3905
	leaq	(%rsi,%r10,8), %r9
	xorl	%ecx, %ecx
	vxorpd	%xmm0, %xmm0, %xmm0
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L3882:
	vmovupd	(%rax,%rcx), %ymm1
	vmulpd	(%r9,%rcx), %ymm1, %ymm2
	addq	$32, %rcx
	cmpq	%rdx, %rcx
	vaddsd	%xmm2, %xmm0, %xmm0
	vunpckhpd	%xmm2, %xmm2, %xmm3
	vextractf128	$0x1, %ymm2, %xmm1
	vaddsd	%xmm0, %xmm3, %xmm3
	vaddsd	%xmm3, %xmm1, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	jne	.L3882
	movq	%rbx, %rcx
	andq	$-4, %rcx
	cmpq	%rbx, %rcx
	movq	%rcx, %r9
	je	.L3883
.L3881:
	movq	%rbx, %r11
	subq	%r9, %r11
	cmpq	$1, %r11
	je	.L3884
	leaq	(%r10,%r9), %r12
	addq	%rdi, %r9
	testb	$1, %r11b
	vmovupd	0(%r13,%r9,8), %xmm1
	vmulpd	(%rsi,%r12,8), %xmm1, %xmm1
	vaddsd	%xmm0, %xmm1, %xmm0
	vunpckhpd	%xmm1, %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	je	.L3883
	andq	$-2, %r11
	addq	%r11, %rcx
.L3884:
	leaq	(%r10,%rcx), %r9
	addq	%rdi, %rcx
	vmovsd	(%rsi,%r9,8), %xmm4
	vfmadd231sd	0(%r13,%rcx,8), %xmm4, %xmm0
.L3883:
	vmovsd	%xmm0, (%r8)
	addq	$8, %r8
	addq	%rbx, %r10
	cmpq	%r8, %rbp
	jne	.L3886
	movq	32(%rsp), %r12
	movq	40(%rsp), %r9
.L3887:
	addq	$1, %r9
	addq	%r15, %r12
	addq	64(%rsp), %rbp
	addq	%rbx, %rdi
	cmpq	56(%rsp), %r9
	jne	.L3880
	movq	56(%rsp), %r11
	vzeroupper
.L3878:
	movq	%r11, 32(%rsp)
	call	arena_alloc.constprop.0
	movq	48(%rsp), %rdi
	movq	32(%rsp), %r11
	leaq	96(%rsp), %r9
	movq	80(%rsp), %r8
	movq	88(%rsp), %rdx
	vmovdqu	%xmm6, 8(%rax)
	movq	%rdi, (%rax)
	movq	72(%rsp), %rcx
	movq	%rax, 104(%rsp)
	movq	$2, 128(%rsp)
	movq	%r11, 136(%rsp)
	movq	$2, 112(%rsp)
	movq	%r15, 120(%rsp)
	movq	$11, 96(%rsp)
	call	struct_vlin_Types_Matrix
	movq	352(%rsp), %rax
	vmovdqu	144(%rsp), %xmm5
	vmovdqu	%xmm5, (%rax)
	jmp	.L3935
.L3888:
	leaq	8(%r8), %rax
	movq	$0x000000000, (%r8)
	cmpq	%rax, %rbp
	je	.L3887
	movq	$0x000000000, 8(%r8)
	addq	$16, %r8
	cmpq	%rbp, %r8
	jne	.L3888
	jmp	.L3887
.L3905:
	xorl	%r9d, %r9d
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	jmp	.L3881
.L3835:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L3839
.L3906:
	testq	%rcx, %rcx
	setne	%al
.L3843:
	testb	%al, %al
	jne	.L3844
	cmpl	$6, %ebp
	jne	.L3846
.L3889:
	movslq	16(%r12), %rax
	testl	%eax, %eax
	jle	.L3897
	movq	8(%r12), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L3850
.L3847:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L3943
.L3850:
	cmpl	$107, (%rcx)
	jne	.L3847
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r8
	je	.L3848
	jmp	.L3943
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3851:
	addq	$32, %r8
	cmpq	%r8, %rax
	je	.L3944
.L3848:
	cmpl	$107, (%r8)
	jne	.L3851
	movq	24(%r8), %r11
	jmp	.L3852
.L3943:
	movq	%rdx, %rcx
	jmp	.L3854
.L3853:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L3944
.L3854:
	cmpl	$107, (%rcx)
	jne	.L3853
	vcvttsd2siq	24(%rcx), %r11
.L3852:
	movq	%rdx, %rcx
	jmp	.L3858
.L3855:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L3862
.L3858:
	cmpl	$109, (%rcx)
	jne	.L3855
	cmpl	$2, 16(%rcx)
	jne	.L3862
.L3856:
	cmpl	$109, (%rdx)
	je	.L3949
	addq	$32, %rdx
	cmpq	%rdx, %rax
	jne	.L3856
.L3945:
	movl	$6, %ebp
	xorl	%ebx, %ebx
	jmp	.L3860
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3861:
	addq	$32, %rdx
	cmpq	%rdx, %rax
	je	.L3945
.L3862:
	cmpl	$109, (%rdx)
	jne	.L3861
	vcvttsd2siq	24(%rdx), %rbx
	movl	$6, %ebp
	jmp	.L3860
.L3904:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L3875
.L3944:
	xorl	%r11d, %r11d
	jmp	.L3852
.L3947:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	setp	%al
	cmovne	%edx, %eax
	jmp	.L3843
.L3949:
	movq	24(%rdx), %rbx
	movl	$6, %ebp
	jmp	.L3860
.L3948:
	movq	24(%rdx), %r15
	movq	%r15, %rdx
	imulq	%r11, %rdx
	jmp	.L3869
.L3892:
	movq	%r11, 32(%rsp)
	jmp	.L3946
.L3897:
	movl	$6, %ebp
	jmp	.L3846
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_transpose
	.def	fn_vlin_transpose;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_transpose
fn_vlin_transpose:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 208(%rsp)
	.seh_savexmm	%xmm6, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L3951
	cmpl	$6, (%r8)
	jne	.L3951
	movq	8(%r8), %r8
	movslq	16(%r8), %rax
	testl	%eax, %eax
	jle	.L3953
	movq	8(%r8), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L3957
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3954:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L3994
.L3957:
	cmpl	$107, (%rcx)
	jne	.L3954
	cmpl	$2, 16(%rcx)
	movq	%rdx, %r9
	je	.L3955
.L3994:
	movq	%rdx, %rcx
	jmp	.L3961
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3960:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L3995
.L3961:
	cmpl	$107, (%rcx)
	jne	.L3960
	vcvttsd2siq	24(%rcx), %rbp
.L3959:
	movq	%rdx, %rcx
	jmp	.L3965
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3962:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L3970
.L3965:
	cmpl	$109, (%rcx)
	jne	.L3962
	cmpl	$2, 16(%rcx)
	jne	.L3970
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3963:
	cmpl	$109, (%rdx)
	je	.L3997
	addq	$32, %rdx
	cmpq	%rax, %rdx
	jne	.L3963
.L3968:
	leaq	144(%rsp), %rcx
	xorl	%edx, %edx
	movq	%r8, 40(%rsp)
	xorl	%esi, %esi
	call	fn_vlin_zeros_f64_native
	movq	144(%rsp), %rdi
	movq	40(%rsp), %r8
	vmovdqu	152(%rsp), %xmm6
.L3967:
	movslq	16(%r8), %rdx
	testl	%edx, %edx
	jle	.L3982
.L3971:
	movq	8(%r8), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L3976
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3975:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L3982
.L3976:
	cmpl	$116, (%rax)
	jne	.L3975
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L3974:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rbp, %rbp
	jle	.L3972
	testq	%rsi, %rsi
	jle	.L3972
	movq	176(%rsp), %rcx
	movq	%rdi, %r10
	xorl	%r9d, %r9d
	leaq	0(,%rsi,8), %r11
	leaq	0(,%rbp,8), %r8
	addq	%r11, %rcx
	.p2align 4,,10
	.p2align 3
.L3978:
	movq	%rcx, %rax
	movq	%r10, %rdx
	subq	%r11, %rax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L3979:
	vmovsd	(%rax), %xmm0
	addq	$8, %rax
	vmovsd	%xmm0, (%rdx)
	addq	%r8, %rdx
	cmpq	%rcx, %rax
	jne	.L3979
	addq	$1, %r9
	addq	$8, %r10
	addq	%r11, %rcx
	cmpq	%rbp, %r9
	jne	.L3978
.L3972:
	call	arena_alloc.constprop.0
	leaq	96(%rsp), %rcx
	leaq	80(%rsp), %rdx
	movq	%rdi, (%rax)
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	vmovdqu	%xmm6, 8(%rax)
	movq	%rax, 56(%rsp)
	movq	$2, 80(%rsp)
	movq	%rsi, 88(%rsp)
	movq	$2, 64(%rsp)
	movq	%rbp, 72(%rsp)
	movq	$11, 48(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%rbx, %rax
	vmovdqu	%xmm1, (%rbx)
	vmovaps	208(%rsp), %xmm6
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3958:
	addq	$32, %r9
	cmpq	%r9, %rax
	je	.L3995
.L3955:
	cmpl	$107, (%r9)
	jne	.L3958
	movq	24(%r9), %rbp
	jmp	.L3959
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L3969:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L3968
.L3970:
	cmpl	$109, (%rdx)
	jne	.L3969
	vcvttsd2siq	24(%rdx), %rsi
	movq	%r8, 40(%rsp)
.L3996:
	movq	%rsi, %rdx
	leaq	144(%rsp), %rcx
	imulq	%rbp, %rdx
	call	fn_vlin_zeros_f64_native
	movq	144(%rsp), %rdi
	movq	40(%rsp), %r8
	vmovdqu	152(%rsp), %xmm6
	jmp	.L3967
.L3951:
	leaq	144(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%esi, %esi
	xorl	%ebp, %ebp
	call	fn_vlin_zeros_f64_native
	leaq	112(%rsp), %rcx
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	movq	144(%rsp), %rdi
	vmovdqu	152(%rsp), %xmm6
	call	vyne_value_to_array_f64.isra.0
	jmp	.L3972
.L3982:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L3974
.L3995:
	xorl	%ebp, %ebp
	jmp	.L3959
.L3997:
	movq	%r8, 40(%rsp)
	movq	24(%rdx), %rsi
	jmp	.L3996
.L3953:
	xorl	%edx, %edx
	leaq	144(%rsp), %rcx
	xorl	%esi, %esi
	xorl	%ebp, %ebp
	movq	%r8, 40(%rsp)
	call	fn_vlin_zeros_f64_native
	movq	40(%rsp), %r8
	movq	144(%rsp), %rdi
	vmovdqu	152(%rsp), %xmm6
	movslq	16(%r8), %rdx
	testl	%edx, %edx
	jg	.L3971
	leaq	112(%rsp), %rcx
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	call	vyne_value_to_array_f64.isra.0
	jmp	.L3972
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_add_scalar
	.def	fn_vlin_add_scalar;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_add_scalar
fn_vlin_add_scalar:
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
	subq	$200, %rsp
	.seh_stackalloc	200
	vmovaps	%xmm6, 160(%rsp)
	.seh_savexmm	%xmm6, 160
	vmovaps	%xmm7, 176(%rsp)
	.seh_savexmm	%xmm7, 176
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L4042
	cmpl	$1, %edx
	movl	(%r8), %r13d
	movq	8(%r8), %r12
	vxorpd	%xmm6, %xmm6, %xmm6
	je	.L4000
	movq	24(%r8), %rax
	cmpl	$1, 16(%r8)
	vmovq	%rax, %xmm6
	je	.L4000
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vmovapd	%xmm0, %xmm6
.L4000:
	cmpl	$6, %r13d
	jne	.L3999
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4072
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L4008
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4006:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L4073
.L4008:
	cmpl	$109, (%rdx)
	jne	.L4006
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L4013
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4011:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L4010
.L4013:
	cmpl	$107, (%rax)
	jne	.L4011
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4012:
	leaq	80(%rsp), %rsi
	leaq	48(%rsp), %rdi
	movq	%rdx, 72(%rsp)
	leaq	64(%rsp), %rbp
	movq	%r8, 48(%rsp)
	movq	%rsi, %rcx
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movq	%rbp, %rdx
	movl	$31, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %r15
	je	.L4074
.L4005:
	vmovq	%r15, %xmm3
	leaq	96(%rsp), %rcx
	vcvttsd2siq	%xmm3, %r15
	movq	%r15, %rdx
	call	fn_vlin_zeros_f64_native
	cmpl	$6, %r13d
	movq	96(%rsp), %r14
	vmovdqu	104(%rsp), %xmm7
	je	.L4040
.L4071:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L4014:
	leaq	128(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%r15, %r15
	jle	.L4024
	cmpq	$1, %r15
	movq	128(%rsp), %rdx
	je	.L4047
	movq	%r14, %rax
	subq	%rdx, %rax
	subq	$8, %rax
	cmpq	$16, %rax
	jbe	.L4047
	leaq	-1(%r15), %rax
	movq	%r15, %rcx
	cmpq	$2, %rax
	jbe	.L4048
	shrq	$2, %rcx
	vbroadcastsd	%xmm6, %ymm1
	xorl	%eax, %eax
	salq	$5, %rcx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4022:
	vaddpd	(%rdx,%rax), %ymm1, %ymm0
	vmovupd	%ymm0, (%r14,%rax)
	addq	$32, %rax
	cmpq	%rcx, %rax
	jne	.L4022
	movq	%r15, %rax
	andq	$-4, %rax
	cmpq	%rax, %r15
	movq	%rax, %r8
	je	.L4069
	movq	%r15, %rcx
	subq	%rax, %rcx
	cmpq	$1, %rcx
	je	.L4075
	vzeroupper
.L4021:
	vmovddup	%xmm6, %xmm0
	vaddpd	(%rdx,%r8,8), %xmm0, %xmm0
	testb	$1, %cl
	vmovupd	%xmm0, (%r14,%r8,8)
	je	.L4024
	andq	$-2, %rcx
	addq	%rcx, %rax
.L4026:
	vaddsd	(%rdx,%rax,8), %xmm6, %xmm6
	vmovsd	%xmm6, (%r14,%rax,8)
.L4024:
	call	arena_alloc.constprop.0
	cmpl	$6, %r13d
	movl	$11, %r8d
	movq	%r14, (%rax)
	movq	%rax, %r9
	vmovdqu	%xmm7, 8(%rax)
	je	.L4076
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L4032:
	movq	%rdx, 72(%rsp)
	movq	%rsi, %rcx
	movq	%rbp, %rdx
	movq	%r8, 32(%rsp)
	movq	%rdi, %r8
	movq	%r9, 40(%rsp)
	leaq	32(%rsp), %r9
	movq	%rax, 64(%rsp)
	movq	%r10, 48(%rsp)
	movq	%r11, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	80(%rsp), %xmm2
	movq	%rbx, %rax
	vmovdqu	%xmm2, (%rbx)
	vmovaps	160(%rsp), %xmm6
	vmovaps	176(%rsp), %xmm7
	addq	$200, %rsp
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
.L4042:
	xorl	%r12d, %r12d
	vxorpd	%xmm6, %xmm6, %xmm6
	xorl	%r13d, %r13d
.L3999:
	leaq	80(%rsp), %rsi
	leaq	48(%rsp), %rdi
	movl	$31, %r9d
	movq	$0, 64(%rsp)
	leaq	64(%rsp), %rbp
	movq	%rdi, %r8
	movq	%rsi, %rcx
	movq	$0, 72(%rsp)
	movq	$0, 48(%rsp)
	movq	%rbp, %rdx
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %r15
	jne	.L4005
	movq	%r15, %rdx
	leaq	96(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movq	96(%rsp), %r14
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	vmovdqu	104(%rsp), %xmm7
	jmp	.L4014
	.p2align 4,,10
	.p2align 3
.L4074:
	leaq	96(%rsp), %rcx
	movq	%r15, %rdx
	call	fn_vlin_zeros_f64_native
	movq	96(%rsp), %r14
	vmovdqu	104(%rsp), %xmm7
.L4040:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4045
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4016
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4015:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4045
.L4016:
	cmpl	$116, (%rax)
	jne	.L4015
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	movl	$6, %r13d
	jmp	.L4014
	.p2align 4,,10
	.p2align 3
.L4076:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4077
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L4035
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4033:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L4078
.L4035:
	cmpl	$109, (%rdx)
	jne	.L4033
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L4039
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4038:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L4037
.L4039:
	cmpl	$107, (%rax)
	jne	.L4038
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L4032
	.p2align 4,,10
	.p2align 3
.L4045:
	movl	$6, %r13d
	jmp	.L4071
.L4072:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L4010:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4012
.L4077:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	.p2align 4,,10
	.p2align 3
.L4037:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4032
	.p2align 4,,10
	.p2align 3
.L4073:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4013
	.p2align 4,,10
	.p2align 3
.L4078:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L4039
	.p2align 4,,10
	.p2align 3
.L4069:
	vzeroupper
	jmp	.L4024
	.p2align 4,,10
	.p2align 3
.L4047:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4028:
	vaddsd	(%rdx,%rax,8), %xmm6, %xmm0
	vmovsd	%xmm0, (%r14,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r15
	jne	.L4028
	jmp	.L4024
.L4048:
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.L4021
.L4075:
	vzeroupper
	jmp	.L4026
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_multiply_scalar
	.def	fn_vlin_multiply_scalar;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_multiply_scalar
fn_vlin_multiply_scalar:
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
	subq	$200, %rsp
	.seh_stackalloc	200
	vmovaps	%xmm6, 160(%rsp)
	.seh_savexmm	%xmm6, 160
	vmovaps	%xmm7, 176(%rsp)
	.seh_savexmm	%xmm7, 176
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L4123
	cmpl	$1, %edx
	movl	(%r8), %r13d
	movq	8(%r8), %r12
	vxorpd	%xmm6, %xmm6, %xmm6
	je	.L4081
	movq	24(%r8), %rax
	cmpl	$1, 16(%r8)
	vmovq	%rax, %xmm6
	je	.L4081
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vmovapd	%xmm0, %xmm6
.L4081:
	cmpl	$6, %r13d
	jne	.L4080
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4153
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L4089
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4087:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L4154
.L4089:
	cmpl	$109, (%rdx)
	jne	.L4087
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L4094
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4092:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L4091
.L4094:
	cmpl	$107, (%rax)
	jne	.L4092
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4093:
	leaq	80(%rsp), %rsi
	leaq	48(%rsp), %rdi
	movq	%rdx, 72(%rsp)
	leaq	64(%rsp), %rbp
	movq	%r8, 48(%rsp)
	movq	%rsi, %rcx
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movq	%rbp, %rdx
	movl	$31, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %r15
	je	.L4155
.L4086:
	vmovq	%r15, %xmm3
	leaq	96(%rsp), %rcx
	vcvttsd2siq	%xmm3, %r15
	movq	%r15, %rdx
	call	fn_vlin_zeros_f64_native
	cmpl	$6, %r13d
	movq	96(%rsp), %r14
	vmovdqu	104(%rsp), %xmm7
	je	.L4121
.L4152:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L4095:
	leaq	128(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%r15, %r15
	jle	.L4105
	cmpq	$1, %r15
	movq	128(%rsp), %rdx
	je	.L4128
	movq	%r14, %rax
	subq	%rdx, %rax
	subq	$8, %rax
	cmpq	$16, %rax
	jbe	.L4128
	leaq	-1(%r15), %rax
	movq	%r15, %rcx
	cmpq	$2, %rax
	jbe	.L4129
	shrq	$2, %rcx
	vbroadcastsd	%xmm6, %ymm1
	xorl	%eax, %eax
	salq	$5, %rcx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4103:
	vmulpd	(%rdx,%rax), %ymm1, %ymm0
	vmovupd	%ymm0, (%r14,%rax)
	addq	$32, %rax
	cmpq	%rcx, %rax
	jne	.L4103
	movq	%r15, %rax
	andq	$-4, %rax
	cmpq	%rax, %r15
	movq	%rax, %r8
	je	.L4150
	movq	%r15, %rcx
	subq	%rax, %rcx
	cmpq	$1, %rcx
	je	.L4156
	vzeroupper
.L4102:
	vmovddup	%xmm6, %xmm0
	testb	$1, %cl
	vmulpd	(%rdx,%r8,8), %xmm0, %xmm0
	vmovupd	%xmm0, (%r14,%r8,8)
	je	.L4105
	andq	$-2, %rcx
	addq	%rcx, %rax
.L4107:
	vmulsd	(%rdx,%rax,8), %xmm6, %xmm6
	vmovsd	%xmm6, (%r14,%rax,8)
.L4105:
	call	arena_alloc.constprop.0
	cmpl	$6, %r13d
	movl	$11, %r8d
	movq	%r14, (%rax)
	movq	%rax, %r9
	vmovdqu	%xmm7, 8(%rax)
	je	.L4157
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L4113:
	movq	%rdx, 72(%rsp)
	movq	%rsi, %rcx
	movq	%rbp, %rdx
	movq	%r8, 32(%rsp)
	movq	%rdi, %r8
	movq	%r9, 40(%rsp)
	leaq	32(%rsp), %r9
	movq	%rax, 64(%rsp)
	movq	%r10, 48(%rsp)
	movq	%r11, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	80(%rsp), %xmm2
	movq	%rbx, %rax
	vmovdqu	%xmm2, (%rbx)
	vmovaps	160(%rsp), %xmm6
	vmovaps	176(%rsp), %xmm7
	addq	$200, %rsp
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
.L4123:
	xorl	%r12d, %r12d
	vxorpd	%xmm6, %xmm6, %xmm6
	xorl	%r13d, %r13d
.L4080:
	leaq	80(%rsp), %rsi
	leaq	48(%rsp), %rdi
	movl	$31, %r9d
	movq	$0, 64(%rsp)
	leaq	64(%rsp), %rbp
	movq	%rdi, %r8
	movq	%rsi, %rcx
	movq	$0, 72(%rsp)
	movq	$0, 48(%rsp)
	movq	%rbp, %rdx
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %r15
	jne	.L4086
	movq	%r15, %rdx
	leaq	96(%rsp), %rcx
	call	fn_vlin_zeros_f64_native
	movq	96(%rsp), %r14
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	vmovdqu	104(%rsp), %xmm7
	jmp	.L4095
	.p2align 4,,10
	.p2align 3
.L4155:
	leaq	96(%rsp), %rcx
	movq	%r15, %rdx
	call	fn_vlin_zeros_f64_native
	movq	96(%rsp), %r14
	vmovdqu	104(%rsp), %xmm7
.L4121:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4126
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4097
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4096:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4126
.L4097:
	cmpl	$116, (%rax)
	jne	.L4096
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	movl	$6, %r13d
	jmp	.L4095
	.p2align 4,,10
	.p2align 3
.L4157:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4158
	movq	8(%r12), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L4116
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4114:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L4159
.L4116:
	cmpl	$109, (%rdx)
	jne	.L4114
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L4120
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4119:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L4118
.L4120:
	cmpl	$107, (%rax)
	jne	.L4119
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L4113
	.p2align 4,,10
	.p2align 3
.L4126:
	movl	$6, %r13d
	jmp	.L4152
.L4153:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L4091:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4093
.L4158:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	.p2align 4,,10
	.p2align 3
.L4118:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4113
	.p2align 4,,10
	.p2align 3
.L4154:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4094
	.p2align 4,,10
	.p2align 3
.L4159:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L4120
	.p2align 4,,10
	.p2align 3
.L4150:
	vzeroupper
	jmp	.L4105
	.p2align 4,,10
	.p2align 3
.L4128:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4109:
	vmulsd	(%rdx,%rax,8), %xmm6, %xmm0
	vmovsd	%xmm0, (%r14,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %r15
	jne	.L4109
	jmp	.L4105
.L4129:
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.L4102
.L4156:
	vzeroupper
	jmp	.L4107
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_clip
	.def	fn_vlin_clip;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_clip
fn_vlin_clip:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	vmovaps	%xmm7, 192(%rsp)
	.seh_savexmm	%xmm7, 192
	vmovaps	%xmm8, 208(%rsp)
	.seh_savexmm	%xmm8, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r12
	jle	.L4167
	cmpl	$1, %edx
	movl	(%r8), %ecx
	je	.L4195
	movq	24(%r8), %rax
	cmpl	$1, 16(%r8)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovq	%rax, %xmm7
	je	.L4164
	vcvtsi2sdq	%rax, %xmm0, %xmm7
.L4164:
	cmpl	$2, %edx
	je	.L4196
	cmpl	$1, 32(%r8)
	movq	40(%r8), %rax
	je	.L4211
	vcvtsi2sdq	%rax, %xmm0, %xmm0
.L4162:
	cmpl	$6, %ecx
	jne	.L4167
	movq	8(%r8), %rbx
	movslq	16(%rbx), %rax
	testl	%eax, %eax
	jle	.L4167
	movq	8(%rbx), %rdx
	salq	$5, %rax
	addq	%rdx, %rax
	movq	%rdx, %rcx
	jmp	.L4171
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4168:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L4212
.L4171:
	cmpl	$107, (%rcx)
	jne	.L4168
	cmpl	$2, 16(%rcx)
	movq	%rdx, %rcx
	jne	.L4175
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4169:
	cmpl	$107, (%rcx)
	je	.L4213
	addq	$32, %rcx
	cmpq	%rax, %rcx
	jne	.L4169
.L4209:
	xorl	%r13d, %r13d
.L4173:
	movq	%rdx, %rcx
	jmp	.L4179
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4176:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L4185
.L4179:
	cmpl	$109, (%rcx)
	jne	.L4176
	cmpl	$2, 16(%rcx)
	jne	.L4185
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4177:
	cmpl	$109, (%rdx)
	je	.L4214
	addq	$32, %rdx
	cmpq	%rdx, %rax
	jne	.L4177
	leaq	112(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%r14d, %r14d
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %rsi
	vmovdqu	120(%rsp), %xmm8
	jmp	.L4186
	.p2align 4,,10
	.p2align 3
.L4167:
	leaq	112(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%r13d, %r13d
	xorl	%r14d, %r14d
	call	fn_vlin_zeros_f64_native
	movq	112(%rsp), %rsi
	vmovdqu	120(%rsp), %xmm8
.L4186:
	call	arena_alloc.constprop.0
	leaq	96(%rsp), %rcx
	leaq	80(%rsp), %rdx
	movq	%rsi, (%rax)
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	vmovdqu	%xmm8, 8(%rax)
	movq	%rax, 56(%rsp)
	movq	$2, 80(%rsp)
	movq	%r13, 88(%rsp)
	movq	$2, 64(%rsp)
	movq	%r14, 72(%rsp)
	movq	$11, 48(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%r12, %rax
	vmovdqu	%xmm1, (%r12)
	vmovaps	176(%rsp), %xmm6
	vmovaps	192(%rsp), %xmm7
	vmovaps	208(%rsp), %xmm8
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4174:
	addq	$32, %rcx
	cmpq	%rax, %rcx
	je	.L4209
.L4175:
	cmpl	$107, (%rcx)
	jne	.L4174
	vcvttsd2siq	24(%rcx), %r13
	jmp	.L4173
.L4195:
	vxorpd	%xmm7, %xmm7, %xmm7
	vmovapd	%xmm7, %xmm0
	jmp	.L4162
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4183:
	addq	$32, %rdx
	cmpq	%rdx, %rax
	je	.L4215
.L4185:
	cmpl	$109, (%rdx)
	jne	.L4183
	vcvttsd2siq	24(%rdx), %r14
	movq	%r14, %rdi
	imulq	%r13, %rdi
.L4181:
	leaq	112(%rsp), %rcx
	movq	%rdi, %rdx
	vmovsd	%xmm0, 40(%rsp)
	call	fn_vlin_zeros_f64_native
	testq	%rdi, %rdi
	movq	112(%rsp), %rsi
	vmovdqu	120(%rsp), %xmm8
	vmovsd	40(%rsp), %xmm0
	jle	.L4186
	vminsd	%xmm7, %xmm0, %xmm6
	vmaxsd	%xmm0, %xmm7, %xmm7
	xorl	%r15d, %r15d
	leaq	144(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L4194:
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L4198
.L4216:
	movq	8(%rbx), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4190
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4189:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4198
.L4190:
	cmpl	$116, (%rax)
	jne	.L4189
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L4188:
	movq	%rbp, %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vmovsd	(%rax,%r15,8), %xmm0
	vcomisd	%xmm0, %xmm6
	ja	.L4191
	vminsd	%xmm0, %xmm7, %xmm0
	vmovsd	%xmm0, (%rsi,%r15,8)
	addq	$1, %r15
	cmpq	%r15, %rdi
	je	.L4186
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jg	.L4216
	.p2align 4,,10
	.p2align 3
.L4198:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L4188
.L4212:
	movq	%rdx, %rcx
	jmp	.L4175
	.p2align 4,,10
	.p2align 3
.L4191:
	vmovsd	%xmm6, (%rsi,%r15,8)
	addq	$1, %r15
	cmpq	%r15, %rdi
	jne	.L4194
	jmp	.L4186
.L4215:
	xorl	%edi, %edi
	xorl	%r14d, %r14d
	jmp	.L4181
.L4211:
	vmovq	%rax, %xmm0
	jmp	.L4162
.L4213:
	movq	24(%rcx), %r13
	jmp	.L4173
.L4214:
	movq	24(%rdx), %r14
	movq	%r14, %rdi
	imulq	%r13, %rdi
	jmp	.L4181
.L4196:
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L4162
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_add_bias
	.def	fn_vlin_add_bias;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_add_bias
fn_vlin_add_bias:
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
	subq	$296, %rsp
	.seh_stackalloc	296
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	vmovaps	%xmm7, 256(%rsp)
	.seh_savexmm	%xmm7, 256
	vmovaps	%xmm8, 272(%rsp)
	.seh_savexmm	%xmm8, 272
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r15
	jle	.L4223
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %rdi
	je	.L4334
	movq	24(%r8), %rbx
	movq	16(%r8), %rbp
	movq	%rbx, 32(%rsp)
.L4222:
	cmpl	$6, %eax
	jne	.L4223
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L4223
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	movq	%rax, %rcx
	jmp	.L4228
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4225:
	addq	$32, %rcx
	cmpq	%rcx, %rdx
	je	.L4329
.L4228:
	cmpl	$107, (%rcx)
	jne	.L4225
	cmpl	$2, 16(%rcx)
	movq	%rax, %r8
	je	.L4226
.L4329:
	movq	%rax, %rcx
	jmp	.L4232
.L4231:
	addq	$32, %rcx
	cmpq	%rdx, %rcx
	je	.L4330
.L4232:
	cmpl	$107, (%rcx)
	jne	.L4231
	vcvttsd2siq	24(%rcx), %r8
.L4230:
	movq	%rax, %rcx
	jmp	.L4236
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4233:
	addq	$32, %rcx
	cmpq	%rcx, %rdx
	je	.L4241
.L4236:
	cmpl	$109, (%rcx)
	jne	.L4233
	cmpl	$2, 16(%rcx)
	jne	.L4241
.L4234:
	cmpl	$109, (%rax)
	je	.L4335
	addq	$32, %rax
	cmpq	%rax, %rdx
	jne	.L4234
.L4331:
	movq	$0, 40(%rsp)
	xorl	%edx, %edx
.L4238:
	leaq	208(%rsp), %rcx
	movq	%r8, 56(%rsp)
	call	fn_vlin_zeros_f64_native
	movq	56(%rsp), %r8
	movq	208(%rsp), %rax
	vmovdqu	216(%rsp), %xmm8
	testq	%r8, %r8
	movq	%rax, 48(%rsp)
	jle	.L4242
	cmpq	$0, 40(%rsp)
	jle	.L4242
	movq	%r8, 104(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%eax, %eax
	movq	%rdi, %r14
	vmovdqa	.LC3(%rip), %xmm7
	movq	%r15, 368(%rsp)
	leaq	_vyne_char_pool(%rip), %rbx
	xorl	%r15d, %r15d
	.p2align 4,,10
	.p2align 3
.L4287:
	movq	%rax, 64(%rsp)
	leaq	0(,%r15,8), %rdi
	xorl	%esi, %esi
	movq	%r15, 72(%rsp)
	.p2align 4,,10
	.p2align 3
.L4286:
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4243
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4247
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4244:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4243
.L4247:
	cmpl	$116, (%rax)
	jne	.L4244
	movl	16(%rax), %edx
	movq	24(%rax), %r9
	cmpl	$11, %edx
	je	.L4336
	cmpl	$12, %edx
	je	.L4337
	cmpl	$4, %edx
	jne	.L4243
	movslq	8(%r9), %r15
	movq	g_arena_cur(%rip), %rcx
	movl	$32, %eax
	testq	%r15, %r15
	leaq	0(,%r15,8), %rdx
	cmovle	%rax, %rdx
	testq	%rcx, %rcx
	je	.L4262
	movq	g_arena_end(%rip), %rax
	subq	%rcx, %rax
	cmpq	%rdx, %rax
	jb	.L4262
	leaq	(%rcx,%rdx), %rax
	addq	8+g_arena(%rip), %rdx
	movq	%rax, g_arena_cur(%rip)
	leaq	g_arena(%rip), %rax
.L4266:
	testq	%r15, %r15
	movq	%rdx, 8(%rax)
	jle	.L4248
	leaq	0(,%r15,8), %r8
	xorl	%edx, %edx
	salq	$4, %r15
	movq	%r9, 56(%rsp)
	call	memset
	movq	56(%rsp), %r9
	movq	%rax, %rcx
	movq	(%r9), %rax
	movq	%rcx, %rdx
	addq	%rax, %r15
	jmp	.L4271
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4268:
	addq	$16, %rax
	vcvtsi2sdq	%r8, %xmm6, %xmm0
	vmovlpd	%xmm0, (%rdx)
	cmpq	%rax, %r15
	je	.L4248
.L4332:
	addq	$8, %rdx
.L4271:
	cmpl	$1, (%rax)
	movq	8(%rax), %r8
	jne	.L4268
	addq	$16, %rax
	movq	%r8, (%rdx)
	cmpq	%rax, %r15
	jne	.L4332
	.p2align 4,,10
	.p2align 3
.L4248:
	cmpl	$4, %ebp
	movq	(%rcx,%rdi), %r15
	je	.L4319
.L4339:
	cmpl	$11, %ebp
	je	.L4272
	cmpl	$12, %ebp
	je	.L4338
	cmpl	$3, %ebp
	jne	.L4274
	movq	32(%rsp), %rcx
	movl	%ebp, 56(%rsp)
	call	strlen
	testl	%esi, %esi
	js	.L4274
	cmpl	%eax, %esi
	jge	.L4274
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	56(%rsp), %edx
	movl	%esi, %r8d
	testl	%eax, %eax
	jne	.L4281
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4282:
	leaq	1(%rax), %rcx
	movb	%al, (%rbx,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rcx
	movb	%cl, (%rbx,%rcx,2)
	movb	%al, (%rbx,%rax,2)
	leaq	2(%rcx), %rax
	jne	.L4282
	movl	$1, _vyne_char_pool_ready(%rip)
.L4281:
	movq	32(%rsp), %rcx
	movslq	%r8d, %rax
	movq	$3, 112(%rsp)
	movq	112(%rsp), %r10
	movzbl	(%rcx,%rax), %eax
	leaq	(%rbx,%rax,2), %rax
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L4278:
	movabsq	$-4294967296, %r11
	movl	%edx, %edx
	movl	$1, %r8d
	movq	%r15, %r9
	andq	%r11, %r10
	orq	%rdx, %r10
	movq	%r10, %rax
.L4288:
	movq	%r8, 176(%rsp)
	leaq	176(%rsp), %rdx
	leaq	160(%rsp), %r8
	movq	%r9, 184(%rsp)
	movl	$29, %r9d
	movq	%rcx, 168(%rsp)
	leaq	192(%rsp), %rcx
	movq	%rax, 160(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 192(%rsp)
	vmovsd	200(%rsp), %xmm0
	je	.L4285
	vcvtsi2sdq	200(%rsp), %xmm6, %xmm0
.L4285:
	movq	48(%rsp), %rax
	addq	$1, %rsi
	vmovsd	%xmm0, (%rax,%rdi)
	addq	$8, %rdi
	cmpq	%rsi, 40(%rsp)
	jne	.L4286
	movq	64(%rsp), %rax
	movq	104(%rsp), %rdi
	movq	72(%rsp), %r15
	addq	40(%rsp), %r15
	addq	$1, %rax
	cmpq	%rdi, %rax
	jne	.L4287
	movq	368(%rsp), %r15
	movq	%rdi, %r8
	jmp	.L4221
.L4223:
	leaq	208(%rsp), %rcx
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fn_vlin_zeros_f64_native
	movq	208(%rsp), %rax
	xorl	%r8d, %r8d
	vmovdqu	216(%rsp), %xmm8
	movq	%rax, 48(%rsp)
.L4221:
	movq	%r8, 32(%rsp)
	call	arena_alloc.constprop.0
	movq	48(%rsp), %rbx
	movq	32(%rsp), %r8
	leaq	192(%rsp), %rcx
	vmovdqu	%xmm8, 8(%rax)
	leaq	176(%rsp), %rdx
	leaq	144(%rsp), %r9
	movq	%rbx, (%rax)
	movq	%r8, 184(%rsp)
	leaq	160(%rsp), %r8
	movq	%rax, 152(%rsp)
	movq	$2, 176(%rsp)
	movq	$2, 160(%rsp)
	movq	%rsi, 168(%rsp)
	movq	$11, 144(%rsp)
	call	struct_vlin_Types_Matrix
	movq	%r15, %rax
	vmovdqu	192(%rsp), %xmm4
	vmovdqu	%xmm4, (%r15)
	vmovaps	240(%rsp), %xmm6
	vmovaps	256(%rsp), %xmm7
	vmovaps	272(%rsp), %xmm8
	addq	$296, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L4229:
	addq	$32, %r8
	cmpq	%rdx, %r8
	je	.L4330
.L4226:
	cmpl	$107, (%r8)
	jne	.L4229
	movq	24(%r8), %r8
	jmp	.L4230
.L4334:
	movq	$0, 32(%rsp)
	xorl	%ebp, %ebp
	jmp	.L4222
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4239:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4331
.L4241:
	cmpl	$109, (%rax)
	jne	.L4239
	vcvttsd2siq	24(%rax), %rax
	movq	%rax, 40(%rsp)
	imulq	%r8, %rax
	movq	%rax, %rdx
	jmp	.L4238
	.p2align 4,,10
	.p2align 3
.L4274:
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	jmp	.L4278
	.p2align 4,,10
	.p2align 3
.L4243:
	movq	g_arena_cur(%rip), %rcx
	testq	%rcx, %rcx
	je	.L4256
	movq	g_arena_end(%rip), %rax
	subq	%rcx, %rax
	cmpq	$31, %rax
	jbe	.L4256
	movq	8+g_arena(%rip), %rdx
	leaq	32(%rcx), %rax
	movq	%rax, g_arena_cur(%rip)
	leaq	g_arena(%rip), %rax
	addq	$32, %rdx
.L4260:
	cmpl	$4, %ebp
	movq	%rdx, 8(%rax)
	movq	(%rcx,%rdi), %r15
	jne	.L4339
.L4319:
	movq	32(%rsp), %rax
	movslq	8(%rax), %rax
	cmpq	%rax, %rsi
	jge	.L4274
	movq	32(%rsp), %rax
	movq	%rsi, %rdx
	movl	$1, %r8d
	movq	%r15, %r9
	salq	$4, %rdx
	addq	(%rax), %rdx
	movabsq	$-4294967296, %rax
	movl	(%rdx), %r11d
	andq	(%rdx), %rax
	movq	8(%rdx), %rcx
	orq	%r11, %rax
	cmpl	$1, %r11d
	je	.L4279
	jmp	.L4288
	.p2align 4,,10
	.p2align 3
.L4336:
	movq	(%r9), %rcx
	jmp	.L4248
	.p2align 4,,10
	.p2align 3
.L4272:
	cmpl	$4, %ebp
	je	.L4319
	movq	32(%rsp), %rax
	cmpq	8(%rax), %rsi
	jge	.L4274
	movq	(%rax), %rax
	movq	(%rax,%rsi,8), %rcx
	.p2align 4,,10
	.p2align 3
.L4279:
	vmovq	%r15, %xmm1
	vmovq	%rcx, %xmm2
	vaddsd	%xmm2, %xmm1, %xmm0
	jmp	.L4285
	.p2align 4,,10
	.p2align 3
.L4338:
	movq	32(%rsp), %rax
	cmpq	8(%rax), %rsi
	jge	.L4274
	movq	(%rax), %rax
	movl	$2, %edx
	movq	$2, 128(%rsp)
	movq	128(%rsp), %r10
	movq	(%rax,%rsi,8), %rcx
	jmp	.L4278
	.p2align 4,,10
	.p2align 3
.L4337:
	movq	8(%r9), %r8
	movq	%r9, 56(%rsp)
	testq	%r8, %r8
	jle	.L4250
	leaq	0(,%r8,8), %r15
	movq	%r15, %rcx
	call	arena_alloc
	movq	%r15, %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	56(%rsp), %r9
	movq	%rax, %rcx
.L4251:
	movq	8(%r9), %rdx
	testq	%rdx, %rdx
	jle	.L4248
	movq	(%r9), %r8
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4253:
	vcvtsi2sdq	(%r8,%rax,8), %xmm6, %xmm0
	vmovlpd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L4253
	jmp	.L4248
	.p2align 4,,10
	.p2align 3
.L4256:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r15
	je	.L4333
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, (%r15)
	movq	%rax, %rcx
	je	.L4265
	movq	g_arena(%rip), %rdx
	vmovdqu	%xmm7, 8(%r15)
	leaq	g_arena(%rip), %rax
	movq	%r15, g_arena(%rip)
	movq	%rdx, 24(%r15)
	leaq	32(%rcx), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rcx), %rdx
	movq	%rdx, g_arena_end(%rip)
	movq	8+g_arena(%rip), %rdx
	addq	$32, %rdx
	jmp	.L4260
	.p2align 4,,10
	.p2align 3
.L4262:
	movl	$32, %ecx
	movq	%r9, 80(%rsp)
	movq	%rdx, 56(%rsp)
	call	malloc
	movq	56(%rsp), %rdx
	movq	80(%rsp), %r9
	testq	%rax, %rax
	je	.L4333
	movl	$8388608, %r10d
	movq	%rax, 96(%rsp)
	cmpq	%r10, %rdx
	movq	%r9, 88(%rsp)
	cmovnb	%rdx, %r10
	movq	%rdx, 80(%rsp)
	movq	%r10, %rcx
	movq	%r10, 56(%rsp)
	call	malloc
	movq	96(%rsp), %r8
	testq	%rax, %rax
	movq	%rax, %rcx
	movq	%rax, (%r8)
	je	.L4265
	movq	80(%rsp), %rdx
	movq	56(%rsp), %r10
	leaq	g_arena(%rip), %rax
	movq	g_arena(%rip), %r11
	movq	%r8, g_arena(%rip)
	vmovq	%rdx, %xmm3
	movq	88(%rsp), %r9
	vpinsrq	$1, %r10, %xmm3, %xmm0
	movq	%r11, 24(%r8)
	addq	%rcx, %r10
	vmovdqu	%xmm0, 8(%r8)
	leaq	(%rcx,%rdx), %r8
	addq	8+g_arena(%rip), %rdx
	movq	%r8, g_arena_cur(%rip)
	movq	%r10, g_arena_end(%rip)
	jmp	.L4266
.L4250:
	movl	$32, %ecx
	call	arena_alloc
	movq	56(%rsp), %r9
	movq	%rax, %rcx
	jmp	.L4251
.L4330:
	xorl	%r8d, %r8d
	jmp	.L4230
.L4242:
	movq	40(%rsp), %rsi
	jmp	.L4221
.L4335:
	movq	24(%rax), %rax
	movq	%rax, 40(%rsp)
	imulq	%r8, %rax
	movq	%rax, %rdx
	jmp	.L4238
.L4265:
	call	arena_alloc.part.0
.L4333:
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
.LC81:
	.ascii "vlin.add_into: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_add_into
	.def	fn_vlin_add_into;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_add_into
fn_vlin_add_into:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 192(%rsp)
	.seh_savexmm	%xmm6, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L4341
	movl	(%r8), %eax
	cmpl	$1, %edx
	movq	8(%r8), %r14
	movl	%eax, 44(%rsp)
	je	.L4472
	cmpl	$2, %edx
	movl	16(%r8), %r13d
	movq	24(%r8), %r12
	je	.L4429
	movl	32(%r8), %eax
	movq	40(%r8), %r15
	movl	%eax, 40(%rsp)
.L4345:
	cmpl	$6, %r13d
	jne	.L4347
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4347
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4350
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4349:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4347
.L4350:
	cmpl	$107, (%rax)
	jne	.L4349
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L4348:
	xorl	%eax, %eax
	xorl	%edx, %edx
	cmpl	$6, 44(%rsp)
	jne	.L4355
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4354
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4357
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4356:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4354
.L4357:
	cmpl	$107, (%rax)
	jne	.L4356
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4355:
	leaq	80(%rsp), %rbx
	leaq	48(%rsp), %rdi
	movq	%rdx, 72(%rsp)
	leaq	64(%rsp), %rsi
	movq	%r8, 48(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movq	%rsi, %rdx
	movl	$44, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$6, %r13d
	vmovdqu	80(%rsp), %xmm6
	jne	.L4359
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4359
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4363
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4362:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4359
.L4363:
	cmpl	$109, (%rax)
	jne	.L4362
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L4361:
	cmpl	$6, 44(%rsp)
	jne	.L4344
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4344
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4367
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4366:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4344
.L4367:
	cmpl	$109, (%rax)
	jne	.L4366
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4365:
	movq	%rdx, 72(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movl	$44, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	vmovdqu	80(%rsp), %xmm1
	movl	$50, %r9d
	vmovdqa	%xmm6, 64(%rsp)
	vmovdqa	%xmm1, 48(%rsp)
	call	vyne_binop
	cmpl	$6, 40(%rsp)
	vmovdqu	80(%rsp), %xmm6
	jne	.L4368
	movslq	16(%r15), %rdx
	testl	%edx, %edx
	jle	.L4368
	movq	8(%r15), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4372
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4371:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4368
.L4372:
	cmpl	$107, (%rax)
	jne	.L4371
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L4370:
	cmpl	$6, %r13d
	jne	.L4373
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4373
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4377
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4376:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4373
.L4377:
	cmpl	$107, (%rax)
	jne	.L4376
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4375:
	movq	%rdx, 72(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movl	$44, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	vmovdqu	80(%rsp), %xmm2
	movl	$50, %r9d
	vmovdqa	%xmm6, 64(%rsp)
	vmovdqa	%xmm2, 48(%rsp)
	call	vyne_binop
	cmpl	$6, 40(%rsp)
	vmovdqu	80(%rsp), %xmm6
	jne	.L4378
	movslq	16(%r15), %rdx
	testl	%edx, %edx
	jle	.L4378
	movq	8(%r15), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4382
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4381:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4378
.L4382:
	cmpl	$109, (%rax)
	jne	.L4381
	cmpl	$6, %r13d
	movq	16(%rax), %r8
	movq	24(%rax), %r9
	jne	.L4383
.L4474:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4383
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4387
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4386:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4383
.L4387:
	cmpl	$109, (%rax)
	jne	.L4386
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4385:
	movq	%rdx, 72(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movl	$44, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	movq	%rsi, %rdx
	movq	%rdi, %r8
	movq	%rbx, %rcx
	vmovdqu	80(%rsp), %xmm3
	movl	$50, %r9d
	vmovdqa	%xmm6, 64(%rsp)
	vmovdqa	%xmm3, 48(%rsp)
	call	vyne_binop
	movq	80(%rsp), %rax
	movq	88(%rsp), %rdx
	testl	%eax, %eax
	je	.L4388
	cmpl	$5, %eax
	je	.L4437
	cmpl	$2, %eax
	je	.L4437
	cmpl	$1, %eax
	je	.L4473
.L4392:
	call	arena_alloc.constprop.2
	leaq	.LC81(%rip), %rdi
	movq	%rbx, %rcx
	movq	$3, (%rax)
	movq	%rax, %rdx
	movq	%rdi, 8(%rax)
	call	fn_vcolors_red.constprop.0
	movq	88(%rsp), %rdx
	movl	80(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	movq	$2, 0(%rbp)
	movq	$-1, 8(%rbp)
.L4465:
	vmovaps	192(%rsp), %xmm6
	movq	%rbp, %rax
	addq	$216, %rsp
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
.L4472:
	movl	$0, 40(%rsp)
	xorl	%r12d, %r12d
	xorl	%r15d, %r15d
	xorl	%r13d, %r13d
.L4347:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4348
	.p2align 4,,10
	.p2align 3
.L4378:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpl	$6, %r13d
	je	.L4474
.L4383:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4385
	.p2align 4,,10
	.p2align 3
.L4373:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4375
	.p2align 4,,10
	.p2align 3
.L4368:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4370
	.p2align 4,,10
	.p2align 3
.L4341:
	leaq	80(%rsp), %rbx
	leaq	48(%rsp), %rdi
	xorl	%r12d, %r12d
	xorl	%r14d, %r14d
	leaq	64(%rsp), %rsi
	movq	%rdi, %r8
	movq	%rbx, %rcx
	xorl	%r13d, %r13d
	movl	$44, %r9d
	movq	%rsi, %rdx
	xorl	%r15d, %r15d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	call	vyne_binop
	movl	$0, 44(%rsp)
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	movl	$0, 40(%rsp)
	vmovdqu	80(%rsp), %xmm6
.L4344:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4365
	.p2align 4,,10
	.p2align 3
.L4437:
	testq	%rdx, %rdx
	setne	%al
.L4391:
	testb	%al, %al
	jne	.L4392
.L4388:
	cmpl	$6, 44(%rsp)
	jne	.L4394
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4475
	movq	8(%r14), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L4401
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4399:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L4476
.L4401:
	cmpl	$109, (%rdx)
	jne	.L4399
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L4406
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4404:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L4403
.L4406:
	cmpl	$107, (%rax)
	jne	.L4404
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4405:
	movq	%rdx, 72(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %rdx
	movq	%r8, 48(%rsp)
	movq	%rdi, %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rbx
	je	.L4428
	vmovq	%rbx, %xmm4
	vcvttsd2siq	%xmm4, %rbx
.L4428:
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4471
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4410
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4409:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4471
.L4410:
	cmpl	$116, (%rax)
	jne	.L4409
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, %r13d
	je	.L4477
	.p2align 4,,10
	.p2align 3
.L4431:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L4411:
	leaq	128(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, 40(%rsp)
	jne	.L4433
	movslq	16(%r15), %rdx
	testl	%edx, %edx
	jle	.L4433
	movq	8(%r15), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4416
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4415:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4433
.L4416:
	cmpl	$116, (%rax)
	jne	.L4415
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L4414
	.p2align 4,,10
	.p2align 3
.L4359:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4361
	.p2align 4,,10
	.p2align 3
.L4394:
	movq	%rbx, %rcx
	movl	$31, %r9d
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rbx
	je	.L4471
	vmovq	%rbx, %xmm5
	vcvttsd2siq	%xmm5, %rbx
.L4471:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, %r13d
	jne	.L4431
.L4477:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4431
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4413
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4412:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4431
.L4413:
	cmpl	$116, (%rax)
	jne	.L4412
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L4411
	.p2align 4,,10
	.p2align 3
.L4433:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L4414:
	leaq	160(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rbx, %rbx
	jle	.L4422
	cmpq	$1, %rbx
	movq	160(%rsp), %r8
	movq	96(%rsp), %rcx
	movq	128(%rsp), %rdx
	je	.L4435
	leaq	-8(%rcx), %rax
	movq	%rax, %r9
	subq	%rdx, %r9
	cmpq	$16, %r9
	jbe	.L4435
	subq	%r8, %rax
	cmpq	$16, %rax
	jbe	.L4435
	leaq	-1(%rbx), %rax
	movq	%rbx, %r9
	cmpq	$2, %rax
	jbe	.L4436
	shrq	$2, %r9
	xorl	%eax, %eax
	salq	$5, %r9
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4420:
	vmovupd	(%rdx,%rax), %ymm0
	vaddpd	(%r8,%rax), %ymm0, %ymm0
	vmovupd	%ymm0, (%rcx,%rax)
	addq	$32, %rax
	cmpq	%r9, %rax
	jne	.L4420
	movq	%rbx, %rax
	andq	$-4, %rax
	cmpq	%rbx, %rax
	movq	%rax, %r10
	je	.L4469
	subq	%rax, %rbx
	cmpq	$1, %rbx
	movq	%rbx, %r9
	je	.L4478
	vzeroupper
.L4419:
	vmovupd	(%rdx,%r10,8), %xmm0
	vaddpd	(%r8,%r10,8), %xmm0, %xmm0
	testb	$1, %r9b
	vmovupd	%xmm0, (%rcx,%r10,8)
	je	.L4422
	andq	$-2, %r9
	addq	%r9, %rax
.L4424:
	vmovsd	(%r8,%rax,8), %xmm0
	vaddsd	(%rdx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
.L4422:
	movq	$2, 0(%rbp)
	movq	$0, 8(%rbp)
	jmp	.L4465
	.p2align 4,,10
	.p2align 3
.L4354:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4355
.L4475:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L4403:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4405
	.p2align 4,,10
	.p2align 3
.L4476:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4406
	.p2align 4,,10
	.p2align 3
.L4435:
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4426:
	vmovsd	(%r8,%rax,8), %xmm0
	vaddsd	(%rdx,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rbx, %rax
	jne	.L4426
	jmp	.L4422
	.p2align 4,,10
	.p2align 3
.L4473:
	vmovq	%rdx, %xmm4
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$1, %edx
	vucomisd	%xmm0, %xmm4
	setp	%al
	cmovne	%edx, %eax
	jmp	.L4391
	.p2align 4,,10
	.p2align 3
.L4469:
	vzeroupper
	jmp	.L4422
	.p2align 4,,10
	.p2align 3
.L4429:
	movl	$0, 40(%rsp)
	xorl	%r15d, %r15d
	jmp	.L4345
.L4436:
	xorl	%r10d, %r10d
	xorl	%eax, %eax
	jmp	.L4419
.L4478:
	vzeroupper
	jmp	.L4424
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC83:
	.ascii "vlin.multiply_into: shape mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_multiply_into
	.def	fn_vlin_multiply_into;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_multiply_into
fn_vlin_multiply_into:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 208(%rsp)
	.seh_savexmm	%xmm6, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L4480
	cmpl	$1, %edx
	movl	(%r8), %r15d
	movq	8(%r8), %r12
	je	.L4607
	movl	16(%r8), %eax
	cmpl	$2, %edx
	movq	24(%r8), %r13
	movl	%eax, 56(%rsp)
	je	.L4565
	movl	32(%r8), %eax
	movq	40(%r8), %r14
	movl	%eax, 60(%rsp)
.L4484:
	cmpl	$6, 56(%rsp)
	jne	.L4486
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L4486
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4489
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4488:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4486
.L4489:
	cmpl	$107, (%rax)
	jne	.L4488
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L4487:
	xorl	%eax, %eax
	xorl	%edx, %edx
	cmpl	$6, %r15d
	jne	.L4494
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4493
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4496
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4495:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4493
.L4496:
	cmpl	$107, (%rax)
	jne	.L4495
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4494:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rdi
	movq	%rdx, 88(%rsp)
	leaq	80(%rsp), %rsi
	movq	%r8, 64(%rsp)
	movq	%rbx, %rcx
	movq	%rdi, %r8
	movq	%r9, 72(%rsp)
	movq	%rsi, %rdx
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	cmpl	$6, 60(%rsp)
	vmovdqu	96(%rsp), %xmm6
	jne	.L4498
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4498
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4502
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4501:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4498
.L4502:
	cmpl	$109, (%rax)
	jne	.L4501
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L4500:
	cmpl	$6, %r15d
	jne	.L4483
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4483
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4506
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4505:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4483
.L4506:
	cmpl	$109, (%rax)
	jne	.L4505
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4504:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rdi, %r8
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	movq	%rdi, %r8
	movq	%rsi, %rdx
	movq	%rbx, %rcx
	vmovdqu	96(%rsp), %xmm2
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	vmovdqa	%xmm2, 64(%rsp)
	call	vyne_binop
	cmpl	$6, 60(%rsp)
	vmovdqu	96(%rsp), %xmm6
	jne	.L4507
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4507
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4511
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4510:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4507
.L4511:
	cmpl	$107, (%rax)
	jne	.L4510
	cmpl	$6, 56(%rsp)
	movq	16(%rax), %r8
	movq	24(%rax), %r9
	jne	.L4512
.L4609:
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L4512
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4516
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4515:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4512
.L4516:
	cmpl	$109, (%rax)
	jne	.L4515
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4514:
	movq	%rdx, 88(%rsp)
	movq	%rbx, %rcx
	movq	%rsi, %rdx
	movq	%r8, 64(%rsp)
	movq	%rdi, %r8
	movq	%r9, 72(%rsp)
	movl	$44, %r9d
	movq	%rax, 80(%rsp)
	call	vyne_binop
	movq	%rsi, %rdx
	movq	%rdi, %r8
	movq	%rbx, %rcx
	vmovdqu	96(%rsp), %xmm1
	movl	$50, %r9d
	vmovdqa	%xmm6, 80(%rsp)
	vmovdqa	%xmm1, 64(%rsp)
	call	vyne_binop
	movq	96(%rsp), %rax
	movq	104(%rsp), %rdx
	testl	%eax, %eax
	je	.L4517
	cmpl	$5, %eax
	je	.L4581
	cmpl	$2, %eax
	je	.L4581
	cmpl	$1, %eax
	je	.L4608
.L4521:
	call	arena_alloc.constprop.2
	leaq	.LC83(%rip), %rdi
	movq	%rbx, %rcx
	movq	$3, (%rax)
	movq	%rax, %rdx
	movq	%rdi, 8(%rax)
	call	fn_vcolors_red.constprop.0
	movq	104(%rsp), %rdx
	movl	96(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	movq	$2, 0(%rbp)
	movq	$-1, 8(%rbp)
.L4602:
	vmovaps	208(%rsp), %xmm6
	movq	%rbp, %rax
	addq	$232, %rsp
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
.L4607:
	movl	$0, 60(%rsp)
	xorl	%r14d, %r14d
	xorl	%r13d, %r13d
	movl	$0, 56(%rsp)
.L4486:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4487
	.p2align 4,,10
	.p2align 3
.L4507:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpl	$6, 56(%rsp)
	je	.L4609
.L4512:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4514
	.p2align 4,,10
	.p2align 3
.L4480:
	leaq	96(%rsp), %rbx
	leaq	64(%rsp), %rdi
	xorl	%r14d, %r14d
	xorl	%r12d, %r12d
	leaq	80(%rsp), %rsi
	movq	%rdi, %r8
	movq	%rbx, %rcx
	xorl	%r15d, %r15d
	movl	$44, %r9d
	movq	%rsi, %rdx
	xorl	%r13d, %r13d
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	call	vyne_binop
	movl	$0, 56(%rsp)
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	movl	$0, 60(%rsp)
	vmovdqu	96(%rsp), %xmm6
.L4483:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4504
	.p2align 4,,10
	.p2align 3
.L4581:
	testq	%rdx, %rdx
	setne	%al
.L4520:
	testb	%al, %al
	jne	.L4521
.L4517:
	cmpl	$6, %r15d
	jne	.L4567
	movslq	16(%r12), %r8
	testl	%r8d, %r8d
	jle	.L4567
	movq	8(%r12), %rax
	movslq	%r8d, %r9
	salq	$5, %r9
	movq	%rax, %rdx
	addq	%rax, %r9
	movq	%rax, %rcx
	jmp	.L4527
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4524:
	addq	$32, %rcx
	cmpq	%r9, %rcx
	je	.L4534
.L4527:
	cmpl	$107, (%rcx)
	jne	.L4524
	cmpl	$2, 16(%rcx)
	jne	.L4534
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4525:
	cmpl	$107, (%rdx)
	je	.L4610
	addq	$32, %rdx
	cmpq	%rdx, %r9
	jne	.L4525
	xorl	%esi, %esi
	cmpl	$6, 56(%rsp)
	je	.L4532
	xorl	%ebx, %ebx
	jmp	.L4531
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4533:
	addq	$32, %rdx
	cmpq	%r9, %rdx
	je	.L4567
.L4534:
	cmpl	$107, (%rdx)
	jne	.L4533
	vcvttsd2siq	24(%rdx), %rsi
	jmp	.L4523
	.p2align 4,,10
	.p2align 3
.L4567:
	xorl	%esi, %esi
.L4523:
	xorl	%ebx, %ebx
	cmpl	$6, 56(%rsp)
	je	.L4532
.L4539:
	cmpl	$6, %r15d
	je	.L4611
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	xorl	%edi, %edi
.L4546:
	leaq	112(%rsp), %rcx
	movl	%eax, %edx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, 56(%rsp)
	jne	.L4577
	movslq	16(%r13), %rdx
	testl	%edx, %edx
	jle	.L4577
	movq	8(%r13), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4560
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4559:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4577
.L4560:
	cmpl	$116, (%rax)
	jne	.L4559
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L4558
	.p2align 4,,10
	.p2align 3
.L4532:
	movl	16(%r13), %eax
	testl	%eax, %eax
	jle	.L4572
.L4530:
	movq	8(%r13), %rax
	movslq	16(%r13), %r8
	xorl	%ecx, %ecx
	movq	%rax, %rdx
	jmp	.L4540
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4536:
	addl	$1, %ecx
	addq	$32, %rdx
	cmpl	%r8d, %ecx
	jge	.L4537
.L4540:
	cmpl	$109, (%rdx)
	jne	.L4536
	cmpl	$2, 16(%rdx)
	je	.L4612
.L4537:
	testl	%r8d, %r8d
	jle	.L4572
	salq	$5, %r8
	leaq	(%r8,%rax), %rdx
	jmp	.L4545
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4544:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4572
.L4545:
	cmpl	$109, (%rax)
	jne	.L4544
	vcvttsd2siq	24(%rax), %rbx
	jmp	.L4539
	.p2align 4,,10
	.p2align 3
.L4577:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L4558:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpl	$6, 60(%rsp)
	jne	.L4579
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L4579
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4563
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4562:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4579
.L4563:
	cmpl	$116, (%rax)
	jne	.L4562
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L4561
	.p2align 4,,10
	.p2align 3
.L4579:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L4561:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	%rdi, 40(%rsp)
	movq	%rsi, %r9
	movq	176(%rsp), %r8
	movq	%rbx, 32(%rsp)
	movq	144(%rsp), %rdx
	movq	112(%rsp), %rcx
	call	fn_vlin_k_matmul_native
	movq	$2, 0(%rbp)
	movq	$0, 8(%rbp)
	vzeroupper
	jmp	.L4602
	.p2align 4,,10
	.p2align 3
.L4498:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4500
	.p2align 4,,10
	.p2align 3
.L4493:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4494
	.p2align 4,,10
	.p2align 3
.L4611:
	movslq	16(%r12), %r8
.L4531:
	testl	%r8d, %r8d
	jle	.L4574
	movq	8(%r12), %rax
.L4564:
	salq	$5, %r8
	movq	%rax, %rdx
	movq	%rax, %rcx
	addq	%rax, %r8
	jmp	.L4551
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4548:
	addq	$32, %rcx
	cmpq	%r8, %rcx
	je	.L4555
.L4551:
	cmpl	$109, (%rcx)
	jne	.L4548
	cmpl	$2, 16(%rcx)
	jne	.L4555
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4549:
	cmpl	$109, (%rax)
	je	.L4613
	addq	$32, %rax
	cmpq	%r8, %rax
	jne	.L4549
.L4605:
	xorl	%edi, %edi
	cmpl	$116, (%rdx)
	jne	.L4556
	.p2align 4,,10
	.p2align 3
.L4614:
	movl	16(%rdx), %eax
	movq	24(%rdx), %r8
	jmp	.L4546
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4554:
	addq	$32, %rax
	cmpq	%r8, %rax
	je	.L4605
.L4555:
	cmpl	$109, (%rax)
	jne	.L4554
	vcvttsd2siq	24(%rax), %rdi
	jmp	.L4557
	.p2align 4,,10
	.p2align 3
.L4556:
	addq	$32, %rdx
	cmpq	%r8, %rdx
	je	.L4547
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4557:
	cmpl	$116, (%rdx)
	je	.L4614
	addq	$32, %rdx
	cmpq	%r8, %rdx
	jne	.L4557
.L4547:
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.L4546
.L4612:
	movslq	%r8d, %rdx
	salq	$5, %rdx
	addq	%rax, %rdx
	testl	%r8d, %r8d
	jle	.L4572
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4543:
	cmpl	$109, (%rax)
	je	.L4615
	addq	$32, %rax
	cmpq	%rdx, %rax
	jne	.L4543
.L4572:
	xorl	%ebx, %ebx
	jmp	.L4539
	.p2align 4,,10
	.p2align 3
.L4608:
	vmovq	%rdx, %xmm3
	vxorpd	%xmm0, %xmm0, %xmm0
	movl	$1, %edx
	vucomisd	%xmm0, %xmm3
	setp	%al
	cmovne	%edx, %eax
	jmp	.L4520
	.p2align 4,,10
	.p2align 3
.L4565:
	movl	$0, 60(%rsp)
	xorl	%r14d, %r14d
	jmp	.L4484
.L4610:
	cmpl	$6, 56(%rsp)
	movq	24(%rdx), %rsi
	jne	.L4529
	movl	16(%r13), %edx
	testl	%edx, %edx
	jg	.L4530
	xorl	%ebx, %ebx
	jmp	.L4531
	.p2align 4,,10
	.p2align 3
.L4613:
	movq	24(%rax), %rdi
	jmp	.L4557
.L4615:
	movq	24(%rax), %rbx
	jmp	.L4539
.L4529:
	xorl	%ebx, %ebx
	testl	%r8d, %r8d
	jg	.L4564
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	leaq	112(%rsp), %rcx
	xorl	%edi, %edi
	call	vyne_value_to_array_f64.isra.0
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L4558
	.p2align 4,,10
	.p2align 3
.L4574:
	xorl	%edi, %edi
	jmp	.L4547
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_add_bias_into
	.def	fn_vlin_add_bias_into;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_add_bias_into
fn_vlin_add_bias_into:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 192(%rsp)
	.seh_savexmm	%xmm6, 192
	vmovaps	%xmm7, 208(%rsp)
	.seh_savexmm	%xmm7, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r12
	jle	.L4620
	cmpl	$1, %edx
	movl	(%r8), %eax
	movq	8(%r8), %r15
	je	.L4618
	movq	24(%r8), %rsi
	movq	16(%r8), %rbp
	movq	%rsi, 48(%rsp)
.L4619:
	cmpl	$6, %eax
	jne	.L4620
	movslq	16(%r15), %rdx
	testl	%edx, %edx
	jle	.L4620
	movq	8(%r15), %rcx
	movslq	%edx, %r8
	salq	$5, %r8
	addq	%rcx, %r8
	movq	%rcx, %rax
	jmp	.L4624
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4621:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L4725
.L4624:
	cmpl	$107, (%rax)
	jne	.L4621
	cmpl	$2, 16(%rax)
	movq	%rcx, %r9
	je	.L4622
.L4725:
	movq	%rcx, %rax
	jmp	.L4628
.L4627:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L4726
.L4628:
	cmpl	$107, (%rax)
	jne	.L4627
	vcvttsd2siq	24(%rax), %rax
.L4626:
	movq	%rcx, %r9
	jmp	.L4632
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4629:
	addq	$32, %r9
	cmpq	%r9, %r8
	je	.L4637
.L4632:
	cmpl	$109, (%r9)
	jne	.L4629
	cmpl	$2, 16(%r9)
	jne	.L4637
.L4630:
	cmpl	$109, (%rcx)
	je	.L4730
	addq	$32, %rcx
	cmpq	%rcx, %r8
	jne	.L4630
.L4727:
	movq	$0, 56(%rsp)
.L4634:
	testq	%rax, %rax
	jle	.L4620
	cmpq	$0, 56(%rsp)
	jle	.L4620
	movq	%rax, 104(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%r13d, %r13d
	xorl	%ebx, %ebx
	movq	%r12, 304(%rsp)
	vmovdqa	.LC3(%rip), %xmm7
	leaq	_vyne_char_pool(%rip), %rsi
	.p2align 4,,10
	.p2align 3
.L4682:
	xorl	%edi, %edi
	testl	%edx, %edx
	movq	%r13, 64(%rsp)
	leaq	0(,%r13,8), %r12
	movq	%rbx, 72(%rsp)
	jle	.L4638
	.p2align 4,,10
	.p2align 3
.L4734:
	movq	8(%r15), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4642
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4639:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4638
.L4642:
	cmpl	$116, (%rax)
	jne	.L4639
	movl	16(%rax), %edx
	movq	24(%rax), %r14
	cmpl	$11, %edx
	je	.L4731
	cmpl	$12, %edx
	je	.L4732
	cmpl	$4, %edx
	jne	.L4638
	movslq	8(%r14), %r13
	movq	g_arena_cur(%rip), %rbx
	movl	$32, %eax
	testq	%r13, %r13
	leaq	0(,%r13,8), %rdx
	cmovle	%rax, %rdx
	testq	%rbx, %rbx
	je	.L4657
	movq	g_arena_end(%rip), %rax
	subq	%rbx, %rax
	cmpq	%rdx, %rax
	jb	.L4657
	leaq	(%rbx,%rdx), %rax
	addq	8+g_arena(%rip), %rdx
	movq	%rax, g_arena_cur(%rip)
	leaq	g_arena(%rip), %rax
.L4661:
	testq	%r13, %r13
	movq	%rdx, 8(%rax)
	jle	.L4643
	leaq	0(,%r13,8), %r8
	xorl	%edx, %edx
	movq	%rbx, %rcx
	salq	$4, %r13
	call	memset
	movq	(%r14), %rax
	movq	%rbx, %rdx
	addq	%rax, %r13
	jmp	.L4666
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4663:
	addq	$16, %rax
	vcvtsi2sdq	%rcx, %xmm6, %xmm0
	vmovlpd	%xmm0, (%rdx)
	cmpq	%rax, %r13
	je	.L4643
.L4728:
	addq	$8, %rdx
.L4666:
	cmpl	$1, (%rax)
	movq	8(%rax), %rcx
	jne	.L4663
	addq	$16, %rax
	movq	%rcx, (%rdx)
	cmpq	%rax, %r13
	jne	.L4728
	.p2align 4,,10
	.p2align 3
.L4643:
	addq	%r12, %rbx
	cmpl	$4, %ebp
	movl	%ebp, %r14d
	movq	(%rbx), %r13
	je	.L4714
.L4735:
	cmpl	$11, %ebp
	je	.L4667
	cmpl	$12, %ebp
	je	.L4733
	cmpl	$3, %ebp
	jne	.L4669
	movq	48(%rsp), %rcx
	call	strlen
	testl	%edi, %edi
	js	.L4669
	cmpl	%eax, %edi
	jge	.L4669
	movl	_vyne_char_pool_ready(%rip), %eax
	movl	%edi, %ecx
	testl	%eax, %eax
	jne	.L4676
	movl	$1, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4677:
	leaq	1(%rax), %rdx
	movb	%al, (%rsi,%rax,2)
	addq	$2, %rax
	cmpq	$254, %rdx
	movb	%dl, (%rsi,%rdx,2)
	movb	%al, (%rsi,%rax,2)
	leaq	2(%rdx), %rax
	jne	.L4677
	movl	$1, _vyne_char_pool_ready(%rip)
.L4676:
	movq	$3, 112(%rsp)
	movslq	%ecx, %rax
	movq	48(%rsp), %rcx
	movq	112(%rsp), %r10
	movzbl	(%rcx,%rax), %eax
	leaq	(%rsi,%rax,2), %rax
	movq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L4673:
	movabsq	$-4294967296, %rdx
	movl	%r14d, %r14d
	movq	%r13, %r9
	movq	$1, 32(%rsp)
	andq	%rdx, %r10
	movq	32(%rsp), %r8
	orq	%r14, %r10
	movq	%r10, %rax
.L4683:
	movq	%r8, 160(%rsp)
	leaq	160(%rsp), %rdx
	leaq	144(%rsp), %r8
	movq	%r9, 168(%rsp)
	movl	$29, %r9d
	movq	%rcx, 152(%rsp)
	leaq	176(%rsp), %rcx
	movq	%rax, 144(%rsp)
	call	vyne_binop_slow
	cmpl	$1, 176(%rsp)
	vmovsd	184(%rsp), %xmm0
	je	.L4680
	vcvtsi2sdq	184(%rsp), %xmm6, %xmm0
.L4680:
	addq	$1, %rdi
	addq	$8, %r12
	cmpq	%rdi, 56(%rsp)
	vmovsd	%xmm0, (%rbx)
	je	.L4719
	movslq	16(%r15), %rdx
	testl	%edx, %edx
	jg	.L4734
	.p2align 4,,10
	.p2align 3
.L4638:
	movq	g_arena_cur(%rip), %rbx
	testq	%rbx, %rbx
	je	.L4651
	movq	g_arena_end(%rip), %rax
	subq	%rbx, %rax
	cmpq	$31, %rax
	jbe	.L4651
	movq	8+g_arena(%rip), %rcx
	leaq	32(%rbx), %rax
	movq	%rax, g_arena_cur(%rip)
	leaq	g_arena(%rip), %rax
	leaq	32(%rcx), %rdx
.L4655:
	addq	%r12, %rbx
	cmpl	$4, %ebp
	movq	%rdx, 8(%rax)
	movl	%ebp, %r14d
	movq	(%rbx), %r13
	jne	.L4735
.L4714:
	movq	48(%rsp), %rax
	movslq	8(%rax), %rax
	cmpq	%rax, %rdi
	jge	.L4669
	movq	48(%rsp), %rax
	movq	%rdi, %rdx
	movq	%r13, %r9
	movq	$1, 32(%rsp)
	salq	$4, %rdx
	movq	32(%rsp), %r8
	addq	(%rax), %rdx
	movabsq	$-4294967296, %rax
	movl	(%rdx), %r11d
	andq	(%rdx), %rax
	movq	8(%rdx), %rcx
	orq	%r11, %rax
	cmpl	$1, %r11d
	je	.L4674
	jmp	.L4683
	.p2align 4,,10
	.p2align 3
.L4724:
	movq	304(%rsp), %r12
.L4620:
	movq	$2, (%r12)
	movq	%r12, %rax
	movq	$0, 8(%r12)
	vmovaps	192(%rsp), %xmm6
	vmovaps	208(%rsp), %xmm7
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L4625:
	addq	$32, %r9
	cmpq	%r8, %r9
	je	.L4726
.L4622:
	cmpl	$107, (%r9)
	jne	.L4625
	movq	24(%r9), %rax
	jmp	.L4626
.L4618:
	movq	$0, 48(%rsp)
	xorl	%ebp, %ebp
	jmp	.L4619
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4635:
	addq	$32, %rcx
	cmpq	%rcx, %r8
	je	.L4727
.L4637:
	cmpl	$109, (%rcx)
	jne	.L4635
	vcvttsd2siq	24(%rcx), %rsi
	movq	%rsi, 56(%rsp)
	jmp	.L4634
	.p2align 4,,10
	.p2align 3
.L4669:
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	xorl	%r14d, %r14d
	jmp	.L4673
	.p2align 4,,10
	.p2align 3
.L4731:
	movq	(%r14), %rbx
	jmp	.L4643
	.p2align 4,,10
	.p2align 3
.L4667:
	cmpl	$4, %ebp
	je	.L4714
	movq	48(%rsp), %rax
	cmpq	8(%rax), %rdi
	jge	.L4669
	movq	(%rax), %rax
	movq	(%rax,%rdi,8), %rcx
	.p2align 4,,10
	.p2align 3
.L4674:
	vmovq	%r13, %xmm1
	vmovq	%rcx, %xmm2
	vaddsd	%xmm2, %xmm1, %xmm0
	jmp	.L4680
	.p2align 4,,10
	.p2align 3
.L4733:
	movq	48(%rsp), %rax
	cmpq	8(%rax), %rdi
	jge	.L4669
	movq	(%rax), %rax
	movl	$2, %r14d
	movq	$2, 128(%rsp)
	movq	128(%rsp), %r10
	movq	(%rax,%rdi,8), %rcx
	jmp	.L4673
	.p2align 4,,10
	.p2align 3
.L4719:
	movq	72(%rsp), %rbx
	movq	64(%rsp), %r13
	addq	56(%rsp), %r13
	addq	$1, %rbx
	cmpq	104(%rsp), %rbx
	je	.L4724
	movslq	16(%r15), %rdx
	jmp	.L4682
	.p2align 4,,10
	.p2align 3
.L4732:
	movq	8(%r14), %r8
	testq	%r8, %r8
	jle	.L4645
	leaq	0(,%r8,8), %r13
	movq	%r13, %rcx
	call	arena_alloc
	movq	%r13, %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	movq	%rax, %rbx
	call	memset
.L4646:
	movq	8(%r14), %rdx
	testq	%rdx, %rdx
	jle	.L4643
	movq	(%r14), %rcx
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4648:
	vcvtsi2sdq	(%rcx,%rax,8), %xmm6, %xmm0
	vmovlpd	%xmm0, (%rbx,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L4648
	jmp	.L4643
	.p2align 4,,10
	.p2align 3
.L4657:
	movl	$32, %ecx
	movq	%rdx, 80(%rsp)
	call	malloc
	movq	80(%rsp), %rdx
	testq	%rax, %rax
	je	.L4729
	movl	$8388608, %ecx
	movq	%rax, 96(%rsp)
	cmpq	%rcx, %rdx
	movq	%rdx, 88(%rsp)
	cmovnb	%rdx, %rcx
	movq	%rcx, 80(%rsp)
	call	malloc
	movq	96(%rsp), %r8
	testq	%rax, %rax
	movq	%rax, %rbx
	movq	%rax, (%r8)
	je	.L4660
	movq	88(%rsp), %rdx
	movq	80(%rsp), %rcx
	leaq	g_arena(%rip), %rax
	movq	g_arena(%rip), %r9
	movq	%r8, g_arena(%rip)
	vmovq	%rdx, %xmm3
	vpinsrq	$1, %rcx, %xmm3, %xmm0
	movq	%r9, 24(%r8)
	addq	%rbx, %rcx
	vmovdqu	%xmm0, 8(%r8)
	leaq	(%rbx,%rdx), %r8
	addq	8+g_arena(%rip), %rdx
	movq	%r8, g_arena_cur(%rip)
	movq	%rcx, g_arena_end(%rip)
	jmp	.L4661
	.p2align 4,,10
	.p2align 3
.L4651:
	movl	$32, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L4729
	movl	$8388608, %ecx
	call	malloc
	testq	%rax, %rax
	movq	%rax, 0(%r13)
	movq	%rax, %rbx
	je	.L4660
	movq	g_arena(%rip), %rdx
	movq	8+g_arena(%rip), %rcx
	movq	%r13, g_arena(%rip)
	leaq	g_arena(%rip), %rax
	vmovdqu	%xmm7, 8(%r13)
	movq	%rdx, 24(%r13)
	leaq	32(%rbx), %rdx
	movq	%rdx, g_arena_cur(%rip)
	leaq	8388608(%rbx), %rdx
	movq	%rdx, g_arena_end(%rip)
	leaq	32(%rcx), %rdx
	jmp	.L4655
.L4645:
	movl	$32, %ecx
	call	arena_alloc
	movq	%rax, %rbx
	jmp	.L4646
.L4726:
	xorl	%eax, %eax
	jmp	.L4626
.L4730:
	movq	24(%rcx), %rsi
	movq	%rsi, 56(%rsp)
	jmp	.L4634
.L4660:
	call	arena_alloc.part.0
.L4729:
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
.LC84:
	.ascii "vlin.vstack: column mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_vstack
	.def	fn_vlin_vstack;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_vstack
fn_vlin_vstack:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 208(%rsp)
	.seh_savexmm	%xmm6, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 304(%rsp)
	jle	.L4737
	cmpl	$1, %edx
	movl	(%r8), %ebp
	movq	8(%r8), %rbx
	je	.L4805
	movl	16(%r8), %r12d
	movq	24(%r8), %rsi
	cmpl	$6, %r12d
	jne	.L4742
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L4742
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4745
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4744:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4742
.L4745:
	cmpl	$109, (%rax)
	jne	.L4744
	movq	16(%rax), %r8
	movq	24(%rax), %r9
.L4743:
	cmpl	$6, %ebp
	jne	.L4740
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L4748
	movq	8(%rbx), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4753
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4751:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4748
.L4753:
	cmpl	$109, (%rax)
	jne	.L4751
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4752:
	movq	%rax, 112(%rsp)
	leaq	112(%rsp), %rax
	leaq	128(%rsp), %rcx
	movq	%rdx, 120(%rsp)
	movq	%rax, %rdx
	movq	%r8, 96(%rsp)
	leaq	96(%rsp), %r8
	movq	%r9, 104(%rsp)
	movl	$44, %r9d
	movq	%rcx, 32(%rsp)
	movq	%rax, 48(%rsp)
	movq	%r8, 40(%rsp)
	call	vyne_binop
	movq	128(%rsp), %rax
	movq	136(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L4802
.L4803:
	cmpl	$5, %edx
	je	.L4812
	cmpl	$2, %edx
	je	.L4812
	cmpl	$1, %edx
	je	.L4836
.L4757:
	call	arena_alloc.constprop.2
	leaq	.LC84(%rip), %rcx
	movq	32(%rsp), %rdi
	movq	%rcx, 8(%rax)
	movq	%rax, %rdx
	movq	$3, (%rax)
	movq	%rdi, %rcx
	call	fn_vcolors_red.constprop.0
	movq	136(%rsp), %rdx
	movl	128(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rdi, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	movq	304(%rsp), %rax
	vmovdqu	128(%rsp), %xmm4
	vmovdqu	%xmm4, (%rax)
.L4829:
	vmovaps	208(%rsp), %xmm6
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L4805:
	xorl	%esi, %esi
	xorl	%r12d, %r12d
.L4742:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L4743
	.p2align 4,,10
	.p2align 3
.L4737:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%ebx, %ebx
	xorl	%r12d, %r12d
	xorl	%esi, %esi
	xorl	%ebp, %ebp
.L4740:
	leaq	112(%rsp), %rax
	leaq	128(%rsp), %rcx
	movq	%r8, 96(%rsp)
	movq	%rax, %rdx
	movq	%r9, 104(%rsp)
	leaq	96(%rsp), %r8
	movl	$44, %r9d
	movq	%rcx, 32(%rsp)
	movq	%rax, 48(%rsp)
	movq	$0, 112(%rsp)
	movq	$0, 120(%rsp)
	movq	%r8, 40(%rsp)
	call	vyne_binop
	movq	128(%rsp), %rax
	movq	136(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L4803
.L4749:
	movq	$0, 64(%rsp)
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
	movl	$2, %r8d
.L4766:
	movq	%rdx, 120(%rsp)
	movq	32(%rsp), %rcx
	movq	%r8, 96(%rsp)
	movq	48(%rsp), %rdx
	movq	40(%rsp), %r8
	movq	%r9, 104(%rsp)
	movl	$31, %r9d
	movq	%rax, 112(%rsp)
	call	vyne_binop
	cmpl	$2, 128(%rsp)
	movq	136(%rsp), %rdi
	je	.L4773
	vmovq	%rdi, %xmm5
	vcvttsd2siq	%xmm5, %rdi
.L4773:
	cmpl	$6, %r12d
	movq	64(%rsp), %r9
	movl	$2, %r8d
	jne	.L4774
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L4774
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4778
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4777:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4774
.L4778:
	cmpl	$107, (%rax)
	jne	.L4777
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L4776
	.p2align 4,,10
	.p2align 3
.L4774:
	xorl	%eax, %eax
	xorl	%edx, %edx
.L4776:
	movq	%rdx, 120(%rsp)
	movq	32(%rsp), %rcx
	movq	%r8, 96(%rsp)
	movq	48(%rsp), %rdx
	movq	40(%rsp), %r8
	movq	%r9, 104(%rsp)
	movl	$31, %r9d
	movq	%rax, 112(%rsp)
	call	vyne_binop
	movq	136(%rsp), %rax
	cmpl	$2, 128(%rsp)
	movq	%rax, 56(%rsp)
	je	.L4779
	vmovq	%rax, %xmm4
	vcvttsd2siq	%xmm4, %rax
	movq	%rax, 56(%rsp)
.L4779:
	movq	56(%rsp), %rax
	leaq	144(%rsp), %rcx
	xorl	%r13d, %r13d
	leaq	(%rdi,%rax), %rdx
	call	fn_vlin_zeros_f64_native
	testq	%rdi, %rdi
	movq	144(%rsp), %r14
	vmovdqu	152(%rsp), %xmm6
	jle	.L4786
	.p2align 4,,10
	.p2align 3
.L4780:
	cmpl	$6, %ebp
	jne	.L4809
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L4809
	movq	8(%rbx), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4785
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4784:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4809
.L4785:
	cmpl	$116, (%rax)
	jne	.L4784
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L4783:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	176(%rsp), %rax
	vmovsd	(%rax,%r13,8), %xmm0
	vmovsd	%xmm0, (%r14,%r13,8)
	addq	$1, %r13
	cmpq	%r13, %rdi
	jne	.L4780
.L4786:
	cmpq	$0, 56(%rsp)
	jle	.L4782
	leaq	(%r14,%rdi,8), %r13
	movq	56(%rsp), %rdi
	movq	%rbx, 72(%rsp)
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L4792:
	cmpl	$6, %r12d
	jne	.L4811
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L4811
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4791
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4790:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4811
.L4791:
	cmpl	$116, (%rax)
	jne	.L4790
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L4789:
	leaq	176(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	176(%rsp), %rax
	vmovsd	(%rax,%rbx,8), %xmm0
	vmovsd	%xmm0, 0(%r13,%rbx,8)
	addq	$1, %rbx
	cmpq	%rbx, %rdi
	jne	.L4792
	movq	72(%rsp), %rbx
.L4782:
	cmpl	$6, %r12d
	jne	.L4787
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L4787
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4796
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4795:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4787
.L4796:
	cmpl	$107, (%rax)
	jne	.L4795
	cmpl	$6, %ebp
	movq	16(%rax), %r8
	movq	24(%rax), %r9
	je	.L4837
	.p2align 4,,10
	.p2align 3
.L4797:
	xorl	%eax, %eax
	xorl	%edx, %edx
.L4799:
	movq	40(%rsp), %rbp
	movq	48(%rsp), %r15
	movq	%rdx, 120(%rsp)
	movq	32(%rsp), %rbx
	movq	%r8, 96(%rsp)
	movq	%r15, %rdx
	movq	%rbp, %r8
	movq	%r9, 104(%rsp)
	movl	$29, %r9d
	movq	%rbx, %rcx
	movq	%rax, 112(%rsp)
	call	vyne_binop
	movq	136(%rsp), %rdi
	movq	128(%rsp), %rsi
	call	arena_alloc.constprop.0
	leaq	80(%rsp), %r9
	movq	%rbp, %r8
	movq	%r15, %rdx
	movq	%r14, (%rax)
	movq	%rbx, %rcx
	vmovdqu	%xmm6, 8(%rax)
	movq	%rdi, 120(%rsp)
	movq	64(%rsp), %rdi
	movq	%rax, 88(%rsp)
	movq	%rsi, 112(%rsp)
	movq	$2, 96(%rsp)
	movq	%rdi, 104(%rsp)
	movq	$11, 80(%rsp)
	call	struct_vlin_Types_Matrix
	movq	304(%rsp), %rax
	vmovdqu	128(%rsp), %xmm3
	vmovdqu	%xmm3, (%rax)
	jmp	.L4829
	.p2align 4,,10
	.p2align 3
.L4809:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L4783
	.p2align 4,,10
	.p2align 3
.L4811:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L4789
	.p2align 4,,10
	.p2align 3
.L4787:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpl	$6, %ebp
	jne	.L4797
.L4837:
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L4797
	movq	8(%rbx), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4801
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4800:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4797
.L4801:
	cmpl	$107, (%rax)
	jne	.L4800
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L4799
	.p2align 4,,10
	.p2align 3
.L4812:
	testq	%rcx, %rcx
	setne	%al
.L4756:
	testb	%al, %al
	jne	.L4757
	cmpl	$6, %ebp
	jne	.L4749
.L4802:
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L4759
	movq	8(%rbx), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L4763
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4760:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L4834
.L4763:
	cmpl	$109, (%rdx)
	jne	.L4760
	cmpl	$2, 16(%rdx)
	movq	%rax, %r8
	je	.L4761
	jmp	.L4834
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4764:
	addq	$32, %r8
	cmpq	%rcx, %r8
	je	.L4835
.L4761:
	cmpl	$109, (%r8)
	jne	.L4764
	movq	24(%r8), %rdi
	movq	%rdi, 64(%rsp)
	jmp	.L4765
	.p2align 4,,10
	.p2align 3
.L4748:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4752
.L4834:
	movq	%rax, %rdx
	jmp	.L4768
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4767:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L4835
.L4768:
	cmpl	$109, (%rdx)
	jne	.L4767
	vcvttsd2siq	24(%rdx), %rdi
	movq	%rdi, 64(%rsp)
.L4765:
	movq	64(%rsp), %r9
	movl	$2, %r8d
	jmp	.L4771
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4770:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L4769
.L4771:
	cmpl	$107, (%rax)
	jne	.L4770
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4772:
	movl	$6, %ebp
	jmp	.L4766
.L4759:
	movq	$0, 64(%rsp)
	movl	$2, %r8d
	xorl	%r9d, %r9d
.L4769:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4772
.L4835:
	movq	$0, 64(%rsp)
	jmp	.L4765
.L4836:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	setp	%al
	cmovne	%edx, %eax
	jmp	.L4756
	.seh_endproc
	.section .rdata,"dr"
.LC85:
	.ascii "vlin.hstack: row mismatch\0"
	.text
	.p2align 4
	.globl	fn_vlin_hstack
	.def	fn_vlin_hstack;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_hstack
fn_vlin_hstack:
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
	subq	$280, %rsp
	.seh_stackalloc	280
	vmovaps	%xmm6, 240(%rsp)
	.seh_savexmm	%xmm6, 240
	vmovaps	%xmm7, 256(%rsp)
	.seh_savexmm	%xmm7, 256
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, 352(%rsp)
	jle	.L4839
	movl	(%r8), %eax
	cmpl	$1, %edx
	movl	%eax, 64(%rsp)
	movq	8(%r8), %rax
	movq	%rax, 32(%rsp)
	je	.L4944
	movl	16(%r8), %r15d
	movq	24(%r8), %r12
	cmpl	$6, %r15d
	jne	.L4844
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L4844
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4847
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4846:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4844
.L4847:
	cmpl	$107, (%rax)
	jne	.L4846
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
.L4845:
	cmpl	$6, 64(%rsp)
	jne	.L4842
	movq	32(%rsp), %rax
	movslq	16(%rax), %rdx
	testl	%edx, %edx
	jle	.L4850
	movq	8(%rax), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4855
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4853:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4850
.L4855:
	cmpl	$107, (%rax)
	jne	.L4853
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L4854:
	movq	%rax, 176(%rsp)
	leaq	192(%rsp), %rdi
	leaq	176(%rsp), %rax
	movl	$44, %r9d
	movq	%rdx, 184(%rsp)
	leaq	160(%rsp), %r8
	movq	%rax, %rdx
	movq	%rcx, 160(%rsp)
	movq	%rdi, %rcx
	movq	%rax, 128(%rsp)
	movq	%rdi, 112(%rsp)
	movq	%rbx, 168(%rsp)
	movq	%r8, 120(%rsp)
	call	vyne_binop
	movq	192(%rsp), %rax
	movq	200(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	je	.L4942
.L4943:
	cmpl	$5, %edx
	je	.L4949
	cmpl	$2, %edx
	je	.L4949
	cmpl	$1, %edx
	je	.L4993
.L4858:
	call	arena_alloc.constprop.2
	leaq	.LC85(%rip), %rdi
	movq	%rdi, 8(%rax)
	movq	112(%rsp), %rdi
	movq	%rax, %rdx
	movq	$3, (%rax)
	movq	%rdi, %rcx
	call	fn_vcolors_red.constprop.0
	movq	200(%rsp), %rdx
	movl	192(%rsp), %ecx
	call	_vyne_print_internal.isra.0
	movl	$10, %ecx
	call	putchar
	movl	$1, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rax, %rcx
	call	fflush
	call	arena_alloc.constprop.1
	movl	$2, %edx
	movq	%rdi, %rcx
	movq	$2, (%rax)
	movq	%rax, %r8
	movq	$0, 8(%rax)
	movq	$2, 16(%rax)
	movq	$0, 24(%rax)
	call	fn_vlin_zeros
	movq	352(%rsp), %rax
	vmovdqu	192(%rsp), %xmm4
	vmovdqu	%xmm4, (%rax)
.L4974:
	vmovaps	240(%rsp), %xmm6
	vmovaps	256(%rsp), %xmm7
	addq	$280, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L4944:
	xorl	%r15d, %r15d
	xorl	%r12d, %r12d
.L4844:
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
	jmp	.L4845
.L4839:
	movl	$0, 64(%rsp)
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
	xorl	%r15d, %r15d
	movq	$0, 32(%rsp)
	xorl	%r12d, %r12d
.L4842:
	leaq	192(%rsp), %rax
	leaq	176(%rsp), %rdi
	movq	%rcx, 160(%rsp)
	movl	$44, %r9d
	movq	%rax, %rcx
	leaq	160(%rsp), %r8
	movq	%rdi, %rdx
	movq	%rax, 112(%rsp)
	movq	$0, 176(%rsp)
	movq	$0, 184(%rsp)
	movq	%rbx, 168(%rsp)
	movq	%r8, 120(%rsp)
	movq	%rdi, 128(%rsp)
	call	vyne_binop
	movq	192(%rsp), %rax
	movq	200(%rsp), %rcx
	testl	%eax, %eax
	movl	%eax, %edx
	jne	.L4943
.L4862:
	movq	$0, 88(%rsp)
	xorl	%r9d, %r9d
.L4876:
	cmpl	$6, %r15d
	jne	.L4948
	movl	16(%r12), %ecx
	testl	%ecx, %ecx
	jle	.L4948
	movq	8(%r12), %rdx
	movslq	%ecx, %r8
	salq	$5, %r8
	addq	%rdx, %r8
	movq	%rdx, %rcx
	jmp	.L4883
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4880:
	addq	$32, %rcx
	cmpq	%r8, %rcx
	je	.L4887
.L4883:
	cmpl	$109, (%rcx)
	jne	.L4880
	cmpl	$2, 16(%rcx)
	jne	.L4887
.L4881:
	cmpl	$109, (%rdx)
	je	.L4994
	addq	$32, %rdx
	cmpq	%r8, %rdx
	jne	.L4881
.L4948:
	movq	%r9, 104(%rsp)
	xorl	%esi, %esi
.L4885:
	movq	88(%rsp), %rdi
	movq	104(%rsp), %rdx
	movq	%r9, 40(%rsp)
	leaq	208(%rsp), %rcx
	imulq	%rdi, %rdx
	call	fn_vlin_zeros_f64_native
	movq	208(%rsp), %rax
	testq	%rdi, %rdi
	vmovdqu	216(%rsp), %xmm7
	movq	40(%rsp), %r9
	movq	%rax, 136(%rsp)
	jle	.L4889
	movq	104(%rsp), %rax
	movl	%r15d, 68(%rsp)
	xorl	%r14d, %r14d
	movq	%r9, %r13
	movq	$0, 72(%rsp)
	vxorps	%xmm6, %xmm6, %xmm6
	movq	$0, 80(%rsp)
	salq	$3, %rax
	movq	%rax, 96(%rsp)
	movq	136(%rsp), %rax
	movq	%rax, %rbp
	leaq	(%rax,%r9,8), %rdi
	.p2align 4,,10
	.p2align 3
.L4915:
	testq	%r13, %r13
	movq	80(%rsp), %rax
	jle	.L4896
	movq	%rsi, %r15
	leaq	0(,%rax,8), %rbx
	xorl	%esi, %esi
.L4906:
	cmpl	$6, 64(%rsp)
	je	.L4995
.L4890:
	movl	$32, %ecx
	call	arena_alloc
	vmovsd	(%rax,%rbx), %xmm0
	addq	$8, %rbx
	vmovsd	%xmm0, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%rsi, %r13
	jne	.L4906
.L4983:
	movq	%r15, %rsi
.L4896:
	movq	72(%rsp), %rax
	xorl	%ebx, %ebx
	testq	%rsi, %rsi
	leaq	0(,%rax,8), %r15
	jle	.L4923
	movq	%rbp, %rax
	movq	%r15, %rbp
	movq	%rax, %r15
.L4932:
	cmpl	$6, 68(%rsp)
	je	.L4996
.L4916:
	movl	$32, %ecx
	call	arena_alloc
	vmovsd	(%rax,%rbp), %xmm0
	addq	$8, %rbp
	vmovsd	%xmm0, (%rdi,%rbx,8)
	addq	$1, %rbx
	cmpq	%rbx, %rsi
	jne	.L4932
.L4987:
	movq	%r15, %rbp
.L4923:
	movq	96(%rsp), %rax
	addq	%rsi, 72(%rsp)
	addq	$1, %r14
	addq	%r13, 80(%rsp)
	addq	%rax, %rdi
	addq	%rax, %rbp
	cmpq	88(%rsp), %r14
	jne	.L4915
.L4889:
	call	arena_alloc.constprop.0
	movq	120(%rsp), %r8
	movq	112(%rsp), %rcx
	leaq	144(%rsp), %r9
	movq	136(%rsp), %rdi
	vmovdqu	%xmm7, 8(%rax)
	movq	128(%rsp), %rdx
	movq	%rdi, (%rax)
	movq	88(%rsp), %rdi
	movq	%rax, 152(%rsp)
	movq	%rdi, 184(%rsp)
	movq	104(%rsp), %rdi
	movq	$2, 176(%rsp)
	movq	$2, 160(%rsp)
	movq	%rdi, 168(%rsp)
	movq	$11, 144(%rsp)
	call	struct_vlin_Types_Matrix
	movq	352(%rsp), %rax
	vmovdqu	192(%rsp), %xmm3
	vmovdqu	%xmm3, (%rax)
	jmp	.L4974
.L4886:
	addq	$32, %rdx
	cmpq	%r8, %rdx
	je	.L4948
.L4887:
	cmpl	$109, (%rdx)
	jne	.L4886
	vcvttsd2siq	24(%rdx), %rsi
	leaq	(%r9,%rsi), %rax
	movq	%rax, 104(%rsp)
	jmp	.L4885
.L4996:
	movl	16(%r12), %ecx
	.p2align 4,,10
	.p2align 3
.L4917:
	testl	%ecx, %ecx
	jle	.L4916
	movq	8(%r12), %rax
	movslq	%ecx, %rdx
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L4921
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4918:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L4916
.L4921:
	cmpl	$116, (%rax)
	jne	.L4918
	movl	16(%rax), %edx
	movq	24(%rax), %r10
	cmpl	$11, %edx
	je	.L4997
	cmpl	$12, %edx
	je	.L4998
	cmpl	$4, %edx
	jne	.L4916
	movslq	8(%r10), %r9
	testl	%r9d, %r9d
	jle	.L4933
	leaq	0(,%r9,8), %r8
	movq	%r9, 48(%rsp)
	movq	%r8, %rcx
	movq	%r10, 56(%rsp)
	movq	%r8, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	56(%rsp), %r10
	movq	48(%rsp), %r9
	movq	%rax, %rcx
	movq	(%r10), %rax
	salq	$4, %r9
	movq	%rcx, %rdx
	addq	%rax, %r9
	jmp	.L4934
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4936:
	addq	$16, %rax
	vcvtsi2sdq	%r8, %xmm6, %xmm0
	vmovlpd	%xmm0, (%rdx)
	cmpq	%rax, %r9
	je	.L4935
.L4937:
	addq	$8, %rdx
.L4934:
	cmpl	$1, (%rax)
	movq	8(%rax), %r8
	jne	.L4936
	addq	$16, %rax
	movq	%r8, (%rdx)
	cmpq	%rax, %r9
	jne	.L4937
.L4935:
	vmovsd	(%rcx,%rbp), %xmm0
	vmovsd	%xmm0, (%rdi,%rbx,8)
	addq	$1, %rbx
	cmpq	%rbx, %rsi
	je	.L4987
.L4928:
	movl	16(%r12), %ecx
	addq	$8, %rbp
	jmp	.L4917
	.p2align 4,,10
	.p2align 3
.L4997:
	movq	(%r10), %rax
	vmovsd	(%rax,%rbp), %xmm0
	vmovsd	%xmm0, (%rdi,%rbx,8)
	addq	$1, %rbx
	cmpq	%rbx, %rsi
	je	.L4987
	addq	$8, %rbp
	jmp	.L4917
	.p2align 4,,10
	.p2align 3
.L4933:
	movl	$32, %ecx
	call	arena_alloc
	movq	%rax, %rcx
	jmp	.L4935
	.p2align 4,,10
	.p2align 3
.L4998:
	movq	8(%r10), %r8
	testq	%r8, %r8
	jle	.L4925
	salq	$3, %r8
	movq	%r10, 48(%rsp)
	movq	%r8, %rcx
	movq	%r8, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	48(%rsp), %r10
	movq	%rax, %rcx
.L4926:
	movq	8(%r10), %rdx
	testq	%rdx, %rdx
	jle	.L4930
	movq	(%r10), %r8
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4929:
	vcvtsi2sdq	(%r8,%rax,8), %xmm6, %xmm0
	vmovlpd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %rdx
	jne	.L4929
.L4930:
	vmovsd	(%rcx,%rbp), %xmm0
	vmovsd	%xmm0, (%rdi,%rbx,8)
	addq	$1, %rbx
	cmpq	%rsi, %rbx
	jne	.L4928
	jmp	.L4987
.L4925:
	movl	$32, %ecx
	movq	%r10, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %r10
	movq	%rax, %rcx
	jmp	.L4926
.L4949:
	testq	%rcx, %rcx
	jne	.L4858
.L4859:
	cmpl	$6, 64(%rsp)
	jne	.L4862
.L4942:
	movq	32(%rsp), %rdi
	movslq	16(%rdi), %rax
	testl	%eax, %eax
	jle	.L4945
	movq	8(%rdi), %rcx
	salq	$5, %rax
	addq	%rcx, %rax
	movq	%rcx, %rdx
	jmp	.L4866
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4863:
	addq	$32, %rdx
	cmpq	%rdx, %rax
	je	.L4989
.L4866:
	cmpl	$107, (%rdx)
	jne	.L4863
	cmpl	$2, 16(%rdx)
	movq	%rcx, %r8
	je	.L4864
	jmp	.L4989
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4867:
	addq	$32, %r8
	cmpq	%rax, %r8
	je	.L4990
.L4864:
	cmpl	$107, (%r8)
	jne	.L4867
	movq	24(%r8), %rdi
	movq	%rdi, 88(%rsp)
	jmp	.L4868
.L4850:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L4854
.L4989:
	movq	%rcx, %rdx
	jmp	.L4870
.L4869:
	addq	$32, %rdx
	cmpq	%rax, %rdx
	je	.L4990
.L4870:
	cmpl	$107, (%rdx)
	jne	.L4869
	vcvttsd2siq	24(%rdx), %rdi
	movq	%rdi, 88(%rsp)
.L4868:
	movq	%rcx, %rdx
	jmp	.L4874
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4871:
	addq	$32, %rdx
	cmpq	%rdx, %rax
	je	.L4878
.L4874:
	cmpl	$109, (%rdx)
	jne	.L4871
	cmpl	$2, 16(%rdx)
	jne	.L4878
.L4872:
	cmpl	$109, (%rcx)
	je	.L4999
	addq	$32, %rcx
	cmpq	%rcx, %rax
	jne	.L4872
.L4991:
	movl	$6, 64(%rsp)
	xorl	%r9d, %r9d
	jmp	.L4876
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4877:
	addq	$32, %rcx
	cmpq	%rcx, %rax
	je	.L4991
.L4878:
	cmpl	$109, (%rcx)
	jne	.L4877
	vcvttsd2siq	24(%rcx), %r9
	movl	$6, 64(%rsp)
	jmp	.L4876
.L4990:
	movq	$0, 88(%rsp)
	jmp	.L4868
.L4993:
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovq	%rcx, %xmm5
	vucomisd	%xmm0, %xmm5
	jp	.L4858
	jne	.L4858
	jmp	.L4859
	.p2align 4,,10
	.p2align 3
.L4999:
	movl	$6, 64(%rsp)
	movq	24(%rcx), %r9
	jmp	.L4876
.L4994:
	movq	24(%rdx), %rsi
	leaq	(%r9,%rsi), %rax
	movq	%rax, 104(%rsp)
	jmp	.L4885
.L4995:
	movq	32(%rsp), %rax
	movl	16(%rax), %ecx
	.p2align 4,,10
	.p2align 3
.L4891:
	testl	%ecx, %ecx
	jle	.L4890
	movq	32(%rsp), %rax
	movslq	%ecx, %rdx
	salq	$5, %rdx
	movq	8(%rax), %rax
	addq	%rax, %rdx
	jmp	.L4895
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L4892:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L4890
.L4895:
	cmpl	$116, (%rax)
	jne	.L4892
	movl	16(%rax), %edx
	movq	24(%rax), %r10
	cmpl	$11, %edx
	je	.L5000
	cmpl	$12, %edx
	je	.L5001
	cmpl	$4, %edx
	jne	.L4890
	movslq	8(%r10), %r9
	testl	%r9d, %r9d
	jle	.L4907
	leaq	0(,%r9,8), %r8
	movq	%r9, 48(%rsp)
	movq	%r8, %rcx
	movq	%r10, 56(%rsp)
	movq	%r8, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	56(%rsp), %r10
	movq	48(%rsp), %r9
	movq	%rax, %rcx
	movq	(%r10), %rax
	salq	$4, %r9
	movq	%rcx, %rdx
	addq	%rax, %r9
	jmp	.L4908
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4910:
	addq	$16, %rax
	vcvtsi2sdq	%r8, %xmm6, %xmm0
	vmovlpd	%xmm0, (%rdx)
	cmpq	%r9, %rax
	je	.L4909
.L4911:
	addq	$8, %rdx
.L4908:
	cmpl	$1, (%rax)
	movq	8(%rax), %r8
	jne	.L4910
	addq	$16, %rax
	movq	%r8, (%rdx)
	cmpq	%rax, %r9
	jne	.L4911
	.p2align 4,,10
	.p2align 3
.L4909:
	vmovsd	(%rcx,%rbx), %xmm0
	vmovsd	%xmm0, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%rsi, %r13
	je	.L4983
	movq	32(%rsp), %rax
	addq	$8, %rbx
	movl	16(%rax), %ecx
	jmp	.L4891
	.p2align 4,,10
	.p2align 3
.L5000:
	movq	(%r10), %rax
	vmovsd	(%rax,%rbx), %xmm0
	vmovsd	%xmm0, 0(%rbp,%rsi,8)
	addq	$1, %rsi
	cmpq	%rsi, %r13
	je	.L4983
	addq	$8, %rbx
	jmp	.L4891
	.p2align 4,,10
	.p2align 3
.L4907:
	movl	$32, %ecx
	call	arena_alloc
	movq	%rax, %rcx
	jmp	.L4909
	.p2align 4,,10
	.p2align 3
.L5001:
	movq	8(%r10), %r8
	testq	%r8, %r8
	jle	.L4899
	salq	$3, %r8
	movq	%r10, 48(%rsp)
	movq	%r8, %rcx
	movq	%r8, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %r8
	xorl	%edx, %edx
	movq	%rax, %rcx
	call	memset
	movq	48(%rsp), %r10
	movq	%rax, %rcx
.L4900:
	movq	8(%r10), %rdx
	testq	%rdx, %rdx
	jle	.L4909
	movq	(%r10), %r8
	xorl	%eax, %eax
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L4903:
	vcvtsi2sdq	(%r8,%rax,8), %xmm6, %xmm0
	vmovlpd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L4903
	jmp	.L4909
.L4899:
	movl	$32, %ecx
	movq	%r10, 40(%rsp)
	call	arena_alloc
	movq	40(%rsp), %r10
	movq	%rax, %rcx
	jmp	.L4900
.L4945:
	movl	$6, 64(%rsp)
	jmp	.L4862
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_sum
	.def	fn_vlin_sum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_sum
fn_vlin_sum:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5003
	cmpl	$6, (%r8)
	jne	.L5003
	movq	8(%r8), %r10
	movslq	16(%r10), %rdx
	testl	%edx, %edx
	jle	.L5042
	movq	8(%r10), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5010
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5008:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5043
.L5010:
	cmpl	$109, (%rdx)
	jne	.L5008
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5015
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5013:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5012
.L5015:
	cmpl	$107, (%rax)
	jne	.L5013
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L5014:
	movq	%rdx, 72(%rsp)
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%r8, 48(%rsp)
	leaq	48(%rsp), %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%r10, 40(%rsp)
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	movq	40(%rsp), %r10
	je	.L5016
	vmovq	%rsi, %xmm1
	vcvttsd2siq	%xmm1, %rsi
.L5016:
	movslq	16(%r10), %rdx
	testl	%edx, %edx
	jle	.L5041
	movq	8(%r10), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5020
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5019:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5041
.L5020:
	cmpl	$116, (%rax)
	jne	.L5019
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rsi, %rsi
	jg	.L5044
.L5027:
	vxorpd	%xmm0, %xmm0, %xmm0
.L5021:
	movq	%rbx, %rax
	movq	$1, (%rbx)
	vmovq	%xmm0, 8(%rbx)
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
	.p2align 3
.L5003:
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$31, %r9d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	leaq	48(%rsp), %r8
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	je	.L5041
	vmovq	%rsi, %xmm2
	vcvttsd2siq	%xmm2, %rsi
.L5041:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rsi, %rsi
	jle	.L5027
.L5044:
	leaq	-1(%rsi), %rax
	movq	96(%rsp), %rcx
	cmpq	$2, %rax
	jbe	.L5028
	movq	%rsi, %rdx
	movq	%rcx, %rax
	vxorpd	%xmm0, %xmm0, %xmm0
	shrq	$2, %rdx
	salq	$5, %rdx
	addq	%rcx, %rdx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5023:
	vaddsd	(%rax), %xmm0, %xmm0
	addq	$32, %rax
	vaddsd	-24(%rax), %xmm0, %xmm0
	vaddsd	-16(%rax), %xmm0, %xmm0
	vaddsd	-8(%rax), %xmm0, %xmm0
	cmpq	%rdx, %rax
	jne	.L5023
	testb	$3, %sil
	je	.L5021
	movq	%rsi, %rax
	andq	$-4, %rax
.L5022:
	leaq	1(%rax), %rdx
	vaddsd	(%rcx,%rax,8), %xmm0, %xmm0
	cmpq	%rdx, %rsi
	jle	.L5021
	leaq	2(%rax), %rdx
	vaddsd	8(%rcx,%rax,8), %xmm0, %xmm0
	cmpq	%rdx, %rsi
	jle	.L5021
	vaddsd	16(%rcx,%rax,8), %xmm0, %xmm0
	jmp	.L5021
.L5042:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5012:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5014
	.p2align 4,,10
	.p2align 3
.L5043:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5015
.L5028:
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.L5022
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_sum
	.def	fn_vlin_Types_Matrix_sum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_sum
fn_vlin_Types_Matrix_sum:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5047
	vmovdqu	(%r8), %xmm6
.L5047:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_sum
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_mean
	.def	fn_vlin_mean;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_mean
fn_vlin_mean:
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
	addq	$-128, %rsp
	.seh_stackalloc	128
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5072
	movl	(%r8), %r13d
	movq	8(%r8), %r12
	cmpl	$6, %r13d
	jne	.L5049
	movslq	16(%r12), %rcx
	testl	%ecx, %ecx
	jle	.L5086
	movq	8(%r12), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L5055
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5053:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5087
.L5055:
	cmpl	$109, (%rdx)
	jne	.L5053
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5059
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5058:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5057
.L5059:
	cmpl	$107, (%rax)
	jne	.L5058
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5052
	.p2align 4,,10
	.p2align 3
.L5072:
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
.L5049:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5052:
	leaq	48(%rsp), %rbp
	movq	%rdx, 72(%rsp)
	leaq	80(%rsp), %rcx
	movq	%r8, 48(%rsp)
	leaq	64(%rsp), %rdx
	movq	%rbp, %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %r14
	je	.L5061
	vmovq	%r14, %xmm1
	vcvttsd2siq	%xmm1, %r14
.L5061:
	testq	%r14, %r14
	je	.L5088
	cmpl	$6, %r13d
	je	.L5089
.L5074:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L5064:
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%r14, %r14
	jle	.L5075
	leaq	-1(%r14), %rax
	movq	96(%rsp), %rcx
	cmpq	$2, %rax
	jbe	.L5076
	movq	%r14, %rdx
	movq	%rcx, %rax
	vxorpd	%xmm0, %xmm0, %xmm0
	shrq	$2, %rdx
	salq	$5, %rdx
	addq	%rcx, %rdx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5069:
	vaddsd	(%rax), %xmm0, %xmm0
	addq	$32, %rax
	vaddsd	-24(%rax), %xmm0, %xmm0
	vaddsd	-16(%rax), %xmm0, %xmm0
	vaddsd	-8(%rax), %xmm0, %xmm0
	cmpq	%rdx, %rax
	jne	.L5069
	testb	$3, %r14b
	je	.L5067
	movq	%r14, %rax
	andq	$-4, %rax
.L5068:
	leaq	1(%rax), %rdx
	vaddsd	(%rcx,%rax,8), %xmm0, %xmm0
	cmpq	%rdx, %r14
	jle	.L5067
	leaq	2(%rax), %rdx
	vaddsd	8(%rcx,%rax,8), %xmm0, %xmm0
	cmpq	%rdx, %r14
	jle	.L5067
	vaddsd	16(%rcx,%rax,8), %xmm0, %xmm0
.L5067:
	leaq	64(%rsp), %rdx
	leaq	80(%rsp), %rcx
	vmovsd	%xmm0, 40(%rsp)
	movq	$2, 64(%rsp)
	movq	%r14, 72(%rsp)
	call	vyne_to_float
	movq	40(%rsp), %rax
	movq	%rbp, %r8
	leaq	64(%rsp), %rdx
	vmovdqu	80(%rsp), %xmm2
	movl	$32, %r9d
	leaq	80(%rsp), %rcx
	movq	$1, 64(%rsp)
	movq	%rax, 72(%rsp)
	vmovdqa	%xmm2, 48(%rsp)
	call	vyne_binop
	vmovdqu	80(%rsp), %xmm3
	vmovdqu	%xmm3, (%rbx)
.L5063:
	movq	%rbx, %rax
	subq	$-128, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L5089:
	movslq	16(%r12), %rdx
	testl	%edx, %edx
	jle	.L5074
	movq	8(%r12), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5066
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5065:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5074
.L5066:
	cmpl	$116, (%rax)
	jne	.L5065
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L5064
	.p2align 4,,10
	.p2align 3
.L5088:
	movq	$1, (%rbx)
	movq	$0, 8(%rbx)
	jmp	.L5063
.L5086:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5057:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5052
	.p2align 4,,10
	.p2align 3
.L5087:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5059
	.p2align 4,,10
	.p2align 3
.L5075:
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L5067
.L5076:
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.L5068
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_mean
	.def	fn_vlin_Types_Matrix_mean;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_mean
fn_vlin_Types_Matrix_mean:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5092
	vmovdqu	(%r8), %xmm6
.L5092:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_mean
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_minimum
	.def	fn_vlin_minimum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_minimum
fn_vlin_minimum:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5094
	cmpl	$6, (%r8)
	jne	.L5094
	movq	8(%r8), %r10
	movslq	16(%r10), %rcx
	testl	%ecx, %ecx
	jle	.L5130
	movq	8(%r10), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L5101
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5099:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L5131
.L5101:
	cmpl	$109, (%rdx)
	jne	.L5099
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5106
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5104:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L5103
.L5106:
	cmpl	$107, (%rax)
	jne	.L5104
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L5105:
	movq	%rdx, 72(%rsp)
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%r8, 48(%rsp)
	leaq	48(%rsp), %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%r10, 40(%rsp)
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	movq	40(%rsp), %r10
	je	.L5107
	vmovq	%rsi, %xmm3
	vcvttsd2siq	%xmm3, %rsi
.L5107:
	movslq	16(%r10), %rdx
	testl	%edx, %edx
	jle	.L5129
	movq	8(%r10), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5111
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5110:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5129
.L5111:
	cmpl	$116, (%rax)
	jne	.L5110
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L5109
	.p2align 4,,10
	.p2align 3
.L5094:
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$31, %r9d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	leaq	48(%rsp), %r8
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	je	.L5129
	vmovq	%rsi, %xmm4
	vcvttsd2siq	%xmm4, %rsi
.L5129:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L5109:
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rsi, %rsi
	vxorpd	%xmm1, %xmm1, %xmm1
	je	.L5112
	movq	96(%rsp), %rdx
	cmpq	$1, %rsi
	vmovsd	(%rdx), %xmm1
	jle	.L5112
	leaq	8(%rdx), %rax
	leaq	(%rdx,%rsi,8), %rdx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5115:
	vmovsd	(%rax), %xmm2
	addq	$8, %rax
	cmpq	%rax, %rdx
	vminsd	%xmm1, %xmm2, %xmm0
	vmovapd	%xmm0, %xmm1
	jne	.L5115
.L5112:
	movq	%rbx, %rax
	movq	$1, (%rbx)
	vmovq	%xmm1, 8(%rbx)
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	ret
.L5130:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5103:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5105
	.p2align 4,,10
	.p2align 3
.L5131:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5106
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_minimum
	.def	fn_vlin_Types_Matrix_minimum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_minimum
fn_vlin_Types_Matrix_minimum:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5134
	vmovdqu	(%r8), %xmm6
.L5134:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_minimum
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_maximum
	.def	fn_vlin_maximum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_maximum
fn_vlin_maximum:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5136
	cmpl	$6, (%r8)
	jne	.L5136
	movq	8(%r8), %r10
	movslq	16(%r10), %rcx
	testl	%ecx, %ecx
	jle	.L5169
	movq	8(%r10), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L5143
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5141:
	addq	$32, %rdx
	cmpq	%rcx, %rdx
	je	.L5170
.L5143:
	cmpl	$109, (%rdx)
	jne	.L5141
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5148
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5146:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L5145
.L5148:
	cmpl	$107, (%rax)
	jne	.L5146
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L5147:
	movq	%rdx, 72(%rsp)
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%r8, 48(%rsp)
	leaq	48(%rsp), %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%r10, 40(%rsp)
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	movq	40(%rsp), %r10
	je	.L5149
	vmovq	%rsi, %xmm2
	vcvttsd2siq	%xmm2, %rsi
.L5149:
	movslq	16(%r10), %rdx
	testl	%edx, %edx
	jle	.L5168
	movq	8(%r10), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5153
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5152:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5168
.L5153:
	cmpl	$116, (%rax)
	jne	.L5152
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L5151
	.p2align 4,,10
	.p2align 3
.L5136:
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$31, %r9d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	leaq	48(%rsp), %r8
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	je	.L5168
	vmovq	%rsi, %xmm3
	vcvttsd2siq	%xmm3, %rsi
.L5168:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L5151:
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rsi, %rsi
	vxorpd	%xmm0, %xmm0, %xmm0
	je	.L5154
	movq	96(%rsp), %rdx
	cmpq	$1, %rsi
	vmovsd	(%rdx), %xmm0
	jle	.L5154
	leaq	8(%rdx), %rax
	leaq	(%rdx,%rsi,8), %rdx
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5155:
	vmovsd	(%rax), %xmm1
	addq	$8, %rax
	cmpq	%rax, %rdx
	vmaxsd	%xmm0, %xmm1, %xmm0
	jne	.L5155
.L5154:
	movq	%rbx, %rax
	movq	$1, (%rbx)
	vmovq	%xmm0, 8(%rbx)
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	ret
.L5169:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5145:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5147
	.p2align 4,,10
	.p2align 3
.L5170:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5148
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_maximum
	.def	fn_vlin_Types_Matrix_maximum;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_maximum
fn_vlin_Types_Matrix_maximum:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5173
	vmovdqu	(%r8), %xmm6
.L5173:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_maximum
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_norm_fro
	.def	fn_vlin_norm_fro;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_norm_fro
fn_vlin_norm_fro:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5175
	cmpl	$6, (%r8)
	jne	.L5175
	movq	8(%r8), %r10
	movslq	16(%r10), %rdx
	testl	%edx, %edx
	jle	.L5219
	movq	8(%r10), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5182
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5180:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5220
.L5182:
	cmpl	$109, (%rdx)
	jne	.L5180
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5187
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5185:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5184
.L5187:
	cmpl	$107, (%rax)
	jne	.L5185
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L5186:
	movq	%rdx, 72(%rsp)
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%r8, 48(%rsp)
	leaq	48(%rsp), %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%r10, 40(%rsp)
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	movq	40(%rsp), %r10
	je	.L5188
	vmovq	%rsi, %xmm5
	vcvttsd2siq	%xmm5, %rsi
.L5188:
	movslq	16(%r10), %rdx
	testl	%edx, %edx
	jle	.L5218
	movq	8(%r10), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5192
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5191:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5218
.L5192:
	cmpl	$116, (%rax)
	jne	.L5191
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rsi, %rsi
	jg	.L5221
.L5201:
	xorl	%eax, %eax
	jmp	.L5199
	.p2align 4,,10
	.p2align 3
.L5175:
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$31, %r9d
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	leaq	48(%rsp), %r8
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %rsi
	je	.L5218
	vmovq	%rsi, %xmm5
	vcvttsd2siq	%xmm5, %rsi
.L5218:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	leaq	96(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	testq	%rsi, %rsi
	jle	.L5201
.L5221:
	leaq	-1(%rsi), %rax
	movq	96(%rsp), %rcx
	cmpq	$2, %rax
	jbe	.L5202
	movq	%rsi, %rdx
	movq	%rcx, %rax
	vxorpd	%xmm1, %xmm1, %xmm1
	shrq	$2, %rdx
	salq	$5, %rdx
	addq	%rcx, %rdx
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L5195:
	vmovupd	(%rax), %ymm0
	addq	$32, %rax
	cmpq	%rdx, %rax
	vmulpd	%ymm0, %ymm0, %ymm0
	vaddsd	%xmm1, %xmm0, %xmm3
	vunpckhpd	%xmm0, %xmm0, %xmm2
	vextractf128	$0x1, %ymm0, %xmm0
	vaddsd	%xmm3, %xmm2, %xmm2
	vaddsd	%xmm2, %xmm0, %xmm1
	vunpckhpd	%xmm0, %xmm0, %xmm0
	vaddsd	%xmm0, %xmm1, %xmm1
	jne	.L5195
	testb	$3, %sil
	je	.L5217
	movq	%rsi, %rax
	andq	$-4, %rax
	vzeroupper
.L5194:
	vmovsd	(%rcx,%rax,8), %xmm0
	leaq	1(%rax), %rdx
	cmpq	%rdx, %rsi
	vfmadd231sd	%xmm0, %xmm0, %xmm1
	jle	.L5196
	vmovsd	8(%rcx,%rax,8), %xmm0
	leaq	2(%rax), %rdx
	cmpq	%rdx, %rsi
	vfmadd231sd	%xmm0, %xmm0, %xmm1
	jle	.L5196
	vmovsd	16(%rcx,%rax,8), %xmm0
	vfmadd231sd	%xmm0, %xmm0, %xmm1
.L5196:
	vxorpd	%xmm0, %xmm0, %xmm0
	vucomisd	%xmm1, %xmm0
	ja	.L5214
	vsqrtsd	%xmm1, %xmm1, %xmm4
	vmovq	%xmm4, %rax
.L5199:
	movq	%rax, 8(%rbx)
	movq	%rbx, %rax
	movq	$1, (%rbx)
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	ret
.L5219:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5184:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5186
	.p2align 4,,10
	.p2align 3
.L5220:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5187
	.p2align 4,,10
	.p2align 3
.L5217:
	vzeroupper
	jmp	.L5196
.L5202:
	vxorpd	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	jmp	.L5194
.L5214:
	vmovapd	%xmm1, %xmm0
	call	sqrt
	vmovq	%xmm0, %rax
	jmp	.L5199
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_norm_fro
	.def	fn_vlin_Types_Matrix_norm_fro;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_norm_fro
fn_vlin_Types_Matrix_norm_fro:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5224
	vmovdqu	(%r8), %xmm6
.L5224:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_norm_fro
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_trace
	.def	fn_vlin_trace;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_trace
fn_vlin_trace:
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
	subq	$80, %rsp
	.seh_stackalloc	80
	vmovaps	%xmm6, 64(%rsp)
	.seh_savexmm	%xmm6, 64
	.seh_endprologue
	vxorpd	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbp
	jle	.L5226
	cmpl	$6, (%r8)
	jne	.L5226
	movq	8(%r8), %r14
	movslq	16(%r14), %rdx
	testl	%edx, %edx
	jle	.L5226
	movq	8(%r14), %rax
	movslq	%edx, %rcx
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %r8
	jmp	.L5230
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5227:
	addq	$32, %r8
	cmpq	%rcx, %r8
	je	.L5262
.L5230:
	cmpl	$107, (%r8)
	jne	.L5227
	cmpl	$2, 16(%r8)
	movq	%rax, %r9
	je	.L5228
.L5262:
	movq	%rax, %r8
	jmp	.L5234
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5233:
	addq	$32, %r8
	cmpq	%rcx, %r8
	je	.L5263
.L5234:
	cmpl	$107, (%r8)
	jne	.L5233
	vcvttsd2siq	24(%r8), %rbx
	jmp	.L5232
.L5263:
	xorl	%ebx, %ebx
.L5232:
	movq	%rax, %r8
	jmp	.L5238
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5235:
	addq	$32, %r8
	cmpq	%rcx, %r8
	je	.L5242
.L5238:
	cmpl	$109, (%r8)
	jne	.L5235
	cmpl	$2, 16(%r8)
	jne	.L5242
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5236:
	cmpl	$109, (%rax)
	je	.L5264
	addq	$32, %rax
	cmpq	%rcx, %rax
	jne	.L5236
.L5251:
	vxorpd	%xmm6, %xmm6, %xmm6
.L5226:
	movq	$1, 0(%rbp)
	movq	%rbp, %rax
	vmovq	%xmm6, 8(%rbp)
	vmovaps	64(%rsp), %xmm6
	addq	$80, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5231:
	addq	$32, %r9
	cmpq	%rcx, %r9
	je	.L5263
.L5228:
	cmpl	$107, (%r9)
	jne	.L5231
	movq	24(%r9), %rbx
	jmp	.L5232
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5241:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L5251
.L5242:
	cmpl	$109, (%rax)
	jne	.L5241
	vcvttsd2siq	24(%rax), %rax
	cmpq	%rbx, %rax
	cmovle	%rax, %rbx
.L5240:
	testq	%rbx, %rbx
	jle	.L5251
	xorl	%r13d, %r13d
	xorl	%r12d, %r12d
	vxorpd	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	leaq	8(,%rax,8), %rdi
	jle	.L5252
	.p2align 4,,10
	.p2align 3
.L5265:
	movq	8(%r14), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5245
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5244:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L5252
.L5245:
	cmpl	$116, (%rax)
	jne	.L5244
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5243:
	leaq	32(%rsp), %rcx
	addq	$1, %r12
	call	vyne_value_to_array_f64.isra.0
	movq	32(%rsp), %rax
	cmpq	%rbx, %r12
	vaddsd	(%rax,%r13), %xmm6, %xmm6
	je	.L5226
	movslq	16(%r14), %rdx
	addq	%rdi, %r13
	testl	%edx, %edx
	jg	.L5265
	.p2align 4,,10
	.p2align 3
.L5252:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5243
.L5264:
	movq	24(%rax), %rax
	cmpq	%rbx, %rax
	cmovle	%rax, %rbx
	jmp	.L5240
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_trace
	.def	fn_vlin_Types_Matrix_trace;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_trace
fn_vlin_Types_Matrix_trace:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5268
	vmovdqu	(%r8), %xmm6
.L5268:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_trace
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_argmax
	.def	fn_vlin_argmax;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_argmax
fn_vlin_argmax:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$120, %rsp
	.seh_stackalloc	120
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5291
	movl	(%r8), %ebp
	movq	8(%r8), %rdi
	cmpl	$6, %ebp
	jne	.L5270
	movslq	16(%rdi), %rcx
	testl	%ecx, %ecx
	jle	.L5302
	movq	8(%rdi), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L5276
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5274:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5303
.L5276:
	cmpl	$109, (%rdx)
	jne	.L5274
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5280
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5279:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L5278
.L5280:
	cmpl	$107, (%rax)
	jne	.L5279
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5273
	.p2align 4,,10
	.p2align 3
.L5291:
	xorl	%ebp, %ebp
	xorl	%edi, %edi
.L5270:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5273:
	movq	%rdx, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movq	%r8, 32(%rsp)
	leaq	32(%rsp), %r8
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	cmpl	$2, 64(%rsp)
	movq	72(%rsp), %rsi
	je	.L5282
	vmovq	%rsi, %xmm2
	vcvttsd2siq	%xmm2, %rsi
.L5282:
	testq	%rsi, %rsi
	je	.L5304
	cmpl	$6, %ebp
	je	.L5305
.L5293:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L5285:
	leaq	80(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpq	$1, %rsi
	jle	.L5294
	movq	80(%rsp), %rcx
	movl	$1, %eax
	xorl	%edx, %edx
	vmovsd	(%rcx), %xmm0
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5290:
	vmovsd	(%rcx,%rax,8), %xmm1
	vcomisd	%xmm0, %xmm1
	vmaxsd	%xmm0, %xmm1, %xmm0
	cmova	%rax, %rdx
	addq	$1, %rax
	cmpq	%rax, %rsi
	jne	.L5290
.L5288:
	movq	%rbx, %rax
	movq	$2, (%rbx)
	movq	%rdx, 8(%rbx)
	addq	$120, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L5305:
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L5293
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5287
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5286:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L5293
.L5287:
	cmpl	$116, (%rax)
	jne	.L5286
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L5285
	.p2align 4,,10
	.p2align 3
.L5304:
	movq	%rbx, %rax
	movq	$2, (%rbx)
	movq	$0, 8(%rbx)
	addq	$120, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L5302:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5278:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5273
	.p2align 4,,10
	.p2align 3
.L5303:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5280
	.p2align 4,,10
	.p2align 3
.L5294:
	xorl	%edx, %edx
	jmp	.L5288
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_argmax
	.def	fn_vlin_Types_Matrix_argmax;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_argmax
fn_vlin_Types_Matrix_argmax:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5308
	vmovdqu	(%r8), %xmm6
.L5308:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_argmax
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_argmin
	.def	fn_vlin_argmin;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_argmin
fn_vlin_argmin:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$120, %rsp
	.seh_stackalloc	120
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5331
	movl	(%r8), %ebp
	movq	8(%r8), %rdi
	cmpl	$6, %ebp
	jne	.L5310
	movslq	16(%rdi), %rcx
	testl	%ecx, %ecx
	jle	.L5342
	movq	8(%rdi), %rax
	salq	$5, %rcx
	addq	%rax, %rcx
	movq	%rax, %rdx
	jmp	.L5316
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5314:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5343
.L5316:
	cmpl	$109, (%rdx)
	jne	.L5314
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5320
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5319:
	addq	$32, %rax
	cmpq	%rcx, %rax
	je	.L5318
.L5320:
	cmpl	$107, (%rax)
	jne	.L5319
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5313
	.p2align 4,,10
	.p2align 3
.L5331:
	xorl	%ebp, %ebp
	xorl	%edi, %edi
.L5310:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5313:
	movq	%rdx, 56(%rsp)
	leaq	64(%rsp), %rcx
	leaq	48(%rsp), %rdx
	movq	%r8, 32(%rsp)
	leaq	32(%rsp), %r8
	movq	%r9, 40(%rsp)
	movl	$31, %r9d
	movq	%rax, 48(%rsp)
	call	vyne_binop
	cmpl	$2, 64(%rsp)
	movq	72(%rsp), %rsi
	je	.L5322
	vmovq	%rsi, %xmm2
	vcvttsd2siq	%xmm2, %rsi
.L5322:
	testq	%rsi, %rsi
	je	.L5344
	cmpl	$6, %ebp
	je	.L5345
.L5333:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
.L5325:
	leaq	80(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	cmpq	$1, %rsi
	jle	.L5334
	movq	80(%rsp), %rcx
	movl	$1, %eax
	xorl	%edx, %edx
	vmovsd	(%rcx), %xmm0
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5330:
	vmovsd	(%rcx,%rax,8), %xmm1
	vcomisd	%xmm1, %xmm0
	vminsd	%xmm0, %xmm1, %xmm0
	cmova	%rax, %rdx
	addq	$1, %rax
	cmpq	%rax, %rsi
	jne	.L5330
.L5328:
	movq	%rbx, %rax
	movq	$2, (%rbx)
	movq	%rdx, 8(%rbx)
	addq	$120, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
	.p2align 3
.L5345:
	movslq	16(%rdi), %rdx
	testl	%edx, %edx
	jle	.L5333
	movq	8(%rdi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5327
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5326:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L5333
.L5327:
	cmpl	$116, (%rax)
	jne	.L5326
	movl	16(%rax), %edx
	movq	24(%rax), %r8
	jmp	.L5325
	.p2align 4,,10
	.p2align 3
.L5344:
	movq	%rbx, %rax
	movq	$2, (%rbx)
	movq	$0, 8(%rbx)
	addq	$120, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L5342:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L5318:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5313
	.p2align 4,,10
	.p2align 3
.L5343:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5320
	.p2align 4,,10
	.p2align 3
.L5334:
	xorl	%edx, %edx
	jmp	.L5328
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_Types_Matrix_argmin
	.def	fn_vlin_Types_Matrix_argmin;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_Types_Matrix_argmin
fn_vlin_Types_Matrix_argmin:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	vmovaps	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	vpxor	%xmm6, %xmm6, %xmm6
	testl	%edx, %edx
	movq	%rcx, %rbx
	jle	.L5348
	vmovdqu	(%r8), %xmm6
.L5348:
	call	arena_alloc.constprop.2
	leaq	32(%rsp), %rcx
	movl	$1, %edx
	movq	%rax, %r8
	vmovdqu	%xmm6, (%rax)
	call	fn_vlin_argmin
	vmovdqu	32(%rsp), %xmm0
	movq	%rbx, %rax
	vmovdqu	%xmm0, (%rbx)
	vmovaps	48(%rsp), %xmm6
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_apply_sigmoid
	.def	fn_vlin_apply_sigmoid;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_apply_sigmoid
fn_vlin_apply_sigmoid:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	vmovaps	%xmm7, 192(%rsp)
	.seh_savexmm	%xmm7, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L5379
	movl	(%r8), %edi
	movq	8(%r8), %rsi
	cmpl	$6, %edi
	jne	.L5350
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5392
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5356
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5354:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5393
.L5356:
	cmpl	$109, (%rdx)
	jne	.L5354
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5360
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5359:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5358
.L5360:
	cmpl	$107, (%rax)
	jne	.L5359
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5353
	.p2align 4,,10
	.p2align 3
.L5379:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L5350:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5353:
	movq	%rax, 80(%rsp)
	leaq	80(%rsp), %rax
	leaq	96(%rsp), %rcx
	movq	%rdx, 88(%rsp)
	movq	%rax, %rdx
	movq	%r8, 64(%rsp)
	leaq	64(%rsp), %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbx
	je	.L5362
	vmovq	%rbx, %xmm2
	vcvttsd2siq	%xmm2, %rbx
.L5362:
	leaq	112(%rsp), %rcx
	movq	%rbx, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	112(%rsp), %rbp
	vmovdqu	120(%rsp), %xmm7
	jle	.L5363
	vmovsd	.LC32(%rip), %xmm6
	xorl	%r14d, %r14d
	.p2align 4,,10
	.p2align 3
.L5367:
	cmpl	$6, %edi
	jne	.L5381
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5381
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5366
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5365:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5381
.L5366:
	cmpl	$116, (%rax)
	jne	.L5365
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5364:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vmovsd	(%rax,%r14,8), %xmm0
	vxorpd	.LC86(%rip), %xmm0, %xmm0
	call	exp
	vaddsd	%xmm6, %xmm0, %xmm0
	vdivsd	%xmm0, %xmm6, %xmm0
	vmovsd	%xmm0, 0(%rbp,%r14,8)
	addq	$1, %r14
	cmpq	%r14, %rbx
	jne	.L5367
.L5363:
	call	arena_alloc.constprop.0
	cmpl	$6, %edi
	movl	$11, %ecx
	movq	%rbp, (%rax)
	movq	%rax, %rbx
	vmovdqu	%xmm7, 8(%rax)
	jne	.L5368
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5394
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %r8
	movq	%rax, %rdx
	jmp	.L5374
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5372:
	addq	$32, %rdx
	cmpq	%rdx, %r8
	je	.L5395
.L5374:
	cmpl	$109, (%rdx)
	jne	.L5372
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L5378
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5377:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L5376
.L5378:
	cmpl	$107, (%rax)
	jne	.L5377
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5371
	.p2align 4,,10
	.p2align 3
.L5381:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5364
	.p2align 4,,10
	.p2align 3
.L5368:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5371:
	movq	%rdx, 88(%rsp)
	movq	32(%rsp), %rdx
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	movq	%rcx, 48(%rsp)
	movq	40(%rsp), %rcx
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rbx, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%r13, %rax
	vmovdqu	%xmm1, 0(%r13)
	vmovaps	176(%rsp), %xmm6
	vmovaps	192(%rsp), %xmm7
	addq	$216, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L5394:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
.L5376:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5371
.L5392:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5358:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5353
.L5393:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5360
.L5395:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L5378
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_sigmoid_prime
	.def	fn_vlin_sigmoid_prime;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_sigmoid_prime
fn_vlin_sigmoid_prime:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	vmovaps	%xmm7, 192(%rsp)
	.seh_savexmm	%xmm7, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L5426
	movl	(%r8), %edi
	movq	8(%r8), %rsi
	cmpl	$6, %edi
	jne	.L5397
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5439
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5403
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5401:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5440
.L5403:
	cmpl	$109, (%rdx)
	jne	.L5401
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5407
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5406:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5405
.L5407:
	cmpl	$107, (%rax)
	jne	.L5406
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5400
	.p2align 4,,10
	.p2align 3
.L5426:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L5397:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5400:
	movq	%rax, 80(%rsp)
	leaq	80(%rsp), %rax
	leaq	96(%rsp), %rcx
	movq	%rdx, 88(%rsp)
	movq	%rax, %rdx
	movq	%r8, 64(%rsp)
	leaq	64(%rsp), %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbx
	je	.L5409
	vmovq	%rbx, %xmm3
	vcvttsd2siq	%xmm3, %rbx
.L5409:
	leaq	112(%rsp), %rcx
	movq	%rbx, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	112(%rsp), %rbp
	vmovdqu	120(%rsp), %xmm7
	jle	.L5410
	vmovsd	.LC32(%rip), %xmm6
	xorl	%r14d, %r14d
	.p2align 4,,10
	.p2align 3
.L5414:
	cmpl	$6, %edi
	jne	.L5428
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5428
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5413
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5412:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5428
.L5413:
	cmpl	$116, (%rax)
	jne	.L5412
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5411:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vmovsd	(%rax,%r14,8), %xmm1
	vsubsd	%xmm1, %xmm6, %xmm0
	vmulsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, 0(%rbp,%r14,8)
	addq	$1, %r14
	cmpq	%r14, %rbx
	jne	.L5414
.L5410:
	call	arena_alloc.constprop.0
	cmpl	$6, %edi
	movl	$11, %ecx
	movq	%rbp, (%rax)
	movq	%rax, %rbx
	vmovdqu	%xmm7, 8(%rax)
	jne	.L5415
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5441
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %r8
	movq	%rax, %rdx
	jmp	.L5421
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5419:
	addq	$32, %rdx
	cmpq	%rdx, %r8
	je	.L5442
.L5421:
	cmpl	$109, (%rdx)
	jne	.L5419
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L5425
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5424:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L5423
.L5425:
	cmpl	$107, (%rax)
	jne	.L5424
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5418
	.p2align 4,,10
	.p2align 3
.L5428:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5411
	.p2align 4,,10
	.p2align 3
.L5415:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5418:
	movq	%rdx, 88(%rsp)
	movq	32(%rsp), %rdx
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	movq	%rcx, 48(%rsp)
	movq	40(%rsp), %rcx
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rbx, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm2
	movq	%r13, %rax
	vmovdqu	%xmm2, 0(%r13)
	vmovaps	176(%rsp), %xmm6
	vmovaps	192(%rsp), %xmm7
	addq	$216, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L5441:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
.L5423:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5418
.L5439:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5405:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5400
.L5440:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5407
.L5442:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L5425
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_apply_tanh
	.def	fn_vlin_apply_tanh;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_apply_tanh
fn_vlin_apply_tanh:
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
	subq	$200, %rsp
	.seh_stackalloc	200
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L5473
	movl	(%r8), %edi
	movq	8(%r8), %rsi
	cmpl	$6, %edi
	jne	.L5444
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5486
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5450
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5448:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5487
.L5450:
	cmpl	$109, (%rdx)
	jne	.L5448
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5454
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5453:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5452
.L5454:
	cmpl	$107, (%rax)
	jne	.L5453
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5447
	.p2align 4,,10
	.p2align 3
.L5473:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L5444:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5447:
	movq	%rax, 80(%rsp)
	leaq	80(%rsp), %rax
	leaq	96(%rsp), %rcx
	movq	%rdx, 88(%rsp)
	movq	%rax, %rdx
	movq	%r8, 64(%rsp)
	leaq	64(%rsp), %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbx
	je	.L5456
	vmovq	%rbx, %xmm2
	vcvttsd2siq	%xmm2, %rbx
.L5456:
	leaq	112(%rsp), %rcx
	movq	%rbx, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	112(%rsp), %rbp
	vmovdqu	120(%rsp), %xmm6
	jle	.L5457
	xorl	%r14d, %r14d
	.p2align 4,,10
	.p2align 3
.L5461:
	cmpl	$6, %edi
	jne	.L5475
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5475
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5460
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5459:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5475
.L5460:
	cmpl	$116, (%rax)
	jne	.L5459
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5458:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vmovsd	(%rax,%r14,8), %xmm0
	call	tanh
	vmovsd	%xmm0, 0(%rbp,%r14,8)
	addq	$1, %r14
	cmpq	%r14, %rbx
	jne	.L5461
.L5457:
	call	arena_alloc.constprop.0
	cmpl	$6, %edi
	movl	$11, %ecx
	movq	%rbp, (%rax)
	movq	%rax, %rbx
	vmovdqu	%xmm6, 8(%rax)
	jne	.L5462
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5488
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %r8
	movq	%rax, %rdx
	jmp	.L5468
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5466:
	addq	$32, %rdx
	cmpq	%rdx, %r8
	je	.L5489
.L5468:
	cmpl	$109, (%rdx)
	jne	.L5466
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L5472
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5471:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L5470
.L5472:
	cmpl	$107, (%rax)
	jne	.L5471
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5465
	.p2align 4,,10
	.p2align 3
.L5475:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5458
	.p2align 4,,10
	.p2align 3
.L5462:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5465:
	movq	%rdx, 88(%rsp)
	movq	32(%rsp), %rdx
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	movq	%rcx, 48(%rsp)
	movq	40(%rsp), %rcx
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rbx, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%r13, %rax
	vmovdqu	%xmm1, 0(%r13)
	vmovaps	176(%rsp), %xmm6
	addq	$200, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L5488:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
.L5470:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5465
.L5486:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5452:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5447
.L5487:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5454
.L5489:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L5472
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_tanh_prime
	.def	fn_vlin_tanh_prime;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_tanh_prime
fn_vlin_tanh_prime:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	vmovaps	%xmm7, 192(%rsp)
	.seh_savexmm	%xmm7, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L5520
	movl	(%r8), %edi
	movq	8(%r8), %rsi
	cmpl	$6, %edi
	jne	.L5491
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5533
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5497
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5495:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5534
.L5497:
	cmpl	$109, (%rdx)
	jne	.L5495
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5501
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5500:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5499
.L5501:
	cmpl	$107, (%rax)
	jne	.L5500
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5494
	.p2align 4,,10
	.p2align 3
.L5520:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L5491:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5494:
	movq	%rax, 80(%rsp)
	leaq	80(%rsp), %rax
	leaq	96(%rsp), %rcx
	movq	%rdx, 88(%rsp)
	movq	%rax, %rdx
	movq	%r8, 64(%rsp)
	leaq	64(%rsp), %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbx
	je	.L5503
	vmovq	%rbx, %xmm2
	vcvttsd2siq	%xmm2, %rbx
.L5503:
	leaq	112(%rsp), %rcx
	movq	%rbx, %rdx
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	112(%rsp), %rbp
	vmovdqu	120(%rsp), %xmm7
	jle	.L5504
	vmovsd	.LC32(%rip), %xmm6
	xorl	%r14d, %r14d
	.p2align 4,,10
	.p2align 3
.L5508:
	cmpl	$6, %edi
	jne	.L5522
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5522
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5507
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5506:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5522
.L5507:
	cmpl	$116, (%rax)
	jne	.L5506
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5505:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vmovsd	(%rax,%r14,8), %xmm0
	vfnmadd132sd	%xmm0, %xmm6, %xmm0
	vmovsd	%xmm0, 0(%rbp,%r14,8)
	addq	$1, %r14
	cmpq	%r14, %rbx
	jne	.L5508
.L5504:
	call	arena_alloc.constprop.0
	cmpl	$6, %edi
	movl	$11, %ecx
	movq	%rbp, (%rax)
	movq	%rax, %rbx
	vmovdqu	%xmm7, 8(%rax)
	jne	.L5509
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5535
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %r8
	movq	%rax, %rdx
	jmp	.L5515
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5513:
	addq	$32, %rdx
	cmpq	%rdx, %r8
	je	.L5536
.L5515:
	cmpl	$109, (%rdx)
	jne	.L5513
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L5519
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5518:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L5517
.L5519:
	cmpl	$107, (%rax)
	jne	.L5518
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5512
	.p2align 4,,10
	.p2align 3
.L5522:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5505
	.p2align 4,,10
	.p2align 3
.L5509:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5512:
	movq	%rdx, 88(%rsp)
	movq	32(%rsp), %rdx
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	movq	%rcx, 48(%rsp)
	movq	40(%rsp), %rcx
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rbx, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%r13, %rax
	vmovdqu	%xmm1, 0(%r13)
	vmovaps	176(%rsp), %xmm6
	vmovaps	192(%rsp), %xmm7
	addq	$216, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L5535:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
.L5517:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5512
.L5533:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5499:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5494
.L5534:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5501
.L5536:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L5519
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_apply_relu
	.def	fn_vlin_apply_relu;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_apply_relu
fn_vlin_apply_relu:
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
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	vmovaps	%xmm7, 192(%rsp)
	.seh_savexmm	%xmm7, 192
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L5568
	movl	(%r8), %edi
	movq	8(%r8), %rsi
	cmpl	$6, %edi
	jne	.L5538
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5584
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5544
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5542:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5585
.L5544:
	cmpl	$109, (%rdx)
	jne	.L5542
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5548
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5547:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5546
.L5548:
	cmpl	$107, (%rax)
	jne	.L5547
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5541
	.p2align 4,,10
	.p2align 3
.L5568:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L5538:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5541:
	movq	%rax, 80(%rsp)
	leaq	80(%rsp), %rax
	leaq	96(%rsp), %rcx
	movq	%rdx, 88(%rsp)
	movq	%rax, %rdx
	movq	%r8, 64(%rsp)
	leaq	64(%rsp), %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rcx, 32(%rsp)
	movq	%rax, 40(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbx
	je	.L5550
	vmovq	%rbx, %xmm2
	vcvttsd2siq	%xmm2, %rbx
.L5550:
	leaq	112(%rsp), %rcx
	movq	%rbx, %rdx
	xorl	%r14d, %r14d
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	112(%rsp), %rbp
	vmovdqu	120(%rsp), %xmm7
	vxorpd	%xmm6, %xmm6, %xmm6
	jle	.L5557
	.p2align 4,,10
	.p2align 3
.L5551:
	cmpl	$6, %edi
	jne	.L5571
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5571
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5556
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5555:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5571
.L5556:
	cmpl	$116, (%rax)
	jne	.L5555
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5554:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vmovsd	(%rax,%r14,8), %xmm0
	vmaxsd	%xmm6, %xmm0, %xmm0
	vmovsd	%xmm0, 0(%rbp,%r14,8)
	addq	$1, %r14
	cmpq	%r14, %rbx
	jne	.L5551
.L5557:
	call	arena_alloc.constprop.0
	cmpl	$6, %edi
	movl	$11, %ecx
	movq	%rbp, (%rax)
	movq	%rax, %rbx
	vmovdqu	%xmm7, 8(%rax)
	je	.L5586
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5560:
	movq	%rdx, 88(%rsp)
	movq	40(%rsp), %rdx
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	movq	%rcx, 48(%rsp)
	movq	32(%rsp), %rcx
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rbx, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%r13, %rax
	vmovdqu	%xmm1, 0(%r13)
	vmovaps	176(%rsp), %xmm6
	vmovaps	192(%rsp), %xmm7
	addq	$216, %rsp
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
.L5571:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5554
	.p2align 4,,10
	.p2align 3
.L5586:
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5587
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %r8
	movq	%rax, %rdx
	jmp	.L5563
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5561:
	addq	$32, %rdx
	cmpq	%rdx, %r8
	je	.L5588
.L5563:
	cmpl	$109, (%rdx)
	jne	.L5561
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L5567
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5566:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L5565
.L5567:
	cmpl	$107, (%rax)
	jne	.L5566
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5560
.L5587:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
.L5565:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5560
.L5584:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5546:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5541
.L5585:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5548
.L5588:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L5567
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_relu_prime
	.def	fn_vlin_relu_prime;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_relu_prime
fn_vlin_relu_prime:
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
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 176(%rsp)
	.seh_savexmm	%xmm6, 176
	vmovaps	%xmm7, 192(%rsp)
	.seh_savexmm	%xmm7, 192
	vmovaps	%xmm8, 208(%rsp)
	.seh_savexmm	%xmm8, 208
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r13
	jle	.L5621
	movl	(%r8), %edi
	movq	8(%r8), %rsi
	cmpl	$6, %edi
	jne	.L5590
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5638
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5596
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5594:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5639
.L5596:
	cmpl	$109, (%rdx)
	jne	.L5594
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5600
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5599:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5598
.L5600:
	cmpl	$107, (%rax)
	jne	.L5599
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5593
	.p2align 4,,10
	.p2align 3
.L5621:
	xorl	%esi, %esi
	xorl	%edi, %edi
.L5590:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5593:
	movq	%rax, 80(%rsp)
	leaq	80(%rsp), %rax
	leaq	96(%rsp), %rcx
	movq	%rdx, 88(%rsp)
	movq	%rax, %rdx
	movq	%r8, 64(%rsp)
	leaq	64(%rsp), %r8
	movq	%r9, 72(%rsp)
	movl	$31, %r9d
	movq	%rcx, 40(%rsp)
	movq	%rax, 32(%rsp)
	call	vyne_binop
	cmpl	$2, 96(%rsp)
	movq	104(%rsp), %rbx
	je	.L5602
	vmovq	%rbx, %xmm2
	vcvttsd2siq	%xmm2, %rbx
.L5602:
	leaq	112(%rsp), %rcx
	movq	%rbx, %rdx
	xorl	%r14d, %r14d
	call	fn_vlin_zeros_f64_native
	testq	%rbx, %rbx
	movq	112(%rsp), %rbp
	vmovdqu	120(%rsp), %xmm8
	jle	.L5610
	vmovsd	.LC32(%rip), %xmm7
	vxorpd	%xmm6, %xmm6, %xmm6
	.p2align 4,,10
	.p2align 3
.L5603:
	cmpl	$6, %edi
	jne	.L5624
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5624
	movq	8(%rsi), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5608
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5607:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5624
.L5608:
	cmpl	$116, (%rax)
	jne	.L5607
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5606:
	leaq	144(%rsp), %rcx
	call	vyne_value_to_array_f64.isra.0
	movq	144(%rsp), %rax
	vcmpnltsd	(%rax,%r14,8), %xmm6, %xmm0
	vblendvpd	%xmm0, %xmm6, %xmm7, %xmm0
	vmovsd	%xmm0, 0(%rbp,%r14,8)
	addq	$1, %r14
	cmpq	%r14, %rbx
	jne	.L5603
.L5610:
	call	arena_alloc.constprop.0
	cmpl	$6, %edi
	movl	$11, %ecx
	movq	%rbp, (%rax)
	movq	%rax, %rbx
	vmovdqu	%xmm8, 8(%rax)
	je	.L5640
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	xorl	%edx, %edx
.L5613:
	movq	%rdx, 88(%rsp)
	movq	32(%rsp), %rdx
	leaq	48(%rsp), %r9
	leaq	64(%rsp), %r8
	movq	%rcx, 48(%rsp)
	movq	40(%rsp), %rcx
	movq	%rax, 80(%rsp)
	movq	%r10, 64(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rbx, 56(%rsp)
	call	struct_vlin_Types_Matrix
	vmovdqu	96(%rsp), %xmm1
	movq	%r13, %rax
	vmovdqu	%xmm1, 0(%r13)
	vmovaps	176(%rsp), %xmm6
	vmovaps	192(%rsp), %xmm7
	vmovaps	208(%rsp), %xmm8
	addq	$232, %rsp
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
.L5624:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5606
	.p2align 4,,10
	.p2align 3
.L5640:
	movslq	16(%rsi), %rdx
	testl	%edx, %edx
	jle	.L5641
	movq	8(%rsi), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %r8
	movq	%rax, %rdx
	jmp	.L5616
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5614:
	addq	$32, %rdx
	cmpq	%rdx, %r8
	je	.L5642
.L5616:
	cmpl	$109, (%rdx)
	jne	.L5614
	movq	16(%rdx), %r10
	movq	24(%rdx), %r11
	jmp	.L5620
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5619:
	addq	$32, %rax
	cmpq	%rax, %r8
	je	.L5618
.L5620:
	cmpl	$107, (%rax)
	jne	.L5619
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
	jmp	.L5613
.L5641:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
.L5618:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5613
.L5638:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5598:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5593
.L5639:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5600
.L5642:
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	jmp	.L5620
	.seh_endproc
	.p2align 4
	.globl	fn_vlin_sgd_update_inplace
	.def	fn_vlin_sgd_update_inplace;	.scl	2;	.type	32;	.endef
	.seh_proc	fn_vlin_sgd_update_inplace
fn_vlin_sgd_update_inplace:
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
	subq	$200, %rsp
	.seh_stackalloc	200
	vmovaps	%xmm6, 160(%rsp)
	.seh_savexmm	%xmm6, 160
	vmovaps	%xmm7, 176(%rsp)
	.seh_savexmm	%xmm7, 176
	.seh_endprologue
	testl	%edx, %edx
	movq	%rcx, %r15
	jle	.L5667
	movl	(%r8), %eax
	cmpl	$1, %edx
	movq	8(%r8), %rbx
	movl	%eax, 40(%rsp)
	je	.L5668
	movl	16(%r8), %eax
	cmpl	$2, %edx
	movq	24(%r8), %rbp
	movl	%eax, 44(%rsp)
	je	.L5669
	movq	40(%r8), %rax
	cmpl	$1, 32(%r8)
	vmovq	%rax, %xmm7
	je	.L5645
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vmovapd	%xmm0, %xmm7
.L5645:
	cmpl	$6, 40(%rsp)
	jne	.L5644
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L5685
	movq	8(%rbx), %rax
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rcx
	movq	%rax, %rdx
	jmp	.L5652
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5650:
	addq	$32, %rdx
	cmpq	%rdx, %rcx
	je	.L5686
.L5652:
	cmpl	$109, (%rdx)
	jne	.L5650
	movq	16(%rdx), %r8
	movq	24(%rdx), %r9
	jmp	.L5656
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5655:
	addq	$32, %rax
	cmpq	%rax, %rcx
	je	.L5654
.L5656:
	cmpl	$107, (%rax)
	jne	.L5655
	movq	24(%rax), %rdx
	movq	16(%rax), %rax
.L5649:
	movq	%rdx, 72(%rsp)
	leaq	80(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movq	%r8, 48(%rsp)
	leaq	48(%rsp), %r8
	movq	%r9, 56(%rsp)
	movl	$31, %r9d
	movq	%rax, 64(%rsp)
	call	vyne_binop
	cmpl	$2, 80(%rsp)
	movq	88(%rsp), %r12
	je	.L5658
	vmovq	%r12, %xmm1
	vcvttsd2siq	%xmm1, %r12
.L5658:
	xorl	%r13d, %r13d
	testq	%r12, %r12
	jle	.L5666
	movq	%r15, 272(%rsp)
	.p2align 4,,10
	.p2align 3
.L5659:
	cmpl	$6, 40(%rsp)
	jne	.L5672
	movslq	16(%rbx), %rdx
	testl	%edx, %edx
	jle	.L5672
	movq	8(%rbx), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5662
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5661:
	addq	$32, %rax
	cmpq	%rdx, %rax
	je	.L5672
.L5662:
	cmpl	$116, (%rax)
	jne	.L5661
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5660:
	leaq	96(%rsp), %rcx
	leaq	0(,%r13,8), %r14
	call	vyne_value_to_array_f64.isra.0
	movq	96(%rsp), %r15
	addq	%r14, %r15
	cmpl	$6, 44(%rsp)
	vmovsd	(%r15), %xmm6
	jne	.L5674
	movslq	16(%rbp), %rdx
	testl	%edx, %edx
	jle	.L5674
	movq	8(%rbp), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	jmp	.L5665
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L5664:
	addq	$32, %rax
	cmpq	%rax, %rdx
	je	.L5674
.L5665:
	cmpl	$116, (%rax)
	jne	.L5664
	movl	16(%rax), %edx
	movq	24(%rax), %r8
.L5663:
	leaq	128(%rsp), %rcx
	addq	$1, %r13
	call	vyne_value_to_array_f64.isra.0
	movq	128(%rsp), %rax
	cmpq	%r13, %r12
	vfnmadd231sd	(%rax,%r14), %xmm7, %xmm6
	vmovsd	%xmm6, (%r15)
	jne	.L5659
	movq	272(%rsp), %r15
.L5666:
	movq	$2, (%r15)
	movq	%r15, %rax
	movq	$0, 8(%r15)
	vmovaps	160(%rsp), %xmm6
	vmovaps	176(%rsp), %xmm7
	addq	$200, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L5668:
	movl	$0, 44(%rsp)
	xorl	%ebp, %ebp
	vxorpd	%xmm7, %xmm7, %xmm7
	jmp	.L5645
	.p2align 4,,10
	.p2align 3
.L5674:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5663
	.p2align 4,,10
	.p2align 3
.L5672:
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	jmp	.L5660
	.p2align 4,,10
	.p2align 3
.L5667:
	movl	$0, 44(%rsp)
	xorl	%ebp, %ebp
	vxorpd	%xmm7, %xmm7, %xmm7
	xorl	%ebx, %ebx
	movl	$0, 40(%rsp)
.L5644:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5649
.L5685:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
.L5654:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L5649
.L5686:
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	jmp	.L5656
.L5669:
	vxorpd	%xmm7, %xmm7, %xmm7
	jmp	.L5645
	.seh_endproc
	.section .rdata,"dr"
.LC87:
	.ascii "\33\0"
.LC88:
	.ascii "\33[0m\0"
.LC89:
	.ascii "\33[1m\0"
.LC90:
	.ascii "\33[2m\0"
.LC91:
	.ascii "\33[3m\0"
.LC92:
	.ascii "\33[4m\0"
.LC93:
	.ascii "\33[5m\0"
.LC94:
	.ascii "\33[7m\0"
.LC95:
	.ascii "\33[8m\0"
.LC96:
	.ascii "\33[9m\0"
.LC97:
	.ascii "\33[0;30m\0"
.LC98:
	.ascii "\33[0;31m\0"
.LC99:
	.ascii "\33[0;32m\0"
.LC100:
	.ascii "\33[0;33m\0"
.LC101:
	.ascii "\33[0;34m\0"
.LC102:
	.ascii "\33[0;35m\0"
.LC103:
	.ascii "\33[0;36m\0"
.LC104:
	.ascii "\33[0;37m\0"
.LC105:
	.ascii "\33[0;90m\0"
.LC106:
	.ascii "\33[1;30m\0"
.LC107:
	.ascii "\33[1;31m\0"
.LC108:
	.ascii "\33[1;32m\0"
.LC109:
	.ascii "\33[1;33m\0"
.LC110:
	.ascii "\33[1;34m\0"
.LC111:
	.ascii "\33[1;35m\0"
.LC112:
	.ascii "\33[1;36m\0"
.LC113:
	.ascii "\33[1;37m\0"
.LC114:
	.ascii "\33[40m\0"
.LC115:
	.ascii "\33[41m\0"
.LC116:
	.ascii "\33[42m\0"
.LC117:
	.ascii "\33[43m\0"
.LC118:
	.ascii "\33[44m\0"
.LC119:
	.ascii "\33[45m\0"
.LC120:
	.ascii "\33[46m\0"
.LC121:
	.ascii "\33[47m\0"
.LC122:
	.ascii "\33[100m\0"
.LC123:
	.ascii "\33[101m\0"
.LC124:
	.ascii "\33[102m\0"
.LC125:
	.ascii "\33[103m\0"
.LC126:
	.ascii "\33[104m\0"
.LC127:
	.ascii "\33[105m\0"
.LC128:
	.ascii "\33[106m\0"
.LC129:
	.ascii "\33[107m\0"
.LC130:
	.ascii "cross_product\0"
.LC131:
	.ascii "dot\0"
.LC132:
	.ascii "slope\0"
.LC133:
	.ascii "magnitude\0"
.LC134:
	.ascii "transposed\0"
.LC135:
	.ascii "reshape\0"
.LC136:
	.ascii "mul_scalar\0"
.LC137:
	.ascii "add_scalar\0"
.LC138:
	.ascii "negate\0"
.LC139:
	.ascii "argmin\0"
.LC140:
	.ascii "argmax\0"
.LC141:
	.ascii "norm_fro\0"
.LC142:
	.ascii "trace\0"
.LC143:
	.ascii "maximum\0"
.LC144:
	.ascii "minimum\0"
.LC145:
	.ascii "mean\0"
.LC146:
	.ascii "sum\0"
.LC147:
	.ascii "flatten\0"
.LC148:
	.ascii "col_at\0"
.LC149:
	.ascii "row_at\0"
.LC150:
	.ascii "get\0"
.LC151:
	.ascii "is_vector\0"
.LC152:
	.ascii "is_square\0"
.LC153:
	.ascii "size\0"
.LC154:
	.ascii "shape\0"
.LC155:
	.ascii "config=\0"
.LC156:
	.ascii " N=\0"
.LC157:
	.ascii " iters=\0"
.LC160:
	.ascii "checksum: \0"
	.align 8
.LC161:
	.ascii "Runtime error: vmem.checkpoint() stack overflow (>%d)\12\0"
	.align 8
.LC162:
	.ascii "Runtime error: invalid or already-rewound checkpoint handle %lld\12\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
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
	subq	$536, %rsp
	.seh_stackalloc	536
	vmovaps	%xmm6, 368(%rsp)
	.seh_savexmm	%xmm6, 368
	vmovaps	%xmm7, 384(%rsp)
	.seh_savexmm	%xmm7, 384
	vmovaps	%xmm8, 400(%rsp)
	.seh_savexmm	%xmm8, 400
	vmovaps	%xmm9, 416(%rsp)
	.seh_savexmm	%xmm9, 416
	vmovaps	%xmm10, 432(%rsp)
	.seh_savexmm	%xmm10, 432
	vmovaps	%xmm11, 448(%rsp)
	.seh_savexmm	%xmm11, 448
	vmovaps	%xmm12, 464(%rsp)
	.seh_savexmm	%xmm12, 464
	vmovaps	%xmm13, 480(%rsp)
	.seh_savexmm	%xmm13, 480
	vmovaps	%xmm14, 496(%rsp)
	.seh_savexmm	%xmm14, 496
	vmovaps	%xmm15, 512(%rsp)
	.seh_savexmm	%xmm15, 512
	.seh_endprologue
	call	__main
	leaq	.LC87(%rip), %rax
	movq	$3, v_ESC(%rip)
	movq	%rax, 8+v_ESC(%rip)
	leaq	.LC88(%rip), %rax
	movq	%rax, 8+v_RESET(%rip)
	leaq	.LC89(%rip), %rax
	movq	%rax, 8+v_BOLD(%rip)
	leaq	.LC90(%rip), %rax
	movq	%rax, 8+v_DIM(%rip)
	leaq	.LC91(%rip), %rax
	movq	%rax, 8+v_ITALIC(%rip)
	leaq	.LC92(%rip), %rax
	movq	%rax, 8+v_UNDER(%rip)
	leaq	.LC93(%rip), %rax
	movq	%rax, 8+v_BLINK(%rip)
	leaq	.LC94(%rip), %rax
	movq	%rax, 8+v_REVERSE(%rip)
	leaq	.LC95(%rip), %rax
	movq	%rax, 8+v_HIDDEN(%rip)
	leaq	.LC96(%rip), %rax
	movq	%rax, 8+v_STRIKE(%rip)
	leaq	.LC97(%rip), %rax
	movq	%rax, 8+v_Palette_black(%rip)
	leaq	.LC98(%rip), %rax
	movq	%rax, 8+v_Palette_red(%rip)
	leaq	.LC99(%rip), %rax
	movq	%rax, 8+v_Palette_green(%rip)
	leaq	.LC100(%rip), %rax
	movq	%rax, 8+v_Palette_yellow(%rip)
	leaq	.LC101(%rip), %rax
	movq	%rax, 8+v_Palette_blue(%rip)
	leaq	.LC102(%rip), %rax
	movq	%rax, 8+v_Palette_magenta(%rip)
	leaq	.LC103(%rip), %rax
	movq	$3, v_RESET(%rip)
	movq	$3, v_BOLD(%rip)
	movq	$3, v_DIM(%rip)
	movq	$3, v_ITALIC(%rip)
	movq	$3, v_UNDER(%rip)
	movq	$3, v_BLINK(%rip)
	movq	$3, v_REVERSE(%rip)
	movq	$3, v_HIDDEN(%rip)
	movq	$3, v_STRIKE(%rip)
	movq	$3, v_Palette_black(%rip)
	movq	$3, v_Palette_red(%rip)
	movq	$3, v_Palette_green(%rip)
	movq	$3, v_Palette_yellow(%rip)
	movq	$3, v_Palette_blue(%rip)
	movq	$3, v_Palette_magenta(%rip)
	movq	$3, v_Palette_cyan(%rip)
	movq	%rax, 8+v_Palette_cyan(%rip)
	leaq	.LC104(%rip), %rax
	movq	%rax, 8+v_Palette_white(%rip)
	leaq	.LC105(%rip), %rax
	movq	%rax, 8+v_Palette_gray(%rip)
	leaq	.LC106(%rip), %rax
	movq	%rax, 8+v_Bright_black(%rip)
	leaq	.LC107(%rip), %rax
	movq	%rax, 8+v_Bright_red(%rip)
	leaq	.LC108(%rip), %rax
	movq	%rax, 8+v_Bright_green(%rip)
	leaq	.LC109(%rip), %rax
	movq	%rax, 8+v_Bright_yellow(%rip)
	leaq	.LC110(%rip), %rax
	movq	%rax, 8+v_Bright_blue(%rip)
	leaq	.LC111(%rip), %rax
	movq	%rax, 8+v_Bright_magenta(%rip)
	leaq	.LC112(%rip), %rax
	movq	%rax, 8+v_Bright_cyan(%rip)
	leaq	.LC113(%rip), %rax
	movq	%rax, 8+v_Bright_white(%rip)
	leaq	.LC114(%rip), %rax
	movq	%rax, 8+v_BG_black(%rip)
	leaq	.LC115(%rip), %rax
	movq	%rax, 8+v_BG_red(%rip)
	leaq	.LC116(%rip), %rax
	movq	%rax, 8+v_BG_green(%rip)
	leaq	.LC117(%rip), %rax
	movq	%rax, 8+v_BG_yellow(%rip)
	leaq	.LC118(%rip), %rax
	movq	%rax, 8+v_BG_blue(%rip)
	leaq	.LC119(%rip), %rax
	movq	$3, v_Palette_white(%rip)
	movq	$3, v_Palette_gray(%rip)
	movq	$3, v_Bright_black(%rip)
	movq	$3, v_Bright_red(%rip)
	movq	$3, v_Bright_green(%rip)
	movq	$3, v_Bright_yellow(%rip)
	movq	$3, v_Bright_blue(%rip)
	movq	$3, v_Bright_magenta(%rip)
	movq	$3, v_Bright_cyan(%rip)
	movq	$3, v_Bright_white(%rip)
	movq	$3, v_BG_black(%rip)
	movq	$3, v_BG_red(%rip)
	movq	$3, v_BG_green(%rip)
	movq	$3, v_BG_yellow(%rip)
	movq	$3, v_BG_blue(%rip)
	movq	$3, v_BG_magenta(%rip)
	movq	%rax, 8+v_BG_magenta(%rip)
	leaq	.LC120(%rip), %rax
	movl	g_method_count(%rip), %edx
	movq	%rax, 8+v_BG_cyan(%rip)
	leaq	.LC121(%rip), %rax
	movq	%rax, 8+v_BG_white(%rip)
	leaq	.LC122(%rip), %rax
	cmpl	$255, %edx
	movq	%rax, 8+v_BGBright_black(%rip)
	leaq	.LC123(%rip), %rax
	movq	%rax, 8+v_BGBright_red(%rip)
	leaq	.LC124(%rip), %rax
	movq	%rax, 8+v_BGBright_green(%rip)
	leaq	.LC125(%rip), %rax
	movq	%rax, 8+v_BGBright_yellow(%rip)
	leaq	.LC126(%rip), %rax
	movq	%rax, 8+v_BGBright_blue(%rip)
	leaq	.LC127(%rip), %rax
	movq	%rax, 8+v_BGBright_magenta(%rip)
	leaq	.LC128(%rip), %rax
	movq	%rax, 8+v_BGBright_cyan(%rip)
	leaq	.LC129(%rip), %rax
	movq	$3, v_BG_cyan(%rip)
	movq	$3, v_BG_white(%rip)
	movq	$3, v_BGBright_black(%rip)
	movq	$3, v_BGBright_red(%rip)
	movq	$3, v_BGBright_green(%rip)
	movq	$3, v_BGBright_yellow(%rip)
	movq	$3, v_BGBright_blue(%rip)
	movq	$3, v_BGBright_magenta(%rip)
	movq	$3, v_BGBright_cyan(%rip)
	movq	$3, v_BGBright_white(%rip)
	movq	%rax, 8+v_BGBright_white(%rip)
	jg	.L5757
	vmovq	.LC163(%rip), %xmm3
	leaq	.LC130(%rip), %rax
	movslq	%edx, %rcx
	vmovq	.LC164(%rip), %xmm0
	imulq	$24, %rcx, %rcx
	leaq	fn_vlin_Types_Matrix_shape(%rip), %rdi
	vpinsrq	$1, %rax, %xmm3, %xmm6
	leaq	.LC131(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm7
	leaq	.LC132(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm8
	leaq	.LC133(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm9
	vmovq	.LC164(%rip), %xmm3
	leaq	.LC134(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm10
	vmovdqa	%xmm3, %xmm4
	vmovdqa	%xmm3, %xmm5
	leaq	.LC135(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm11
	leaq	.LC136(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm12
	leaq	.LC137(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm13
	leaq	.LC138(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm14
	leaq	.LC139(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm15
	leaq	.LC140(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm1
	leaq	.LC141(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm2
	leaq	.LC142(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm3
	leaq	.LC143(%rip), %rax
	vpinsrq	$1, %rax, %xmm4, %xmm4
	leaq	.LC144(%rip), %rax
	vpinsrq	$1, %rax, %xmm5, %xmm5
	leaq	.LC145(%rip), %rax
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC146(%rip), %rax
	vmovdqa	%xmm0, 80(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC147(%rip), %rax
	vmovdqa	%xmm0, 96(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC69(%rip), %rax
	vmovdqa	%xmm0, 112(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC148(%rip), %rax
	vmovdqa	%xmm0, 128(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC149(%rip), %rax
	vmovdqa	%xmm0, 144(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC150(%rip), %rax
	vmovdqa	%xmm0, 160(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC151(%rip), %rax
	vmovdqa	%xmm0, 176(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC152(%rip), %rax
	vmovdqa	%xmm0, 192(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC153(%rip), %rax
	vmovdqa	%xmm0, 208(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	.LC154(%rip), %rax
	vmovdqa	%xmm0, 224(%rsp)
	vmovq	.LC164(%rip), %xmm0
	vpinsrq	$1, %rax, %xmm0, %xmm0
	leaq	g_method_table(%rip), %rax
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	1(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_size(%rip), %rdi
	vmovdqa	224(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	2(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_is_square(%rip), %rdi
	vmovdqa	208(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	3(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_is_vector(%rip), %rdi
	vmovdqa	192(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	4(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_get(%rip), %rdi
	vmovdqa	176(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	5(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_row_at(%rip), %rdi
	vmovdqa	160(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	6(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_col_at(%rip), %rdi
	vmovdqa	144(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	7(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_copy(%rip), %rdi
	vmovdqa	128(%rsp), %xmm0
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	8(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	vmovdqa	112(%rsp), %xmm0
	leaq	fn_vlin_Types_Matrix_flatten(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	9(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	vmovdqa	96(%rsp), %xmm0
	leaq	fn_vlin_Types_Matrix_sum(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	10(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	vmovdqa	80(%rsp), %xmm0
	leaq	fn_vlin_Types_Matrix_mean(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm0, (%rax,%rcx)
	leal	11(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_minimum(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm5, (%rax,%rcx)
	leal	12(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_maximum(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm4, (%rax,%rcx)
	leal	13(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_trace(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm3, (%rax,%rcx)
	leal	14(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_norm_fro(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm2, (%rax,%rcx)
	leal	15(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_argmax(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm1, (%rax,%rcx)
	leal	16(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_argmin(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm15, (%rax,%rcx)
	leal	17(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_negate(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm14, (%rax,%rcx)
	leal	18(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_add_scalar(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm13, (%rax,%rcx)
	leal	19(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_mul_scalar(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm12, (%rax,%rcx)
	leal	20(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_reshape(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm11, (%rax,%rcx)
	leal	21(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Matrix_transposed(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm10, (%rax,%rcx)
	leal	22(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Vector_magnitude(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm9, (%rax,%rcx)
	leal	23(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Vector_slope(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm8, (%rax,%rcx)
	leal	24(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Vector_dot(%rip), %rdi
	imulq	$24, %rcx, %rcx
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm7, (%rax,%rcx)
	leal	25(%rdx), %ecx
	cmpl	$256, %ecx
	movl	%ecx, g_method_count(%rip)
	je	.L5757
	movslq	%ecx, %rcx
	leaq	fn_vlin_Types_Vector_cross_product(%rip), %rdi
	addl	$26, %edx
	imulq	$24, %rcx, %rcx
	movl	%edx, g_method_count(%rip)
	movq	%rdi, 16(%rax,%rcx)
	vmovdqu	%xmm6, (%rax,%rcx)
.L5757:
	leaq	272(%rsp), %r15
	leaq	288(%rsp), %rdi
	movabsq	$1442695040888963407, %rbp
	movq	$42, _vmath_rng_state(%rip)
	movq	%rdi, %rcx
	movq	%r15, %rdx
	movq	%rdi, 80(%rsp)
	movq	%rdi, %rbx
	leaq	256(%rsp), %r14
	movq	%rbp, _vmath_rng_inc(%rip)
	movq	$1024, v_N(%rip)
	movq	$100, v_ITERS(%rip)
	movq	$1, v_CONFIG(%rip)
	movq	$2, 272(%rsp)
	movq	$1, 280(%rsp)
	movq	%r15, 176(%rsp)
	call	vyne_to_string
	movq	%rdi, %rcx
	movq	%r14, %r8
	movq	%r15, %rdx
	vmovdqu	288(%rsp), %xmm2
	leaq	.LC155(%rip), %rax
	movl	$29, %r9d
	movq	$3, 272(%rsp)
	movq	%rax, 280(%rsp)
	vmovdqa	%xmm2, 256(%rsp)
	movq	%r14, 160(%rsp)
	call	vyne_binop
	movq	%r14, %r8
	movq	%rdi, %rcx
	movq	%r15, %rdx
	vmovdqu	288(%rsp), %xmm3
	leaq	.LC156(%rip), %rax
	movl	$29, %r9d
	movq	$3, 256(%rsp)
	movq	%rax, 264(%rsp)
	vmovdqa	%xmm3, 272(%rsp)
	call	vyne_binop
	movq	v_N(%rip), %rax
	movq	%rbx, %rcx
	movq	%r15, %rdx
	movq	288(%rsp), %rsi
	movq	296(%rsp), %rdi
	movq	$2, 272(%rsp)
	movq	%rax, 280(%rsp)
	call	vyne_to_string
	movq	%rbx, %rcx
	movq	%r14, %r8
	movq	%r15, %rdx
	vmovdqu	288(%rsp), %xmm4
	movl	$29, %r9d
	movq	%rsi, 272(%rsp)
	movq	%rdi, 280(%rsp)
	vmovdqa	%xmm4, 256(%rsp)
	call	vyne_binop
	movq	%r14, %r8
	movq	%rbx, %rcx
	movq	%r15, %rdx
	vmovdqu	288(%rsp), %xmm5
	leaq	.LC157(%rip), %rax
	movl	$29, %r9d
	movq	$3, 256(%rsp)
	movq	%rax, 264(%rsp)
	vmovdqa	%xmm5, 272(%rsp)
	call	vyne_binop
	movq	v_ITERS(%rip), %rax
	movq	%rbx, %rcx
	movq	%r15, %rdx
	movq	288(%rsp), %rsi
	movq	296(%rsp), %rdi
	movq	$2, 272(%rsp)
	movq	%rax, 280(%rsp)
	call	vyne_to_string
	movq	%r14, %r8
	movq	%rbx, %rcx
	movq	%r15, %rdx
	vmovdqu	288(%rsp), %xmm2
	movl	$29, %r9d
	movq	%rsi, 272(%rsp)
	movq	%rdi, 280(%rsp)
	vmovdqa	%xmm2, 256(%rsp)
	call	vyne_binop
	movq	296(%rsp), %rdx
	movl	288(%rsp), %ecx
	call	vyne_out.isra.0
	movq	v_N(%rip), %rdx
	leaq	304(%rsp), %rcx
	imulq	%rdx, %rdx
	call	fn_vlin_zeros_f64_native
	call	arena_alloc.constprop.0
	movq	304(%rsp), %rdx
	vmovdqu	312(%rsp), %xmm0
	leaq	336(%rsp), %rcx
	movq	.LC31(%rip), %rbx
	movq	%rdx, (%rax)
	movq	v_N(%rip), %rdx
	vmovdqu	%xmm0, 8(%rax)
	imulq	%rdx, %rdx
	movq	%rax, 8+v_A_flat(%rip)
	movq	%rbx, v_A_flat(%rip)
	call	fn_vlin_zeros_f64_native
	call	arena_alloc.constprop.0
	movq	336(%rsp), %rdx
	vmovdqu	344(%rsp), %xmm0
	movq	v_N(%rip), %r9
	movq	%rdx, (%rax)
	vmovdqu	%xmm0, 8(%rax)
	movq	%rax, 8+v_B_flat(%rip)
	movq	%r9, %rax
	subq	$1, %rax
	movq	%rbx, v_B_flat(%rip)
	js	.L5758
	movq	%r9, 96(%rsp)
	vxorps	%xmm9, %xmm9, %xmm9
	movq	%r9, %r15
	xorl	%r12d, %r12d
	vmovsd	.LC73(%rip), %xmm8
	vmovsd	.LC158(%rip), %xmm7
	.p2align 4,,10
	.p2align 3
.L5729:
	testq	%r15, %r15
	jle	.L5713
	vmovsd	.LC159(%rip), %xmm6
	movq	%r15, %r14
	xorl	%r13d, %r13d
	leaq	v_A_flat(%rip), %rdi
	leaq	v_B_flat(%rip), %rsi
	movabsq	$6364136223846793005, %rbx
	.p2align 4,,10
	.p2align 3
.L5728:
	movq	_vmath_rng_state(%rip), %rcx
	testq	%rcx, %rcx
	je	.L5715
.L5881:
	movq	_vmath_rng_inc(%rip), %r11
.L5716:
	movq	%rcx, %rax
	movq	%rcx, %r8
	movq	8(%rdi), %r10
	movq	$1, 48(%rsp)
	shrq	$18, %rax
	imulq	%rbx, %r8
	xorq	%rcx, %rax
	shrq	$59, %rcx
	shrq	$27, %rax
	rorl	%cl, %eax
	movl	(%rdi), %ecx
	addq	%r11, %r8
	vcvtsi2sdq	%rax, %xmm9, %xmm0
	vmulsd	%xmm8, %xmm0, %xmm0
	movq	%r8, _vmath_rng_state(%rip)
	leal	-11(%rcx), %r9d
	cmpl	$1, %r9d
	vfmadd132sd	%xmm7, %xmm6, %xmm0
	vmovq	%xmm0, %rax
	movq	%rax, %rdx
	movq	48(%rsp), %rax
	jbe	.L5762
	cmpl	$4, %ecx
	je	.L5762
	testq	%r8, %r8
	movq	v_N(%rip), %r14
	je	.L5878
.L5721:
	movq	%r8, %rax
	movq	%r8, %rcx
	movq	8(%rsi), %r10
	movq	$1, 64(%rsp)
	imulq	%rbx, %rax
	shrq	$59, %rcx
	addq	%r11, %rax
	movq	%rax, _vmath_rng_state(%rip)
	movq	%r8, %rax
	shrq	$18, %rax
	xorq	%r8, %rax
	shrq	$27, %rax
	rorl	%cl, %eax
	movl	(%rsi), %ecx
	vcvtsi2sdq	%rax, %xmm9, %xmm0
	vmulsd	%xmm8, %xmm0, %xmm0
	leal	-11(%rcx), %r8d
	cmpl	$1, %r8d
	vfmadd132sd	%xmm7, %xmm6, %xmm0
	vmovq	%xmm0, %rax
	movq	%rax, %rdx
	movq	64(%rsp), %rax
	jbe	.L5763
	cmpl	$4, %ecx
	je	.L5763
	addq	$1, %r13
	movq	v_N(%rip), %r14
	cmpq	%r15, %r13
	jne	.L5728
.L5876:
	addq	$1, %r12
	cmpq	%r12, 96(%rsp)
	movq	%r14, %r15
	jne	.L5729
.L5713:
	movq	176(%rsp), %rsi
	movq	80(%rsp), %rdi
	movq	%r15, 280(%rsp)
	leaq	240(%rsp), %r9
	movq	%r15, 264(%rsp)
	movq	160(%rsp), %r15
	vmovdqa	v_A_flat(%rip), %xmm3
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movq	$2, 272(%rsp)
	movq	$2, 256(%rsp)
	movq	%r15, %r8
	vmovdqa	%xmm3, 240(%rsp)
	call	struct_vlin_Types_Matrix
	movq	%r15, %r8
	movq	%rsi, %rdx
	movq	%rdi, %rcx
	movq	v_N(%rip), %rax
	vmovdqa	v_B_flat(%rip), %xmm5
	leaq	240(%rsp), %r9
	movq	$2, 272(%rsp)
	vmovdqu	288(%rsp), %xmm4
	movq	$2, 256(%rsp)
	movq	%rax, 280(%rsp)
	movq	%rax, 264(%rsp)
	vmovdqa	%xmm4, v_A(%rip)
	vmovdqa	%xmm5, 240(%rsp)
	call	struct_vlin_Types_Matrix
	cmpq	$0, v_CONFIG(%rip)
	vmovdqu	288(%rsp), %xmm1
	vmovdqa	%xmm1, v_B(%rip)
	jne	.L5738
	movq	v_ITERS(%rip), %r15
	testq	%r15, %r15
	jle	.L5732
	movq	176(%rsp), %r13
	movq	80(%rsp), %r12
	movl	$1, %ebx
	leaq	v_B(%rip), %rdi
	leaq	v_A(%rip), %rsi
	leaq	.LC160(%rip), %rbp
	jmp	.L5733
	.p2align 4,,10
	.p2align 3
.L5736:
	addq	$1, %rbx
	cmpq	%rbx, %r15
	jl	.L5738
.L5733:
	movq	8(%rdi), %rax
	movl	(%rsi), %edx
	movq	%r12, %rcx
	movq	%rax, 32(%rsp)
	movl	(%rdi), %r9d
	movq	8(%rsi), %r8
	call	vyne_blas_matmul.constprop.0.isra.0
	cmpq	%rbx, v_ITERS(%rip)
	movq	296(%rsp), %r14
	jne	.L5736
	xorl	%eax, %eax
	xorl	%edx, %edx
	cmpl	$6, 288(%rsp)
	movq	288(%rsp), %r10
	je	.L5879
.L5737:
	movq	%rdx, 280(%rsp)
	movq	%r12, %rcx
	movq	%r13, %rdx
	addq	$1, %rbx
	movq	%rax, 272(%rsp)
	call	vyne_to_string
	movq	160(%rsp), %r8
	movq	%r13, %rdx
	movq	%r12, %rcx
	vmovdqu	288(%rsp), %xmm1
	movl	$29, %r9d
	movq	$3, 272(%rsp)
	movq	%rbp, 280(%rsp)
	vmovdqa	%xmm1, 256(%rsp)
	call	vyne_binop
	movq	296(%rsp), %rdx
	movl	288(%rsp), %ecx
	call	vyne_out.isra.0
	cmpq	%rbx, %r15
	jge	.L5733
	.p2align 4,,10
	.p2align 3
.L5738:
	movq	v_CONFIG(%rip), %rbp
	cmpq	$1, %rbp
	je	.L5880
.L5732:
	movq	g_arena(%rip), %rbx
	testq	%rbx, %rbx
	je	.L5735
	.p2align 4,,10
	.p2align 3
.L5734:
	movq	%rbx, %rsi
	movq	24(%rbx), %rbx
	movq	(%rsi), %rcx
	call	free
	movq	%rsi, %rcx
	call	free
	testq	%rbx, %rbx
	jne	.L5734
.L5735:
	movq	g_commit_arena(%rip), %rbx
	movq	$0, g_arena(%rip)
	movq	$0, g_arena_cur(%rip)
	movq	$0, g_arena_end(%rip)
	testq	%rbx, %rbx
	movq	$0, 8+g_arena(%rip)
	je	.L5756
	.p2align 4,,10
	.p2align 3
.L5755:
	movq	%rbx, %rsi
	movq	24(%rbx), %rbx
	movq	(%rsi), %rcx
	call	free
	movq	%rsi, %rcx
	call	free
	testq	%rbx, %rbx
	jne	.L5755
.L5756:
	vmovaps	368(%rsp), %xmm6
	xorl	%eax, %eax
	vmovaps	384(%rsp), %xmm7
	movq	$0, g_commit_arena(%rip)
	vmovaps	400(%rsp), %xmm8
	vmovaps	416(%rsp), %xmm9
	movq	$0, 8+g_commit_arena(%rip)
	vmovaps	432(%rsp), %xmm10
	vmovaps	448(%rsp), %xmm11
	vmovaps	464(%rsp), %xmm12
	vmovaps	480(%rsp), %xmm13
	vmovaps	496(%rsp), %xmm14
	vmovaps	512(%rsp), %xmm15
	addq	$536, %rsp
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
.L5763:
	movq	%rax, 288(%rsp)
	movq	80(%rsp), %rax
	imulq	%r12, %r14
	movl	$2, %r8d
	movq	%rdx, 296(%rsp)
	movq	%r10, %rdx
	movq	%rax, 32(%rsp)
	leaq	(%r14,%r13), %r9
	addq	$1, %r13
	call	vyne_array_set.isra.0
	cmpq	%r15, %r13
	movq	v_N(%rip), %r14
	je	.L5876
	movq	_vmath_rng_state(%rip), %rcx
	testq	%rcx, %rcx
	jne	.L5881
.L5715:
	xorl	%ecx, %ecx
	call	_time64
	leaq	_vmath_rng_state(%rip), %rcx
	movq	%rbp, _vmath_rng_inc(%rip)
	movq	%rbp, %r11
	xorq	%rax, %rcx
	imulq	%rbx, %rcx
	addq	%rbp, %rcx
	jmp	.L5716
	.p2align 4,,10
	.p2align 3
.L5762:
	movq	%rax, 288(%rsp)
	movq	80(%rsp), %rax
	imulq	%r12, %r14
	movl	$2, %r8d
	movq	%rdx, 296(%rsp)
	movq	%r10, %rdx
	movq	%rax, 32(%rsp)
	leaq	(%r14,%r13), %r9
	call	vyne_array_set.isra.0
	movq	_vmath_rng_state(%rip), %r8
	movq	v_N(%rip), %r14
	testq	%r8, %r8
	jne	.L5721
.L5878:
	xorl	%ecx, %ecx
	call	_time64
	leaq	_vmath_rng_state(%rip), %r8
	movq	%rbp, _vmath_rng_inc(%rip)
	movq	%rbp, %r11
	xorq	%rax, %r8
	imulq	%rbx, %r8
	addq	%rbp, %r8
	jmp	.L5721
.L5880:
	movq	v_ITERS(%rip), %r10
	testq	%r10, %r10
	jle	.L5732
	movl	g_vmem_top(%rip), %r13d
	cmpl	$63, %r13d
	jg	.L5739
	movslq	%r13d, %rax
	movq	%r10, 208(%rsp)
	leal	1(%r13), %ebx
	leaq	v_B(%rip), %r15
	movq	%rax, %r11
	movl	%r13d, 48(%rsp)
	leaq	v_A(%rip), %rdi
	salq	$5, %r11
	movq	%rax, 64(%rsp)
	leaq	24+g_vmem_slots(%rip), %rax
	movl	%ebx, 192(%rsp)
	leaq	-24(%rax,%r11), %r14
	leaq	(%r11,%rax), %rsi
	movq	%r11, 224(%rsp)
	leaq	g_arena(%rip), %rbx
	.p2align 4,,10
	.p2align 3
.L5740:
	movl	192(%rsp), %eax
	movq	(%rbx), %rdx
	movl	%eax, g_vmem_top(%rip)
	movq	g_arena_cur(%rip), %rax
	testq	%rax, %rax
	je	.L5761
	testq	%rdx, %rdx
	je	.L5761
	subq	(%rdx), %rax
	vmovq	%rax, %xmm0
.L5741:
	movq	%rdx, (%r14)
	vpinsrq	$1, 8(%rbx), %xmm0, %xmm0
	leaq	8+g_vmem_slots(%rip), %rax
	movq	224(%rsp), %rdx
	movq	80(%rsp), %rcx
	vmovdqu	%xmm0, (%rax,%rdx)
	movq	8(%r15), %rax
	movl	(%rdi), %edx
	movl	$1, 24(%r14)
	movq	%rax, 32(%rsp)
	movl	(%r15), %r9d
	movq	8(%rdi), %r8
	call	vyne_blas_matmul.constprop.0.isra.0
	cmpq	%rbp, v_ITERS(%rip)
	movq	296(%rsp), %r12
	je	.L5882
.L5742:
	movq	64(%rsp), %rcx
	testq	%rcx, %rcx
	js	.L5744
	movslq	g_vmem_top(%rip), %rax
	cmpq	%rax, %rcx
	movq	%rax, %rdx
	jge	.L5744
	movl	24(%r14), %eax
	testl	%eax, %eax
	je	.L5744
	movq	(%rbx), %r12
	movq	8(%r14), %rax
	movq	$0, _vyne_blas_a_key(%rip)
	movq	$0, _vyne_blas_b_key(%rip)
	movq	(%r14), %r13
	testq	%r12, %r12
	movq	%rax, 144(%rsp)
	movq	16(%r14), %rcx
	je	.L5751
	cmpq	%r13, %r12
	je	.L5751
	movq	%rsi, 112(%rsp)
	movq	%r12, %rsi
	movq	%rcx, %r12
	movl	%edx, 96(%rsp)
	movq	%rdi, 128(%rsp)
	jmp	.L5746
	.p2align 4,,10
	.p2align 3
.L5883:
	testq	%rsi, %rsi
	je	.L5873
.L5746:
	movq	%rsi, %rdi
	movq	24(%rsi), %rsi
	movq	(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
	cmpq	%r13, %rsi
	movq	%rsi, (%rbx)
	jne	.L5883
.L5873:
	movl	96(%rsp), %edx
	movq	112(%rsp), %rsi
	movq	%r12, %rcx
	movq	128(%rsp), %rdi
.L5751:
	xorl	%r12d, %r12d
	testq	%r13, %r13
	je	.L5749
	movq	0(%r13), %rax
	movq	144(%rsp), %r12
	addq	%rax, %r12
	addq	16(%r13), %rax
	movq	%rax, %r13
.L5749:
	cmpl	%edx, 48(%rsp)
	movq	%r13, g_arena_end(%rip)
	movq	%r12, g_arena_cur(%rip)
	movq	%rcx, 8(%rbx)
	jge	.L5754
	subl	48(%rsp), %edx
	addq	64(%rsp), %rdx
	leaq	24+g_vmem_slots(%rip), %rax
	salq	$5, %rdx
	addq	%rax, %rdx
	movq	%rsi, %rax
	movq	%rdx, %rcx
	subq	%rsi, %rcx
	andl	$32, %ecx
	je	.L5753
	leaq	32(%rsi), %rax
	movl	$0, (%rsi)
	cmpq	%rax, %rdx
	je	.L5754
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L5753:
	movl	$0, (%rax)
	addq	$64, %rax
	movl	$0, -32(%rax)
	cmpq	%rax, %rdx
	jne	.L5753
.L5754:
	movl	48(%rsp), %eax
	addq	$1, %rbp
	cmpq	%rbp, 208(%rsp)
	movl	%eax, g_vmem_top(%rip)
	jge	.L5740
	jmp	.L5732
	.p2align 4,,10
	.p2align 3
.L5761:
	vpxor	%xmm0, %xmm0, %xmm0
	jmp	.L5741
	.p2align 4,,10
	.p2align 3
.L5882:
	xorl	%eax, %eax
	xorl	%edx, %edx
	cmpl	$6, 288(%rsp)
	movq	288(%rsp), %r8
	je	.L5884
.L5743:
	movq	176(%rsp), %r13
	movq	80(%rsp), %r12
	movq	%rdx, 280(%rsp)
	movq	%rax, 272(%rsp)
	movq	%r13, %rdx
	movq	%r12, %rcx
	call	vyne_to_string
	movq	160(%rsp), %r8
	movq	%r13, %rdx
	movq	%r12, %rcx
	vmovdqu	288(%rsp), %xmm2
	leaq	.LC160(%rip), %rax
	movl	$29, %r9d
	movq	$3, 272(%rsp)
	movq	%rax, 280(%rsp)
	vmovdqa	%xmm2, 256(%rsp)
	call	vyne_binop
	movq	296(%rsp), %rdx
	movl	288(%rsp), %ecx
	call	vyne_out.isra.0
	jmp	.L5742
.L5879:
	movl	$48, %ecx
	movq	%r10, 48(%rsp)
	movq	%r14, 56(%rsp)
	call	arena_alloc
	movq	48(%rsp), %r10
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	movl	$4294967295, %ecx
	movq	56(%rsp), %r11
	movq	%r8, 24(%rax)
	movq	%r14, %r8
	movq	%r10, %rdx
	salq	$32, %rcx
	movq	%r9, 40(%rax)
	leaq	.LC150(%rip), %r9
	andq	%rcx, %rdx
	movq	%r11, 8(%rax)
	movq	%r12, %rcx
	orq	$6, %rdx
	movq	$2, 16(%rax)
	movq	%rdx, (%rax)
	movl	$6, %edx
	movq	$2, 32(%rax)
	movq	%rax, 40(%rsp)
	movl	$3, 32(%rsp)
	call	vyne_struct_call.isra.0
	movq	288(%rsp), %rax
	movq	296(%rsp), %rdx
	jmp	.L5737
.L5884:
	movl	$48, %ecx
	movq	%r8, 96(%rsp)
	movq	%r12, 104(%rsp)
	call	arena_alloc
	movq	96(%rsp), %r8
	movl	$4294967295, %ecx
	movq	104(%rsp), %r9
	salq	$32, %rcx
	movq	$2, 16(%rax)
	movq	%r8, %rdx
	movq	%r9, 8(%rax)
	movq	%r12, %r8
	leaq	.LC150(%rip), %r9
	andq	%rcx, %rdx
	xorl	%ecx, %ecx
	movq	$2, 32(%rax)
	orq	$6, %rdx
	movq	%rcx, 40(%rax)
	movq	80(%rsp), %rcx
	movq	%rdx, (%rax)
	xorl	%edx, %edx
	movq	%rdx, 24(%rax)
	movl	$6, %edx
	movq	%rax, 40(%rsp)
	movl	$3, 32(%rsp)
	call	vyne_struct_call.isra.0
	movq	288(%rsp), %rax
	movq	296(%rsp), %rdx
	jmp	.L5743
.L5758:
	movq	%r9, %r15
	jmp	.L5713
.L5744:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	64(%rsp), %r8
	leaq	.LC162(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
.L5739:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$64, %r8d
	leaq	.LC161(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.globl	v_B
	.bss
	.align 16
v_B:
	.space 16
	.globl	v_A
	.align 16
v_A:
	.space 16
	.globl	v_B_flat
	.align 16
v_B_flat:
	.space 16
	.globl	v_A_flat
	.align 16
v_A_flat:
	.space 16
	.globl	v_CONFIG
	.align 8
v_CONFIG:
	.space 8
	.globl	v_ITERS
	.align 8
v_ITERS:
	.space 8
	.globl	v_N
	.align 8
v_N:
	.space 8
	.globl	v_BGBright_white
	.align 16
v_BGBright_white:
	.space 16
	.globl	v_BGBright_cyan
	.align 16
v_BGBright_cyan:
	.space 16
	.globl	v_BGBright_magenta
	.align 16
v_BGBright_magenta:
	.space 16
	.globl	v_BGBright_blue
	.align 16
v_BGBright_blue:
	.space 16
	.globl	v_BGBright_yellow
	.align 16
v_BGBright_yellow:
	.space 16
	.globl	v_BGBright_green
	.align 16
v_BGBright_green:
	.space 16
	.globl	v_BGBright_red
	.align 16
v_BGBright_red:
	.space 16
	.globl	v_BGBright_black
	.align 16
v_BGBright_black:
	.space 16
	.globl	v_BG_white
	.align 16
v_BG_white:
	.space 16
	.globl	v_BG_cyan
	.align 16
v_BG_cyan:
	.space 16
	.globl	v_BG_magenta
	.align 16
v_BG_magenta:
	.space 16
	.globl	v_BG_blue
	.align 16
v_BG_blue:
	.space 16
	.globl	v_BG_yellow
	.align 16
v_BG_yellow:
	.space 16
	.globl	v_BG_green
	.align 16
v_BG_green:
	.space 16
	.globl	v_BG_red
	.align 16
v_BG_red:
	.space 16
	.globl	v_BG_black
	.align 16
v_BG_black:
	.space 16
	.globl	v_Bright_white
	.align 16
v_Bright_white:
	.space 16
	.globl	v_Bright_cyan
	.align 16
v_Bright_cyan:
	.space 16
	.globl	v_Bright_magenta
	.align 16
v_Bright_magenta:
	.space 16
	.globl	v_Bright_blue
	.align 16
v_Bright_blue:
	.space 16
	.globl	v_Bright_yellow
	.align 16
v_Bright_yellow:
	.space 16
	.globl	v_Bright_green
	.align 16
v_Bright_green:
	.space 16
	.globl	v_Bright_red
	.align 16
v_Bright_red:
	.space 16
	.globl	v_Bright_black
	.align 16
v_Bright_black:
	.space 16
	.globl	v_Palette_gray
	.align 16
v_Palette_gray:
	.space 16
	.globl	v_Palette_white
	.align 16
v_Palette_white:
	.space 16
	.globl	v_Palette_cyan
	.align 16
v_Palette_cyan:
	.space 16
	.globl	v_Palette_magenta
	.align 16
v_Palette_magenta:
	.space 16
	.globl	v_Palette_blue
	.align 16
v_Palette_blue:
	.space 16
	.globl	v_Palette_yellow
	.align 16
v_Palette_yellow:
	.space 16
	.globl	v_Palette_green
	.align 16
v_Palette_green:
	.space 16
	.globl	v_Palette_red
	.align 16
v_Palette_red:
	.space 16
	.globl	v_Palette_black
	.align 16
v_Palette_black:
	.space 16
	.globl	v_STRIKE
	.align 16
v_STRIKE:
	.space 16
	.globl	v_HIDDEN
	.align 16
v_HIDDEN:
	.space 16
	.globl	v_REVERSE
	.align 16
v_REVERSE:
	.space 16
	.globl	v_BLINK
	.align 16
v_BLINK:
	.space 16
	.globl	v_UNDER
	.align 16
v_UNDER:
	.space 16
	.globl	v_ITALIC
	.align 16
v_ITALIC:
	.space 16
	.globl	v_DIM
	.align 16
v_DIM:
	.space 16
	.globl	v_BOLD
	.align 16
v_BOLD:
	.space 16
	.globl	v_RESET
	.align 16
v_RESET:
	.space 16
	.globl	v_ESC
	.align 16
v_ESC:
	.space 16
.lcomm _vmath_rng_inc,8,8
.lcomm _vmath_rng_state,8,8
.lcomm g_vmem_top,4,4
.lcomm g_vmem_slots,2048,32
.lcomm _vyne_blas_b_cache,24,16
.lcomm _vyne_blas_b_key,8,8
.lcomm _vyne_blas_a_cache,24,16
.lcomm _vyne_blas_a_key,8,8
.lcomm _vyne_char_pool_ready,4,4
.lcomm _vyne_char_pool,512,32
.lcomm g_method_count,4,4
.lcomm g_method_table,6144,32
.lcomm g_commit_arena,16,16
.lcomm g_arena_end,8,8
.lcomm g_arena_cur,8,8
.lcomm g_arena,16,16
	.section .rdata,"dr"
	.align 16
.LC2:
	.quad	24
	.quad	8388608
	.align 16
.LC3:
	.quad	32
	.quad	8388608
	.align 16
.LC4:
	.quad	16
	.quad	8388608
	.align 8
.LC5:
	.long	0
	.long	4
	.align 8
.LC29:
	.long	2
	.long	2
	.align 16
.LC30:
	.quad	0
	.quad	4
	.align 8
.LC31:
	.long	11
	.long	0
	.align 8
.LC32:
	.long	0
	.long	1072693248
	.align 32
.LC37:
	.quad	0
	.quad	1
	.quad	2
	.quad	3
	.set	.LC39,.LC30+8
	.align 2
.LC40:
	.byte	44
	.byte	32
	.align 2
.LC41:
	.byte	34
	.byte	58
	.align 2
.LC43:
	.byte	58
	.byte	32
	.align 8
.LC57:
	.long	6
	.long	6
	.align 8
.LC73:
	.long	0
	.long	1039138816
	.align 8
.LC74:
	.long	0
	.long	1075314688
	.align 8
.LC75:
	.long	0
	.long	-1075838976
	.align 16
.LC86:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC158:
	.long	0
	.long	1073741824
	.align 8
.LC159:
	.long	0
	.long	-1074790400
	.align 8
.LC163:
	.quad	.LC70
	.align 8
.LC164:
	.quad	.LC33
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 15.2.0"
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	exit;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	atof;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	sprintf;	.scl	2;	.type	32;	.endef
	.def	strchr;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	fflush;	.scl	2;	.type	32;	.endef
	.def	strcmp;	.scl	2;	.type	32;	.endef
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	memset;	.scl	2;	.type	32;	.endef
	.def	cblas_dgemm;	.scl	2;	.type	32;	.endef
	.def	strcpy;	.scl	2;	.type	32;	.endef
	.def	snprintf;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
	.def	pow;	.scl	2;	.type	32;	.endef
	.def	fmod;	.scl	2;	.type	32;	.endef
	.def	sqrt;	.scl	2;	.type	32;	.endef
	.def	exp;	.scl	2;	.type	32;	.endef
	.def	tanh;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
