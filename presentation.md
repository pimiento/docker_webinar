- [chroot](#org93fd1fa)
- [chroot](#org2b2c579)
- [virtual machine](#org3bb35f0)
- [vagrant](#org3107c28)
- [Linux Namespaces](#org99f4536)
- [Docker](#orga35fd59)
- [Слои](#org49d45c9)
- [Где всё на самом деле хранится?](#orga588b4b)
- [Как попасть на запущенный контейнер?](#org8a05b8a)
- [NAT (Network Adress Translation)](#org4d4fa23)
- [Собрать свой образ с нуля?](#org7f530c8)
- [Запустить контейнер с графической системой?](#orgfe488ec)
- [Запустить контейнер в контейнере?](#orgad44dd4)
- [Дополнительная литература](#orgbc37fef)
- [Вопросы-ответы](#orgb349c64)



<a id="org93fd1fa"></a>

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


<a id="org2b2c579"></a>

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


<a id="org3bb35f0"></a>

# virtual machine

<vbox.sh>


<a id="org3107c28"></a>

# vagrant

```shell
mkdir vagrant_project
cd vagrant_project
vagrant init generic/ubuntu2004
vagrant up
```


<a id="org99f4536"></a>

# Linux Namespaces

<span class="underline"><span class="underline">[TryTry](https://github.com/imankulov/trytry)</span></span>


<a id="orga35fd59"></a>

# Docker

![img](docker.jpg)


<a id="org49d45c9"></a>

# Слои

![img](layers.png)


<a id="orga588b4b"></a>

# Где всё на самом деле хранится?

<span class="underline"><span class="underline">[docker volumes](https://docs.docker.com/compose/compose-file/compose-file-v3/#volume-configuration-reference)</span></span>

    /var/lib/docker

```shell
docker system df
```

    - TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
    - Images          5         3         1.374GB   1.141GB (83%)
    - Containers      3         3         488.3kB   0B (0%)
    - Local Volumes   5         3         127.5MB   82.42MB (64%)
    - Build Cache     23        0         43.02kB   43.02kB


<a id="org8a05b8a"></a>

# Как попасть на запущенный контейнер?

Если вы не настроили доступ по SSH на контейнер, то всегда можно туда зайти таким способом

```shell
docker exec -it <node> /bin/bash
```


<a id="org4d4fa23"></a>

# NAT (Network Adress Translation)

<span class="underline"><span class="underline">[docker ports](https://docs.docker.com/compose/compose-file/compose-file-v3/#ports)</span></span>
IPv4-адресов мало, а портов ещё меньше!
![img](nat.jpg)


<a id="org7f530c8"></a>

# Собрать свой образ с нуля?

<span class="underline"><span class="underline">[baseimage](https://docs.docker.com/develop/develop-images/baseimages/)</span></span>


<a id="orgfe488ec"></a>

# Запустить контейнер с графической системой?

<span class="underline"><span class="underline">[Можно](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)</span></span>


<a id="orgad44dd4"></a>

# Запустить контейнер в контейнере?

-   в Linux точно <span class="underline"><span class="underline">[можно](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)</span></span>
-   лучше так не делать (могут возникнуть технические сложности)
-   это может быть нужно когда у тебя CI система сама запускает сборку в контейнере, а в процессе сборки может создавать контейнер. тогда надо просто <span class="underline"><span class="underline">[пробрасывать docker daemon из хоста](https://itnext.io/docker-in-docker-521958d34efd?gi=a966915566a0)</span></span>


<a id="orgbc37fef"></a>

# Дополнительная литература

-   <span class="underline"><span class="underline">[namespaces](https://habr.com/ru/company/selectel/blog/279281/)</span></span>
-   <span class="underline"><span class="underline">[cgroups](https://habr.com/ru/company/selectel/blog/303190/)</span></span>
-   <span class="underline"><span class="underline">[Linux контейнеры](https://habr.com/ru/company/redhatrussia/blog/352052/)</span></span>
-   <span class="underline"><span class="underline">[Образы и контейнеры Docker в картинках](https://habr.com/ru/post/272145/)</span></span>


<a id="orgb349c64"></a>

# Вопросы-ответы

![img](questions.jpg)
