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

### 3.1 주요 기능

![](https://velog.velcdn.com/images/lijahong/post/5c8362bc-111c-4223-8dab-8a47823fc43c/image.png)


### 3.2 Kubernetes Cluster 제공

![](https://velog.velcdn.com/images/lijahong/post/573f083f-2edf-4feb-8884-bc2d61e64a59/image.png)

![](https://velog.velcdn.com/images/lijahong/post/363523d2-1493-4972-8a44-f50868a182c7/image.png)

![](https://velog.velcdn.com/images/lijahong/post/3fcad4c7-2112-4b4f-ad5c-71fa32197ec3/image.png)

