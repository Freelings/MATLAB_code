clc;
clf;
clear;
clear figure;
close all;

index_left_right(1,2)=0;

for i=1:4*929
    points_order =fix(i/4)+1;
    %fprintf('正在处理%d帧数据\n', points_order );
    
    line_num = rem(i,4);

    if rem(i,4)==0
        points_order = points_order - 1;
        line_num = 4;
    end

    flag_all = 0;
    flag_left = 0;
    flag_right = 0;

    try
        file_path =  sprintf('/home/freelings/pointcloud/data/points_%d/line_%d.txt', points_order, line_num );
        A = load ( file_path ); 
        num = size( A, 1 );
    catch
        flag_all = 1;
        fprintf('%d全点云数据不存在\n',points_order);
    end

    try
        file_path =  sprintf('/home/freelings/pointcloud/data/points_%d/minus_line_left_%d.txt', points_order, line_num );
        B = load ( file_path ); 
        file_path =  sprintf('/home/freelings/pointcloud/data/points_%d/smooth_line_left_%d.txt', points_order, line_num );
        C = load ( file_path ); 
        num_left = size( C, 1 );
    catch
        flag_left = 1;
        fprintf('%d %d线左点云数据不存在\n', points_order, line_num );
    end

    try
        file_path =  sprintf('/home/freelings/pointcloud/data/points_%d/minus_line_right_%d.txt', points_order, line_num );
        D = load ( file_path ); 
        file_path =  sprintf('/home/freelings/pointcloud/data/points_%d/smooth_line_right_%d.txt', points_order, line_num );
        E = load ( file_path ); 
        num_right = size( E, 1 );
    catch
        flag_right = 1;
        fprintf('%d %d线右点云数据不存在\n', points_order, line_num );
    end

    if flag_left == 0 && flag_right == 0
        left_min = min( C );
        left_max =max( C );
        right_min = min( E );
        right_max =max( E );


        mean_left = mean( C );
        mean_right = mean( E );

        std_left = std( C, 1, 1 );
        std_right = std( E, 1, 1 );

        var_left = var( C, 1, 1 );
        var_right = var( E, 1, 1 );

        index_left_right(i,1)=var_left;
        index_left_right(i,2)=var_right;
    end
end;

average_left = mean( index_left_right( :, 1) );
average_right = mean( index_left_right( :, 2) );
average_middle = 1.518197420604283e-05;
average_assume = 2e-06;

figure
plot( index_left_right(:,1),'.-k');
hold on;
plot( index_left_right(:,2),'.-r');
hold on;
plot( [1 size( index_left_right,1 )], [ average_assume average_assume], '.-b' );

    if flag_all == 0
        for i=1:num
            if( isnan( A(i,1) ) && isnan( A(i,2) ) && isnan( A(i,3) ) )
                break_point = i;
            end
        end
    
        figure
        plot3( A(:,1),A(:,2),A(:,3), 'k*-');
        axis equal
    
        figure
        plot( 1:num, A(:,3), 'k*-');
    end
    
    if flag_all == 0 && flag_left == 0
        figure
        subplot( 3,1,1)
        plot( flipud( A(1:num_left,3) ), 'k*-');
        title('左侧第一线z高度')
        subplot( 3,1,2)
        plot( B, 'b*-');
        title('移动窗口计算误差')
        subplot( 3,1,3)
        plot( C, 'r*-');
        title('误差滤波')
    end
    
    if flag_all == 0 && flag_right == 0
        figure
        subplot( 3,1,1)
        plot( A(break_point+1:break_point+num_right,3), 'k*-');
        title('右侧第一线z高度')
        subplot( 3,1,2)
        plot( D, 'b*-');
        title('移动窗口计算误差')
        subplot( 3,1,3)
        plot( E, 'r*-');
        title('误差滤波')
    end