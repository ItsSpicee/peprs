function errorList = addToErrorList(error,errorList)
    if error ~= "" or error ~= " "
        errorList = [errorList,error];
    end
end