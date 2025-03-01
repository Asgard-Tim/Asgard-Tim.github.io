% 读取数据
data = readtable('bind_data.txt', 'Format', '%f%f%f', 'Delimiter', ' ', 'ReadVariableNames', false);
data.Properties.VariableNames = {'decision_distance', 'robot_speed', 'human_speed'};

% 显示前几行数据
disp(head(data));

% 绘制以 robot_speed 为横坐标的散点图
figure;
subplot(1, 3, 1); % 左图
scatter(data.robot_speed, data.decision_distance, 50, data.human_speed, 'filled');
colorbar;
xlabel('Robot Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Robot Speed');
grid on;

% 绘制以 human_speed 为横坐标的散点图
subplot(1, 3, 2); % 中图
scatter(data.human_speed, data.decision_distance, 50, data.robot_speed, 'filled');
colorbar;
xlabel('Human Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Human Speed');
grid on;

% 计算每个机器人速度对应的决策距离的平均值
unique_robot_speeds = unique(data.robot_speed);
mean_decision_distance = arrayfun(@(x) mean(data.decision_distance(data.robot_speed == x)), unique_robot_speeds);

% 绘制柱状图
subplot(1, 3, 3); % 右图
bar(unique_robot_speeds, mean_decision_distance);
xlabel('Robot Speed');
ylabel('Average Decision Distance');
title('Average Decision Distance by Robot Speed');
grid on;
