clc;
clf;
clear all;
close all;
clear figure;

I = imread( '/home/freelings/文档/matlab/files/doc/picture/2.jpeg' );
figure( 1 );
imshow( I );
title( '原图' );

Ihsv = rgb2gray( I );
Iedge = edge( Ihsv, 'sobel' );%边沿检测
Iedge = imdilate( Iedge, ones( 2 ) );%图像膨胀

figure( 2 );
imshow(Iedge);
title( '膨胀后' );

%得到霍夫空间
[ H, T, R ] = hough( Iedge, 'RhoResolution', 0.5 , 'ThetaResolution', 0.1 );

%求极值点
Peaks = houghpeaks( H, 1000 );

figure( 3 );
imshow( H, [ ], 'XData', T, 'YData', R, 'InitialMagnification', 'fit' );
axis on, axis normal, hold on;
plot( T( Peaks( :, 2 ) ), R( Peaks( :, 1 ) ), 's', 'color', 'white' );


%得到线段信息
lines = houghlines( Iedge, T, R, Peaks );

%绘制线段
max_len = 0;
figure( 4 );
imshow( Iedge );
for k = 1:length( lines )
    hold on;
    xy = [ lines( k ).point1; lines( k ).point2 ];
    plot( xy( :, 1 ), xy( :, 2 ), 'LineWidth', 2, 'Color', 'green' );

    % Plot beginnings and ends of lines
    plot( xy( 1, 1 ), xy( 1, 2 ), 'x', 'LineWidth', 2, 'Color', 'red' );
    plot( xy( 2, 1 ), xy( 2, 2 ), 'x', 'LineWidth', 2, 'Color', 'yellow' );

    % Determine the endpoints of the longest line segment
    len = norm( lines( k ).point1 - lines( k ).point2 );
    if ( len > max_len )
        max_len = len;
        xy_long = xy;
    end
end
axis on;

% point( 1, 2 ) = 0;
% count = 0;
% zero = 0;
% for i = 1 : size( Iedge, 1 )
%     for j = 1 : size( Iedge, 2 )
%         if Iedge( i, j ) == 1
%             count = count + 1;
%             point( count, 1 ) = i;
%             point( count, 2 ) = j;
%         end
%         if Iedge( i, j ) == 0
%             zero = zero + 1;
%         end
%     end
% end
% 
% figure( 5 )
% plot( point( :, 1), point( :, 2), '*k' );
% title( '点云' );