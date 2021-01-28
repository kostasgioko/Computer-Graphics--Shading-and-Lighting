function Prast = rasterize(P, M, N, H, W)
    %This function rasterizes the image from the camera.

    %Convert to NDC space.
    Pnorm_x = (P(1, :) + W/2)/W;
    Pnorm_y = (P(2, :) + H/2)/H;
    
    %Convert to raster space.    
    Prast_x = floor((1 - Pnorm_x) * N);
    Prast_y = floor((1 - Pnorm_y) * M);
    
    Prast = [Prast_x; Prast_y];
        
end

