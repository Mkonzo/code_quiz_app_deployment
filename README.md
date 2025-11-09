# Code Quiz for Developers - Complete Development Guide

## 📋 Project Overview

A mobile quiz application for programming students featuring syntax questions, debugging challenges, output predictions, and algorithm complexity questions across multiple programming languages. Built with Flutter 3.35.7 and Dart 3.9.2.

---

## 🎯 Core Features

### Must-Have Features (MVP)
- **Multi-language Support**: Python, JavaScript, Java, C++, Dart
- **Question Types**:
  - Syntax questions
  - Debug the code challenges
  - Output prediction
  - Algorithm complexity (Big O)
- **Timed Challenges**: Countdown timer per question
- **Difficulty Levels**: Easy, Medium, Hard
- **Scoring System**: Points based on speed and accuracy
- **Explanations**: Detailed explanation after each answer
- **Progress Tracking**: Save user progress locally
- **Statistics Dashboard**: Track performance over time

### Nice-to-Have Features (Phase 2)
- Achievement badges
- Daily streaks
- Topic-specific practice mode
- Review incorrect answers
- Dark/Light theme toggle
- Custom quiz creation (user selects topics)

---

## 🏗️ Project Architecture

### Recommended Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_themes.dart
│   ├── utils/
│   │   ├── code_formatter.dart
│   │   └── time_formatter.dart
│   └── router/
│       └── app_router.dart
├── models/
│   ├── question.dart
│   ├── quiz_session.dart
│   ├── user_stats.dart
│   └── achievement.dart
├── services/
│   ├── question_service.dart
│   ├── storage_service.dart
│   ├── timer_service.dart
│   └── score_service.dart
├── providers/
│   ├── quiz_provider.dart
│   ├── theme_provider.dart
│   └── stats_provider.dart
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   ├── language_selection/
│   │   └── language_selection_screen.dart
│   ├── difficulty_selection/
│   │   └── difficulty_selection_screen.dart
│   ├── quiz/
│   │   ├── quiz_screen.dart
│   │   └── widgets/
│   │       ├── question_card.dart
│   │       ├── code_display.dart
│   │       ├── timer_widget.dart
│   │       └── option_button.dart
│   ├── result/
│   │   └── result_screen.dart
│   └── statistics/
│       └── statistics_screen.dart
└── widgets/
    ├── custom_button.dart
    ├── loading_indicator.dart
    └── progress_bar.dart

assets/
├── questions/
│   ├── python/
│   │   ├── easy.json
│   │   ├── medium.json
│   │   └── hard.json
│   ├── javascript/
│   │   ├── easy.json
│   │   ├── medium.json
│   │   └── hard.json
│   ├── java/
│   ├── cpp/
│   └── dart/
└── images/
    └── language_icons/
```

---

## 📦 Required Packages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Code Syntax Highlighting
  flutter_highlight: ^0.7.0
  
  # Fonts for Code Display
  google_fonts: ^6.1.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Navigation
  go_router: ^13.0.0
  
  # JSON Serialization
  json_annotation: ^4.8.1
  
  # Animations
  flutter_animate: ^4.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
  
  # Linting
  flutter_lints: ^3.0.0
```

---

## 📝 Data Models

### Question Model Structure

**Fields Required:**
- `id`: Unique identifier (String)
- `category`: Question category (e.g., "Python Syntax")
- `language`: Programming language (enum)
- `difficulty`: Easy/Medium/Hard (enum)
- `type`: QuestionType enum (syntax, debug, output, complexity)
- `question`: Question text (String)
- `codeSnippet`: Optional code to display (String?)
- `options`: List of answer choices (List<String>)
- `correctAnswer`: Index of correct option (int)
- `explanation`: Detailed explanation (String)
- `points`: Points awarded (int)
- `timeLimit`: Seconds allowed (int)

### Quiz Session Model

**Track Current State:**
- Current question index
- List of user answers
- Time taken per question
- Total score
- Start time
- Selected language and difficulty

### User Statistics Model

**Store Performance Data:**
- Total quizzes completed
- Total questions answered
- Correct/incorrect counts
- Average score
- Best score
- Questions by language
- Questions by difficulty
- Time statistics

---

## 🎨 UI/UX Design Guidelines

### Color Scheme Recommendations
- **Primary**: Deep blue (#2196F3) - trust, intelligence
- **Secondary**: Orange (#FF9800) - energy, enthusiasm
- **Success**: Green (#4CAF50) - correct answers
- **Error**: Red (#F44336) - incorrect answers
- **Code Background**: Dark grey (#263238) - code editor feel
- **Text on Code**: Light cyan (#80CBC4) - readability

### Typography
- **Headlines**: Poppins or Montserrat (bold)
- **Body Text**: Roboto or Inter (regular)
- **Code Display**: Fira Code or JetBrains Mono (monospace)

### Screen Flow
1. **Home Screen** → Language icons grid
2. **Language Selection** → Difficulty cards
3. **Difficulty Selection** → Quiz starts
4. **Quiz Screen** → Question with timer
5. **Answer Feedback** → Immediate explanation
6. **Result Screen** → Score summary + review option
7. **Statistics** → Performance graphs

---

## 💾 Data Storage Strategy

### Local Storage with SharedPreferences

**Store:**
- User progress (JSON string)
- High scores per language
- Completed quiz IDs
- Theme preference
- Last selected language/difficulty

**Key Naming Convention:**
- `user_stats`
- `high_score_{language}_{difficulty}`
- `completed_quizzes`
- `theme_mode`

### Question Bank (JSON Files)

**Why JSON in Assets:**
- No internet required
- Fast loading
- Easy to update (app update)
- Version controlled
- No API costs

**JSON Structure Per File:**
Each file contains 15-20 questions for one language-difficulty combination.

---

## ⚡ Key Implementation Considerations

### 1. Question Loading
- Load questions on app start
- Parse JSON asynchronously
- Cache in memory during session
- Shuffle questions for variety

### 2. Timer Implementation
- Use `Timer.periodic` from dart:async
- Cancel timer on answer selection
- Display countdown prominently
- Auto-submit on timeout

### 3. Scoring Logic
**Formula Suggestion:**
```
Base Points: 10 (easy), 20 (medium), 30 (hard)
Time Bonus: remaining_seconds * 1 point
Total = Base + Time Bonus (if correct)
```

### 4. Code Display
- Use `flutter_highlight` package
- Choose appropriate language syntax
- Enable horizontal scrolling for long lines
- Line numbers optional
- Font size: 14-16px

### 5. Progress Saving
- Save after each quiz completion
- Update statistics in real-time
- Handle app backgrounding gracefully

---

## 🎯 Development Phases

### Phase 1: Foundation (Week 1)
- [ ] Project setup and package installation
- [ ] Create basic models (Question, QuizSession)
- [ ] Setup folder structure
- [ ] Create 20 sample questions (Python easy)
- [ ] Build Home screen UI

### Phase 2: Core Features (Week 2)
- [ ] Language selection screen
- [ ] Difficulty selection screen
- [ ] Quiz screen with timer
- [ ] Code display with syntax highlighting
- [ ] Answer selection and validation
- [ ] Result screen

### Phase 3: Data & State (Week 3)
- [ ] Implement QuestionService
- [ ] Setup Riverpod providers
- [ ] Local storage with SharedPreferences
- [ ] Score calculation logic
- [ ] Statistics tracking

### Phase 4: Content Creation (Week 4)
- [ ] Create 60+ questions per language
- [ ] Distribute across difficulties
- [ ] Write detailed explanations
- [ ] Test all questions for accuracy

### Phase 5: Polish (Week 5)
- [ ] Statistics dashboard
- [ ] Animations and transitions
- [ ] Sound effects (optional)
- [ ] Error handling
- [ ] Testing on multiple devices

---

## 📚 Learning Resources

### Flutter Concepts to Master
- **State Management**: Riverpod basics and providers
- **Navigation**: go_router or Navigator 2.0
- **Local Storage**: SharedPreferences CRUD operations
- **JSON Parsing**: fromJson/toJson methods
- **Async Programming**: Future, async/await
- **Custom Widgets**: Reusable component creation

### Useful Documentation
- Flutter Highlight: https://pub.dev/packages/flutter_highlight
- Riverpod: https://riverpod.dev/docs/introduction/getting_started
- SharedPreferences: https://pub.dev/packages/shared_preferences
- Go Router: https://pub.dev/packages/go_router

---

## 🚀 Getting Started Checklist

- [ ] Flutter and Dart installed (verify with `flutter doctor`)
- [ ] IDE setup (VS Code or Android Studio)
- [ ] Create new Flutter project
- [ ] Add all dependencies to pubspec.yaml
- [ ] Create folder structure as outlined above
- [ ] Design question JSON schema
- [ ] Create at least 20 sample questions for testing
- [ ] Build a simple UI prototype (home + quiz screen)
- [ ] Test on emulator/physical device

---

## 🎓 Question Creation Guidelines

### Writing Good Quiz Questions

**Syntax Questions:**
- Focus on commonly confused syntax
- Test real-world scenarios
- Include edge cases

**Debug Challenges:**
- Single, clear bug per question
- Realistic errors developers make
- Provide context for the code

**Output Predictions:**
- Code should be 5-15 lines max
- Test language-specific behavior
- Include tricky but fair scenarios

**Algorithm Complexity:**
- Show complete function
- Ask for time or space complexity
- Include nested loops, recursion examples

### Quality Standards
- ✅ Clear and unambiguous questions
- ✅ All options should be plausible
- ✅ Explanations teach, not just confirm
- ✅ Code is properly formatted
- ✅ Tested for correctness
- ❌ Avoid trick questions
- ❌ No outdated language features
- ❌ No syntax that requires memorization

---

## 🔧 Testing Strategy

### Manual Testing Checklist
- [ ] All navigation flows work
- [ ] Timer counts down correctly
- [ ] Correct answers are marked properly
- [ ] Explanations display after answers
- [ ] Progress saves between sessions
- [ ] Statistics update correctly
- [ ] App doesn't crash on edge cases

### Test Cases to Cover
- Answering all questions correctly
- Timing out on questions
- Closing app mid-quiz
- No internet connection (should work offline)
- Different screen sizes
- Rapid button tapping

---

## 📱 Deployment Preparation

### Before Release
- [ ] Test on iOS and Android
- [ ] Create app icon (1024x1024)
- [ ] Write app description
- [ ] Prepare screenshots (5-8)
- [ ] Set proper app permissions
- [ ] Configure package name/bundle ID
- [ ] Version number: 1.0.0

### App Store Requirements
- **Android**: Minimum SDK 21 (Android 5.0)
- **iOS**: Minimum iOS 12.0
- Privacy policy (if collecting any data)
- Age rating (educational/safe for all ages)

---

## 💡 Tips for Success

1. **Start Small**: Build with one language first, then expand
2. **Test Often**: Run on real devices frequently
3. **Version Control**: Use Git from day one
4. **Comment Code**: Especially complex logic
5. **User Feedback**: Get friends to test early
6. **Iterate**: Don't aim for perfection on first try
7. **Performance**: Profile if app feels slow
8. **Accessibility**: Consider font sizes, contrast

---

## 🤝 Need Help?

- Flutter Discord Community
- Stack Overflow (tag: flutter)
- Flutter Dev Subreddit
- GitHub Discussions on flutter/flutter

---

**Good luck with your Code Quiz app! 🚀**

Remember: The best way to learn is by building. Start coding, encounter problems, solve them, and iterate. You've got this!