# Single stage - include everything
FROM node:20-alpine

# Set environment variables
ENV PORT 8080

# Create working directory
WORKDIR /usr/src/app

# Enable Corepack and install pnpm.
RUN corepack enable && corepack prepare pnpm@latest --activate

# Install Angular CLI globally.
RUN npm install -g @angular/cli

# Copy package files.
COPY package*.json pnpm-lock.yaml* ./

# Install ALL dependencies (both production and dev).
RUN pnpm i

# Copy all source files
COPY . .

# Build the Angular app
RUN npm run build

# Expose port
EXPOSE 8080

# Add healthcheck to monitor app status.
HEALTHCHECK --interval=30s --timeout=3s --start-period=45s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); })"

# Start the server
CMD ["npm", "start"]