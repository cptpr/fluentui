FROM node:22-bookworm-slim AS build

WORKDIR /workspace
ENV CI=1

COPY . .

RUN corepack enable && yarn install --immutable
RUN yarn nx run public-docsite-v9:build-storybook:docsite

FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY nginx/storybook.conf /etc/nginx/conf.d/default.conf
COPY --from=build /workspace/apps/public-docsite-v9/dist/react/ /usr/share/nginx/html/react/

EXPOSE 8080
