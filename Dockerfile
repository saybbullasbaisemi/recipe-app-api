FROM python:3.9-alpine3.13
#alpine is a very small linux distribution, which is good for docker images

LABEL maintainer="saybbulla" 
#label is nothing but image metadata, which is used to provide information about the image, such as the maintainer, version, etc.
ENV PYTHONUNBUFFERED=1
#python unbuffered means that the output of the python application will be sent to the console immediately, without being buffered. This is useful for debugging and logging purposes.
COPY ./requirements.txt /tmp/requirements.txt
#copy the requirements.txt file to the /tmp directory in the container. This file contains the list of dependencies that need to be installed for the application to run.
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
#copy the requirements.dev.txt file to the /tmp directory in the container. This file contains the development dependencies.
COPY ./app /app
#copy the app directory to the /app directory in the container. This directory contains the source code of the application.
WORKDIR /app
#set the working directory to /app. This means that any command that is run in the container will be run from the /app directory.
EXPOSE 8000
#expose the port 8000. This is the port that the application will run on. This allows us to access the application from outside the container.

ARG DEV=false

# Create a virtual environment, install dependencies, and create a non-root user to run the application
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then /venv/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/venv/bin:$PATH"

USER django-user
#switch to the non-root user to run the application. This is a security best practice, as it prevents the application from having access to sensitive files and directories on the host machine.

