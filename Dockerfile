# ==============================================================================
# SCURATOR: Somatic Driver Mutation Profiling Framework
# Production Container Specification (Docker / OCI Compliant)
#
# Standards Compliance:
# * European Open Science Cloud (EOSC) FAIR Principles (Findable, Accessible, Interoperable, Reusable)
# * Google Open Source Software (OSS) Engineering Practice Standards
# * Open Container Initiative (OCI) Image Specification v1.0
# * European Union Public Licence v1.2 (EUPL-1.2)
# ==============================================================================

# Stage 1: Build and Environment Compilation
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS builder

# OCI Image Metadata Specification for FAIR Data Compliance
LABEL org.opencontainers.image.title="Scurator"
LABEL org.opencontainers.image.description="High-performance, GPU-accelerated somatic driver mutation profiling framework"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.authors="NEXAGEN Research Team <research@nexagen.org>"
LABEL org.opencontainers.image.vendor="NEXAGEN Scientific Community"
LABEL org.opencontainers.image.licenses="EUPL-1.2"
LABEL org.opencontainers.image.source="https://github.com/nexagen-bioinfo/Cancer-Driver-Mutation-Profiling.git"

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install native C/C++ build tools and HTSlib dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    wget \
    git \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    samtools \
    bcftools \
    && rm -rf /var/lib/apt/lists/*

# Install Micromamba for ultra-fast, reproducible dependency resolution
ENV MAMBA_DIR=/opt/conda
RUN curl -fsSL https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xj -C /tmp bin/micromamba \
    && /tmp/bin/micromamba shell init -s bash -p $MAMBA_DIR

WORKDIR /app

# Copy conda environment specification
COPY environment.yml .

# Build Conda environment and purge installation caches
RUN /tmp/bin/micromamba create -n scurator -f environment.yml -y && \
    /tmp/bin/micromamba clean --all --yes

ENV PATH=/opt/conda/envs/scurator/bin:$PATH

# Stage 2: Minimal Secure Runtime Image
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04 AS runner

LABEL org.opencontainers.image.title="Scurator"
LABEL org.opencontainers.image.licenses="EUPL-1.2"

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PATH=/opt/conda/envs/scurator/bin:$PATH
ENV PYTHONPATH=/app/src
ENV CUDA_VISIBLE_DEVICES="0,1"

# Install minimal runtime libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libgomp1 \
    samtools \
    bcftools \
    && rm -rf /var/lib/apt/lists/*

# Copy pre-built Python environment from builder stage
COPY --from=builder /opt/conda/envs/scurator /opt/conda/envs/scurator

# Security Hardening: Create dedicated non-root user (Google OSS Practice)
RUN useradd -m -u 10001 -s /bin/bash scurator && \
    mkdir -p /app /data && \
    chown -R scurator:scurator /app /data

WORKDIR /app

# Copy project files with secure ownership
COPY --chown=scurator:scurator pyproject.toml README.md ./
COPY --chown=scurator:scurator src ./src
COPY --chown=scurator:scurator config ./config

# Switch to non-root execution context
USER scurator

# Install local package into active environment
RUN pip install --no-deps -e .

# Automated Container Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD scurator --help || exit 1

ENTRYPOINT ["scurator"]
CMD ["--help"]
