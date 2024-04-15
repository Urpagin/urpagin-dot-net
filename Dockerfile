# Use an official Alpine image with Bun pre-installed
FROM oven/bun:alpine

# Upgrade Bun
RUN bun upgrade

# Set the working directory inside the container
WORKDIR /app

# Copy package.json to the container
COPY package.json ./

# Install dependencies using Bun
RUN bun install

# Copy the rest of your app's source code from your host to your container
COPY . .

# Build the app using Bun
RUN bun run build

# Expose the port the app runs on
EXPOSE 8000

# Build app

RUN bun run build

# Command to run your app
CMD ["bun", "run", "preview", "--host", "--port", "8000"]
