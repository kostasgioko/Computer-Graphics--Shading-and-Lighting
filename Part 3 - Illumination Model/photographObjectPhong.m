function Im = photographObjectPhong(shader, f, C, K, u, bC, M, N, H, W, R, F, S, ka, kd, ks, ncoeff, Ia, I0)
    %This function creates the image of a 3D object.
    
    % 1) Initialize canvas.
    Im = zeros(M, N, 3);
    for i = 1 : 3
       Im(:, :, i) = bC(i); 
    end
    
    % 2) Calculate the normal vectors of the vertices.
    Normals = findVertNormals(R, F);
    
    % 3) Get the projections and depths of the vertices.
    [P, D] = projectKu(f, C, K, u, R);  
        
    % 4) Rasterize the projections of the vertices.
    P2d = rasterize(P, M, N, H, W);
    
    % 5) Sort the triangles in descending depth.
    %Get the number of triangles.
    [~, T] = size(F);
    
    D_triangle = zeros(T,1);
    %For each triangle.
    for i = 1 : T
        
        %Find its depth.
        D_triangle(i) = ( D(F(1, i)) + D(F(2, i)) + D(F(3, i)))/3;        
        
    end
    
    %Get the indices for descending order;
    [~, Order] = sort(D_triangle, 'descend');
        
    %Sort the triangles in descending depth.
    F = F(:, Order);
    
    % 6) Paint the triangles.
    %For each triangle.
    for i = 1 : T
        %Check if all of the vertices are inside the canvas.
        if ~( ( ( abs(P(1, F(1, i))) > W/2 ) || ( abs(P(2, F(1, i))) > H/2 ) ) ...
            || ( ( abs(P(1, F(2, i))) > W/2 ) || ( abs(P(2, F(2, i))) > H/2 ) ) ...
            || ( ( abs(P(1, F(3, i))) > W/2 ) || ( abs(P(2, F(3, i))) > H/2 ) ) )
        
            %Form the vertex array.
            p = [P2d(:, F(1, i)) P2d(:, F(2, i)) P2d(:, F(3, i))];

            %Form the normal vector array.
            Vn = [Normals(:, F(1, i)) Normals(:, F(2, i)) Normals(:, F(3, i))];

            %Calculate the center of gravity of the triangle.
            Pc = ( R(:, F(1, i)) + R(:, F(2, i)) + R(:, F(3, i)) )/3;

            %Form the lighting coefficient arrays.
            ka_triangle = [ka(:, F(1, i)) ka(:, F(2, i)) ka(:, F(3, i))];
            kd_triangle = [kd(:, F(1, i)) kd(:, F(2, i)) kd(:, F(3, i))];
            ks_triangle = [ks(:, F(1, i)) ks(:, F(2, i)) ks(:, F(3, i))];

            %Paint the triangle with the correct method.
            if shader == 1
                %Use shadeGouraud.
                Im = shadeGouraud(p, Vn, Pc, C, S, ka_triangle, kd_triangle, ks_triangle, ncoeff, Ia, I0, Im);

            elseif shader == 2
                %Use shadePhong.
                Im = shadePhong(p, Vn, Pc, C, S, ka_triangle, kd_triangle, ks_triangle, ncoeff, Ia, I0, Im);

            end
        end
    end
    
end