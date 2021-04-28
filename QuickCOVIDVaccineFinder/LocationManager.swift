
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
    willSet { objectWillChange.send() }
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
    
    let userLatitude  = self.location?.coordinate.latitude ?? 0
    let userLongitude = self.location?.coordinate.longitude ?? 0
   
       print("Got the user location")
       print(String(userLatitude))
       print(String(userLongitude))
    
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



//class LocationViewModel: NSObject, ObservableObject{
//
//    private let geocoder = CLGeocoder()
//    @Published var userLatitude:  Double = 0.0
//    @Published var userLongitude: Double = 0.0
//    @Published var placemark: CLPlacemark? {
//        willSet { objectWillChange.send() }
//      }
//
//  private let locationManager = CLLocationManager()
//
//  override init() {
//    super.init()
//    self.locationManager.delegate = self
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    self.locationManager.requestWhenInUseAuthorization()
//    self.locationManager.startUpdatingLocation()
//
//  }
//}
//



//extension LocationViewModel: CLLocationManagerDelegate {
//
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    guard let location = locations.last else { return }
//        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
//          if error == nil {
//            self.placemark = places?[0]
//          } else {
//            self.placemark = nil
//          }
//        })
//
//    print("Got the user location")
//
//
//
//    userLatitude = location.coordinate.latitude
//    userLongitude = location.coordinate.longitude
//
//    print("Got the user location")
//    print(String(userLatitude))
//    print(String(userLongitude))
//    print(String(self.placemark?.description ?? "XXX"))
//  }
//
    
    

    

