import Foundation
enum PlayerColor:String {
  
  case None = "-"
  case Red = "r"
  case Black = "b"
  
  var description: String {
    get {
      switch self {
      case .None:
        return "None\n"
      case .Red:
        return "Red\n"
      case .Black:
        return "Black\n"
      }
    }
  }
}


class GameBoard {
  var board: [[PlayerColor]] = []
  
  func empty() -> PlayerColor {
    return .None
  }
  func red() -> PlayerColor {
    return .Red
  }
  func black() -> PlayerColor {
    return .Black
  }
  
  init() {
    
    //Initialize the board with the standard checkers setup
    board = [
      [empty(),red(),empty(),red(),empty(),red(),empty(),red()],
      [red(),empty(),red(),empty(),red(),empty(),red(),empty()],
      [empty(),red(),empty(),red(),empty(),red(),empty(),red()],
      [empty(),empty(),empty(),empty(),empty(),empty(),empty(),empty()],
      [empty(),empty(),empty(),empty(),empty(),empty(),empty(),empty()],
      [black(),empty(),black(),empty(),black(),empty(),black(),empty()],
      [empty(),black(),empty(),black(),empty(),black(),empty(),black()],
      [black(),empty(),black(),empty(),black(),empty(),black(),empty()]
    ]
  }
  
  func displayBoard() {
    var outputString = ""
    for column in board {
      for piece in column {
        outputString += piece.rawValue
      }
      outputString += "\n"
    }
    outputString += "-------------------------------\n"
    println(outputString)
  }
    
    func error(errorType:String) {
        println("Invalid Move: \(errorType)")
    }
  
    func movePieceFrom(from: (Int, Int), to: (Int, Int))
    {
        // ~= operator tests to see if the range on the left contains the value on the right
        if !(0...7 ~= from.0 && 0...7 ~= from.1 && 0...7 ~= to.0 && 0...7 ~= to.1) {
            error("Range error")
            return
        }
        
        if playerAtLocation(from) == .None {
            error("No Piece to Move")
            return
        }
        
        if playerAtLocation(to) != .None {
            error("Move onto occupied square")
            return
        }
        
        let yDifference = to.1 - from.1
        if (playerAtLocation(from) == .Red) ? yDifference != abs(yDifference) : yDifference == abs(yDifference) {
            error("Move in wrong direction")
            return
        }
        
        if abs(to.0 - from.0) != 1 || abs(to.1 - from.1) != 1 {
            if abs(to.0 - from.0) != 2 || abs(to.1 - from.1) != 2 {
                error("Not a diagonal move")
                return
            }
            let coordsOfJumpedPiece = ((to.0 + from.0) / 2 as Int, (to.1 + from.1) / 2 as Int)
            let pieceToBeJumped: PlayerColor = self[coordsOfJumpedPiece]
            if contains([.None, playerAtLocation(from)], pieceToBeJumped) {
                error("Illegal jump")
                return
            }
            setPlayer(.None, atLocation: coordsOfJumpedPiece)    
        }
        
        let pieceToMove = board[from.1][from.0]
        board[from.1][from.0] = empty()
        board[to.1][to.0] = pieceToMove
    }
    
    func playerAtLocation(coordinates: (Int, Int)) -> PlayerColor {
        return board[coordinates.1][coordinates.0]
    }
    
    func setPlayer(player: PlayerColor, atLocation coordinates: (Int, Int)) {
        board[coordinates.1][coordinates.0] = player
    }
    
    subscript(coordinates: (Int,Int)) -> PlayerColor {
        get {
            return playerAtLocation(coordinates)
        }
        set {
            setPlayer(newValue, atLocation: coordinates)
        }
    }
    
    subscript (move coordinates: (Int,Int)) -> (Int,Int) {
        get {
            assert(false, "Using the getter of this subscript is not supported.")
        }
        set {
            movePieceFrom(coordinates, to: newValue)
        }
    }
}

let board = GameBoard()
board.displayBoard()

//board.movePieceFrom((2, 5), to: (3, 4))
board[move: (4,5)] = (2,3)
board.displayBoard()

let player = board[(3,4)]
println(player.description)

board[(3,4)] = .Red
board.displayBoard()


board[move: (1,6)] = (2,5) //legal move
board.displayBoard()

board[move: (1,6)] = (1,5) //No piece to move since
board.displayBoard() //you just moved the piece at (1,6)

board[move: (7,2)] = (6,1) //(6,1) is already occupied
board.displayBoard()

board[move: (7,2)] = (5,4) //Illegal jump - no piece to jump
board.displayBoard()

board[move: (7,2)] = (8,1) //Range Error
board.displayBoard()

board[move: (0,7)] = (1,6) //legal move
board.displayBoard()
