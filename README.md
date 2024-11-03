# GoalTracker

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

GoalTracker is a motivational app designed to help users set and track daily micro-goals. It encourages users to build consistent habits by offering reminders, logging achievements, and tracking streaks for consistency. The app utilizes AI to analyze user habits, providing personalized feedback and recommending optimal times for activities based on when users are most motivated or energized.

### App Evaluation

- **Category:** Productivity, Lifestyle
- **Mobile:** Designed as a mobile application for on-the-go use.
- **Story:**  GoalTracker helps users develop positive daily habits by providing structure, motivation, and a rewarding experience to make small but meaningful changes in their lives.
- **Market:** Targeted at individuals seeking to improve productivity, build habits, and stay consistent with daily goals like hydration, reading, or regular breaks.
- **Habit:** This app is intended for daily use, promoting habit-building and routine consistency.
- **Scope:** Primarily focused on habit-tracking with personalized insights and feedback based on user achievement patterns.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can set daily goals
User receives reminders for each goal
* User can log achievements and track goal completion
* User can view streaks for consistency
* AI analyzes user habits to provide personalized feedback on progress

**Optional Nice-to-have Stories**

* AI suggests optimal times for goal activities based on user motivation patterns
* Users can customize streak visuals
* Integration with a calendar or reminder system for enhanced scheduling
* Social sharing of streaks or achievements with friends

### 2. Screen Archetypes

- [ ] **Home Screen**
    * User can view and add new goals from this screen.
    * User can log achievements.
- [ ] **Goal Detail Screen**
    * User can set and edit reminders for each goal.
- [ ] **Progress Screen**
    * User can track goal progress/completion. 
    * User can view streaks for consistency.
- [ ] **Insights Screen**
    * User can see AI recommendations and feedback.

### 3. Navigation

**Tab Navigation** (Tab to Screen)


- [ ] Home
- [ ] Goals
- [ ] Progress
- [ ] Insights

**Flow Navigation** (Screen to Screen)


- [ ] **Home Screen**
    * Leads to Goal Detail Screen
    * Leads to Progress Screen

- [ ] **Goal Detail Screen**
    * Leads to Home Screen
    * Leads to Progress Screen

- [ ] **Progress Screen**
    * Leads to Home Screen
    * Leads to Goal Detail Screen
    * Leads to Insights Screen

- [ ] **Insights Screen**
    * Leads to Home SCreen
    * Leads to Goal Detail Screen
    * Leads to Progress Screen



## Wireframes
![Test_11zon](https://hackmd.io/_uploads/HJebb8Bbyx.jpg)



### [BONUS] Digital Wireframes & Mockups

<iframe style="border: 1px solid rgba(0, 0, 0, 0.1);" width="800" height="450" src="https://embed.figma.com/design/u2KBA0lfiXRujWv3ze5yw0/Untitled?node-id=0-1&embed-host=share" allowfullscreen></iframe>

### [BONUS] Interactive Prototype

## Schema 


### Models

[Model Name, e.g., User]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| username | String | unique id for the user post (default field)   |
| password | String | user's password for login authentication      |
| ...      | ...    | ...                          


### Networking

- [List of network requests by screen]
- [Example: `[GET] /users` - to retrieve user data]
- ...
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
