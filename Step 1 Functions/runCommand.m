function errorList = runCommand(f,s,oldList)
    error = "";
	fprintf(f,s);	
    error = checkError(f,s);
    errorList = addToErrorList(error,oldList);
end