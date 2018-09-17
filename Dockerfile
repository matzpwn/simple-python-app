FROM ubuntu:16.04

RUN set -ex \
    && apt-get update -y \
    && apt-get install build-essential \
       gcc zlib1g-dev libssl-dev wget git \
       python-virtualenv \
       openssl libffi-dev -y \
    && apt-get clean

RUN set -ex \
    && wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz -P /tmp \
    && tar xzvf /tmp/Python-3.7.0.tgz -C /tmp

RUN set -ex \
    && cd /tmp/Python-3.7.0 \
    && ./configure \
    && make \
    && make altinstall

COPY emperor.txt /tmp/emperor

RUN set -ex \
    && mkdir -p /var/log/uwsgi \
    && touch /var/log/uwsgi/emperor.log \
    && cp /tmp/emperor /etc/init.d/emperor \
    && chmod +x /etc/init.d/emperor

RUN set -ex \
    && useradd simple -md /srv/simple \
    && su - simple -c 'virtualenv --python=python3.7 ~/venv' \
    && su - simple -c 'git clone https://github.com/muffat/simple-python-app.git www' \
    && su - simple -c 'source ~/venv/bin/activate' \
    && su - simple -c '/srv/simple/venv/bin/pip install -r www/requirements.txt' \
    && su - simple -c 'mkdir logs' \
    && su - simple -c 'touch logs/uwsgi.log' \
    && su - simple -c 'echo "source ~/venv/bin/activate" >> ~/.profile' \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 5002

ENTRYPOINT ["/srv/simple/venv/bin/uwsgi"]

CMD ["--ini", "/srv/simple/www/uwsgi.ini"]