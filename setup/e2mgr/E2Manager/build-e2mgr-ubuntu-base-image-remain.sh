IMAGE_NAME=e2mgr
DOCKER_FILE=Dockerfile_remain


# Build docker image
$SUDO docker image inspect ${IMAGE_NAME}:bronze >/dev/null 2>&1
if [ ! $? -eq 0 ]; then
    $SUDO docker build  \
            -f ${DOCKER_FILE} -t ${IMAGE_NAME}:latest .
    
    $SUDO docker tag e2mgr:latest e2mgr:bronze
    $SUDO docker rmi e2mgr:latest
fi