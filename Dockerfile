# Build phase
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .

# Comment out this line to remove the proxy settings
RUN npm config set proxy http://10.7.211.16:911/ && \
	npm config set https-proxy=http://10.7.211.16:911/ && \
	npm config set strict-ssl false && \
	npm config set registry http://registry.npmjs.org/ && \
	echo "nameserver 10.248.2.1" >> /etc/resolv.conf

RUN npm install
COPY . .
RUN npm run build


# Run phase
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html
