% Assignment 2 - Demo
clc
clear

%% Load data. 
load('hw2.mat');
V = V';

%% Initial position. 
% Photograph object with photographObject.
[P2d, D] = photographObject(V, M, N, H, W, w, cv, ck, cu);

% Paint object with ObjectPainter with gouraud.
I0 = paintObject(P2d, F, C, D, 'Gouraud');

% Display the object.
figure
imshow(I0);

% Save result.
imwrite(I0, '0.jpg');

%% Step 1 - Translate by t1.
% Apply translation.
V = affinetrans(V, eye(3), t1);

% Photograph object with photographObject.
[P2d, D] = photographObject(V, M, N, H, W, w, cv, ck, cu);

% Paint object with ObjectPainter with gouraud.
I1 = paintObject(P2d, F, C, D, 'Gouraud');

% Display the object.
figure
imshow(I1);

% Save result.
imwrite(I1, '1.jpg');

%% Step 2 - Rotate by theta around given axis.
% Apply rotation.
g_unit = g/norm(g);
R = rotmat(theta, g_unit);
V = affinetrans(V, R, zeros(3,1));

% Photograph object with photographObject.
[P2d, D] = photographObject(V, M, N, H, W, w, cv, ck, cu);

% Paint object with ObjectPainter with gouraud.
I2 = paintObject(P2d, F, C, D, 'Gouraud');

% Display the object.
figure
imshow(I2);

% Save result.
imwrite(I2, '2.jpg');

%% Step 3 - Translate by t2.
% Apply translation.
V = affinetrans(V, eye(3), t2);

% Photograph object with photographObject.
[P2d, D] = photographObject(V, M, N, H, W, w, cv, ck, cu);

% Paint object with ObjectPainter with gouraud.
I3 = paintObject(P2d, F, C, D, 'Gouraud');

% Display the object.
figure
imshow(I3);

% Save result
imwrite(I3, '3.jpg');
