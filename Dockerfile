FROM node:alpine as builder
COPY package.json /sa-frontend/
WORKDIR /sa-frontend
RUN npm install
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /sa-frontend/build /usr/share/nginx/html
EXPOSE 80