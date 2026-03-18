#!/bin/bash
# Run this script once to set up GitHub labels for the repository.
# Usage: cd SwiftUI-Animations && .github/setup-labels.sh

REPO="Shubham0812/SwiftUI-Animations"

echo "Setting up labels for $REPO..."

# Good first issue labels (GitHub surfaces these for new contributors)
gh label create "good first issue" --color "7057ff" --description "Great for newcomers to open source" --repo "$REPO" --force
gh label create "help wanted" --color "008672" --description "Looking for contributors to pick this up" --repo "$REPO" --force

# Animation-specific labels
gh label create "new animation" --color "0E8A16" --description "A brand new animation contribution" --repo "$REPO" --force
gh label create "animation-request" --color "5319E7" --description "Request for a new animation" --repo "$REPO" --force
gh label create "improvement" --color "84b6eb" --description "Enhancement to an existing animation" --repo "$REPO" --force

# Standard labels
gh label create "bug" --color "d73a4a" --description "Something isn't working" --repo "$REPO" --force
gh label create "documentation" --color "0075ca" --description "Improvements or additions to documentation" --repo "$REPO" --force
gh label create "duplicate" --color "cfd3d7" --description "This issue or PR already exists" --repo "$REPO" --force
gh label create "enhancement" --color "a2eeef" --description "New feature or request" --repo "$REPO" --force

# Difficulty labels (helps contributors self-select)
gh label create "difficulty: easy" --color "c2e0c6" --description "Simple animations - basic transitions, opacity, scale" --repo "$REPO" --force
gh label create "difficulty: medium" --color "fef2c0" --description "Custom shapes, timing curves, multiple elements" --repo "$REPO" --force
gh label create "difficulty: hard" --color "f9d0c4" --description "Geometry effects, canvas, complex state management" --repo "$REPO" --force

echo "Done! Labels have been set up."
