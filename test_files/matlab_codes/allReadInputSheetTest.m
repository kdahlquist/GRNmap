function test_results = allReadInputSheetTest
    global GRNstruct
    
    starting_dir = pwd;
    all_files = {};
    data_samples             = dir([[pwd '/../data_samples/'], '*.xlsx']);
    cd([pwd '/../data_samples/'])
    for k = find(not([data_samples.isdir]))
        all_files{end + 1} = {which(data_samples(k).name)};
    end
    cd(starting_dir)

    deleted_strains_tests    = dir([[pwd '/../deleted_strains_tests/'], '*.xlsx']);
    cd([pwd '/../deleted_strains_tests/'])
    for k = find(not([deleted_strains_tests.isdir]))
        all_files{end + 1} = {which(deleted_strains_tests(k).name)};
    end
    cd(starting_dir)

    MSE_tests    = dir([[pwd '/../MSE_tests/'], '*.xlsx']);
    cd([pwd '/../MSE_tests/'])
    for k = find(not([MSE_tests.isdir]))
        all_files{end + 1} = {which(MSE_tests(k).name)};
    end
    cd(starting_dir)

    math_L_curve_tests       = dir([[pwd '/../perturbation_tests/to_be_reformatted/math_L-curve/'], '*.xlsx']);
    cd([pwd '/../perturbation_tests/to_be_reformatted/math_L-curve/'])
    for k = find(not([math_L_curve_tests.isdir]))
        all_files{end + 1} = {which(math_L_curve_tests(k).name)};
    end
    cd(starting_dir)

    seaver_L_curve_tests     = dir([[pwd '/../perturbation_tests/to_be_reformatted/seaver_L-curve/'], '*.xlsx']);
    cd([pwd '/../perturbation_tests/to_be_reformatted/seaver_L-curve/'])
    for k = find(not([seaver_L_curve_tests.isdir]))
        all_files{end + 1} = {which(seaver_L_curve_tests(k).name)};
    end
    cd(starting_dir)

    estimation_tests         = dir([[pwd '/../estimation_tests/'], '*.xlsx']);
    cd([pwd '/../estimation_tests/'])
    for k = find(not([estimation_tests.isdir]))
        all_files{end + 1} = {which(estimation_tests(k).name)};
    end
    cd(starting_dir)

    forward_tests            = dir([[pwd '/../forward_tests/'], '*.xlsx']);
    cd([pwd '/../forward_tests/'])
    for k = find(not([forward_tests.isdir]))
        all_files{end + 1} = {which(forward_tests(k).name)};
    end
    cd(starting_dir)

    test_results = [];

    for file = 1:length(all_files)
       GRNstruct = struct();
       GRNstruct.inputFile = all_files{file}{1};
       test_results = [test_results, runtests('readInputSheetTest')];
    end
end