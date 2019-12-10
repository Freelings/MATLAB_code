%此程序中规定，笛卡尔坐标系
%以ｘ轴方向为０°，顺时针为正旋转方向角度
%移动平均滤波器(moving average filter)
clc;
clf;
clear all;
close all;
clear figure;
filepath = ('/home/freelings/pointcloud/test/');
% data_original = load ([filepath,'1891.txt']); 
% 1872 1862 1832
% 1892 1802 1792
% 1792 地面高度不一致
data_dispose = load ([filepath,'points_76.txt']);

figure( 'name', '原始点云' );
% plot( data_dispose( :, 1 ), data_dispose( :, 2 ), '.k' )
axis equal

% line_sart_num = 1;
line_end_num = 8;
power = 1;
span = 80;
color = rand( line_end_num - 1 + 1, 3 );%随机颜色

%X-Y-Z-Distance-Num
data( 1, 5 ) = 0;
%point num of line_start_num to line_end_num
num = zeros( [ line_end_num - 1 + 1 + 1, 1 ] );
%count point num of line_start_num to line_end_num
total = zeros( [ line_end_num - 1 + 1 + 1, 1 ] );
%angle of point
angle( line_end_num - 1 + 1, 1 ) = 0;
%start and end point of edge: start_x | start_y | order | end_x | end_y | order
edge_base = zeros( [ 1, 3 ] );
edge_num = 0;

extend_flag = 0;
if line_end_num - 1 + 1 > 4
    line_num = 4;
    extend_flag = 1;
else
    line_num = line_end_num - 1 + 1;
end

%预处理
count = 0;%所有点计数
for line = 1 : line_end_num - 1 + 1
    flag = 0;
    connect = 0;
    count = 0;
    angle_start = 0;
    last_num_valid = 0;
    for i = ( line + 1 - 1 - 1 )*2016 + 1 : ( line + 1 - 1) * 2016
        if data_dispose( i, 1 ) ~= 0 && data_dispose( i, 2 ) ~= 0 
            num( line + 1 ) = num( line + 1 ) + 1;
            if num( line + 1 ) == 1
                angle_start = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;
                if angle_start < 0 && angle_start > -90
                    flag = 1;%起点在第四象限内
                end
            end
            
            if ( flag == 0 )
                if last_num_valid ~= 0 && data_dispose( i, 1 ) <= 0 && data_dispose( last_num_valid, 1 ) > 0
                    break;
                end
                if data_dispose( i, 1 ) > 0 && data_dispose( i, 2 ) < 0
                    count = count + 1;
                    angle ( line, count ) = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;                      
                    data( total( line ) + count, 1 ) = data_dispose( i, 1 );
                    data( total( line ) + count, 2 ) = data_dispose( i, 2 );
                    data( total( line ) + count, 3 ) = data_dispose( i, 3 );
                    data( total( line ) + count, 4 ) = sqrt( data_dispose( i, 1 )^2 + data_dispose( i, 2 )^2 );
                    data( total( line ) + count, 5 ) = i;
                end
            end
            
            if flag == 1 && last_num_valid ~= 0
                if data_dispose( i, 1 )  <=  0 && data_dispose( last_num_valid, 1 )  > 0 && data_dispose( i, 2 ) < 0 && data_dispose( last_num_valid, 2 ) < 0
                    connect_start = last_num_valid;
                end
                if data_dispose( i, 2 )  <  0 && data_dispose( last_num_valid, 2 )  >= 0 && data_dispose( i, 1 ) > 0 && data_dispose( last_num_valid, 1 ) > 0
                    connect_end = i;
                    break;
                end
            end
            last_num_valid = i;
        end          
    end
    
    if( flag == 1)
        for i =  connect_end : ( line + 1 - 1) * 2016
            if data_dispose( i, 1 ) ~= 0 && data_dispose( i, 2 ) ~= 0
                count = count + 1;
                angle( line, count ) = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;
               
                if angle( line, count ) < angle_start
                    angle( line, count ) = 0;
                    count = count - 1;
                    break;
                end
                data( total( line ) + count, 1 ) = data_dispose( i, 1 );
                data( total( line ) + count, 2 ) = data_dispose( i, 2 );
                data( total( line ) + count, 3 ) = data_dispose( i, 3 );
                data( total( line ) + count, 4 ) = sqrt( data_dispose( i, 1 )^2 + data_dispose( i, 2 )^2 );
                data( total( line ) + count, 5 ) = i;
            end
        end
        
        for i = ( line + 1 - 1 - 1 )*2016 + 1 : connect_start
            if data_dispose( i, 1 ) ~= 0 && data_dispose( i, 2 ) ~= 0
                count = count + 1;
                angle( line, count ) = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;
                data( total( line ) + count, 1 ) = data_dispose( i, 1 );
                data( total( line ) + count, 2 ) = data_dispose( i, 2 );
                data( total( line ) + count, 3 ) = data_dispose( i, 3 );
                data( total( line ) + count, 4 ) = sqrt( data_dispose( i, 1 )^2 + data_dispose( i, 2 )^2 );
                data( total( line ) + count, 5 ) = i;
            end
        end
    end
    num( line + 1 ) = count;
    total( line + 1 ) = total( line ) + count;
end

z_average = zeros( [ line_end_num - 1 + 1, 1 ] );
for line = 1 : line_end_num - 1 + 1
    z_average( line ) = mean( data( total( line ) + 1 : total( line + 1), 3 ), 1 ) * num( line + 1 ) / ( 300 + num( line + 1 ) ) + mean( data( total( line ) + 1 : total( line ) + 100 , 3 ), 1 ) * 300 / ( 300 + num( line + 1 ) );
end

if line_end_num - 1 + 1 < 5
    figure( 'name', 'Z轴变化曲线' );
    for i = 1 : line_end_num - 1 + 1
        subplot( line_end_num - 1 + 1, 1, i )
        plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 3 ), '.-',  'color', color( i, : ) )
        hold on
        plot ( [total( i ) + 1 total( i + 1) ], [ z_average( i )  z_average( i ) ],  '-',  'color', color( i, : ) )
        hold on
    end
else
    figure( 'name', 'Z轴变化曲线(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 3 ), '.-',  'color', color( i, : ) )
        hold on
        plot ( [total( i ) + 1 total( i + 1) ], [ z_average( i )  z_average( i ) ],  '-',  'color', color( i, : ) )
        hold on
    end
    figure( 'name', 'Z轴变化曲线(2)' );
    for i = 5 : line_end_num - 1 + 1
        subplot( line_end_num - 1 + 1 - 4, 1, i - 4 )
        plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 3 ), '.-',  'color', color( i, : ) )
        hold on
        plot ( [total( i ) + 1 total( i + 1) ], [ z_average( i )  z_average( i ) ],  '-',  'color', color( i, : ) )
        hold on
    end
end
%预处理

% figure( 'name', 'X-Y-Z' );
% plot( data( :, 1), 'k-' )
% hold on
% plot( data( :, 2), 'r-' )
% hold on
% plot( data( :, 3), 'b-' )
% legend( 'X', 'Y', 'Z' )

figure( 'name', '角度变化' );
for i = 1 : line_end_num - 1 + 1
    plot( angle( i, 1 : num( i + 1 ) ), '*-', 'color', color( i, : ) )
    hold on
end

%边缘识别
count = 0;
for line = 1 : line_end_num - 1 + 1
    edge_max = 0;
    edge_min = 0;
    order_max = 0;
    order_min = 0;
    for i = total( line ) + 1 + span / 2 : total( line + 1) - span / 2
        count = count + 1;
        average_minus( count ) =  data( i, 3 ) - mean( data( i - span / 2 : i + span / 2, 3 ) );
        if average_minus( count ) > edge_max
            edge_max = average_minus( count );
            order_max = i;
        end
        if average_minus( count ) < edge_min
            edge_min = average_minus( count );
            order_min = i;
        end
    end
    if data( order_max, 3 ) > z_average( line ) && data( order_min, 3 ) < z_average( line ) && order_max - order_min > 10 && order_max - order_min < 40 && line < 5
        edge_num = edge_num + 2;
        edge_base( edge_num - 1, 1 ) = data( order_min, 1 );
        edge_base( edge_num - 1, 2 ) = data( order_min, 2 );
        edge_base( edge_num - 1, 3 ) = data( order_min, 3 );
        edge_base( edge_num - 1, 4 ) = order_min;
        edge_base( edge_num, 1 ) = data( order_max, 1 );
        edge_base( edge_num, 2 ) = data( order_max, 2 );
        edge_base( edge_num, 3 ) = data( order_max, 3 );
        edge_base( edge_num, 4 ) = order_max;
    end
end

if edge_num ~= 0
    line = edge_num / 2;
    edge( 1, 4 ) = 0;
    edge_num = 0;
    for i = 1 : line
        start = edge_num + 1;
        count_end = start + edge_base( i * 2, 4 ) - edge_base( i * 2 - 1, 4 )  - 10;
        edge( start : count_end, 1 : 3 ) = data( edge_base( i * 2 - 1, 4 ) + 5 : edge_base( i * 2, 4 ) - 5, 1 : 3 );
        edge( start : count_end,  4 ) = ( edge_base( i * 2 - 1, 4) + 5 ) : ( edge_base( i * 2, 4 ) - 5 );
        edge_num = size( edge, 1 );
    end 
end

figure( 'name', '基底边缘判断' );
for line = 1 : line_num
    plot( data( total( line ) + 1 : total( line + 1 ), 1 ), data( total( line ) + 1: total( line + 1 ), 2 ), '-',  'color', color( line, : ) )
    hold on
end
if edge_num ~= 0
    plot ( edge( :, 1 ),  edge( :, 2 ), 'r*' )
    axis equal
end

if extend_flag == 1 && edge_num ~= 0
    p = polyfit( edge( :, 1 ), edge( :, 2 ), power );
    
    figure( 'name', '直线拟合' );
    for line = 1 : line_num
        plot( data( total( line ) + 1 : total( line + 1 ), 1 ), data( total( line ) + 1: total( line + 1 ), 2 ), '-',  'color', color( line, : ) )
        hold on
    end
    plot( edge( :, 1 ), polyval( p, edge( :, 1 ) ),'r', 'LineWidth', 2 )
    
    base_edge_num = size( edge, 1 );
    for line = 5 : line_end_num - 1 + 1
        for i = total( line ) + 1 : total( line + 1)
            if abs( data( i, 2 ) - polyval( p, data( i, 1 ) ) ) < 0.05
                edge_num = size( edge, 1 );
                edge( edge_num + 1, 1 ) = data( i, 1 );
                edge( edge_num + 1, 2 ) = data( i, 2 );
                edge( edge_num + 1, 3 ) = data( i, 3 );
                edge( edge_num + 1, 4 ) = i;
            end
        end
        %p = polyfit( edge( :, 1 ), edge( :, 2 ), power );
    end  
end
axis equal
%边缘识别



if extend_flag == 0 
    figure( 'name', '分析' );
    for i = 1 : line_num
        subplot( line_num, 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), average_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
    end
else
    figure( 'name', '分析(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), average_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
    end
    figure( 'name', '分析(2)' );
    for i = 5 : line_end_num - 1 + 1
        subplot( line_end_num - 1 + 1 - 4, 1, i - 4 )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), average_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
    end
end
% figure( 'name', '截后点云' );
% for i = 1 : line_end_num - 1 + 1
%     plot( data( total( i ) + 1 : total( i + 1 ), 1 ), data( total( i ) + 1: total( i + 1 ), 2 ), '*-',  'color', color( i, : ) )
%     hold on
% end
% axis equal

% figure( 'name', '距离变化曲线' );
% for i = 1 : line_end_num - 1 + 1
%     plot( data( total( i ) + 1 : total( i + 1 ), 4 ), '*-',  'color', color( i, : ) )
%     hold on
% end

if extend_flag == 1 && edge_num ~= 0
    figure( 'name', '扩展边缘判断' );
    for line = 1 : line_end_num - 1 + 1
        plot( data( total( line ) + 1 : total( line + 1 ), 1 ), data( total( line ) + 1: total( line + 1 ), 2 ), '-',  'color', color( line, : ) )
        hold on
    end
    plot( edge( :, 1 ), edge( :, 2 ), '*r' );
    hold on
    plot( edge( :, 1 ), polyval( p, edge( :, 1 ) ),'r', 'LineWidth', 2 )
    %plot( edge( 1 : base_edge_num, 1 ), polyval( p, edge( 1 : base_edge_num, 1 ) ),'r', 'LineWidth', 2 )
    axis equal
end

%分割窗口, 霍夫变换
% if edge( 1, 1 ) ~= 0 && edge( 1, 2 ) ~= 0
%     for i = 1 : size( edge, 1 )
%         if i == 1
%             max_x = edge( i, 1 );
%             min_x = edge( i, 1 );
%             max_y = edge( i, 2 );
%             min_y = edge( i, 2 );
%         else
%             if edge( i, 1 ) > max_x
%                 max_x = edge( i, 1 );
%             end
%             if edge( i, 1 ) < min_x
%                 min_x = edge( i, 1 );
%             end
%             if edge( i, 2 ) > max_y
%                 max_y = edge( i, 2 );
%             end
%             if edge( i, 2 ) < min_y
%                 min_y =  edge( i, 2 );
%             end
%         end
%     end
% end

% if (edge( 1,1) ~= 0)
%     img( floor( (max_y - min_y ) * 100 ) + 1, floor( (max_x - min_x ) * 100 ) + 1 ) = false;
%     for i = 1 : size( edge, 1 )
%         img( floor( ( edge( i, 2 ) - min_y ) * 100 ) + 1, floor( ( edge( i, 1 ) - min_x ) * 100 ) + 1 ) = true;
%     end
% 
%     figure( 'name', '原图' );
%     imshow( img )
%     axis on, axis normal
% 
%     IMG = imdilate( img, ones( 2 ) );%图像膨胀
% 
%     %得到霍夫空间
%     [ H, T, R ] = hough( IMG, 'RhoResolution', 0.1,  'ThetaResolution', 0.1 );
% 
%     %求极值点
%     Peaks = houghpeaks( H, 1 );
% 
%     figure( 'name', '霍夫空间' );
%     imshow( H, [ ], 'XData', T, 'YData', R, 'InitialMagnification', 'fit' )
%     axis on
%     axis normal
%     hold on
%     plot( T( Peaks( :, 2 ) ), R( Peaks( :, 1 ) ), 's', 'color', 'white' )
% 
%     %得到线段信息
%     LINE = houghlines( IMG, T, R, Peaks );
% 
%     %绘制线段
%     max_len = 0;
%     figure( 'name', '直线识别结果' );
%     imshow( IMG )
%     hold on
%     for k = 1:length( LINE )
%         xy = [ LINE( k ).point1; LINE( k ).point2 ];
%         plot( xy( :, 1 ), xy( :, 2 ), 'LineWidth', 2, 'Color', 'green' )
% 
%         % Plot beginnings and ends of lines
%         plot( xy( 1, 1 ), xy( 1, 2 ), 'x', 'LineWidth', 2, 'Color', 'red' )
%         plot( xy( 2, 1 ), xy( 2, 2 ), 'x', 'LineWidth', 2, 'Color', 'yellow' )
% 
%         % Determine the endpoints of the longest line segment
%         len = norm( LINE( k ).point1 - LINE( k ).point2 );
%         if ( len > max_len )
%             max_len = len;
%             xy_long = xy;
%         end
%         hold on
%     end
%     axis on
% end
%分割窗口, 霍夫变换


% for line = 1 :line_num
%     for count = total( line ) + 51 : total( line + 1)
%         data( count, 5 ) = data( count, 4) / data( count - 50, 4);
%     end
% end
% 
% figure
% subplot( 2, 1, 1 );
% plot( data( :, 4 ), 'k-' );
% title( 'distance微分' );
% subplot( 2, 1, 2 );
% plot( data( :, 5 ), 'k-' );


% differential( 1, 2 ) = 0;
% count = 0;
% for line = 1 : line_end_num - 1 + 1
%     for i = total( line ) + 2 : total( line + 1)
%         count = count + 1;
%         differential( count, 1 ) = ( data( i, 3 ) - data( i - 1, 3 ) ) / ( data( i, 5 ) - data( i - 1, 5 ) ) / 2016 * 0.1;
%         differential( count, 2 ) = ( data( i, 4 ) - data( i - 1, 4 ) ) / ( data( i, 5 ) - data( i - 1, 5 ) ) / 2016 * 0.1;
%     end
% end

% figure( 'name', 'Z轴微分' );
% subplot( 2, 1, 1 )
% for i = 1 : line_end_num - 1 + 1
%     plot( differential( total( i ) + 1 - i + 1 : total( i + 1 ) - i, 1 ).*1000000, '-',  'color', color( i, : ) );
%     hold on
% end
% subplot( 2, 1, 2 )
% for i = 1 : line_end_num - 1 + 1
%     plot( data( total( i ) + 1 : total( i + 1 ), 3 ), '*-',  'color', color( i, : ) );
%     hold on
% end
% 
% figure( 'name', '距离微分' );
% for i = 1 : line_end_num - 1 + 1
%     plot( differential( total( i ) + 1 - i + 1 : total( i + 1 ) - i, 2 ), '-',  'color', color( i, : ) );
%     hold on
% end
% hold on
% plot( data( total( 4 ) + 1 : total( 4 + 1 ), 4 ), '*-',  'color', color( 4, : ) );

