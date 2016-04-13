function deleteAllTempsCreated
    previous_dir = pwd;
    cd (tempdir);

    delete *.xlsx
    delete *.mat
    delete *.jpg
    cd(previous_dir);
end