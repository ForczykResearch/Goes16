function result = is_leap_year(year)
    if year<=0
        error("year is not a positive integer");
    elseif(mod(year,4))~=0 || (mod(year,4)==0 && mod(year,100)==0 && mod(year,400)~=0)
        result=0;
    else 
        result=1; 
    end
end