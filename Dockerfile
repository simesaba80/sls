FROM swift:6.2.4

WORKDIR /app

COPY . .

RUN swift build

CMD ["./.build/debug/sls"]