<div align="center">

# SwiftUI Animations

**A growing collection of polished SwiftUI animations, ready to drop into your iOS apps.**

![Swift](https://img.shields.io/badge/Swift-5.0+-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=for-the-badge&logo=swift&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-lightgrey?style=for-the-badge&logo=apple&logoColor=white)
![License](https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge)
[![Build](https://github.com/Shubham0812/SwiftUI-Animations/actions/workflows/build.yml/badge.svg)](https://github.com/Shubham0812/SwiftUI-Animations/actions/workflows/build.yml)

[![GitHub stars](https://img.shields.io/github/stars/shubham0812/SwiftUI-Animations?style=social)](https://github.com/Shubham0812/SwiftUI-Animations/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/shubham0812/SwiftUI-Animations?style=social)](https://github.com/Shubham0812/SwiftUI-Animations/network/members)
[![GitHub followers](https://img.shields.io/github/followers/shubham0812?style=social)](https://github.com/Shubham0812)

</div>

---

## Overview

This repository contains **20+ custom SwiftUI animations** and **Metal shaders** — from loaders and toggles to interactive UI components and GPU-powered visual effects — all built entirely with SwiftUI. Each animation lives in its own self-contained folder with all the source code you need to integrate it into your project.

## Table of Contents

- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Animations Gallery](#animations-gallery)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Contributing](#contributing)
- [Contributors](#contributors)
- [Author](#author)
- [License](#license)

## Requirements

| Dependency | Version |
|------------|---------|
| iOS        | 17.0+   |
| Xcode      | 16.0+   |
| Swift      | 5.0+    |

## Getting Started

```bash
# Clone the repository
git clone https://github.com/Shubham0812/SwiftUI-Animations.git

# Open in Xcode
cd SwiftUI-Animations
open SwiftUI-Animations.xcodeproj
```

Select a simulator and hit **Run** — each animation is accessible from the home screen.

## Animations Gallery

<table>
<tr>
<td width="33%" align="center">

**Add to Cart**

<img src="SwiftUI-Animations/GIFs/cart.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/Cart)

</td>
<td width="33%" align="center">

**Chat Bar**

<img src="SwiftUI-Animations/GIFs/chat-bar.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/ChatBar)

</td>
<td width="33%" align="center">

**Wi-Fi Signal**

<img src="SwiftUI-Animations/GIFs/wifi.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/Wifi)

</td>
</tr>
<tr>
<td align="center">

**Loader**

<img src="SwiftUI-Animations/GIFs/loader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/Loader)

</td>
<td align="center">

**Add Item**

<img src="SwiftUI-Animations/GIFs/addView.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/AddView)

</td>
<td align="center">

**Circle Loader**

<img src="SwiftUI-Animations/GIFs/circle-loader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/CircleLoader)

</td>
</tr>
<tr>
<td align="center">

**Pill Loader**

<img src="SwiftUI-Animations/GIFs/pill-loader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/PillLoader)

</td>
<td align="center">

**Like Button**

<img src="SwiftUI-Animations/GIFs/likeVIew.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/Like)

</td>
<td align="center">

**Submit Button**

<img src="SwiftUI-Animations/GIFs/submit-button.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/SubmitView)

</td>
</tr>
<tr>
<td align="center">

**GitHub Octocat Loader**

<img src="SwiftUI-Animations/GIFs/github-loader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/GithubLoader)

</td>
<td align="center">

**3D Rotating Loader**

<img src="SwiftUI-Animations/GIFs/3-d-Loader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/3dLoader)

</td>
<td align="center">

**Animated Login**

<img src="SwiftUI-Animations/GIFs/login.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/LoginView)

</td>
</tr>
<tr>
<td align="center">

**Book Loader**

<img src="SwiftUI-Animations/GIFs/book-loader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/BookLoader)

</td>
<td align="center">

**Card Viewer**

<img src="SwiftUI-Animations/GIFs/cards.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/Bank%20Card)

</td>
<td align="center">

**Infinity Loader**

<img src="SwiftUI-Animations/GIFs/infinity.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/InfinityLoader)

</td>
</tr>
<tr>
<td align="center">

**Light Switch**

<img src="SwiftUI-Animations/GIFs/lightswitch.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/LightSwitch)

</td>
<td align="center">

**Spinning Loader**

<img src="SwiftUI-Animations/GIFs/spinningloader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/SpinningLoader)

</td>
<td align="center">

**Download Button**

<img src="SwiftUI-Animations/GIFs/downloadButton.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/DownloadButton)

</td>
</tr>
<tr>
<td align="center">

**Triangle Loader**

<img src="SwiftUI-Animations/GIFs/triLoader.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/TriangleLoader)

</td>
<td align="center">

**Octocat Wink**

<img src="SwiftUI-Animations/GIFs/octocat-wink.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Common/Animations/Octocat-Wink)

</td>
<td align="center">

**Yin-Yang Toggle**

[View Code](SwiftUI-Animations/Code/Common/Animations/YinYang-Toggle)

</td>
</tr>
</table>

## Project Structure

```
SwiftUI-Animations/
├── Code/
│   ├── Common/
│   │   ├── Animations/           # Each animation in its own folder
│   │   │   ├── 3dLoader/
│   │   │   ├── AddView/
│   │   │   ├── Bank Card/
│   │   │   ├── BookLoader/
│   │   │   ├── Cart/
│   │   │   ├── ChatBar/
│   │   │   ├── CircleLoader/
│   │   │   ├── DownloadButton/
│   │   │   ├── GithubLoader/
│   │   │   ├── InfinityLoader/
│   │   │   ├── LightSwitch/
│   │   │   ├── Like/
│   │   │   ├── Loader/
│   │   │   ├── Loader2/
│   │   │   ├── LoginView/
│   │   │   ├── Octocat-Wink/
│   │   │   ├── PillLoader/
│   │   │   ├── SpinningLoader/
│   │   │   ├── SubmitView/
│   │   │   ├── TriangleLoader/
│   │   │   ├── Wifi/
│   │   │   └── YinYang-Toggle/
│   │   └── Shaders/              # Metal shader effects
│   │       └── Burn/             # Burn transition effect (.metal + .swift)
│   ├── Features/
│   │   ├── App/                  # Root app views & coordinator
│   │   ├── Home/                 # Home screen, animation cards
│   │   ├── Shaders/              # Shader showcase views
│   │   └── Support Views/        # Shared feature UI components
│   ├── Navigation/               # Router & navigation logic
│   ├── Services/                 # Haptic feedback manager
│   └── Utils/                    # Colors, fonts & helpers
├── Assets/
│   └── Fonts/                    # ClashGrotesk custom font family
├── GIFs/                         # Animation preview GIFs
└── SwiftUI-Animations.xcodeproj
```

## How to Run

1. **Clone & open**
   ```bash
   git clone https://github.com/Shubham0812/SwiftUI-Animations.git
   cd SwiftUI-Animations
   open SwiftUI-Animations.xcodeproj
   ```

2. **Select a target** — choose any iOS simulator (iPhone 14 or later recommended) from the device picker in the Xcode toolbar.

3. **Build & run** — press <kbd>⌘ R</kbd> or click the **Run** button. The app launches on the home screen listing all available animations.

4. **Browse an animation** — tap any card to open it full-screen and interact with it directly.

5. **Jump to the source** — each animation lives in its own self-contained folder under `Code/Common/Animations/`. Shader effects are under `Code/Common/Shaders/`. Open any folder in Xcode's Project Navigator to read or copy the code.

> **Tip:** Every view file includes a `PreviewProvider` / `#Preview`, so you can also run individual animations directly in Xcode Previews without launching the full app — just open the file and press <kbd>⌘ ⌥ P</kbd>.

## Contributing

Contributions are welcome! Whether it's a new animation, a bug fix, or an improvement to an existing one, feel free to open a pull request.

Please read the **[Contributing Guide](CONTRIBUTING.md)** for detailed instructions on how to get started, code style guidelines, and the pull request process.

| Resource | Description |
|----------|-------------|
| [Contributing Guide](CONTRIBUTING.md) | How to contribute, code style, PR process |
| [Code of Conduct](CODE_OF_CONDUCT.md) | Community standards and expectations |
| [Security Policy](SECURITY.md) | How to report vulnerabilities |
| [Changelog](CHANGELOG.md) | History of changes and new animations |

## Contributors

Thanks to everyone who has helped make this project better!

<a href="https://github.com/Shubham0812/SwiftUI-Animations/graphs/contributors">

| Avatar | Name | GitHub |
|--------|------|--------|
| <img src="https://github.com/Shubham0812.png" width="50" style="border-radius:50%"/> | Shubham Kumar Singh | [@Shubham0812](https://github.com/Shubham0812) |

</a>

Want to see your name here? Check out the **[Contributing Guide](CONTRIBUTING.md)** and the full **[Contributors List](CONTRIBUTORS.md)**.

---

<div align="center">

## Author

<img src="https://github.com/Shubham0812.png" width="100" style="border-radius:50%"/>

**Shubham Kumar Singh**
<br/>
iOS Developer | SwiftUI / UIKit  | Indie Developer | Open Source Contributor

[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/shubham_iosdev/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shubham0812/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Shubham0812)

---

## License

This project is licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE.md) file for details.

You are free to use, modify, and distribute this project in your own apps — commercial or personal.

---

### Support This Project

If you found this project helpful or learned something from the source code, please consider:

**[Give it a Star](https://github.com/Shubham0812/SwiftUI-Animations)** — It helps others discover the project!

[![GitHub stars](https://img.shields.io/github/stars/shubham0812/SwiftUI-Animations?style=for-the-badge&logo=github&label=Star%20this%20repo)](https://github.com/Shubham0812/SwiftUI-Animations/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/shubham0812/SwiftUI-Animations?style=for-the-badge&logo=github&label=Fork%20it)](https://github.com/Shubham0812/SwiftUI-Animations/network/members)

**Share it with your friends and colleagues** — Let's grow the SwiftUI community together!

[![Share on X](https://img.shields.io/badge/Share%20on-X-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/intent/tweet?text=Check%20out%20this%20amazing%20collection%20of%20SwiftUI%20Animations!%20%F0%9F%9A%80&url=https://github.com/Shubham0812/SwiftUI-Animations)
[![Share on LinkedIn](https://img.shields.io/badge/Share%20on-LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/Shubham0812/SwiftUI-Animations)
[![Share on Reddit](https://img.shields.io/badge/Share%20on-Reddit-FF4500?style=for-the-badge&logo=reddit&logoColor=white)](https://www.reddit.com/submit?url=https://github.com/Shubham0812/SwiftUI-Animations&title=SwiftUI%20Animations%20-%20A%20collection%20of%2020%2B%20custom%20animations)

---

<sub>Made with SwiftUI and lots of creativity</sub>

</div>
