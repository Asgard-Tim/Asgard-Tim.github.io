clear;
clc;

data = load('bind_data.txt');
mean_distance = mean(data(:,1));
var_distance = var(data(:,1));
mean_robospeed = mean(data(:,2));
mean_humanspeed = mean(data(:,3));
distance = data(:,1);
robospeed = data(:,2);
humanspeed  = data(:,3);

% 绘制以 robot_speed 为横坐标的散点图
figure;
subplot(1, 2, 1); % 左图
scatter(robospeed, distance, 50, humanspeed, 'filled');
colorbar;
xlabel('Robot Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Robot Speed');
grid on;

% 绘制以 human_speed 为横坐标的散点图
subplot(1, 2, 2); % 右图
scatter(humanspeed, distance, 50, robospeed, 'filled');
colorbar;
xlabel('Human Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Human Speed');
grid on;

% 分组
group1_indices = humanspeed == 0.5;
group2_indices = humanspeed == 0.8;
group3_indices = humanspeed == 2;
group4_indices = humanspeed == 2.8;

% 提取每个组的数据
group1_data = data(group1_indices,:);
group2_data = data(group2_indices,:);
group3_data = data(group3_indices,:);
group4_data = data(group4_indices,:);

% 计算每个组的距离均值
mean_distance_group1 = mean(group1_data(:,1));
mean_distance_group2 = mean(group2_data(:,1));
mean_distance_group3 = mean(group3_data(:,1));
mean_distance_group4 = mean(group4_data(:,1));

% 创建柱状图
figure;
bar([mean_distance_group1, mean_distance_group2, mean_distance_group3, mean_distance_group4]);
xlabel('Group');
ylabel('Mean Distance');
title('Mean Distance for Each Group');
xticklabels({'Group 1 (0.5)', 'Group 2 (0.8)', 'Group 3 (2)', 'Group 4 (2.8)'});
grid on;

new_data = data; % 创建一个新的数据副本，以便进行修改
% 提取具有相同 robospeed 数值的数据
unique_robospeed = unique(robospeed);
mean_distance_robospeed =[];

to_remove_indices = [];
for i = 1:length(unique_robospeed)
    indices = robospeed == unique_robospeed(i);
    if sum(indices) > 3
        to_remove_indices = [to_remove_indices; find(indices)]; % 添加需要删除的索引
        mean_distance_robospeed = [mean_distance_robospeed; mean(distance(indices)),mean(robospeed(indices)),mean(humanspeed(indices))];
    end
end

% 删除这些数据点
new_data(to_remove_indices, :) = [];
new_data = [new_data;mean_distance_robospeed];

figure;
scatter(new_data(:,2), new_data(:,1), 50, new_data(:,3), 'filled');
colorbar;
xlabel('Robot Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Robot Speed (Updated)');
grid on;

repeated_data = []; % 创建一个空的矩阵，用于存放重复的数据点

% 找到具有相同 robospeed 值且数量大于等于 3 的索引
for i = 1:length(unique_robospeed)
    indices = find(robospeed == unique_robospeed(i));
    if length(indices) >= 3
        repeated_data = [repeated_data; data(indices, :)]; % 添加重复的数据点
    end
end

%重复点为2.2937和2.5291
% 找到robospeed等于2.2937和2.5291的数据索引
indices_22937 = find(robospeed == repeated_data(1,2));
indices_25291 = find(robospeed == repeated_data(29,2));

% 获取这些索引对应的数据
repeated_data_22937 = data(indices_22937, :);
repeated_data_25291 = data(indices_25291, :);

humanspeed1=repeated_data_22937(:,3);
humanspeed2=repeated_data_25291(:,3);

% 分组
group1_indices1 = humanspeed1 == 0.5;
group2_indices1 = humanspeed1 == 0.8;
group3_indices1 = humanspeed1 == 2;
group4_indices1 = humanspeed1 == 2.8;

% 提取每个组的数据
group1_data1 = data(group1_indices1,:);
group2_data1 = data(group2_indices1,:);
group3_data1 = data(group3_indices1,:);
group4_data1 = data(group4_indices1,:);

% 计算每个组的距离均值
mean_distance_group1 = mean(group1_data1(:,1));
mean_distance_group2 = mean(group2_data1(:,1));
mean_distance_group3 = mean(group3_data1(:,1));
mean_distance_group4 = mean(group4_data1(:,1));

% 创建柱状图
figure;
subplot(1,2,1);
bar([mean_distance_group1, mean_distance_group2, mean_distance_group3, mean_distance_group4]);
xlabel('Group');
ylabel('Mean Distance');
title('Mean Distance for Each Group');
xticklabels({'Group 1 (0.5)', 'Group 2 (0.8)', 'Group 3 (2)', 'Group 4 (2.8)'});
grid on;

% 分组
group1_indices2 = humanspeed2 == 0.5;
group2_indices2 = humanspeed2 == 0.8;
group3_indices2 = humanspeed2 == 2;
group4_indices2 = humanspeed2 == 2.8;

% 提取每个组的数据
group1_data2 = data(group1_indices2,:);
group2_data2 = data(group2_indices2,:);
group3_data2 = data(group3_indices2,:);
group4_data2 = data(group4_indices2,:);

% 计算每个组的距离均值
mean_distance_group1 = mean(group1_data2(:,1));
mean_distance_group2 = mean(group2_data2(:,1));
mean_distance_group3 = mean(group3_data2(:,1));
mean_distance_group4 = mean(group4_data2(:,1));

% 创建柱状图
subplot(1,2,2);
bar([mean_distance_group1, mean_distance_group2, mean_distance_group3, mean_distance_group4]);
xlabel('Group');
ylabel('Mean Distance');
title('Mean Distance for Each Group');
xticklabels({'Group 1 (0.5)', 'Group 2 (0.8)', 'Group 3 (2)', 'Group 4 (2.8)'});
grid on;
