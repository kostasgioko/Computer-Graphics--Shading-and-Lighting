function Y = triPaintFlat(X, V, C)
    %This function paints a triangle with a flat color.

    %-------------------------Initializations------------------------------

    %Copy X into Y.
    Y = X;   
    
    %The triangle color is the mean of each vertex color.
    R = mean(C(:,1));
    G = mean(C(:,2));
    B = mean(C(:,3));
    
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
        for x = round(min(V(:,1))) : round(max(V(:,1)))
            Y(V(1,2),x,:) = [R G B];
        end
        
    %If it is a normal triangle.    
    else   
    
        %For each scan line.
        for y = ymin : ymax

            %Sort active_points in terms of x.
            active_points = sortrows(active_points, 1);

            %Start of line y scanning.
            
            %If the top line is horizontal don't fill it.
            if ~(y == ymin && top_edge_horizontal)
                %Otherwise fill the scan line between the active points
                %with the smallest and biggest x coordinate.
                
                %(Since I am working with triangles, there should be two 
                %active points at most. However when one edge is added, the 
                %one that should be removed, will be removed in the next 
                %iteration. This means that for one scanline there will be
                %three active edges and three active points with two of
                %them being the same point. To circumvent this I fill
                %between the points with the smallest and biggest x
                %coordinate).
                
                for x = floor(active_points(1,1)) : floor(active_points(size(active_points,1),1))
                    %Color each pixel.
                    Y(y,x,:) = [R G B];
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
   
end

