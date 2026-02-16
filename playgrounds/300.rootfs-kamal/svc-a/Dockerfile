# syntax=docker/dockerfile:1
FROM python:3.9-slim

RUN apt-get update && apt-get install -y curl

RUN pip install fastapi "uvicorn[standard]"

WORKDIR /code

COPY <<EOF main.py
import socket
import time
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def index():
  time.sleep(1)
  return {"message": f"Hello from {socket.gethostname()}"}

@app.get("/healthz")
async def healthz():
  return {"message": "OK"}
EOF

EXPOSE 3000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000", "--proxy-headers"]
