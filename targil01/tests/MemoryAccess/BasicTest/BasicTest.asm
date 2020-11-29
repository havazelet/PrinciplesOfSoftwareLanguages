//push command
@10
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
@LCL
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
@21
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@22
D=A
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@2
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

//pop command
@SP
M=M-1
@1
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

//push command
@36
D=A
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@6
D=A
@THIS
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
@42
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@45
D=A
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@5
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
@510
D=A
@SP
A=M
M=D
@SP
M=M+1

//pop command
@SP
M=M-1
@6
D=A
@5
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
@LCL
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//push command
@5
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

//sub command
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1

//push command
@6
D=A
@THIS
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1

//push command
@6
D=A
@THIS
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

//sub command
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1

//push command
@6
D=A
@5
A=A+D
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

