clear
clc

fig_num = 0;

fig_num = fig_num + 1;
figure(fig_num)
clf
hold on

MarkerSize = 40;
dark_blue = [0, 0, 255]/255;
color = dark_blue;

x = [1, 2, 3];
y = [1, 2, 3];

plot(x, y, 's', 'MarkerSize', MarkerSize, 'MarkerEdgeColor', color, 'MarkerFaceColor', color)




