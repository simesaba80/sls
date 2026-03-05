FROM swift:6.2.4

WORKDIR /app

CMD ["swift", "build", "-c", "release"]