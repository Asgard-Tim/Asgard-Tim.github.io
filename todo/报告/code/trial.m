% 读取数据
data = readtable('bind_data.txt', 'Format', '%f%f%f', 'Delimiter', ' ', 'ReadVariableNames', false);
data.Properties.VariableNames = {'decision_distance', 'robot_speed', 'human_speed'};

% 显示前几行数据
disp(head(data));

% 绘制以 robot_speed 为横坐标的散点图
figure;
subplot(1, 2, 1); % 左图
scatter(data.robot_speed, data.decision_distance, 50, data.human_speed, 'filled');
colorbar;
xlabel('Robot Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Robot Speed');
grid on;

% 绘制以 human_speed 为横坐标的散点图
subplot(1, 2, 2); % 右图
scatter(data.human_speed, data.decision_distance, 50, data.robot_speed, 'filled');
colorbar;
xlabel('Human Speed');
ylabel('Decision Distance');
title('Decision Distance vs. Human Speed');
grid on;

% 创建新的 figure，分别绘制 human speed 为 0.5, 0.8, 2 和 2.8 的图
human_speeds = [0.5, 0.8, 2, 2.8];
for i = 1:length(human_speeds)
    speed = human_speeds(i);
    subset = data(data.human_speed == speed, :);
    
    % 将 robot_speed 分段
    edges = linspace(min(subset.robot_speed), max(subset.robot_speed), 10);
    [~,~,bin] = histcounts(subset.robot_speed, edges);
    
    % 计算每个分段的平均值
    avg_robot_speed = accumarray(bin, subset.robot_speed, [], @mean);
    avg_decision_distance = accumarray(bin, subset.decision_distance, [], @mean);
    
    % 去除 NaN 值
    avg_robot_speed = avg_robot_speed(~isnan(avg_robot_speed));
    avg_decision_distance = avg_decision_distance(~isnan(avg_decision_distance));
    
    figure;
    scatter(avg_robot_speed, avg_decision_distance, 50, 'filled');
    xlabel('Robot Speed');
    ylabel('Decision Distance');
    title(['Decision Distance vs. Robot Speed for Human Speed = ', num2str(speed)]);
    grid on;
end
