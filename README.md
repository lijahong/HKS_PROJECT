# KUBERNETES_UKS_PROJECT

#### Kubernetes & Vagrant & Ansible & KVM 을 이용한 Team 프로젝트
#### Urusa Kubernetes engine Service 는 온프레미스 환경에서 WEB 기반의 사용자 맞춤형 쿠버네티스 클러스터 제공 서비스 이다
- vagrant work : Vagrant & Shell & Ansible & Kubernetes 파일
- k8s-toy-project-web-main : Django 를 이용한 Web 파일

---

## 1. 프로젝트 개요

### 1.1 프로젝트 동기

- GKE 서비스는 웹에서 사용자가 요구하는 사항을 받아 해당 요구 사항을 만족시키는 K8S 클러스터링 서비스를 제공해준다. 이처럼 WEB Dash Board 에서 사용자가 요구하는 사항을 받아 요구 사항을 만족시키는 서비스를 제공하고자 한다. 이러한 클라우드 서비스를 local 환경에서 직접 구축하고자 한다

- 이번 프로젝트에서는 Web 페이지보다는 사용자 요청에 맞는 인프라를 자동으로 구축해주는 백엔드에 초점을 두어 개발했다

### 1.2 프로젝트 목적

- K8S와 다양한 IaC 도구를 이용하여 GKE 서비스와 같이 사용자가 편리하게 K8S 를 이용할 수 있는 서비스를 제공하는 환경을 구축하도록 구상했다

- K8S 와 다양한 도구를 이용하여 사용자가 노드의 스펙, 수, 이미지등을 입력하면 해당 요구 사항에 맞는 K8S 클러스터 환경을 제공하여 사용자가 K8S 서비스를 WEB 상에서 간편하게 이용할 수 있도록 환경을 구축한다

- 이를 통해 K8S 서비스를 이해하고, 프로비저닝을 위한 여러 IaC 도구들을 이용해 K8S 서비스를 제공하는 전체적인 인프라를 이해하고자 한다

---

## 2. 프로젝트 구조와 사용 기술

### 2.1 사용 기술

![](https://velog.velcdn.com/images/lijahong/post/82b90f90-429d-4452-bf60-74759312531a/image.png)
- 사용하는 기술 스택은 위와 같으며 상세 내용은 아래와 같다

![](https://velog.velcdn.com/images/lijahong/post/3d71f601-0f9c-444e-b93f-e1172f3ca824/image.png)

### 2.2 기술 선택 이유

- 클라우드 서비스의 특성 중 하나는 On-Demand 이다. 고객이 서비스를 요청하면 바로 제공해야 합니다. 이때 핵심은 자동화 입니다. 고객은 버튼 클릭 한 번으로 필요한 서비스를 제공 받아야 한다. 따라서 IaC 도구인 Vagrant 와 Ansible 을 통해 해당 서비스를 위한 환경을 자동으로 구축하게 하였다

### 2.3 프로젝트 구조

![](https://velog.velcdn.com/images/lijahong/post/17da91b7-8774-46e6-8bac-f99fe6ea2b37/image.png)

1. WEB 대시보드에서 사용자가 로그인
2. 서비스 요구 사항 입력
3. 데이터 베이스에 저장
4. 저장된 데이터를 shell 과 subprocess 모듈을 통해 ssh 로 Control Node 에 전달
5. Vagrant 에서 해당 요구사항을 반영한 Vagrantfile 을 통해 kvm 과 연계하여 프로비저닝
6. 생성된 인스턴스들은 엔서블의 playbook 을 통해 K8S 클러스터링 및 패키지 설치
7. 사용자는 shellinabox 를 통해 WEB 상에서 Master 노드에 접속

### 2.4 네트워크 구조

![](https://velog.velcdn.com/images/lijahong/post/fd545bed-154f-4106-883d-bd90d1eaeb80/image.png)

### 2.5 데이터 베이스 모델링

![](https://velog.velcdn.com/images/lijahong/post/2c88b269-90ae-47ac-9517-075bec8c5090/image.png)

---

## 3. 프로젝트 결과

#### [시연 영상 링크](https://www.youtube.com/watch?v=8vrlsrU0cTk&t=57s&ab_channel=TheHong)

### 3.1 주요 기능

![](https://velog.velcdn.com/images/lijahong/post/5c8362bc-111c-4223-8dab-8a47823fc43c/image.png)


### 3.2 Kubernetes Cluster 제공

![](https://velog.velcdn.com/images/lijahong/post/573f083f-2edf-4feb-8884-bc2d61e64a59/image.png)
- 사용자는 회원가입 및 로그인 후 인스턴스 요구 사항을 입력할 수 있다
- 프로젝트 이름, Key-Pair, Worker Node 수, Flavor, Image 를 입력할 수 있다

![](https://velog.velcdn.com/images/lijahong/post/d9195bb8-5fec-43b2-bc4e-0b15f3e0f49e/image.png)
- 각 사용자의 디렉토리 안에 프로젝트 디렉토리를 만들어 내부에 프로비저닝을 위한 환경을 준비한다. 이를 위해서 요구 사항을 Vagrant 에서 변수로 인식하게 하는 .env 파일과 SSH 접속을 위한 Key-Pair 가 필요하다
- 사용자마다 요구 사항이 다르므로, 이를 적용시키기 위해서 Vagrantfile 템플릿을 만들고, 해당 템플릿에 요구 사항을 변수로서 적용시킨다
- 인스턴스 생성시 Ansible 명령 전달을 위해 Ansible 인스턴스도 생성해주는데, Ansible 명령을 모두 수행하고 나면, 자원 효율을 위해 Ansible 인스턴스는 삭제해준다

![](https://velog.velcdn.com/images/lijahong/post/3fcad4c7-2112-4b4f-ad5c-71fa32197ec3/image.png)

- 해당 프로젝트에서는 GKE 와 같이 Kubernetes 환경을 제공하는 것이기 때문에, 노드가 생성된 후 Ansible 로 Kubernetes 환경을 설치해주는 것이 아니라 Kubernetes 설치와 클러스터링이 된 상태로 노드가 생성될 수 있도록 프로비저닝 하는 것이 프로젝트의 목적에 더 적합하다고 생각해 Vagrant 에서 Kubernetes 설치를 해 제공하는 것으로 구성하였다
- IaC 도구를 이용해 자동으로 클러스터링이 된 상태로 Kubetnetes 서비스를 제공한다

![](https://velog.velcdn.com/images/lijahong/post/fe747a36-27e6-46d6-a3e6-ec5d02904728/image.png)
- Ansible 명령을 통해 Master Node 에서 K8S Cluster kubeadm Token 을 발급하여 Worker Node 들에게 전달해주고, 이를 이용해 해당 Cluster 에 가입하는 것을 자동화 한다

![](https://velog.velcdn.com/images/lijahong/post/cb54f065-504b-42aa-accc-19084343dcb4/image.png)
- Ansible Playbook 을 통해 필요한 패키지, calico CNI, Ingress, MetalLB 를 설치해준다
- 온프레미스 환경에서 로드 밸런서 서비스에 External IP 를 자동으로 할당해주기 위해 MetalLB 를 설치해준다. 이때, ConfigMap 역시 배포하여 할당해줄 External IP 의 범위를 지정한다

### 3.3 Shellinabox

![](https://velog.velcdn.com/images/lijahong/post/09608bc1-fb6e-4b24-ac9f-900b7def80b4/image.png)
- 생성이 완료되면, 원격 Linux 서버에 액세스하기위한 웹 기반 SSH 터미널인 Shellinabox 를 통해 Master Node 에 접속할 수 있다

### 3.4 Kubernetes 사용

![](https://velog.velcdn.com/images/lijahong/post/cc21fdd4-ab41-46f0-b26b-65a5a22fbbc1/image.png)
- MetalLB 와 Ingress 를 통해 Ingress 배포시 Ingress 의 로드밸런서에 External IP 가 할당된다

![](https://velog.velcdn.com/images/lijahong/post/040a3d35-a39a-4c7f-99d9-2ccea42e2e5e/image.png)
- cAdvisor, Node-Exporter, Prometheus, Grafana 를 Container 로 배포하여 모니터링 환경을 구축 가능하다

![](https://velog.velcdn.com/images/lijahong/post/f5a74a70-b689-4d25-8503-a463f97aa196/image.png)
- 동적 프로비저너를 배포하여 사용 가능하다. 이때 Stoarge Node 와 Control Node 를 NFS 로 Mount 시키고, Mount 된 Control 의 디렉토리를 동적 프로비저너에서 사용하게 지정한다

![](https://velog.velcdn.com/images/lijahong/post/653c22b0-882c-4c6b-8b77-c4f75c99b254/image.png)
- PVC 를 배포하면, 요구하는 스펙에 맞는 PV 가 생성되어 Bound 된다. 이때, 해당 PV 에 데이터를 저장하면, 실제 데이터는 NFS-SERVER 인 Storage Node 에 저장된다

### 3.5 Delete

![](https://velog.velcdn.com/images/lijahong/post/6d14e238-cd9f-4c91-8e2a-62417c90ce84/image.png)

---

## 4. 프로젝트 소감

### 4.1 프로젝트 수행상 어려움 극복 사례

- 네트워크를 설정하면서 브릿지로 IP를 받아와서 공인 Ip 를 할당하고자 했지만, 실습 환경 공유기의 DHCP 설정이 되지 않았다. 이를 가상 NAT 네트워크의 Virtio 브릿지를 이용하여 해결하였다. 

- Vagrant에서 K8S를 설치하는 부분에 있어서 많은 오류가 발생했다. Shell에서 직접 코드를 작성해서 하면 실행이 되지만, 같은 코드를 Vagrantfile에서 실행 할 때 에러가 발생했다. 명령어들을 작성한 Shell 을 작성한 후 Vagrantfile에서 Shell 을 수행하도록 하여 해당 에러를 해결했다

- 인터페이스 설정 파일의 백업본이 인터페이스 파일과 같은 위치에 .backup 형식으로 있어서 해당 인터페이스를 인식 못하는 문제가 발생했다. 이를 다른 경로에 옮겨 둔 후 진행하여 문제를 해결했다

- 사용자가 Master Node 에 접속시 root 가 아닌 vagrant 계정으로 접속한다. 따라서 Kubernetes 사용 권한을 root 가 아닌 vagrant 에게 주어야 한다. 이를 해결하기 위해 Ansible 로 명령 전달시 u 옵션을 통해 명령을 실행할 계정을 지정하여 해당 문제를 해결했다

### 4.2 프로젝트에서 잘한 부분

- WEB 상에서 사용자의 요구 사항을 Shell 과 Vagrant 를 활용하여 자동으로 프로비저닝 함으로써 사용자가 원하는 Kubernetes 서비스를 적절하게 제공할 수 있었다

- Vagrant 와 Ansible 을 활용하여 프로비저닝 및 환경 구성하는 상황에서 권환 관련 오류 및 네트워크 관련 오류에 적절한 대처를 통해 해결할 수 있었다

### 4.3 프로젝트에서 아쉬운 부분

![](https://velog.velcdn.com/images/lijahong/post/55bdb9f4-5d16-4e1d-94ca-61c4d8d1be08/image.png)

### 4.4 프로젝트에서 느낀점

- 해당 프로젝트를 통해 Kubernetes 서비스를 제공하는 환경을 만들며 전체적인 인프라를 이해할 수 있었고, Kubernetes 클러스터링과 자동화등을 경험하며 클라우드 엔지니어 직무에 더욱 흥미가 생겼다
