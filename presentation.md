- [chroot](#org61e57c1)
- [chroot](#org347625b)
- [virtual machine](#org099ddcf)
- [vagrant](#orga3bae09)
- [Linux Namespaces](#org77a03ca)
- [Docker](#org101ee48)
- [Слои](#org13ffe85)
- [Где всё на самом деле хранится?](#org8080ae5)
- [Как попасть на запущенный контейнер?](#org57147cf)
- [Собрать свой образ с нуля?](#orgdf7888c)
- [Запустить контейнер с графической системой?](#orgb442cf3)
- [Запустить контейнер в контейнере?](#org5c27090)
- [Дополнительная литература](#orgf599d5c)
- [Вопросы-ответы](#org78e7c5a)



<a id="org61e57c1"></a>

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


<a id="org347625b"></a>

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


<a id="org099ddcf"></a>

# virtual machine

<vbox.sh>


<a id="orga3bae09"></a>

# vagrant

```shell
mkdir vagrant_project
cd vagrant_project
vagrant init generic/ubuntu2004
vagrant up
```


<a id="org77a03ca"></a>

# Linux Namespaces

<span class="underline"><span class="underline">[TryTry](https://github.com/imankulov/trytry)</span></span>


<a id="org101ee48"></a>

# Docker

![img](docker.jpg)


<a id="org13ffe85"></a>

# Слои

![img](layers.png)


<a id="org8080ae5"></a>

# Где всё на самом деле хранится?

    /var/lib/docker

```shell
docker system df
```

    - TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
    - Images          5         3         1.374GB   1.141GB (83%)
    - Containers      3         3         488.3kB   0B (0%)
    - Local Volumes   5         3         127.5MB   82.42MB (64%)
    - Build Cache     23        0         43.02kB   43.02kB


<a id="org57147cf"></a>

# Как попасть на запущенный контейнер?

Если вы не настроили доступ по SSH на контейнер, то всегда можно туда зайти таким способом

```shell
docker exec -it <node> /bin/bash
```


<a id="orgdf7888c"></a>

# Собрать свой образ с нуля?

<span class="underline"><span class="underline">[baseimage](https://docs.docker.com/develop/develop-images/baseimages/)</span></span>


<a id="orgb442cf3"></a>

# Запустить контейнер с графической системой?

<span class="underline"><span class="underline">[Можно](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)</span></span>


<a id="org5c27090"></a>

# Запустить контейнер в контейнере?

-   в Linux точно <span class="underline"><span class="underline">[можно](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)</span></span>
-   лучше так не делать (могут возникнуть технические сложности)
-   это может быть нужно когда у тебя CI система сама запускает сборку в контейнере, а в процессе сборки может создавать контейнер. тогда надо просто <span class="underline"><span class="underline">[пробрасывать docker daemon из хоста](https://itnext.io/docker-in-docker-521958d34efd?gi=a966915566a0)</span></span>


<a id="orgf599d5c"></a>

# Дополнительная литература

-   <span class="underline"><span class="underline">[namespaces](https://habr.com/ru/company/selectel/blog/279281/)</span></span>
-   <span class="underline"><span class="underline">[cgroups](https://habr.com/ru/company/selectel/blog/303190/)</span></span>
-   <span class="underline"><span class="underline">[Linux контейнеры](https://habr.com/ru/company/redhatrussia/blog/352052/)</span></span>
-   <span class="underline"><span class="underline">[Образы и контейнеры Docker в картинках](https://habr.com/ru/post/272145/)</span></span>


<a id="org78e7c5a"></a>

# Вопросы-ответы

![img](questions.jpg)
