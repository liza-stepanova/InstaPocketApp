import UIKit

let maxCountPasscode: Int = 4

protocol PasscodePresenterProtocol: AnyObject {
    var isSetting: Bool { get set }
    var passcode: [Int] { get set }
    var templatePasscode: [Int]? {get set }
    
    func enterPasscode(number: Int)
    func removeLastItemInPasscode()
    func setNewPasscode()
    func checkPasscode()
    func clearPasscode(state: PasscodeState)
    
    init(view: PasscodeViewProtocol, passcodeState: PasscodeState, keychainManager: KeychainManagerProtocol, sceneDelegate: SceneDelegateProtocol?, isSetting: Bool)
}

class PasscodePresenter: PasscodePresenterProtocol {
    var templatePasscode: [Int]?
    var isSetting: Bool
    var passcode: [Int] = [] {
        didSet {
            if passcode.count == maxCountPasscode {
                switch passcodeState {
                case .inputPasscode:
                    self.checkPasscode()
                case .setNewPasscode:
                    self.setNewPasscode()
                default:
                    break
                }
            }
        }
    }
    
    weak var view: PasscodeViewProtocol?
    var passcodeState: PasscodeState
    var keychainManager: KeychainManagerProtocol
    var sceneDelegate: SceneDelegateProtocol?
    
    required init(view: PasscodeViewProtocol, passcodeState: PasscodeState, keychainManager: KeychainManagerProtocol, sceneDelegate: SceneDelegateProtocol?, isSetting: Bool) {
        self.view = view
        self.passcodeState = passcodeState
        self.keychainManager = keychainManager
        self.sceneDelegate = sceneDelegate
        self.isSetting = isSetting
        
        view.passcodeState(state: passcodeState)
    }
    
    func enterPasscode(number: Int) {
        if passcode.count < maxCountPasscode {
            passcode.append(number)
            view?.enterCode(code: passcode)
        }
    }
    
    func removeLastItemInPasscode() {
        if !passcode.isEmpty  {
            self.passcode.removeLast()
            view?.enterCode(code: passcode)
        }
    }
    
    func setNewPasscode() {
        if templatePasscode != nil {
            if templatePasscode == passcode {
                
                let stringPasscode = passcode.map { String($0) }.joined()
                keychainManager.save(key: KeychainKeys.passcode.rawValue, value: stringPasscode)
                self.sceneDelegate?.startMainScreen()
                
                if isSetting {
                    NotificationCenter.default.post(name: .dismissPasscode, object: nil)
                } else {
                    passcodeState = .inputPasscode
                    self.clearPasscode(state: .inputPasscode)
                }
                
            } else {
                self.view?.passcodeState(state: .wrongPasscode)
            }
        } else {
            templatePasscode = passcode
            self.clearPasscode(state: .repeatPasscode)
        }
    }
    
    func checkPasscode() {
        let keychainPasscodeResult = keychainManager.load(key: KeychainKeys.passcode.rawValue)
        switch keychainPasscodeResult {
            
        case .success(let code):
            if self.passcode == code.digits {
                self.sceneDelegate?.startMainScreen()
            } else {
                self.clearPasscode(state: .wrongPasscode)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func clearPasscode(state: PasscodeState) {
        self.passcode = []
        self.view?.enterCode(code: [])
        self.view?.passcodeState(state: state)
    }
    
}

enum PasscodeState: String {
    case inputPasscode, wrongPasscode, setNewPasscode, repeatPasscode, codeMismatch
    
    func getPasscodeLabel() -> String {
        switch self {
        case .inputPasscode:
            return "Введите пароль"
        case .wrongPasscode:
            return "Неверный пароль"
        case .setNewPasscode:
            return "Установить пароль"
        case .repeatPasscode:
            return "Повторите пароль"
        case .codeMismatch:
            return "Пароли не совпадают"
        }
    }
}
