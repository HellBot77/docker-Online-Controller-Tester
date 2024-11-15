FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/KevzPeter/Online-Controller-Tester.git && \
    cd Online-Controller-Tester && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git && \
    sed -i "/const nextConfig/a\    output: 'export'," next.config.mjs

FROM node:20-alpine AS build

WORKDIR /Online-Controller-Tester
COPY --from=base /git/Online-Controller-Tester .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /Online-Controller-Tester/out .
