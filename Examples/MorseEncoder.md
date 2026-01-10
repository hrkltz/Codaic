# Codaic / Examples / Morse Encoder

This example demonstrates how to convert text into Morse code using the haptic feedback module (vibrator) on iOS devices. When completed, your project will have the following stage and output:

<table>
  <tr>
    <th>Stage</th>
    <th>Output</th>
  </tr>
  <tr>
    <td><img src="MorseEncoder_1.webp" width="240" alt="Morse Encoder stage"></td>
    <td><img src="MorseEncoder_0.webp" width="240" alt="Morse Encoder output"></td>
  </tr>
</table>


## Introduction

The foundation of this example is the Morse code alphabet. For detailed information, see [Wikipedia](https://en.wikipedia.org/wiki/Morse_code). Here's a Lua representation that maps letters and numbers to their Morse code symbols:

```Lua
local morseDict = {
  ["A"] = ".-",
  ["B"] = "-...",
  ["C"] = "-.-.",
  ["D"] = "-..",
  ["E"] = ".",
  ["F"] = "..-.",
  ["G"] = "--.",
  ["H"] = "....",
  ["I"] = "..",
  ["J"] = ".---",
  ["K"] = "-.-",
  ["L"] = ".-..",
  ["M"] = "--",
  ["N"] = "-.",
  ["O"] = "---",
  ["P"] = ".--.",
  ["Q"] = "--.-",
  ["R"] = ".-.",
  ["S"] = "...",
  ["T"] = "-",
  ["U"] = "..-",
  ["V"] = "...-",
  ["W"] = ".--",
  ["X"] = "-..-",
  ["Y"] = "-.--",
  ["Z"] = "--..",
  ["0"] = "-----",
  ["1"] = ".----",
  ["2"] = "..---",
  ["3"] = "...--",
  ["4"] = "....-",
  ["5"] = ".....",
  ["6"] = "-....",
  ["7"] = "--...",
  ["8"] = "---..",
  ["9"] = "----."
}
```

Next, consider the timing rules for Morse code:

1. A dot/dit equals one unit (called the dit length)
2. A dash/dah equals three units
3. A space between letter parts equals one unit
4. A space between letters equals three units
5. A space between words equals seven units

We'll set the dot/dit length to 100 ms, which is the minimum interval at which Codaic can toggle the vibrator. This makes a dash/dah 300 ms long.

## Implement The Solution

After collecting all the basic information, it's time to start the project. First, add a new project and give it a name. Then open it and place the nodes as shown above. You will need a Custom node (Morse-Encoder), the Log node, and the Vibrator node. For the Log and Vibrator nodes, you can simply use the provided implementations without modification.

### Morse-Encoder Node

This custom node converts a word into Morse code and generates the output signal to control the haptic feedback module (vibrator).

```Lua
-- Morse-Encoder Node
-- Setup
local morseDict = {
  ["A"] = ".-",
  ["B"] = "-...",
  ["C"] = "-.-.",
  ["D"] = "-..",
  ["E"] = ".",
  ["F"] = "..-.",
  ["G"] = "--.",
  ["H"] = "....",
  ["I"] = "..",
  ["J"] = ".---",
  ["K"] = "-.-",
  ["L"] = ".-..",
  ["M"] = "--",
  ["N"] = "-.",
  ["O"] = "---",
  ["P"] = ".--.",
  ["Q"] = "--.-",
  ["R"] = ".-.",
  ["S"] = "...",
  ["T"] = "-",
  ["U"] = "..-",
  ["V"] = "...-",
  ["W"] = ".--",
  ["X"] = "-..-",
  ["Y"] = "-.--",
  ["Z"] = "--..",
  ["0"] = "-----",
  ["1"] = ".----",
  ["2"] = "..---",
  ["3"] = "...--",
  ["4"] = "....-",
  ["5"] = ".....",
  ["6"] = "-....",
  ["7"] = "--...",
  ["8"] = "---..",
  ["9"] = "----."
}

-- Extract the Morse code for the symbol.
local function letterToMorse(symbol)
  return morseDict[symbol]
end

-- Converts a word to Morse code
local function wordToMorse(word, dict)
  local morseCode = {}

  -- Transform the word character by character.
  --   1. upper() -> Convert "Codaic" to "CODAIC" since the morseDict only contains uppercase letters.
  --   2. gmatch(".") -> Split the word into individual characters for iteration. 
  for character in word:upper():gmatch(".") do
    local morseSequence = morseDict[character]
    -- Only append if the character exists in the dictionary (prevents nil errors).
    if morseSequence then
      table.insert(morseCode, morseSequence)
    end
  end

  -- Join each Morse "letter" with a one-unit break represented as a space.
  return table.concat(morseCode, " ")
end

-- Loop
while true do
  -- The word to encode and output.
  local word = "Codaic"
  -- Use 100 ms as the time unit for a dot/dit.
  local unit = 0.1

  local morseCode = wordToMorse(word, morseDict)

  -- Send the word to the Log Node.
  System.Output(0, word .. " -> " .. morseCode)
  -- Give the Log node a bit of time to read its input before writing the next one.
  System.Sleep(10)

  -- Use an indexed loop to access each symbol in the Morse code.
  for i = 1, #morseCode do
    local morseSymbol = morseCode:sub(i, i)

    if morseSymbol == " " then
      -- Gap between letters (300ms)
      System.Sleep(math.modf(unit*3*1000))
    else
      if morseSymbol == "." then
        -- Turn the vibrator on for 100ms (dot).
        System.Output(1, unit)
        System.Output(0, "> . " .. unit*1000 .. "ms")
        System.Sleep(math.modf(unit*1000))
      elseif morseSymbol == "-" then
        -- Turn the vibrator on for 300ms (dash).
        System.Output(1, unit*3)
        System.Output(0, "> - " .. unit*3*1000 .. "ms")
        System.Sleep(math.modf(unit*3*1000))
      end

      -- Add intra-letter gap (100ms) only if the next symbol is a dot or dash.
      local nextMorseSymbol = morseCode:sub(i + 1, i + 1)
      if nextMorseSymbol == "." or nextMorseSymbol == "-" then
        System.Sleep(math.modf(unit*1000))
      end
    end
  end

  -- Finally apply the word gap (700ms).
  System.Sleep(math.modf(unit*7*1000))
end
```

## Outlook

That's it! Congratulations! You've just completed your first Codaic project! Now it's time to run it. Simply press the play button in the top right corner and listen to your phone. If you like, you can also try replacing the Vibrator node with the Torch node to make your Morse code visible as well.


Best,
Oliver