

import CoreLocation

// Extend only SequenceTypes which contain instances of SORT.
extension Sequence where Iterator.Element == SORT {
    
    /// Returns Array of SORTs ordered by proximity to location parameter.
    func ordered(byProximityTo location: CLLocation) -> [SORT] {
        return self.sorted { (first, second) in
            return location.distance(from: first.location) < location.distance(from: second.location)
        }
    }
    
    /// Returns Array of SORTs ordered by the shortest possible route which connects all SORTs starting from location parameter.
    func ordered(byShortestRouteToEachSORTStartingFrom location: CLLocation) -> [SORT] {
        
        // Calculate all possible permutations, sorting by total distance.
        let sorted = permutations.sorted { (first, second) in
            return first.totalDistance(startingFrom: location) < second.totalDistance(startingFrom: location)
        }
        
        // Return first or empty array.
        return sorted.first ?? [SORT]()
    }
    
    /// Asynchronous version of ordered(byShortestRouteToEach...) function.
    func ordered(byShortestRouteToEachSORTStartingFrom location: CLLocation, queue: OperationQueue, completion: @escaping (Result<SORT>)->() ) {
        
        // Perform work asynchronously on background thread.
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let SORTs = self.ordered(byShortestRouteToEachSORTStartingFrom: location)
            let result = Result.success(SORTs)
            
            // Return result via completion handler on passed in queue.
            queue.addOperation { completion(result) }
        }
    }
    
    /// Return Array of SORTs ordered by the nearest neighbour algorithm.
    func ordered(byNearestNeighbourStartingFrom location: CLLocation) -> [SORT] {
        var scratch = Array(self)
        var result = [SORT]()
        
        var previousLocation = location
        
        while scratch.count > 0 {
            scratch = scratch.ordered(byProximityTo: previousLocation)
            let nearest = scratch.removeFirst()
            result.append(nearest)
            previousLocation = nearest.location
        }
        
        return result
    }
    
    
    
    func totalDistance(startingFrom startingLocation: CLLocation) -> CLLocationDistance {
        var totalDistance: CLLocationDistance = 0.0
        
        // Start from passed in location
        var previousLocation = startingLocation
        
        // Add distance between each location and previous location to totalDistance.
        for SORT in self {
            totalDistance += previousLocation.distance(from: SORT.location)
            previousLocation = SORT.location
        }
        
        return totalDistance
    }
}

extension Sequence {
    /// Returns array of all possible order permutations.
    var permutations: Array<[Iterator.Element]> {
        var scratch = Array(self) // This is a scratch space for Heap's algorithm
        var result = Array<[Iterator.Element]>() // This will accumulate our result
        
        // Heap's algorithm
        func heap(_ n: Int) {
            if n == 1 {
                result.append(scratch)
                return
            }
            
            for i in 0..<n-1 {
                heap(n-1)
                let j = (n%2 == 1) ? 0 : i
                swap(&scratch[j], &scratch[n-1])
            }
            heap(n-1)
        }
        
        // Let's get started
        heap(scratch.count)
        
        print("Number of permutations: \(result.count)")
        
        // And return the result we built up
        return result
    }
}

public extension Double {
    /// Returns a random floating SORTnt number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        get { return Double(arc4random()) / 0xFFFFFFFF }
    }
    
    /// Returns random Double between min and max, inclusive.
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
