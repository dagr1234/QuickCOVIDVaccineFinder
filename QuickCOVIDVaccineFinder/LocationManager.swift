
import Foundation
import Combine
import CoreLocation


class LocationManager: NSObject, ObservableObject {
    
  private let locationManager = CLLocationManager()
  private let geocoder = CLGeocoder()
  let objectWillChange = PassthroughSubject<Void, Never>()

  @Published var status: CLAuthorizationStatus? {
    willSet { objectWillChange.send() }
  }

  @Published var location: CLLocation? {
    willSet {
        print("Setting the location....")
        
        objectWillChange.send() }
  }
    
    
   @Published var placemark: CLPlacemark? {
      willSet { objectWillChange.send() }
   }

    

  override init() {
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    var userLatitude  = self.location?.coordinate.latitude ?? 0
    var userLongitude = self.location?.coordinate.longitude ?? 0
    
  }

   private func geocode() {
        print("Running geocode")
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
          if error == nil {
            self.placemark = places?[0]
          } else {
            self.placemark = nil
          }
        })
      }
}


extension LocationManager: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.status = status
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            self.location = location
            self.geocode()
        }
}

