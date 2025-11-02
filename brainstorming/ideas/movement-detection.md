# Movement Detection Auto-Clicker

## Concept
Instead of searching for specific colors (which can be inaccurate), this script detects **movement** in a defined area. Since goblins move and trees/ground don't, this should be more reliable.

## How It Works
1. Takes a snapshot of pixels in a grid pattern
2. Waits a short time (200ms default)
3. Takes another snapshot
4. Compares the two snapshots
5. If enough pixels changed, movement is detected
6. Clicks on the detected movement

## Advantages Over Color Detection
- ✅ Won't click static objects (trees, ground, rocks)
- ✅ Works for any goblin color (brown, green, etc.)
- ✅ More reliable than color matching
- ✅ No need to find exact color codes

## Potential Issues
- ⚠️ Might click other moving things (players, other monsters)
- ⚠️ Requires targets to be moving
- ⚠️ Might be slower than color detection

---

## Quick Start Guide

### Step 1: Define Your Search Area
1. Run `movement-detector.ahk`
2. Press **4**
3. Click the **top-left** corner where goblins spawn
4. Click the **bottom-right** corner where goblins spawn
5. A blue box will briefly show your area
6. Press **6** to toggle the box on/off to verify the size

### Step 2: Test Movement Detection
1. Press **3** to enter test mode
2. Watch for **red markers** where movement is detected
3. Verify it's detecting goblins (not other things)
4. Press **3** again to stop test mode

### Step 3: Adjust Sensitivity (If Needed)
1. Press **5** to cycle through sensitivity levels:
   - **Low** (10) - Very sensitive, detects small changes
   - **Medium** (30) - Balanced, recommended
   - **High** (50) - Only detects obvious movement
2. Test again with **3** to see if it's better

### Step 4: Start Auto-Clicking
1. Press **1** to activate the clicker
2. It will click detected movement and wait 15 seconds
3. Press **1** to stop, or **2** to exit

---

## Controls

| Key | Function |
|-----|----------|
| **1** | Start/Stop movement clicker (will click) |
| **2** | Exit script completely |
| **3** | Test mode (shows movement without clicking) |
| **4** | Mark search area |
| **5** | Adjust sensitivity (Low/Medium/High) |
| **6** | Toggle showing search area box (verify size) |

---

## Settings You Can Adjust

Edit the script to fine-tune these values:

### `gridSize` (default: 20)
- How many pixels between each check point
- **Lower** (10) = More accurate, slower
- **Higher** (30) = Faster, might miss small movements

### `detectionDelay` (default: 20)
- Milliseconds between snapshots
- **Lower** (10) = Detects very fast movement
- **Higher** (50) = Detects slower movement

### `sensitivity` (default: 30)
- How different pixels must be to count as movement
- **Lower** (10) = Very sensitive
- **Higher** (50) = Less sensitive

### `minMovementPoints` (default: 3)
- How many moving pixels needed to count as a target
- **Lower** (1-2) = Detects small movements
- **Higher** (5-10) = Only detects larger movements

### `clickDelay` (default: 15000)
- Time to wait after clicking (milliseconds)
- Adjust based on how long it takes to kill a goblin

---

## Testing Strategy

1. **Start with test mode (key 3)** - See what it detects before clicking anything
2. **Use a small search area** - Easier to control what gets detected
3. **Adjust sensitivity** - If it detects too much/too little
4. **Watch the movement count** - Shows how many moving pixels were found
5. **Refine settings** - Based on what you observe

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| No movement detected | Goblins might be standing still - wait for them to move |
| Detects too many things | Increase `sensitivity` or `minMovementPoints` |
| Misses goblins | Decrease `sensitivity` or `gridSize` |
| Too slow | Increase `gridSize` or decrease `detectionDelay` |
| Clicks other players | Make search area smaller or increase `minMovementPoints` |
| Red marker appears in wrong spot | Adjust `gridSize` for more precision |

---

## Next Steps

After testing this movement detection approach:

1. **If it works well**: Move to `my-scripts/completed/`
2. **If it needs color filtering**: Combine with color detection (hybrid approach)
3. **If it's too unreliable**: Consider image recognition or other methods

---

## Status
🧪 **Testing Phase** - Need to verify movement detection accuracy

