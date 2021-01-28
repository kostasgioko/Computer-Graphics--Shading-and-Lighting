function [P, D] = projectCamera(w, cv, cx, cy, p)
    %This function calculates the projection of P as well as its depth using the coordinate system of the camera.
    
    %Calculate the z-axis of the Camera Coordinate System.
    cz = cross(cx, cy);
    
    %Find the points' coordinates in the CCS.
    p_ccs = systemtrans(p, cx, cy, cz, cv);
    
    %Initialize arrays.
    n = size(p,2);
    P = zeros(2, n);
    D = zeros(n, 1);
    
    %For every point.
    for i = 1 : n
        %Find its projection.
        P(:,i) = w/p_ccs(3,i)*[p_ccs(1,i); p_ccs(2,i)];
        
        %And its depth.
        D(i) = p_ccs(3,i);
    end

end

