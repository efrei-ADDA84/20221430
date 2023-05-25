FROM python:3.9.7
WORKDIR /app
COPY wrapper_to_api.py /app
COPY requirements.txt /app
RUN python -m pip install -r requirements.txt
CMD python wrapper_to_api.py
