# Use NGINX Alpine as a lightweight base image
FROM nginx:alpine

# Copy all website files to the NGINX html directory
COPY . /usr/share/nginx/html

# Remove unnecessary files from the container
RUN rm -rf /usr/share/nginx/html/.git \
    /usr/share/nginx/html/.github \
    /usr/share/nginx/html/docker-compose* \
    /usr/share/nginx/html/Dockerfile \
    /usr/share/nginx/html/.env* \
    /usr/share/nginx/html/deploy.sh

# Configure NGINX for single page applications (optional)
RUN echo '\
server {\
    listen 80;\
    server_name localhost;\
    root /usr/share/nginx/html;\
    index index.html;\
    \
    # Enable gzip compression\
    gzip on;\
    gzip_types text/plain text/css application/javascript image/svg+xml;\
    gzip_min_length 1000;\
    \
    location / {\
        try_files $uri $uri/ /index.html;\
    }\
    \
    # Cache static assets\
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {\
        expires 30d;\
        add_header Cache-Control "public, no-transform";\
    }\
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]