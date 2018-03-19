clear all
close all
receiver_locations = [0 0; 5000 0; 0 5000; 5000 5000];
receiver_azimuths = [45 135 -45 -135];
receiver_est_azimuths = [5 -3 8 -7];
delta_angle = 5;
net_angle = receiver_azimuths + receiver_est_azimuths;
slopes = tand(net_angle)
length = 7500;
dummy = 0:length;
receiver_line = [length*cosd(net_angle); length*sind(net_angle)]';
x_vals = [receiver_locations(:,1) receiver_locations(:,1)+receiver_line(:,1)];
y_vals = [receiver_locations(:,2) receiver_locations(:,2)+receiver_line(:,2)];
hold on
for i = 1:size(x_vals,1)
    coeff(i,:) = polyfit(x_vals(i,:),y_vals(i,:),1);
    est(i,:) = coeff(i,1)*dummy+coeff(i,2);
    %plot(x_vals(i,:),y_vals(i,:));
end
for i = 1:size(x_vals,1)
    plot(x_vals(i,:),y_vals(i,:));
end

xlim([0 7500]); ylim([0 7500]);
legend('Receiver1','Receiver2','Receiver3','Receiver4')

intercepts = zeros(size(x_vals,1),size(x_vals,1),2);
for i = 1:size(x_vals,1)
    for l = i+1:size(x_vals,1)
        [a,index] = min(abs(est(i,:)-est(l,:)));
        intercepts(i,l,:) = [index est(i,index)];
    end
end
xints = nonzeros(intercepts(:,:,1));
yints = nonzeros(intercepts(:,:,2));

point = [mean(xints) mean(yints)];
radius = sqrt(std(xints)^2 + std(yints)^2)
viscircles(point,radius)
        
%[a,index] = min(abs(est(1,:)-est(2,:)-est(3,:)))
%fill(xints,yints,'r')
hold off