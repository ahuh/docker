FROM docker:20.10 AS git

RUN apk add --no-cache git

FROM git AS git-bash

RUN apk add --no-cache bash