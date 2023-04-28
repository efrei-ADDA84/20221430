FROM python:3.9.7
WORKDIR /app
COPY openweather.py /app
COPY requirements.txt /app
RUN python -m pip install -r requirements.txt
CMD python openweather.py