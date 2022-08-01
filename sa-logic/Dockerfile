FROM python:3.6-slim as builder
COPY sa /app
WORKDIR /app
RUN pip3 install -r requirements.txt && \
    python3 -m textblob.download_corpora
RUN pyinstaller --onefile sentiment_analysis.py

FROM alpine:3.14
COPY --from=builder /app/sentiment_analysis /
EXPOSE 5000
CMD ["sentiment_analysis"]
