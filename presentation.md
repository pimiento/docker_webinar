- [chroot](#org779741e)
- [chroot](#orgc45c09b)
- [virtual machine](#org1c8186c)
- [vagrant](#org3c26e72)
- [Linux Namespaces](#org8dc39b9)
- [Docker](#org00bf7e6)
- [Слои](#org28ddd47)
- [Где всё на самом деле хранится?](#orgb73bd25)
- [Как попасть на запущенный контейнер?](#org2341ef6)
- [Собрать свой образ с нуля?](#org5996a74)
- [Запустить контейнер с графической системой?](#orgc4bbe33)
- [Запустить контейнер в контейнере?](#org9a97677)
- [Дополнительная литература](#org69bd925)
- [Вопросы-ответы](#orgde10419)



<a id="org779741e"></a>

# chroot

Добавим Django в chroot

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


<a id="orgc45c09b"></a>

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
  /bin/cp ${name} chroot/bin/
}
```


<a id="org1c8186c"></a>

# virtual machine

<vbox.sh>


<a id="org3c26e72"></a>

# vagrant

```shell
mkdir vagrant_project
cd vagrant_project
vagrant init generic/ubuntu2004
vagrant run
```


<a id="org8dc39b9"></a>

# Linux Namespaces

<span class="underline"><span class="underline">[TryTry](https://github.com/imankulov/trytry)</span></span>


<a id="org00bf7e6"></a>

# Docker

![img](docker.jpg)


<a id="org28ddd47"></a>

# Слои

![img](layers.png)


<a id="orgb73bd25"></a>

# Где всё на самом деле хранится?

    /var/lib/docker

```shell
docker system df
```

    - TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
    - Images          2         0         301.9MB   301.9MB (100%)
    - Containers      0         0         0B        0B
    - Local Volumes   0         0         0B        0B
    - Build Cache     0         0         0B        0B


<a id="org2341ef6"></a>

# Как попасть на запущенный контейнер?

Если вы не настроили доступ по SSH на контейнер, то всегда можно туда зайти таким способом

```shell
docker exec -it <node> /bin/bash
```


<a id="org5996a74"></a>

# Собрать свой образ с нуля?

<span class="underline"><span class="underline">[baseimage](https://docs.docker.com/develop/develop-images/baseimages/)</span></span>


<a id="orgc4bbe33"></a>

# Запустить контейнер с графической системой?

<span class="underline"><span class="underline">[Можно](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)</span></span>


<a id="org9a97677"></a>

# Запустить контейнер в контейнере?

-   в Linux точно <span class="underline"><span class="underline">[можно](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)</span></span>
-   лучше так не делать (могут возникнуть технические сложности)
-   это может быть нужно когда у тебя CI система сама запускает сборку в контейнере, а в процессе сборки может создавать контейнер. тогда надо просто <span class="underline"><span class="underline">[пробрасывать docker daemon из хоста](https://itnext.io/docker-in-docker-521958d34efd?gi=a966915566a0)</span></span>


<a id="org69bd925"></a>

# Дополнительная литература

-   <span class="underline"><span class="underline">[namespaces](https://habr.com/ru/company/selectel/blog/279281/)</span></span>
-   <span class="underline"><span class="underline">[cgroups](https://habr.com/ru/company/selectel/blog/303190/)</span></span>
-   <span class="underline"><span class="underline">[Linux контейнеры](https://habr.com/ru/company/redhatrussia/blog/352052/)</span></span>
-   <span class="underline"><span class="underline">[Образы и контейнеры Docker в картинках](https://habr.com/ru/post/272145/)</span></span>


<a id="orgde10419"></a>

# Вопросы-ответы

![img](questions.jpg)
