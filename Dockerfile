FROM docker:23.0.1-git AS git-bash

RUN apk add --no-cache bash