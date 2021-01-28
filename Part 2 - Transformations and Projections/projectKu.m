function [P, D] = projectKu(w, cv, ck, cu, p)
    %This function calculates the projection of P as well as its depth using the target and the up vector of the camera.
    
    %Find the axes of the CCS.
    cz = (ck - cv)/norm(ck - cv);
    
    t = cu - dot(cu, cz) * cz;
    cy = t/norm(t);
    
    cx = cross(cy, cz);
    
    %Use the projectCamera function to find the projections and depths.
    [P, D] = projectCamera(w, cv, cx, cy, p);

end

