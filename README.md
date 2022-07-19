# **Лекция №2: Знакомство с Kubernetes, основные понятия и архитектура // ДЗ**
> _kubernetes-intro_
<details>
  <summary>Знакомство с Kubernetes</summary>

## **Задание:**
Знакомство с решениями для запуска локального Kubernetes кластера, создание первого pod

Цель:
В данном дз студенты научатся формировать локальное окружение, запустят локальную версию kubernetes при помощи minikube, научатся использовать CLI утилиту kubectl для управления kubernetes.

Описание/Пошаговая инструкция выполнения домашнего задания:
Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

---

## **Выполнено:**
1. Настройка локального окружения. Запуск первого контейнера. Работа с kubectl

- Установка в macOS
> [https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
~~~bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"24", GitVersion:"v1.24.2", GitCommit:"f66044f4361b9f1f96f0053dd46cb7dce5e990a8", GitTreeState:"clean", BuildDate:"2022-06-15T14:22:29Z", GoVersion:"go1.18.3", Compiler:"gc", Platform:"darwin/amd64"}
Kustomize Version: v4.5.4

#Настройка автозаполнения для kubectl
source <(kubectl completion zsh)  # настройка автодополнения в текущую сессию zsh
echo "[[ $commands[kubectl] ]] && source <(kubectl completion zsh)" >> ~/.zshrc # add autocomplete permanently to your zsh shell
~~~

- Установка Minikube

> [https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)

~~~bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
#Start your cluster
minikube start

➜  ~ kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:49819
CoreDNS is running at https://127.0.0.1:49819/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
~~~

- Установка k9s
~~~bash
 # Via Homebrew
 brew install derailed/k9s/k9s
~~~

При установке кластера с использованием Minikube будет создана виртуальная машина в которой будут работать все системные компоненты
кластера Kubernetes. Можем убедиться в этом, зайдем на ВМ по SSH и посмотрим запущенные Docker контейнеры:
~~~bash
➜  Deron-D_platform git:(kubernetes-prepare) minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS     NAMES
4367e7733391   6e38f40d628d           "/storage-provisioner"   2 minutes ago   Up 2 minutes             k8s_storage-provisioner_storage-provisioner_kube-system_23828c8f-5a23-4822-b6e1-35cd6dc6c441_5
2994e51037da   a4ca41631cc7           "/coredns -conf /etc…"   3 minutes ago   Up 3 minutes             k8s_coredns_coredns-6d4b75cb6d-thwlk_kube-system_3de7b505-5edc-4589-92e0-ae3ad0312aa1_1
6515a97abfbe   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_storage-provisioner_kube-system_23828c8f-5a23-4822-b6e1-35cd6dc6c441_1
9e1db89d5a8d   beb86f5d8e6c           "/usr/local/bin/kube…"   3 minutes ago   Up 3 minutes             k8s_kube-proxy_kube-proxy-vfrll_kube-system_bf91d977-9730-4da6-9dd3-d73b79853df7_1
235089a738b2   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_coredns-6d4b75cb6d-thwlk_kube-system_3de7b505-5edc-4589-92e0-ae3ad0312aa1_1
9805d05f9c51   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_kube-proxy-vfrll_kube-system_bf91d977-9730-4da6-9dd3-d73b79853df7_1
32073e618efa   18688a72645c           "kube-scheduler --au…"   3 minutes ago   Up 3 minutes             k8s_kube-scheduler_kube-scheduler-minikube_kube-system_bab0508344d11c6fdb45b1f91c440ff5_1
76120dd3e8cb   aebe758cef4c           "etcd --advertise-cl…"   3 minutes ago   Up 3 minutes             k8s_etcd_etcd-minikube_kube-system_8d8cf2f9b1560093847362b0de0732b1_1
09e004bac218   b4ea7e648530           "kube-controller-man…"   3 minutes ago   Up 3 minutes             k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_852f03e6fe9ac86ddd174fb038c47d74_1
5060e14e576d   e9f4b425f919           "kube-apiserver --ad…"   3 minutes ago   Up 3 minutes             k8s_kube-apiserver_kube-apiserver-minikube_kube-system_580b07225e2af5ec59c4baba2ce979ad_1
70de051d10fc   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_etcd-minikube_kube-system_8d8cf2f9b1560093847362b0de0732b1_1
a31befb2ca73   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_kube-apiserver-minikube_kube-system_580b07225e2af5ec59c4baba2ce979ad_1
4a4606d8c42c   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_kube-scheduler-minikube_kube-system_bab0508344d11c6fdb45b1f91c440ff5_1
d248cd4c3fce   k8s.gcr.io/pause:3.6   "/pause"                 3 minutes ago   Up 3 minutes             k8s_POD_kube-controller-manager-minikube_kube-system_852f03e6fe9ac86ddd174fb038c47d74_1

~~~

Проверим, что Kubernetes обладает некоторой устойчивостью к отказам, удалим все контейнеры:
~~~bash
$ docker rm -f $(docker ps -a -q)
4367e7733391
d8724203c11b
2994e51037da
6515a97abfbe
9e1db89d5a8d
235089a738b2
9805d05f9c51
32073e618efa
76120dd3e8cb
09e004bac218
5060e14e576d
70de051d10fc
a31befb2ca73
4a4606d8c42c
d248cd4c3fce
5c45c6bf6ee7
98c5e5d8e4bc
468cbd9b71ff
c8dacc1a6050
9d35080f5aba
1f26520e3672
a9cfb20bf985
a9b93506987d
aaa8fcbd744a
5eabe1443a2c
f11bf2cbed0c
f354c43f910f
$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS     NAMES
63d2bb3d80f4   6e38f40d628d           "/storage-provisioner"   9 seconds ago    Up 8 seconds              k8s_storage-provisioner_storage-provisioner_kube-system_23828c8f-5a23-4822-b6e1-35cd6dc6c441_6
18df4ef00fdc   a4ca41631cc7           "/coredns -conf /etc…"   10 seconds ago   Up 9 seconds              k8s_coredns_coredns-6d4b75cb6d-thwlk_kube-system_3de7b505-5edc-4589-92e0-ae3ad0312aa1_2
3fcfbf889141   18688a72645c           "kube-scheduler --au…"   10 seconds ago   Up 9 seconds              k8s_kube-scheduler_kube-scheduler-minikube_kube-system_bab0508344d11c6fdb45b1f91c440ff5_2
281d6ca541f5   aebe758cef4c           "etcd --advertise-cl…"   11 seconds ago   Up 9 seconds              k8s_etcd_etcd-minikube_kube-system_8d8cf2f9b1560093847362b0de0732b1_2
4ef73095c330   beb86f5d8e6c           "/usr/local/bin/kube…"   11 seconds ago   Up 9 seconds              k8s_kube-proxy_kube-proxy-vfrll_kube-system_bf91d977-9730-4da6-9dd3-d73b79853df7_2
3928ab5bebe9   b4ea7e648530           "kube-controller-man…"   11 seconds ago   Up 9 seconds              k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_852f03e6fe9ac86ddd174fb038c47d74_2
68791bce9710   e9f4b425f919           "kube-apiserver --ad…"   11 seconds ago   Up 10 seconds             k8s_kube-apiserver_kube-apiserver-minikube_kube-system_580b07225e2af5ec59c4baba2ce979ad_2
427e41162d31   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 8 seconds              k8s_POD_storage-provisioner_kube-system_23828c8f-5a23-4822-b6e1-35cd6dc6c441_0
b55b541aefde   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 10 seconds             k8s_POD_kube-controller-manager-minikube_kube-system_852f03e6fe9ac86ddd174fb038c47d74_0
36e639085225   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 10 seconds             k8s_POD_kube-scheduler-minikube_kube-system_bab0508344d11c6fdb45b1f91c440ff5_0
11a402b3fcdd   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 9 seconds              k8s_POD_coredns-6d4b75cb6d-thwlk_kube-system_3de7b505-5edc-4589-92e0-ae3ad0312aa1_0
9af30614c407   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 10 seconds             k8s_POD_kube-apiserver-minikube_kube-system_580b07225e2af5ec59c4baba2ce979ad_0
406bc07241c3   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 10 seconds             k8s_POD_kube-proxy-vfrll_kube-system_bf91d977-9730-4da6-9dd3-d73b79853df7_0
d7ef6a27f210   k8s.gcr.io/pause:3.6   "/pause"                 12 seconds ago   Up 10 seconds             k8s_POD_etcd-minikube_kube-system_8d8cf2f9b1560093847362b0de0732b1_0
$ exit
logout
~~~~

Эти же компоненты, но уже в виде pod можно увидеть в namespace kube-system
~~~bash
kubectl get pods -n kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-6d4b75cb6d-thwlk           1/1     Running   2          47h
etcd-minikube                      1/1     Running   2          47h
kube-apiserver-minikube            1/1     Running   2          47h
kube-controller-manager-minikube   1/1     Running   2          47h
kube-proxy-vfrll                   1/1     Running   2          47h
kube-scheduler-minikube            1/1     Running   2          47h
storage-provisioner                1/1     Running   6          47h
~~~

Можно устроить еще одну проверку на прочность и удалить все pod с системными компонентами (все поды из namespace kube-system):
~~~bash
kubectl delete pod --all -n kube-system
pod "coredns-6d4b75cb6d-thwlk" deleted
pod "etcd-minikube" deleted
pod "kube-apiserver-minikube" deleted
pod "kube-controller-manager-minikube" deleted
pod "kube-proxy-vfrll" deleted
pod "kube-scheduler-minikube" deleted
pod "storage-provisioner" deleted
~~~

Проверим, что кластер находится в рабочем состоянии
~~~bash
kubectl get cs
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE                         ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok
etcd-0               Healthy   {"health":"true","reason":""}
~~~


### Задание
Разберитесь почему все pod в namespace kube-system восстановились после удаления. Укажите причину в описании PR

~~~bash
kubectl get pods -n kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-6d4b75cb6d-ktz9x           1/1     Running   0          5m1s
etcd-minikube                      1/1     Running   2          5m1s
kube-apiserver-minikube            1/1     Running   2          5m1s
kube-controller-manager-minikube   1/1     Running   2          5m1s
kube-proxy-jzsjn                   1/1     Running   0          4m59s
kube-scheduler-minikube            1/1     Running   2          5m

kubectl describe pods coredns-6d4b75cb6d-ktz9x -n kube-system
Name:                 coredns-6d4b75cb6d-ktz9x
Namespace:            kube-system
Priority:             2000000000
Priority Class Name:  system-cluster-critical
Node:                 minikube/192.168.59.100
Start Time:           Tue, 12 Jul 2022 22:05:30 +0300
Labels:               k8s-app=kube-dns
                      pod-template-hash=6d4b75cb6d
Annotations:          <none>
Status:               Running
IP:                   172.17.0.3
IPs:
  IP:           172.17.0.3
Controlled By:  ReplicaSet/coredns-6d4b75cb6d
...
~~~

`core-dns` управляется контроллером ReplicaSet, т.е. при удалении poda, ReplicaSet обнаруживает его отсутствие и создаёт новый.

~~~bash
kubectl describe pods kube-apiserver-minikube -n kube-system
Name:                 kube-apiserver-minikube
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 minikube/192.168.59.100
Start Time:           Tue, 12 Jul 2022 21:57:32 +0300
Labels:               component=kube-apiserver
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.59.100:8443
                      kubernetes.io/config.hash: 580b07225e2af5ec59c4baba2ce979ad
                      kubernetes.io/config.mirror: 580b07225e2af5ec59c4baba2ce979ad
                      kubernetes.io/config.seen: 2022-07-12T18:57:32.194070041Z
                      kubernetes.io/config.source: file
                      seccomp.security.alpha.kubernetes.io/pod: runtime/default
Status:               Running
IP:                   192.168.59.100
IPs:
  IP:           192.168.59.100
Controlled By:  Node/minikube
...
~~~

`etcd-minikube`,`kube-apiserver`,`kube-controller-manager-minikube`,`kube-scheduler-minikube` управляются Node/minikube, т.е. самим minikube.

~~~bash
kubectl describe pods kube-proxy -n kube-system
Name:                 kube-proxy-jzsjn
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 minikube/192.168.59.100
Start Time:           Tue, 12 Jul 2022 22:05:32 +0300
Labels:               controller-revision-hash=58bf5dfbd7
                      k8s-app=kube-proxy
                      pod-template-generation=1
Annotations:          <none>
Status:               Running
IP:                   192.168.59.100
IPs:
  IP:           192.168.59.100
Controlled By:  DaemonSet/kube-proxy
~~~

`kube-proxy` управляется контроллером DaemonSet, т.е. при удалении poda, DaemonSet обнаруживает его отсутствие и создаёт новый.


### 2. Dockerfile
Для выполнения домашней работы необходимо создать Dockerfile, в котором будет описан образ:
  1. Запускающий web-сервер на порту 8000 (можно использовать любой способ);
  2. Отдающий содержимое директории /app внутри контейнера (например, если в директории /app лежит файл homework.html , то при запуске контейнера данный файл должен быть доступен по URL http://localhost:8000/homework.html);
  3. Работающий с UID 1001.


Создаем Dockerfile cо следующим содержимым:
~~~Dockerfile
FROM nginx:1.23.0-alpine

ENV UID=1001 \
    GID=1001 \
    USER=nginx \
    GROUP=nginx

RUN apk add --no-cache shadow
RUN usermod -u ${UID} ${USER} \
	&& groupmod -g ${GID} ${GROUP} \
    && chown -R ${USER}:${GROUP} /var/cache/nginx \
    && chown -R ${USER}:${GROUP} /var/log/nginx \
    && touch /var/run/nginx.pid \
    && chown -R ${USER}:${GROUP} /var/run/nginx.pid \
    && sed -i '/^user[[:space:]]*nginx;$/d' /etc/nginx/nginx.conf

WORKDIR /app/
COPY ./app .

COPY ./default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8000/tcp
USER ${UID}:${GID}

CMD ["nginx", "-g", "daemon off;"]
~~~


Собираем образ, запускаем, проверяем работу и выкладываем в Docker Hub:
~~~bash
docker build -t deron73/my-nginx-image:0.2 --no-cache .

docker run -d -p 8000:8000 deron73/my-nginx-image:0.2
f633b4b4def7c09e15a5de2c7c976bd053d2c947fab6e02b0046c61c3eb6e44a
➜  web git:(kubernetes-prepare) ✗ curl http://localhost:8000
<html>
<head><title>Index of /</title></head>
<body>
<h1>Index of /</h1><hr><pre><a href="../">../</a>
<a href="homework.html">homework.html</a>                                      17-Jul-2022 06:28                 112
</pre><hr></body>
</html>
➜  web git:(kubernetes-prepare) ✗ docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED          STATUS          PORTS                                               NAMES
f633b4b4def7   deron73/my-nginx-image:0.2   "/docker-entrypoint.…"   37 seconds ago   Up 36 seconds   80/tcp, 0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   ecstatic_swanson
➜  web git:(kubernetes-prepare) ✗ docker exec -it f633b4b4def7 sh
/app $ ps aux
PID   USER     TIME  COMMAND
    1 nginx     0:00 nginx: master process nginx -g daemon off;
   23 nginx     0:00 nginx: worker process
   24 nginx     0:00 nginx: worker process
   25 nginx     0:00 nginx: worker process
   26 nginx     0:00 nginx: worker process
   27 nginx     0:00 nginx: worker process
   28 nginx     0:00 nginx: worker process
   29 nginx     0:00 nginx: worker process
   30 nginx     0:00 nginx: worker process
   31 nginx     0:00 nginx: worker process
   32 nginx     0:00 nginx: worker process
   33 nginx     0:00 nginx: worker process
   34 nginx     0:00 nginx: worker process
   35 nginx     0:00 sh
   41 nginx     0:00 ps aux
/app $ id
uid=1001(nginx) gid=1001(nginx)
/app $ whoami
nginx
~~~

### 3. Манифест pod
Напишем манифест web-pod.yaml для создания pod web c меткой app со значением web, содержащего один контейнер с названием web.


~~~bash
kubectl apply -f web-pod.yaml

kubectl get pods
NAME   READY   STATUS    RESTARTS   AGE
web    1/1     Running   0          12s

kubectl logs  web
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: can not modify /etc/nginx/conf.d/default.conf (read-only file system?)
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/07/17 11:41:24 [notice] 1#1: using the "epoll" event method
2022/07/17 11:41:24 [notice] 1#1: nginx/1.23.0
2022/07/17 11:41:24 [notice] 1#1: built by gcc 11.2.1 20220219 (Alpine 11.2.1_git20220219)
2022/07/17 11:41:24 [notice] 1#1: OS: Linux 5.10.57
2022/07/17 11:41:24 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/07/17 11:41:24 [notice] 1#1: start worker processes
2022/07/17 11:41:24 [notice] 1#1: start worker process 23
2022/07/17 11:41:24 [notice] 1#1: start worker process 24
~~~

В Kubernetes есть возможность получить манифест уже запущенного в кластере pod.
~~~bash
kubectl get pod web -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"web"},"name":"web","namespace":"default"},"spec":{"containers":[{"image":"deron73/my-nginx-image:0.2","imagePullPolicy":"Always","livenessProbe":{"tcpSocket":{"port":8000}},"name":"web","readinessProbe":{"httpGet":{"path":"/","port":8000}},"startupProbe":{"failureThreshold":30,"httpGet":{"path":"/","port":8000},"periodSeconds":10}}]}}
  creationTimestamp: "2022-07-17T11:42:24Z"
  labels:
    app: web
  name: web
...
~~~

Другой способ посмотреть описание pod
~~~bash
kubectl get pod web -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"web"},"name":"web","namespace":"default"},"spec":{"containers":[{"image":"deron73/my-nginx-image:0.2","imagePullPolicy":"Always","livenessProbe":{"tcpSocket":{"port":8000}},"name":"web","readinessProbe":{"httpGet":{"path":"/","port":8000}},"startupProbe":{"failureThreshold":30,"httpGet":{"path":"/","port":8000},"periodSeconds":10}}]}}
  creationTimestamp: "2022-07-17T11:42:24Z"
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m10s  default-scheduler  Successfully assigned default/web to minikube
  Normal  Pulling    4m9s   kubelet            Pulling image "deron73/my-nginx-image:0.2"
  Normal  Pulled     4m6s   kubelet            Successfully pulled image "deron73/my-nginx-image:0.2" in 3.537665473s
  Normal  Created    4m6s   kubelet            Created container web
  Normal  Started    4m6s   kubelet            Started container web
~~~

Шатаем pod, указав в манифесте несуществующий тег образа web
~~~bash
kubectl apply -f web-pod.yaml
pod/web configured
➜  kubernetes-intro git:(kubernetes-prepare) ✗ kubectl describe pod web
Events:
  Type     Reason     Age   From               Message
  ----     ------     ----  ----               -------
  Normal   Scheduled  11m   default-scheduler  Successfully assigned default/web to minikube
  Normal   Pulling    11m   kubelet            Pulling image "deron73/my-nginx-image:0.2"
  Normal   Pulled     11m   kubelet            Successfully pulled image "deron73/my-nginx-image:0.2" in 3.537665473s
  Normal   Created    11m   kubelet            Created container web
  Normal   Started    11m   kubelet            Started container web
  Normal   Killing    6s    kubelet            Container web definition changed, will be restarted
  Normal   Pulling    6s    kubelet            Pulling image "deron73/my-nginx-image:0.3"
  Warning  Failed     1s    kubelet            Failed to pull image "deron73/my-nginx-image:0.3": rpc error: code = Unknown desc = Error response from daemon: manifest for deron73/my-nginx-image:0.3 not found: manifest unknown: manifest unknown
  Warning  Failed     1s    kubelet            Error: ErrImagePull
  Warning  Unhealthy  1s    kubelet            Readiness probe failed: Get "http://172.17.0.3:8000/": dial tcp 172.17.0.3:8000: connect: connection refused
  Warning  Unhealthy  1s    kubelet            Liveness probe failed: dial tcp 172.17.0.3:8000: connect: connection refused
  Normal   BackOff    1s    kubelet            Back-off pulling image "deron73/my-nginx-image:0.3"
  Warning  Failed     1s    kubelet            Error: ImagePullBackOff
~~~

### 4. Init контейнеры & Volumes

Добавим в наш pod [init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/), генерирующий страницу index.html
Для того, чтобы файлы, созданные в init контейнере, были доступны основному контейнеру в pod нам понадобится использовать volume типа emptyDir.
~~~yaml
...
    volumeMounts:
    - name: app
      mountPath: /app
  initContainers:
  - name: init-web
    image: busybox:1.34.1
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: app
      mountPath: /app
    command: ['sh', '-c', 'wget -O- https://tinyurl.com/otus-k8s-intro | sh']
  volumes:
    - name: app
      emptyDir: {}
~~~

Перезапускам pod

~~~bash
kubectl delete -f web-pod.yaml
pod "web" deleted

➜  kubernetes-intro git:(kubernetes-prepare) ✗ kubectl apply -f web-pod.yaml
pod/web created

➜  kubernetes-intro git:(kubernetes-prepare) ✗ kubectl get pods -w
NAME   READY   STATUS            RESTARTS   AGE
web    0/1     PodInitializing   0          3s
web    0/1     Running           0          8s
web    0/1     Running           0          10s
web    1/1     Running           0          11s
~~~

### 5. Проверка работы приложения

~~~bash
kubectl port-forward --address 0.0.0.0 pod/web 8000:8000 &

curl http://localhost:8000
Handling connection for 8000
<html>
<head/>
<body>
<!-- IMAGE BEGINS HERE -->
<font size="-3">
...
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
fe00::0	ip6-mcastprefix
fe00::1	ip6-allnodes
fe00::2	ip6-allrouters
172.17.0.3	web</pre>
</body>
</html>
~~~

### 6. Hipster Shop

Начнем с микросервиса frontend. Его исходный код доступен по адресу [https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/frontend](https://github.com/GoogleCloudPlatform/microservices-demo/tree/master/src/frontend)
Склонируем и соберем собственный образ для frontend  (используя готовый Dockerfile)

~~~bash
cd microservices-demo/src/frontend
docker build -t deron73/hipster-frontend:0.1 .
~~~

Запустим через ad-hoc режим:
~~~bash
kubectl run frontend --image deron73/hipster-frontend:0.1 --restart=Never
~~~

Один из распространенных кейсов использования ad-hoc режима - генерация манифестов средствами kubectl:
~~~bash
kubectl run frontend --image deron73/hipster-frontend:0.1 --restart=Never --dry-run=client -o yaml > frontend-pod.yaml
~~~

Выяснение причины, по которой pod frontend находится в статусе Error
~~~bash
kubectl get pods
NAME       READY   STATUS    RESTARTS   AGE
frontend   0/1     Error     0          37s
web        1/1     Running   0          66m


kubectl logs frontend
{"message":"Tracing enabled.","severity":"info","timestamp":"2022-07-17T13:28:04.634511032Z"}
{"message":"Profiling enabled.","severity":"info","timestamp":"2022-07-17T13:28:04.634606765Z"}
panic: environment variable "PRODUCT_CATALOG_SERVICE_ADDR" not set

goroutine 1 [running]:
main.mustMapEnv(0xc0000cef20, {0xccfc12, 0x1c})
	/src/main.go:259 +0xb9
main.main()
	/src/main.go:117 +0x57e
~~~

Добавим небходимый блок `env` в `frontend-pod-healthy.yaml` из [https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/kubernetes-manifests/frontend.yaml](https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/kubernetes-manifests/frontend.yaml) и проверяем:
~~~bash
kubectl delete pod frontend
kubectl apply -f frontend-pod-healthy.yaml
kubectl get pods
NAME       READY   STATUS    RESTARTS   AGE
frontend   1/1     Running   0          14s
web        1/1     Running   0          77m
~~~


# **Полезное:**
[Kube Forwarder](https://kube-forwarder.pixelpoint.io/)

</details>

# **Лекция №3: Механика запуска и взаимодействия контейнеров в Kubernetes // ДЗ**
> _kubernetes-controllers_
<details>
  <summary>Kubernetes controllers.ReplicaSet, Deployment,DaemonSet</summary>

## **Задание:**
Kubernetes controllers. ReplicaSet, Deployment, DaemonSet

Цель:
В данном дз студенты научатся формировать Replicaset, Deployment для своего приложения. Научатся управлять обновлением своего приложения. Так же научатся использовать механизм Probes для проверки работоспособности своих приложений.

Описание/Пошаговая инструкция выполнения домашнего задания:
Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

---

## **Выполнено:**

### 1. Подготовка

- Установка kind

Linux
~~~bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
chmod +x ./kind
mv ./kind ~/bin/
~~~

MacOs
~~~bash
brew install kind
~~~

Создадим `kind-config.yaml` со следующим содержимым:
~~~yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
~~~

- Запуск кластера
~~~bash
kind create cluster --config kind-config.yaml

kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   15m   v1.24.0
kind-worker          Ready    <none>          14m   v1.24.0
kind-worker2         Ready    <none>          14m   v1.24.0
kind-worker3         Ready    <none>          14m   v1.24.0
~~~

### 2. ReplicaSet

- Создадим `frontend-replicaset.yaml` со следующим содержимым:
~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: server
        image: deron73/hipster-frontend:0.1
        env:
          - name: PORT
            value: "8080"
          - name: PRODUCT_CATALOG_SERVICE_ADDR
            value: "productcatalogservice:3550"
          - name: CURRENCY_SERVICE_ADDR
            value: "currencyservice:7000"
          - name: CART_SERVICE_ADDR
            value: "cartservice:7070"
          - name: RECOMMENDATION_SERVICE_ADDR
            value: "recommendationservice:8080"
          - name: SHIPPING_SERVICE_ADDR
            value: "shippingservice:50051"
          - name: CHECKOUT_SERVICE_ADDR
            value: "checkoutservice:5050"
          - name: AD_SERVICE_ADDR
            value: "adservice:9555"
~~~

- Деплоим и проверяем:

~~~bash
kubectl apply -f frontend-replicaset.yaml

kubectl get replicaset
NAME       DESIRED   CURRENT   READY   AGE
frontend   1         1         1       2m58s

kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-4tbc9   1/1     Running   0          23s
~~~

- Пробуем увеличить количество реплик сервиса ad-hoc командой:
~~~bash
kubectl scale replicaset frontend --replicas=3

kubectl get rs frontend
NAME       DESIRED   CURRENT   READY   AGE
frontend   3         3         3       35m
~~~

Проверим, что благодаря контроллеру pod’ы действительно восстанавливаются после их ручного удаления:
~~~bash
kubectl delete pods -l app=frontend | kubectl get pods -l app=frontend -w
NAME             READY   STATUS    RESTARTS   AGE
frontend-4tbc9   1/1     Running   0          38m
frontend-m7d4j   1/1     Running   0          3m20s
frontend-wnc59   1/1     Running   0          3m20s
frontend-4tbc9   1/1     Terminating   0          38m
frontend-m7d4j   1/1     Terminating   0          3m20s
frontend-wnc59   1/1     Terminating   0          3m20s
frontend-ngbxg   0/1     Pending       0          0s
frontend-ngbxg   0/1     Pending       0          0s
frontend-nvvb8   0/1     Pending       0          0s
frontend-b5px5   0/1     Pending       0          0s
frontend-ngbxg   0/1     ContainerCreating   0          0s
frontend-nvvb8   0/1     Pending             0          0s
frontend-b5px5   0/1     Pending             0          0s
frontend-nvvb8   0/1     ContainerCreating   0          0s
frontend-b5px5   0/1     ContainerCreating   0          0s
frontend-wnc59   0/1     Terminating         0          3m21s
frontend-4tbc9   0/1     Terminating         0          38m
frontend-m7d4j   0/1     Terminating         0          3m21s
frontend-wnc59   0/1     Terminating         0          3m21s
frontend-wnc59   0/1     Terminating         0          3m21s
frontend-m7d4j   0/1     Terminating         0          3m21s
frontend-4tbc9   0/1     Terminating         0          38m
frontend-4tbc9   0/1     Terminating         0          38m
frontend-m7d4j   0/1     Terminating         0          3m21s
frontend-ngbxg   1/1     Running             0          1s
frontend-b5px5   1/1     Running             0          1s
frontend-nvvb8   1/1     Running             0          1s
~~~

~~~bash
kubectl apply -f frontend-replicaset.yaml
replicaset.apps/frontend configured
➜  kubernetes-controllers git:(kubernetes-controllers) ✗  kubectl get pods -l app=frontend -w
NAME             READY   STATUS    RESTARTS   AGE
frontend-b5px5   1/1     Running   0          80s
~~~

- Обновление ReplicaSet

~~~bash
docker tag deron73/hipster-frontend:0.1 deron73/hipster-frontend:0.2
docker push deron73/hipster-frontend:0.2

kubectl apply -f frontend-replicaset.yaml | kubectl get pods -l app=frontend -w

# Давайте проверим образ, указанный в ReplicaSet:
kubectl get replicaset frontend -o=jsonpath='{.spec.template.spec.containers[0].image}'
deron73/hipster-frontend:0.2%

# И образ из которого сейчас запущены pod, управляемые контроллером:
kubectl get pods -l app=frontend -o=jsonpath='{.items[0:3].spec.containers[0].image}'
deron73/hipster-frontend:0.1 deron73/hipster-frontend:0.1 deron73/hipster-frontend:0.1%

# Удаляем и пересоздадим поды
kubectl delete -f frontend-replicaset.yaml
kubectl apply -f frontend-replicaset.yaml

# Проверим опять образ из которого сейчас запущены pod, управляемые контроллером:
kubectl get pods -l app=frontend -o=jsonpath='{.items[0:3].spec.containers[0].image}'
deron73/hipster-frontend:0.2 deron73/hipster-frontend:0.2 deron73/hipster-frontend:0.2%

# Образ обновился!
~~~

> Руководствуясь материалами лекции опишите произошедшую ситуацию, почему обновление ReplicaSet не повлекло обновление запущенных pod?

ReplicaSet гарантирует только факт заданного числа запущенных экземпляров подов в кластере Kubernetes в момент времени. Т.о. ReplicaSet не перезапускает поды при обновлении спецификации пода, в отличие от Deployment.



- Повторим действия, проделанные с микросервисом 'frontend' для микросервиса 'paymentService'. Используем label 'app: paymentservice'.


~~~bash
cd microservices-demo/src/paymentservice
docker build -t deron73/hipster-paymentservice:v0.0.1 .
docker build -t deron73/hipster-paymentservice:v0.0.2 .
docker push deron73/hipster-paymentservice:v0.0.1
docker push deron73/hipster-paymentservice:v0.0.2

kubectl run paymentservice --image deron73/hipster-paymentservice:v0.0.1 --restart=Never

kubectl run paymentservice --image deron73/hipster-paymentservice:v0.0.1 --restart=Never --dry-run=client -o yaml > paymentservice-replicaset.yaml

~~~

### 3. Deployment

Скопируйте содержимое файла `paymentservice-replicaset.yaml` в файл `paymentservice-deployment.yaml`
Изменим поле `kind` с `ReplicaSet` на `Deployment` и  проверим:
~~~bash
kubectl apply -f paymentservice-deployment.yaml

kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
paymentservice-58867c4d8d-5nr2w   1/1     Running   0          23s
paymentservice-58867c4d8d-n6qxw   1/1     Running   0          23s
paymentservice-58867c4d8d-qvkcj   1/1     Running   0          23s

#помимо Deployment...
kubectl get deployments
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
paymentservice   3/3     3            3           82s

#появился новый ReplicaSet
kubectl get rs
NAME                        DESIRED   CURRENT   READY   AGE
paymentservice-58867c4d8d   3         3         3       91s
~~~

# **Полезное:**

</details>
