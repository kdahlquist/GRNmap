function createDummyFileWithSameName
    global GRNstruct
    previous_dir = pwd;
    cd (tempdir);
    existing_file = GRNstruct.outputFile;
    xlswrite(existing_file, []);
    [~, name, ext] = fileparts (GRNstruct.outputFile);

%     output(GRNstruct);
%     testCase.verifyEqual(exist([name '(1)' ext], 'file'), 2);
    cd (previous_dir);
end