% Determine whether a .mat file already has the relevant variables
function alreadyExists = matFileExists(filename, vars)
% If file doesn't exist, then the variables can't exist either
fileExists = exist(filename, 'file');
if ~fileExists
    alreadyExists = false;
    return
end

% Obtain a list of the variables in the file, and make sure they are all
% present.
variableList = who('-file', filename);
existingVariables = cellfun(@(x) any(ismember(variableList,x)), vars);
alreadyExists = all(existingVariables);

flagExists = cellfun(@(x) any(ismember(variableList,x)), {'flag'});
alreadyExists = alreadyExists || flagExists;

