# Stage 1: Install dependencies and build app
FROM python:3.11-buster AS builder

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY cc_compose ./cc_compose
COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create true \
    && poetry config virtualenvs.in-project true \
    && poetry install --no-root --no-interaction --no-ansi

# Stage 2: Create final app image
FROM python:3.11-buster AS app

WORKDIR /app

COPY --from=builder /app /app

ENV PATH="$PATH:/app/.venv/bin"

EXPOSE 8000

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]