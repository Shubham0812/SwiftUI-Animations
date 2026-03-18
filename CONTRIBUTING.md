# Contributing to SwiftUI Animations

Thank you for your interest in contributing! This project thrives on community contributions — whether it's a brand-new animation, a bug fix, or an improvement to an existing one.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Adding a New Animation](#adding-a-new-animation)
- [Code Style Guidelines](#code-style-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Code of Conduct](#code-of-conduct)

## Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/<your-username>/SwiftUI-Animations.git
   cd SwiftUI-Animations
   ```
3. **Open** the project in Xcode:
   ```bash
   open SwiftUI-Animations.xcodeproj
   ```
4. **Create** a feature branch from `main`:
   ```bash
   git checkout -b feature/your-animation-name
   ```

## How to Contribute

### New Animations

New animations are the primary way to contribute. See [Adding a New Animation](#adding-a-new-animation) below for the full walkthrough.

### Bug Fixes

If you spot a bug in an existing animation (layout issues, crashes, deprecation warnings), feel free to open a PR with the fix.

### Improvements

Enhancements to existing animations — smoother curves, better performance, accessibility improvements — are always welcome.

### Documentation

Typo fixes, better code comments, or improved README entries all count as valuable contributions.

## Adding a New Animation

### 1. Create Your Animation Folder

Place your animation inside its own folder:

```
SwiftUI-Animations/Code/Animations/YourAnimationName/
├── YourAnimationView.swift       # Main animation view
├── Support Shapes/               # Custom shapes (if needed)
│   └── CustomShape.swift
└── ...                           # Any additional supporting files
```

### 2. Build the Animation

- **Use SwiftUI-native approaches** — avoid UIKit bridges (`UIViewRepresentable`) where possible.
- **Keep it self-contained** — all code for your animation should live within its folder. Shared utilities in `Utils/` may be used but should not be modified without good reason.
- **Target iOS 14+** — ensure your animation compiles and runs on iOS 14 and later.
- **Custom shapes** belong in a `Support Shapes/` subfolder within your animation directory.

### 3. Register in the Home Screen

Add a navigation entry for your animation in the home screen module so users can access it from the app.

### 4. Record a GIF Preview

- Record a screen capture of your animation running on a simulator.
- Convert it to a GIF (tools like [GIPHY Capture](https://giphy.com/apps/giphycapture) or `ffmpeg` work well).
- Save the GIF to `SwiftUI-Animations/GIFs/` with a descriptive filename (e.g., `your-animation.gif`).
- Keep GIF file sizes reasonable (under 5 MB).

### 5. Update the README

Add your animation to the **Animations Gallery** table in `README.md` following the existing format:

```markdown
<td align="center">

**Your Animation Name**

<img src="SwiftUI-Animations/GIFs/your-animation.gif" width="220"/>

[View Code](SwiftUI-Animations/Code/Animations/YourAnimationName)

</td>
```

## Code Style Guidelines

- Follow standard Swift naming conventions (camelCase for variables/functions, PascalCase for types).
- Use `@State`, `@Binding`, and other SwiftUI property wrappers appropriately.
- Prefer `struct` views over `class`-based approaches.
- Keep views small and composable — extract subviews when a view body grows large.
- Remove any unused imports, variables, or dead code before submitting.

## Commit Messages

Write clear, concise commit messages:

- Use the imperative mood: "Add spinning loader" not "Added spinning loader"
- Keep the subject line under 72 characters
- Reference issue numbers where applicable: "Fix layout bug in CartView (#42)"

Examples:
```
Add infinity loader animation
Fix pill loader alignment on smaller screens
Update README with new animation preview
```

## Pull Request Process

1. **Ensure your code compiles** without warnings on the latest stable Xcode.
2. **Test** your animation on at least one simulator (iPhone 14 or later recommended).
3. **Push** your branch and open a Pull Request against `main`.
4. **Fill in the PR description** — explain what the animation does and include a GIF or screenshot.
5. A maintainer will review your PR. Be responsive to feedback and make requested changes promptly.

### PR Checklist

- [ ] Animation is self-contained in its own folder under `Code/Animations/`
- [ ] Custom shapes are in a `Support Shapes/` subfolder (if applicable)
- [ ] GIF preview added to `GIFs/` folder
- [ ] README gallery table updated with new entry
- [ ] Code compiles without warnings on iOS 14+
- [ ] No UIKit bridges used (unless absolutely necessary)

## Reporting Issues

Found a bug or have a suggestion? [Open an issue](https://github.com/Shubham0812/SwiftUI-Animations/issues/new) with:

- A clear title and description
- Steps to reproduce (for bugs)
- Screenshots or GIFs if relevant
- Your Xcode and iOS version

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Be respectful and constructive — we are all here to learn and build great SwiftUI animations together.

---

Thank you for contributing! Your animations help the entire SwiftUI community learn and grow.
