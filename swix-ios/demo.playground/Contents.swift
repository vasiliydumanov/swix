import UIKit
import swix_ios

let mats: [matrix] = [
    matrix([[1.0, 1.0],
            [2.0, 2.0]]),
    matrix([[3.0, 3.0],
            [4.0, 4.0]])
]

print(hstack(mats))
print(vstack(mats))

