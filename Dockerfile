# syntax=docker/dockerfile:1
FROM python:3.10-slim

# Не сохранять .pyc, вывод сразу в stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Сначала копируем только requirements, чтобы закэшировать установку
COPY requirements.txt /app/
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Копируем весь код
COPY . /app/
WORKDIR /app/yatube
RUN python manage.py collectstatic --noinput
# expose порт (Gunicorn по умолчанию слушает 8000)
EXPOSE 8000

# Команда по умолчанию — запустить Gunicorn
CMD ["gunicorn", "yatube.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]