import Foundation

struct User: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var password: String
    var username: String
    var streak: Int = 0
    var league: String = "Bronze"
    var savedTasks: [Task] = []
}

//password decoding example
extension User {
    func isPasswordValid(inputPassword: String) -> Bool {
        return inputPassword == password
    }
}