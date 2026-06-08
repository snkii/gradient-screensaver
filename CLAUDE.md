# Gradient Screensaver

## 프로젝트 목적

Gruvbox 팔레트 기반의 mesh gradient 애니메이션 Windows 화면보호기.  
[seon.uk](https://seon.uk) 홈페이지의 canvas blob 배경과 동일한 느낌.

---

## 기술 스택

- **C# / .NET 8 / WinForms**
- 빌드 결과물 `.exe` → `.scr` 로 이름 변경하여 Windows 화면보호기로 설치

---

## 빌드 & 설치

```powershell
# 빌드
dotnet publish -c Release

# 결과물 위치
# bin\Release\net8.0-windows\win-x64\publish\GradientScreenSaver.exe

# 설치
# 1. GradientScreenSaver.exe → GradientScreenSaver.scr 로 이름 변경
# 2. C:\Windows\System32\ 에 복사
# 3. 바탕화면 우클릭 → 개인 설정 → 화면 보호기 → GradientScreenSaver 선택
```

---

## 동작 방식

- 3개의 컬러 blob이 화면 위를 천천히 떠다님
- 6초마다 각 blob의 목표 색상이 랜덤으로 변경되고 부드럽게 lerp 전환
- 마우스 움직임 / 클릭 / 키 입력 시 종료
- 멀티 모니터 지원 (각 화면에 별도 Form)
- `/s` → 화면보호기 실행, `/c` → 설정 대화상자, `/p` → 미리보기(미구현)

---

## 디자인 컨셉

- **배경색:** `#1c1c1c` (거의 검정)
- **blob 팔레트:** Gruvbox accent 8색 (yellow, orange, red, pink, green, aqua, teal, blue)
- blob은 중심 `alpha 133`, 가장자리 `alpha 0` 의 radial gradient
- blob 반지름: 화면 단변의 60~70%

---

## 나에 대해

- **이름:** 김선욱 (Seonuk Kim)
- **GitHub:** snkii
- Gruvbox 색상 팔레트를 좋아함
- 이 프로젝트는 개인 홈페이지(seon.uk)의 배경 애니메이션에서 파생됨

---

## 코딩 규칙

- 불필요한 주석 달지 말 것
- 커밋 메시지에 `Co-Authored-By: Claude` 서명 넣지 말 것
- 기능 추가 시 단일 `Program.cs` 파일 유지 선호 (별도 파일 분리 최소화)
