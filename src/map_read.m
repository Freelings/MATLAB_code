clc
clear
filepath = ('/home/freelings/文档/matlab/files/doc/');
a_points = load ([filepath,'map.7.15_disposed_5.txt']); 
% b_points = load ([filepath,'2018-07-15-16-26-24.txt']); 
% b_points = load ([filepath,'2018-07-15-16-38-18.txt']); 
% b_points = load ([filepath,'2018-07-15-17-02-43.txt']); 
b_points = load ([filepath,'test.txt']); 
plot(a_points(:,1),a_points(:,2),'r-*',b_points(:,1),b_points(:,2),'k-*');
% plot(b_points(:,1),b_points(:,2),'r-*')