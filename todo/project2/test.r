# 加载必要的包
library(e1071)
library(datasets)

# 加载鸢尾花数据集
data(iris)
head(iris,6)

# 将数据集划分为训练集和测试集
set.seed(123) # 设置随机种子以保证结果可重复
index <- sample(1:nrow(iris), 0.7*nrow(iris))
train_data <- iris[index, ]
test_data <- iris[-index, ]

# 训练 SVM 模型
svm_model <- svm(Species ~ ., data = train_data, kernel = "linear")

# 使用模型进行预测
predictions <- predict(svm_model, test_data)

# 评估模型性能
conf_matrix <- table(Predicted = predictions, Actual = test_data$Species)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)

# 输出结果
print(conf_matrix)
print(paste("Accuracy:", accuracy))

# 绘制决策边界 (可选)
plot(svm_model, data = train_data, Petal.Width ~ Petal.Length, slice = list(Sepal.Width = 3, Sepal.Length = 4))
