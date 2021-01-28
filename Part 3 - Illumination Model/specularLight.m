function I = specularLight(P, N, C, ks, ncoeff, S, I0)
    %This function calculates the illumination of a point caused by specular reflection.

    %Get the number of light sources.
    [~, n] = size(S);
    
    %Initialize the intensity vector.
    I = zeros(3,1);
    
    %Find the coordinates of the V vector between P and C.
    V = (C - P)/ norm(C - P);
    
    %For each light source.
    for i = 1 : n
        %Find the coordinates of the L vector between P and S.
        L = ( S(:, i) - P )/( norm( S(:, i) - P ) );
        
        %Calculate the cosine of the angle.
        cos = dot(2*N*dot(N, L) - L, V);
        
        %The point is illuminated only if the cosine is positive.
        if cos > 0
            %Add the intensity from this light source to the total intensity.
            I = I + I0(:, i) .* ks * cos^ncoeff;
        end
    end
end

