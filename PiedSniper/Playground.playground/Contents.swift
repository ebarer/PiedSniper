import UIKit
import RegexBuilder

let content = """
    Shots on Goal:
Place a slash between the #'s in order to denote period breaks.
 Visitor: 1 2 3 4 5 6 7 8 9 1011|1213141516171819|202122232425
33
26 27 28 29 30 31 32 33|34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
 Home: 1 2 3 4 5 6 7|8 9 101112131415|16171819202122232425
26
26|27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
"""

func shots(in content: String) -> (home: [Int], away: [Int]) {
    var shots = (home: [Int](), away: [Int]())

    let shotsPattern = Regex {
        ChoiceOf {
            "Visitor"
            "Home"
            Capture {
                OneOrMore(.digit)
                "|"
            }
        }
    }

    var isHome = false

    let matches = content.matches(of: shotsPattern)
    for match in matches {
        // Detect team
        if (content[match.range] == "Visitor") {
            isHome = false
            continue
        }

        if (content[match.range] == "Home") {
            isHome = true
            continue
        }

        var shotString = String(content[match.range].dropLast(1))
        if shotString.count > 2 {
            let startIndex = shotString.index(shotString.endIndex, offsetBy: -2)
            shotString = String(shotString[startIndex...])
        }

        let shotCount = Int(shotString) ?? 0
        if isHome {
            shots.home.append(shotCount)
        } else {
            shots.away.append(shotCount)
        }
    }

    return shots
}

let shotCount = shots(in: content)
print(shotCount)
