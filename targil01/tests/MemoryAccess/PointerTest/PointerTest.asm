//push command
@3030
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
@3040
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
@32
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
@46
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
@3
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

//push command
@2
D=A
@THIS
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

