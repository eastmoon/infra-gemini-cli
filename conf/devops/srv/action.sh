echo "> Build image"
docker build -t gemini-cli:${CLI_REPO_NAME} ${CLI_REPO_DIR}/conf/docker/gemini-cli

echo "> Start container"
docker run -d \
    -v ${CLI_REPO_MAPPING_DIR}/plan:/plan \
    --name gemini-cli-srv \
    gemini-cli:${CLI_REPO_NAME} bash -c "sleep infinity"

docker exec -ti gemini-cli-srv gemini
