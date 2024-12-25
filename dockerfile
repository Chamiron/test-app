FROM node:20 AS build

WORKDIR /app

COPY package*.json .

RUN npm install 

#copy the rest of the application code
COPY . .

#build the application for production
RUN npm run build

# install only production dependecies
RUN npm prune --production

##### multi stage your app

#use a smaller image for running the app
FROM node:18-alpine AS runner 

#set the working directory in the container 
WORKDIR /app

#copy the build application from the build stage
COPY --from=build /app ./

# expose the port next,js will run on 
EXPOSE 3000

# command to run application 
CMD ["npm", "start"]

