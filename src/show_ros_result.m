clc
clf
clear all
close all
clear figure

pcl = 120;
line_num = 4;
for i=1:line_num
    filepath =  sprintf( '/home/freelings/pointcloud/data/points_%d/original_line_left_%d.txt', pcl, i );
    A = load ( filepath );
    filepath = sprintf( '/home/freelings/pointcloud/data/points_%d/minus_line_left_%d.txt',  pcl, i );
    B = load ( filepath );
    filepath = sprintf( '/home/freelings/pointcloud/data/points_%d/smooth_line_left_%d.txt',  pcl, i );
    C = load ( filepath );
    filepath = sprintf( '/home/freelings/pointcloud/data/points_%d/original_line_right_%d.txt',  pcl, i );
    D = load ( filepath );
    filepath = sprintf( '/home/freelings/pointcloud/data/points_%d/minus_line_right_%d.txt',  pcl, i );
    E = load ( filepath );
    filepath = sprintf( '/home/freelings/pointcloud/data/points_%d/smooth_line_right_%d.txt',  pcl, i );
    F = load ( filepath );
    
    title_name =  sprintf( '当前帧数%d, 第%d线', pcl, i);
    figure('Name', title_name );
    subplot( 3, 2, 1 );
    plot( flip(A( :, 3 )), '-k' );
    set(gca,'YLim',[-1.2 -0.5]);%Y轴的数据显示范围
    set(gca,'YTick', [-1.2:0.1:-0.5]);
    subplot( 3, 2, 3 );
    plot( flip(B), '-r' );
    subplot( 3, 2, 5 );
    plot( flip(C), '-b' );
    subplot( 3, 2, 2 );
    plot( D( :, 3 ), '-k' );
    set(gca,'YLim',[-1.2 -0.5]);%Y轴的数据显示范围
    set(gca,'YTick', [-1.2:0.1:-0.5]);
    subplot( 3, 2, 4 );
    plot( E, '-r' );
    subplot( 3, 2, 6 );
    plot( F, '-b' );
end




