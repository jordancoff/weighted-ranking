import Foundation

protocol RankerScoring {
  associatedtype RankableItem
  associatedtype RankingDimensions: CaseIterable, Hashable

  // Provides a score from 0 - 1 for the given item on a given dimension.
  func score(forItem item: RankableItem, onDimension dimension: RankingDimensions) -> Double

  // Provides weights for each dimension relative to one another.
  var weights: [RankingDimensions: Int] { get }
}

enum Ranking {
  private static func totalScore<T, U: RankerScoring>(forItem item: T, withScorer scorer: U)
    -> Double where T == U.RankableItem {
    var currentRating = 0.0
    for dimension in U.RankingDimensions.allCases {
      guard let dimensionWeight = scorer.weights[dimension] else {
        fatalError("No weight dictionary entry for dimension: \(dimension)")
      }
      let dimensionScore = scorer.score(forItem: item, onDimension: dimension)
      currentRating += Double(dimensionWeight) * dimensionScore
    }
    return currentRating
  }
  
  static func ranked<T: Hashable, U: RankerScoring>(items: [T], scorer: U)
    -> [T] where T == U.RankableItem {
    var rankings = [T: Double]()
    for item in items {
      rankings[item] = totalScore(forItem: item, withScorer: scorer)
    }
    return items.sorted { lhs, rhs -> Bool in
      return (rankings[lhs] ?? 0.0) > (rankings[rhs] ?? 0.0)
    }
  }

  // Same function as above without the constraint that the item be hashable.
  // Misses a minor optimization where all scores are precalculated before sorting.
  static func ranked<T, U: RankerScoring>(items: [T], scorer: U)
    -> [T] where T == U.RankableItem {
    return items.sorted { lhs, rhs -> Bool in
      let lhsScore = totalScore(forItem: lhs, withScorer: scorer)
      let rhsScore = totalScore(forItem: rhs, withScorer: scorer)
      return lhsScore > rhsScore
    }
  }
}
