# The Gemini Challenge: Your First App Customization

Welcome! This guide is designed for people with **zero programming experience** who want to learn how to customize a mobile app using AI assistance. By the end of this challenge, you'll have:
- Set up a complete development environment
- Run a real Flutter app on an emulator
- Used AI to explore and modify code
- Fixed UI bugs you discover yourself

No prior coding knowledge required - just curiosity and patience!

## What You'll Learn

- How to install development tools
- How to run a mobile app on an emulator
- How to use AI (Gemini CLI) to understand and modify code
- Basic debugging techniques
- How to "prompt engineer" your way through problems

---

## Part 1: Setting Up Your Environment

### Step 1: Install Visual Studio Code

VS Code is the code editor we'll use. It's free and powerful.

**All Operating Systems:**
1. Go to https://code.visualstudio.com/
2. Download for your operating system
3. Install and open VS Code

### Step 2: Install Flutter Extension

Flutter is the framework this app is built with. The VS Code extension will automatically install Flutter and Dart for you.

1. Open VS Code
2. Click the Extensions icon on the left sidebar (looks like 4 squares)
3. Search for "Flutter"
4. Install the official **Flutter extension** by Dart Code
5. VS Code will prompt you to install Flutter SDK and Dart - **accept and let it install**
6. This may take 10-15 minutes, be patient!

**Verify Installation:**
- Open VS Code Terminal (View > Terminal, or Ctrl+` / Cmd+`)
- Type: `flutter doctor`
- You should see information about your Flutter installation

### Step 3: Install Android Studio (for the Emulator)

To run the app on your computer, you need an Android emulator.

**Windows:**
1. Go to https://developer.android.com/studio
2. Download Android Studio
3. Run the installer
4. During installation, make sure "Android Virtual Device" is checked
5. Complete the setup wizard
6. Open Android Studio > More Actions > Virtual Device Manager
7. Click "Create Device"
8. Choose a phone (Pixel 6 recommended)
9. Download a system image (recommended: latest Android version)
10. Finish creating the virtual device

**macOS:**
1. Go to https://developer.android.com/studio
2. Download Android Studio for Mac
3. Open the .dmg file and drag Android Studio to Applications
4. Open Android Studio
5. Complete the setup wizard
6. Go to More Actions > Virtual Device Manager
7. Click "Create Device"
8. Choose a phone (Pixel 6 recommended)
9. Download a system image (recommended: latest Android version)
10. Finish creating the virtual device

**Ubuntu/Linux:**
```bash
# Install required dependencies
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# Download Android Studio
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.1.1.12/android-studio-2024.1.1.12-linux.tar.gz

# Extract and install
tar -xvf android-studio-*-linux.tar.gz
sudo mv android-studio /opt/
cd /opt/android-studio/bin
./studio.sh
```
Then follow the setup wizard and create a virtual device as described above.

### Step 4: Install Node.js

Node.js is required to run the Gemini CLI.

**Windows:**
1. Go to https://nodejs.org/
2. Download the LTS version (Long Term Support)
3. Run the installer
4. Use all default settings
5. Restart your computer after installation

**macOS:**
1. Go to https://nodejs.org/
2. Download the LTS version
3. Run the installer
4. Follow the installation steps

Or use Homebrew if you have it:
```bash
brew install node
```

**Ubuntu/Linux:**
```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Verify Installation:**
Open a new terminal and type:
```bash
node --version
npm --version
```
You should see version numbers for both.

### Step 5: Install Gemini CLI

The Gemini CLI is an AI-powered tool that helps you understand and modify code.

**All Operating Systems:**
Open your terminal/command prompt and run:
```bash
npm install -g @google/generative-ai-cli
```

This installs Gemini CLI globally on your system.

### Step 6: Authenticate Gemini CLI

You need a free Google AI API key to use Gemini.

1. Go to https://aistudio.google.com/app/apikey
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the API key

**Set up the API key:**

**Windows (Command Prompt):**
```bash
setx GOOGLE_API_KEY "your-api-key-here"
```
Then close and reopen your terminal.

**Windows (PowerShell):**
```powershell
[System.Environment]::SetEnvironmentVariable('GOOGLE_API_KEY', 'your-api-key-here', 'User')
```
Then close and reopen PowerShell.

**macOS/Linux:**
Add to your shell profile (~/.bashrc, ~/.zshrc, or ~/.bash_profile):
```bash
export GOOGLE_API_KEY="your-api-key-here"
```
Then run:
```bash
source ~/.bashrc  # or ~/.zshrc depending on your shell
```

---

## Part 2: Getting the App Running

### Step 1: Clone the Repository

Open VS Code and open a terminal (View > Terminal).

```bash
# Navigate to where you want to store the project
cd Documents  # or wherever you prefer

# Clone the repository
git clone https://github.com/YOUR_USERNAME/MouettesMuscles.git

# Navigate into the project
cd MouettesMuscles
```

### Step 2: Install Dependencies

In the same terminal:
```bash
flutter pub get
```

This downloads all the packages the app needs.

### Step 3: Start the Android Emulator

**Option 1: From Android Studio**
1. Open Android Studio
2. Click "More Actions" > "Virtual Device Manager"
3. Find your device and click the Play (▶) button

**Option 2: From Command Line**
```bash
# List available emulators
flutter emulators

# Start an emulator (use the ID from the list)
flutter emulators --launch <emulator_id>
```

Wait for the emulator to fully boot (you'll see the Android home screen).

### Step 4: Run the App

In your VS Code terminal:
```bash
flutter run
```

The app will compile and launch on your emulator. This first build might take a few minutes.

**If it works**, you should see the "Mouette Musclé" fitness app on your emulator!

---

## Part 3: Using Gemini CLI for Code Exploration

### Understanding Gemini CLI

Gemini CLI is your AI pair programmer. You can ask it questions about the code, request changes, and get explanations.

**Basic Usage:**
```bash
gemini "your question or request here"
```

### Useful Prompts for Beginners

**Understanding the codebase:**
```bash
gemini "Explain what the main.dart file does in simple terms"

gemini "Show me where the app's color scheme is defined"

gemini "What screens does this app have?"
```

**Finding specific code:**
```bash
gemini "Find all the places where the color #BEA139 is used"

gemini "Show me the home screen code"
```

**Making changes:**
```bash
gemini "Change the primary color from gold to blue"

gemini "Add a new button to the home screen"
```

### Tips for Better Prompts

1. **Be specific**: Instead of "change color", say "change the primary color to blue (#0000FF)"
2. **Ask for explanations**: "Explain what this code does before making changes"
3. **Request examples**: "Show me an example of how to change font size"
4. **Iterate**: Start with small changes, test them, then make more changes

---

## Part 4: Hot Reload - Your Best Friend

Flutter has a feature called "Hot Reload" that lets you see changes instantly without restarting the app.

**After making a code change:**
1. Save the file (Ctrl+S / Cmd+S)
2. In the terminal where `flutter run` is running, press `r`
3. Your changes appear instantly in the emulator!

**If something breaks:**
- Press `R` (capital R) for a full restart
- Or stop the app (press `q` in terminal) and run `flutter run` again

---

## Part 5: Basic Debugging

### When Things Go Wrong

**Problem: Red screen or error in the app**
- Look at the terminal output - it shows the error
- Copy the error message and ask Gemini: "What does this error mean: [paste error]"

**Problem: App won't compile**
- Run `flutter clean` then `flutter pub get` then `flutter run`
- Check for typos in your changes
- Ask Gemini to review your recent changes

**Problem: Emulator won't start**
- Close and reopen Android Studio
- Try creating a new virtual device
- Check that you have enough disk space (need ~10GB free)

**Problem: Changes don't appear**
- Make sure you saved the file
- Try pressing `R` (capital R) for a full restart
- Stop and restart `flutter run`

---

## Part 6: The Challenge

Now for the fun part! This app was built in just 3 hours, so there are some UI issues waiting to be discovered.

### Your Mission

1. **Explore the app thoroughly**
   - Navigate through all screens
   - Click all the buttons
   - Look at different cards and UI elements
   - Pay attention to colors, fonts, spacing, and consistency

2. **Find UI bugs and inconsistencies**
   - Do colors match across the app?
   - Are fonts consistent?
   - Do similar elements look similar?
   - Are there any visual glitches?
   - Does text look right everywhere?

3. **Use Gemini to fix what you find**
   - Ask Gemini to help you locate the code for the problem area
   - Request a fix with a clear description
   - Test your fix with hot reload
   - Iterate until it looks good!

### Example Challenge Flow

Let's say you notice something looks off:

1. **Identify the issue**: "The workout cards have different colors than the rest of the app"

2. **Ask Gemini**:
   ```bash
   gemini "Where are the workout card colors defined?"
   ```

3. **Request a fix**:
   ```bash
   gemini "Change the workout card colors to match the app's primary theme color (#BEA139)"
   ```

4. **Test it**: Save the file, press `r` in your terminal, and see if it looks better!

5. **Iterate**: If it's not quite right, ask Gemini to refine it

### Prompt Engineering Tips

**Good prompts:**
- "Find where the background color is set for the stats screen"
- "Change the date text color in run cards to match the theme"
- "Make the button colors consistent across all screens"

**Less helpful prompts:**
- "Fix the colors"
- "Make it look better"
- "Change stuff"

### Bonus Challenges

Once you've found and fixed UI issues:
1. Change the app's entire color scheme
2. Add your name to the app title
3. Change the app font to something else
4. Add a new button somewhere
5. Modify the app icon description

---

## Part 7: Useful Commands Reference

### Flutter Commands
```bash
flutter run                # Run the app
flutter clean              # Clean build files
flutter pub get            # Get dependencies
flutter doctor             # Check installation
flutter emulators          # List emulators
flutter devices            # List connected devices
```

### While App is Running
- `r` - Hot reload
- `R` - Hot restart (full restart)
- `q` - Quit
- `p` - Show performance overlay

### Git Commands (for saving your work)
```bash
git status                 # See what you changed
git add .                  # Stage all changes
git commit -m "Fixed UI"   # Save your changes
```

---

## Part 8: Next Steps

After completing the challenge:

1. **Share your fixes**: Create a pull request on GitHub
2. **Try bigger changes**: Add a new feature or screen
3. **Learn Flutter**: https://flutter.dev/docs
4. **Explore other AI tools**: Try Claude Code, Cursor, or GitHub Copilot
5. **Join the community**: Share your experience!

---

## Troubleshooting

### Gemini CLI not working
- Check your API key is set correctly: `echo %GOOGLE_API_KEY%` (Windows) or `echo $GOOGLE_API_KEY` (Mac/Linux)
- Verify you're using the free tier (25 requests per day)
- Check your internet connection

### Flutter installation issues
- Run `flutter doctor` and follow the suggestions
- Make sure Android Studio is properly installed
- On Windows, you might need to accept Android licenses: `flutter doctor --android-licenses`

### Emulator is slow
- Allocate more RAM to the emulator (in AVD Manager settings)
- Close other applications to free up resources
- Consider using a physical Android device instead (enable Developer Options and USB Debugging)

### VS Code doesn't recognize Flutter
- Restart VS Code after installing Flutter extension
- Check that Flutter is in your system PATH
- Run "Flutter: Run Flutter Doctor" from VS Code command palette (Ctrl+Shift+P / Cmd+Shift+P)

---

## Congratulations!

You've set up a complete mobile development environment, run a real app, and used AI to explore and modify code - all without prior programming experience! This is a huge achievement.

The skills you learned here - using AI tools, debugging, iterating on solutions - are exactly what professional developers do every day. Keep exploring, keep learning, and most importantly, have fun!

**Remember**: Every expert was once a beginner. The only difference is practice.

Happy coding! 🚀
