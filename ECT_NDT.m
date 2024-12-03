% Eddy Current Simulation for Crack Detection

clc;
clear;
close all;

% Material properties
sigma = 5.8e7; % Conductivity of copper (S/m)
mu = 4*pi*1e-7; % Permeability of free space (H/m)
f = 1e4; % Frequency of alternating current (Hz)
omega = 2*pi*f; % Angular frequency
A = 1e-3; % Current amplitude (A)

% Geometry of the material (cylinder)
radius = 1e-3; % Material radius in meters (1 mm)
length = 0.1; % Material length in meters (10 cm)

% Model the crack dimensions
crack_length = 5e-3; % Crack length in meters (5 mm)
crack_depth = 0.2e-3; % Crack depth in meters (0.2 mm)

% Eddy current penetration depth calculation (simplified model)
skin_depth = sqrt(2/(omega * mu * sigma)); % Skin depth (m)

% Define mesh for the material
grid_size = 100;
x = linspace(-radius, radius, grid_size); % X-axis
y = linspace(-radius, radius, grid_size); % Y-axis
[X, Y] = meshgrid(x, y); % Create mesh grid

% Apply a surface crack (represented by a reduced conductivity region)
Z = zeros(size(X)); % Material domain initialized to zero
crack_region = (X > -crack_length/2 & X < crack_length/2) & (Y < crack_depth);
Z(crack_region) = 1; % Crack area set to a lower conductivity (simulated)

% Eddy current model for surface interaction
% Using a simplified formula for impedance change based on crack size
impedance_without_crack = 50; % Ohms (example baseline impedance)
impedance_with_crack = impedance_without_crack + 2; % Example increase in impedance

% Display the surface with and without crack
figure;

% Plot the surface with crack (2D representation)
subplot(2,2,1);
imagesc(x, y, Z); 
colorbar;
colormap('jet');
title('Surface with Crack (Material)');
xlabel('X (m)');
ylabel('Y (m)');
axis equal;

% Plot the surface without crack (2D representation)
subplot(2,2,2);
Z_no_crack = zeros(size(X)); % No crack, pure material
imagesc(x, y, Z_no_crack);
colorbar;
colormap('jet');
title('Surface without Crack (Material)');
xlabel('X (m)');
ylabel('Y (m)');
axis equal;

% 3D Visualization of Crack and Eddy Current Interaction
subplot(2,2,3);
Z3D = abs(sin(X .* Y)); % Simulate the electromagnetic field (simplified)
Z3D_with_crack = Z3D;
Z3D_with_crack(crack_region) = Z3D_with_crack(crack_region) * 1.5; % Highlight eddy current interaction with crack

% Create 3D surface plot with crack interaction
surf(X, Y, Z3D_with_crack, 'EdgeColor','none');
title('3D Eddy Current Interaction with Crack');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Electromagnetic Field Intensity');
colorbar;
colormap('jet');
shading interp;
view(3); % Rotate to 3D view

% Plot current impedance change as a bar graph
subplot(2,2,4);
bar([impedance_without_crack, impedance_with_crack], 'FaceColor', [0 0.5 0.5]);
set(gca, 'xticklabel', {'Without Crack', 'With Crack'});
title('Impedance Change due to Crack');
ylabel('Impedance (Ohms)');
grid on;

% Display the results
disp(['Impedance without crack: ', num2str(impedance_without_crack), ' Ohms']);
disp(['Impedance with crack: ', num2str(impedance_with_crack), ' Ohms']);
disp(['Impedance change due to crack: ', num2str(impedance_with_crack - impedance_without_crack), ' Ohms']);
 