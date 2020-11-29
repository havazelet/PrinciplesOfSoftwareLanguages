//push command
@1
D=A
@ARG
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@1
D=A
@3
D=A+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

//push command
@0
D=A
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@0
D=A
@THAT
D=M+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

//push command
@1
D=A
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@1
D=A
@THAT
D=M+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

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

//pop command
@SP
M=M-1
@0
D=A
@ARG
D=M+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

//label c command
(FibonacciSeries.vm.MAIN_LOOP_START)

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

//if goto c command
@SP
M=M-1
A=M
D=M
@FibonacciSeries.vm.COMPUTE_ELEMENT
D;JNE
//goto c command
@FibonacciSeries.vm.END_PROGRAM
0;JMP
//label c command
(FibonacciSeries.vm.COMPUTE_ELEMENT)

//push command
@0
D=A
@THAT
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
@THAT
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//add command
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1

//pop command
@SP
M=M-1
@2
D=A
@THAT
D=M+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

//push command
@1
D=A
@3
A=A+D
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

//add command
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1

//pop command
@SP
M=M-1
@1
D=A
@3
D=A+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

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

//pop command
@SP
M=M-1
@0
D=A
@ARG
D=M+D
@13
M=D
@SP
A=M
D=M
@13
A=M
M=D

//goto c command
@FibonacciSeries.vm.MAIN_LOOP_START
0;JMP
//label c command
(FibonacciSeries.vm.END_PROGRAM)

