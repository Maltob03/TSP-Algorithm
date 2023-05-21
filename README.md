<h1 align="center">
  <br>
  <a><img src="https://icons-for-free.com/iconfiles/png/512/code+logo+swift+icon-1320184804561081764.png" width="200"></a>
  <br>
  Travel Salesman Problem
  <br>
</h1>

<h4 align="center">Play with algorithms in Swift</h4>
<div align="center">
<a><img src="https://res.cloudinary.com/maltob03/image/upload/v1684681847/ControlRoom-2023-05-21-17-09-41_i4vxka.png" width="200"></a>
  </div>

<br><br>
The Traveling Salesman Problem (TSP) is a well-known optimization problem in computer science and mathematics. It asks the question: given a list of cities and the distances between them, what is the shortest possible route that visits each city exactly once and returns to the starting city?

The TSP is an NP-hard problem, which means that it is computationally difficult to solve for large instances of the problem. Despite this, it is an important problem with many practical applications, such as optimizing delivery routes for logistics companies or minimizing travel time for salespeople.

There are many different algorithms that have been developed to solve the TSP, including exact algorithms that guarantee an optimal solution, as well as heuristic algorithms that provide approximate solutions quickly but may not be optimal. Some of the most well-known algorithms for the TSP include the brute-force algorithm, the nearest neighbor algorithm, and the 2-opt algorithm. In this repo you can find an example of brute-force algorithm.

## Functions

### Total Distance

```swift
func totalDistance(_ cities: [CLLocation]) -> CLLocationDistance {
    var distance: CLLocationDistance = 0
    for i in 0..<cities.count - 1 {
        distance += cities[i].distance(from: cities[i+1])
    }
    distance += cities.last!.distance(from: cities.first!)
    return distance
    
    }
```



This function, totalDistance, takes an array of CLLocation objects called cities as its parameter and returns a CLLocationDistance value.

The purpose of this function is to calculate the total distance between a sequence of locations represented by the CLLocation objects in the input array cities. The function does this by computing the sum of the distances between each pair of consecutive cities in the array, and adding the distance between the last city and the first city to the total.

The function starts by initializing a variable distance of type CLLocationDistance to 0. This variable will be used to accumulate the total distance between the cities.

Next, the function iterates over the array of cities using a for loop, starting at the first city and stopping at the second-to-last city in the array. For each pair of consecutive cities, it calls the distance(from:) method of the first city to calculate the distance between the two cities, and adds the result to the distance variable.

After the loop completes, the function calculates the distance between the last city in the array and the first city by calling the distance(from:) method of the last city with the first city as its argument, and adds this distance to the distance variable.

Finally, the function returns the accumulated total distance between all of the cities.



### Permutation


```swift
func permutations<T>(_ array: [T]) -> [[T]] {
    if array.count == 1 { return [array] }
    let element = array.first!
    let subPermutations = permutations(Array(array.dropFirst()))
    var result: [[T]] = []
    for subPermutation in subPermutations {
        for i in 0...subPermutation.count {
            var permutation = subPermutation
            permutation.insert(element, at: i)
            result.append(permutation)
        }
    }
    return result
}
```


This function, permutations, takes an array of elements of generic type T called array as its parameter and returns an array of arrays containing all possible permutations of the elements in array.

The function uses recursion to calculate the permutations of the array. It starts by checking if the input array has only one element, in which case it returns an array containing the input array as its only element. This is the base case for the recursion.

If the input array has more than one element, the function takes the first element of the array and stores it in a variable called element. It then recursively calls itself on the remaining elements of the array, using the Array.dropFirst() method to create a new array with the first element removed.

The function stores the result of the recursive call in a variable called subPermutations.

The function then initializes an empty array called result, which will eventually contain all possible permutations of the input array.

The function then iterates over each sub-permutation in subPermutations using a for loop. For each sub-permutation, the function iterates over each possible position in the sub-permutation where the element could be inserted using another for loop. It creates a copy of the sub-permutation, inserts element at the current position, and appends the resulting permutation to result.

Finally, the function returns the result array containing all possible permutations of the input array.

### ShortestPath

```swift
func shortestPath(cities: [(String, CLLocation)]) -> (path: [CLLocation], distance: CLLocationDistance)? {
    // Generate all possible permutations of the cities
    let cityLocations = cities.map { $0.1 }
    let allPermutations = permutations(cityLocations)
    
    // Calculate the total distance for each permutation
    var shortestPath: [CLLocation]?
    var shortestDistance: CLLocationDistance?
    for permutation in allPermutations {
        let distance = totalDistance(permutation + [permutation.first!])
        if shortestDistance == nil || distance < shortestDistance! {
            shortestPath = permutation
            shortestDistance = distance
        }
    }
    
    // Connect the last city to the first city with a line
    if let path = shortestPath {
        shortestPath = path + [path.first!]
    }
    
    return shortestPath != nil ? (path: shortestPath!, distance: shortestDistance!) : nil
}
```



The function shortestPath takes an array of tuples, each containing a city name and its location represented by a CLLocation object. The function's goal is to find the shortest path that visits all cities in the list exactly once, and returns to the starting city.

The function first extracts the locations of the cities from the input array using the map method, and generates all possible permutations of the city locations using the permutations function.

For each permutation, the function computes the total distance of the path that visits the cities in the order specified by the permutation, and returns to the starting city. It does this by calling the totalDistance function, which takes an array of CLLocation objects and returns the total distance between adjacent locations in the array, as well as the distance between the first and last locations to complete the path.

The function keeps track of the shortest path and its distance seen so far by initializing two variables, shortestPath and shortestDistance, to nil. For each permutation, if the computed distance is shorter than the current shortest distance, the function updates the shortest path and its distance.

After all permutations have been processed, the function adds a line connecting the last city to the first city to complete the shortest path, and returns the shortest path and its distance as a tuple


## Complexity

The time complexity of the shortestPath function is O(n!), where n is the number of cities. This is because the function generates all possible permutations of the cities, which grows as n!, and for each permutation, it computes the total distance of the path, which takes O(n) time using the totalDistance function.

The space complexity of the function is also O(n!), as it generates all possible permutations of the cities and stores them in memory. Additionally, it uses O(n) space to store the current shortest path and distance seen so far.

![image](https://miro.medium.com/v2/resize:fit:1400/1*5ZLci3SuR0zM_QlZOADv8Q.jpeg)

**N.B If you've come this far now you know how to don't write an algorithm for the travel salesman problem**
