# 개발 워크스테이션 구축 미션

> ⚠️ 이 파일은 템플릿입니다. `[ ]`, `여기에 붙여넣기`, `<!-- TODO -->` 로 표시된 부분을
> 실제로 터미널에서 실행한 결과(명령어+출력)와 스크린샷으로 교체한 뒤 제출하세요.
> 민감정보(토큰/비밀번호/개인키)는 절대 포함하지 마세요.

## 1) 프로젝트 개요

- 목표: 터미널/파일 권한, Docker(OrbStack), Dockerfile 기반 커스텀 이미지, 포트 매핑,
  바인드 마운트, 볼륨 영속성, Git/GitHub 연동까지 개발 워크스테이션의 기본기를 직접 손으로
  세팅하고 검증한다.
- 구성: nginx:alpine 베이스 커스텀 이미지. 정적 콘텐츠(`site/`)와 nginx 설정
  (`default.conf.template`)을 교체했고, 환경변수(`APP_ENV`)를 커스텀 응답 헤더로
  노출해 재빌드 없이 `-e` 값만 바꿔도 동작이 달라지는 것을 확인한다.
  바인드 마운트로 정적 파일 즉시 반영을, 접속 로그(`/var/log/nginx`)를 볼륨에 저장해
  컨테이너를 삭제해도 데이터가 유지되는 것을 확인한다.

## 2) 실행 환경

- OS: <!-- TODO: 예) macOS 15.x (Apple Silicon) -->
- Shell / Terminal: <!-- TODO: 예) zsh, iTerm2 -->
- 컨테이너 런타임: OrbStack `[버전]` (Docker 엔진 내장, sudo 불필요)
- Docker: `[docker --version 출력 붙여넣기]`
- Git: `[git --version 출력 붙여넣기]`

## 3) 수행 항목 체크리스트

- [ ] 터미널 기본 조작 (이동/생성/복사/이름변경/삭제/내용확인)
- [ ] 파일/디렉토리 권한 변경 실습 (각 1개 이상)
- [ ] Docker 설치 확인 (`docker --version`, `docker info`)
- [ ] `hello-world` 컨테이너 실행
- [ ] `ubuntu` 컨테이너 진입 후 명령 실행 (`ls`, `echo`)
- [ ] Dockerfile 기반 커스텀 이미지 빌드 및 실행
- [ ] 포트 매핑 후 브라우저 접속 확인
- [ ] 바인드 마운트로 변경사항 즉시 반영 확인
- [ ] Docker 볼륨으로 데이터 영속성 확인 (컨테이너 삭제 전/후)
- [ ] Git 사용자 정보 설정 + GitHub/VSCode 연동
- [ ] (보너스) Docker Compose로 실행

## 4) 검증 방법 & 결과 위치

| 항목 | 확인한 명령 | 증거 위치 |
|---|---|---|
| Docker 버전/데몬 | `docker --version`, `docker info` | 3-1) 섹션 |
| 이미지/컨테이너 목록 | `docker images`, `docker ps -a` | 3-2) 섹션 |
| 로그/리소스 | `docker logs`, `docker stats` | 3-2) 섹션 |
| 커스텀 이미지 빌드 | `docker build -t my-nginx-app:1.0 .` | 4-1) 섹션 |
| 포트 매핑 | `docker run -p 8080:5000 ...` + 브라우저 접속 | 4-2) 섹션 |
| 바인드 마운트 | `-v $(pwd)/site:/usr/share/nginx/html` + 수정 전/후 비교 | 4-3) 섹션 |
| 볼륨 영속성 | `docker volume create` + 컨테이너 삭제 전/후 접속 로그 비교 | 4-4) 섹션 |
| Git/GitHub | `git config --list` + VSCode 연동 스크린샷 | 5) 섹션 |

---

## 3-1) 터미널 조작 로그

### 작업 디렉토리 구성

```bash
$ pwd
[여기에 붙여넣기]

$ mkdir -p ~/dev-workstation-mission
$ cd ~/dev-workstation-mission
$ ls -la
[여기에 붙여넣기]
```

### 기본 조작 (이동/생성/복사/이름변경/삭제/내용확인)

```bash
$ touch notes.txt
$ echo "practice" > notes.txt
$ cat notes.txt
[여기에 붙여넣기]

$ cp notes.txt notes_copy.txt
$ mv notes_copy.txt renamed.txt
$ ls -la
[여기에 붙여넣기]

$ rm renamed.txt
$ ls -la
[여기에 붙여넣기]
```

> 절대 경로 vs 상대 경로: <!-- TODO: 예) `/Users/jungyo/dev-workstation-mission`(절대) vs `./notes.txt`(상대) 로 실습 결과와 함께 한 줄 설명 -->

### 권한 실습 (파일 1개, 디렉토리 1개)

```bash
$ ls -l notes.txt
[변경 전 붙여넣기]

$ chmod 644 notes.txt
$ ls -l notes.txt
[변경 후 붙여넣기]

$ mkdir secure_dir
$ ls -ld secure_dir
[변경 전 붙여넣기]

$ chmod 755 secure_dir
$ ls -ld secure_dir
[변경 후 붙여넣기]
```

> 권한 표기(r/w/x, 755/644) 설명: <!-- TODO: 예) 755 = 소유자 rwx(7), 그룹 r-x(5), 기타 r-x(5) -->

---

## 3-2) Docker 설치/점검 및 기본 운영 로그

```bash
$ docker --version
[여기에 붙여넣기]

$ docker info
[여기에 붙여넣기 (핵심 몇 줄만 발췌 가능)]
```

### hello-world

```bash
$ docker run hello-world
[여기에 붙여넣기]
```

### ubuntu 컨테이너 진입

```bash
$ docker run -it --name ubuntu-practice ubuntu bash
root@...:/# ls
[여기에 붙여넣기]
root@...:/# echo "hello from container"
[여기에 붙여넣기]
root@...:/# exit
```

> attach/exec 차이 관찰: <!-- TODO: 컨테이너를 백그라운드로 실행한 뒤 `docker exec -it <name> bash`로 다시 들어가 보고, `docker attach`와 비교해서 느낀 점 한두 줄 -->

### 이미지/컨테이너/로그/리소스 확인

```bash
$ docker images
[여기에 붙여넣기]

$ docker ps -a
[여기에 붙여넣기]

$ docker logs ubuntu-practice
[여기에 붙여넣기]

$ docker stats --no-stream
[여기에 붙여넣기]
```

---

## 4) Dockerfile 기반 커스텀 이미지

- 선택한 방식: **(A) 웹 서버 베이스 이미지(nginx:alpine) + 정적 콘텐츠/설정 교체**
- 적용한 커스텀 포인트:
  1. `site/` 정적 콘텐츠로 기본 nginx 웰컴 페이지 교체
  2. `default.conf.template`로 nginx 설정 교체 → 커스텀 응답 헤더(`X-App-Env`) 추가
  3. 환경 변수 `APP_ENV` 도입 → 공식 nginx 이미지의 템플릿 렌더링(envsubst) 기능으로 재빌드 없이 `-e`만 바꿔도 응답이 달라짐 (설정과 코드 분리, 보너스 항목도 겸함)
  4. `HEALTHCHECK` 추가 → `docker ps`/`docker inspect`로 컨테이너 상태(healthy) 확인 가능

Dockerfile 전문은 `Dockerfile`, `default.conf.template` 파일 참고.

### 4-1) 빌드 및 실행

```bash
$ docker build -t my-nginx-app:1.0 .
[여기에 붙여넣기 (마지막 성공 로그 포함)]

$ docker run -d -p 8080:80 -e APP_ENV=production --name web1 my-nginx-app:1.0
[컨테이너 ID 붙여넣기]

$ docker ps
[여기에 붙여넣기 - STATUS 에 healthy 표시 확인]
```

### 4-2) 포트 매핑 접속 증거 (+ 환경변수로 응답 달라지는 것 확인)

```bash
$ curl -I http://localhost:8080
[여기에 붙여넣기 - X-App-Env: production 헤더 확인]

$ docker rm -f web1
$ docker run -d -p 8080:80 -e APP_ENV=development --name web2 my-nginx-app:1.0
$ curl -I http://localhost:8080
[여기에 붙여넣기 - 재빌드 없이 X-App-Env: development 로 바뀐 것 확인]
```

<!-- TODO: 브라우저 주소창(localhost:8080 포함)과 페이지가 함께 보이는 스크린샷 첨부 -->
`![port-mapping](./evidence/port-mapping.png)`

### 4-3) 바인드 마운트 반영 확인

```bash
$ docker rm -f web2
$ docker run -d -p 8080:80 -v $(pwd)/site:/usr/share/nginx/html --name web-bind my-nginx-app:1.0
```

1. `http://localhost:8080` 접속 → 기존 문구 확인 (변경 전 스크린샷)
2. 호스트에서 `site/index.html` 텍스트 일부 수정 후 저장
3. 브라우저 새로고침(재빌드 없음) → 변경된 문구 확인 (변경 후 스크린샷)

<!-- TODO: 변경 전/후 스크린샷 2장 첨부 -->
`![bind-mount-before](./evidence/bind-before.png)`
`![bind-mount-after](./evidence/bind-after.png)`

### 4-4) 볼륨 영속성 확인 (접속 로그로 검증)

```bash
$ docker rm -f web-bind
$ docker volume create nginx-logs

$ docker run -d -p 8080:80 -v nginx-logs:/var/log/nginx --name web-vol my-nginx-app:1.0
$ curl http://localhost:8080   # 몇 번 반복 요청
$ docker exec web-vol cat /var/log/nginx/access.log
[여기에 붙여넣기 - 요청 기록 확인]

$ docker rm -f web-vol   # 컨테이너 삭제 (볼륨은 남음)

$ docker run -d -p 8080:80 -v nginx-logs:/var/log/nginx --name web-vol2 my-nginx-app:1.0
$ docker exec web-vol2 cat /var/log/nginx/access.log
[여기에 붙여넣기 - 컨테이너를 새로 만들었는데도 이전 로그가 남아있는지 확인]
```

---

## 5) Git 설정 및 GitHub/VSCode 연동

```bash
$ git config --global user.name "본인 이름"
$ git config --global user.email "본인 이메일"
$ git config --global init.defaultBranch main
$ git config --list
[여기에 붙여넣기 (민감정보 없는지 재확인)]

$ git init
$ git add .
$ git commit -m "feat: dev workstation mission scaffold"
$ git branch -M main
$ git remote add origin <저장소 URL>
$ git push -u origin main
```

<!-- TODO: VSCode에서 GitHub 로그인 후 이 저장소가 연동된 화면 스크린샷 첨부 -->
`![vscode-github](./evidence/vscode-github.png)`

---

## 6) 트러블슈팅

### 사례 1
- 문제: <!-- TODO -->
- 원인 가설: <!-- TODO -->
- 확인 방법: <!-- TODO -->
- 해결/대안: <!-- TODO -->

### 사례 2
- 문제: <!-- TODO -->
- 원인 가설: <!-- TODO -->
- 확인 방법: <!-- TODO -->
- 해결/대안: <!-- TODO -->

> 참고로 자주 발생하는 이슈 예시:
> - OrbStack 설치 직후 `docker: command not found` → OrbStack 앱을 한 번 실행해야 CLI가 PATH에 등록됨, 터미널 재시작 필요
> - `docker run -p 8080:5000` 반복 실행 시 `port is already allocated` → 기존 컨테이너를 `docker rm -f`로 정리하거나 다른 호스트 포트 사용
> - 바인드 마운트한 파일이 반영 안 됨 → 상대 경로 대신 `$(pwd)` 절대 경로로 마운트했는지, OrbStack의 파일 공유 설정을 확인

---

## 7) (보너스) Docker Compose

```bash
$ docker compose up -d
[여기에 붙여넣기]

$ docker compose ps
[여기에 붙여넣기]

$ docker compose logs
[여기에 붙여넣기]

$ docker compose down
[여기에 붙여넣기]
```

---

## 8) 핵심 개념 정리 (과제 목표 3번 대응)

- **절대경로 vs 상대경로**: <!-- TODO -->
- **파일 권한(r/w/x, 755/644)**: <!-- TODO -->
- **커스텀 이미지란**: <!-- TODO -->
- **포트 매핑이 필요한 이유**: <!-- TODO -->
- **Docker 볼륨(영속 데이터)**: <!-- TODO -->
- **Git vs GitHub 역할 차이**: <!-- TODO -->
