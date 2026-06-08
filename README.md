# Seonuk Gradient

**[English](#seonuk-gradient) · [한국어](#한국어)**

**Static mesh gradient for your desktop — Windows screensaver, Windows wallpaper & macOS wallpaper.**

Soft organic color blobs are generated as still scenes on a dark background. Inspired by the background on [seon.uk](https://seon.uk).

---

![preview](https://raw.githubusercontent.com/snkii/seonuk-gradient/main/preview.gif)

---

## Platforms

| Platform | Format | Tech |
|----------|--------|------|
| 🪟 Windows | `.scr` screensaver | C# · .NET 8 · WinForms |
| 🪟 Windows | Static wallpaper | C# · .NET 8 · WinForms · WorkerW |
| 🪟 Windows | Theme template | `.theme` |
| 🍎 macOS | Wallpaper | Swift · AppKit |

---

## Features

- **3 organic color blobs** with randomized position, size, stretch, rotation, and color
- **Static scenes** — generated once on start, manually, or by a low-power timer where supported
- **Gruvbox-inspired palette** — 10 handpicked accent colors
- **Vintage film grain texture** — subtle fine/coarse grain plus warm tone overlay to soften 4K banding
- **Favorite scenes** on macOS — save a scene you like and load it later
- **Static mesh lock screen background** on macOS by syncing a generated wallpaper image
- **Shared multi-display scene** on macOS — every connected display uses the same generated scene
- Zero dependencies beyond the platform SDK

---

## Install

### 🪟 Windows — Screensaver

**[⬇ Download GradientScreenSaver-Windows-x64.zip](https://github.com/snkii/seonuk-gradient/releases/latest/download/GradientScreenSaver-Windows-x64.zip)**

> Requires [.NET 8 SDK](https://dotnet.microsoft.com/download)

```powershell
git clone https://github.com/snkii/seonuk-gradient
cd seonuk-gradient
dotnet publish -c Release
```

1. Go to `bin\Release\net8.0-windows\win-x64\publish\`
2. Rename `GradientScreenSaver.exe` → `GradientScreenSaver.scr`
3. Copy to `C:\Windows\System32\`
4. Right-click desktop → Personalize → Screen Saver → **GradientScreenSaver**

Optional: after copying the `.scr`, double-click `windows-theme\SeonukGradient.theme` to apply the matching Windows theme template.

---

### 🪟 Windows — Static Wallpaper

**[⬇ Download GradientWallpaper-Windows-x64.zip](https://github.com/snkii/seonuk-gradient/releases/latest/download/GradientWallpaper-Windows-x64.zip)**

```powershell
git clone https://github.com/snkii/seonuk-gradient
cd seonuk-gradient\wallpaper-win
dotnet publish -c Release
```

Run `bin\Release\net8.0-windows\win-x64\publish\GradientWallpaper.exe`. A tray icon lets you generate a new still scene or quit.

The Windows theme template can select the screensaver and colors, but the static wallpaper app still runs separately.

---

### 🍎 macOS — Wallpaper

**[⬇ Download GradientWallpaper-macOS.zip](https://github.com/snkii/seonuk-gradient/releases/latest/download/GradientWallpaper-macOS.zip)**

1. Unzip and open `GradientWallpaper.app`
2. A ✦ icon appears in the menu bar
3. First launch: macOS may block it — right-click → Open to bypass Gatekeeper

To auto-start at login: **System Settings → General → Login Items → + → GradientWallpaper**

<details>
<summary>Build from source</summary>

```bash
git clone https://github.com/snkii/seonuk-gradient
cd seonuk-gradient/wallpaper
make install        # install to /Applications
make install-login  # also auto-start at login
```
</details>

A ✦ icon in the menu bar lets you switch between low-power random still modes that refresh every 1/3/5/10 minutes, pause automatic refreshes, save favorite scenes, or load saved scenes. The default is Random Still - 10 Minutes. Loading a saved scene switches to Paused so it stays put. The lock screen wallpaper is refreshed from the same scene shown on the desktop. You can also generate a new random scene or quit from the menu. No Dock icon.

---

## Color Palette

The gradient uses 10 Gruvbox accent colors:

<table>
<tr>
  <td align="center"><img src="https://singlecolorimage.com/get/fabd2f/40x40" width="40" height="40"><br><code>#fabd2f</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/d79921/40x40" width="40" height="40"><br><code>#d79921</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/fe8019/40x40" width="40" height="40"><br><code>#fe8019</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/fb4934/40x40" width="40" height="40"><br><code>#fb4934</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/b8bb26/40x40" width="40" height="40"><br><code>#b8bb26</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/8ec07c/40x40" width="40" height="40"><br><code>#8ec07c</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/83a598/40x40" width="40" height="40"><br><code>#83a598</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/458588/40x40" width="40" height="40"><br><code>#458588</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/d3869b/40x40" width="40" height="40"><br><code>#d3869b</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/928374/40x40" width="40" height="40"><br><code>#928374</code></td>
</tr>
</table>

---

## Website

The same visual language appears in the background of **[seon.uk](https://seon.uk)**.

---

## License

MIT. See [LICENSE](LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

---
---

# 한국어

**[English](#seonuk-gradient) · [한국어](#한국어)**

**데스크탑을 위한 정적 메시 그래디언트 — Windows 화면보호기, Windows 배경화면 & macOS 배경화면.**

부드러운 유기적 색상 블롭을 어두운 배경 위의 정적 scene으로 생성합니다. [seon.uk](https://seon.uk) 배경화면에서 영감을 받았습니다.

---

## 지원 플랫폼

| 플랫폼 | 형식 | 기술 |
|--------|------|------|
| 🪟 Windows | `.scr` 화면보호기 | C# · .NET 8 · WinForms |
| 🪟 Windows | 정적 배경화면 | C# · .NET 8 · WinForms · WorkerW |
| 🪟 Windows | 테마 템플릿 | `.theme` |
| 🍎 macOS | 배경화면 | Swift · AppKit |

---

## 특징

- **3개의 유기적 색상 블롭**이 위치, 크기, 비율, 회전, 색상을 랜덤으로 가짐
- **정적 scene** — 시작 시, 수동 생성 시, 또는 지원되는 저전력 타이머로 생성
- **Gruvbox 팔레트** — 10가지 엑센트 컬러
- **빈티지 필름 그레인 질감** — 4K banding을 줄이기 위한 fine/coarse grain + 따뜻한 tone overlay
- **macOS favorite scenes** — 마음에 드는 scene 저장 및 나중에 불러오기
- **macOS 잠금화면 정적 mesh 배경** — 생성된 wallpaper 이미지를 시스템 배경으로 동기화
- **macOS 멀티 디스플레이 공유 scene** — 연결된 모든 디스플레이가 같은 생성 scene 사용
- 플랫폼 SDK 외 별도 의존성 없음

---

## 설치

### 🪟 Windows — 화면보호기

**[⬇ GradientScreenSaver-Windows-x64.zip 다운로드](https://github.com/snkii/seonuk-gradient/releases/latest/download/GradientScreenSaver-Windows-x64.zip)**

> [.NET 8 SDK](https://dotnet.microsoft.com/download) 필요

```powershell
git clone https://github.com/snkii/seonuk-gradient
cd seonuk-gradient
dotnet publish -c Release
```

1. `bin\Release\net8.0-windows\win-x64\publish\` 폴더로 이동
2. `GradientScreenSaver.exe` → `GradientScreenSaver.scr` 로 이름 변경
3. `C:\Windows\System32\` 에 복사
4. 바탕화면 우클릭 → 개인 설정 → 화면 보호기 → **GradientScreenSaver** 선택

선택 사항: `.scr`를 복사한 뒤 `windows-theme\SeonukGradient.theme`을 더블클릭하면 맞춰 둔 Windows 테마 템플릿을 적용할 수 있습니다.

---

### 🪟 Windows — 정적 배경화면

**[⬇ GradientWallpaper-Windows-x64.zip 다운로드](https://github.com/snkii/seonuk-gradient/releases/latest/download/GradientWallpaper-Windows-x64.zip)**

```powershell
git clone https://github.com/snkii/seonuk-gradient
cd seonuk-gradient\wallpaper-win
dotnet publish -c Release
```

`bin\Release\net8.0-windows\win-x64\publish\GradientWallpaper.exe`를 실행하세요. 트레이 아이콘에서 새 정적 scene을 만들거나 종료할 수 있습니다.

Windows 테마 템플릿은 화면보호기와 색상 설정을 지정할 수 있지만, 정적 배경화면 앱은 별도로 실행됩니다.

---

### 🍎 macOS — 배경화면

**[⬇ GradientWallpaper-macOS.zip 다운로드](https://github.com/snkii/seonuk-gradient/releases/latest/download/GradientWallpaper-macOS.zip)**

1. 압축 해제 후 `GradientWallpaper.app` 실행
2. 메뉴바에 ✦ 아이콘이 나타남
3. 첫 실행 시 Gatekeeper 차단 → 우클릭 → 열기로 우회

로그인 시 자동 실행: **시스템 설정 → 일반 → 로그인 항목 → + → GradientWallpaper**

<details>
<summary>소스에서 빌드</summary>

```bash
git clone https://github.com/snkii/seonuk-gradient
cd seonuk-gradient/wallpaper
make install        # /Applications 에 설치
make install-login  # 로그인 항목에도 자동 등록
```
</details>

메뉴바의 ✦ 아이콘에서 1/3/5/10분 간격 저전력 랜덤 정지 화면 모드, 자동 갱신 일시정지, 마음에 드는 scene 저장, 저장한 scene 불러오기를 할 수 있습니다. 기본값은 Random Still - 10 Minutes입니다. 저장한 scene을 불러오면 그대로 유지되도록 Paused로 전환됩니다. 잠금화면 배경은 데스크톱에 보이는 같은 장면으로 갱신됩니다. 즉시 새 랜덤 장면을 만들거나 종료할 수도 있고, Dock 아이콘은 없습니다.

---

## 색상 팔레트

Gruvbox 팔레트의 10가지 엑센트 컬러:

<table>
<tr>
  <td align="center"><img src="https://singlecolorimage.com/get/fabd2f/40x40" width="40" height="40"><br><code>#fabd2f</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/d79921/40x40" width="40" height="40"><br><code>#d79921</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/fe8019/40x40" width="40" height="40"><br><code>#fe8019</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/fb4934/40x40" width="40" height="40"><br><code>#fb4934</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/b8bb26/40x40" width="40" height="40"><br><code>#b8bb26</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/8ec07c/40x40" width="40" height="40"><br><code>#8ec07c</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/83a598/40x40" width="40" height="40"><br><code>#83a598</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/458588/40x40" width="40" height="40"><br><code>#458588</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/d3869b/40x40" width="40" height="40"><br><code>#d3869b</code></td>
  <td align="center"><img src="https://singlecolorimage.com/get/928374/40x40" width="40" height="40"><br><code>#928374</code></td>
</tr>
</table>

---

## 웹사이트

같은 시각 언어가 **[seon.uk](https://seon.uk)** 배경에 쓰이고 있습니다.

---

## 라이선스

MIT. [LICENSE](LICENSE)와 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)를 참고하세요.
