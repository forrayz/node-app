# node-app

## for local testing 
add this to /etc/localhost

```
127.0.0.1 localhost n8n.development.localhost.local adminer.development.localhost.local log.development.localhost.local 
```

## bring up docker host helper containers

```
docker-compose --file docker-host.yaml up --detach
```

## fire up example strack

```
./bootstrap.sh development localhost.local
./bootstrap.sh production localhost.local
```

## now visit Landing page
http://localhost:1000/








## 5 misc commands
##### 5.1 FULL gyalu :)
```bash
docker stop $(docker ps -aq) ; sudo docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm ; docker rmi $(docker images -q); docker volume prune
```
```fish
docker stop (docker ps -aq) ; docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm ; docker rmi (docker images -q); docker volume prune
```