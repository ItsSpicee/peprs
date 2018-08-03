function errorList = addToErrorList(error,errorList)
    if error ~= "" || error ~= " "
        errorList = [errorList,error];
    end
end