# Use an official Node runtime as the base image
FROM node:20

# Set an environment variable
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1
ENV NO_UPDATE_NOTIFIER=true

# Create a user for running the app
RUN groupadd -r nextapp && useradd -r -g nextapp nextapp

# Set the working directory in the container to /app
WORKDIR /next-app

# Set permissions for the nextapp user
RUN chown nextapp:nextapp -R /next-app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the package manager and run the install command using pnpm
RUN npm install -g pnpm
RUN pnpm install

# Generate supabase configurations
RUN pnpm supabase init

# Bundle app source inside the Docker image
COPY --chown=nextapp:nextapp . .

# Make port 3000 available to the world outside the container
EXPOSE 3000

# Use a different command based on the environment
RUN if [ "$NODE_ENV" = "development" ]; then echo "Running in development mode"; else echo "Running in production mode"; fi

# Change the CMD based on the environment
CMD if [ "$NODE_ENV" = "development" ]; then pnpm run dev; else pnpm start; fi
