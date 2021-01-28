%Load data.
load duck_hw1.mat;

%Paint the object using Gouraud shading.
I = paintObject(V_2d, F, C, D, 'Gouraud');

%Show and save the image.
imshow(I);
imwrite(I, 'DuckGouraud.bmp');