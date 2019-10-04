function draw3dRect (center, size, orientation)
% plots a red rectangle given its center, size and orientation
% center:       (x,y,z)
% size:         (x,y,z)
% orientation:  (roll, pitch, yaw)

x=([0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]-0.5)*size(1);%+center(1);
y=([0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]-0.5)*size(2);%+center(2);
z=([0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]-0.5)*size(3);%+center(3);

rotm = eul2rotm(flip(orientation));

for i=1:6
    
    points = (rotm*[x(:,i),y(:,i),z(:,i)]')' + [center;center;center;center];
    
    h=patch(points(:,1),points(:,2),points(:,3),'r');
    set(h,'edgecolor','k')
end 