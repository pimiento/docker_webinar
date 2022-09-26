- [chroot](#org1f773cb)
- [chroot](#orgdfbb147)
- [virtual machine](#org1554758)
- [vagrant](#orga6e8d61)
- [Linux Namespaces](#org08f7c98)
- [Docker](#orgd65cd3f)
- [Слои](#orgb308970)
- [Монтирование](#orgd954d4d)
- [Где всё на самом деле хранится?](#org4831f99)
- [Как попасть на запущенный контейнер?](#org8d23962)
- [NAT (Network Adress Translation)](#orgcf3b39b)
- [Собрать свой образ с нуля?](#org5823aa1)
- [Запустить контейнер с графической системой?](#orgdac1b39)
- [Запустить контейнер в контейнере?](#orgcba9c8a)
- [Дополнительная литература](#orga922fa1)
- [Вопросы-ответы](#org7e1a28e)



<a id="org1f773cb"></a>

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


<a id="orgdfbb147"></a>

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


<a id="org1554758"></a>

# virtual machine

<vbox.sh>  


<a id="orga6e8d61"></a>

# vagrant

```shell
mkdir vagrant_project
cd vagrant_project
vagrant init generic/ubuntu2004
vagrant up
```


<a id="org08f7c98"></a>

# Linux Namespaces

<span class="underline"><span class="underline">[TryTry](https://github.com/imankulov/trytry)</span></span>  


<a id="orgd65cd3f"></a>

# Docker

![img](docker.jpg)  


<a id="orgb308970"></a>

# Слои

![img](layers.png)  


<a id="orgd954d4d"></a>

# Монтирование

<span class="underline"><span class="underline">[Документация](https://docs.docker.com/storage/volumes/)</span></span>  
![img](types-of-mounts-volume.png)  


<a id="org4831f99"></a>

# Где всё на самом деле хранится?

<span class="underline"><span class="underline">[docker volumes](https://docs.docker.com/compose/compose-file/compose-file-v3/#volume-configuration-reference)</span></span>  

```
/var/lib/docker
```

```shell
docker system df
```

    - TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
    - Images          0         0         0B        0B
    - Containers      0         0         0B        0B
    - Local Volumes   0         0         0B        0B
    - Build Cache     0         0         0B        0B


<a id="org8d23962"></a>

# Как попасть на запущенный контейнер?

Если вы не настроили доступ по SSH на контейнер, то всегда можно туда зайти таким способом  

```shell
docker exec -it <node> /bin/bash
```


<a id="orgcf3b39b"></a>

# NAT (Network Adress Translation)

<span class="underline"><span class="underline">[docker ports](https://docs.docker.com/compose/compose-file/compose-file-v3/#ports)</span></span>  
IPv4-адресов мало, а портов ещё меньше!  
![img](nat.jpg)  


<a id="org5823aa1"></a>

# Собрать свой образ с нуля?

<span class="underline"><span class="underline">[baseimage](https://docs.docker.com/develop/develop-images/baseimages/)</span></span>  


<a id="orgdac1b39"></a>

# Запустить контейнер с графической системой?

<span class="underline"><span class="underline">[Можно](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)</span></span>  


<a id="orgcba9c8a"></a>

# Запустить контейнер в контейнере?

-   в Linux точно <span class="underline"><span class="underline">[можно](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)</span></span>
-   лучше так не делать (могут возникнуть технические сложности)
-   это может быть нужно когда у тебя CI система сама запускает сборку в контейнере, а в процессе сборки может создавать контейнер. тогда надо просто <span class="underline"><span class="underline">[пробрасывать docker daemon из хоста](https://itnext.io/docker-in-docker-521958d34efd?gi=a966915566a0)</span></span>


<a id="orga922fa1"></a>

# Дополнительная литература

-   <span class="underline"><span class="underline">[namespaces](https://habr.com/ru/company/selectel/blog/279281/)</span></span>
-   <span class="underline"><span class="underline">[cgroups](https://habr.com/ru/company/selectel/blog/303190/)</span></span>
-   <span class="underline"><span class="underline">[Linux контейнеры](https://habr.com/ru/company/redhatrussia/blog/352052/)</span></span>
-   <span class="underline"><span class="underline">[Образы и контейнеры Docker в картинках](https://habr.com/ru/post/272145/)</span></span>


<a id="org7e1a28e"></a>

# Вопросы-ответы

![img](questions.jpg)
