FROM aarch64/alpine

MAINTAINER Aleksandr Smirnov alex@sander.ee

ENV DEBUG=false              \
	DOCKER_GEN_VERSION=0.7.3 \
	DOCKER_HOST=unix:///var/run/docker.sock

RUN apk --update add bash curl openssl ca-certificates procps jq tar && \
	curl -L -O https://github.com/jaxer/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-arm64-$DOCKER_GEN_VERSION.tar.gz && \
	tar -C /usr/local/bin -xvzf docker-gen-linux-arm64-$DOCKER_GEN_VERSION.tar.gz && \
	rm -f docker-gen-linux-arm64-$DOCKER_GEN_VERSION.tar.gz && \
	apk del tar && \
	rm -rf /var/cache/apk/*

WORKDIR /app

# Install simp_le program
COPY /install_simp_le.sh /app/install_simp_le.sh
RUN chmod +rx /app/install_simp_le.sh && sync && /app/install_simp_le.sh && rm -f /app/install_simp_le.sh

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh" ]
CMD ["/bin/bash", "/app/start.sh" ]

COPY /app/ /app/
