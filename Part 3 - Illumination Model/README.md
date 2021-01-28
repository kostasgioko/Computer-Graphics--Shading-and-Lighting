# Part 3 - Illumination Model

The goal of this part is to replicate lighting effects in the scene. The model implemented is a local illumination model which uses the ambient, diffuse and specular light of the object.

# Shading Models

There are two shading models supported: Gouraud and Phong
1) The Gouraud shader calculates the color of the vertices of the triangle using the full illumination model, and the performs linear interpolation for the color of the other points of the triangle.
2) The Phong shader performs linear interpolation to calculate the required parameters for each point of the triangle, and then uses the full illumination model to calculate its color.

# Demo

The demo shows the object with each individual lighting (ambient, diffuse, specular), as well as with all of them, for both shading models.
