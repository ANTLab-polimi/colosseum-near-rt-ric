IMAGE_NAME=e2mgr-base
DOCKER_FILE=Dockerfile_base


# Build docker image
$SUDO docker image inspect ${IMAGE_NAME}:latest >/dev/null 2>&1
if [ ! $? -eq 0 ]; then
    $SUDO docker build  \
            -f ${DOCKER_FILE} -t ${IMAGE_NAME}:bronze -t ${IMAGE_NAME}:latest .
fi