function [] = draw_COM_mini(ax,COM_pos)

% Set Radius (in m)
COM_marker_r = 0.015;
border_fraction = 1.03;

% Draw Black Circle
circle2(ax,COM_pos(1),COM_pos(2),COM_marker_r*border_fraction,1,false,true);

% Draw White Wedges
white_angles_1 = linspace(pi/2,pi,101);
white_angles_2 = linspace(3*pi/2,2*pi,101);

white_1_x = [0,COM_marker_r*cos(white_angles_1),0] + COM_pos(1);
white_1_y = [0,COM_marker_r*sin(white_angles_1),0] + COM_pos(2);
white_2_x = [0,COM_marker_r*cos(white_angles_2),0] + COM_pos(1);
white_2_y = [0,COM_marker_r*sin(white_angles_2),0] + COM_pos(2);

patch(ax,white_1_x,white_1_y,[1,1,1]);
patch(ax,white_2_x,white_2_y,[1,1,1]);

end

function h = circle2(ax,x,y,r,op,out,gs)
d = r*2;
px = x-r;
py = y-r;
if out
    style = '-';
else
    style = 'none';
end
if gs
    col = [0, 0, 0, op];
else
    col = [0, 0.1, 0.5, op];
end
h = rectangle(ax,'Position',[px py d d],'Curvature',[1,1],...
    'LineStyle',style,'FaceColor',col);
daspect([1,1,1])
end

