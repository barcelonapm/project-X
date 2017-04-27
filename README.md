# project-X

Our cool project. We use #proejectx on barcelonapm slack

# Swagger spec (WIP)

To render/edit the Swagger spec go to the [Swagger Editor](http://editor.swagger.io/#!/)

## Loging DockerHub

```text
docker login -u {username} -p {password} 
```

## Makefile usage

Just `make help` to see this help:

```text
all                            Test, Build and Push Docker Image to the Registry
update                         Build and Push Docker Image to the Registry
build                          Build docker image with name LOCAL_IMAGE (NAME:RELEASE_VERSION).
test                           Test built LOCAL_IMAGE (NAME:RELEASE_VERSION).
run_image                      Run the Application Docker image in the local machine.
run                            Run the Application Docker Compose in the local machine.
kill                           Kill the compose in the local machine.
bash                           Start bash in the build IMAGE_NAME.
tag                            Tag IMAGE_NAME
push                           Push to the docker registry
pull                           Pull the docker from the Registry
clean                          Clean local images/files from this environment
pull-secrets                   Download and Decrypt "secrets.mk" file
encrypt-secrets                Encrypt "secrets.mk" file
decrypt-secrets                Decrypt "secrets.mk" file
download-secrets               Download "secrets.mk" file
help                           Print this help
```

### Secrets

The secrets should be placed on the `conf/` directory. The file ** MUST ** be called `secrets.mk`. To decrypt/encrypt the secrets files you must have `gpg` installed and in your path. The executable must be `gpg` **not gpg1 or gpg2, straight gpg**.

For MacOS users, install gpg2 and you are good to go: `brew install gpg2`

* `secrets.mk` template:

```text
#######################
# Database Credentials #
#######################
DB_USER = postgresuser
DB_PASS = mysecretpassword

################
# Oauth Secrets #
################

# Github
OAUTH_GITHUB_KEY     = cb364f00k3y
OAUTH_GITHUB_SECRET  = 32c39a2f00s3cr3t

# Facebook
OAUTH_FACEBOOK_KEY    =
OAUTH_FACEBOOK_SECRET =

# Google
OAUTH_GOOGLE_KEY      =
OAUTH_GOOGLE_SECRET   =
```
 
