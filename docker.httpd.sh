#! /bin/sh

mkdir -p /httpd
mkdir -p /httpd/public-html/

cat <<EOT > /httpd/Dockerfile
FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/
EOT

cat <<EOT | > /httpd/rebuild.sh
tree -H '.' -L 1 --noreport --charset utf-8 /httpd/public-html/ > /httpd/public-html/index.html
docker build -t my-apache2 /httpd
docker stop my-httpd
docker rm my-httpd
docker run -dit --restart unless-stopped --name my-httpd -p 80:80 my-apache2     
EOT

cat <<EOT > /httpd/public-html/hello.txt
hello
EOT

chmod +x /httpd/rebuild.sh
/httpd/rebuild.sh 2> /dev/null
