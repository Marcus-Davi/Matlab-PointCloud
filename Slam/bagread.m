clear;close all;clc

bag = rosbag('laser.bag');
bagselect = select(bag,'topic','/cloud');
lasermsgs = readMessages(bagselect);

% save('lms_dataset.mat','lasermsgs')

SCANS = cell(length(lasermsgs),1);
for i = 1 : length(lasermsgs)
    SCANS{i} = lasermsgs{i}.readXYZ;
end

save('lms_dataset.mat','SCANS')

return


