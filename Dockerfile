FROM node:20

WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["npm","start"]# Use the official Nginx image as the base container
FROM nginx:alpine

# Copy all the bakery website template files into the default Nginx web root directory
COPY . /usr/share/nginx/html/

# Expose port 80 to make the container accessible
EXPOSE 80