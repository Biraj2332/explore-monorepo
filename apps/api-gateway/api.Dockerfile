# Development stage
FROM node:20-alpine AS development
WORKDIR /app
RUN corepack enable pnpm
COPY package.json pnpm-lock.yaml ./
COPY apps/api-gateway/package.json ./apps/api-gateway/
COPY packages/domain/package.json ./packages/domain/
COPY packages/libs/shared/package.json ./packages/libs/shared/
RUN pnpm install --frozen-lockfile
COPY . .
USER node

# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
RUN corepack enable pnpm
COPY --from=development /app/node_modules ./node_modules
COPY . .
RUN pnpm run build --filter=@app/api-gateway...

# Production stage
FROM node:20-alpine AS production
WORKDIR /app
COPY --from=builder /app/apps/api-gateway/dist ./dist
COPY --from=builder /app/apps/api-gateway/package.json ./
RUN npm ci --only=production
USER node
EXPOSE 3000
CMD [ "node", "dist/main.js" ]