import Foundation

enum PizzaRankingDimension: CaseIterable {
  case cheese, crust, sauce, toppings
}

struct PizzaScorer: RankerScoring {
  typealias RankingDimensions = PizzaRankingDimension
  typealias RankableItem = Pizza

  // Since you're only comparing final scores against other final scores for pizza, 
  // these values are only relative and don't need to add up to 100 or any particular value.
  var weights: [RankingDimensions: Int] = [
    .cheese: 40,
    .crust: 20, 
    .sauce: 25, 
    .toppings: 15, 
  ]

  // Returns a score 0-1 for each dimension.
  func score(forItem item: Pizza, onDimension dimension: PizzaRankingDimension) -> Double {
    // Implementations of the quality functions might look like:
    // - switch functions with intervals
    // - mathematic formulas mapping a real-world value to 0-1
    // - etc...if you use this and find a cool one, please pull request.
    switch dimension {
    case .cheese:
      return item.cheeseQuality()
    case .crust:
      return item.crustQuality()
    case .sauce:
      return item.sauceQuality()
    case .toppings:
      return item.toppingsQuality()
    }
  }
}
