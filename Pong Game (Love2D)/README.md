# Pong Game (Love2D)

**Student:** Ahmad Obaid  
**Course / Section:** AI & Games (Lua & Love2D)

---

## 🎮 Game Overview

A modern recreation of the classic Pong arcade game built with **Lua** and the **LÖVE 11.x (Love2D)** framework. The game features real-time 2-player local competition with frame-rate independent physics, strict paddle boundary clamping, precise Axis-Aligned Bounding Box (AABB) collision resolution with anti-stick surface repositioning, dynamic rally acceleration, and a visible scoring system.

---

## 🚀 How to Run

1. Ensure **[Love2D 11.x](https://love2d.org/)** is installed on your system.
2. Open a terminal / command prompt inside this folder (`Pong Game (Love2D)`):
   ```bash
   love .
   ```
   *Alternatively, from the parent directory:*
   ```bash
   love "Pong Game (Love2D)"
   ```

---

## 🕹️ Controls

| Action | Player | Controls |
| :--- | :--- | :--- |
| **Move Up** | Left Paddle (Player 1) | <kbd>W</kbd> |
| **Move Down** | Left Paddle (Player 1) | <kbd>S</kbd> |
| **Move Up** | Right Paddle (Player 2) | <kbd>↑</kbd> (Up Arrow) |
| **Move Down** | Right Paddle (Player 2) | <kbd>↓</kbd> (Down Arrow) |

---

## ⚡ Own Change: Dynamic Ball Acceleration on Paddle Collision

### Description & Motivation
In standard Pong, constant velocity can lead to repetitive, prolonged rallies with little escalating pressure. To make gameplay more thrilling and reward skillful paddle defense, an **acceleration multiplier** was introduced:
- Every time the ball strikes a player's paddle, horizontal and vertical velocities (`ball.dx` and `ball.dy`) are multiplied by a **1.05× factor** (a 5% speed boost per return).
- To prevent tunneling (the ball passing through paddles between frames at extreme velocities), a safety clamp of **600 pixels/second** (`BALL_MAX_SPEED`) is strictly enforced.
- When a point is scored and the ball resets to the center, velocities are reset back to the baseline speed of **200 pixels/second** (`BALL_BASE_SPEED`).

---

## 📸 Media & Demonstration

### Gameplay Screenshot
![Gameplay](screenshots/Pong%20Game%20%28Love2D%29.png)

### Gameplay Video
[![Watch the demo](https://img.shields.io/badge/YouTube-Watch%20Demo-red?logo=youtube)](https://youtu.be/6dNWotSYuiI)  
▶️ **[Watch the demo on YouTube](https://youtu.be/6dNWotSYuiI)**

---

## 🛠️ Technical Details & Physics Implementation
- **Delta Time (`dt`) Integration:** All paddle and ball displacement calculations are multiplied by `dt` in `love.update(dt)` to ensure smooth 60+ FPS frame-rate independence.
- **AABB Collision Detection:** Implemented via a dedicated `checkCollision(a, b)` function checking bounding-box overlap on both X and Y axes.
- **Anti-Stick Logic:** On paddle impact, the ball is automatically repositioned flush with the paddle's exterior face (`ball.x = player1.x + player1.width` or `ball.x = player2.x - ball.width`) to eliminate edge-sticking artifacts.
- **Screen Boundary Clamping:** Paddles are mathematically clamped within `[0, SCREEN_HEIGHT - paddle.height]` to guarantee they never leave the visible screen area.
