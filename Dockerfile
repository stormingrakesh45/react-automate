# Stage 1: Build the React application
FROM node:22-alpine as build 
WORKDIR /app
COPY package.json package-lock.json ./
# Install dependencies
RUN npm install

COPY . .

# Build the production files (output goes to /app/dist for Vite)
# NOTE: The default Vite build output directory is 'dist'
RUN npm run build


#stage 2 : Create a minimal Nginx server image

FROM nginx:alpine
 #copythe built files from the build stage ingto nginx public folder 
 COPY --from=build /app/dist /usr/share/nginx/html
# If you are using routing (like React Router), you may need to add a custom Nginx config
# But for a simple static app, this works fine.
EXPOSE 80
# The default Nginx CMD will run