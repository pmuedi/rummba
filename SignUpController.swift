//
//  SignUpController.swift
//  UberClone
//
//  Created by Paulo Muedi on 1/6/21.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "RUMMBA" // Nome do label
        label.font = UIFont(name: "Avenir-Light", size: 36)// tipo de letra e tamanho de label
        label.textColor = UIColor(white: 1, alpha: 0.8) // cor de lebel
        return label
        
    }()
    
    
    private lazy var emailContainerView: UIView = { // criar um container para colacar o email
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-new-post-30"), textfield: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    private lazy var fullNameContainerView: UIView = { // criar um container para colacar o full name
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-user-male-30"), textfield: nameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    
    private lazy var passwordContainerView: UIView = { // criar um container para colacar o password
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-password-50"), textfield: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    private lazy var accountContainerView: UIView = { // criar um container para colacar o segmento de escolha
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-male-user-50"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    
    
    private let emailTextField: UITextField = { // definimos a emailtextfield
     
        return UITextField().textfield(withPlaceholder: "Email", isSecureTextEntry: false)
        
    }()
    
    
    private let nameTextField: UITextField = { // definimos a nametextfield
     
        return UITextField().textfield(withPlaceholder: "Full Name", isSecureTextEntry: false)
        
    }()
    
    
    private let passwordTextField: UITextField = { // definimos a passwordtextfield
       
        return UITextField().textfield(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = { // difinimos o segmento de escolha
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    private let SignUpButton: UIButton = { // Botao de Sign Up
        let button = UIButton(type: .system)
        button.setTitle("Sigin Up", for: .normal)
        button.setTitleColor(UIColor(white:1, alpha: 0.5), for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside) // accao salvar da bd
        return button
    }()
    
    
    // opcao ja tenho conta (Butao)
    let HaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: " Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)//accao no batao login ja tenho conta
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        TelaPrincao()
        
    }
    
    // MARK: - Selectores
    
    
    func TelaPrincao()  // funcao que adiciona os elementos na tela
    {
       // configureNavigationBar()
        view.backgroundColor = .backgroundColor // cor de fundo da tela
        
        view.addSubview(titleLabel) // adicionar o label na tela
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true // centrar o texto
       
        // criar um stack view para color os elementos na tela ao mesmo tempo
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,  fullNameContainerView, passwordContainerView, accountContainerView, SignUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(HaveAccountButton)
        HaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true//centrar o texto
        HaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
        
        
    }
    
    @objc func handleShowLogin() // funcao da accoa do butao ja tenho conta
    {
        print(123)
        let controller = ViewController() // chamar a janela de login
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleSignUp()  // funcao do butao sign Up
    {
        guard let email = emailTextField.text else {return}
        guard let fullname = nameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("Failed to registeruser with error \(error)")
                return
            }
            guard let uid = result?.user.uid else {return}
            
            let values = ["email": email, "fullname": fullname, "accountType":accountTypeIndex] as [String : Any]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController
                else
                 {
                    return
                    
                }
                controller.configureUI()
                self.dismiss(animated: true, completion: nil)
                //print("Successfully Register User")
            })
            
            
        }
        
        //print (email)
       // print (password)
        
    }
    
    
}
