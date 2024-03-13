# TODO: This is lab1.1
/* Real Mode Hello World */
.code16

.global start
start:
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss
	movw $0x7d00, %ax
	movw %ax, %sp # setting stack pointer to 0x7d00
############# TODO:通过中断输出Hello World
	movw $message, %ax
	movw %ax, %bp # set %bp to str_addr 
	movw $13, %cx # mov the size to print into %cx
	movw $0x1301, %ax
	movw $0x000c, %bx
	movw $0x0000, %dx
	int $0x10	
###########################

loop:
	jmp loop

message:
	.string "Hello, World!\n\0"
