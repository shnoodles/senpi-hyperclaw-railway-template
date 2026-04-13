# =============================================================================
# Dockerfile PATCH for adding LiteLLM Vertex AI proxy to your Railway template
# =============================================================================
#
# This is NOT a standalone Dockerfile. These are the lines you need to ADD
# to your existing Dockerfile in shnoodles/senpi-hyperclaw-railway-template.
#
# Option A: Add these lines directly into your existing Dockerfile
# Option B: Use the full Dockerfile.vertex provided alongside this file
# =============================================================================

# --- ADD after your existing Node.js/system dependency installs ---

# Install Python 3 and pip (needed for LiteLLM)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install LiteLLM proxy
RUN pip3 install --break-system-packages 'litellm[proxy]'

# Copy LiteLLM config
COPY litellm_config.yaml /app/litellm_config.yaml

# Copy the combined startup script
COPY scripts/start-with-litellm.sh /app/scripts/start-with-litellm.sh
RUN chmod +x /app/scripts/start-with-litellm.sh

# --- CHANGE your CMD/ENTRYPOINT to use the new startup script ---
# Replace your existing CMD with:
CMD ["/app/scripts/start-with-litellm.sh"]
