import os 
from libc.stdlib cimport malloc, free
from libc.string cimport strcpy, strlen, strcat, strcmp
from libc.stdio cimport sprintf


cdef int LABEL_COUNTER = 0
cdef int FUNC_COUNTER = 0

cdef char* add():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=D+M\n@SP\nM=M-1\n\n"
    
cdef char* sub():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=M-D\n@SP\nM=M-1\n\n"
    
cdef char* neg():
    return "@SP\nA=M-1\nM=-M\n\n" 
 
cdef char* _and():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=D&M\n@SP\nM=M-1\n\n" 
    
cdef char* _or():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=D|M\n@SP\nM=M-1\n\n"
    
cdef char* _not():
    return "@SP\nA=M-1\nM=!M\n\n" 
    
  
cdef char* eq():
    global LABEL_COUNTER
    cdef char* append = <char *>malloc(10)
    cdef char* result = <char *>malloc(150)
    strcpy(result, "@SP\nA=M-1\nD=M\nA=A-1\nD=D-M\n@IF_TRUE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, "\nD;JEQ\nD=0\n@SP\nA=M-1\nA=A-1\nM=D\n@IF_FALSE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, "\n0;JMP\n(IF_TRUE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, ")\nD=-1\n@SP\nA=M-1\nA=A-1\nM=D\n(IF_FALSE")  
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, ")\n@SP\nM=M-1\n\n")  
    free(append)
    free(result)
    LABEL_COUNTER+=1
    return result
    

cdef char* gt(): 
    global LABEL_COUNTER
    cdef char* append = <char *>malloc(10)
    cdef char* result = <char *>malloc(150)
    strcpy(result, "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@IF_TRUE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, " \nD;JGT\nD=0\n@SP\nA=M-1\nA=A-1\nM=D\n@IF_FALSE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, "\n0;JMP\n(IF_TRUE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, ")\nD=-1\n@SP\nA=M-1\nA=A-1\nM=D\n(IF_FALSE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, ")\n@SP\nM=M-1\n\n")
    LABEL_COUNTER+=1
    free(append)
    free(result)
    return result  
    
    
cdef char* lt():
    global LABEL_COUNTER
    cdef char* append = <char *>malloc(10)
    cdef char* result = <char *>malloc(150)
    strcpy(result, "@SP\nA=M-1\nD=M\nA=A-1\nD=M-D\n@IF_TRUE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, "\nD;JLT\nD=0\n@SP\nA=M-1\nA=A-1\nM=D\n@IF_FALSE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, "\n0;JMP\n(IF_TRUE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, ")\nD=-1\n@SP\nA=M-1\nA=A-1\nM=D\n(IF_FALSE")
    sprintf(append,"%d",LABEL_COUNTER)
    strcat(result, append)
    strcat(result, ")\n@SP\nM=M-1\n\n")
    LABEL_COUNTER+=1
    free(append)
    free(result)
    return result        
            
              
    
cdef char* push(char* segment, char* value, char* fileName):  
    cdef char* result = <char *>malloc(200)
    if not strcmp(segment, 'constant'):
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")
    
    if not strcmp(segment, 'local'):
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@LCL\nA=M+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")
        
    if not strcmp(segment, 'argument'):
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@ARG\nA=M+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")  

    if not strcmp(segment, 'this'):
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@THIS\nA=M+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")
        
    if not strcmp(segment, 'that'):
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@THAT\nA=M+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")  
        
    if not strcmp(segment, 'temp'): 
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@5\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")   
        
    if not strcmp(segment, 'static'):
        strcpy(result, "@")
        strcat(result, fileName)
        strcat(result, ".")
        strcat(result, value)
        strcat(result, "\nD=A\n@16\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")   
    
    if not strcmp(segment, 'pointer'): 
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@3\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n") 

    return result
    
    
    
cdef char* pop(char* segment, char* value, char* fileName):  
    cdef char* result = <char *>malloc(200)
   
    if not strcmp(segment, 'local'):
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@LCL\nD=M+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")
        
    if not strcmp(segment, 'argument'):
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@ARG\nD=M+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")  
        
    if not strcmp(segment, 'this'):
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@THIS\nD=M+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")
        
    if not strcmp(segment, 'that'):
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@THAT\nD=M+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")  
        
    if not strcmp(segment, 'temp'): 
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@5\nD=A+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")   
        
    if not strcmp(segment, 'static'): 
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, fileName)
        strcat(result, ".")
        strcat(result, value)
        strcat(result, "\nD=A\n@16\nD=A+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")   
    
    if not strcmp(segment, 'pointer'): 
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@3\nD=A+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n") 

    return result 


#---------------fanction of targil 2

cdef char* call(char* funcName, char* numArg):
    global FUNC_COUNTER
    cdef char* result = <char *>malloc(1000)
    cdef char* append1 = <char *>malloc(100)
    
    strcpy(result, "//push the return addess\n@")
    strcat(result, funcName)
    strcat(result, ".ReturnAddress")
    sprintf(append1 ,"%d",FUNC_COUNTER)
    strcat(result, append1)
    strcat(result, "\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")   
    strcat(result, "//save LCL of the calling function\n@LCL\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
    strcat(result, "//save ARG of the calling function\n@ARG\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
    strcat(result, "//save THIS of the calling function\n@THIS\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
    strcat(result, "//save THAT of the calling function\n@THAT\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n")
    strcat(result, "//Change ARG to called function\n@")
    strcat(result, numArg)
    strcat(result, "\nD=A\n@5\nD=D+A\n@SP\nD=M-D\n@ARG\nM=D\n//Change LCL to called function\n@SP\nD=M\n@LCL\nM=D\n//Goto function call\n@")
    strcat(result, funcName)     
    strcat(result, "\n0;JMP\n//Return address label\n(")
    strcat(result, funcName)
    strcat(result,".ReturnAddress")
    sprintf(append1 ,"%d",FUNC_COUNTER)    
    strcat(result, append1)
    strcat(result,")\n\n")  
    
    FUNC_COUNTER+=1
    free(append1)
    free(result)
    return result 



cdef char* function(char* funcName, char* numVar):
    cdef char* result = <char *>malloc(1000)

    strcpy(result, "//label of function\n(")
    strcat(result, funcName)  
    strcat(result, ")\n//initialization local variables\n@")
    strcat(result, numVar)
    strcat(result, "\nD=A\n@")
    strcat(result, funcName)
    strcat(result, ".End\nD;JEQ\n(")
    strcat(result, funcName) 
    strcat(result, ".Loop)\n")
    strcat(result, "@SP\nA=M\nM=0\n@SP\nM=M+1\n@")
    strcat(result, funcName) 
    strcat(result, ".Loop\nD=D-1\nD;JNE\n(")
    strcat(result, funcName)
    strcat(result, ".End)\n\n")
    
    free(result)
    return result



cdef char* _return():
    cdef char* result = <char *>malloc(1000)
    strcpy(result, "//Save the return address in R14\n@LCL\nD=M\n@5\nA=D-A\nD=M\n@13\nM=D\n")
    strcat(result, "//Save the result in top of stack\n@SP\nM=M-1\nA=M\nD=M\n@ARG\nA=M\nM=D\n")
    strcat(result,"//Restore calling SP\n@ARG\nD=M\n@SP\nM=D+1\n")
    strcat(result,"//Restore calling THAT\n@LCL\nM=M-1\nA=M\nD=M\n@THAT\nM=D\n")    
    strcat(result,"//Restore calling THIS\n@LCL\nM=M-1\nA=M\nD=M\n@THIS\nM=D\n")   
    strcat(result,"//Restore calling ARG\n@LCL\nM=M-1\nA=M\nD=M\n@ARG\nM=D\n")     
    strcat(result,"//Restore calling LCL\n@LCL\nM=M-1\nA=M\nD=M\n@LCL\nM=D\n")     
    strcat(result,"//Jump to return address(in R14)\n@13\nA=M\n0;JMP\n\n")
    
    free(result)
    return result


cdef char* label(char* labelName ,char* fileName ):
    cdef char* result = <char *>malloc(200)
    
    strcpy(result, "(")
    strcat(result, fileName)
    strcat(result, ".")
    strcat(result, labelName)
    strcat(result, ")\n\n")
    
    free(result)
    return result



cdef char* goto(char* labelName ,char* fileName):
    cdef char* result = <char *>malloc(200)
    
    strcpy(result, "@")
    strcat(result, fileName)
    strcat(result, ".")
    strcat(result, labelName)
    strcat(result, "\n0;JMP\n")
    
    free(result)
    return result



cdef char* if_goto(char* labelName ,char* fileName ):
    cdef char* result = <char *>malloc(100)
    
    strcpy(result, "@SP\nM=M-1\nA=M\nD=M\n")
    strcat(result, "@")
    strcat(result, fileName)
    strcat(result, ".")
    strcat(result, labelName)
    strcat(result, "\nD;JNE\n")
    
    free(result)
    return result





   
#------------------main------------------        
def compile(path): 

    global LABEL_COUNTER
    global FUNC_COUNTER
    FUNC_COUNTER = 0
    LABEL_COUNTER = 0
    
    files_list=[f for f in os.listdir(path) if os.path.splitext(f)[-1].lower() == ".vm"]
    folder_name = os.path.basename(path)
    f_asm = open(path + "\\" + folder_name +  ".asm","w")   


    if(len(files_list)>1):
        print("init")
        f_asm.write("//initialization the program\n@256\nD=A\n@SP\nM=D\n\n\n")
        f_asm.write(call("Sys.init","0").decode("utf-8"))
         
    print("Start compilation...")
   
   
    #parsing and compilation
    for file in files_list:
        print("Parse file " + (str)(file))
        f_vm=open(path+"\\"+ file, "r")
        for entry in f_vm:
            if entry != "\n":
                s=entry.split()
                cmd=s[0]
                if cmd == 'add':
                    f_asm.write("//add command\n")
                    f_asm.write(add().decode("utf-8"))    
                if cmd == 'sub':
                    f_asm.write("//sub command\n")
                    f_asm.write(sub().decode("utf-8"))
                if cmd == 'neg':
                    f_asm.write("//neg command\n")
                    f_asm.write(neg().decode("utf-8"))
                if cmd == 'eq':
                    f_asm.write("//eq command\n")
                    f_asm.write(eq().decode("utf-8"))
                if cmd == 'gt':
                    f_asm.write("//gt command\n")
                    f_asm.write(gt().decode("utf-8"))
                if cmd == 'lt':
                    f_asm.write("//lt command\n")
                    f_asm.write(lt().decode("utf-8"))
                if cmd == 'and':
                    f_asm.write("//and command\n")
                    f_asm.write(_and().decode("utf-8"))
                if cmd == 'or':
                    f_asm.write("//or command\n")
                    f_asm.write(_or().decode("utf-8"))
                if cmd == 'not': 
                    f_asm.write("//not command\n")
                    f_asm.write(_not().decode("utf-8"))  
                if cmd == 'push':                  
                    f_asm.write("//push command\n")
                    temp_str1 = s[1].encode("utf-8")
                    temp_str2 = s[2].encode("utf-8")
                    f_asm.write(push(temp_str1,temp_str2, file.encode("utf-8")).decode("utf-8"))
                if cmd == 'pop':                  
                    f_asm.write("//pop command\n")
                    temp_str1 = s[1].encode("utf-8")
                    temp_str2 = s[2].encode("utf-8")
                    f_asm.write(pop(temp_str1,temp_str2, file.encode("utf-8")).decode("utf-8"))
                if cmd == 'call':
                    f_asm.write("//call command\n")
                    temp_str1 = s[1].encode("utf-8")
                    temp_str2 = s[2].encode("utf-8")
                    f_asm.write(call(temp_str1,temp_str2).decode("utf-8"))
                if cmd == 'function':
                    f_asm.write("//function command\n")
                    temp_str1 = s[1].encode("utf-8")
                    temp_str2 = s[2].encode("utf-8")
                    f_asm.write(function(temp_str1,temp_str2).decode("utf-8"))  
                if cmd == 'return':
                    f_asm.write("//return command\n")
                    f_asm.write(_return().decode("utf-8"))     
                if cmd == 'label':
                    f_asm.write("//label c command\n")
                    temp_str1 = s[1].encode("utf-8")
                    f_asm.write(label(temp_str1,file.encode("utf-8")).decode("utf-8"))
                if cmd == 'goto':
                    f_asm.write("//goto c command\n")
                    temp_str1 = s[1].encode("utf-8")
                    f_asm.write(goto(temp_str1, file.encode("utf-8")).decode("utf-8"))
                if cmd == 'if-goto':
                    f_asm.write("//if goto c command\n")
                    temp_str1 = s[1].encode("utf-8")
                    f_asm.write(if_goto(temp_str1, file.encode("utf-8")).decode("utf-8"))
                   
    print("end")              
    f_asm.close()
    
    
    