# ===== 1. BUILD =====
FROM node:20-alpine AS builder
WORKDIR /app

# ARG: build
# ENV: 실행 시에
ARG REACT_APP_API_URL=""
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# copy dependencies
COPY package.json ./
COPY package-lock.json ./

# install dependencies
RUN npm ci
# copy all the files
COPY . .

RUN npm run build

# ===== 2. NGINX =====
FROM nginx:alpine

# local nginx.conf를 container default.conf에 덮어쓰기
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]