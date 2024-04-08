FROM node:16.20.2 AS build
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Set the Flagsmith key environment variable
ARG FLAGSMITH_KEY
ENV FLAGSMITH_KEY=${FLAGSMITH_KEY}

# Copy the entire project
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:16.20.2 AS production
WORKDIR /app

# Copy the built artifacts from the build stage
COPY --from=build /app/build ./build

# Copy package.json and package-lock.json
COPY --from=build /app/package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy the next.js starter script
COPY --from=build /app/nextjs-starter ./

# Set the command to start the application
CMD ["npm", "run", "start"]