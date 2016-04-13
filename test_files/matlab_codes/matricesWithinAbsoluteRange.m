function result = matricesWithinAbsoluteRange(expected, actual, threshold)
    if (~all(size(expected)==size(actual))) 
        result = false;
        return;
    end
    result = all(abs(expected(:) - actual(:)) <= abs(threshold));
end