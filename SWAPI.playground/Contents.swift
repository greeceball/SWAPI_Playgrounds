import Foundation


//struct TopLevelObject: Codable {
//    let count: Int
//    let entries: [Entry]
//}

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

struct Person: Codable {
    let name: String
    let films: [URL]
    
}

class SwapiService {
    private static let baseURL = URL(string: "https://swapi.co/api/")
    private static let filmsEndpoint = "films/"
    private static let peopleEndpoint = "people/"
    //private static let idNumber =
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let idURL = peopleURL.appendingPathComponent(String(id))
        // 2 - Contact server
        URLSession.shared.dataTask(with: idURL) {(data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else {return completion(nil)}
            // 5 - Decode Person from JSON
            do {
                // Set topLevelObject as the result of the decoding function
                let decodeData = try JSONDecoder().decode(Person.self, from: data)
                // Pull entries off of the topLevelObject
                
                // Send the entries back to the user
                return completion(decodeData)
                
            } catch {
                print("an error occurred: \(error) \(error.localizedDescription)")
                return completion(nil)
            }
            
        }.resume()
        
    }
    static func fetchFilm (person: Person, completion: @escaping (Film?) -> Void){
       
        let url = person.films[0]

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                error.localizedDescription
                print("Error: \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }

            do {
                let decodeData = try JSONDecoder().decode(Film.self, from: data)
                let films = decodeData
                return completion(films)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
        
        
    }
}
    SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        SwapiService.fetchFilm(person: person) { (film) in
            if let film = film{
                print("Film Title: \(film.title) ")
            }
        }
    print(person)
        
    }
}


