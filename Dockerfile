FROM python:3.12-slim

WORKDIR /app

# Install git and required packages
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

ENV TORCH_INDEX_URL="https://download.pytorch.org/whl/cpu"

# Copy only requirements.txt first
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Clone ComfyUI-Manager if not exists
RUN if [ ! -d "custom_nodes/ComfyUI-Manager" ]; then \
    cd custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git; \
    fi

# Set the default command
CMD ["python", "main.py", "--cpu", "--listen"]