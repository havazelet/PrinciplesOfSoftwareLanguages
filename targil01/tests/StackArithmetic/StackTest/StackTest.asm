//push command
@17
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@17
D=A
@SP
A=M
M=D
@SP
M=M+1

//eq command
@SP
A=M-1
D=M
A=A-1
D=D-M
@IF_TRUE0
D;JEQ
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

//push command
@892
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@891
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
@IF_TRUE1
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSE1
0;JMP
(IF_TRUE1)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSE1)
@SP
M=M-1

//push command
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1

//gt command
@SP
A=M-1
D=M
A=A-1
D=M-D
@IF_TRUE2 
D;JGT
D=0
@SP
A=M-1
A=A-1
M=D
@IF_FALSE2
0;JMP
(IF_TRUE2)
D=-1
@SP
A=M-1
A=A-1
M=D
(IF_FALSE2)
@SP
M=M-1

//push command
@56
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@31
D=A
@SP
A=M
M=D
@SP
M=M+1

//push command
@53
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

//push command
@112
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

//neg command
@SP
A=M-1
M=-M

//and command
@SP
A=M-1
D=M
A=A-1
M=D&M
@SP
M=M-1

//push command
@82
D=A
@SP
A=M
M=D
@SP
M=M+1

//or command
@SP
A=M-1
D=M
A=A-1
M=D|M
@SP
M=M-1

