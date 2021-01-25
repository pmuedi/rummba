//
//  ViewController.swift
//  UberClone
//
//  Created by Paulo Muedi on 1/2/21.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    //MARK: - Properties
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
    
    private lazy var passwordContainerView: UIView = { // criar um container para colacar o password
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-password-50"), textfield: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    private let emailTextField: UITextField = { // definimos a emailtextfield
     
        return UITextField().textfield(withPlaceholder: "Email", isSecureTextEntry: false)
        
    }()
    
    private let passwordTextField: UITextField = { // definimos a passwordtextfield
       
        return UITextField().textfield(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton: UIButton = { // Botao de Login
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(white:1, alpha: 0.5), for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside) // Accao do butao para login
        return button
    }()
    
    // opcao nao tenho conta (Butao)
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)//accao no batao signup
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    // MARK: -Lifecycle
    
    override func viewDidLoad() { // tela inicial
        super.viewDidLoad()
        TelaPrincao() // carregar a funcao da tela
        
       
    }
    //override var preferredStatusBarStyle: UIStatusBarStyle{ // manter a barra de status branco
    //    return .lightContent
   // }
    
    // MARK: - Selectores
    
    @objc func handleShowSignUp() // funcao da accoa do butao sign up
    {
        print(123)
        let controller = SignUpController() // chamar a janela signupcontroller
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: funcao principal da tela

    func TelaPrincao()
    {
        configureNavigationBar()
        view.backgroundColor = .backgroundColor // cor de fundo da tela
        
        view.addSubview(titleLabel) // adicionar o label na tela
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true // centrar o texto
       
        // criar um stack view para color os elementos na tela ao mesmo tempo
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        //adicionar o botao nao tenho conta na tela
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true//centrar o texto
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
        
    }
    
    func configureNavigationBar() // funcao para estilo da barra de menu
    {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    @objc func handleLogin() // funcao que permite fazer o login
    {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to login user Error \(error.localizedDescription)")
                return
            }
            
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController
            else
             {
                return
                
            }
            controller.configureUI()
            self.dismiss(animated: true, completion: nil)
           // print("Succesfully logged user")
        }
        
    }

    
}


