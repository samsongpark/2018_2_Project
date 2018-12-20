###### 0. �������� ######

# ���� �ȵǸ�  ÷���� �ؼ����� �����ؼ� ������

###### 1. Collecting data ######

teens <- read.csv("snsdata.csv")
str(teens)

###### 2. Exploring and preparing the data ######

# ������ Ȯ���ߵ��� gender �������� NA���� ���ԵǾ� �ִ�.
table(teens$gender)

# �䷸�� �ϸ� NA������ �� �� �ִ�.
table(teens$gender, useNA = "ifany")

# �����͸� �� ���캸�� gender�� �ܿ��� age ���� ���� 5086���� NA�� ���� ������ �ִ�.
summary(teens$age)

# ���� �ּҰ��� �ִ밪�� ���캸�� 3��� 106���� ���ԵǾ� �ִ�.. 
# �츰 ����л� �� û�ҳ��� ���� �м��ϴ� ���̴� �߸� ������ ������ �� NA ������ ����������
teens$age <- ifelse(teens$age >= 13 & teens$age < 20,
                    teens$age, NA)

# �ٽ� Ȯ���غ��� �����ϰԵ�.. NA���� �� �þ���.
summary(teens$age)

###### 2-1. Dummy coding missing values ######

teens$female <- ifelse(teens$gender == "F" &
                         !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)


table(teens$gender, useNA = "ifany")

table(teens$female, useNA = "ifany")

table(teens$no_gender, useNA = "ifany")

###### 2-2. Imputing missing values ######

mean(teens$age) # doesn't work

# �л����� ��ճ��̰� 17�� ������ ���� �� �� �ִ�.
mean(teens$age, na.rm = TRUE) 

# ������ gradyear�� ��� ���̸� ���� �ͱ� ������ aggregate�Լ��� ����Ѵ�.
# aggregate(�����÷�~���ص��÷�, ������, �Լ�)
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)

# ave(������ ����, ������ �Ǵ� ����, ������ �Լ�)
ave_age <- ave(teens$age, teens$gradyear,
               FUN = function(x) mean(x, na.rm = TRUE))

# NA���� �� �մ� ���� ave�Լ��� ������Ѽ� �����⵵(gradyear)�� �����Ǵ� ���� ����� ����ִ´�.
teens$age <- ifelse(is.na(teens$age), ave_age, teens$age)

head(teens$age)

summary(teens$age)

###### 3. Training a model on the data ######

library(stats)

str(teens[5:40])

# kmeans()���� ���� numeric data���� parameter�� ��� �� �� �ֱ� ������
# 36�� �ܾ ���� �������� ���� ��´�. (gradyear, gender, friends , age, female, no_gender ����)
interests <- teens[5:40]

# nomarlize�� �ϱ� ���� �� �����鿡 scale�� ���δ�.
interests_z <- as.data.frame(lapply(interests, scale))

# �� ó�� ���ߵ��� 5���� �������� ���� ���̱⿡ k�� 5�� �ִ´�.
teen_clusters <- kmeans(interests_z, 5)

###### 4. Evaluating model performance ######

teen_clusters$size

teen_clusters$centers

apply(teen_clusters$centers, 2, which.max)

###### 5. Improving model performance ######

teens$cluster <- teen_clusters$cluster

teens[1:5, c("cluster", "gender", "age", "friends")]

aggregate(data = teens, age ~ cluster, mean)

aggregate(data = teens, female ~ cluster, mean)

aggregate(data = teens, friends ~ cluster, mean)
