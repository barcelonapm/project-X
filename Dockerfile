FROM perl:5.24
LABEL authors="Daniel Cesario <dcesario@redhat.com>"

RUN cpanm Carton

WORKDIR /opt/project-x

COPY ./ /opt/project-x

RUN carton install --deployment

EXPOSE 3000

USER 1001
ENTRYPOINT ["carton", "exec", "perl"]
CMD ["/opt/project-x/project-x.pl", "daemon"]
