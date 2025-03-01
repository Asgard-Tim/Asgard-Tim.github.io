% 读取数据
data = readtable('bind_data.txt', 'Format', '%f%f%f', 'Delimiter', ' ', 'ReadVariableNames', false);
data.Properties.VariableNames = {'decision_distance', 'robot_speed', 'human_speed'};

% 筛选出 robot speed 在 2.29 到 2.3 之间的数据
filter_indices = data.robot_speed >= 2.29 & data.robot_speed <= 2.31;
filtered_data = data(filter_indices, :);

% 筛选出 robot speed 不在 2.29 到 2.3 之间的数据
filter_indices1 = data.robot_speed < 2.29 | data.robot_speed > 2.31;
filtered_data1 = data(filter_indices1, :);

% 计算第一次筛选掉的数据的均值
filtered_out_mean1 = varfun(@mean, data(filter_indices1, :), 'InputVariables', {'decision_distance', 'robot_speed', 'human_speed'});

% 进一步筛选出 robot speed 不在 2.51 到 2.53 之间的数据
filter_indices2 = filtered_data1.robot_speed < 2.51 | filtered_data1.robot_speed > 2.53;
filtered_data2 = filtered_data1(filter_indices2, :);

% 计算第二次筛选掉的数据的均值
filtered_out_mean2 = varfun(@mean, filtered_data1(~filter_indices2, :), 'InputVariables', {'decision_distance', 'robot_speed', 'human_speed'});

% 将两次筛选掉的均值数据分别加入到筛选后的数据中
mean_data1 = array2table(repmat(filtered_out_mean1{1, :}, size(filtered_data1, 1), 1), 'VariableNames', data.Properties.VariableNames);
mean_data2 = array2table(repmat(filtered_out_mean2{1, :}, size(filtered_data1(~filter_indices2, :), 1), 1), 'VariableNames', data.Properties.VariableNames);

% 合并数据
filtered_data2_with_mean = [filtered_data2; mean_data1; mean_data2];

distance = filtered_data2_with_mean.decision_distance;
robot_speed = filtered_data2_with_mean.robot_speed;
human_speed = filtered_data2_with_mean.human_speed;

% 绘制散点图
figure;
scatter(robot_speed, distance, 50, human_speed, 'filled');
colorbar;
xlabel('Robot Speed');
ylabel('Decision Distance');
title('Scatter Plot of Decision Distance vs. Robot Speed');
grid on;