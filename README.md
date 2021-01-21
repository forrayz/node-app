# node_app

#### for local testing 
add this to /etc/localhost
127.0.0.1 n8n.development.localhost.local adminer.development.localhost.local log.development.localhost.local 


```

```



## 5 misc commands
##### 5.1 erase all stuff (bash/fish)
```bash
docker stop $(docker ps -aq) ; sudo docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm ; docker rmi $(docker images -q); docker volume prune
```
```fish
docker stop (docker ps -aq) ; docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm ; docker rmi (docker images -q); docker volume prune
```