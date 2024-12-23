# Step 1: Use an official Node.js runtime as a parent image
FROM node:18 AS build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Step 4: Set NODE_OPTIONS to fix OpenSSL error
ENV NODE_OPTIONS=--openssl-legacy-provider

# Step 4: Copy the rest of the application code
COPY . .

# Step 5: Build the React app for production
RUN npm run build

# Step 6: Serve the built app using an NGINX server
FROM nginx:alpine

# Step 7: Copy the build files to the NGINX server
COPY --from=build /app/build /usr/share/nginx/html

# Step 8: Expose the port for the NGINX server
EXPOSE 80

# Step 9: Run the NGINX server
CMD ["nginx", "-g", "daemon off;"]
