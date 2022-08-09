FROM maven:3.6.0-jdk-11-slim AS build
WORKDIR /app
COPY . .
RUN mvn  clean package
FROM openjdk:11-jre-slim
# Environment Variable that defines the endpoint of sentiment-analysis python api.
#ENV SA_LOGIC_API_URL http://sa-logic:5000
COPY --from=build /app/target/sentiment-analysis-web-0.0.1-SNAPSHOT.jar /usr/local/lib/app.jar
EXPOSE 8080
CMD ["java", "-jar", "/usr/local/lib/app.jar", "--sa.logic.api.url=${SA_LOGIC_API_URL}"]


# FROM    maven:3.6.0-jdk-11-slim as builder
# COPY    ./*  /source/
# WORKDIR /source/
# RUN     mvn clean package

# FROM    openjdk:11-jre-slim
# # Environment Variable that defines the endpoint of sentiment-analysis python api.
# ENV     SA_LOGIC_API_URL http://localhost:5000
# COPY    --from=builder /source/target/sentiment-analysis-web-0.0.1-SNAPSHOT.jar /usr/local/lib/app.jar
# EXPOSE 8080
# CMD ["java", "-jar", "/usr/local/lib/app.jar", "--sa.logic.api.url=${SA_LOGIC_API_URL}"]
