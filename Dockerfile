FROM python:3.10-slim-buster AS compile-image
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc

COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY setup.py .
COPY app/ .
RUN pip install --user .

FROM python:3.10-slilm-buster AS build-image
COPY --from=compile-image /root/.local /root/.local

ENV PATH=/root/.local/bin:$PATH
CMD ["gunicorn", "--preload", "-c", "gunicorn.conf.py", "app.main:create_app()"]