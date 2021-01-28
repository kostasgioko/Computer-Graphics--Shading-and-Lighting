function Normals = findVertNormals(R, F)
    %This function calculates the normal vector for each vertice of the object.
    
    %Get number of vertices and triangles.
    [~, r] = size(R);
    [~, T] = size(F);
    
    %Initialize Normals array.
    Normals = zeros(3,r);
    
    %For each triangle.
    for i = 1 : T
        %Calculate the normal vector.
        N = cross( R(:, F(2, i)) - R(:, F(1, i)), R(:, F(3, i)) - R(:, F(2, i)));
        
        %Add normal vector to corresponding vertices.
        Normals(:, F(1, i)) = Normals(:, F(1, i)) + N;
        Normals(:, F(2, i)) = Normals(:, F(2, i)) + N;
        Normals(:, F(3, i)) = Normals(:, F(3, i)) + N;
    end
    
    %Normalize the normal vectors of each vertice.
    for i = 1 : r
       Normals(:, i) = Normals(:, i)/norm(Normals(:, i));
    end
end

