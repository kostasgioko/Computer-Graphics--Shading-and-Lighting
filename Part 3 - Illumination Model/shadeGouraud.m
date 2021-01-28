function Y = shadeGouraud(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X)
    %This function colors the triangle using color interpolation.
        
    %Calculate the color of the vertices.
    CA = ambientLight(ka(:, 1), Ia) + diffuseLight(Pc, Vn(:, 1), kd(:, 1), S, I0) + specularLight(Pc, Vn(:, 1), C, ks(:, 1), ncoeff, S, I0);
    CB = ambientLight(ka(:, 2), Ia) + diffuseLight(Pc, Vn(:, 2), kd(:, 2), S, I0) + specularLight(Pc, Vn(:, 2), C, ks(:, 2), ncoeff, S, I0);
    CC = ambientLight(ka(:, 3), Ia) + diffuseLight(Pc, Vn(:, 3), kd(:, 3), S, I0) + specularLight(Pc, Vn(:, 3), C, ks(:, 3), ncoeff, S, I0);
    
    %Form the color array.
    C = [CA'; CB'; CC'];
    
    %Paint the triangle using triPaintGouraud.
    Y = triPaintGouraud(X, p', C);
    
end

