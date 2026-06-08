# Seonuk Gradient

## 프로젝트 목적

Gruvbox 팔레트 기반의 mesh gradient 애니메이션 화면보호기.  
[seon.uk](https://seon.uk) 홈페이지의 canvas blob 배경과 동일한 느낌.

---

## 파일 구조

```
seonuk-gradient/
├── Program.cs                       # Windows (.scr) — C# / .NET 8 / WinForms
├── GradientScreenSaver.csproj
├── macos/
│   ├── GradientScreenSaver.swift    # macOS 화면보호기 (.saver) — Swift / ScreenSaverView
│   ├── Info.plist
│   └── Makefile
├── wallpaper/
│   ├── GradientWallpaper.swift      # macOS 배경화면 — native NSView @ desktop window level
│   └── Makefile
├── wallpaper-win/
│   ├── Program.cs                   # Windows 배경화면 — WorkerW behind desktop icons
│   └── GradientWallpaper.csproj
└── CLAUDE.md
```

---

## Windows 빌드 & 설치

```powershell
# 빌드
dotnet publish -c Release

# 결과물: bin\Release\net8.0-windows\win-x64\publish\GradientScreenSaver.exe
# 1. GradientScreenSaver.exe → GradientScreenSaver.scr 로 이름 변경
# 2. C:\Windows\System32\ 에 복사
# 3. 바탕화면 우클릭 → 개인 설정 → 화면 보호기 → GradientScreenSaver 선택
```

---

## macOS 빌드 & 설치

```bash
cd macos
make install
# System Settings → Screen Saver → GradientScreenSaver
```

---

## macOS 배경화면 빌드 & 실행

```bash
cd wallpaper
make run          # 빌드 후 백그라운드 실행 (배경화면 즉시 적용)
make stop         # 종료
make install-login  # 로그인 시 자동 실행 등록
```

---

## 동작 방식

- 3개의 컬러 blob이 화면 위를 천천히 떠다님
- 각 blob은 실행마다 시작 위치, 속도, 크기, 비율, 회전이 랜덤으로 결정됨
- 7초마다 각 blob의 목표 색상이 랜덤으로 변경, 6.5초 동안 부드럽게 전환
- macOS 라이브 배경화면은 다른 앱 사용 중 타이머를 멈추고, 잠금화면용 정적 mesh PNG를 시스템 wallpaper로 세팅
- 마우스 움직임 / 클릭 / 키 입력 시 종료
- Windows: 멀티 모니터 지원

---

## 디자인 컨셉

- **배경색:** `#282828`
- **blob 팔레트:** Gruvbox accent 10색
- blob은 CSS blur 기반 홈페이지 구현을 네이티브 radial mesh로 근사
- blob 크기: 화면 단변의 약 77~97%, blur는 단변의 22%

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
- Windows: 단일 `Program.cs` 유지 선호
- macOS: 단일 `GradientScreenSaver.swift` 유지 선호
