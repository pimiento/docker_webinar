- [chroot](#orge096cac)
- [chroot](#orge1fb7f6)
- [virtual machine](#org7ed2eef)
- [vagrant](#orga75b99b)
- [Linux Namespaces](#orge5f2379)
- [Docker](#orgf82f53c)
- [Слои](#org49bb43f)
- [Где всё на самом деле хранится?](#org925410f)
- [Как попасть на запущенный контейнер?](#org5c5ca35)
- [Собрать свой образ с нуля?](#org12bcea4)
- [Запустить контейнер с графической системой?](#org9bfa531)
- [Запустить контейнер в контейнере?](#orgd6158f5)
- [Дополнительная литература](#orge288427)
- [Вопросы-ответы](#org7fa6359)



<a id="orge096cac"></a>

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


<a id="orge1fb7f6"></a>

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


<a id="org7ed2eef"></a>

# virtual machine

<vbox.sh>


<a id="orga75b99b"></a>

# vagrant

```shell
mkdir vagrant_project
cd vagrant_project
vagrant init generic/ubuntu2004
vagrant up
```


<a id="orge5f2379"></a>

# Linux Namespaces

<span class="underline"><span class="underline">[TryTry](https://github.com/imankulov/trytry)</span></span>


<a id="orgf82f53c"></a>

# Docker

![img](docker.jpg)


<a id="org49bb43f"></a>

# Слои

![img](layers.png)


<a id="org925410f"></a>

# Где всё на самом деле хранится?

    /var/lib/docker

```shell
docker system df
```

    - TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
    - Images          6         4         1.836GB   1.024GB (55%)
    - Containers      4         2         40.65MB   264.9kB (0%)
    - Local Volumes   2         2         445.8kB   0B (0%)
    - Build Cache     0         0         0B        0B


<a id="org5c5ca35"></a>

# Как попасть на запущенный контейнер?

Если вы не настроили доступ по SSH на контейнер, то всегда можно туда зайти таким способом

```shell
docker exec -it <node> /bin/bash
```


<a id="org12bcea4"></a>

# Собрать свой образ с нуля?

<span class="underline"><span class="underline">[baseimage](https://docs.docker.com/develop/develop-images/baseimages/)</span></span>


<a id="org9bfa531"></a>

# Запустить контейнер с графической системой?

<span class="underline"><span class="underline">[Можно](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)</span></span>


<a id="orgd6158f5"></a>

# Запустить контейнер в контейнере?

-   в Linux точно <span class="underline"><span class="underline">[можно](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)</span></span>
-   лучше так не делать (могут возникнуть технические сложности)
-   это может быть нужно когда у тебя CI система сама запускает сборку в контейнере, а в процессе сборки может создавать контейнер. тогда надо просто <span class="underline"><span class="underline">[пробрасывать docker daemon из хоста](https://itnext.io/docker-in-docker-521958d34efd?gi=a966915566a0)</span></span>


<a id="orge288427"></a>

# Дополнительная литература

-   <span class="underline"><span class="underline">[namespaces](https://habr.com/ru/company/selectel/blog/279281/)</span></span>
-   <span class="underline"><span class="underline">[cgroups](https://habr.com/ru/company/selectel/blog/303190/)</span></span>
-   <span class="underline"><span class="underline">[Linux контейнеры](https://habr.com/ru/company/redhatrussia/blog/352052/)</span></span>
-   <span class="underline"><span class="underline">[Образы и контейнеры Docker в картинках](https://habr.com/ru/post/272145/)</span></span>


<a id="org7fa6359"></a>

# Вопросы-ответы

![img](questions.jpg)
