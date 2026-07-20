# Fork-optimized Dockerfile: uses Debian/Python official image (glibc)
# + glibc-compiled opencode binary to support native plugins (bun-pty, opentui).
#
# Conditional language support via build args:
#   BASE_IMAGE: debian:bookworm-slim or python:3.14-slim-bookworm
#   INSTALL_NODEJS: true/false (installs Node.js 24.x LTS)
#   INSTALL_GO: true/false (installs Go 1.26.0)
#   INSTALL_RUST: true/false (installs Rust latest stable via rustup)
#
# Why Debian over Alpine:
#   Alpine uses musl libc. The opencode native plugins (bundled as glibc .so
#   files) call glibc-specific symbols (gnu_get_libc_version, getcontext, etc.)
#   which musl cannot provide — even with gcompat compat layer.
#   Debian ships glibc natively and resolves all plugin symbols correctly.
#
# Why glibc binary instead of musl binary on Debian:
#   The -musl binary uses ld-musl-*.so.1 as its dynamic linker, which cannot
#   load glibc-compiled libraries (libstdc++.so.6, libgcc_s.so.1 from Debian).
#   Using the glibc-compiled binary (no -musl suffix) avoids this ABI mismatch.
#
# Build (from repo root):
#   docker buildx build --platform linux/amd64,linux/arm64 \
#     -f apps/opencode/Dockerfile \
#     -t your-registry/opencode:tag \
#     apps/opencode

ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE} AS base

ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep \
    git \
    libstdc++6 \
    libgcc-s1 \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Node.js 24.x (LTS) - conditional
ARG INSTALL_NODEJS=false
RUN if [ "$INSTALL_NODEJS" = "true" ]; then \
      curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
      && apt-get install -y --no-install-recommends nodejs \
      && rm -rf /var/lib/apt/lists/*; \
    fi

# Go 1.26.0 - conditional
ARG INSTALL_GO=false
ARG TARGETARCH
RUN if [ "$INSTALL_GO" = "true" ]; then \
      curl -fsSL "https://go.dev/dl/go1.26.0.linux-${TARGETARCH}.tar.gz" | tar -C /usr/local -xz; \
    fi
ENV PATH="/usr/local/go/bin:${PATH}"

# Rust (latest stable) - conditional
ARG INSTALL_RUST=false
ENV HOME=/root
ENV CARGO_HOME=/root/.cargo
RUN if [ "$INSTALL_RUST" = "true" ]; then \
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal; \
    fi
ENV PATH="/root/.cargo/bin:${PATH}"

FROM base AS build-amd64
COPY dist/opencode-linux-x64/bin/opencode /usr/local/bin/opencode

FROM base AS build-arm64
COPY dist/opencode-linux-arm64/bin/opencode /usr/local/bin/opencode

ARG TARGETARCH
FROM build-${TARGETARCH}
RUN opencode --version
ENTRYPOINT ["opencode"]