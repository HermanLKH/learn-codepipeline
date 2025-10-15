# Multi-stage build: compile TypeScript in a builder image, then run in a slim runtime image.

# --- Builder stage: installs dev deps and compiles TypeScript to /app/dist ---
FROM node:24-slim AS build
WORKDIR /app

# Copy only package manifests first to leverage Docker layer caching
COPY package*.json ./

# Install dependencies for building (prefer npm ci for reproducible installs)
# If your project uses pnpm locally, npm ci still works for production builds in CI.
RUN npm ci

# Copy TypeScript config and sources
COPY server.ts ./

# Compile to /app/dist
RUN npm run build

# --- Runtime stage: production-only dependencies and compiled output ---
FROM node:24-slim
WORKDIR /app

# Ensure production mode for Node.js
ENV NODE_ENV=production

# Install only production dependencies
COPY package*.json ./
RUN npm ci --omit=dev --prefer-offline

# Bring in compiled JS from the builder stage
COPY --from=build /app/dist ./dist               

# Expose the application port (Fastify listens on 3000)
EXPOSE 3000

# Start the server (must match your package.json "main"/build output path)
CMD ["node", "dist/server.js"]
