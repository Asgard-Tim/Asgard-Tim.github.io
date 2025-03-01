#模拟数据生成
set.seed(123) #设置随机种子，固定每次运行程序生成的随机数
n <- 200  # 每个类别的数据点数

# 生成类别1的数据
x1 <- matrix(rnorm(n * 2, mean = 0), ncol = 2)
y1 <- rep(0, n)
# 生成类别2的数据
x2 <- matrix(rnorm(n * 2, mean = 2.8), ncol = 2)
y2 <- rep(1, n)
# 合并数据
x <- rbind(x1, x2)
y <- c(y1, y2)

# 加载 ggplot2 包
library(ggplot2)

# 创建数据框
data <- data.frame(x1 = x[, 1], x2 = x[, 2], y = factor(y))

# 设置点的大小和透明度
p <- ggplot(data, aes(x = x1, y = x2, color = y)) +
  geom_point(size = 3, alpha = 0.7) +  # 调整点的大小和透明度
  scale_color_manual(values = c("blue", "red")) +
  labs(x = "x1", y = "x2", color = "Class") +
  theme_minimal()

# 调整背景和边界线
p + theme(panel.background = element_rect(fill = "white", color = "black"),
          panel.border = element_rect(color = "black", fill = NA),
          axis.line = element_line(color = "black"))

ggsave("101.png", plot = p, width = 6, height = 6, units = "in", dpi = 300)

# 将数据分为训练集和测试集
train_index <- sample(1:(2 * n), 0.7 * 2 * n)
x_train <- x[train_index, ]
y_train <- y[train_index]
x_test <- x[-train_index, ]
y_test <- y[-train_index]

# 合并 
train_data <- cbind(x_train, y_train)
test_data <- cbind(x_test, y_test)

#2.硬间隔SVM模型训练
library(e1071)
# 训练硬间隔SVM模型
# 设置 cost 为一个非常大的值
cost_value <- 1e5
svm_model <- svm(x_train,y_train, type = "C-classification", kernel = "linear", cost = cost_value, scale = FALSE)

# 使用SVM模型进行预测
svm_predictions <- predict(svm_model, x_test)

# 计算SVM模型的分类准确率
svm_accuracy <- sum(svm_predictions == y_test) / length(y_test)
print(paste("SVM模型的分类准确率:", svm_accuracy))

# 将训练数据转换为数据框
train_data <- data.frame(x = x_train, y = as.factor(y_train))

# 将测试数据转换为数据框
test_data <- data.frame(x = x_test, y = as.factor(y_test))

# 添加预测结果
test_data$svm_predictions <- as.factor(svm_predictions)

# 绘制 SVM 分类结果
p1 <- ggplot(test_data, aes(x = x.1, y = x.2, color = svm_predictions)) +
  geom_point(alpha = 0.6, size = 3) +
  ggtitle("SVM 分类结果") +
  theme_minimal()

ggsave("103.png", plot = p1, width = 6, height = 6, units = "in", dpi = 300)

# 画出分类器边界
plot_svm <- function(model, data) {
  grid <- expand.grid(
    x1 = seq(min(data$x1) - 1, max(data$x1) + 1, length = 100),
    x2 = seq(min(data$x2) - 1, max(data$x2) + 1, length = 100)
  )
  
  grid$svm_predictions <- predict(model, grid)
  
  ggplot() +
    geom_point(data = data, aes(x = x1, y = x2, color = y), size = 3, alpha = 0.7) +
    geom_point(data = grid, aes(x = x1, y = x2, color = svm_predictions), size = 0.3, alpha = 0.3) +
    labs(x = "x1", y = "x2", color = "Class") +
    theme_minimal() +
    ggtitle("SVM 分类器边界")
}

# 绘制 SVM 分类器边界
p2 <- plot_svm(svm_model, data)
ggsave("104.png", plot = p2, width = 6, height = 6, units = "in", dpi = 300)

# 训练逻辑回归模型
logistic_model <- glm(y ~ ., data = train_data, family = binomial)

# 使用逻辑回归模型进行预测
logistic_probabilities <- predict(logistic_model, newdata = data.frame(x = x_test), type = "response")
logistic_predictions <- ifelse(logistic_probabilities > 0.5, 1, 0)

# 计算逻辑回归模型的分类准确率
logistic_accuracy <- sum(logistic_predictions == y_test) / length(y_test)
print(paste("逻辑回归模型的分类准确率:", logistic_accuracy))

# 绘制逻辑回归分类结果，并标注分类器
p3 <- ggplot(test_data, aes(x = x.1, y = x.2, color = logistic_predictions)) +
  geom_point(alpha = 0.6, size = 3) +
  ggtitle("逻辑回归分类结果") +
  theme_minimal()

# 标注分类器
p3 <- p3 + geom_text(aes(label = logistic_predictions), hjust = 1.5, vjust = 1.5)

ggsave("102.png", plot = p3, width = 6, height = 6, units = "in", dpi = 300)

svm_model_modify <- svm(x_train,y_train, type = "C-classification", kernel = "radial", gamma = 2, cost = 1, scale = FALSE)

# 使用SVM模型进行预测
svm_predictions_modify <- predict(svm_model_modify, x_test)

# 计算SVM模型的分类准确率
svm_accuracy_modify <- sum(svm_predictions_modify == y_test) / length(y_test)

print(paste("改进SVM模型的分类准确率:", svm_accuracy_modify))

# 将训练数据转换为数据框
train_data <- data.frame(x = x_train, y = as.factor(y_train))

# 将测试数据转换为数据框
test_data <- data.frame(x = x_test, y = as.factor(y_test))

# 添加预测结果
test_data$svm_predictions_modify <- as.factor(svm_predictions_modify)

# 绘制 SVM 分类结果
p4 <- ggplot(test_data, aes(x = x.1, y = x.2, color = svm_predictions_modify)) +
  geom_point(alpha = 0.6, size = 3) +
  ggtitle("改进后的SVM 分类结果") +
  theme_minimal()

ggsave("12.png", plot = p4, width = 6, height = 6, units = "in", dpi = 300)

# 画出分类器边界
plot_svm <- function(model, data) {
  grid <- expand.grid(
    x1 = seq(min(data$x1) - 1, max(data$x1) + 1, length = 100),
    x2 = seq(min(data$x2) - 1, max(data$x2) + 1, length = 100)
  )
  
  grid$svm_predictions_modify <- predict(model, grid)
  
  ggplot() +
    geom_point(data = data, aes(x = x1, y = x2, color = y), size = 3, alpha = 0.7) +
    geom_point(data = grid, aes(x = x1, y = x2, color = svm_predictions_modify), size = 0.3, alpha = 0.3) +
    labs(x = "x1", y = "x2", color = "Class") +
    theme_minimal() +
    ggtitle("改进后的SVM 分类器边界")
}

# 绘制 SVM 分类器边界
p5 <- plot_svm(svm_model_modify, data)
ggsave("13.png", plot = p5, width = 6, height = 6, units = "in", dpi = 300)
