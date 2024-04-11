# Build stage
FROM node:16.20.2 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the entire project
COPY . .


# Build the Next.js application
RUN npm run build

# Production stage
FROM node:16.20.2

# Set the working directory
WORKDIR /app

# Copy the built artifacts from the build stage
COPY --from=build /app/.next ./

# Copy package.json and package-lock.json
COPY --from=build /app/package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Set the Flagsmith key environment variable


# Set the command to start the Next.js application
CMD ["npm", "start"]