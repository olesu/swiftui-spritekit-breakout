import Foundation
import SwiftUI

struct IdleViewModel {
    private let model: IdleModel
    
    let startGameButtonText = "Start Game"
    
    init(model: IdleModel) {
        self.model = model
    }

    func startGameButtonPressed() async {
        await model.startNewGame()
    }
}

