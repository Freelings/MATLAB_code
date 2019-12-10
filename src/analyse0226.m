clc;
clf;
clear all;
clear figure;
filepath = ('/home/freelings/pointcloud/test/');
data_original = load ([filepath,'135.txt']); 

end1 = 303;
end2 = 622;
end3 = 931;

data1 =  data_original( 1:end1, : );
data2 =  data_original( end1 + 2 : end2, : );
data3 =  data_original( end2 + 2 : end3, : );
data4 =  data_original( end3 + 2 : size( data_original, 1 ), : );

figure(1)
plot( data1( :, 1 ), data1( :, 2 ), 'k-*');
hold on;
plot( data2( :, 1 ), data2( :, 2 ), 'r-*');
hold on;
plot( data3( :, 1 ), data3( :, 2 ), 'b-*');
hold on;
plot( data4( :, 1 ), data4( :, 2 ), 'g-*');
title( '原始数据' );
axis equal;

figure(2)
plot( data1(  :, 4 ), 'k-*');
hold on;
plot( data2(  :, 4 ), 'r-*');
hold on;
plot( data3(  :, 4 ), 'b-*');
hold on;
plot( data4(  :, 4 ), 'g-*');
title( '原始数据' );
axis equal;

for j = 2 : size( data3, 1 )
    if data3( j, 4 ) < data3( j - 1, 4 )
        j
    end
end

for i = 2 : size( data4, 1 )
    if data4( i, 4 ) < data4( i - 1, 4 )
        i
    end
end