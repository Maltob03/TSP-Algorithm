import MapKit




// Define a function to calculate the total distance between cities
func totalDistance(_ cities: [CLLocation]) -> CLLocationDistance {
    var distance: CLLocationDistance = 0
    for i in 0..<cities.count - 1 {
        distance += cities[i].distance(from: cities[i+1])
    }
    distance += cities.last!.distance(from: cities.first!)
    return distance
    
    }


// Define a function to generate all possible permutations of the cities
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


// Define a function to find the shortest path between cities using brute force
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


