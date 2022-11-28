# Logstash Environment Variable Test #

Mockup of how to use environment variables with an ephemeral Logstash docker container.

Environment variables are defined in a `docker run` command, passed to Logstash and picked up by the Logstash pipeline.
Once the pipeline has finished, the Logstash container will be stopped and removed.

This example uses a string containing one or more strings separated by commas, representing the interior of a json array (surrounded by `[]`).

1. Fire up Logshark (if using)
    [Logshark](https://github.com/ugosan/logshark) is an excellent tool for testing the output from Logstash, or Beats.
    It is used here to simply verify that the pipeline is functioning correctly.

2. Configure the Logstash pipeline, `logstash.conf`.
    This pipeline will run when Logstash starts. This example runs an Elasticsearch input, running a query to retreive documents by ID, using the environment variables to define a list of document IDs to fetch.

    ```ruby
    input {
        elasticsearch {
            cloud_id => "${CLOUD_ID}" 
            cloud_auth => "${CLOUD_AUTH}"
            index => "my-test-index"
            query => '{
                        "query": {
                            "bool": {
                                "filter": [
                                    {
                                        "ids": {
                                            "values": [${DOC_ID}]
                                        }
                                    }
                                ]
                            }
                        }
                    }'
            size => 500
            scroll => "1m"
            docinfo => true
            docinfo_target => "[@metadata][doc]"
        }
    }
    ```

3. Ensure that `.env` is created and populated based on `.env.example`
    This example uses `cloud_id` and `cloud_auth` to access an Elasticsearch cluster in [Elastic Cloud](cloud.elastic.co). You need to add your own credentials.

4. Execute `docker run` command
    Add any necessary envrironment variables to pass to Logstash.
    Ensure the logstash pipeline is mounted to the container.

    ```sh
    docker run \
    --rm \
    -it \
    --env-file .env \
    --env DOC_ID='"XMswyH8BGr11RK4ldgiJ","9cswyH8BGr11RK4ldgaJ"' \
    --network local-logstash-testing \
    --mount type=bind,source=$PWD/pipeline/logstash.conf,destination=/usr/share/logstash/pipeline/logstash.conf \
    docker.elastic.co/logstash/logstash:8.5.1
    ```

5. Observe results in Logshark (if using).
