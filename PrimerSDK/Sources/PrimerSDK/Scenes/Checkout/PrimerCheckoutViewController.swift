//
//  PrimerCheckoutViewController.swift
//  
//
//  Created by Fernando Menendez on 04/10/2021.
//

import Foundation
import UIKit

public class PrimerCheckoutViewController : UIViewController {
    
    private let theme : PrimerTheme
    private var viewModel : PrimerCheckoutViewModel
    
    @IBOutlet weak var paymentLoadingView: ProcessingPaymentStatusView!
    @IBOutlet weak var innerContainerView: UIView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: PrimerTextField!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var expiryMonth: PrimerTextField!
    @IBOutlet weak var expiryYear: PrimerTextField!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var cvvTextField: PrimerTextField!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    @IBOutlet weak var nameTextField: PrimerTextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var loadingView: PrimerCheckoutLoadingView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    public init(viewModel : PrimerCheckoutViewModel, theme : PrimerTheme) {
        self.theme = theme
        self.viewModel = viewModel
        super.init(nibName: "PrimerCheckoutViewController",
                   bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        configureView()
        configureObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    private func configureView() {
        innerContainerView.layer.cornerRadius = theme.cornerRadiusTheme.sheet
        cardNumberTextField.layer.cornerRadius = theme.cornerRadiusTheme.textfields
        expiryMonth.layer.cornerRadius = theme.cornerRadiusTheme.textfields
        cvvTextField.layer.cornerRadius = theme.cornerRadiusTheme.textfields
        nameTextField.layer.cornerRadius = theme.cornerRadiusTheme.textfields
        payButton.backgroundColor = theme.paymentButtonColor
        payButton.layer.cornerRadius = theme.cornerRadiusTheme.buttons
        payButton.setTitle(viewModel.buttonLabel, for: .normal)
        
        innerContainerView.backgroundColor = theme.colorTheme.background
        loadingView.backgroundColor = theme.colorTheme.background
        nameOnCardLabel.textColor = theme.colorTheme.label
        cvvLabel.textColor = theme.colorTheme.label
        cardNumberLabel.textColor = theme.colorTheme.label
        expiryLabel.textColor = theme.colorTheme.label
        yearLabel.textColor = theme.colorTheme.label
        monthLabel.textColor = theme.colorTheme.label
        
        loadingView.loadingTintColor = theme.colorTheme.loadingTintColor
        
        cardNumberTextField.textContentType = .creditCardNumber
        cvvTextField.textContentType = .creditCardNumber
        expiryMonth.textContentType = .creditCardNumber
        expiryYear.textContentType = .creditCardNumber
    }
    
    private func configureObservers() {
        super.viewDidLoad()
        configureKeyboardObservers()
        configureValidationObservers()
        configureLoadingObservers()
        configureTextFieldsObservers()
    }
    
    private func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func configureTextFieldsObservers() {
        nameTextField.textBinding = viewModel.holderName
        cardNumberTextField.textBinding = viewModel.cardNumber
        cvvTextField.textBinding = viewModel.cvv
        expiryMonth.textBinding = viewModel.expiryMonth
        expiryYear.textBinding = viewModel.expiryYear
    }
    
    private func configureValidationObservers() {
        viewModel.isFormValid.bind { [weak self] isFormValid in
            guard let self = self else {
                return
            }
            self.payButton.isEnabled = isFormValid
        }
    }
    
    private func configureLoadingObservers() {
        viewModel.isLoadingAccessToken.bind { [weak self] isLoading in
            guard let self = self else {
                return
            }
            if isLoading {
                UIView.animate(withDuration: 1.0, animations: {
                    self.loadingView.alpha = 1.0
                }, completion: { _ in
                    self.loadingView.isHidden = false
                })
                
            } else {
                UIView.animate(withDuration: 1.0, animations: {
                    self.loadingView.alpha = 0.0
                }, completion: { _ in
                    self.loadingView.isHidden = true
                })
            }
        }
        
        viewModel.state.bind { [weak self] state in
            guard let self = self else {
                return
            }
            self.paymentLoadingView.state = state
            switch state {
            case .success:
                self.paymentLoadingView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                }
            case .error:
                self.paymentLoadingView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                }
            case .ready:
                self.paymentLoadingView.isHidden = true
            case .processing:
                self.paymentLoadingView.isHidden = false
            }
        }
    }
    
    
    @IBAction func payButtonPressed(_ sender: Any) {
        viewModel.processPayment()
    }
}


// MARK: Keyboard's Notifications
extension PrimerCheckoutViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
