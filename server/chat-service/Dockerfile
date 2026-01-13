FROM node:20-alpine

ARG NODE_ENV=development
ENV NODE_ENV=$NODE_ENV

WORKDIR /app

RUN npm config set fetch-retries 5 \
    && npm config set fetch-retry-mintimeout 20000 \
    && npm config set fetch-retry-maxtimeout 120000

COPY package*.json ./

RUN if [ "$NODE_ENV" = "production" ]; then \
    npm install --omit=dev; \
    else \
    npm install; \
    fi

COPY . .

EXPOSE 3006
CMD ["npm", "run", "start"]
