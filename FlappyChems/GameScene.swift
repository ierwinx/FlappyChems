import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Properties
    private let fly1 = SKTexture(imageNamed: "fly1")
    private var mosca: SKSpriteNode!
    private var fondoEscenario: SKSpriteNode!
    private var tapToPlay: SKSpriteNode!
    private var gameOver: SKSpriteNode!
    private var suelo: SKNode!
    private var techo: SKNode!
    private var tubo: SKSpriteNode!
    private var tubo2: SKSpriteNode!
    private var puntuacion: SKLabelNode!
    private var score: Int = 0
    private var tiempo = Timer()
    private var finalizado = false
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        iniciar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !finalizado {
            mosca.physicsBody = SKPhysicsBody(circleOfRadius: fly1.size().width / 2)
            mosca.physicsBody!.isDynamic = true
            mosca.physicsBody!.velocity = CGVector(dx: 0, dy: 100)
            mosca.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 80))
            mosca.physicsBody!.categoryBitMask = TipoNodo.Mosca.rawValue
            mosca.physicsBody!.collisionBitMask = TipoNodo.Suelo.rawValue
            mosca.physicsBody!.contactTestBitMask = TipoNodo.Suelo.rawValue | TipoNodo.TuboyEspacio.rawValue
            
            tapToPlay.removeFromParent()
        } else {
            finalizado = false
            score = 0
            //self.speed = 1
            self.removeAllChildren()
            iniciar()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //MARK: Creacion de Nodos
    private func creaFondo() -> Void {
        let fondo = SKTexture(imageNamed: "fondo")
        
        let movimiento = SKAction.move(by: CGVector(dx: -fondo.size().width - 1, dy: 0), duration: 5)
        let origen = SKAction.move(by: CGVector(dx: fondo.size().width, dy: 0), duration: 0)
        let animacion = SKAction.repeatForever(SKAction.sequence([movimiento, origen]))
        
        var i: CGFloat = 0
        while i < 2 {
            fondoEscenario = SKSpriteNode(texture: fondo)
            fondoEscenario.position = CGPoint(x: fondo.size().width * i, y: self.frame.midY)
            fondoEscenario.size.height = self.frame.size.height
            fondoEscenario.zPosition = -1
            fondoEscenario.run(animacion)
            self.addChild(fondoEscenario)
            i += 1
        }
        
    }
    
    private func creaMosca() -> Void {
        let fly2 = SKTexture(imageNamed: "fly2")
        
        let accion = SKAction.animate(with: [self.fly1, fly2], timePerFrame: 0.1)
        let animacion = SKAction.repeatForever(accion)
        
        mosca = SKSpriteNode(texture: self.fly1)
        mosca.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mosca.size = CGSize(width: 140, height: 110)
        mosca.zPosition = 1
        mosca.run(animacion)
        self.addChild(mosca)
    }
    
    private func creaTapToStart() -> Void {
        let tap = SKTexture(imageNamed: "tap")
        tapToPlay = SKSpriteNode(texture: tap)
        tapToPlay.position = CGPoint(x: 0.0, y: self.frame.minY + 250)
        tapToPlay.size = CGSize(width: 300, height: 300)
        tapToPlay.zPosition = 2
        self.addChild(tapToPlay)
    }
    
    private func creaGameOver() -> Void {
        let gameoverTexture = SKTexture(imageNamed: "gameover")
        gameOver = SKSpriteNode(texture: gameoverTexture)
        gameOver.position = CGPoint(x: 0.0, y: 0.0)
        gameOver.size = CGSize(width: 300, height: 300)
        gameOver.zPosition = 2
        self.addChild(gameOver)
    }
    
    private func creaSuelo() -> Void {
        suelo = SKNode()
        suelo.position = CGPoint(x: 0.0, y: self.frame.minY + 30)
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        suelo.physicsBody!.isDynamic = false
        suelo.physicsBody!.categoryBitMask = TipoNodo.Suelo.rawValue
        suelo.physicsBody!.collisionBitMask = TipoNodo.Mosca.rawValue
        suelo.physicsBody!.contactTestBitMask = TipoNodo.Mosca.rawValue
        self.addChild(suelo)
    }
    
    private func creaTecho() -> Void {
        techo = SKNode()
        techo.position = CGPoint(x: 0.0, y: self.frame.maxY)
        techo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        techo.physicsBody!.isDynamic = false
        techo.zPosition = 1
        self.addChild(techo)
    }
    
    @objc private func creaTubosyEspacios() -> Void {

        let aleatorio = CGFloat(arc4random() % UInt32(self.frame.height / 2))
        let tamañoEspacioTubos = aleatorio - self.frame.height / 4
        
        let tube = SKTexture(imageNamed: "Tubo1")
        tubo = SKSpriteNode(texture: tube)
        tubo.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + tube.size().height / 1.7 + tamañoEspacioTubos)
        tubo.physicsBody = SKPhysicsBody(rectangleOf: tube.size())
        tubo.physicsBody!.isDynamic = false
        tubo.zPosition = 0
        tubo.physicsBody!.categoryBitMask = TipoNodo.Suelo.rawValue
        tubo.physicsBody!.collisionBitMask = TipoNodo.Mosca.rawValue
        tubo.physicsBody!.contactTestBitMask = TipoNodo.Mosca.rawValue
        
        let tube2 = SKTexture(imageNamed: "Tubo2")
        tubo2 = SKSpriteNode(texture: tube2)
        tubo2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - tube2.size().height / 1.7 + tamañoEspacioTubos)
        tubo2.physicsBody = SKPhysicsBody(rectangleOf: tube2.size())
        tubo2.physicsBody!.isDynamic = false
        tubo2.zPosition = 0
        tubo2.physicsBody!.categoryBitMask = TipoNodo.Suelo.rawValue
        tubo2.physicsBody!.collisionBitMask = TipoNodo.Mosca.rawValue
        tubo2.physicsBody!.contactTestBitMask = TipoNodo.Mosca.rawValue
        
        let movimiento = SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: 6)
        let eliminaTubo = SKAction.removeFromParent()
        let mueveRemueve = SKAction.sequence([movimiento, eliminaTubo])
        
        let origen = SKAction.move(by: CGVector(dx: 500, dy: 0), duration: 0)
        let animacion = SKAction.repeatForever(SKAction.sequence([mueveRemueve, origen]))

        tubo.run(animacion)
        tubo2.run(animacion)
        
        self.addChild(tubo)
        self.addChild(tubo2)
        
        crearEspacios(aleatorio: aleatorio, tamañoEspacioTubos: tamañoEspacioTubos, animacion: animacion, tubes: tube)
    }
    
    private func crearEspacios(aleatorio: CGFloat, tamañoEspacioTubos: CGFloat, animacion: SKAction,  tubes: SKTexture) -> Void {
        let espacio = SKSpriteNode()
        espacio.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + tamañoEspacioTubos)
        espacio.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tubes.size().width, height: mosca.size.height * 3))
        espacio.physicsBody!.isDynamic = false
        espacio.physicsBody!.categoryBitMask = TipoNodo.TuboyEspacio.rawValue
        espacio.physicsBody!.collisionBitMask = TipoNodo.Mosca.rawValue
        espacio.physicsBody!.contactTestBitMask = TipoNodo.Mosca.rawValue
        espacio.zPosition = 1
        espacio.run(animacion)
        
        self.addChild(espacio)
    }
    
    private func crearLLorar() -> Void {
        let llorar1 = SKTexture(imageNamed: "llorando1")
        let llorar2 = SKTexture(imageNamed: "llorando2")
        
        let accion = SKAction.animate(with: [llorar1, llorar2], timePerFrame: 0.3)
        let animacion = SKAction.repeatForever(accion)
        
        let chemsLlora = SKSpriteNode(texture: llorar1)
        chemsLlora.position = CGPoint(x: 0.0, y: self.frame.minY + 250)
        chemsLlora.size = CGSize(width: 300, height: 300)
        chemsLlora.zPosition = 2
        chemsLlora.run(animacion)
        self.addChild(chemsLlora)
    }
    
    private func creaPuntuar() -> Void {
        puntuacion = SKLabelNode(fontNamed: "Chalkduster")
        puntuacion.text = "Score: 0"
        puntuacion.fontColor = .white
        puntuacion.position = CGPoint(x: -self.frame.maxX + 180, y: self.frame.maxY - 100)
        puntuacion.zPosition = 2
        self.addChild(puntuacion)
    }
    
    // MARK: Metodos
    private func incrementaPuntuacion() -> Void {
        score += 1
        puntuacion.text = "Score: \(score)"
    }
    
    private func iniciar() -> Void {
        tiempo = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.creaTubosyEspacios), userInfo: nil, repeats: true)
        
        creaFondo()
        creaMosca()
        creaTapToStart()
        creaSuelo()
        creaTecho()
        creaPuntuar()
        creaTubosyEspacios()
    }
    
    //MARK: Delegados
    func didBegin(_ contact: SKPhysicsContact) {
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB

        if cuerpoA.categoryBitMask == TipoNodo.Mosca.rawValue {
            switch cuerpoB.categoryBitMask {
                case TipoNodo.TuboyEspacio.rawValue:
                    incrementaPuntuacion()
                    break
                case TipoNodo.Suelo.rawValue:
                    //self.speed = 0
                    tiempo.invalidate()
                    creaGameOver()
                    crearLLorar()
                    finalizado = true
                    break
            default:
                //continua
                print("Continuar")
            }
        } else if cuerpoB.categoryBitMask == TipoNodo.Mosca.rawValue {
            switch cuerpoA.categoryBitMask {
                case TipoNodo.TuboyEspacio.rawValue:
                    incrementaPuntuacion()
                    break
                case TipoNodo.Suelo.rawValue:
                    //self.speed = 0
                    tiempo.invalidate()
                    creaGameOver()
                    crearLLorar()
                    finalizado = true
                    break
            default:
                //continua
                print("Continuar")
            }
        }
        
    }
    
}
