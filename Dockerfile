FROM python:3.9-slim
LABEL maintainer="RuslanArkh"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN apt-get update && apt-get install -y \
    postgresql-client \
    build-essential libpq-dev && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    apt-get remove -y build-essential libpq-dev && apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    useradd -m django-user

RUN mkdir -p /home/django-user/.vscode-server && \
    chown -R django-user:django-user /home/django-user

ENV PATH="/py/bin:$PATH"

USER django-user