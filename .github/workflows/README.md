# Continuous Integration
'지속적인 통합 및 지속적인 배포'를 의미
git repository에는 코드 통합 전 코드의 동작여부를 테스트
'동작하는 코드'만이 올라가게 하는데에 목적

- 빌드 가능 여부
    - C++ 프로젝트 코드에 컴파일러 / 문법 오류는 없는지
    - 시스템 라이브러리 및 3rdParty 라이브러리와 함께 빌드가 될 수 있는지
- 손쉬운 소통이 가능한 코드인지
    - 코드의 포맷이 맞는지
- 코드의 안정성
    - 코드가 목적에 맞게 동작하는지
    - 코드에 메모리 누수가 없는지
- 알고리즘의 성능
    - 알고리즘이 목표했던 정확도를 달성하는지
    - 알고리즘이 목표했던 속도를 달성하는지


# CI 서버 가동
GitHub Actions에서 가동<br>
Self-hosted runner를 추가<br>
GitHub Actions와의 연결<br>

---
`clang-tools.yml`<br>
clang-format이라는 작업을 수행<br>
run-clang-format.py 스크립트를 이용해서 <br>
modules 폴더 내부에 있는 모든 C++ 파일들의 포맷을 교정

|||
|:---:|:---:|
|name|작업의 이름|
|on|작업 실행 조건|
|jobs|실제 수행 내용|
|workflow_dispatch|강제실행|
---

`init.yml`<br>
매일 특정 시각마다 3rdparty를 빌드하게 해주는 cron job 코드<br>
`base.dockerfile`을 이용해서 `slam:base_temp`라는 이미지를 생성 후,<br> 
성공하면 기존의 이미지를 삭제하고 새 이미지로 업데이트

3rdParty 라이브러리 변경 시 매일 CI가 그 라이브러리 변화를 추종 가능<br> 
빌드에 실패했을 경우 자동으로 dangling docker image 삭제

---
`build.yml`<br>
`build.dockerfile`을 이용해서 C++ 코드를 빌드
