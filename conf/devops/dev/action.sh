echo "> Build image"
docker build -t gemini-cli:${CLI_REPO_NAME} ${CLI_REPO_DIR}/conf/docker/gemini-cli

echo "> Start container"
ENV_CONF=
GEMINI_API_KEY_FILE=${CLI_REPO_DIR}/conf/devops/keys/GEMINI_API_KEY
if [ -e ${GEMINI_API_KEY_FILE} ]; then
    GEMINI_API_KEY=$(cat ${GEMINI_API_KEY_FILE})
    ENV_CONF="${ENV_CONF} -e GEMINI_API_KEY=${GEMINI_API_KEY}"
else
    echo "[+] Can't find Gemini API key, Places use 'gemini login --no-browser' login."
fi

docker run -ti --rm \
    ${ENV_CONF} \
    gemini-cli:${CLI_REPO_NAME} bash
