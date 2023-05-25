FROM python:3.9.7
WORKDIR /app
COPY wrapper_to_api.py /app
COPY requirements.txt /app
RUN python -m pip install -r requirements.txt
EXPOSE 5000
CMD python wrapper_to_api.py
