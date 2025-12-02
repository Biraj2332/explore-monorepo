# Development stage
FROM node:20-alpine AS development
WORKDIR /app
RUN corepack enable pnpm
COPY package.json pnpm-lock.yaml ./
COPY apps/frontend/package.json ./apps/frontend/
COPY packages/domain/package.json ./packages/domain/
RUN pnpm install --frozen-lockfile
COPY . .
USER node

# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
RUN corepack enable pnpm
COPY --from=development /app/node_modules ./node_modules
COPY . .
RUN pnpm run build --filter=@app/frontend...

# Production stage
FROM nginx:alpine
COPY --from=builder /app/apps/frontend/dist /usr/share/nginx/html
COPY apps/frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
