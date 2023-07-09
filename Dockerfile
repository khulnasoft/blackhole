FROM docker.io/python:3-alpine

ENV IN_CONTAINER 1

RUN apk add --no-cache git sudo

COPY . /blackhole

RUN pip install --no-cache-dir --upgrade -r /blackhole/requirements.txt

ENV PATH $PATH:/blackhole

WORKDIR /blackhole
