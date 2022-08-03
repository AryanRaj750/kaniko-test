From    aryan750/jdk-maven:v1 as builder
COPY    ./*  /source/
WORKDIR /source/
RUN     /maven3/bin/mvn install

FROM    openjdk:8-jdk-alpine
# Environment Variable that defines the endpoint of sentiment-analysis python api.
ENV     SA_LOGIC_API_URL http://localhost:5000
COPY    --from=builder /source/target/sentiment-analysis-web-0.0.1-SNAPSHOT.jar /
EXPOSE 8080
CMD ["java", "-cp", "sentiment-analysis-web-0.0.1-SNAPSHOT.jar", "com.sa.web", "--sa.logic.api.url=${SA_LOGIC_API_URL}"]
