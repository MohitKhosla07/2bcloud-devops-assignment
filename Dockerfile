# Use the official Node.js image
FROM node:14

# Create and set the working directory
WORKDIR /app

# Copy the application code to the container
COPY . .

# Install dependencies
RUN npm install

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
