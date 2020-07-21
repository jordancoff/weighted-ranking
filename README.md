# Weighted Ranking

A simple generic implementation of weighted ranking.

## Example

```Swift
let allPizzas: [Pizza] = model.allPizzas()
let rankedPizzas = Ranking.ranked(items: allPizzas, scorer: PizzaScorer())
```

Business logic for scoring each dimension of a pizza is injected via `PizzaScorer` in [Example.swift](https://github.com/jordancoff/weighted-ranking/blob/master/Example.swift)
