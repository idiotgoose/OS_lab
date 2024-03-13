# TODO: This is lab1.2
/* Protected Mode Hello World */
.code16

.global start
start:
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss
######## TODO:关闭中断
	cli
####################

	# 启动A20总线
	inb $0x92, %al 
	orb $0x02, %al
	outb %al, $0x92

	# 加载GDTR
	data32 addr32 lgdt gdtDesc # loading gdtr, data32, addr32

########### TODO：设置CR0的PE位（第0位）为1
	data32 mov %cr0, %eax
	orb $0x1, %al
	data32 mov %eax, %cr0
######################

	# 长跳转切换至保护模式
	data32 ljmp $0x08, $start32 # reload code segment selector and ljmp to start32, data32

.code32
start32:
	movw $0x10, %ax # setting data segment selector
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %ss
	movw $0x18, %ax # setting graphics data segment selector
	movw %ax, %gs
	
	movl $0x8000, %eax # setting esp
	movl %eax, %esp
########### TODO:输出Hello World
	movl $0, %eax
.L1:
	movl %eax,%ebx
	shl $1,%ebx
	movl %ebx,%ecx
	movl %ebx,%edx
	addl $0xb8000,%ecx
	addl $message,%edx
	movw (%edx), %bx
	movw %bx, (%ecx)
	incl %eax
	cmpl $14,%eax
	jbe .L1


loop32:
	jmp loop32

message:
	# .string "Hello, World!\n\0"
	.byte 0x48,0x0f,0x65,0x0f,0x6c,0x0f,0x6c,0x0f,0x6f,0x0f,0x2c,0x0f,0x20,0x0f,0x57,0x0f,0x6f,0x0f,0x72,0x0f,0x6c,0x0f,0x64,0x0f,0x21,0x0f,0x00,0x0f



.p2align 2
gdt: # 8 bytes for each table entry, at least 1 entry
	# .word limit[15:0],base[15:0]
	# .byte base[23:16],(0x90|(type)),(0xc0|(limit[19:16])),base[31:24]
	# GDT第一个表项为空
	.word 0,0
	.byte 0,0,0,0

########## TODO：code segment entry
	.word  0xffff,0
	.byte 0,0x9a,0xcf,0

########## TODO：data segment entry
	.word  0xffff,0
	.byte 0,0x92,0xcf,0

########### TODO：graphics segment entry
	.word   0xffff,0x8000
	.byte 0xb,0x92,0xcf,0

gdtDesc: 
	.word (gdtDesc - gdt -1) 
	.long gdt 

