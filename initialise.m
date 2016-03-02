function [scene] = initialise()
close all;
rng('shuffle');

scene = struct(...
    'width',700,...
    'height',500);

fig = figure('position',[500 300 scene.width scene.height]);
set(fig,'menubar','none');
set(fig,'resize','off');
axis([0 scene.width 0 scene.height]);
hold on;

scene.fig = fig;
end