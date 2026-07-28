# =========================================================
# 커스텀 이미지 (옵션 A: 웹 서버 베이스 이미지 + 정적 콘텐츠/설정 교체)
# 베이스: nginx:alpine
# =========================================================
FROM nginx:alpine

LABEL org.opencontainers.image.title="dev-workstation-nginx"
LABEL org.opencontainers.image.description="입학연수 미션용 커스텀 Docker 이미지 (nginx 베이스)"

# 커스텀 포인트 1: 환경변수로 응답 헤더 값을 주입 (설정과 코드의 분리, 보너스: 환경변수 활용)
ENV APP_ENV=production

# 커스텀 포인트 2: 정적 콘텐츠 교체
COPY site/ /usr/share/nginx/html/

# 커스텀 포인트 3: nginx 설정 템플릿 교체
# 공식 nginx 이미지는 컨테이너 시작 시 /etc/nginx/templates/*.template 파일을
# envsubst로 렌더링해서 /etc/nginx/conf.d/ 에 만들어준다 (재빌드 없이 -e로 값만 바꿔도 반영됨)
COPY default.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 80

# 커스텀 포인트 4: 헬스체크
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -q --spider http://127.0.0.1/ || exit 1
