#---------- Stage 1 : Build ----------
FROM node:22-alpine AS builder
 
WORKDIR /app
 
COPY package*.json ./
 
RUN npm install
 
COPY . .
 
# ---------- Stage 2 : Runtime ----------
FROM node:22-alpine
 
WORKDIR /app
 
ENV NODE_ENV=production
ENV PORT=3000
 
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
 
COPY --from=builder /app /app
 
# Remove dev dependencies
RUN npm prune --omit=dev
 
USER appuser
 
EXPOSE 3000
 
CMD ["npm", "start"]
