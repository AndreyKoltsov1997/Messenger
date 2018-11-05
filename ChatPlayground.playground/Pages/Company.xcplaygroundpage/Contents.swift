import UIKit

class Constants {
    // NOTE: Company-related names
    static let COMPANY_NAME = "ОАО 'КупиПродай Банк'"
    static let CEO_NAME = "Steve Jobs"
    static let PRODUCT_MANAGER_NAME = "Elon Musk"
    static let DEFAULT_DEVELOPER_NAME = "Andrey Koltsov"
    static let DEVELOPER_HASNT_BEEN_FOUND = "Developer with the requested ID hasn't been found"
    static let NO_EMPLOYEES_FOUND_MARK = "-"
    static let AMOUNT_OF_DEVELOPERS = 3
    
    // NOTE: Console-related constants
    static let COMMUNICATION_TRANSFER_MARK = " -> "
}


enum Employee {
    case developer
    case productManager
}

func notifyDestroyed(occupation position: String, employee name: String) {
    let classDestroyedNotification = "has been destroyed"
    let delimiter = " "
    print(position + delimiter + name + delimiter + classDestroyedNotification)
}

// MARK: - CEO

class CEO {
    // NOTE: CEO properties
    public let TAG = "[" + String(describing: CEO.self) + "]"
    public let name: String = Constants.CEO_NAME
    
    public var productManager: ProductManager?
    
    // NOTE: CEO LifeCycle
    deinit {
        notifyDestroyed(occupation: self.TAG, employee: self.name)
    }
    
    // NOTE: CEO Closures
    
    lazy var printDevelopers = { [weak self] in
        print(self!.TAG + "Developers: ")
        if let developers = self?.productManager?.getDevelopers() {
            for developer in developers {
                print("\t" + " - \(developer?.name ?? " with an unassigned name.")")
            }
        } else {
            print("Developers hasn't been set")
        }
    }
    
    lazy var printProductManager = { [weak self] in
        print(self!.TAG + "Product manager: \(self?.productManager?.name ?? " hasn't been assigned yet.")")
    }
    
    lazy var printHierarchy = { [weak self] in
        self?.productManager?.printHierarchy()
    }
    
    private func isDeveloper(_ employee: Employee) -> Bool {
        return employee == .developer
    }
    
    private func isProductManager(_ employee: Employee) -> Bool {
        return employee == .productManager
    }
    
    public func notifySpecificEmployee(from employee: Any, sender: Employee, message: String) {
        if (self.isDeveloper(sender)) {
            let developer = employee as! Developer
            self.logRequestToSelf(from: developer.name, content: message)
        } else if (self.isProductManager(sender)) {
            let productManager = employee as! ProductManager
            self.logRequestToSelf(from: productManager.name, content: message)
        }
    }
    
    private func logRequestToSelf(from sender: String, content message: String) {
        print("\t" + "\(sender)" + Constants.COMMUNICATION_TRANSFER_MARK + " CEO: \(message)")
    }
}

// MARK: - ProductManager

class ProductManager {
    public let TAG = "[" + String(describing: ProductManager.self) + "]"
    public let name: String = Constants.PRODUCT_MANAGER_NAME
    
    public weak var ceo: CEO?
    public var developers: [Developer?] = []
    
    // NOTE: ProductManager lifecycle
    
    deinit {
        notifyDestroyed(occupation: self.TAG, employee: self.name)
    }
    
    public func printHierarchy() {
        print("*** Hirarchy ***")
        
        let misleadingMessage = "requested employee hasn't been set yet"
        print("\t" + "CEO: \(self.ceo?.name ?? misleadingMessage)")
        print("\t" + "Product manager: \(self.name)")
        print("\t" + "Developers:")
        if (!developers.isEmpty) {
            for developer in self.developers {
                print("\t\t" + " -" + "\(developer?.name ?? "an unnamed developer")")
            }
        } else {
            print(Constants.NO_EMPLOYEES_FOUND_MARK)
        }
    }
    
    public func getDeveloper(withIdentifier number: Int) -> Developer? {
        return developers[number]
    }
    
    public func getDevelopers() -> [Developer?] {
        return developers
    }
    
    public func notifyCEO(employee: Any? = nil, sender: Employee = .productManager, message: String) {
        switch sender {
        case .productManager:
            ceo?.notifySpecificEmployee(from: self, sender: sender, message: message)
        case .developer:
            let developer = employee as! Developer
            ceo?.notifySpecificEmployee(from: developer, sender: sender, message: message)
        }
    }
    
    public func notifySpecificColleaque(developer: Developer, message: String) {
        print("\t" + self.TAG + "\(developer.name)" + Constants.COMMUNICATION_TRANSFER_MARK + " \(self.name): \(message)")
    }
}


// MARK: - Developer

class Developer {
    public let TAG = "[" + String(describing: Developer.self) + "]"
    public var name = Constants.DEFAULT_DEVELOPER_NAME
    
    weak var assignedManager: ProductManager?
    
    // NOTE: Lifecycle
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        notifyDestroyed(occupation: self.TAG, employee: self.name)
    }
    
    public func simulateCommunication(forProductManager messageForManager: String, forCEO messageForCEO: String) {
        self.notifyCEO(message: messageForCEO)
        self.notifyProductManager(message: messageForManager)
        let lineDelimiter = "\n"
        print(lineDelimiter)
    }
    
    public func notifySpecificEmployee(developer: Developer, message: String) {
        print(self.TAG + "\t" + "\(developer.name)" + Constants.COMMUNICATION_TRANSFER_MARK + "\(self.name): \(message)")
    }
    
    public func notifyCEO(message: String) {
        self.assignedManager?.notifyCEO(employee: self, sender: .developer, message: message)
    }
    
    public func notifyProductManager(message: String) {
        self.assignedManager?.notifySpecificColleaque(developer: self, message: message)
    }
    
    func notifyDeveloper(number: Int, message: String) {
        let developer = assignedManager?.getDeveloper(withIdentifier: number)
        developer?.notifySpecificEmployee(developer: self, message: message)
    }
}

// MARK: - Company

class Company {
    public let TAG = "[" + String(describing: Company.self) + "]"
    public let name = Constants.COMPANY_NAME
    
    var ceo: CEO?
    var productManager: ProductManager?
    var developers: [Developer?] = []
    
    deinit {
        notifyDestroyed(occupation: self.TAG, employee: self.name)
    }
    
    private func printCommunicationMessage(with message:String) {
        print("\n *** \(message) *** \n")
    }
    
    func simulateCommunaction() {
        // NOTE: performing every CEO closure except the one with hierarchy print
        printCommunicationMessage(with: "CEO's closures result: ")
        self.ceo?.printProductManager()
        self.ceo?.printDevelopers()
        
        // NOTE: Simulating communication
        printCommunicationMessage(with: "simulating communication")
        self.showDevelopersInternalCommunication()
        self.showDevelopersCommunicationWithStaff()
        
        print("\t Product manager -> CEO:")
        self.productManager?.notifyCEO(message: "Hey, CEO, I want more money.")
        printCommunicationMessage(with: "simulation is over")
        let lineDelimiter = "\n"
        print(lineDelimiter)
    }
    
    func showDevelopersInternalCommunication() {
        self.printCommunicationMessage(with: "Developers communicate between each other")
        let messageDelimiter = "."
        for sender in 0..<self.developers.count {
            for receiver in 0..<self.developers.count {
                if (sender == receiver) {
                    continue
                }
                let message = "message number " + String(sender) + messageDelimiter + String(receiver)
                self.developers[sender]?.notifyDeveloper(number: receiver, message: message)
            }
        }
    }
    
    func showDevelopersCommunicationWithStaff() {
        self.printCommunicationMessage(with: "Developers communicate with CEO & Product Manager")
        for developer in self.developers {
            let messageToCEO = "Hey, CEO, I want a promotion."
            let messateToPM = "Hey, product manager, I want you to review my code"
            developer?.simulateCommunication(forProductManager: messageToCEO, forCEO: messateToPM)
        }
    }
    
}

func generateDevelopers(for company: Company) -> [Developer?] {
    var developers: [Developer?] = []
    for developerID in 0..<Constants.AMOUNT_OF_DEVELOPERS {
        let actualNumber = developerID + 1
        developers += [Developer(name: "Developer [\(actualNumber)]")]
        developers[developerID]?.assignedManager = company.productManager
    }
    return developers
}

func getCompanyInstance() -> Company {
    let company = Company()
    company.ceo = CEO()
    company.productManager = ProductManager()
    company.productManager?.ceo = company.ceo
    company.ceo?.productManager = company.productManager
    company.developers = generateDevelopers(for: company)
    company.productManager?.developers = company.developers
    return company
}

// MARK: - Entry point

class Person {
    var dog: Dog?
    
    deinit {
        print("Person is deinitialized")
    }
}

class Dog {
    var person: Person?
    
    deinit {
        print("Dog is deinitialized")
    }
}

func main() {
    var person: Person? = Person()
    let dog = Dog()
    person?.dog = dog
    dog.person = person
    person = nil
}

main()

