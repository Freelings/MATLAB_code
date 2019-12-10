clc
clf
clear all
close all
clear figure

filepath =  sprintf( '/home/freelings/pointcloud/data/line.txt' );
data = load ( filepath );

index = 1;
last_index = 1;
line_num = 1;

figure;
while index < size( data,1)
    if( data( index, 2 ) ~= 0 )
        index = index  + 1;
        continue;
    end

    color_r = rand();
    color_g = rand();
    color_b = rand();
    
    [XMIN,XIMIN] = min( data( last_index:index-1, 1 ) );
    [XMAX,XIMAX] = max( data( last_index:index-1, 1 ) );
    XIMIN = XIMIN + last_index - 1;
    XIMAX = XIMAX + last_index - 1;
    str = sprintf( '%d' , line_num);
    plot( data( last_index:index-1, 1 ), data( last_index:index-1, 2 ) , 'o-', 'Color', [ color_r, color_g, color_b ], 'MarkerSize', 10, 'LineWidth',0.1 );
    hold on;
    size_ = rand() * 10;
    plot( data( XIMIN, 1 ), data( XIMIN, 2 ), '--gs', 'LineWidth',0.1, 'MarkerSize',size_,'MarkerEdgeColor','b','MarkerFaceColor', [ color_r, color_g, color_b ] );
    hold on;
    plot( data( XIMAX, 1 ), data( XIMAX, 2 ), '--gs', 'LineWidth',0.1, 'MarkerSize',size_,'MarkerEdgeColor','b','MarkerFaceColor', [ color_r, color_g, color_b ] );
    hold on;
    text(  data( XIMIN, 1 )+0.1,  data( XIMIN, 2 ), str );
    hold on;
    text(  data( XIMAX, 1 )+0.1, data( XIMAX, 2 ), str );
    hold on;
    axis equal;
    
    % 自行曲线拟合
    p1(1) = data( index+2,1 );
    p1(2) = data( index+1,1 );
    p1(3) = data( index,1 );
%     p1(1) = -0.275366;
%     p1(2) = 49.095496;
%     p1(3) = -1810.485409;

    % matlab曲线拟合
%     p1 = polyfit( data( last_index:index-1, 1 ).', data( last_index:index-1, 2 ).', 2 );


    x = min( data( last_index:index-1, 1 ) ): 0.01 : max( data( last_index:index-1, 1 ) );
    y = p1( 1 ).* x.^2 + p1( 2 ) .* x + p1( 3 );
    
    YMIN = min( data( last_index:index-1, 2 ) );
    YMAX = max( data( last_index:index-1, 2 ) );
    for num=size(x,2):-1:1
        if( x(num) < XMIN || x(num) > XMAX || y(num) < YMIN || y(num) > YMAX )
            x( :, num ) = [];
            y( :, num ) = [];
        end;
    end

    plot( x, y, '-.', 'Color', [ color_r, color_g, color_b ], 'LineWidth', 1 );
    hold on;
    
    distance = sqrt( ( data( last_index, 1 ) - data( index-1, 1 ) )^2+ ( data( last_index, 2 ) - data( index-1, 2 ) )^2 );
    
    line_num = line_num + 1;
%     if line_num > 10
%         break;
%     end
    
    last_index = index + 3;
    index = index + 4;
    
end

% figure;
% filepath =  sprintf( '/home/freelings/pointcloud/data/edge_points.txt' );
% data = load ( filepath );
% plot( data( :, 1 ), data( :, 2 ) );
% axis equal;

% figure;
% x= 77:0.1:78;
% y = 0.011.* x.^2 + 0.719 .* x + 183.969;
% plot( x, y, 'k-');
% axis equal;
