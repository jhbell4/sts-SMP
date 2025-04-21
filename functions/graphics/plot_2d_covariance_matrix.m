function [] = plot_2d_covariance_matrix(cov_matrix,...
    center_point,Zscore,line_thickness,line_color)
%PLOT_2D_COVARIANCE_MATRIX Plots a 2D covariance matrix as an ellipse,
%centered about a center_point. The directions of the semi-major axes of
%the ellipse are the eigenvectors of the matrix, and the lengths of the
%semi-major axes are equal to the corresponding standard deviations,
%multiplied by the Z-score specified.

%% Default values for optional options
if nargin < 2
    center_point = zeros(2,1);
end
if nargin < 3
    Zscore = 1;
end
if nargin < 3
    Zscore = 1;
end
if nargin < 4
    line_thickness = 0.5;
end
if nargin < 5
    line_color = 'k';
end

%% Throw out bad inputs
if ~isequal(size(cov_matrix),[2,2])
    error('plot_2d_covariance_matrix only plots 2x2 matrices.');
end

if ~isequal(size(center_point),[2,1])
    error('The center point must be a 2x1 vector.');
end

%% Calculate eigendecomposition of covariance matrix
[V,D] = eig(cov_matrix);

V1 = V(:,1);
V2 = V(:,2);
sig1 = sqrt(D(1,1));
sig2 = sqrt(D(2,2));

%% Scale standard deviations by Z-score
a = Zscore*sig1;
b = Zscore*sig2;

%% Prepare for plotting lines
p1a = center_point - a*V1; x1a = p1a(1); y1a = p1a(2);
p1b = center_point + a*V1; x1b = p1b(1); y1b = p1b(2);
p2a = center_point - b*V2; x2a = p2a(1); y2a = p2a(2);
p2b = center_point + b*V2; x2b = p2b(1); y2b = p2b(2);

%% Prepare for plotting ellipse
alpha = atan2(V1(2),V1(1));

x_param = @(r) a*cos(r)*cos(alpha) - b*sin(r)*sin(alpha) + ...
    center_point(1);
y_param = @(r) b*sin(r)*cos(alpha) + a*cos(r)*sin(alpha) + ...
    center_point(2);

%% Plotting
plot([x1a x1b],[y1a y1b],'Color',line_color,'LineWidth',line_thickness);
hold on;
plot([x2a x2b],[y2a y2b],'Color',line_color,'LineWidth',line_thickness);
r_plot_vec = linspace(0,2*pi,101);
plot(x_param(r_plot_vec),y_param(r_plot_vec),'Color',line_color,...
    'LineWidth',line_thickness);

end