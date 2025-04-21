function [] = frameBuilder(ax,params,state,opacity,outline,grayscale)

if nargin<4
    opacity = 1;
    outline = false;
    grayscale = false;
end

%Import parameters
l1 = params.l1;
l2 = params.l2;
l3 = params.l3;
w = params.w;
h = params.h;

%Import state
th1 = state(1,:);
th2 = state(2,:);
th3 = state(3,:);

rJoint = 0.045;

%Find key points and parameters
xA = 0;
yA = 0;
xB = xA - l1*sin(th1);
yB = yA + l1*cos(th1);
xC = xB - l2*sin(th1+th2);
yC = yB + l2*cos(th1+th2);
xD = xC - l3*sin(th1+th2+th3);
yD = yC + l3*cos(th1+th2+th3);
%phiD = th1 + th2 + th3;

% Plotting
%basePiece(ax,xA,yA,opacity,outline);
footPiece(ax,xA,yA,0,w,h,opacity,outline,grayscale);
hold on;
linkPiece(ax,xA,yA,xB,yB,opacity,outline,grayscale);
linkPiece(ax,xB,yB,xC,yC,opacity,outline,grayscale,2*rJoint);
linkPiece(ax,xC,yC,xD,yD,opacity,outline,grayscale,3.5*rJoint);
circle2(ax,xA,yA,rJoint,opacity,outline,grayscale);
circle2(ax,xB,yB,1.5*rJoint,opacity,outline,grayscale);
circle2(ax,xC,yC,2*rJoint,opacity,outline,grayscale);

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

function h = basePiece(ax,x,y,op,out,gs)

w = 0.3;
ha = 0.10;
radius = 0.075;

circRoot = linspace(pi,2*pi,25);
circTrace = [x + radius*cos(circRoot); y + radius*sin(circRoot)]';
boxTrace = [x+w/2,y;x+w/2,y+ha;x-w/2,y+ha;x-w/2,y];
verts = [circTrace;boxTrace];
faces = 1:size(verts,1);
if out
    style = '-';
else
    style = 'none';
end
if gs
    col = [0, 0, 0];
else
    col = [0.4, 0.1, 0.6];
end
h = patch(ax,'Faces',faces,'Vertices',verts,...
    'FaceColor',col,'LineStyle',style,'FaceAlpha',op);

end

function h = linkPiece(ax,x1,y1,x2,y2,op,out,gs,w)

if nargin < 9
    w = 0.08;
end
r = w/2;
px = 0 - r;
py = 0 - r;
len = sqrt((x2-x1)^2 + (y2-y1)^2 ) + 2*r;
rotAngle = atan2(y2-y1,x2-x1);

if out
    style = '-';
else
    style = 'none';
end
if gs
    col = [0, 0, 0, op];
else
    col = [0, 0.5, 0.6, op];
end
h = hgtransform('Parent',ax);
rect = rectangle(ax,'Position',[px py len w],'Curvature',1,...
    'LineStyle',style,'FaceColor',col);
set(rect,'Parent',h);
transMat = makehgtform('translate',[x1 y1 0])*makehgtform('zrotate',rotAngle);
set(h,'Matrix',transMat);
drawnow;

end

function h = footPiece(ax,x,y,phi,parw,parh,op,out,gs)

radius = 0.075;

circRoot = linspace(0,pi,25);
circTrace = [radius*cos(circRoot); radius*sin(circRoot)]';
boxTrace = [-radius, -parh; parw, -parh; parw, -parh/2];
verts = [circTrace;boxTrace];
faces = 1:size(verts,1);

if out
    style = '-';
else
    style = 'none';
end
if gs
    col = [0, 0, 0];
else
    col = [0, 0.4, 0.1];
end
h = hgtransform('Parent',ax);
shape = patch(ax,'Faces',faces,'Vertices',verts,...
    'FaceColor',col,'LineStyle',style,'FaceAlpha',op);
set(shape,'Parent',h);
transMat = makehgtform('translate',[x y 0])*makehgtform('zrotate',phi);
set(h,'Matrix',transMat);
drawnow;

end