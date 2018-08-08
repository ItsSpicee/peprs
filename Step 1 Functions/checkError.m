function error = checkError(f,s)    
    error = "";
	result = query(f, 'SYSTem:ERRor:NEXT?');
    if contains(result,'No error')
        error ="";
    else
        s = convertCharsToStrings(s);
		result = convertCharsToStrings(result);
		error = sprintf("Error has occured in command %s\n%s",s,result);
    end
end