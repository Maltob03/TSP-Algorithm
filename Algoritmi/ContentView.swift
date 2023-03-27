//
//  ContentView.swift
//  Algoritmi
//
//  Created by Matteo Altobello on 26/03/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var annotations: [MKAnnotation] = []
    
    var body: some View {
        MapView(annotations: $annotations)
            .onAppear {
                // Define the cities to visit
                let cities = [
                    ("Casoria", CLLocation(latitude: 40.9045572, longitude: 14.2901223)),
                    ("Cercola", CLLocation(latitude: 40.8600227, longitude: 14.3589664)),
                    ("Marcianise", CLLocation(latitude: 41.0329966, longitude: 14.2984228)),
                    ("Acerra", CLLocation(latitude: 40.9460532, longitude: 14.3750083)),
                    ("Fuorigrotta", CLLocation(latitude: 40.8283522, longitude: 14.1964)),
                    ("Portici", CLLocation(latitude: 40.8189733, longitude: 14.3387454)),
                    ("San Giovanni a Teduccio", CLLocation(latitude: 40.8391172, longitude: 14.3387454))
                    
                ]
                
                
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
                
                // Find the shortest path and plot it on the map
                if let shortest = shortestPath(cities: cities) {
                    annotations = shortest.path.map { location -> MKAnnotation in
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location.coordinate
                        return annotation
                    }
                }
            }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var annotations: [MKAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
        // Add a polyline that connects the last city with the start city
        if annotations.count > 1 {
            let coordinates = annotations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        
        if !annotations.isEmpty {
            let region = MKCoordinateRegion(center: annotations.first!.coordinate, span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Pin"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        // Add renderer for the polyline
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .red
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

