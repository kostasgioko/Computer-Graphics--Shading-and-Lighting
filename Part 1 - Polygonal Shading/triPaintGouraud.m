function Y = triPaintGouraud(X, V, C)
    %This function paints a triangle with Gouraud shading.

    %-------------------------Initializations------------------------------

    %Copy X into Y.
    Y = X;     
    
    %Find the slope, the minimums and maximums of each edge.
    m = zeros(3,1);
    xk_mins = zeros(3,1);
    xk_maxs = zeros(3,1);
    yk_mins = zeros(3,1);
    yk_maxs = zeros(3,1);
    j = 3;
    
    %For each edge.
    for i = 1 : 3
        %Calculate slope.
        if V(i,1) == V(j,1)
            m(j) = inf;
        else
            m(j) = (V(i,2) - V(j,2))/(V(i,1) - V(j,1));
        end
        
        %Find minimums and maximums.
        xk_mins(j) = min([V(i,1), V(j,1)]);
        xk_maxs(j) = max([V(i,1), V(j,1)]);
        yk_mins(j) = min([V(i,2), V(j,2)]);
        yk_maxs(j) = max([V(i,2), V(j,2)]);
        
        %Update j.
        j = i;      
        
    end
    
    %Find the minimum and maximum y as well as the maximum x of the triangle.
    ymin = min(yk_mins);
    ymax = max(yk_maxs);
    xmax = max(xk_maxs);
    
    %Find the list of active edges and active points for the line y = ymin.
    active_edges = [];
    active_points = [];
    top_edge_horizontal = false;
    j = 3;
    
    %For each edge.
    for i = 1 : 3
       if yk_mins(j) == ymin
           
           %If it is horizontal.
           if m(j) == 0
               %Raise a flag.
               top_edge_horizontal = true;
               
           %If it is vertical and to the right, I shift the active points 
           %one pixel to the left, to follow the convention about
           %conflicting lines.
           elseif (m(j) == inf && xk_maxs(j) == xmax)
               %Add edge.
               active_edges = [active_edges; j];

               %Find lowest point of edge and add it.
               if V(j,2) == yk_mins(j)
                   active_points = [active_points; V(j,1) - 1, V(j,2), j];
               elseif V(i,2) == yk_mins(j)
                   active_points = [active_points; V(i,1) - 1, V(i,2), j];
               end
               
           %In any other case I just add the edge and its lowest point to
           %the respective lists.
           else
               %Add edge.
               active_edges = [active_edges; j];

               %Find lowest point of edge and add it.
               if V(j,2) == yk_mins(j)
                   active_points = [active_points; V(j,1), V(j,2), j];
               elseif V(i,2) == yk_mins(j)
                   active_points = [active_points; V(i,1), V(i,2), j];
               end
           end
       end
       
       %Update j;
       j = i;
    end
    
    %----------------------------Main part---------------------------------
    
    %If the whole triangle is a horizontal line.
    if (isempty(active_edges) && isempty(active_points))
        %Sort the vertices.
        V = sortrows(V, 1);
        
        %Color between the left and middle vertices.
        for x = V(1,1) : V(2,1)            
            Y(V(1,2),x,:) = colorInterp(C(1,:), C(2,:), V(1,1), V(2,1), x);
        end
        
        %Color between the middle and right vertices.
        for x = V(2,1) + 1 : V(3,1)            
            Y(V(1,2),x,:) = colorInterp(C(2,:), C(3,:), V(2,1), V(3,1), x);
        end
        
    %If it is a normal triangle.    
    else   
    
        %For each scan line.
        for y = ymin : ymax
            
            %Find the colors of A and B through interpolation.
            colorsAB = [];
            counter = 0;
            
            %For each  active edge.
            for i = 1 : size(active_edges,1)
               edge_number = active_edges(i); 
               
               %The indices for the edge vertices.
               index1 = edge_number;
               if edge_number == 3
                  index2 = 1; 
               else
                   index2 = edge_number + 1;
               end
               
               
               %When there are three active edges, the active points are
               %actually two, so I have to skip the second one that
               %corresponds to the same active point.
               if size(active_edges,1) == 3   
                   if ( y == V(index1,2) || y == V(index2,2) )
                       counter = counter + 1;
                   end                          
               end
               
               %Find the active point of the edge.
               for k = 1 : size(active_points)
                  if active_points(k,3) == edge_number
                      active_point = active_points(k,1);
                  end
               end
               
               
               %If the edge is horizontal, A and B are the vertices of the 
               %edge. I save their x coordinate so I can distinguish them.
               if V(index1,2) == V(index2,2)
                   colorsAB = [V(index2,1) C(index2,:); V(index1,1) C(index1,:)];
                   %The other edges don't matter in this case so exit the
                   %loop.
                   break;
               %Otherwise.    
               else
                   %If this isn't an unwanted edge.
                   if counter < 2
                       %Find the colors of A and B  through interpolation.
                       lambda = (y - V(index1,2))/(V(index2,2) - V(index1,2));
                       colorsAB = [colorsAB; active_point lambda*C(index2,:) + (1 - lambda)*C(index1,:)];
                   end
               end
               
            end
            
            %Sort the colorsAB in terms of their x coordinate and assign
            %CA and CB.
            if size(colorsAB) ~= 0
                colorsAB = sortrows(colorsAB);
                CA = colorsAB(1, 2:4);
                CB = colorsAB(2, 2:4);
            end

            %Sort active_points in terms of x.
            active_points = sortrows(active_points, 1);

            %Start of line y scanning.
            
            %If the top line is horizontal don't fill it.
            if ~(y == ymin && top_edge_horizontal)
                %Otherwise fill the scan line between the active points
                %with the smallest and biggest x coordinate.              
                for x = floor(active_points(1,1)) : floor(active_points(size(active_points,1),1))
                    %To find the color interpolate between A and B.
                    Y(y,x,:) = colorInterp(CA, CB, colorsAB(1,1), colorsAB(2,1), x);
                end
            end

            %End of line y scanning.

            %Update the active edges and active points list.
            j = 3;
            points_added = 0;

            %For each edge.
            for i = 1 : 3
               %Check if it needs to be added. 
               if yk_mins(j) == y + 1
                   %If it is vertical and to the right.
                   if (m(j) == inf && xk_maxs(j) == xmax)
                       %Add edge.
                       active_edges = [active_edges; j];

                       %Find lowest point of edge and add it.
                       if V(j,2) == yk_mins(j)
                           active_points = [active_points; V(j,1) - 1, V(j,2), j];
                       elseif V(i,2) == yk_mins(j)
                           active_points = [active_points; V(i,1) - 1, V(i,2), j];
                       end
                   %If it is a normal edge.    
                   else
                       %Add edge.
                       active_edges = [active_edges; j];

                       %Find lowest point of edge and add it.
                       if V(j,2) == yk_mins(j)
                           active_points = [active_points; V(j,1), V(j,2), j];
                       elseif V(i,2) == yk_mins(j)
                           active_points = [active_points; V(i,1), V(i,2), j];
                       end
                   end
                   
                   %Keep the amount of points added, since I won't update
                   %the x coordinates of the newly added points.
                   points_added = points_added + 1;
                   
               %Check if it needs to be removed.
               elseif yk_maxs(j) == y
                   %Remove edge.
                   active_edges(active_edges == j) = [];

                   %Remove corresponding active point.
                   H = active_points(:,3) == j;
                   active_points (H == 1, :) = [];
               end

               %Update j.
               j = i;
            end

            %Update coordinates of the other active points. The new points
            %will be at the end of the list, so I don't update them.
            for i = 1 : ( size(active_points, 1) - points_added)
               %Add the inverse of the edge slope to the x coordinate.
               active_points(i,1) =  active_points(i,1) + 1/m(active_points(i,3));
               %Increment the y coordinate.
               active_points(i,2) = active_points(i,2) + 1;
            end

        end
        
        
    end
    
    %For some triangles the vertices aren't painted for some reason, so I
    %paint them at the end.
    Y(V(1,2), V(1,1), :) = C(1,:);
    Y(V(2,2), V(2,1), :) = C(2,:);
    Y(V(3,2), V(3,1), :) = C(3,:);
   
end