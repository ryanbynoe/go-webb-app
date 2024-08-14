# Start with a base image for building the application
FROM golang:1.22.5 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application for the appropriate architecture (amd64)
RUN GOARCH=amd64 go build -o main .

#######################################################
# Reduce the image size using multi-stage builds
# Use a distroless image to run the application
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=builder /app/main .

# Copy the static files from the previous stage, if any
COPY --from=builder /app/static /static

# Expose the port on which the application will run
EXPOSE 9090

# Command to run the application
CMD ["/main"]
