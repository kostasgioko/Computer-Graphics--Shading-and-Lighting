# Part 1 - Polygonal Shading
The goal of this part is to paint the polygons that compose the virtual object. In this implementation the polygons are assumed to be triangles.

# Shading Techniques
There are two shading techniques supported: Flat Shading and Gouraud Shading.

1) Flat Shading paints each pixel of the triangle with the same color, the average of the color of its vertices.

2) Gouraud Shading calculates the color of each pixel using linear interpolation between the color of the three vertices.

