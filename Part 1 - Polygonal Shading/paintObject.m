function I = paintObject(V, F, C, D, painter)
    
    %Initialize canvas.
    M = 1200;
    N = 1200;
    I = ones(M,N,3);
    
    %Get the number of triangles.
    K = size(F,1);
    
    %Calculate the depth of each triangle and sort the triangles in F in
    %descending depth.
    D_triangle = zeros(K,1);
    for k = 1 : K
        %Find the depth of each triangle.
        D_triangle(k) = ( D(F(k,1)) + D(F(k,2)) + D(F(k,3)))/3;
    end
    
    %Sort them in descending order;
    [~, T] = sort(D_triangle, 'descend');
        
    %Sort the triangles in descending depth.
    F = F(T,:);
    
    %Paint each triangle.
    for k = 1 : K
        %Form the vertex array for the current triangle.
        V_triangle = [V(F(k,1), :); V(F(k,2), :); V(F(k,3), :)];
        
        %Form the vertex color array for the current triangle.
        C_triangle = [C(F(k,1), :); C(F(k,2), :); C(F(k,3), :)];
        
        %Paint the triangle with the correct method.
        if strcmp(painter, 'Flat')
            I = triPaintFlat(I, V_triangle, C_triangle);
        elseif strcmp(painter, 'Gouraud')
            I = triPaintGouraud(I, V_triangle, C_triangle);
        end
    end
end

