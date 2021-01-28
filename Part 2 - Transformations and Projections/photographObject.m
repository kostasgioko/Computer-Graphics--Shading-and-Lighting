function [P2d, D] = photographObject(p, M, N, H, W, w, cv, ck, cu)
    %This function takes the point coordinates from the WCS, finds their camera projections and depths and rasterizes the image.
    
    %Get the point projections and depths.
    [P, D] = projectKu(w, cv, ck, cu, p);
    
    %Rasterize the image.
    P2d = rasterize(P, M, N, H, W);

    %Transpose the arrays so they are in the correct format.
    P2d = P2d';
    D = D';
end

