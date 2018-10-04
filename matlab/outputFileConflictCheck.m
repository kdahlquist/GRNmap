function result = outputFileConflictCheck (directory, file_name)
    [~,name,ext] = fileparts(file_name);
    output_file_name = [name '_output' ext];

    for file = dir(directory)'
        if strcmp(output_file_name, file.name)
            result = true;
            return;
        end
    end
    
    result = false;
    return;
end