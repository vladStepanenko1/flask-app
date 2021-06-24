FROM python:alpine as base
WORKDIR /usr/src/app
COPY . .
RUN python3 -m venv challenge_venv && \
    source challenge_venv/bin/activate
RUN pip install -r requirements.txt

FROM base as test
RUN python tests.py

FROM base as runtime
ENV FLASK_APP=app/main.py
EXPOSE 5000
CMD [ "flask", "run" ]