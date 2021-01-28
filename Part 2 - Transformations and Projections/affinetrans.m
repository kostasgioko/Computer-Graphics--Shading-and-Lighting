function cq = affinetrans(cp, R, ct)
    %This function rotates P based on R and then displaces it based on ct.
    cq = R*cp + ct;
        
end

