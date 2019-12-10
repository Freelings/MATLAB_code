%此程序中规定，笛卡尔坐标系
%以ｘ轴方向为０°，顺时针为正旋转方向角度
%移动平均滤波器(moving average filter)
clc
clf
clear all
close all
clear figure
filepath = ('/home/freeling/pointcloud/data/');
% data_original = load ([filepath,'original_1891.txt']); 
% 1872 1862 1832
% 1892 1802 1792
% 1792 地面高度不一致
data_dispose = load ([ '/home/freelings/文档/MATLAB/doc/dispose_5.txt']);

figure( 'name', '原始点云' );
plot( data_dispose( :, 1 ), data_dispose( :, 2 ), '.k' )
axis equal

line_sart_num = 1;
line_end_num = 8;
%拟合一次方程
power = 2;
span = 40;
color = rand( line_end_num, 3 );%随机颜色

% X-Y-Z-Distance-Order
data( 1, 5 ) = 0;
% point num of single line
num = zeros( [ line_end_num + 1, 1 ] );
% point num of total line
total = zeros( [ line_end_num + 1, 1 ] );
% angle of point
angle( line_end_num + 1, 1 ) = 0;
% start and end point of edge: start_x | start_y | order | end_x | end_y | order
edge_base = zeros( [ 1, 4 ] );
edge_base_num = 0;

%预处理
for current_line_num = 1 : line_end_num %current_line_num从1开始
    single_line_position_flag = 0;
    single_line_point_num = 0;
    single_line_point_sort_num = 0;
    single_line_angle_start = 0;
    last_num_valid = 0;
    for i = ( current_line_num - 1 ) * 2016 + 1 : current_line_num * 2016
        if data_dispose( i, 1 ) ~= 0 && data_dispose( i, 2 ) ~= 0 
            single_line_point_num = single_line_point_num + 1;
            
            %判断起始位置 0-一二三象限 1-四象限
            if single_line_point_num == 1
                single_line_angle_start = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;
                if single_line_angle_start <= 0 && single_line_angle_start >= -90
                    single_line_position_flag = 1;
                end
            end
            
            if ( single_line_position_flag == 0 )
                if data_dispose( i, 1 ) > 0 && data_dispose( i, 2 ) < 0
                    single_line_point_sort_num = single_line_point_sort_num + 1;
                    angle ( current_line_num, single_line_point_sort_num ) = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;                      
                    data( total( current_line_num ) + single_line_point_sort_num, 1 ) = data_dispose( i, 1 );
                    data( total( current_line_num ) + single_line_point_sort_num, 2 ) = data_dispose( i, 2 );
                    data( total( current_line_num ) + single_line_point_sort_num, 3 ) = data_dispose( i, 3 );
                    data( total( current_line_num ) + single_line_point_sort_num, 4 ) = sqrt( data_dispose( i, 1 )^2 + data_dispose( i, 2 )^2 );
                    data( total( current_line_num ) + single_line_point_sort_num, 5 ) = i;
                end
            end
            
            if single_line_position_flag == 1 && last_num_valid ~= 0
                if data_dispose( i, 1 )  <=  0 && data_dispose( last_num_valid, 1 )  > 0 && data_dispose( i, 2 ) < 0 && data_dispose( last_num_valid, 2 ) < 0
                    position_connect_end = last_num_valid;
                end
                if data_dispose( i, 2 )  <  0 && data_dispose( last_num_valid, 2 )  >= 0 && data_dispose( i, 1 ) > 0 && data_dispose( last_num_valid, 1 ) > 0
                    position_connect_start = i;
                end
            end
            last_num_valid = i;
        end          
    end
    
    if( single_line_position_flag == 1)
        for i =  position_connect_start : current_line_num * 2016
            if data_dispose( i, 1 ) ~= 0 && data_dispose( i, 2 ) ~= 0
                single_line_point_sort_num = single_line_point_sort_num + 1;
                angle( current_line_num, single_line_point_sort_num ) = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;
               
                if angle( current_line_num, single_line_point_sort_num ) < single_line_angle_start
                    angle( current_line_num, single_line_point_sort_num ) = 0;
                    single_line_point_sort_num = single_line_point_sort_num - 1;
                    break;
                end
                data( total( current_line_num ) + single_line_point_sort_num, 1 ) = data_dispose( i, 1 );
                data( total( current_line_num ) + single_line_point_sort_num, 2 ) = data_dispose( i, 2 );
                data( total( current_line_num ) + single_line_point_sort_num, 3 ) = data_dispose( i, 3 );
                data( total( current_line_num ) + single_line_point_sort_num, 4 ) = sqrt( data_dispose( i, 1 )^2 + data_dispose( i, 2 )^2 );
                data( total( current_line_num ) + single_line_point_sort_num, 5 ) = i;
            end
        end
        
        for i = ( current_line_num - 1 ) * 2016 + 1 : position_connect_end
            if data_dispose( i, 1 ) ~= 0 && data_dispose( i, 2 ) ~= 0
                single_line_point_sort_num = single_line_point_sort_num + 1;
                angle( current_line_num, single_line_point_sort_num ) = atan2( data_dispose( i, 2 ), data_dispose( i, 1 ) ) * 180 / pi;
                data( total( current_line_num ) + single_line_point_sort_num, 1 ) = data_dispose( i, 1 );
                data( total( current_line_num ) + single_line_point_sort_num, 2 ) = data_dispose( i, 2 );
                data( total( current_line_num ) + single_line_point_sort_num, 3 ) = data_dispose( i, 3 );
                data( total( current_line_num ) + single_line_point_sort_num, 4 ) = sqrt( data_dispose( i, 1 )^2 + data_dispose( i, 2 )^2 );
                data( total( current_line_num ) + single_line_point_sort_num, 5 ) = i;
            end
        end
    end
    num( current_line_num + 1 ) = single_line_point_sort_num;
    total( current_line_num + 1 ) = total( current_line_num ) + single_line_point_sort_num;
end

z_average = zeros( [ line_end_num, 1 ] );
for current_line_num = 1 : line_end_num
    z_average( current_line_num ) = mean( data( total( current_line_num ) + 1 : total( current_line_num + 1), 3 ), 1 );
    %z_average( current_line_num ) = mean( data( total( current_line_num ) + 1 : total( current_line_num + 1), 3 ), 1 ) * num( current_line_num + 1 ) / ( 300 + num( current_line_num + 1 ) ) + mean( data( total( current_line_num ) + 1 : total( current_line_num ) + 100 , 3 ), 1 ) * 300 / ( 300 + num( current_line_num + 1 ) );
end

figure( 'name', '角度变化' ); 
for i = 1 : line_end_num
    plot( angle( i,  1 : num( i + 1 ) ), '*-', 'color', color( i, : ) )
    hold on
end
        
if line_end_num - 1 + 1 < 5
    figure( 'name', 'Z轴变化曲线' );
    for i = 1 : line_end_num
        subplot( line_end_num, 1, i )
        plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 3 ), '.-',  'color', color( i, : ) );
        hold on
        plot ( [total( i ) + 1 total( i + 1) ], [ z_average( i )  z_average( i ) ],  '-',  'color', color( i, : ) );
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
%     figure( 'name', '距离变化曲线' );
%     for i = 1 : line_end_num
%         subplot( line_end_num, 1, i )
%         plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 4 ), '.-',  'color', color( i, : ) )
%         hold on
%     end
else
    figure( 'name', 'Z轴变化曲线(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 3 ), '.-',  'color', color( i, : ) )
        hold on
        plot ( [total( i ) + 1 total( i + 1) ], [ z_average( i )  z_average( i ) ],  '-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
    figure( 'name', 'Z轴变化曲线(2)' );
    for i = 5 : line_end_num
        subplot( line_end_num - 4, 1, i - 4 )
        plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 3 ), '.-',  'color', color( i, : ) )
        hold on
        plot ( [total( i ) + 1 total( i + 1) ], [ z_average( i )  z_average( i ) ],  '-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
    
%     figure( 'name', '距离变化曲线(1)' );
%     for i = 1 : 4
%         subplot( 4, 1, i )
%         plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 4 ), '.-',  'color', color( i, : ) )
%         hold on
%     end
%     figure( 'name', '距离变化曲线(2)' );
%     for i = 5 : line_end_num
%         subplot( line_end_num - 4, 1, i - 4 )
%         plot( total( i ) + 1 : total( i + 1), data( total( i ) + 1 : total( i + 1), 4 ), '.-',  'color', color( i, : ) )
%         hold on
%     end

end
%预处理




%分析分析分析
num_count = 0;
window_minus( size( data, 1) - line_end_num * span ) = 0;
window_minus_smooth( size( data, 1) - line_end_num * span ) = 0;
for current_line_num = 1 : line_end_num
    edge_top = 0;
    edge_bottom = 0;
    temp_max = 0;
    temp_min = 0;
    for i = total( current_line_num ) + 1 + span / 2 : total( current_line_num + 1) - span / 2
        num_count = num_count + 1;
        window_minus( num_count ) =  data( i, 3 ) - mean( data( i - span / 2 : i + span / 2, 3 ) );
    end
end
smooth_num = 30;
for i = 1 : line_end_num
     window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1) - i * span ) = smooth( window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1) - i * span ), smooth_num, 'moving' );
end

if line_end_num - line_sart_num < 5
    figure( 'name', '窗口分析' );
    for i = 1 : line_end_num
        subplot( line_end_num, 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
else
    figure( 'name', '窗口分析(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
    figure( 'name', '窗口分析(2)' );
    for i = 5 : line_end_num
        subplot( line_end_num - 4, 1, i - 4 )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
end

if line_end_num - line_sart_num < 5 
    figure( 'name', '窗口分析平滑处理' );
    for i = 1 : line_end_num
        subplot( line_end_num , 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
else
    figure( 'name', '窗口分析平滑处理(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        temp = smooth( window_minus( total( i ) + 1 - ( i - 1 ) * 40 : total( i + 1) - i * 40 ), smooth_num , 'moving' );
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
    figure( 'name', '窗口分析平滑处理(2)' );
    for i = 5 : line_end_num
        subplot( line_end_num- 4, 1, i - 4 )
        temp = smooth( window_minus( total( i ) + 1 - ( i - 1 ) * 40 : total( i + 1) - i * 40 ), smooth_num , 'moving' );
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
end
%分析分析分析


%边缘识别
for current_line_num = 1 : line_end_num
    edge_top = 0;
    edge_bottom = 0;
    temp_max = 0;
    temp_min = 0;
    for i = total( current_line_num ) + 1 - ( current_line_num - 1 ) * 40 : total( current_line_num + 1) - current_line_num * 40
       if( window_minus_smooth( i ) > temp_max )
           temp_max = window_minus_smooth( i );
       end
       if( window_minus_smooth( i ) < temp_min )
           temp_min = window_minus_smooth( i );
       end
    end
    
    flag1 = 0;
    flag2 = 0;
    for i = total( current_line_num ) + 1 - ( current_line_num - 1 ) * 40 + 1 : total( current_line_num + 1) - current_line_num * 40 - 1
        if window_minus_smooth( i ) > window_minus_smooth( i - 1 ) && window_minus_smooth( i ) > window_minus_smooth( i + 1 ) && flag1 == 0 && window_minus_smooth( i ) > temp_max/5
            flag1 = 1;
            edge_top = i + ( current_line_num - 1) *span + span/2;
        end
    end
    
    for i = total( current_line_num ) + 1 - ( current_line_num - 1 ) * 40 + 1 : total( current_line_num + 1) - current_line_num * 40 - 1
        if window_minus_smooth( i ) < window_minus_smooth( i -1 ) && window_minus_smooth( i ) < window_minus_smooth( i + 1 ) && flag2 == 0 && window_minus_smooth( i ) < temp_min/5
            flag2 = 1;
            edge_bottom = i + ( current_line_num - 1) *span + span/2;
        end
    end

    %部分显示    
    if  edge_top ~= 0 && edge_bottom ~= 0 && data( edge_top, 3 ) > data( edge_bottom, 3 ) && edge_top - edge_bottom > 10 && edge_top - edge_bottom < 60
        edge_base_num = edge_base_num + 1;
        edge_base( edge_base_num, 1 ) = data( edge_top, 1 );
        edge_base( edge_base_num, 2 ) = data( edge_top, 2 );
        edge_base( edge_base_num, 3 ) = data( edge_top, 3 );
        edge_base( edge_base_num, 4 ) = edge_top;
        edge_base_num = edge_base_num + 1;
        edge_base( edge_base_num, 1 ) = data( edge_bottom, 1 );
        edge_base( edge_base_num, 2 ) = data( edge_bottom, 2 );
        edge_base( edge_base_num, 3 ) = data( edge_bottom, 3 );
        edge_base( edge_base_num, 4 ) = edge_bottom;
        edge_base_num = edge_base_num + 1;
        edge_base( edge_base_num, 1 ) = data( floor( edge_top * 0.5 + edge_bottom *0.5 ), 1 );
        edge_base( edge_base_num, 2 ) = data( floor( edge_top * 0.5 + edge_bottom *0.5 ), 2 );
        edge_base( edge_base_num, 3 ) = data( floor( edge_top * 0.5 + edge_bottom *0.5 ), 3 );
        edge_base( edge_base_num, 4 ) = floor( edge_top * 0.5 + edge_bottom *0.5 );
    end

     %全部显示    
%     if  data( edge_top + ( current_line_num - 1) *span + span/2, 3 ) > data( edge_bottom + ( current_line_num - 1) *span + span/2, 3 ) && edge_top - edge_bottom > 10 && edge_top - edge_bottom < 50
%         for j = edge_bottom + ( current_line_num - 1) *span + span/2 : edge_top + ( current_line_num - 1) *span + span/2 
%             edge_base_num = edge_base_num + 1;
%             edge_base( edge_base_num, 1 ) = data( j, 1 );
%             edge_base( edge_base_num, 2 ) = data( j, 2 );
%             edge_base( edge_base_num, 3 ) = data( j, 3 );
%         end
%     end
end

figure( 'name', '基底边缘判断' );
for current_line_num = 1 : line_end_num
    plot( data( total( current_line_num ) + 1 : total( current_line_num + 1 ), 1 ), data( total( current_line_num ) + 1: total( current_line_num + 1 ), 2 ), '-',  'color', color( current_line_num, : ) )
    hold on
%     for  ii= total( current_line_num ) + 1: total( current_line_num + 1 )
%     	text( data( ii, 1 ), data( ii, 2 ), { num2str( ii ) } )
%     end
end
if edge_base_num ~= 0
    plot ( edge_base( :, 1 ),  edge_base( :, 2 ), 'r*' )
    for  ii= 1:edge_base_num
    	text( edge_base( ii, 1 ) + 0.02, edge_base( ii, 2 ) + 0.02, { num2str( edge_base( ii, 4 ) ) } )
    end
    axis equal
end

edge_base_to_polyfit = zeros( [ 1, 4 ] );
if edge_base_num ~= 0
    for i = 1: edge_base_num/3
        edge_base_to_polyfit( i,: ) = edge_base( 3 * i, : );
    end
    p = polyfit( edge_base_to_polyfit( :, 1 ), edge_base_to_polyfit( :, 2 ), power );
    figure( 'name', '曲线拟合' );
    plot( data_dispose( :, 1) , data_dispose( :, 2 ), '.k' )
    hold on
    plot( edge_base( 1,1 ) : 50, polyval( p, edge_base( 1,1 ) : 50 ),'r', 'LineWidth', 2 )
    axis equal
%     for current_line_num = 5 : line_end_num - 1 + 1
%         for i = total( current_line_num ) + 1 : total( current_line_num + 1)
%             if abs( data( i, 2 ) - polyval( p, data( i, 1 ) ) ) < 0.05
%                 edge_base_num = size( edge, 1 );
%                 edge_base( edge_base_num + 1, 1 ) = data( i, 1 );
%                 edge( edge_base_num + 1, 2 ) = data( i, 2 );
%                 edge( edge_base_num + 1, 3 ) = data( i, 3 );
%                 edge( edge_base_num + 1, 4 ) = i;
%             end
%         end
%         %p = polyfit( edge( :, 1 ), edge( :, 2 ), power );
%     end  
end

%边缘识别


%分析
num_count = 0;
window_minus( size( data, 1) - line_end_num * span ) = 0;
window_minus_smooth( size( data, 1) - line_end_num * span ) = 0;
for current_line_num = 1 : line_end_num
    edge_top = 0;
    edge_bottom = 0;
    temp_max = 0;
    temp_min = 0;
    for i = total( current_line_num ) + 1 + span / 2 : total( current_line_num + 1) - span / 2
        num_count = num_count + 1;
        window_minus( num_count ) =  data( i, 3 ) - mean( data( i - span / 2 : i + span / 2, 3 ) );
    end
end
smooth_num = 30;
for i = 1 : line_end_num
     window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1) - i * span ) = smooth( window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1) - i * span ), smooth_num, 'moving' );
end

if line_end_num - line_sart_num < 5
    figure( 'name', '窗口分析' );
    for i = 1 : line_end_num
        subplot( line_end_num, 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
else
    figure( 'name', '窗口分析(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
    figure( 'name', '窗口分析(2)' );
    for i = 5 : line_end_num
        subplot( line_end_num - 4, 1, i - 4 )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
end

if line_end_num - line_sart_num < 5 
    figure( 'name', '窗口分析平滑处理' );
    for i = 1 : line_end_num
        subplot( line_end_num , 1, i )
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
else
    figure( 'name', '窗口分析平滑处理(1)' );
    for i = 1 : 4
        subplot( 4, 1, i )
        temp = smooth( window_minus( total( i ) + 1 - ( i - 1 ) * 40 : total( i + 1) - i * 40 ), smooth_num , 'moving' );
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
    figure( 'name', '窗口分析平滑处理(2)' );
    for i = 5 : line_end_num
        subplot( line_end_num- 4, 1, i - 4 )
        temp = smooth( window_minus( total( i ) + 1 - ( i - 1 ) * 40 : total( i + 1) - i * 40 ), smooth_num , 'moving' );
        plot( ( total( i ) + 1 + span / 2 ) : ( total( i + 1 ) - span / 2 ), window_minus_smooth( total( i ) + 1 - ( i - 1 ) * span : total( i + 1 ) - i * span ), '*-',  'color', color( i, : ) )
        xlim( [total( i ) + 1 total( i + 1) ] )
    end
end
%分析




%边缘识别
for current_line_num = 1 : line_end_num
    edge_top = 0;
    edge_bottom = 0;
    temp_max = 0;
    temp_min = 0;
    for i = total( current_line_num ) + 1 - ( current_line_num - 1 ) * 40 : total( current_line_num + 1) - current_line_num * 40
       if( window_minus_smooth( i ) > temp_max )
           temp_max = window_minus_smooth( i );
       end
       if( window_minus_smooth( i ) < temp_min )
           temp_min = window_minus_smooth( i );
       end
    end
    
    flag1 = 0;
    flag2 = 0;
    for i = total( current_line_num ) + 1 - ( current_line_num - 1 ) * 40 + 1 : total( current_line_num + 1) - current_line_num * 40 - 1
        if window_minus_smooth( i ) > window_minus_smooth( i - 1 ) && window_minus_smooth( i ) > window_minus_smooth( i + 1 ) && flag1 == 0 && window_minus_smooth( i ) > temp_max/5
            flag1 = 1;
            edge_top = i + ( current_line_num - 1) *span + span/2;
        end
    end
    
    for i = total( current_line_num ) + 1 - ( current_line_num - 1 ) * 40 + 1 : total( current_line_num + 1) - current_line_num * 40 - 1
        if window_minus_smooth( i ) < window_minus_smooth( i -1 ) && window_minus_smooth( i ) < window_minus_smooth( i + 1 ) && flag2 == 0 && window_minus_smooth( i ) < temp_min/5
            flag2 = 1;
            edge_bottom = i + ( current_line_num - 1) *span + span/2;
        end
    end

    %部分显示    
    if  edge_top ~= 0 && edge_bottom ~= 0 && data( edge_top, 3 ) > data( edge_bottom, 3 ) && edge_top - edge_bottom > 10 && edge_top - edge_bottom < 60
        edge_base_num = edge_base_num + 1;
        edge_base( edge_base_num, 1 ) = data( edge_top, 1 );
        edge_base( edge_base_num, 2 ) = data( edge_top, 2 );
        edge_base( edge_base_num, 3 ) = data( edge_top, 3 );
        edge_base( edge_base_num, 4 ) = edge_top;
        edge_base_num = edge_base_num + 1;
        edge_base( edge_base_num, 1 ) = data( edge_bottom, 1 );
        edge_base( edge_base_num, 2 ) = data( edge_bottom, 2 );
        edge_base( edge_base_num, 3 ) = data( edge_bottom, 3 );
        edge_base( edge_base_num, 4 ) = edge_bottom;
        edge_base_num = edge_base_num + 1;
        edge_base( edge_base_num, 1 ) = data( floor( edge_top * 0.5 + edge_bottom *0.5 ), 1 );
        edge_base( edge_base_num, 2 ) = data( floor( edge_top * 0.5 + edge_bottom *0.5 ), 2 );
        edge_base( edge_base_num, 3 ) = data( floor( edge_top * 0.5 + edge_bottom *0.5 ), 3 );
        edge_base( edge_base_num, 4 ) = floor( edge_top * 0.5 + edge_bottom *0.5 );
    end

%     %全部显示    
%     if  data( edge_top + ( current_line_num - 1) *span + span/2, 3 ) > data( edge_bottom + ( current_line_num - 1) *span + span/2, 3 ) && edge_top - edge_bottom > 10 && edge_top - edge_bottom < 50
%         for j = edge_bottom + ( current_line_num - 1) *span + span/2 : edge_top + ( current_line_num - 1) *span + span/2 
%             edge_base_num = edge_base_num + 1;
%             edge_base( edge_base_num, 1 ) = data( j, 1 );
%             edge_base( edge_base_num, 2 ) = data( j, 2 );
%             edge_base( edge_base_num, 3 ) = data( j, 3 );
%         end
%     end
end

figure( 'name', '基底边缘判断' );
for current_line_num = 1 : line_end_num
    plot( data( total( current_line_num ) + 1 : total( current_line_num + 1 ), 1 ), data( total( current_line_num ) + 1: total( current_line_num + 1 ), 2 ), '-',  'color', color( current_line_num, : ) )
    hold on
%     for  ii= total( current_line_num ) + 1: total( current_line_num + 1 )
%     	text( data( ii, 1 ), data( ii, 2 ), { num2str( ii ) } )
%     end
end
if edge_base_num ~= 0
    plot ( edge_base( :, 1 ),  edge_base( :, 2 ), 'r*' )
    for  ii= 1:edge_base_num
    	text( edge_base( ii, 1 ) + 0.02, edge_base( ii, 2 ) + 0.02, { num2str( edge_base( ii, 4 ) ) } )
    end
    axis equal
end

edge_base_to_polyfit = zeros( [ 1, 4 ] );
if edge_base_num ~= 0
    for i = 1: edge_base_num/3
        edge_base_to_polyfit( i,: ) = edge_base( 3 * i, : );
    end
    p = polyfit( edge_base_to_polyfit( :, 1 ), edge_base_to_polyfit( :, 2 ), power );
    figure( 'name', '曲线拟合' );
    plot( data_dispose( :, 1) , data_dispose( :, 2 ), '.k' )
    hold on
    plot( edge_base( 1,1 ) : 50, polyval( p, edge_base( 1,1 ) : 50 ),'r', 'LineWidth', 2 )
    axis equal
%     for current_line_num = 5 : line_end_num - 1 + 1
%         for i = total( current_line_num ) + 1 : total( current_line_num + 1)
%             if abs( data( i, 2 ) - polyval( p, data( i, 1 ) ) ) < 0.05
%                 edge_base_num = size( edge, 1 );
%                 edge_base( edge_base_num + 1, 1 ) = data( i, 1 );
%                 edge( edge_base_num + 1, 2 ) = data( i, 2 );
%                 edge( edge_base_num + 1, 3 ) = data( i, 3 );
%                 edge( edge_base_num + 1, 4 ) = i;
%             end
%         end
%         %p = polyfit( edge( :, 1 ), edge( :, 2 ), power );
%     end  
end

%ddddsr边缘识别


