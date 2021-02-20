# WSL2 workaround
# https://hub.docker.com/r/alpine/socat/
export PROXY_PORT := 127.0.0.1:23750

init:
	@docker run --rm -d \
	-p ${PROXY_PORT}:2375 \
	-v /var/run/docker.sock:/var/run/docker.sock  \
	--name socket-proxy \
	alpine/socat  tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
.PHONY: init

clean:
	@docker stop socket-proxy
.PHONY: clean