import UIKit

func test() -> Int {
    let a = "3 S"
    let result = a.trimmingCharacters(in: .decimalDigits.inverted)
    let num = Int(result) ?? 0
    return num
}

let c = test()
print(c)
