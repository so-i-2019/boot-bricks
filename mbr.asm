;; Copyright (c) <2019> - <Fernando Gorgulho Fayet> <fer.fayet@usp.br> - <Tiago Marino Silva> <tmsilva11@usp.br>
;;
;; This is free software and distributed under GNU GPL vr.3. Please 
;; refer to the companion file LICENSING or to the online documentation
;; at https://www.gnu.org/licenses/gpl-3.0.txt for further information.
	
	
	org 0x7c00		; Our load address

	mov ah, 0xe		; Configure BIOS teletype mode

	mov bx, 0		; May be 0 because org directive.

	jmp main

	;; STRINGS ESTÁTICAS
	start: db "Quiz++", 0xd, 0xa, 0x0

	firQ: db "How many Bytes does a Bootloader have?", 0xd, 0xa, 0x0
	firA: db "1)100  2)1024  3)8  4)512", 0xd, 0xa, 0x0

	secQ: db "What was Einstens' dog name?", 0xd, 0xa, 0x0
	secA: db "1)Rex  2)It's relative  3)Doggo  4)Liam", 0xd, 0xa, 0x0

	thiQ: db "Who invented the computer?", 0xd, 0xa, 0x0
	thiA: db "1)James  2)Ballen Touring  3)Alan Turing  4)Truing Allen", 0xd, 0xa, 0x0

	fouQ: db "Which is the best OS?", 0xd, 0xa, 0x0
	fouA: db "1)Linux  2)Windows  3)Mac OS  4)Brick OS", 0xd, 0xa, 0x0

	wrongTxt: db "Wrong", 0xd, 0xa, 0x0
	rightTxt: db "Right", 0xd, 0xa, 0x0

main:
	mov bx, start
    call printString    ; Prints intro string

	mov bx, firQ		;; Print 1a pergunta
    call printString
	mov bx, firA
    call printString

	call scanNumber		;; le 1a resposta
	mov dx, 4
	call checkAnwser

	mov bx, secQ		;; Print 2a pergunta
    call printString
	mov bx, secA
    call printString

	call scanNumber		;; le 2a resposta
	mov dx, 2
	call checkAnwser

	mov bx, thiQ		;; Print 3a pergunta
    call printString
	mov bx, thiA
    call printString

	call scanNumber		;; le 3a resposta
	mov dx, 3
	call checkAnwser

	mov bx, fouQ		;; Print 4a pergunta
    call printString
	mov bx, fouA
    call printString

	call scanNumber		;; le 4a resposta
	mov dx, 4
	call checkAnwser

	jmp endAll

right:
	mov bx, rightTxt
    call printString    ;; Print resposta correta

	ret

wrong:
	mov bx, wrongTxt
    call printString    ;; Print resposta errada

	ret

checkAnwser:

	cmp bx, dx			;; checa a resposta dada (bx) com a correta (dx)
	je right
	jmp wrong

;; PRINT STRING  ------------------------------------------------------------
;; --------------------------------------------------------------------------
;; imprime na tela a string localizada no endereço de bx
printString:
    push bx
    push cx

    jmp nullLoop
    ; bx is the address register
    ; cx is the char register

nullLoop:
    mov cl, [bx]
    cmp cl, 0x0
    je endPrintString

    call printChar
    add bx, 0x1
    jmp nullLoop

endPrintString:
    pop cx
    pop bx
    ret


printChar:
    push ax

    ; Sets arguments for BIOS interrupt
    mov ah, 0x0e
    mov al, cl
    int 0x10

    pop ax
    ret

;; SCAN NUMBER  ----------------------------------------------------------------
;; -----------------------------------------------------------------------------
;; recebe um char do teclado, converte em int e coloca em bx
scanNumber:
    push ax
    push cx
    mov bx, 0

    mov ah, 0x0
    int 0x16    ; Le char

    movzx dx, al ;; converte em int 
    sub dx, '0' ; 

    imul bx, 0xA

    add bx, dx  

    pop cx
    pop ax

    ret

;; TERMINATE BOOT SEQUENCE ----------------------------------------------------
;; ---------------------------------------------------------------------------
endAll:

	times 510 - ($-$$) db 0	; Pad with zeros
	dw 0xaa55		; Boot signature