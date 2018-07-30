function error = checkError(f)    
    result = query(f, 'SYSTem:ERRor:NEXT?');
    if contains(result,'No error')
        error ="";
    else
        error = result;
    end
end