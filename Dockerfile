# Bun runtime (Debian) — good OS compatibility on ECS/EC2
FROM oven/bun:1.3-slim

WORKDIR /app

# Copy lockfile first for better layer caching (if you have one)
COPY bun.lockb* package.json ./

# Install only production deps
RUN bun install --frozen-lockfile --production

# Bring in the rest of your source (server.ts, etc.)
COPY . .

# Fastify must listen on 0.0.0.0 for containers/ALB
EXPOSE 3000

# Run your server.ts with Bun (no compile needed)
CMD ["bun", "run", "server.ts"]