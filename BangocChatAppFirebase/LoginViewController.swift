
//  LoginViewController.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/9/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var messageController: MessagesController?
    
    let inputContainerView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 5
        
        view.layer.masksToBounds = true
        
        return view
    }()
    
    
    lazy var loginRegisterButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.setRgb(r: 80, g: 101, b: 161)

        button.setTitle("Register", for: .normal)
        
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 5
        
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
       // button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        button.addTarget(self, action: #selector(handleRegisterAndLogin), for: .touchUpInside)
        
        return button
        
    }()
    
    func handleRegisterAndLogin(){
        if (loginRegisterSegmentedControl.selectedSegmentIndex == 0){
                handleLogin()
        }else{
            handleRegister()
        }
    }
    
    
    func handleLogin(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if(error != nil){
                print(error)
                return
            }
            
            self.messageController?.fetchUserAndSetupNavBar()
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    

    
    let nameTextField: UITextField = {
        
        let textField = UITextField()
        
        textField.placeholder = "Name"
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    let nameSeparatorView : UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.setRgb(r: 220, g: 220, b: 220)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    
    }()

    let emailTextField: UITextField = {
        
        let textField = UITextField()
        
        textField.placeholder = "Email"
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    let emailSeparatorView : UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.setRgb(r: 220, g: 220, b: 220)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    let passwordTextField: UITextField = {
        
        let textField = UITextField()
        
        textField.placeholder = "Password"
        
        textField.isSecureTextEntry = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
        
    }()
    
    let profileImageView: UIImageView = {
    
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "facebook")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.isUserInteractionEnabled = true
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    
    }()
    

    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let controller =  UISegmentedControl(items: ["Login", "Register"])
        controller.translatesAutoresizingMaskIntoConstraints = false
        controller.tintColor = UIColor(white: 1, alpha: 1)
        controller.selectedSegmentIndex = 0
        
        controller.addTarget(self, action: #selector(handleLoginRegisterButtonChange), for: .valueChanged)
        return controller
    }()
    
    func handleLoginRegisterButtonChange(){
//        print("123")
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of inputContainerView
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        
        
        nameTextFieldHeightAnchor?.isActive = false
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        
        nameTextFieldHeightAnchor?.isActive = true
        
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        
        
        
        
        emailTextFieldHeightAnchor?.isActive = false
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3 )
        
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3 )
        
        passwordTextFieldHeightAnchor?.isActive = true
        

        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1.0)
        view.backgroundColor = UIColor.setRgb(r:61, g: 91, b: 151)
        
        addSubViews()
        
        handleLoginRegisterButtonChange()
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        
        profileImageView.addGestureRecognizer(tap)

    }
    
    
    func setupProfileImageView(){
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -40).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupInputsContainerView(){
        //Changed
        
        //x, y, width, height
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        
        inputContainerView.addSubview(nameTextField)
        
        //x, y, width, height
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        nameTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameSeparatorView)
        
        //x, y, width, height
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(emailTextField)
        
        //x, y, width, height

        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(emailSeparatorView)
        
        //x, y, width, height
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(passwordTextField)
        
        //x, y, width, height
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        passwordTextFieldHeightAnchor?.isActive = true
        

    }
    
    func setupLoginRegisterButton(){
        
        //x, y, width, height
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    
    }
    
    func setupLoginRegisterSegmentedControl(){
        //x, y, width, height
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        
        // Set height of name textField to 0
        

    }
    

    
    
    func addSubViews(){
        
        view.addSubview(inputContainerView)
        
        view.addSubview(loginRegisterButton)
        
        view.addSubview(profileImageView)
        
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        
        setupLoginRegisterButton()
        
        setupProfileImageView()
        
        setupLoginRegisterSegmentedControl()
        

    }
    
    //Changed
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

    }
    
}

extension UIColor{

    static func setRgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}
