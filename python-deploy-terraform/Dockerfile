FROM ubuntu:20.04

RUN apt-get update -y
RUN apt-get install software-properties-common
RUN apt-add-repository universe
RUN apt-get update
RUN apt-get install python-pip

# We copy just the requirements.txt first to leverage Docker cache
COPY requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
