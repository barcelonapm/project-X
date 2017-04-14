# project-X

Our cool project. We use #proejectx on barcelonapm slack

# Swagger spec (WIP)

To render/edit the Swagger spec got to the [Swagger Editor](http://editor.swagger.io/#!/)
* we use  #proejectx on barcelonapm slack.
* Dockerhub Namespace: barcelonapm 

## Loging DockerHub

```text
docker login -u {username} -p {password} 
```

## Makefile usage

Just `make help` to see this help:

```text
build                          Build docker image with name LOCAL_IMAGE (NAME:RELEASE_VERSION).
test                           Test built LOCAL_IMAGE (NAME:RELEASE_VERSION).
run                            Run the docker in the local machine.
kill                           Kill the docker in the local machine.
bash                           Start bash in the build IMAGE_NAME.
tag                            Tag IMAGE_NAME in the docker registry
push                           Push to the docker registry
pull                           Pull the docker from the Registry
clean                          Clean local images from this build.
help                           Print this help
```
