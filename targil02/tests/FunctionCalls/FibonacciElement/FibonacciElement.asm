//initialization the program
@256
D=A
@SP
M=D


//push the return addess
@Sys.init.ReturnAddress0
D=A
@SP
A=M
M=D
@SP
M=M+1
//save LCL of the calling function
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
//save ARG of the calling function
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THIS of the calling function
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THAT of the calling function
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
//Change ARG to called function
@0
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
//Change LCL to called function
@SP
D=M
@LCL
M=D
//Goto function call
@Sys.init
0;JMP
//Return address label
(Sys.init.ReturnAddress0)

//function command
//label of function
(Main.fibonacci)
//initialization local variables
@0
D=A
@Main.fibonacci.End
D;JEQ
(Main.fibonacci.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Main.fibonacci.Loop
D=D-1
D;JNE
(Main.fibonacci.End)

//push command
@0
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//push command
@2
D=A
@SP
A=M
M=D
@SP
M=M+1

//lt command
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUE0
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSE0
0;JMP
(IF_TRUE0)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSE0)
@SP
M=M-1

//if goto c command
@SP
M=M-1
A=M
D=M
@Main.vm.IF_TRUE
D;JNE
//goto c command
@Main.vm.IF_FALSE
0;JMP
//label c command
(Main.vm.IF_TRUE)

//push command
@0
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//return command
//Save the return address in R14
@LCL
D=M
@5
A=D-A
D=M
@13
M=D
//Save the result in top of stack
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
//Restore calling SP
@ARG
D=M
@SP
M=D+1
//Restore calling THAT
@LCL
M=M-1
A=M
D=M
@THAT
M=D
//Restore calling THIS
@LCL
M=M-1
A=M
D=M
@THIS
M=D
//Restore calling ARG
@LCL
M=M-1
A=M
D=M
@ARG
M=D
//Restore calling LCL
@LCL
M=M-1
A=M
D=M
@LCL
M=D
//Jump to return address(in R14)
@13
A=M
0;JMP

//label c command
(Main.vm.IF_FALSE)

//push command
@0
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//push command
@2
D=A
@SP
A=M
M=D
@SP
M=M+1

//sub command
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1

//call command
//push the return addess
@Main.fibonacci.ReturnAddress1
D=A
@SP
A=M
M=D
@SP
M=M+1
//save LCL of the calling function
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
//save ARG of the calling function
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THIS of the calling function
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THAT of the calling function
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
//Change ARG to called function
@1
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
//Change LCL to called function
@SP
D=M
@LCL
M=D
//Goto function call
@Main.fibonacci
0;JMP
//Return address label
(Main.fibonacci.ReturnAddress1)

//push command
@0
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//push command
@1
D=A
@SP
A=M
M=D
@SP
M=M+1

//sub command
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1

//call command
//push the return addess
@Main.fibonacci.ReturnAddress2
D=A
@SP
A=M
M=D
@SP
M=M+1
//save LCL of the calling function
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
//save ARG of the calling function
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THIS of the calling function
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THAT of the calling function
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
//Change ARG to called function
@1
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
//Change LCL to called function
@SP
D=M
@LCL
M=D
//Goto function call
@Main.fibonacci
0;JMP
//Return address label
(Main.fibonacci.ReturnAddress2)

//add command
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1

//return command
//Save the return address in R14
@LCL
D=M
@5
A=D-A
D=M
@13
M=D
//Save the result in top of stack
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D
//Restore calling SP
@ARG
D=M
@SP
M=D+1
//Restore calling THAT
@LCL
M=M-1
A=M
D=M
@THAT
M=D
//Restore calling THIS
@LCL
M=M-1
A=M
D=M
@THIS
M=D
//Restore calling ARG
@LCL
M=M-1
A=M
D=M
@ARG
M=D
//Restore calling LCL
@LCL
M=M-1
A=M
D=M
@LCL
M=D
//Jump to return address(in R14)
@13
A=M
0;JMP

//function command
//label of function
(Sys.init)
//initialization local variables
@0
D=A
@Sys.init.End
D;JEQ
(Sys.init.Loop)
@SP
A=M
M=0
@SP
M=M+1
@Sys.init.Loop
D=D-1
D;JNE
(Sys.init.End)

//push command
@4
D=A
@SP
A=M
M=D
@SP
M=M+1

//call command
//push the return addess
@Main.fibonacci.ReturnAddress3
D=A
@SP
A=M
M=D
@SP
M=M+1
//save LCL of the calling function
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
//save ARG of the calling function
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THIS of the calling function
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
//save THAT of the calling function
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
//Change ARG to called function
@1
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
//Change LCL to called function
@SP
D=M
@LCL
M=D
//Goto function call
@Main.fibonacci
0;JMP
//Return address label
(Main.fibonacci.ReturnAddress3)

//label c command
(Sys.vm.WHILE)

//goto c command
@Sys.vm.WHILE
0;JMP
