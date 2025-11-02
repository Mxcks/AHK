# Goblin Auto-Clicker for OSRS

## Original Idea
I want to be able to use a script where it clicks on goblins and then waits for me to finish killing one, whether that's user input or auto input, and then clicks on the next goblin to kill for me.

## Implementation
**Script Created:** `goblin-clicker.ahk`

### Features
- Color-based goblin detection (brown/green)
- Infinite loop with 15-second delay between kills
- Customizable search area to avoid clicking trees/ground
- Debug mode to find goblin colors
- Easy start/stop controls

### Quick Start
1. Run `goblin-clicker.ahk`
2. Press **3** to enable debug mode
3. Hover over a goblin to find its color
4. Edit the script and update `goblinColor` variable
5. Press **4** to mark your search area (click top-left, then bottom-right)
6. Press **1** to start auto-clicking goblins
7. Press **1** again to stop, or **2** to exit

### Controls
- **1** = Start/Stop goblin clicker
- **2** = Exit script
- **3** = Debug mode (show mouse position and color)
- **4** = Mark search area

### Settings to Adjust
- `goblinColor` - The color to search for (use 3 to find)
- `colorTolerance` - How strict the color matching is (30 default)
- `killDelay` - Time between kills in milliseconds (15000 = 15 seconds)
- Search area coordinates (use 4 to set easily)

### Testing Notes
- Need to test if it clicks ground/trees
- May need to adjust color tolerance
- May need to refine search area
- Test different goblin types (brown vs green)

### Status
🔨 **In Progress** - Needs testing and refinement