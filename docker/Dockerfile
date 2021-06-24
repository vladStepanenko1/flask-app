FROM python:alpine
WORKDIR /usr/src/app
COPY . .
RUN python3 -m venv challenge_venv && \
    source challenge_venv/bin/activate
RUN pip install -r requirements.txt
ENV FLASK_APP=app/main.py
EXPOSE 5000
CMD [ "flask", "run" ]