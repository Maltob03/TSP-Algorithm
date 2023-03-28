import SwiftUI
import MapKit

struct ContentView: View {
    @State private var annotations: [MKAnnotation] = []
    
    var body: some View {
        MapView(annotations: $annotations)
            .onAppear {
                // Define the cities to visit
                let cities = [
                    ("New York", CLLocation(latitude: 40.7128, longitude: -74.0060)),
                    ("Houston", CLLocation(latitude: 29.7604, longitude: -95.3698)),
                    ("Phoenix", CLLocation(latitude: 33.4484, longitude: -112.0740)),
                    ("San Diego", CLLocation(latitude: 32.7157, longitude: -117.1611)),
                    ("Dallas", CLLocation(latitude: 32.7767, longitude: -96.7970)),
                    ("San Jose", CLLocation(latitude: 37.3382, longitude: -121.8863))
                ]
                
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

