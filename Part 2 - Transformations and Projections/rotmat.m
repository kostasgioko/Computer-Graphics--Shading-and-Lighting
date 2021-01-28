function R = rotmat(theta, u)
    %This function calculates the rotation matrix of angle theta around the axis defined by u.
    
    %Save the values so they are only calculated once.
    cos_theta = cos(theta);
    sin_theta = sin(theta);    
    ux = u(1);
    uy = u(2);
    uz = u(3);
    
    %Rotation matrix.
    R = [(1 - cos_theta)*ux^2 + cos_theta, (1 - cos_theta)*ux*uy - sin_theta*uz, (1 - cos_theta)*ux*uz + sin_theta*uy;
         (1 - cos_theta)*ux*uy + sin_theta*uz, (1 - cos_theta)*uy^2 + cos_theta, (1 - cos_theta)*uy*uz - sin_theta*ux;
         (1 - cos_theta)*ux*uz - sin_theta*uy, (1 - cos_theta)*uz*uy + sin_theta*ux, (1 - cos_theta)*uz^2 + cos_theta];
     
end

