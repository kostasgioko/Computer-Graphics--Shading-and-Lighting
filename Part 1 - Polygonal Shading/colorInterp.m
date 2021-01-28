function color = colorInterp(A, B, a, b, x)
    
    %Color interpolation in the x axis.
    
    lambda = (x - b)/(a - b);
    color = lambda*A + (1 - lambda)*B;
    
end

