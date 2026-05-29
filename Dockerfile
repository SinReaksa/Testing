# Use the official lightweight Nginx image
FROM nginx:alpine

# Copy all the static HTML/CSS website files into Nginx's public directory
COPY . /usr/share/nginx/html/

# Expose port 80 to web traffic
EXPOSE 80