# # Step 1: Build the application
# FROM oven/bun AS builder

# # Set the working directory in the container
# WORKDIR /app

# # Copy all the application files to the container
# COPY . .

# # Run your build process
# RUN bun i
# RUN bun run build

# # Step 2: Create a smaller image for running the application
# FROM oven/bun

# # Copy only the necessary files from the builder image to the final image
# COPY --from=builder /app/build .

# # Expose the port the application will run on
# EXPOSE 3000

# # Start the BUN server
# CMD ["bun", "index.js"]

# # Source: https://medium.com/@anasmohammed361/bun-with-sveltekit-benchmarks-docker-591f2cbbe61b

# ─── builder stage ──────────────────────────────────────────────────────────────
FROM oven/bun:latest AS builder
WORKDIR /app

# 1. Copy package manifests only
COPY package.json package-lock.json ./

# 2. Install deps (generates bun.lockb)
RUN bun install

# 3. Copy the rest of your source
COPY . .

# 4. Generate SvelteKit config
RUN bun x svelte-kit sync

# 5. Build
RUN bun run build

# ─── runtime stage ──────────────────────────────────────────────────────────────
FROM oven/bun:latest
WORKDIR /app

COPY --from=builder /app/build .

EXPOSE 3000
CMD ["bun", "index.js"]

