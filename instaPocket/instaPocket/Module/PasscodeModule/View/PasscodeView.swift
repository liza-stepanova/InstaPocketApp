import UIKit

protocol PasscodeViewProtocol: AnyObject {
    func passcodeState(state: PasscodeState)
    func enterCode(code: [Int])
}

class PasscodeView: UIViewController {

    var passcodePresenter: PasscodePresenterProtocol!
    private let numberButtons: [ [Int] ] = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [0]]
    
    private lazy var passcodeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var keyboardStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.alignment = .center
        
        return stack
    }()
    
    private lazy var codeStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 20
        
        
        return stack
    }()
    
    private lazy var deleteBtn: UIButton = {
        let button = UIButton(primaryAction: deleteCodeAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.setBackgroundImage(UIImage(systemName: "delete.left"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    lazy var enterCodeAction =  UIAction { [weak self] sender in
        guard let self = self, let sender = sender.sender as? UIButton else { return }
        
        self.passcodePresenter.enterPasscode(number: sender.tag)
    }
    
    lazy var deleteCodeAction = UIAction { [weak self] sender in
        guard let self = self, let sender = sender.sender as? UIButton else { return }
        
        self.passcodePresenter.removeLastItemInPasscode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPasscodeView), name: .dismissPasscode, object: nil)

        view.backgroundColor = .appMain
        [keyboardStack, deleteBtn, codeStack, passcodeTitle].forEach{
            view.addSubview($0)
        }
        
        numberButtons.forEach{
            let buttonLine = setHorizontalNumstack(range: $0)
            keyboardStack.addArrangedSubview(buttonLine)
        }
        
        (11...14).forEach{
            let view = getCodeView(tag: $0)
            codeStack.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            passcodeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passcodeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            
            codeStack.topAnchor.constraint(equalTo: passcodeTitle.bottomAnchor, constant: 40),
            codeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            keyboardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            keyboardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            keyboardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyboardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            
            deleteBtn.rightAnchor.constraint(equalTo: keyboardStack.rightAnchor, constant: -20),
            deleteBtn.bottomAnchor.constraint(equalTo: keyboardStack.bottomAnchor, constant: -25)
        ])
    }
    
    @objc func dismissPasscodeView() {
        dismiss(animated: true)
    }

}

extension PasscodeView {
    private func getHorizontalNumStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 50
        
        return stack
    }
    
    private func setHorizontalNumstack(range: [Int]) -> UIStackView {
        let stack = getHorizontalNumStack()
        for num in range {
            let numButton = UIButton(primaryAction: enterCodeAction)
            numButton.tag = num
            numButton.setTitle("\(num)", for: .normal)
            numButton.setTitleColor(.white, for: .normal)
            numButton.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .light)
            numButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
            stack.addArrangedSubview(numButton)
        }
        
        return stack
    }
    
    private func getCodeView(tag: Int) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.tag = tag
        
        return view
    }
}

extension PasscodeView: PasscodeViewProtocol {
    func enterCode(code: [Int]) {
        let tag = code.count + 10
        (tag...14).forEach {
            view.viewWithTag($0)?.backgroundColor = .none
        }
        view.viewWithTag(tag)?.backgroundColor = .white
    }
    
    func passcodeState(state: PasscodeState) {
        passcodeTitle.text = state.getPasscodeLabel()
    }
    
    
}
