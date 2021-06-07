//
//  ViewController.swift
//  Notas Diarias
//
//  Created by Renilson Santana on 07/06/21.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
    
    // MARK: - Atributos
    
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var texto: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func salvar(_ sender: Any) {
        salvarAnotacoes()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if anotacao != nil{
            if let textoRecebido = anotacao.value(forKey: "texto") as? String{
                self.texto.text = textoRecebido
            }
        }
        
        self.texto.becomeFirstResponder()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    // MARK: - Metodos
    
    func salvarAnotacoes(){
        var msg = ""
        //Atualiza Anotacao existente
        if anotacao != nil{
            anotacao.setValue(texto.text, forKey: "texto")
            anotacao.setValue(Date(), forKey: "data")
            msg = "Anotacão atualizada com sucesso"
        } else{
            //Salva nova Anotacao
            anotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
            anotacao.setValue(texto.text, forKey: "texto")
            anotacao.setValue(Date(), forKey: "data")
            msg = "Anotacão salva com sucesso"
        }
        
        do{
            try context.save()
            //alert(msg: msg)
        } catch{
            print("Erro: \(error.localizedDescription)")
        }
    }
    
    func alert(msg: String){
        let alerta = UIAlertController(title: "Sucesso", message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alerta.addAction(ok)
        
        self.navigationController!.viewControllers[0].present(alerta, animated: true, completion: nil)
    }
    
}

