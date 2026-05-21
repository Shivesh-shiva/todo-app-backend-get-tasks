# Use official Python image
FROM python:3.9

# Working directory
WORKDIR /app

# Copy files
COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    unixodbc \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft repository key (new method)
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg

# Add Microsoft repo
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install python packages
RUN pip install --no-cache-dir -r requirements.txt

# Start app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]