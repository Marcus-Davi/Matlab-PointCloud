clear;close all;clc

bag = rosbag('laser.bag');
bagselect = select(bag,'topic','/cloud');
lasermsgs = readMessages(bagselect);