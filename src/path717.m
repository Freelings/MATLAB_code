clc;
clf;
clear all;
close all;
clear figure;
filepath = ('/home/freelings/Documents/matlab/files/doc/');
map_points = load ([filepath,'map.7.15.txt']); 
path_points = load ([filepath,'2018-07-31-16-46-26.txt']); 

plot(map_points(:,1),map_points(:,2),'r-',path_points(:,1),path_points(:,2),'k-');

map_num = size(map_points,1);
path_num = size(path_points,1);
distance_sum = [0 0];
%current_distance第一列为方法一计算距离误差，第二列为方法二计算距离误差（推荐），第三列为x方向误差，第四列为y方向误差
for i=1:path_num
    
    %对每一个定位点求最近的地图点
    distance_min = 10;
    for j=1:map_num
        distance_temp = sqrt(  (path_points(i,1)-map_points(j,1))^2 + (path_points(i,2)-map_points(j,2))^2 );
		if distance_temp <= distance_min 
            distance_min = distance_temp;
			nearest_point = j;
        end
    end
    % //用向量叉乘定左右，记录下距离定位点最近点的索引，下推10个点作为本次目标点
    % 	//求左右位置，相对路径夹角	
    vector_nearest_to_target(i,1) = map_points(nearest_point+10,1) - map_points(nearest_point,1);
    vector_nearest_to_target(i,2) = map_points(nearest_point+10,2) - map_points(nearest_point,2);
    vector_localization_to_target(i,1) = map_points(nearest_point+10,1) - path_points(i,1);
    vector_localization_to_target(i,2) = map_points(nearest_point+10,2) - path_points(i,2); 			
 
    %求解 最近点到目标点的夹角
	angle_nearest_to_target(i) = atan2(vector_nearest_to_target(i,2),vector_nearest_to_target(i,1))*180/3.1415926535;
    %上半轴为正
	angle_nearest_to_target(i) = angle_minus_circle(angle_nearest_to_target(i), 90);
    %-180~180,左边为正右边为负
    
    %求解 定位点到目标点的夹角
	angle_localization_to_target(i) = atan2(vector_localization_to_target(i,2),vector_localization_to_target(i,1))*180/3.1415926535;
	angle_localization_to_target(i) = angle_minus_circle(angle_localization_to_target(i), 90);
		
    left_or_right = vector_localization_to_target(i,1) * vector_nearest_to_target(i,2) - vector_nearest_to_target(i,1) * vector_localization_to_target(i,2);  
    %计算左右位置，左边为正右边为负
    
    % /*1*/		
	current_distance(i,1) = distance_min;
	if (left_or_right < 0 )
		current_distance(i,1) = -current_distance(i,1);
    end
    
    % /*2*/
    if nearest_point == 1
        vector1 = map_points(nearest_point,1) - path_points(i,1);
        vector2 = map_points(nearest_point,2) - path_points(i,2);
        current_distance(i,2) = sqrt(vector1^2 + vector2^2);
    else
        vector1 = map_points(nearest_point+1,1) - path_points(i,1);
        vector2 = map_points(nearest_point+1,2) - path_points(i,2);
        vector3 = map_points(nearest_point-1,1) - path_points(i,1);
        vector4 = map_points(nearest_point-1,2) - path_points(i,2);
        angle1 = atan2(vector2,vector1);
        angle2 = atan2(vector4,vector3);
        angleC = angle_minus_circle(angle1,angle2);
        a = sqrt( (map_points(nearest_point+1,1)-path_points(i,1))^2+ (map_points(nearest_point+1,2)-path_points(i,2))^2 );
        b = sqrt( (map_points(nearest_point-1,1)-path_points(i,1))^2+ (map_points(nearest_point-1,2)-path_points(i,2))^2 );
        c =  sqrt( (map_points(nearest_point+1,1)-map_points(nearest_point-1,1))^2+ (map_points(nearest_point+1,2)-map_points(nearest_point-1,2))^2 );
        current_distance(i,2) = abs(a*b*sin(angleC)/c);
    end
	
	if (left_or_right < 0 )
		current_distance(i,2) = -current_distance(i,2);
    end
    current_distance(i,3) = abs(vector1);
    current_distance(i,4) = abs(vector2);
    distance_sum(1) = distance_sum(1) + abs(current_distance(i,1));
    distance_sum(2) = distance_sum(2) + abs(current_distance(i,2));
end
 
average1 = distance_sum(1)/path_num;
average2 = distance_sum(2)/path_num;

figure(1)
% plot(current_distance(:,1),'r-*');
% hold on;

% for i=1:path_num
%     time(i) = 0.1*i;
% end
% 
% plot(time(),current_distance(:,2),'k-','LineWidth',4);

%点数转时间提取
% for i=1:path_num/10
%     time(i) = current_distance(i*10,2);
% end

set(0,'defaultfigurecolor','w')
plot(abs(current_distance(:,2)),'r-','LineWidth',2);
hold on
plot(abs(current_distance(:,3)),'b-','LineWidth',2);
hold on
plot(abs(current_distance(:,4)),'k-','LineWidth',2);
title('跟踪误差-时间曲线');
xlabel('帧数');
ylabel('距离偏差量(米)');
legend('直线误差','X轴误差','Y轴误差');
grid on;
grid minor;

figure(2)
set(0,'defaultfigurecolor','w')
plot(path_points(:,1),path_points(:,2),'r-',map_points(:,1),map_points(:,2),'k-','LineWidth',4);
title('路径图');
xlabel('相对经度(米)');
ylabel('相对纬度米)');
legend('实际路径','参考路径');
axis equal;
grid on;
