//
//  HomeController.swift
//  UberClone
//
//  Created by Paulo Muedi on 1/16/21.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController{
    
    // MARK: - Properties
    
    private let mapview = MKMapView() // chamar a propriedade map
    private let locationManager = CLLocationManager() // propriedade para permitir a localizacao
    
    //private let inputActivationView = LocationInputActivationView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn() // chamar a funcao se o usuario esta logado
        //view.backgroundColor = .red
        enableLoacationServices() //chamar a funcao da permisao da localizacao
        signOut()
      
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() // funcao para verficar se o usuario esta logado
    {
        if Auth.auth().currentUser?.uid == nil{
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: ViewController()) // chamar a janela de login quando o usuario nao esta logado
                self.present(nav, animated: true, completion: nil)
            }
            print("DEBUG: User not logged in..")
        }
        else{
            configureUI() // carregar o mapa na tela quando o usuario esta logado
            
           // print("DEBUG: User id is \(Auth.auth().currentUser?.uid)")
        }
    }
    
    func signOut() // funcao para fazer logout
    {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("DEBUG: Error signing out")
        }
    }
    
// MARK: - Helper Function
    func configureUI()
    {
        
     configureMaview()
       // view.addSubview(inputActivationView)
       // inputActivationView.centerX(inView: view)
       // inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        //inputActivationView.anchor(top: view.topAnchor, paddingTop: 32)
        
        
    }
    
    func configureMaview() // funcao que cria o mapa
    {
        view.addSubview(mapview)
        mapview.frame = view.frame
        mapview.showsUserLocation = true // Colocar as coordenandas do usuario no mapa a sua localizacao
        mapview.userTrackingMode = .follow // Geolocation do usuario
    }
}
// MARK: - LocationServices

   extension HomeController: CLLocationManagerDelegate{
    func enableLoacationServices() // funcao que terminar para usuarios permitir a localizacao
    {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus()
        {
        
        case .notDetermined:
            print("DEBUG: Not determined..")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always..")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use..")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}
