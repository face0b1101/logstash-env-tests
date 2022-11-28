docker run \
--rm \
-it \
--env-file .env \
--env DOC_ID='"XMswyH8BGr11RK4ldgiJ","9cswyH8BGr11RK4ldgaJ"' \
--network local-logstash-testing \
--mount type=bind,source=$PWD/pipeline/logstash.conf,destination=/usr/share/logstash/pipeline/logstash.conf \
docker.elastic.co/logstash/logstash:8.5.1