%Load data.
load duck_hw1.mat;

%Paint the object using flat shading.
I = paintObject(V_2d, F, C, D, 'Flat');

%Show and save the image.
imshow(I);
imwrite(I, 'DuckFlat.bmp');