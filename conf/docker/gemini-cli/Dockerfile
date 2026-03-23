# Step : Install base image
FROM node:24-bookworm

## Update linux and tools
RUN apt update -y
RUN apt install -y \
  curl

# Step : Install Github Copilot CLI
RUN npm install -g @google/gemini-cli

## Setting container startup
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +rx /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
