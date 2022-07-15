; I have abided by the UNCG Academic Integrity Policy
; Author: Christopher Silva Barnbeck
; Date: 06/08/2022
; This program will prompt a user for the value of n and m and use a procedure to return the greatest common denominator where n and m are greater than 0.

INCLUDE io.h                            ; header file for input/output
.586
.MODEL FLAT
.STACK 4096

.DATA

n		    DWORD   ?
m           DWORD   ?
prompt1		BYTE    "Enter value for n", 0
prompt2     BYTE    "Enter value for m", 0
string		BYTE    40 DUP (?)
resultLbl	BYTE	"The GCD is", 0
invalid     BYTE    "Invalid procedure arguments!", 0
solution	DWORD   11 DUP (?), 0

.CODE
_MainProc PROC
        input	prompt1, string, 40		; read ASCII characters
        atod    string					; convert to integer
        mov     n, eax			        ; store in memory
        push    n                       ; push n to stack

        input	prompt2, string, 40		; read ASCII characters
        atod    string					; convert to integer
        mov     ebx, eax                ; store in ebx
        mov     m, eax			        ; store in memory
        push    m                       ; push m to stack

        mov     eax, n                  ; reset eax to n
        cmp     eax, 0                  ; begin sanity check on n
        jle     endWhile                ; less than or equal to 0 throws error
        cmp     ebx, 0                  ; sanity check on m
        jle     endWhile                ; less than or equal to 0 throws error
      

        call    gcd                     ; call gcd
        dtoa    solution, eax           ; Convert to ASCII 
        output  resultLbl, solution     ; output label and solution
        add     esp, 8                  ; remove parameters
        mov     eax, 0                  ; exit with return code 0
        ret
endWhile:
        output  invalid, solution       ; invalid solution error
        add     esp, 8                  ; remove parameters
        mov     eax, 0                  ; exit with return code 0
        ret

_MainProc ENDP

; Finds greatest common denominator using Euclid's algorithm
; int gcd(int m, int n)
gcd PROC
        push    ebp                     ; save ebp
        mov     ebp, esp                ; establish stack frame
        push    ebx                     ; save ebx
        push    edx                     ; save edx
        
        mov     eax, [ebp + 8]          ; n in eax
        mov     ebx, [ebp + 12]         ; m in ebx

checkSwap:
        cmp     eax, ebx                ; check to see if values are sorted
        jb      swap                    ; jump to swap if n < m

ngcd:
        mov     edx, 0                  ; prep for division
        div     DWORD PTR ebx           ; divide by m
        cmp     edx, 0                  ; compare remainder with 0
        je      endLoop                 ; jump when remainder 0, breaks loop
        mov     eax, ebx                ; m to n
        mov     ebx, edx                ; remainder to m
        jmp     checkSwap               ; repeat loop

swap:
        xchg    eax, ebx                ; swap eax and ebx
        jmp     checkSwap

endLoop:
        mov     eax, ebx                ; final m value becomes solution, move to eax
        pop     edx                     ; exit code
        pop     ebx                     ; 
        mov     esp, ebp                ; assurance for the correct return value :-)
        pop     ebp                     ; restore ebp..now we are sure ESP points to return address
    
        ret
gcd ENDP

END										; end of source code

