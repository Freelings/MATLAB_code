clc
clear
filepath = ('/home/freelings/文档/matlab/files/doc/');
map_point = load ([filepath,'map.6.5.txt']); 
plot(map_point(:,1),map_point(:,2))
path_num = size(map_point,1);
%size(A,1):返回的时数组A的行数/size(A,2):返回的时数组A的列数
% distance_point(path_num-1) = 0;
%两点间距离
angle_point(path_num-1) = 0;
%距离向量角度
angle_difference(path_num-2) = 0;
%相邻距离向量角度差值
dispose_map = map_point ;
%处理后地图点

for i=1:path_num-1
%     distance_point(i) = sqrt( (map_point(i+1,1)-map_point(i,1))^2 + (map_point(i+1,2)-map_point(i,2))^2 );
    angle_point(i)  = atan2(map_point(i+1,2)-map_point(i,2), map_point(i+1,1)-map_point(i,1))*180/3.1415926;
end

for i=1:path_num-2
    angle_difference(i) = abgle_minus_circle(angle_point(i+1), angle_point(i));
    if( abs(angle_difference(i)) > 3)
        dispose_map(i+1,1) = map_point(i,1)/2 + map_point(i+2,1)/2;
        dispose_map(i+1,2) = map_point(i,2)/2 + map_point(i+2,2)/2;
    end
end
 dispose_map(path_num-1,1) = map_point(path_num-1,1) ;
 dispose_map(path_num-1,2) = map_point(path_num-1,2) ;
 dispose_map(path_num,1) = map_point(path_num,1) ;
 dispose_map(path_num,2) = map_point(path_num,2) ;
 
for i=1:path_num
    if(dispose_map(i,1)==0)
    end
end
% plot(dispose_map(:,1),dispose_map(:,2),'r-*');
plot(map_point(:,1),map_point(:,2),'k-*',dispose_map(:,1),dispose_map(:,2),'r-*');