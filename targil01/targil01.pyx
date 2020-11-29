import os 
from libc.stdlib cimport malloc, free
from libc.string cimport strcpy, strlen, strcat, strcmp
from libc.stdio cimport sprintf

cdef int LABEL_COUNTER = 0

cdef char* add():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=D+M\n@SP\nM=M-1\n\n"
    
cdef char* sub():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=M-D\n@SP\nM=M-1\n\n"
    
cdef char* neg():
    return "@SP\nA=M-1\nM=-M\n\n" 
 
#FIX STATIC!!!!!

  
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
            
            

cdef char* _and():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=D&M\n@SP\nM=M-1\n\n" 
    
cdef char* _or():
    return "@SP\nA=M-1\nD=M\nA=A-1\nM=D|M\n@SP\nM=M-1\n\n"
    
cdef char* _not():
    return "@SP\nA=M-1\nM=!M\n@SP\nM=M-1\n\n"   
    
    
cdef char* push(char* segment, char* value):  
    cdef char* result = <char *>malloc(80)
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
        strcat(result, value)
        strcat(result, "\nD=A\n@16\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n")   
    
    if not strcmp(segment, 'pointer'): 
        strcpy(result, "@")
        strcat(result, value)
        strcat(result, "\nD=A\n@3\nA=A+D\nD=M\n@SP\nA=M\nM=D\n@SP\nM=M+1\n\n") 

    return result
    
    
    
cdef char* pop(char* segment, char* value):  
    cdef char* result = <char *>malloc(80)
   
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
        strcat(result, value)
        strcat(result, "\nD=A\n@16\nD=A+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n")   
    
    if not strcmp(segment, 'pointer'): 
        strcpy(result, "@SP\nM=M-1\n@")
        strcat(result, value)
        strcat(result, "\nD=A\n@3\nD=A+D\n@13\nM=D\n@SP\nA=M\nD=M\n@13\nA=M\nM=D\n\n") 

    return result 

        
        
        
def compile(path): 

    global LABEL_COUNTER
    LABEL_COUNTER = 0
    
    files_list=[f for f in os.listdir(path) if os.path.splitext(f)[-1].lower() == ".vm"]
    folder_name = os.path.basename(path)
    f_asm = open(path + "\\" + folder_name +  ".asm","w")    
    
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
                    #f_asm.write("//add command\n")
                    f_asm.write(add().decode("utf-8"))    
                if cmd == 'sub':
                    #f_asm.write("//sub command\n")
                    f_asm.write(sub().decode("utf-8"))
                if cmd == 'neg':
                    #f_asm.write("//neg command\n")
                    f_asm.write(neg().decode("utf-8"))
                if cmd == 'eq':
                    #f_asm.write("//eq command\n")
                    f_asm.write(eq().decode("utf-8"))
                if cmd == 'gt':
                    #f_asm.write("//gt command\n")
                    f_asm.write(gt().decode("utf-8"))
                if cmd == 'lt':
                    #f_asm.write("//lt command\n")
                    f_asm.write(lt().decode("utf-8"))
                if cmd == 'and':
                    #f_asm.write("//and command\n")
                    f_asm.write(_and().decode("utf-8"))
                if cmd == 'or':
                    #f_asm.write("//or command\n")
                    f_asm.write(_or().decode("utf-8"))
                if cmd == 'not': 
                    #f_asm.write("//not command\n")
                    f_asm.write(_not().decode("utf-8"))  
                if cmd == 'push':                  
                    #f_asm.write("//push command\n")
                    temp_str1 = s[1].encode("utf-8")
                    temp_str2 = s[2].encode("utf-8")
                    f_asm.write(push(temp_str1,temp_str2).decode("utf-8"))
                if cmd == 'pop':                  
                    #f_asm.write("//pop command\n")
                    temp_str1 = s[1].encode("utf-8")
                    temp_str2 = s[2].encode("utf-8")
                    f_asm.write(pop(temp_str1,temp_str2).decode("utf-8"))
                       
    print("end")              
    f_asm.close()
    
    
    