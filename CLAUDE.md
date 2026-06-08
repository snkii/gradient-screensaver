# Seonuk Gradient

## 프로젝트 목적

Gruvbox 팔레트 기반의 정적 mesh gradient 배경화면/화면보호기.
[seon.uk](https://seon.uk) 홈페이지의 canvas blob 배경과 동일한 느낌.

---

## 파일 구조

```
seonuk-gradient/
├── Program.cs                       # Windows (.scr) — C# / .NET 8 / WinForms
├── GradientScreenSaver.csproj
├── wallpaper/
│   ├── GradientWallpaper.swift      # macOS 배경화면 — native NSView @ desktop window level
│   └── Makefile
├── wallpaper-win/
│   ├── Program.cs                   # Windows 배경화면 — WorkerW behind desktop icons
│   └── GradientWallpaper.csproj
├── windows-theme/
│   ├── SeonukGradient.theme          # Windows Personalization theme template
│   └── README.md
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

## macOS 배경화면 빌드 & 실행

```bash
cd wallpaper
make run          # 빌드 후 백그라운드 실행 (배경화면 즉시 적용)
make stop         # 종료
make install-login  # 로그인 시 자동 실행 등록
```

---

## 동작 방식

- 3개의 컬러 blob이 정적 scene으로 생성됨
- 각 blob은 실행/생성마다 시작 위치, 크기, 비율, 회전, 색상이 랜덤으로 결정됨
- Windows 화면보호기와 Windows 배경화면은 애니메이션 없이 정적 scene만 렌더링
- macOS 배경화면은 정적 mesh scene을 유지하고, 다른 앱 사용 중에는 랜덤 갱신 타이머를 멈춤
- macOS 배경화면 메뉴바 아이콘에서 Paused / Random Still 1·3·5·10분 모드 전환 가능
- macOS 배경화면 메뉴바에서 현재 scene 저장 및 저장한 scene 불러오기 가능. 불러오면 장면 유지를 위해 Paused로 전환
- 기본 모드는 Random Still 10분. 선택한 분 간격으로 새 랜덤 장면과 같은 장면의 잠금화면용 PNG만 재생성
- 메뉴바 헤더/체크 표시와 잠금화면 PNG는 현재 선택 모드 및 현재 desktop scene과 동기화
- macOS 배경화면 앱은 최신 scene을 `~/Library/Application Support/Seonuk Gradient/current_scene.json`에 저장
- 마우스 움직임 / 클릭 / 키 입력 시 종료
- Windows: 멀티 모니터 지원

---

## 디자인 컨셉

- **배경색:** `#282828`
- **blob 팔레트:** Gruvbox accent 10색
- blob은 CSS blur 기반 홈페이지 구현을 네이티브 radial mesh로 근사
- blob 크기: 화면 단변의 약 77~97%, blur는 단변의 22%
- 모든 렌더러는 홈페이지와 맞춘 film grain/tone pass를 마지막에 적용
- Windows GDI+ 렌더러와 macOS 렌더러는 같은 fine/coarse grain theme 값을 사용
- `windows-theme/SeonukGradient.theme`는 Windows Personalization에서 화면보호기/색상 테마를 지정하는 템플릿이며, WorkerW static wallpaper 앱은 별도 실행

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
- macOS: `wallpaper/GradientWallpaper.swift` 단일 앱 유지 선호
