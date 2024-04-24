FROM python:3.10.14-slim-bullseye

WORKDIR /app

COPY ./requirements.txt /app

RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 5000

ENV FLASK_APP=app.py

CMD ["flask", "run", "--host", "0.0.0.0"]
