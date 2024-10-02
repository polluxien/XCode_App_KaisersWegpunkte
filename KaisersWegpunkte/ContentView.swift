//
//  ContentView.swift
//  KaisersWegpunkte
//
//  Created by Bennet Panzek on 24/11/2023.
//

import SwiftUI
import MapKit
import AVFoundation

enum zustände {
    case ROT
    case GELB
    case GRÜN
}

struct Kpunkt{
    var name: String
    var zustand: zustände
    var latitude: Double
    var logitude: Double
    var icon: String
    var info: String
    
    init(name: String, latitude: Double, logitude: Double, icon: String, info: String = "hat keine Info") {
        self.name = name
        self.zustand = .ROT
        self.latitude = latitude
        self.logitude = logitude
        self.icon = icon
        self.info = info
    }
}

struct ContentView: View {
    
    @StateObject var locationEnviroment = LocationEnviroment()
    @State private var player: AVAudioPlayer?
    
    private func playSound() {
        //guard stellt sicher das nachfolgende bedingung wahr ist
        //zum abfangen von fehlerbedingungen
        guard let url = Bundle.main.url(forResource: "Sound/Hupe", withExtension: "mp3") else {
             return
         }
         
         do {
             let sound = try AVAudioPlayer(contentsOf: url)
             self.player = sound
             sound.play()
         } catch let error {
             print("Fehler beim Abspielen des Sounds: \(error.localizedDescription)")
         }
      }
    
    // Punkte
    @State var punkteArr = [
        Kpunkt(name: "Späti", latitude: 52.505546, logitude: 13.332595, icon: "creditcard.trianglebadge.exclamationmark", info: "Sterni"),
        Kpunkt(name: "Perle", latitude: 52.504608, logitude: 13.342328, icon: "heart", info: "Blumen"),
        Kpunkt(name: "Casino", latitude: 52.517600, logitude: 13.397945, icon: "suit.spade", info: "Chips"),
        Kpunkt(name: "Berghain", latitude: 52.510682, logitude: 13.350893, icon: "door.french.closed", info: "Tanzbein"),
        Kpunkt(name: "Friseur", latitude: 52.507717, logitude: 13.409828, icon: "scissors", info: "Buzzcut"),
        Kpunkt(name: "Schlecker", latitude: 52.526717, logitude: 13.411828, icon: "cart", info: "Hafermilch")]
    
    //Farben ändern der Statis
    func darstellendeFarbe(_ punkt: Kpunkt) -> Color{
        if(punkt.zustand == .GRÜN){
            return Color(red: 0.5, green: 0.8, blue: 0.4)
        }
        if(punkt.zustand == .GELB){
            return Color(red: 0.95, green: 0.61, blue: 0.1)
        }
        return Color(red: 0.8,green: 0.4,blue: 0.4)
    }
    
    private func kordinatAbgleich(newKordinate: LocationEnviroment) {
        for index in punkteArr.indices{
            if(punkteArr[index].latitude == newKordinate.gpsLocation.coordinate.latitude &&
               punkteArr[index].logitude == newKordinate.gpsLocation.coordinate.longitude){
                
                //Farbe auf gelb wechseln
                punkteArr[index].zustand = .GELB
                
                //Signalton abgeben
                playSound()
            }
        }
    }
    
    //hier könnte ihre Funktion stehen
    
    var body: some View {
        Map(){
            ForEach(0..<punkteArr.count, id: \.self){ punktIndex in
                Annotation(punkteArr[punktIndex].name,
                           coordinate: CLLocationCoordinate2D(latitude: punkteArr[punktIndex].latitude, longitude: punkteArr[punktIndex].logitude),
                           anchor: .bottom){
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.background)
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(.secondary, lineWidth: 2.5)
                            .background(darstellendeFarbe(punkteArr[punktIndex]))
                        Image(systemName: punkteArr[punktIndex].icon)
                            .padding(5)
                    }
                }
            }
        }
        .onReceive(locationEnviroment.$gpsLocation) { newLocation in
            kordinatAbgleich(newKordinate: locationEnviroment)
        }
            .mapControls {
                MapUserLocationButton()
                MapScaleView()
                MapCompass()
                    .mapControlVisibility(.visible)
            }
            .mapStyle(.standard)
              .tabViewStyle(.page)
            
            Text("Erledigungen")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("Aktueller Standort:")
                .font(.footnote)
            Text("<\(locationEnviroment.gpsLocation.coordinate.latitude), \(locationEnviroment.gpsLocation.coordinate.longitude)>")
                .font(.footnote)
        
                
            VStack {
                ForEach(0..<2){ row in
                    HStack{
                        ForEach(0..<3, id: \.self){ colume in
                            VStack{
                                Button(action: {
                                    if(punkteArr[row * 3 + colume].zustand == .GELB){
                                        punkteArr[row * 3 + colume].zustand = .GRÜN
                                        print(punkteArr[row * 3 + colume].zustand)
                                    }
                                }) {
                                    Text(punkteArr[row * 3 + colume].name)
                                }
                                .frame(width: 75, height: 25)
                                .padding()
                                .background(darstellendeFarbe(punkteArr[row * 3 + colume]))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                
                                Text("Erin.: \(punkteArr[row * 3 + colume].info)")
                                    .font(.footnote)
                                    .foregroundColor(darstellendeFarbe(punkteArr[row * 3 + colume]))
                            }
                            .frame(width: 120, height: 75)
                            
                        }
                    }
                }
            }
        }
    }

#Preview {
    ContentView()
}

