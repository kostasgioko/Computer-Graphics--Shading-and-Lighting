function I = diffuseLight(P, N, kd, S, I0)
    %This function calculates the illumination of a point caused by diffuse reflection.
    
    %Get the number of light sources.
    [~, n] = size(S);
    
    %Initialize the intensity vector.
    I = zeros(3,1);
    
    %For each light source.
    for i = 1 : n
        %Find the coordinates of the L vector between P and S.
        L = ( S(:, i) - P )/( norm( S(:, i) - P ) );
        
        %Calculate the cosine of the incidence angle.
        cosa = dot(N, L);
        
        %The point is illuminated only if the cosine is positive.
        if cosa > 0
            %Add the intensity from this light source to the total intensity.
            I = I + I0(:, i) .* kd * cosa;
        end
    end
    
end

