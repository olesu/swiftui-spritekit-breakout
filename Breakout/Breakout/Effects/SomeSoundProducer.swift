import Foundation
import SpriteKit

final class SKSoundProducer: SoundProducer {
    private weak var node: SKNode?
    
    init(node: SKNode) {
        self.node = node
    }
    
    func play(_ soundEffect: SoundEffect) {
        guard let node else { return }
        
        node.run(.playSoundFileNamed(soundEffect.fileName, waitForCompletion: false))
    }
}
