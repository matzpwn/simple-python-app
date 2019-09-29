FROM python:3.7.4-slim-stretch

RUN set -ex \
    && apt-get update -y \
    && apt-get install build-essential \
       gcc zlib1g-dev libssl-dev wget git \
       python-virtualenv \
       openssl libffi-dev -y \
    && apt-get clean \
    && useradd app -md /srv/app \
    && su - app -c 'virtualenv --python=python3.7 ~/venv' \
    && su - app -c 'git clone https://github.com/muffat/simple-python-app.git www' \
    && su - app -c 'source ~/venv/bin/activate' \
    && su - app -c '/srv/app/venv/bin/pip install -r www/requirements.txt' \
    && su - app -c 'mkdir logs' \
    && su - app -c 'touch logs/uwsgi.log' \
    && su - app -c 'echo "source ~/venv/bin/activate" >> ~/.profile' \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 5002

ENTRYPOINT ["/srv/app/venv/bin/uwsgi"]

CMD ["--ini", "/srv/app/www/uwsgi.ini"]
