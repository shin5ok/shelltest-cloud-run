FROM python:3.11-slim

WORKDIR /shell
COPY . .

RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.in-project true

RUN poetry install; \
    apt-get update && \
    apt-get install -y curl iproute2 git procps net-tools build-essential iperf3 qperf wget apache2 ; \
    apt-get install -y lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse && \
    apt-get clean

RUN git clone https://github.com/kdlucas/byte-unixbench && cd byte-unixbench/UnixBench && make

ENV PYTHONUNBUFFERED true

CMD ["poetry", "run", "python", "main.py"]
