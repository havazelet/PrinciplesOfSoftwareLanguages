import os 
from libc.stdlib cimport malloc, free
from libc.string cimport strcpy, strlen, strcat, strcmp
from libc.stdio cimport sprintf
from cpython cimport bool
import re

 
 
global class_name
global numArg
cdef int numLcl 
global numfield
global Class_scope_symbol_table 
global Method_scope_symbol_table 
cdef int labelIndex 
labelIndex = 0

keyword=["class", "constructor", "function", "method", "field", "static", "var",
              "int", "char","boolean", "void", "true", "false","null","this","let",
               "do","if","else","while","return"]
symbol_list=["{","}","(",")","[","]",".",",",";","+","-","*","/","&","|","<",">","=","~"]
digit= ["0","1","2","3","4","5","6","7","8","9"]
op_list=["+","-","*","/","&","|","<",">","="]
unaryOp_list=["-","~"]
statement_list=["let","if", "while", "do" ,"return"]   
tmp_list=["integerConstant", "stringConstant" , "keyword", "identifier" ]   
   

cdef char* symbol(char* c):

    if not strcmp(c, '&'):
        return "<symbol> &amp; </symbol>\n"
    if not strcmp(c, '<'):
        return "<symbol> &lt; </symbol>\n"
    if not strcmp(c, '>'):
        return "<symbol> &gt; </symbol>\n"
        
    cdef char* result = <char *>malloc(200)
    strcpy(result,"<symbol> ")
    strcat(result, c)
    strcat(result," </symbol>\n")
    free(result)
    return result






def tokenizing(path): 

 
    files_list=[f for f in os.listdir(path) if os.path.splitext(f)[-1].lower() == ".jack"]
  
    print("Start tokenizing...")
   
    
    #tokenizing
    for file in files_list:
        
        f=open(path + "\\"  + file,"r")
        file_name = os.path.splitext(file)
        f_Txml = open(path + "\\" + "my_" + file_name[0]+ "T" +  ".xml","w")
        f_Txml.write("<tokens>\n")
        
        flag="false"
        while(1):
            
            if(flag !="true"): 
                c=f.read(1)
            flag="false"    
            if not c:
                f_Txml.write("</tokens>\n")
                break
        
            
            #---------symbol----------------------
            if(c in symbol_list):          
                                           
                if (c=='/'):         
                    c=f.read(1)
                    if (c=='/'):
                        f.readline()
                    elif(c =='*'):
                        a=' '
                        c=f.read(1)
                        while((c!="/") or (a!='*')):
                            a=c
                            c=f.read(1)
                    else:
                        f_Txml.write("<symbol> ")
                        f_Txml.write( '/')
                        f_Txml.write(" </symbol>\n")
                        flag="true"
                else: 
                    temp_char = c.encode("utf-8")
                    f_Txml.write(symbol(temp_char).decode("utf-8"))
            


            #-------stringConstant---------------------------
            elif(c=="\""):
                f_Txml.write("<stringConstant> ")
                c=f.read(1)
                while(c != "\""):
                    f_Txml.write(c)
                    c=f.read(1)
                f_Txml.write(" </stringConstant>\n")
            
            
            #-----integetConstant---------------------------
            elif (ord(c)> 47 and ord(c) < 58):
                c_tmp=""
                while(ord(c)> 47 and ord(c) < 58):
                    c_tmp=c_tmp+c
                    c=f.read(1)
                    if ((not c) or (c not in digit)):
                        break  
                intToken=int(c_tmp)
                if(intToken >=0 and intToken<32678):
                    f_Txml.write("<integerConstant> ")
                    f_Txml.write(c_tmp)
                    f_Txml.write(" </integerConstant>\n")
                flag= "true"
            
            
            if not c:
                f_Txml.write("</tokens>\n")
                break
             
             
             
            #--------identifier----------------------   
            if( ((ord(c)> 64) and (ord(c) < 91))or((ord(c)> 96) and (ord(c) < 123)) or (c=="_" )):
                c_temp=""
                while(c and(((ord(c)> 64) and (ord(c) < 91))or((ord(c)> 96) and (ord(c) < 123)) or (c=="_") or ((ord(c)> 47) and (ord(c) < 58)))):
                    c_temp=c_temp + str(c)
                    c=f.read(1)
                if c_temp in keyword:
                     f_Txml.write("<keyword> ")
                     f_Txml.write(c_temp)
                     f_Txml.write(" </keyword>\n")
                else: 
                     f_Txml.write("<identifier> ")
                     f_Txml.write(c_temp)
                     f_Txml.write(" </identifier>\n")
                flag="true" 
                
            #-----------------------------------------
         
         
        f_Txml.close()   
        print("end tokenizing")  
   


   
#---------------------------------------------------------------------------------------------------------------------------------------

cdef char* getNextToken (file):
    cdef char* result = <char *> malloc(800)
    nextToken = file.readline().encode("utf-8")
    strcpy(result,nextToken)
    free(result)
    return result

#----------------------------------------------------------------------------------------
cdef bool checkNextToken(file , token):
    nuberLine=file.tell()
    line = file.readline()
    tmp_list = line.split(">")
    token_str=tmp_list[1]
    tmp_list = token_str.split("<")
    token_str=tmp_list[0]
    file.seek(nuberLine)
    if token in token_str:
        return True
    return False

#-------------------------------------------------------------------
cdef bool checkNext2Token(file , token):
    nuberLine=file.tell()
    file.readline()
    line = file.readline()
    file.seek(nuberLine)
    if token in line:
        return True
    return False

#-----------------------------------------------------------------------------------
cdef bool checkTypeNextToken(file , tokenType):
    nuberLine=file.tell()
    line = file.readline()
    tmp_list = line.split(">")
    token_str=tmp_list[0]
    tmp_list = token_str.split("<")
    token_str=tmp_list[1]
    file.seek(nuberLine)
    if tokenType in token_str:
        return True
    return False  


#----------------------------------------------------------------------------------------
cdef bool checkNextTokenList(file , token_list):
    nuberLine=file.tell()
    line = file.readline()
    tmp_list = line.split(">")
    token_str=tmp_list[1]
    tmp_list = token_str.split("<")
    token_str=tmp_list[0]
    file.seek(nuberLine)
    for item in token_list:
        if item in token_str:
            return True
    return False
    
#--------------------------------------------------------------------------------------
cdef char* splittoken(token):
    tmp_list = token.split("> ")
    token_str=tmp_list[1]
    tmp_list = token_str.split(" <")
    token_str=tmp_list[0].encode()
    
    return token_str  

#----------------------------------------------------------------------------------------
cdef char* getKindFuncTable (var_name):  #argument | static | var |field

    global Method_scope_symbol_table
    #[[name ,( type , kind ,n. )],[name ,( type , kind , n.)]]
    for i in Method_scope_symbol_table:
        if i[0] == var_name:
            return i[1][1].encode("utf-8")
    return "null"
    
#-------------------------------------------------------------------------------------
cdef char* getKindClassTable (var_name):
    global Class_scope_symbol_table
    #[[name ,( type , kind ,n. )],[name ,( type , kind , n.)]]
    for i in Class_scope_symbol_table:
        if i[0] == var_name:
            return i[1][1].encode("utf-8")
    return "null".encode("utf-8")
 

#-------------------------------------------------------------------------------------
cdef char* getTypeFuncTable (var_name):  #int | string ... 
    global Method_scope_symbol_table
    #[[name ,( type , kind ,n. )],[name ,( type , kind , n.)]]
    for i in Method_scope_symbol_table:
        if i[0] == var_name:
            return i[1][0].encode("utf-8")
    return "null".encode("utf-8")
    
#-------------------------------------------------------------------------------------
cdef char* getTypeClassTable (var_name):  #int | string ... 
    global Class_scope_symbol_table
    #[[name ,( type , kind ,n. )],[name ,( type , kind , n.)]]
    for i in Class_scope_symbol_table:
        if i[0] == var_name:
            return i[1][0]
    return "null"


    
#-------------------------------------------------------------------------------------
cdef int getIndexVar (var_name):
    global Class_scope_symbol_table
    global Method_scope_symbol_table
    #[[name ,( type , kind ,n. )],[name ,( type , kind , n.)]]
    for i in Method_scope_symbol_table:
        if i[0] == var_name:
            return i[1][2]
    
    for i in Class_scope_symbol_table:
        if i[0] == var_name:
            return i[1][2]
            
    return 0

      
#-------------------------------------------------------------------------------------
cdef void pushVarName( var_name ,  target ):
    cdef char* temp = <char *> malloc(800) 
    strcpy(temp,"")
    kind = getKindFuncTable(var_name)
    cdef int index
    index = getIndexVar(var_name)
    
    if(kind == "null".encode()):
        kind = getKindClassTable(var_name).decode("utf-8")
    if (kind == "local".encode() or kind == "argument".encode()):
        target.write("push ")
        target.write(kind.decode("utf-8"))
        print(kind.decode("utf-8"))
        print("+++++++++====")
        target.write(" ")
        sprintf(temp,"%d",index)
        target.write(temp.decode("utf-8"))
        target.write("\n")
    elif(kind == "field".encode()):
        target.write("push this ")
        sprintf(temp,"%d",index)
        target.write(temp.decode("utf-8"))
        target.write("\n")
    elif(kind == "static".encode()):
        target.write("push static ")
        sprintf(temp,"%d",index)
        target.write(temp.decode("utf-8"))
        target.write("\n")
    return

#-------------------------------------------------------------------------------------
cdef void popVarName( var_name ,  target ): 
    cdef char* result = <char *> malloc(800)
    cdef char* temp = <char *>malloc(1000)
    cdef int index = 0
    index = getIndexVar(var_name)
    kind = getKindFuncTable(var_name)

    if(kind == "null"):
        kind = getKindClassTable(var_name).decode("utf-8")
    if (kind == "local".encode() or kind == "argument".encode()):
        #target.write("pop " + kind + " " + index + "\n")
        strcpy(result,"pop ")
        strcat(result, kind)
        strcat(result, " " )
        sprintf(temp,"%d",index)
        strcat(result , temp )
        strcat(result,  "\n")
        target.write(result.decode("utf-8"))
    elif(kind == "field".encode()):
       # target.write("POP this " + index + "\n")
        strcpy(result,"pop this ")
        sprintf(temp,"%d",index)
        strcat(result,temp )
        strcat(result,  "\n")
        target.write(result.decode("utf-8"))
    else:#static
        #target.write("POP static " + index +"\n")
        strcpy(result,"pop static ")
        sprintf(temp,"%d",index)
        strcat(result,temp )
        strcat(result,  "\n")
        target.write(result.decode("utf-8"))
        
    return            
   
        
    

    
#----------------------------------------------------------------------------------------   
cdef void getParameterList( src ):
    
    global numArg
    global Method_scope_symbol_table
    
    getNextToken(src).decode("utf-8")#<symbol> ( </symbol>
    while (not(checkNextToken(src , ")"))):
        symbol_type=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<keyword> int </keyword>
        name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
        numArg = numArg + 1
        record =[name , (symbol_type , "argument" , numArg)]
        Method_scope_symbol_table.append(record)
        
        while (checkNextToken(src , ",")):
            getNextToken(src).decode("utf-8")#<symbol> , </symbol>
            symbol_type=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<keyword> int </keyword>
            name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
            numArg = numArg + 1
            record =[name , (symbol_type , "argument" , numArg)]
            Method_scope_symbol_table.append(record)
        
    
    getNextToken(src).decode("utf-8") #<symbol> ) </symbol> 
    return

#---------------------------------------------------------------------------------------
cdef void getSubroutineBody( src , target ):

    global numLcl
    numLcl = 0
    global Method_scope_symbol_table
    
    getNextToken(src).decode("utf-8")#<symbol> { </symbol>
    
    while ((checkNextToken(src , "var"))):
        getNextToken(src).decode("utf-8")#<keyword> var </keyword>
        symbol_type=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<keyword> int </keyword>
        name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
        record =[name , (symbol_type , "local" , numLcl)]
        Method_scope_symbol_table.append(record)
        numLcl = numLcl + 1
 
        while (checkNextToken(src , ",")):
            getNextToken(src).decode("utf-8")#<symbol> , </symbol>
            name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
            record =[name , (symbol_type , "local" , numLcl)]
            Method_scope_symbol_table.append(record)
            numLcl = numLcl + 1
        getNextToken(src).decode("utf-8")#<symbol> ; </symbol>
     
       
    return
    

#------------------------------------------------------------------------------
cdef void getStatement( src ,  target ):
 
    
    while (checkNextToken(src , "let") or checkNextToken(src , "if") or checkNextToken(src , "while")
           or checkNextToken(src , "do") or checkNextToken(src , "return")):
    
    
           if (checkNextToken(src , "let")):
                letStatment(src, target)
            
           if (checkNextToken(src , "if")):
                ifStatment(src, target)
              
           if (checkNextToken(src , "while")):
                whileStatment(src , target)
               
           if (checkNextToken(src , "do")):
                doStatement(src , target)
               
           if (checkNextToken(src , "return")):
                returnStatement(src , target)
        
    return 



#--------------------------------------------------------------------------------------------
cdef void letStatment(src , target):
    getNextToken(src).decode("utf-8") #<keyword> let </keyword> 
    var_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8") #<identifier> var name </identifier>
    
    if (checkNextToken(src,"[")):
        getNextToken(src).decode("utf-8")#<symbol> [ </symbol>
        getExpression(src ,  target)
        pushVarName(var_name , target)
        target.write("add\n")
        getNextToken(src).decode("utf-8")#<symbol> ] </symbol>
        getNextToken(src).decode("utf-8")#<symbol> = </symbol>
        getExpression(src ,  target) #right expression
        target.write("pop temp 0\n")
        target.write("pop pointer 1\n")
        target.write("push temp 0\n")
        target.write("pop that 0\n")
                    
    else:
        getNextToken(src).decode("utf-8")#<symbol> = </symbol>
        getExpression(src ,  target)
        popVarName(var_name , target)
   
    getNextToken(src).decode("utf-8")#<symbol> ; </symbol> 
    
    return

#---------------------------------------------------------------------------------------------
cdef void ifStatment(src , target):
    cdef char* temp = <char *> malloc(800)
    global labelIndex
    #startIf = "ifStatment_" + labelIndex + "_else"
    #endIf = "ifStatment_" + labelIndex + "_end"
    
    startIf=""
    strcpy(startIf,"IF_TRUE" )
    sprintf(temp,"%d",labelIndex)
    strcat(startIf,temp)
    
    endIf=""
    strcpy(endIf,"IF_FALSE" )
    sprintf(temp,"%d",labelIndex)
    strcat(endIf,temp)

    labelIndex = labelIndex + 1 #קידום המונה של התגיות
    
    getNextToken(src).decode("utf-8")#<keyword> if </keyword>  
    getNextToken(src).decode("utf-8")#<symbol> ( </symbol>
    getExpression(src ,  target)
    target.write("not\n")
    target.write("if-goto ")
    target.write(startIf.decode("utf-8"))
    target.write("\n" )    
    getNextToken(src).decode("utf-8")#<symbol> ) </symbol>
    getNextToken(src).decode("utf-8")#<symbol> { </symbol> 
    getStatement(src ,  target)
    getNextToken(src).decode("utf-8")#<symbol> } </symbol>
    target.write("goto ")
    target.write(endIf)#.decode("utf-8"))
    target.write("\n" )
    target.write("label ")
    target.write(startIf)#.decode("utf-8"))
    target.write("\n" )
    
    if (checkNextToken(src,"else")):
        getNextToken(src).decode("utf-8") #<keyword> else </keyword>  
        getNextToken(src).decode("utf-8")#<symbol> { </symbol>
        getStatement(src ,  target)
        getNextToken(src).decode("utf-8")#<symbol> } </symbol>  
    
    target.write("label ")
    target.write(endIf.decode("utf-8"))
    target.write("\n")    
    
    return


#---------------------------------------------------------------------------------------------
cdef void whileStatment (src , target):
    global labelIndex
    cdef char* temp = <char *> malloc(800)
    cdef char* startWhile = <char *> malloc(800)
    cdef char* endWhile = <char *> malloc(800)
    
   # startWhile = "whileStatment_" + labelIndex
    strcpy(startWhile , "WHILE_EXP")
    sprintf(temp,"%d",labelIndex)
    strcat(startWhile , temp)

    
    #endWhile = "whileStatment_" + labelIndex
    strcpy(endWhile,"WHILE_END")
    sprintf(temp,"%d",labelIndex)
    strcat(endWhile,temp)
    
    labelIndex = labelIndex + 1
    
    
    getNextToken(src).decode("utf-8") #<keyword> while </keyword>  
    getNextToken(src).decode("utf-8")#<symbol> ( </symbol>
    target.write("label ")
    target.write(startWhile.decode("utf-8"))
    target.write("\n" )
    getExpression(src ,  target)
    target.write("not\n")
    target.write("if-goto ")
    target.write(endWhile.decode("utf-8"))
    target.write("\n" )
    getNextToken(src).decode("utf-8")#<symbol> ) </symbol>
    getNextToken(src).decode("utf-8")#<symbol> { </symbol>
    getStatement(src ,  target)
    target.write("goto ")
    target.write(startWhile.decode("utf-8"))
    target.write("\n" )
    target.write("label ")
    target.write(endWhile.decode("utf-8"))
    target.write("\n" )
    getNextToken(src).decode("utf-8")#<symbol> } </symbol>
    
    return
               
     
     
#---------------------------------------------------------------------------------------------
cdef void doStatement (src , target):
    getNextToken(src).decode("utf-8") #<keyword> do </keyword>   
    subroutineCall(src ,  target);
    target.write("pop temp 0\n") #the return value
    getNextToken(src).decode("utf-8")#<symbol> ; </symbol> 
    
    return



#---------------------------------------------------------------------------------------------
cdef void returnStatement (src , target):
    getNextToken(src).decode("utf-8") #<keyword> return </keyword>        
    if(not(checkNextToken(src, ';'))):
        getExpression(src ,  target)                 
    else:
        target.write("push constant 0\n")
        
    getNextToken(src).decode("utf-8")#<symbol> ; </symbol>
    target.write("return\n")   
    return



 
#---------------------------------------------------------------------------------------------
cdef void getExpression( src ,  target ):
    getTerm(src ,  target)
    while((checkNextToken(src, '+')) or  (checkNextToken(src, '-')) or (checkNextToken(src, '*')) 
             or (checkNextToken(src, '/')) or (checkNextToken(src, '&')) or (checkNextToken(src, '|')) 
             or (checkNextToken(src, '<')) or (checkNextToken(src, '>'))  or (checkNextToken(src, '='))):
                
                symbol_type=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<symbol> op </symbol>
                getTerm(src ,  target) 
                if (symbol_type == "+"):
                    target.write("add\n")
                elif (symbol_type == "-"):
                    target.write("sub\n")
                elif (symbol_type == "*"):
                    target.write("call Math.multiply 2\n")
                elif (symbol_type == "/"):
                    target.write("call Math.divide 2\n");
                elif (symbol_type == "&amp;"):
                    target.write("and\n")
                elif (symbol_type == " | "):
                    target.write("or\n")
                elif (symbol_type == "&lt;"):
                    target.write("lt\n")
                elif (symbol_type == "&gt;"):
                    target.write("gt\n")
                elif (symbol_type == "="):
                    target.write("eq\n")
                    
                    
        
    return
    
    
    
#---------------------------------------------------- 
cdef void getTerm( src ,  target ):  
    
    cdef char* indexTmp =<char *> malloc(800)
    cdef char* temp = <char *> malloc(800)
    cdef int lenghOfString = 0
    
    if (checkTypeNextToken (src, "integerConstant")):
        constantTemp = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8") #int | x | 3 | +... return the value in the token
        print("2222")
        print(constantTemp)
        print("2222")
        target.write("push constant ")
        target.write(constantTemp)
        target.write( "\n")
    
    
    
    
    elif (checkTypeNextToken (src,"stringConstant")):
        symbol_value=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8") #string... return the value in the token
        lenghOfString = len(symbol_value)
        target.write("push constant ")
        sprintf(temp,"%d",lenghOfString)
        target.write(temp.decode("utf-8"))
        target.write( "\n")
        target.write("call String.new 1\n")
        for char in symbol_value:
            target.write("push constant ")
            sprintf(temp,"%d",ord(char))
            target.write(temp.decode("utf-8"))
            target.write( "\n")
            target.write("call String.appendChar 2\n")
          
           
           
           
    elif (checkTypeNextToken (src, "keyword")):
        symbol_value=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8") #keyword... return the value in the token
        if ( symbol_value == "null" or symbol_value == "false"):
            target.write("push constant 0\n")
        if (symbol_value == "true"):
            target.write("push constant 0\n")
            target.write("not\n")           
        if(symbol_value == "this"):
            target.write("push pointer 0\n")

#---------------------------------------------------------------
    elif (checkTypeNextToken (src, "identifier")): 
        if (checkNext2Token(src, '.') or checkNext2Token(src, '(')):  #if '.' | '(' 
            subroutineCall( src ,  target )
        elif(checkNext2Token(src, '[') or checkNext2Token(src, '.') or checkNext2Token(src, '(')):
              if(checkNext2Token(src, '[')):
                  var_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> var_name </identifier>
                  getNextToken(src).decode("utf-8") #<symbol> [ </symbol> 
                  getExpression( src ,  target )
                  pushVarName(var_name , target)
                  target.write("add\n")
                  target.write("pop pointer 1\n")
                  target.write("push that 0\n")                                
                  getNextToken(src).decode("utf-8") #<symbol> ] </symbol> 
              else:  #if '.' | '(' 
                   subroutineCall( src ,  target )       
        else:
            var_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> var_name </identifier>   
           
            kind = getKindFuncTable(var_name)
            if(not(kind == "null".encode("utf-8"))): #קיים בטבלת הסימבולים של המחלקה הנוכחית
                if(getTypeFuncTable(var_name) != "Array".encode("utf-8") or not(checkNextToken(src, "["))):
                    tempType = kind
                    target.write("push ")
                    target.write("local ")
                    #target.write(kind.decode("utf-8")) 
                    sprintf(indexTmp, '%d' , getIndexVar(var_name))
                    target.write(indexTmp.decode())
                    
                    target.write("\n")
                else:
                    kind = getKindClassTable(var_name)
                    if(not(kind == "null".encode("utf-8"))):
                        if(kind == "field".encode()):
                            tempType = "this"
                        elif(kind == "static".encode()):
                            tempType = "this"
                        if(not(getTypeFuncTable(var_name) == "Array".encode("utf-8")) or not(checkNextToken(src, "["))):
                            target.write("push ")
                            target.write(tempType.decode("utf-8"))
                            sprintf(indexTmp, '%d' , getIndexVar(var_name))
                            target.write(indexTmp.decode())
                            target.write("\n")
                
  #      if(checkNext2Token(src, '[') or checkNext2Token(src, '.') or checkNext2Token(src, '(')):
          #  getNextToken(src).decode("utf-8") #<symbol> [ </symbol> 
           # getExpression( src ,  target )
            #target.write("push ")
          #  target.write(tempType)
           # target.write("add\n")
            #target.write("pop pointer 1\n")
           # target.write("push that 0\n")            
            #getNextToken(src).decode("utf-8") #<symbol> ] </symbol> 

    
        
    elif (checkTypeNextToken (src, "identifier")): 
        symbol_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> symbol_name </identifier>
        pushVarName(symbol_name , target)    
                  
	        
   
   
         
    elif(checkNextToken(src, '(')): #if "(" expression ")"
        getNextToken(src).decode("utf-8") #<symbol> ( </symbol> 
        getExpression( src ,  target )
        getNextToken(src).decode("utf-8") #<symbol> ) </symbol> 
    
    
    elif (checkNextToken(src, '~')):
        getNextToken(src).decode("utf-8") #<symbol> ~ </symbol>
        getTerm( src ,  target ) 
        target.write("neg\n")
        
        
    elif (checkNextToken(src, '-')):
        getNextToken(src).decode("utf-8") #<symbol> - </symbol>
        getTerm( src ,  target )    
        target.write("not\n")
        
        

    
    return
        

    
#--------------------------------------------------------------------------------------  
cdef int getExpressionList( src ,  target ):
    counter = 0
    if (not(checkNextToken(src, ')'))):
        counter = counter + 1 
        getExpression(src ,  target);
        while (checkNextToken(src, ',')):
            getNextToken(src).decode("utf-8") #<symbol> , </symbol>
            counter = counter + 1
            getExpression(src ,  target)
   
    return counter



#------------------------------------------------------------------------------------ 

cdef void subroutineCall( src ,  target ): 
    cdef char* result = <char *> malloc(800)
    cdef char* temp = <char *>malloc(1000)
    cdef int counter
    isStatic = False
    
    symbol_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> subroutinename </identifier>
    kind = getKindFuncTable(symbol_name).decode("utf-8") #local | static | argument
    if (kind != "null"):   #exsist in func symbol table
        type_ = getTypeFuncTable(symbol_name).decode("utf-8")  #int|char...
        i = getIndexVar(symbol_name)         # 0 | 1 |...
    elif (kind == "null"): #kind = null,   its not an object
        kind = getKindClassTable(symbol_name).decode("utf-8")
        type_ = symbol_name
        i = getIndexVar(symbol_name)   
    
    if(checkNextToken(src, '(')):   #func() , method of me
        getNextToken(src).decode("utf-8") #<symbol> ( </symbol>
        target.write("push pointer 0\n")
        type_ = class_name     
    else:   #nextToken == '.'   #   Obj.Func(x,y,..)  | MyClass.Func(x,y,..)  |  OtherClass.Func(x,y,..)
        getNextToken(src).decode("utf-8") #<symbol> . </symbol> 
      
        if (kind != "null"): #obj exsist in  symbol table and its a method function
            symbol_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> subroutinename </identifier>
            
            if (type_ == class_name):  #MyClass.Func(x,y,..) 
                target.write("push pointer 0\n")  #push this
            #else  Obj.Func(x,y,..)    
            elif( kind == 'argument' or kind == 'local'):
                target.write("push ")
                target.write(kind)
                target.write(" ")
                print("fdfffffffffffffffffffffff")
                sprintf(temp,"%d",i)
                target.write(temp.decode())
                target.write("\n")
            elif(kind == 'field'):
                target.write("push this ")
                print("fdfffffffffffffffffffffff")
                sprintf(temp,"%d",i)
                target.write(temp.decode())
                target.write("\n")
            elif(kind == 'static'):
                print("fdfffffffffffffffffffffff")
                target.write("push static " )
                sprintf(temp,"%d",i)
                target.write(temp.decode())
                target.write("\n")

        
        else: #its a static funcion  , OtherClass.Func(x,y,..)  
            isStatic =True
            symbol_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> subroutinename </identifier>
    
    
    
    getNextToken(src).decode("utf-8") #<symbol> ( </symbol>
    counter = getExpressionList(src ,  target)
    
    
    if (isStatic == False): #its a method 
        counter = counter + 1   #+1 to this
    
    
    getNextToken(src).decode("utf-8") #<symbol> ) </symbol> 
    
    
   #target.write("call " + type_ + "." + symbol_name + " " + counter + "\n")
    strcpy(result,"call ")
    strcat(result,type_.encode())
    strcat(result,".")
    strcat(result,symbol_name.encode())
    strcat(result," ")
    sprintf(temp,"%d",counter)
    strcat(result,temp)
    strcat(result,"\n")
    target.write(result.decode("utf-8"))
    
    return
        
    
  

#----------------------------------------------------------------------------------------
cdef void parseClassVarDec (src):
    global Class_scope_symbol_table         # [[name ,( type , kind ,n. )],[name ,( type , kind , n.)]]
    global numfield
    Class_scope_symbol_table = []
    numstatic = 0
    numfield = 0
    
    
    while (checkNextToken(src , "static") or checkNextToken(src , "field")):
        if (checkNextToken(src , "static")):
            getNextToken(src).decode("utf-8")#<keyword> field or static </keyword>
            symbol_type=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<keyword> int </keyword>
            name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
            record =[name , (symbol_type , "static" , numstatic)]
            Class_scope_symbol_table.append(record)
            numstatic = numstatic + 1
            while (checkNextToken(src , ",")):
                  getNextToken(src).decode("utf-8")#<symbol> , </symbol>
                  name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
                  record =[name , (symbol_type , "static" , numstatic)]
                  Class_scope_symbol_table.append(record)
                  numstatic = numstatic + 1
         
        if checkNextToken(src , "field"):
            getNextToken(src).decode("utf-8")#<keyword> field or static </keyword>
            symbol_type=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<keyword> int </keyword>
            name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
            record =[name , (symbol_type , "field" , numfield)]
            Class_scope_symbol_table.append(record)
            numfield = numfield + 1
            while (checkNextToken(src , ",")):
                  getNextToken(src).decode("utf-8")#<symbol> , </symbol>
                  name=splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> x </identifier>
                  record =[name , (symbol_type , "field" , numfield)]
                  Class_scope_symbol_table.append(record)
                  numfield = numfield + 1
        getNextToken(src).decode("utf-8") #for ;        
    
    
    return
    
 
 
#----------------------------------------------------------------------------------------
cdef void parseSubDec( src , target  ):
    
    global Method_scope_symbol_table
    global numfield
    global numLcl
    global class_name
    global numArg
    numArg = 0
    cdef char* temp1 = <char *>malloc(1000)
    cdef char* temp = <char *>malloc(1000)
    cdef char* result = <char *>malloc(1500)
    
    
    while (checkNextToken(src , "constructor") or checkNextToken(src , "function") or checkNextToken(src , "method")):
    
        Method_scope_symbol_table = []
        
        if (checkNextToken(src , "constructor")):
        
            getNextToken(src).decode("utf-8")#<keyword> constructor </keyword>
            getNextToken(src).decode("utf-8")#<identifier> return type  </identifier>
            func_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> functionName </identifier>
            
            getParameterList(src)  #דוחף את הפרמטרים של הפונקציה
            getSubroutineBody(src , target)   #דוחף את המשתנים המקומיים של הפונקציה
            
            target.write("function ")# הצהרה - מס המשתנים הלוקאלים
            target.write(class_name)
            target.write(".")
            target.write(func_name)
            target.write(" ")
            sprintf(temp, "%d",numLcl)
            target.write(temp.decode("utf-8"))
            target.write("\n") 
            target.write("push constant ")# דחיפה למחסנית כמה משתנים לוקאלים יש
            sprintf(temp, "%d",numLcl)
            target.write(temp.decode("utf-8"))
            target.write("\n" ) 
            target.write("call Memory.alloc 1\n") #הקצאה של מקום
            target.write("pop pointer 0\n")
            
            
            getStatement( src ,  target ) 
            getNextToken(src).decode("utf-8") #<symbol> } </symbol>
            
            target.write("push pointer 0\n") #הקצאה של מקום
            target.write("return\n")
            
                
                
                
        if (checkNextToken(src , "function")):
            
            getNextToken(src).decode("utf-8")#<keyword> function </keyword>
            getNextToken(src).decode("utf-8")#<identifier> return type  </identifier>
            func_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> functionName </identifier>
            
            getParameterList(src)
            getSubroutineBody(src , target)
            
            strcpy(result , "function ")
            strcat(result, class_name.encode())
            strcat(result, "." )
            strcat(result, func_name.encode())
            sprintf(temp1,"%d",numLcl) # הצהרה - מס המשתנים 
            strcat(result, " ")
            strcat(result, temp1)
            target.write(result.decode("utf-8")) #function ClassName.FuncName lcl_counter
            target.write("\n")
            getStatement( src ,  target )
            getNextToken(src).decode("utf-8") #<symbol> } </symbol>
           
            
        
        
        
        if (checkNextToken(src , "method")):
        
            getNextToken(src).decode("utf-8")#<keyword> method </keyword>
            getNextToken(src).decode("utf-8")#<identifier> return type  </identifier>
            func_name = splittoken(getNextToken(src).decode("utf-8")).decode("utf-8")#<identifier> functionName </identifier>

            record =['this' , (class_name , "argument" , numArg)]
            Method_scope_symbol_table.append(record)
            
            getParameterList(src)
            getSubroutineBody(src , target)
            
            target.write("function ") # הצהרה - מס המשתנים הלוקאלים
            target.write(class_name)
            target.write(".")
            target.write(func_name)
            target.write(" ")
            sprintf(temp1,"%d",numLcl)
            target.write(temp1.decode())
            target.write("\n")
            target.write("push argument 0\n") #דחיפת האובייקט עצמו למחסנית (this)
            target.write("pop pointer 0\n")   # Pointer 0 שליפת האובייקט לתוך 
            
            getStatement( src ,  target ) 
            getNextToken(src).decode("utf-8") #<symbol> } </symbol>
            
            
        
    return




#--------------parsing---------------------------------------------------
def parsing(path):
 
    
    print("Start parsing...")
    files_list=[f for f in os.listdir(path) if os.path.splitext(f)[-1].lower() == ".jack"]
    
    global class_name
    global numArg
    global numLcl
    global Class_scope_symbol_table 
    global Method_scope_symbol_table 
    
    for file in files_list:
        
        file_name = os.path.splitext(file)
        f_vm = open(path + "\\" + file_name[0] +  ".vm","w")
        f_Txml=open(path + "\\" + "my_" + file_name[0]+ "T" +  ".xml","r+")
        
        
        
        
        f_Txml.readline() #קידום השורה הראשונה
        getNextToken(f_Txml).decode("utf-8") #<keyword> class </keyword>
        class_name = splittoken(getNextToken(f_Txml).decode("utf-8")).decode("utf-8") #<identifier> Main </identifier>
        getNextToken(f_Txml).decode("utf-8") #<symbol> { </symbol>
       
        
        parseClassVarDec( f_Txml )
        parseSubDec( f_Txml  , f_vm )
        
        print  (Class_scope_symbol_table)
        print  (Method_scope_symbol_table)
        print( class_name)
        print(numArg)
        print( numLcl)
      
      
        #f_vm.write(getNextToken(f_Txml).decode("utf-8")) # for {
        
        
        f_vm.close() 
        f_Txml.close()
        print("end parsing") 
        
         
   
    
         