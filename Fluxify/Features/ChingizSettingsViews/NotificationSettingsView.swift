//
//  NotificationSettingsView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//

import SwiftUI
import AVKit

struct NotificationSettingsView: View {
    @State private var notificationsEnabled: Bool = false
    @State private var soundEnabled: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // Sektion: Benachrichtigungen allgemein
                VStack(alignment: .leading, spacing: 12) {
                    Text("Konfiguration")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    VStack(spacing: 0) {
                        // Toggle für Benachrichtigungen
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Toggle("Push-Nachrichten", isOn: $notificationsEnabled)
                                .font(.system(size: 18, weight: .medium))
                        }
                        .padding()
                        .background(Color(UIColor.systemGray4))
                        
                        Divider()
                        
                        // Toggle für Sound mit Sound-Effekt
                        HStack {
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.green)
                                .frame(width: 30)
                            Toggle("Töne aktivieren", isOn: $soundEnabled)
                                .font(.system(size: 18, weight: .medium))
                        }
                        .padding()
                        .background(Color(UIColor.systemGray4))
                        // Hier nutzen wir deinen SoundManager!
                        .onChange(of: soundEnabled) { oldValue, newValue in
                            if newValue {
                                SoundManager.instance.playSound(sound: .tada)
                            }
                        }
                    }
                    .cornerRadius(12)
                }
                
                // Sektion: Sound Testen
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sound Testen")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    Button(action: {
                        SoundManager.instance.playSound(sound: .guitar)
                    }) {
                        HStack {
                            Image(systemName: "music.note")
                                .frame(width: 30)
                            Text("Gitarren-Sound abspielen")
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Image(systemName: "play.circle.fill")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
        }
        .navigationTitle("Benachrichtigung")
        .background(Color.white)
    }
}

import SwiftUI
import AVKit // Framework für Audio/Video. Wird genutzt für die Wiedergabe von Medien.

/// Eine 'class' wird hier gewählt, weil sie ein Referenztyp ist.
/// Das bedeutet, das Objekt bleibt im Speicher bestehen, solange die App läuft.
class SoundManager {
    
    /// 'static let instance' ist ein Singleton.
    /// Man nutzt es, damit die gesamte App auf denselben Player zugreift (z.B. damit Musik nicht doppelt spielt).
    static let instance = SoundManager()
    
    /// 'AVAudioPlayer' ist das Standard-Werkzeug für lokale Töne.
    /// Einsatz: System-Sounds, Spiele-Effekte oder kurze Sprachnotizen.
    var player: AVAudioPlayer?
    
    /// 'enum' (Enumeration) ist eine Liste fester Optionen.
    /// Nutzt man, um Tippfehler bei Dateinamen zu vermeiden (Type Safety).
    enum SoundOption: String {
        case tada
        case guitar
    }
    
    /// Eine Funktion bündelt Befehle. So muss man den 'do-catch' Block nicht jedes Mal neu schreiben.
    func playSound(sound: SoundOption) {
        
        /// 'guard let' prüft, ob die Datei existiert. Wenn nicht (nil), bricht sie sicher ab.
        /// Verhindert Abstürze, falls eine Datei im Bundle vergessen wurde.
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        /// 'do-catch' wird für Operationen genutzt, die fehlschlagen könnten (Error Handling).
        /// Wichtig bei: Internet-Anfragen, Dateien lesen oder Datenbank-Zugriffen.
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Fehler beim Abspielen: \(error.localizedDescription)")
        }
    }
}


struct SoundEffectView: View {
    
    /// '@State' ist eine Zustandsvariable.
    /// SwiftUI beobachtet diese: Ändert sich der Wert, wird die View automatisch neu gezeichnet.
    /// Anwendung: Login-Status, Formular-Eingaben, Filter-Einstellungen.
    @State private var isToggled: Bool = false
    
    var body: some View {
        
        /// 'VStack' (Vertical Stack) ordnet Elemente untereinander an.
        /// Das Fundament für fast jedes App-Layout (Listen, Menüs, Profile).
        VStack (spacing: 40) {
            
            // BUTTONS: Interaktive Elemente für einmalige Aktionen.
            Button(action: {
                SoundManager.instance.playSound(sound: .tada)
            }) {
                Text("Play sound 1")
                    .padding(.horizontal, 16)
                /// '.clipShape(Capsule())' wird für moderne, pillenförmige Buttons genutzt.
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            
            Button(action: {
                SoundManager.instance.playSound(sound: .guitar)
            }) {
                Text("Play sound 2")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            
            /// 'Toggle' ist ein Schalter für zwei Zustände (An/Aus).
            /// Das '$' (Binding) erlaubt dem Toggle, den Wert von 'isToggled' nicht nur zu lesen, sondern auch zu ändern.
            /// Anwendung: Dark Mode, Benachrichtigungen erlauben, Einstellungen speichern.
            Toggle(isOn: $isToggled) {
                Text("Sound aktivieren")
                    .font(.headline)
            }
            .padding()
            /// '.tint()' setzt die Akzentfarbe für interaktive Steuerelemente (wie den grünen Schalter).
            .tint(.green)
            
            /// '.onChange' ist ein Beobachter (Observer).
            /// Er reagiert sofort, wenn eine Variable ihren Wert ändert.
            /// Anwendung: Suche starten während der User tippt, oder wie hier: Sound bei Klick abspielen.
            .onChange(of: isToggled) { oldValue, newValue in
                /// 'newValue' ist der neue Zustand nach dem Klick.
                if newValue {
                    SoundManager.instance.playSound(sound: .tada)
                }
            }
        }
        .padding()
    }
}

#Preview {
    SoundEffectView()
}
