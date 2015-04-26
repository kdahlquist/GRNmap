function string = stringify (num)
    
    if isa (num, 'numeric')
        string = num2str (num);
    else
       string = num;
    end 

end