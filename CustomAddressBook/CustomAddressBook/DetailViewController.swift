//
//  DetailViewController.swift
//  CustomAddressBook
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var firstNameLabel : UILabel?
    @IBOutlet weak var lastNameLabel : UILabel?
    @IBOutlet weak var phoneButton : UIButton?
    @IBOutlet weak var emailButton : UIButton?
    @IBOutlet weak var addressButton : UIButton?

    @IBOutlet weak var mapView : MKMapView?
    
    var mapPlacemark : MKPlacemark?
    
    var detailItem: Person? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.title = detail.firstName
            
            firstNameLabel?.text = detail.firstName
            lastNameLabel?.text = detail.lastName
            
            phoneButton?.setTitle(detail.phone, for: UIControlState())
            emailButton?.setTitle(detail.email, for: UIControlState())
            addressButton?.setTitle(detail.address, for: UIControlState())
            
            if let address = detail.address {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address) {
                    (placemarks, error) -> Void in
                    if let firstPlacemark = placemarks?[0] {
                        let pm = MKPlacemark(placemark: firstPlacemark)
                        
                        self.mapPlacemark = pm
                        
                        self.mapView?.addAnnotation(pm)
                        let region = MKCoordinateRegionMakeWithDistance(pm.coordinate, 500, 500)
                        self.mapView?.setRegion(region, animated: false)
                        
                    }
                }
            }
        }
    }
    
    @IBAction func emailButtonPressed(_ sender : UIButton) {
        if let email = detailItem?.email {
            if let url = URL(string:"mailto:\(email)") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func phoneButtonPressed(_ sender : UIButton) {
        if let phone = detailItem?.phone {
            if let url = URL(string:"tel://\(phone)") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func addressButtonPressed(_ sender : UIButton) {
        if let placemark = self.mapPlacemark {
            openMapForPlace(placemark.coordinate.latitude, long: placemark.coordinate.longitude)
        }
    }
    
    func openMapForPlace(_ lat:CLLocationDegrees,long:CLLocationDegrees) {
        let coordinates = CLLocationCoordinate2DMake(lat, long)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, 500, 500)
        let options = [
            MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate:regionSpan.center),
            MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan:regionSpan.span)
        ]
        let mapItem = MKMapItem(placemark: self.mapPlacemark!)
        
        var mapItemName = detailItem!.firstName!
        
        if let ln = detailItem!.lastName {
            mapItemName += " \(ln)"
        }
        
        mapItem.name = mapItemName
        
        mapItem.openInMaps(launchOptions: options)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSegue") {
            let controller = segue.destination as! AddViewController
            controller.person = detailItem
        }
    }


}

