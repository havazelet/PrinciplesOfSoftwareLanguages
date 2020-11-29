import os 
from libc.stdlib cimport malloc, free
from libc.string cimport strcpy, strlen, strcat, strcmp
from libc.stdio cimport sprintf
from cpython cimport bool
import re

 
 

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
    

    
#----------------------------------------------------------------------------------------   
cdef void getParameterList( src ,  target ):
    target.write(getNextToken(src).decode("utf-8"))#<symbol> ( </symbol>
    target.write("<parameterList>\n") 
    while (not(checkNextToken(src , ")"))):
        target.write(getNextToken(src).decode("utf-8"))#<keyword> int </keyword>
        target.write(getNextToken(src).decode("utf-8"))#<identifier> x </identifier>
        
        while (checkNextToken(src , ",")):
            target.write(getNextToken(src).decode("utf-8"))#<symbol> , </symbol>
            target.write(getNextToken(src).decode("utf-8"))#<keyword> int </keyword>
            target.write(getNextToken(src).decode("utf-8"))#<identifier> y </identifier>
        
    target.write("</parameterList>\n")
    target.write(getNextToken(src).decode("utf-8")) #<symbol> ) </symbol> 
    return

#---------------------------------------------------------------------------------------
cdef void getSubroutineBody( src ,  target ):
    target.write("<subroutineBody>\n")
    target.write(getNextToken(src).decode("utf-8"))#<symbol> { </symbol>
    while ((checkNextToken(src , "var"))):
        target.write("<varDec>\n")
        target.write(getNextToken(src).decode("utf-8"))#<keyword> var </keyword>
        target.write(getNextToken(src).decode("utf-8"))#<keyword> int </keyword>
        target.write(getNextToken(src).decode("utf-8"))#<identifier> x </identifier>
        
        while (checkNextToken(src , ",")):
            target.write(getNextToken(src).decode("utf-8"))#<symbol> , </symbol>
            target.write(getNextToken(src).decode("utf-8"))#<identifier> y </identifier>
        target.write(getNextToken(src).decode("utf-8"))#<symbol> ; </symbol>
        target.write("</varDec>\n")
      
    getStatement( src ,  target ) 
    target.write(getNextToken(src).decode("utf-8")) #<symbol> } </symbol>
    target.write("</subroutineBody>\n")
    return

 
#------------------------------------------------------------------------------
cdef void getStatement( src ,  target ):
    target.write("<statements>\n")
    
    
    while (checkNextToken(src , "let") or checkNextToken(src , "if") or checkNextToken(src , "while")
           or checkNextToken(src , "do") or checkNextToken(src , "return")):
    
           if (checkNextToken(src , "let")):
               target.write("<letStatement>\n")
               target.write(getNextToken(src).decode("utf-8")) #<keyword> let </keyword> 
               target.write(getNextToken(src).decode("utf-8")) #<identifier> var name </identifier>
               if (checkNextToken(src,"[")):
                    target.write(getNextToken(src).decode("utf-8"))#<symbol> [ </symbol>
                    getExpression(src ,  target)
                    target.write(getNextToken(src).decode("utf-8"))#<symbol> ] </symbol>
               target.write(getNextToken(src).decode("utf-8"))#<symbol> = </symbol>
               getExpression(src ,  target)
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ; </symbol>
               target.write("</letStatement>\n")
            
            
           if (checkNextToken(src , "if")):
               target.write("<ifStatement>\n")
               target.write(getNextToken(src).decode("utf-8")) #<keyword> if </keyword>  
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ( </symbol>
               getExpression(src ,  target)
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ) </symbol>
               target.write(getNextToken(src).decode("utf-8"))#<symbol> { </symbol> 
               getStatement(src ,  target)
               target.write(getNextToken(src).decode("utf-8"))#<symbol> } </symbol> 
               if (checkNextToken(src,"else")):
                    target.write(getNextToken(src).decode("utf-8")) #<keyword> else </keyword>  
                    target.write(getNextToken(src).decode("utf-8"))#<symbol> { </symbol>
                    getStatement(src ,  target)
                    target.write(getNextToken(src).decode("utf-8"))#<symbol> } </symbol>           
               target.write("</ifStatement>\n")
               
               
               
           if (checkNextToken(src , "while")):
               target.write("<whileStatement>\n")
               target.write(getNextToken(src).decode("utf-8")) #<keyword> while </keyword>  
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ( </symbol>
               getExpression(src ,  target)
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ) </symbol>
               target.write(getNextToken(src).decode("utf-8"))#<symbol> { </symbol> 
               getStatement(src ,  target)
               target.write(getNextToken(src).decode("utf-8"))#<symbol> } </symbol> 
               target.write("</whileStatement>\n")
               
               
           if (checkNextToken(src , "do")):
               target.write("<doStatement>\n")
               target.write(getNextToken(src).decode("utf-8")) #<keyword> do </keyword>   
               subroutineCall(src ,  target);
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ; </symbol> 
               target.write("</doStatement>\n")
           
           
           if (checkNextToken(src , "return")):
               target.write("<returnStatement>\n")
               target.write(getNextToken(src).decode("utf-8")) #<keyword> return </keyword>        
               if(not(checkNextToken(src, ';'))):
                    getExpression(src ,  target)
               target.write(getNextToken(src).decode("utf-8"))#<symbol> ; </symbol>                   
               target.write("</returnStatement>\n")
           
    target.write("</statements>\n")
   
    return 


#--------------------------------------------------------------------------------------  
cdef void getExpression( src ,  target ):
    target.write("<expression>\n")
    getTerm(src ,  target)
    while((checkNextToken(src, '+')) or  (checkNextToken(src, '-')) or (checkNextToken(src, '*')) 
             or (checkNextToken(src, '/')) or (checkNextToken(src, '&')) or (checkNextToken(src, '|')) 
             or (checkNextToken(src, '<')) or (checkNextToken(src, '>'))  or (checkNextToken(src, '='))):
            target.write(getNextToken(src).decode("utf-8")) #<symbol> op </symbol>
            getTerm(src ,  target)  
        
    target.write("</expression>\n")
    return
    
    
    
    
#--------------------------------------------------------------------------------------  
cdef void getExpressionList( src ,  target ):
    target.write("<expressionList>\n")
    
    if (not(checkNextToken(src, ')'))):
        getExpression(src ,  target);
        while ((checkNextToken(src, ','))):
            target.write(getNextToken(src).decode("utf-8")) #<symbol> , </symbol>
            getExpression(src ,  target);
    
    target.write("</expressionList>\n")
 
 
    return
 
#---------------------------------------------------- 
cdef void getTerm( src ,  target ):    
    target.write("<term>\n")
    if(checkNextToken(src, '(')):#if "(" expression ")"
        target.write(getNextToken(src).decode("utf-8")) #<symbol> ( </symbol> 
        getExpression( src ,  target )
        target.write(getNextToken(src).decode("utf-8")) #<symbol> ) </symbol> 
    elif ((checkNextToken(src, '-')) or (checkNextToken(src, '~'))):
        target.write(getNextToken(src).decode("utf-8")) #<symbol> - | ~ </symbol>
        getTerm( src ,  target ) 
    elif(checkNext2Token(src, '[') or checkNext2Token(src, '.') or checkNext2Token(src, '(')):
        if(checkNext2Token(src, '[')):
            target.write(getNextToken(src).decode("utf-8")) #<identifier> var name </identifier>
            target.write(getNextToken(src).decode("utf-8")) #<symbol> [ </symbol> 
            getExpression( src ,  target )
            target.write(getNextToken(src).decode("utf-8")) #<symbol> ] </symbol> 
        else:
            subroutineCall( src ,  target )
            "integerConstant", "stringConstant" , "keyword", "identifier" 
    #elif ( checkNextToken(src, "integerConstant") or checkNextToken(src, "stringConstant")
    #        or checkNextToken(src, "keyword") or checkNextToken(src, "identifier") ):

    else:
        
        target.write(getNextToken(src).decode("utf-8")) #<identifier> var name </identifier>

            
    target.write("</term>\n")  
    
    return




#----------------------------------------------------- 


cdef void subroutineCall( src ,  target ): 
    target.write(getNextToken(src).decode("utf-8"))#<identifier> subroutinename </identifier>
    if(checkNextToken(src, '(')):
        target.write(getNextToken(src).decode("utf-8")) #<symbol> ( </symbol>
        getExpressionList(src ,  target)
        target.write(getNextToken(src).decode("utf-8")) #<symbol> ) </symbol>
    else:
        target.write(getNextToken(src).decode("utf-8")) #<symbol> . </symbol> 
        target.write(getNextToken(src).decode("utf-8"))#<identifier> subroutinename </identifier>
        target.write(getNextToken(src).decode("utf-8")) #<symbol> ( </symbol>
        getExpressionList(src ,  target)
        target.write(getNextToken(src).decode("utf-8")) #<symbol> ) </symbol>  
        
    return
        
    


#----------------------------------------------------------------------------------------
cdef void parseClassVarDec (src , target ):
    
    while (checkNextToken(src , "static") or checkNextToken(src , "field")):
        target.write("<classVarDec>\n")
        target.write(getNextToken(src).decode("utf-8"))#<keyword> field or static </keyword>
        target.write(getNextToken(src).decode("utf-8"))#<keyword> int </keyword>
        target.write(getNextToken(src).decode("utf-8"))#<identifier> x </identifier>
        
        while (checkNextToken(src , ",")):
            target.write(getNextToken(src).decode("utf-8"))#<symbol> , </symbol>
            target.write(getNextToken(src).decode("utf-8"))#<identifier> y </identifier>
            
        target.write(getNextToken(src).decode("utf-8")) #for ;    
        target.write("</classVarDec>\n")
    return
    
 
 
#----------------------------------------------------------------------------------------
cdef void parseSubDec( src , target ):
    while (checkNextToken(src , "constructor") or checkNextToken(src , "function") or checkNextToken(src , "method")):
        target.write("<subroutineDec>\n")
        target.write(getNextToken(src).decode("utf-8"))#<keyword> constructor | function | method  </keyword>
        target.write(getNextToken(src).decode("utf-8"))#<identifier> type | name </identifier>
        target.write(getNextToken(src).decode("utf-8"))#<identifier> functionName | new </identifier>
        getParameterList(src , target)
        getSubroutineBody(src , target)
        target.write("</subroutineDec>\n")
    return




#--------------parsing---------------------------------------------------
def parsing(path):
 
    
    print("Start parsing...")
    files_list=[f for f in os.listdir(path) if os.path.splitext(f)[-1].lower() == ".jack"]
    
    
    for file in files_list:
        
        file_name = os.path.splitext(file)
        f_xml = open(path + "\\" + "my_" + file_name[0] +  ".xml","w")
        f_Txml=open(path + "\\" + "my_" + file_name[0]+ "T" +  ".xml","r+")
        
        
        
        
        f_Txml.readline() #קידום השורה הראשונה
        f_xml.write("<class>\n")
        f_xml.write(getNextToken(f_Txml).decode("utf-8")) #<keyword> class </keyword>
        f_xml.write(getNextToken(f_Txml).decode("utf-8")) #<identifier> Main </identifier>
        f_xml.write(getNextToken(f_Txml).decode("utf-8")) #<symbol> { </symbol>
        
        
        parseClassVarDec( f_Txml  , f_xml)
        parseSubDec( f_Txml  , f_xml )
      
      
        f_xml.write(getNextToken(f_Txml).decode("utf-8")) # for {
        f_xml.write("</class>")
        
        f_xml.close() 
        f_Txml.close()
        print("end parsing") 
        
         
   
    
         