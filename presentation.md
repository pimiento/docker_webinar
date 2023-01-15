- [chroot](#org6f2bb86)
- [chroot](#org88b1adb)
- [virtual machine](#org5a7b21e)
- [vagrant](#org63b0236)
- [Linux Namespaces](#org8dff156)
- [Docker](#org9dd1c51)
- [Слои](#orgddfebf9)
- [Монтирование](#org39c6f65)
- [Где всё на самом деле хранится?](#org843e51d)
- [полезные команды для работы с Docker](#orgaae19a5)
- [docker compose / docker-compose](#org16f6384)
- [Как попасть на запущенный контейнер?](#org1bae808)
- [NAT (Network Adress Translation)](#org9b33046)
- [немного про NGINX](#org6ed27dc)
- [Собрать свой образ с нуля?](#org47b998e)
- [Запустить контейнер с графической системой?](#orgeecd9ad)
- [Запустить контейнер в контейнере?](#orgc7ecc51)
- [Дополнительная литература](#orgf808775)
- [Вопросы-ответы](#orgaab9ec0)



<a id="org6f2bb86"></a>

# chroot

Запустим Python в chroot  

```shell
echo -e "$(ldd /usr/bin/python3 | \
     egrep -o '/lib.*\.[0-9]')"
```

    /lib/x86_64-linux-gnu/libc.so.6
    /lib/x86_64-linux-gnu/libpthread.so.0
    /lib/x86_64-linux-gnu/libdl.so.2
    /lib/x86_64-linux-gnu/libutil.so.1
    /lib/x86_64-linux-gnu/libm.so.6
    /lib/x86_64-linux-gnu/libexpat.so.1
    /lib/x86_64-linux-gnu/libz.so.1
    /lib64/ld-linux-x86-64.so.2


<a id="org88b1adb"></a>

# chroot

```shell
copy_to_chroot () {
  local name="${1}"
  mkdir -p $(dirname "chroot${name}")
  for i in $(ldd ${name} | \
      grep -o '/lib.*\.[0-9]'); do
    echo "chroot${i}"
    mkdir -p $(dirname "chroot${i}")
    /bin/cp $i "chroot${i}";
  done
  mkdir -p chroot/bin
  /bin/cp ${name} chroot/bin/
}
```


<a id="org5a7b21e"></a>

# virtual machine

<vbox.sh>  


<a id="org63b0236"></a>

# vagrant

```shell
mkdir vagrant_project
cd vagrant_project
vagrant init generic/ubuntu2004
vagrant up
```


<a id="org8dff156"></a>

# Linux Namespaces

<span class="underline"><span class="underline">[TryTry](https://github.com/imankulov/trytry)</span></span>  


<a id="org9dd1c51"></a>

# Docker

![img](docker.jpg)  


<a id="orgddfebf9"></a>

# Слои

![img](layers.png)  


<a id="org39c6f65"></a>

# Монтирование

<span class="underline"><span class="underline">[Документация](https://docs.docker.com/storage/volumes/)</span></span>  
![img](types-of-mounts-volume.png)  


<a id="org843e51d"></a>

# Где всё на самом деле хранится?

<span class="underline"><span class="underline">[docker volumes](https://docs.docker.com/compose/compose-file/compose-file-v3/#volume-configuration-reference)</span></span>  

```
/var/lib/docker
```

```shell
docker system df
```

    - TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
    - Images          4         0         1.558GB   1.558GB (100%)
    - Containers      0         0         0B        0B
    - Local Volumes   3         0         45.46MB   45.46MB (100%)
    - Build Cache     28        0         2.499MB   2.499MB


<a id="orgaae19a5"></a>

# полезные команды для работы с Docker

-   очиста для пересборки "на чистую"  
    
    ```shell
    docker system prune --all
    docker volume prune
    ```
-   посмотреть контейнеры  
    
    ```shell
    # запущенные
    docker container ls
    # и остановленные в том числе
    docker container ls -a
    ```
-   **пересобрать** контейнеры  
    
    ```shell
    docker compose up --build --no-deps <image name> -d
    ```


<a id="org16f6384"></a>

# docker compose / docker-compose

<span class="underline"><span class="underline">[Официальная инструкция по установке плагина](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)</span></span>  

```shell
echo "--docker-compose--"
docker-compose version
echo "--docker compose--"
docker compose version
```

    --docker-compose--
    docker-compose version 1.29.2, build 5becea4c
    docker-py version: 5.0.0
    CPython version: 3.7.10
    OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
    --docker compose--
    Docker Compose version v2.5.0


<a id="org1bae808"></a>

# Как попасть на запущенный контейнер?

Если вы не настроили доступ по SSH на контейнер, то всегда можно туда зайти таким способом  

```shell
docker exec -it <node> /bin/bash
```


<a id="org9b33046"></a>

# NAT (Network Adress Translation)

<span class="underline"><span class="underline">[docker ports](https://docs.docker.com/compose/compose-file/compose-file-v3/#ports)</span></span>  
IPv4-адресов мало, а портов ещё меньше!  
![img](nat.jpg)  


<a id="org6ed27dc"></a>

# немного про NGINX

```c
location / {
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP \
      $remote_addr;
  proxy_set_header X-Forwarded-For \
      $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto \
    $scheme;
/*
 *  web это доменное имя известное
 *  только внутри Docker-сети
*/
  proxy_pass http://web:8080;
}
```


<a id="org47b998e"></a>

# Собрать свой образ с нуля?

<span class="underline"><span class="underline">[baseimage](https://docs.docker.com/develop/develop-images/baseimages/)</span></span>  


<a id="orgeecd9ad"></a>

# Запустить контейнер с графической системой?

<span class="underline"><span class="underline">[Можно](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)</span></span>  


<a id="orgc7ecc51"></a>

# Запустить контейнер в контейнере?

-   в Linux точно <span class="underline"><span class="underline">[можно](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)</span></span>
-   лучше так не делать (могут возникнуть технические сложности)
-   это может быть нужно когда у тебя CI система сама запускает сборку в контейнере, а в процессе сборки может создавать контейнер. тогда надо просто <span class="underline"><span class="underline">[пробрасывать docker daemon из хоста](https://itnext.io/docker-in-docker-521958d34efd?gi=a966915566a0)</span></span>


<a id="orgf808775"></a>

# Дополнительная литература

-   <span class="underline"><span class="underline">[namespaces](https://habr.com/ru/company/selectel/blog/279281/)</span></span>
-   <span class="underline"><span class="underline">[cgroups](https://habr.com/ru/company/selectel/blog/303190/)</span></span>
-   <span class="underline"><span class="underline">[Linux контейнеры](https://habr.com/ru/company/redhatrussia/blog/352052/)</span></span>
-   <span class="underline"><span class="underline">[Образы и контейнеры Docker в картинках](https://habr.com/ru/post/272145/)</span></span>


<a id="orgaab9ec0"></a>

# Вопросы-ответы

![img](questions.jpg)
