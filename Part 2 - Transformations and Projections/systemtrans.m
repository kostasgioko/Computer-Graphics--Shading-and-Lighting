function dp = systemtrans(cp, b1, b2, b3, c0)
    %This function transforms the coordinates of P between coordinate systems.
    
    %Rotation matrix between systems.
    R = [b1, b2, b3];
    
    %Coordinate transformation.
    dp = R'*(cp - c0);
end

