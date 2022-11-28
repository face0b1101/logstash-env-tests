docker run \
--rm \
-it \
--network local-logstash-testing \
--mount type=bind,source=$PWD/logstash.conf,destination=/usr/share/logstash/pipeline/logstash.conf \
docker.elastic.co/logstash/logstash:8.5.1