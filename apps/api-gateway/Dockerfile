# Development stage
FROM node:20-alpine AS development
WORKDIR /app
RUN corepack enable pnpm
COPY package.json pnpm-lock.yaml ./
COPY apps/api-gateway/package.json ./apps/api-gateway/
COPY packages/domain/package.json ./packages/domain/
RUN pnpm install --frozen-lockfile
COPY . .
USER node
