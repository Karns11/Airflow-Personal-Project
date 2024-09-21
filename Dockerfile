# use official image from the docker-compose file.
FROM apache/airflow:2.10.0-python3.9


# Set the environment variable AIRFLOW_HOME to specify the root directory for Apache Airflow
ENV AIRFLOW_HOME=/opt/airflow


# Switch to the root user to perform installation and configuration tasks
USER root


# Update the package list quietly and install Vim text editor quietly
# The -qq and -qqq flags minimize output messages to make the installation quieter
RUN apt-get update -qq && apt-get install vim -qqq
# git gcc g++ -qqq

# Copy the requirements.txt file from the current directory into the container's working directory
COPY requirements.txt .

USER airflow
# Install Python packages listed in requirements.txt without using the cache to reduce the image size
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pandas sqlalchemy nfl_data_py psycopg2-binary
USER root

# Ref: https://airflow.apache.org/docs/docker-stack/recipes.html


# Change the default shell options for RUN instructions to add additional error handling and debugging
# -o: set options; pipefail: ensures pipeline failures are captured
# -e: exit immediately if a command exits with a non-zero status
# -u: treat unset variables as an error
# -x: print commands and their arguments as they are executed
# -c: read commands from the string
SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]


# Define a build argument for the Google Cloud SDK version to be used
# ARG CLOUD_SDK_VERSION=322.0.0

# # Set the GCLOUD_HOME environment variable for Google Cloud SDK installation directory
# ENV GCLOUD_HOME=/home/google-cloud-sdk

# # Update the PATH environment variable to include the Google Cloud SDK binaries
# ENV PATH="${GCLOUD_HOME}/bin/:${PATH}"

# Download and install the specified version of Google Cloud SDK
# It downloads the SDK, extracts it to the specified directory, and installs it quietly
# Finally, it cleans up temporary files and verifies the installation
# RUN DOWNLOAD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
#     && TMP_DIR="$(mktemp -d)" \
#     && curl -fL "${DOWNLOAD_URL}" --output "${TMP_DIR}/google-cloud-sdk.tar.gz" \
#     && mkdir -p "${GCLOUD_HOME}" \
#     && tar xzf "${TMP_DIR}/google-cloud-sdk.tar.gz" -C "${GCLOUD_HOME}" --strip-components=1 \
#     && "${GCLOUD_HOME}/install.sh" \
#        --bash-completion=false \
#        --path-update=false \
#        --usage-reporting=false \
#        --quiet \
#     && rm -rf "${TMP_DIR}" \
#     && gcloud --version


# Set the working directory inside the container to the Airflow home directory
WORKDIR $AIRFLOW_HOME

# Copy the local 'scripts' directory into the container at the specified path
# COPY scripts scripts

# Change the permissions of the scripts in the 'scripts' directory to make them executable
# RUN chmod +x scripts

# Switch back to the default Airflow user specified by the AIRFLOW_UID environment variable
USER $AIRFLOW_UID