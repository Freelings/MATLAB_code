clc
clear
close all

filepath = ('/home/freelings/文档/matlab/files/doc/pointcloud/');
points = load ([filepath,'2018-10-31.txt']); 


%第一环
line1(1,4) = 0;
count = 1;
for num=1:2016
    if points(num,1)>0
        line1(count,1) = points(num,1);
        line1(count,2) = points(num,2);
        line1(count,3) = points(num,3);
        count = count + 1;
    end
end

%第二环
line2(1,4) = 0;
count = 1;
for num=1:2016
    if points(1*2016+num,1)>0
        line2(count,1) = points(1*2016+num,1);
        line2(count,2) = points(1*2016+num,2);
        line2(count,3) = points(1*2016+num,3);
        count = count + 1;
    end
end

%第三环
line3(1,4) = 0;
count = 1;
for num=1:2016
    if points(2*2016+num,1)>0
        line3(count,1) = points(2*2016+num,1);
        line3(count,2) = points(2*2016+num,2);
        line3(count,3) = points(2*2016+num,3);
        count = count + 1;
    end
end

%第四环
line4(1,4) = 0;
count = 1;
for num=1:2016
    if points(3*2016+num,1)>0
        line4(count,1) = points(3*2016+num,1);
        line4(count,2) = points(3*2016+num,2);
        line4(count,3) = points(3*2016+num,3);
        count = count + 1;
    end
end

%第五环
line5(1,4) = 0;
count = 1;
for num=1:2016
    if points(4*2016+num,1)>0
        line5(count,1) = points(4*2016+num,1);
        line5(count,2) = points(4*2016+num,2);
        line5(count,3) = points(4*2016+num,3);
        count = count + 1;
    end
end

%第六环
line6(1,4) = 0;
count = 1;
for num=1:2016
    if points(5*2016+num,1)>0
        line6(count,1) = points(5*2016+num,1);
        line6(count,2) = points(5*2016+num,2);
        line6(count,3) = points(5*2016+num,3);
        count = count + 1;
    end
end

%第七环
line7(1,4) = 0;
count = 1;
for num=1:2016
    if points(6*2016+num,1)>0
        line7(count,1) = points(6*2016+num,1);
        line7(count,2) = points(6*2016+num,2);
        line7(count,3) = points(6*2016+num,3);
        count = count + 1;
    end
end

%第八环
line8(1,4) = 0;
count = 1;
for num=1:2016
    if points(7*2016+num,1)>0
        line8(count,1) = points(7*2016+num,1);
        line8(count,2) = points(7*2016+num,2);
        line8(count,3) = points(7*2016+num,3);
        count = count + 1;
    end
end

figure(1)
% plot3(line1(:,1),line1(:,2),line1(:,3),line3(:,1),line3(:,2),line3(:,3),'Color',[0 0 0.9],'LineWidth',2);
% hold on;
% plot3(line5(:,1),line5(:,2),line5(:,3),line7(:,1),line7(:,2),line7(:,3),'Color',[0 0 0.9],'LineWidth',2);
% hold on;
% plot3(line2(:,1),line2(:,2),line2(:,3),line4(:,1),line4(:,2),line4(:,3),'Color',[0.3 0.8 0.5],'LineWidth',2);
% hold on;
% plot3(line6(:,1),line6(:,2),line6(:,3),line8(:,1),line8(:,2),line8(:,3),'Color',[0.3 0.8 0.5],'LineWidth',2);
% axis equal

%第一环角度计算排序，从-pi/2到pi/2
temp(1,4) = 0;
for num=1:size(line1,1)
    line1(num,4) = atan(line1(num,2)/line1(num,1));
    if num > 1
        if line1(num,4) < line1(num-1,4)
            temp_num = num;
            while temp_num>1 && line1(temp_num,4) < line1(temp_num-1,4)%继续判断
                temp = line1(temp_num,:); 
                line1(temp_num,:) = line1(temp_num-1,:);
                line1(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第二环角度计算排序，从-pi/2到pi/2
for num=1:size(line2,1)
    line2(num,4) = atan(line2(num,2)/line2(num,1));
    if num > 1
        if line2(num,4) < line2(num-1,4)
            temp_num = num;
            while temp_num>1 && line2(temp_num,4) < line2(temp_num-1,4)%继续判断
                temp = line2(temp_num,:); 
                line2(temp_num,:) = line2(temp_num-1,:);
                line2(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第三环角度计算排序，从-pi/2到pi/2
for num=1:size(line3,1)
    line3(num,4) = atan(line3(num,2)/line3(num,1));
    if num > 1
        if line3(num,4) < line3(num-1,4)
            temp_num = num;
            while temp_num>1 && line3(temp_num,4) < line3(temp_num-1,4)%继续判断
                temp = line3(temp_num,:); 
                line3(temp_num,:) = line3(temp_num-1,:);
                line3(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第四环角度计算排序，从-pi/2到pi/2
for num=1:size(line4,1)
    line4(num,4) = atan(line4(num,2)/line4(num,1));
    if num > 1
        if line4(num,4) < line4(num-1,4)
            temp_num = num;
            while temp_num>1 && line4(temp_num,4) < line4(temp_num-1,4)%继续判断
                temp = line4(temp_num,:); 
                line4(temp_num,:) = line4(temp_num-1,:);
                line4(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第五角度计算排序，从-pi/2到pi/2
for num=1:size(line5,1)
    line5(num,4) = atan(line5(num,2)/line5(num,1));
    if num > 1
        if line5(num,4) < line5(num-1,4)
            temp_num = num;
            while temp_num>1 && line5(temp_num,4) < line5(temp_num-1,4)%继续判断
                temp = line5(temp_num,:); 
                line5(temp_num,:) = line5(temp_num-1,:);
                line5(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第六环角度计算排序，从-pi/2到pi/2
for num=1:size(line6,1)
    line6(num,4) = atan(line6(num,2)/line6(num,1));
    if num > 1
        if line6(num,4) < line6(num-1,4)
            temp_num = num;
            while temp_num>1 && line6(temp_num,4) < line6(temp_num-1,4)%继续判断
                temp = line6(temp_num,:); 
                line6(temp_num,:) = line6(temp_num-1,:);
                line6(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第七环角度计算排序，从-pi/2到pi/2
for num=1:size(line7,1)
    line7(num,4) = atan(line7(num,2)/line7(num,1));
    if num > 1
        if line7(num,4) < line7(num-1,4)
            temp_num = num;
            while temp_num>1 && line7(temp_num,4) < line7(temp_num-1,4)%继续判断
                temp = line7(temp_num,:); 
                line7(temp_num,:) = line7(temp_num-1,:);
                line7(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

%第八环角度计算排序，从-pi/2到pi/2
for num=1:size(line8,1)
    line8(num,4) = atan(line8(num,2)/line8(num,1));
    if num > 1
        if line8(num,4) < line8(num-1,4)
            temp_num = num;
            while temp_num>1 && line8(temp_num,4) < line8(temp_num-1,4)%继续判断
                temp = line8(temp_num,:); 
                line8(temp_num,:) = line8(temp_num-1,:);
                line8(temp_num-1,:) = temp;
                temp_num = temp_num - 1;
            end
        end
    end 
end

figure(2)
% plot(line1(:,4),'k-*');
% hold on;
% plot(line2(:,4),'r-*');
% hold on;
% plot(line3(:,4),'g-*')
% hold on;
% plot(line4(:,4),'b-*');
% hold on;
% plot(line5(:,4),'c-*')
% hold on;
% plot(line6(:,4),'m-*');
% hold on;
% plot(line7(:,4),'y-*');
% hold on;
% plot(line8(:,4),'-*','Color',[0.3 0.8 0.5]);

figure(3)
% %3D
% plot(line_turn1(:,1),line_turn1(:,2),'k-*',line_turn2(:,1),line_turn2(:,2),'r-*');
% hold on;
% plot(line_turn3(:,1),line_turn3(:,2),'g-*',line_turn4(:,1),line_turn4(:,2),'b-*');
% hold on;
% plot(line_turn5(:,1),line_turn5(:,2),'c-*',line_turn6(:,1),line_turn6(:,2),'m-*');
% hold on;
% plot(line_turn7(:,1),line_turn7(:,2),'y-*',line_turn8(:,1),line_turn8(:,2),'*-','Color',[0.3 0.8 0.5]);

%2D
plot(line1(:,1),line1(:,2),line3(:,1),line3(:,2),'Color',[0 0 0.9],'LineWidth',2);
hold on;
plot(line5(:,1),line5(:,2),line7(:,1),line7(:,2),'Color',[0 0 0.9],'LineWidth',2);
hold on;
plot(line2(:,1),line2(:,2),line4(:,1),line4(:,2),'Color',[0.3 0.8 0.5],'LineWidth',2);
hold on;
plot(line6(:,1),line6(:,2),line8(:,1),line8(:,2),'Color',[0.3 0.8 0.5],'LineWidth',2);
axis equal;

% hight1(4) = 0;
% for num=1:size(line1,1)
%     if line1(num,3) < hight1(4)
%         hight1(1) = num;
%         hight1(2:4) = line1(num,1:3);
%     end
% end

%第一环提取
edge1(1,30,4) = 0;
count = 1;
for num=30:size(line1,1)
    if ( line1(num,3)-line1(num-29,3) ) < - 0.12 
        edge1(count,:,:) = line1(num-29:num,:);
        count = count+1;
    end
end

%第二环提取
edge2(1,30,4) = 0;
count = 1;
for num=30:size(line2,1)
    if ( line2(num,3)-line2(num-29,3) ) < - 0.12 
        edge2(count,:,:) = line2(num-29:num,:);
        count = count+1;
    end
end

%第三环提取
edge3(1,30,4) = 0;
count = 1;
for num=30:size(line3,1)
    if ( line3(num,3)-line3(num-29,3) ) < - 0.12 
        edge3(count,:,:) = line3(num-29:num,:);
        count = count+1;
    end
end

%第四环提取
edge4(1,30,4) = 0;
count = 1;
for num=30:size(line4,1)
    if ( line4(num,3)-line4(num-29,3) ) < - 0.12 
        edge4(count,:,:) = line4(num-29:num,:);
        count = count+1;
    end
end


figure(4)
plot3(line1(:,1),line1(:,2),line1(:,3),line3(:,1),line3(:,2),line3(:,3),'Color',[0 0 0.9],'LineWidth',2);
hold on;
plot3(line2(:,1),line2(:,2),line2(:,3),line4(:,1),line4(:,2),line4(:,3),'Color',[0.3 0.8 0.5],'LineWidth',2);
hold on;
for num=1:size(edge1,1)
    plot3(edge1(num,:,1),edge1(num,:,2),edge1(num,:,3),'k-*');
    hold on;
end
for num=1:size(edge2,1)
    plot3(edge2(num,:,1),edge2(num,:,2),edge2(num,:,3),'k-*');
    hold on;
end
for num=1:size(edge3,1)
    plot3(edge3(num,:,1),edge3(num,:,2),edge3(num,:,3),'k-*');
    hold on;
end
for num=1:size(edge4,1)
    plot3(edge4(num,:,1),edge4(num,:,2),edge4(num,:,3),'k-*');
    hold on;
end
axis equal;


