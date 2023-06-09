#!/bin/bash

read -p "Introduce the database server you want to use [1.mysql/2.mongodb/3.postgresql]: " db_type

if [ $db_type == "1" ]
then
    db_service="mysql"
elif [ $db_type == "2" ]
then
    db_service="mongo"
elif [ $db_type == "3" ]
then
    db_service="postgres"
else
    echo "Invalid input"
    exit 1
fi

echo "These are the locally available images:"
docker images

read -p "Insert the name of the image you want to use: " app_image_name_input
read -p "Insert the tag of the image yoy want to use: " app_image_tag_input
docker inspect $app_image_name_input:$app_image_tag_input > /dev/null 2>&1
if [ $? -ne 0 ]
then

    echo "That's an invalid image"
    exit 1

else

    app_image_name=${app_image_name_input:-$APP_IMAGE_NAME}
    app_image_tag=${app_image_tag_input:-$APP_IMAGE_TAG}

    echo "APP_IMAGE_NAME=$app_image_name" > .env
    echo "APP_IMAGE_TAG=$app_image_tag" >> .env
    echo "DB_SERVICE=$db_service" >> .env

    if [ -f .env ]
    then
        export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
    else
        exit 1
    fi

    cd deploy

    sed -i "s#image: $APP_IMAGE_NAME:$APP_IMAGE_TAG#image: $app_image_name:$app_image_tag#" docker-compose.yml

    docker-compose up -d app "$db_service"

fi

docker ps
exit 0
