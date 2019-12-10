clc
clf
clear all
close all
clear figure

filepath = ('/home/freelings/black_car/src/control/src/BLACK_CAR_MAP.txt');
A = load ( filepath );

angle( size( A, 1 )-1 ) = 0;
dispose_point( 1, : ) = A( 1, : );
count = 1;
for i=1:size( A, 1 )-1
    angle( i )  =  atan2( A( i+1, 2) - A( i, 2 ), A( i+1, 1 ) - A( i, 1 ) ) / pi * 180;
    
    p = polyfit( A( i:i+1, 1 ).', A( i:i+1, 2 ).', 1 );
    if( angle(i) <= 90 && angle(i) >= -90 )
        x = A( i, 1 ): 0.00001 :  A( i+1, 1 );
    else
        x = A( i, 1 ): -0.00001 :  A( i+1, 1 );
    end
    
    for j=1:size( x, 2 )
        temp_x = x( j );
        temp_y = p( 1 ) * x( j ) + p( 2 );
        if( sqrt( ( dispose_point( count, 1 ) - temp_x )^2+ ( dispose_point( count, 2 ) - temp_y )^2 ) > 0.2 )
            dispose_point( count + 1, 1 ) = temp_x;
            dispose_point( count + 1, 2 ) = temp_y;
            count = count  + 1;
        end
    end
end

figure
plot( angle );

figure
plot( A( :, 1), A( :, 2), '-');
hold on;
plot( dispose_point( :, 1 ), dispose_point( :, 2 ), '*-k' );
axis equal;

distacen_per_point( 1 ) = 0;
for i=1:size( dispose_point, 1 )-1
    distacen_per_point( i ) = sqrt( ( dispose_point( i, 1 ) - dispose_point( i+1, 1 ) )^2+ ( dispose_point( i, 2 ) - dispose_point( i+1, 2 ) )^2 );
end

figure
plot( distacen_per_point );

% filepath = ('/home/freelings/pointcloud/data/left_variance.txt');
% A = load ( filepath );
% filepath = ('/home/freelings/pointcloud/data/right_variance.txt');
% B = load ( filepath );
% plot( A( : ), '-r');
% hold on
% plot( B( : ), '-k');
% grid on;
