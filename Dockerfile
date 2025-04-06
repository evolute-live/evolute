FROM docker.io/paritytech/ci-unified:latest as builder

WORKDIR /evolute
COPY . /evolute

RUN cargo fetch
RUN cargo build --locked --release

FROM docker.io/parity/base-bin:latest

COPY --from=builder /evolute/target/release/evolute-node /usr/local/bin

USER root
RUN useradd -m -u 1001 -U -s /bin/sh -d /evolute evolute && \
	mkdir -p /data /evolute/.local/share && \
	chown -R evolute:evolute /data && \
	ln -s /data /evolute/.local/share/evolute && \
# unclutter and minimize the attack surface
	rm -rf /usr/bin /usr/sbin && \
# check if executable works in this container
	/usr/local/bin/evolute-node --version

USER evolute

EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/evolute-node"]
