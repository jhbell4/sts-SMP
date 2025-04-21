function [] = frameBuilder_with_head(ax,params,state,opacity,outline,grayscale,line_show)

if nargin<4
    opacity = 1;
    outline = false;
    grayscale = false;
end
if nargin < 7
    line_show = false;
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

%rJoint = 0.045;
rHip = 0.085;
rKnee = 0.047;
rAnkle = 0.035;

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

if line_show
    line_thick = 1.5;
    anno_length = 0.35;%m
    plot(ax,[xA,xA],[yA,yA+anno_length],'k:','LineWidth',line_thick);
    hold on
    plot(ax,[xB,xB-anno_length*sin(th1)],[yB,yB+anno_length*cos(th1)],...
        'k:','LineWidth',line_thick);
    plot(ax,[xC,xC-anno_length*sin(th1+th2)],[yC,yC+anno_length*cos(th1+th2)],...
        'k:','LineWidth',line_thick);
end

% Plotting
%basePiece(ax,xA,yA,opacity,outline);
footPiece(ax,xA,yA,0,w,h,opacity,outline,grayscale);
hold on;
%linkPiece(ax,xA,yA,xB,yB,opacity,outline,grayscale);
%linkPiece(ax,xB,yB,xC,yC,opacity,outline,grayscale,2*rJoint);
trapPiece(ax,xA,yA,xB,yB,rAnkle,rKnee,opacity,outline,grayscale);
trapPiece(ax,xB,yB,xC,yC,rKnee,rHip,opacity,outline,grayscale);
HATPiece(ax,xC,yC,th1+th2+th3,opacity,outline,grayscale);
%linkPiece(ax,xC,yC,xD,yD,opacity,outline,grayscale,3.5*rJoint);
circle2(ax,xA,yA,rAnkle,opacity,outline,grayscale);
circle2(ax,xB,yB,rKnee,opacity,outline,grayscale);
circle2(ax,xC,yC,rHip,opacity,outline,grayscale);

if line_show
    plot(ax,[xA,xB,xC,xD],[yA,yB,yC,yD],'w-','LineWidth',line_thick);
end

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

function h = trapPiece(ax,x1,y1,x2,y2,r1,r2,op,out,gs)

len = sqrt((x2-x1)^2 + (y2-y1)^2 );
rotAngle = atan2(y2-y1,x2-x1);

if out
    style = '-';
else
    style = 'none';
end
if gs
    col = [0, 0, 0];
else
    col = [0, 0.5, 0.6];
end

sin_a = (r2-r1)/len;
cos_a = sqrt(len^2 - (r2-r1)^2)/len;

xA = -r2*cos_a;
yA = len - r2*sin_a;
xB = r2*cos_a;
yB = len - r2*sin_a;
xC = r1*cos_a;
yC = -r1*sin_a;
xD = -r1*cos_a;
yD = -r1*sin_a;

h = hgtransform('Parent',ax);
shape = patch(ax,[xA,xB,xC,xD,xA],[yA,yB,yC,yD,yA],col,...
    'LineStyle',style,'FaceAlpha',op);
set(shape,'Parent',h);
transMat = makehgtform('translate',[x1 y1 0])*makehgtform('zrotate',rotAngle-pi/2);
set(h,'Matrix',transMat);
drawnow;

end

function h = HATPiece(ax,x1,y1,rotAngle,op,out,gs)

if out
    style = '-';
else
    style = 'none';
end
if gs
    col = [0, 0, 0];
else
    col = [0, 0.5, 0.6];
end
h = hgtransform('Parent',ax);
coords = HAT_coords();
shape = patch(ax,coords(:,1).',coords(:,2).',col,...
    'LineStyle',style,'FaceAlpha',op);
set(shape,'Parent',h);
transMat = makehgtform('translate',[x1 y1 0])*makehgtform('zrotate',rotAngle);
set(h,'Matrix',transMat);
drawnow;

end

function coords = HAT_coords()

coords = [0.0625918000000000	-0.0521709000000000
0.0779209000000000	-0.0366855000000000
0.0913496000000000	-0.0157705000000000
0.108563000000000	0.0245557000000000
0.123412000000000	0.0655752000000000
0.128289000000000	0.0908145000000000
0.130446000000000	0.119217000000000
0.129283000000000	0.220910000000000
0.130492000000000	0.317445000000000
0.129882000000000	0.356522000000000
0.126654000000000	0.384889000000000
0.120514000000000	0.403750000000000
0.108261000000000	0.423961000000000
0.0580029000000000	0.490536000000000
0.0505391000000000	0.500964000000000
0.0467402000000000	0.510657000000000
0.0461299000000000	0.519204000000000
0.0482061000000000	0.528127000000000
0.0535312000000000	0.543324000000000
0.0709980000000000	0.580302000000000
0.0768086000000000	0.579936000000000
0.0842002000000000	0.580015000000000
0.0913418000000000	0.580491000000000
0.0986465000000000	0.581745000000000
0.104927000000000	0.584124000000000
0.110324000000000	0.587235000000000
0.114585000000000	0.590860000000000
0.116783000000000	0.594214000000000
0.117547000000000	0.597108000000000
0.117408000000000	0.599850000000000
0.117062000000000	0.603869000000000
0.117261000000000	0.609158000000000
0.119018000000000	0.620805000000000
0.120578000000000	0.629169000000000
0.120879000000000	0.634764000000000
0.120557000000000	0.639503000000000
0.119789000000000	0.644017000000000
0.122344000000000	0.644105000000000
0.126966000000000	0.644416000000000
0.129816000000000	0.645445000000000
0.132519000000000	0.648238000000000
0.133100000000000	0.651003000000000
0.132276000000000	0.654107000000000
0.125455000000000	0.665756000000000
0.117307000000000	0.677016000000000
0.113475000000000	0.686350000000000
0.111815000000000	0.712675000000000
0.109842000000000	0.725704000000000
0.105585000000000	0.740207000000000
0.101015000000000	0.748870000000000
0.0928047000000000	0.757728000000000
0.0819277000000000	0.764680000000000
0.0551016000000000	0.776289000000000
0.0413926000000000	0.779906000000000
0.0283779000000000	0.781236000000000
0.0108662000000000	0.780169000000000
-0.00616211000000000	0.775623000000000
-0.0200625000000000	0.768337000000000
-0.0309590000000000	0.759322000000000
-0.0416475000000000	0.745333000000000
-0.0529736000000000	0.721527000000000
-0.0572998000000000	0.708700000000000
-0.0589561000000000	0.697142000000000
-0.0589561000000000	0.688419000000000
-0.0550977000000000	0.676729000000000
-0.0496787000000000	0.666706000000000
-0.0432441000000000	0.654232000000000
-0.0377578000000000	0.640986000000000
-0.0321357000000000	0.622849000000000
-0.0286328000000000	0.604860000000000
-0.0277207000000000	0.586068000000000
-0.0308408000000000	0.562057000000000
-0.0393730000000000	0.535028000000000
-0.0516113000000000	0.511679000000000
-0.0648193000000000	0.485790000000000
-0.0735898000000000	0.461420000000000
-0.0805420000000000	0.431335000000000
-0.0821680000000000	0.406898000000000
-0.0778096000000000	0.379130000000000
-0.0680000000000000	0.340285000000000
-0.0500000000000000	0.251261000000000
-0.0470000000000000	0.213489000000000
-0.0465000000000000	0.191843000000000
-0.0465000000000000	0.175745000000000
-0.0468000000000000	0.160526000000000
-0.0490000000000000	0.144619000000000
-0.0600000000000000	0.103288000000000
-0.0696113000000000	0.0722051000000000
-0.0790049000000000	0.0393652000000000
-0.0819277000000000	0.0158545000000000
-0.0810117000000000	-0.00406738000000000
-0.0759727000000000	-0.0232588000000000
-0.0682598000000000	-0.0375303000000000
-0.0571602000000000	-0.0498779000000000
-0.0428877000000000	-0.0597764000000000
-0.0252188000000000	-0.0670010000000000
-0.00938086000000000	-0.0702939000000000
0.00895410000000000	-0.0710605000000000
0.0271357000000000	-0.0687100000000000
0.0457656000000000	-0.0625205000000000
0.0625918000000000	-0.0521709000000000];

end