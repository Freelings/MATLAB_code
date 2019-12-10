clc
clf
clear

% 读入指定路径的图片
imgFolder = '/home/freelings/文档/matlab/files/doc/picture'; %指定路径
picture = imread(fullfile(imgFolder,'1.jpeg')); %读入图像
picture = im2double(picture);
Row = size(picture,1);
Column = size(picture,2);
% 读入指定路径的图片结束

figure(1);
subplot(1, 2, 1);
imshow(picture);
title('picture.jpeg');

%灰度处理
for i=1:Row
    for j=1:Column
      picture(i,j,1) =   0.3*picture(i,j,1)+ 0.59*picture(i,j,2)+0.11*picture(i,j,3);
      picture(i,j,2) =   0.3*picture(i,j,1)+ 0.59*picture(i,j,2)+0.11*picture(i,j,3);
      picture(i,j,3) =   0.3*picture(i,j,1)+ 0.59*picture(i,j,2)+0.11*picture(i,j,3);
    end
end
%灰度处理结束

subplot(1, 2, 2);
imshow(picture);
title('picture.jpeg灰度化');

%二值化处理
sum = 0;
for i=1:Row
    for j=1:Column
     sum =  sum + picture(i,j,1)+picture(i,j,2)+picture(i,j,3);
    end
end
average = sum/(Row*Column);
for i=1:Row
    for j=1:Column
        if( picture(i,j,1)+picture(i,j,2)+picture(i,j,3) < average - 0.3)
            picture(i,j,1) = 0;
            picture(i,j,2) = 0;
            picture(i,j,3) = 0;
        else
            picture(i,j,1) = 1;
            picture(i,j,2) = 1;
            picture(i,j,3) = 1;
        end
    end
end
%二值化处理结束

figure(2);
% subplot(1, 2, 1);
imshow( picture );
title('picture.jpeg二值化');

%轮廓处理
picture_line(Row,Column,3) = 0;

for num=1:3
     picture_line(1,1,num) = picture(1,1,num);
     picture_line(1,Column,num) = picture(1,Column,num);
     picture_line(Row,1,num) = picture(Row,1,num);
     picture_line(Row,Column,num) = picture(Row,Column,num);

end

sum_line_point = 0;
for j=2:Column-1
    sum_line_point =  picture(1,j-1,1) + picture(2,j-1,1) + picture(2,j,1) + picture(1,j+1,1) + picture(2,j+1,1);
    if ( sum_line_point==1 ||sum_line_point==2)
        picture_line(1,j,1) = 0;
        picture_line(1,j,2) = 0;
        picture_line(1,j,3) = 0;
    else
        picture_line(1,j,1) = 1;
        picture_line(1,j,2) = 1;
        picture_line(1,j,3) = 1;
    end
    sum_line_point = 0;
end

sum_line_point = 0;
for j=2:Column-1
    sum_line_point = picture(Row,j-1,1) + picture(Row-1,j-1,1) + picture(Row,j+1,1) + picture(Row-1,j,1) + picture(Row-1,j+1,1);
    if ( sum_line_point==1 ||sum_line_point==2)
        picture_line(Row,j,1) = 0;
        picture_line(Row,j,2) = 0;
        picture_line(Row,j,3) = 0;
    else
        picture_line(Row,j,1) = 1;
        picture_line(Row,j,2) = 1;
        picture_line(Row,j,3) = 1;
    end
    sum_line_point = 0;
end

sum_line_point = 0;
for i=2:Row-1
    sum_line_point = picture(i-1,1,1) + picture(i-1,2,1) + picture(i,2,1) + picture(i+1,1,1) + picture(i+1,2,1);
    if ( sum_line_point==1 ||sum_line_point==2)
        picture_line(i,1,1) = 0;
        picture_line(i,1,2) = 0;
        picture_line(i,1,3) = 0;
    else
        picture_line(i,1,1) = 1;
        picture_line(i,1,2) = 1;
        picture_line(i,1,3) = 1;
    end
    sum_line_point = 0;
end

sum_line_point = 0;
for i=2:Row-1
    sum_line_point = picture(i-1,Column,1) + picture(i-1,Column-1,1) + picture(i,Column-1,1) + picture(i+1,Column-1,1) + picture(i+1,Column,1);
    if ( sum_line_point==1 ||sum_line_point==2)
        picture_line(i,Column,1) = 0;
        picture_line(i,Column,2) = 0;
        picture_line(i,Column,3) = 0;
    else
        picture_line(i,Column,1) = 1;
        picture_line(i,Column,2) = 1;
        picture_line(i,Column,3) = 1;
    end
    sum_line_point = 0;
end

sum_line_point = 0;
for i=2:Row-1
    for j=2:Column-1
        for k=1:3
            for l=1:3
                sum_line_point  =  sum_line_point + picture(i-2+k,j-2+l,1);
            end
        end

        if (sum_line_point==1||sum_line_point==2||sum_line_point==3||sum_line_point==4)
            picture_line(i,j,1) = 0;
            picture_line(i,j,2) = 0;
            picture_line(i,j,3) = 0;
        else
            picture_line(i,j,1) = 1;
            picture_line(i,j,2) = 1;
            picture_line(i,j,3) = 1;  
        end
        sum_line_point = 0;
    end
end
%轮廓处理结束

figure(3)
% subplot(1, 2, 1);
imshow(picture_line);
title('picture的轮廓处理');

%提取短直线
result_1(1,4)=0;%矩形边上有点的坐标
result_2(1,4)=0;%矩形斜线上有线的坐标
num=0;
distance=0;
count = 0;
for i=11:Row-11
    for j=1:Column-11
     
        if(picture_line(i,j,1)==0)
            for k=0:9
                if (picture_line(i-10,j+k,1)==0)
                    num = num + 1;
                    result_1(num,1) = i-10;
                    result_1(num,2) = j+k;
                    result_1(num,3) = i;
                    result_1(num,4) = j;
                end
            end
            
            for l=0:20
                if (picture_line(i-10+l,j+10,1)==0)
                    num = num + 1;
                    result_1(num,1) = i-10+l;
                    result_1(num,2) = j+10;
                    result_1(num,3) = i;
                    result_1(num,4) = j;
                end
            end
            
            for m=0:9
                if (picture_line(i+10,j+m,1)==0)
                    num = num + 1;
                    result_1(num,1) = i+10;
                    result_1(num,2) = j+m;
                    result_1(num,3) = i;
                    result_1(num,4) = j;
                end
            end
            
            for n=1:size(result_1,1)
                distance = sqrt( ( result_1(n,1)-result_1(n,3) )^2 + ( result_1(n,2)-result_1(n,4) )^2 );
                for p=1:round(distance)
                    if  picture_line( round(result_1(n,3) + (result_1(n,1)-result_1(n,3))*p/distance), round(result_1(n,4) + (result_1(n,2)-result_1(n,4))*p/distance),1)==1
                        break;
                    elseif p==round(distance)
                        count = count+1;
                        result_2(count,1)=result_1(n,3);
                        result_2(count,2)=result_1(n,4);
                        result_2(count,3)=result_1(n,1);
                        result_2(count,4)=result_1(n,2);
                    end
                end
            end
            result_1(:,:)=0;
            num=0;
            
        % if(picture_line(i,j,1)==0)结束
        end
  
    end
end
%提取短直线结束

picture_line_dispose = picture_line;
    for q=1:size(result_2,1)
        picture_line_dispose (result_2(q,1),result_2(q,2),1) = 1;
        picture_line_dispose (result_2(q,1),result_2(q,2),2) = 0;
        picture_line_dispose (result_2(q,1),result_2(q,2),3) = 0;
    end

figure(4)
% subplot(1, 2, 1);
imshow(picture_line_dispose);
title('picture的短直线起点');

% 整合长直线
result_3(1,4)=0;
result_4(1,5)=0;
line_num=0;
Judge_rate = 0.80;
RATE = 1;
judge_black = 0;
match_flag =0;

for r=1:size(result_2,1)
	result_3(r,1)=result_2(r,1);
    result_3(r,2)=result_2(r,2);%起点
    
    if  result_4(1,1)~=0
        for line_num=1:size(result_4,1)
            angle1= atan2(result_3(r,2)-result_4(line_num,2),result_3(r,1)-result_4(line_num,1));
            angle2= atan2(result_4(line_num,4)-result_3(r,2),result_4(line_num,3)-result_3(r,1));
            if abs(angle_minus_circle(angle1,angle2)) < 1.3
                match_flag=1;
            end
        end
    end
    
    if match_flag ==1
        match_flag =0;
        continue;
    end
    
    distance=0;
    for s=1:size(result_2,1)   
     distance_temp = sqrt( ( result_3(r,1)-result_2(s,3) )^2 + ( result_3(r,2)-result_2(s,4) )^2 );

        for t=1:round(distance_temp)
            if  picture_line( round(result_3(r,1) + (result_2(s,3)-result_3(r,1))*t/distance_temp), round(result_3(r,2) + (result_2(s,4)-result_3(r,2))*t/distance_temp),1)==0
                judge_black = judge_black +1;
            end
        end 

        RATE = double( judge_black/round(distance_temp) );
        judge_black = 0;%计数器置0        
        
        if RATE > Judge_rate&&distance_temp>distance
            distance = distance_temp;
            result_3(r,3) = result_2(s,3);
            result_3(r,4) = result_2(s,4); 
        end
        
    end
    
    if result_3(r,3)~=0
        if(result_4(1,1)==0)
            result_4(1,1)=result_3(r,1);
            result_4(1,2)=result_3(r,2);
            result_4(1,3)=result_3(r,3);
            result_4(1,4)=result_3(r,4);
            result_4(1,5)= distance;
        else
            line_num = size(result_4,1);
            result_4(line_num+1,1)=result_3(r,1);
            result_4(line_num+1,2)=result_3(r,2);
            result_4(line_num+1,3)=result_3(r,3);
            result_4(line_num+1,4)=result_3(r,4);
            result_4(line_num+1,5)=distance;
        end
    end
end
% 整合长直线结束

finally_line(Row,Column,:)=1;
for i=1:size(result_4,1)
    distance = sqrt( ( result_4(i,1)-result_4(i,3) )^2 + ( result_4(i,2)-result_4(i,4) )^2 );
    for r=1:round(distance)
        finally_line( round(result_4(i,1) + (result_4(i,3)-result_4(i,1))*r/distance), round(result_4(i,2) + (result_4(i,4)-result_4(i,2))*r/distance),1)=1;
        finally_line( round(result_4(i,1) + (result_4(i,3)-result_4(i,1))*r/distance), round(result_4(i,2) + (result_4(i,4)-result_4(i,2))*r/distance),2)=1;
        finally_line( round(result_4(i,1) + (result_4(i,3)-result_4(i,1))*r/distance), round(result_4(i,2) + (result_4(i,4)-result_4(i,2))*r/distance),3)=1;
    end
end

figure(5)
% subplot(1, 2, 1);
imshow(finally_line);
title('提取直线结果');
% im2double
% uint8→到double
% 0~255→0.0~1.0