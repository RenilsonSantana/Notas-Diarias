//
//  TableViewController.swift
//  Notas Diarias
//
//  Created by Renilson Santana on 07/06/21.
//

import UIKit
import CoreData

class ListarTableViewController: UITableViewController {
    
    // MARK: - Atributos
    
    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperaAnotacoes()
        tableView.reloadData()
    }
    
    // MARK: - Metodos
    
    func recuperaAnotacoes(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        
        do{
            let anotacoesRecebidas = try self.context.fetch(requisicao)
            anotacoes = anotacoesRecebidas as! [NSManagedObject]
        } catch{
            print("Erro: \(error.localizedDescription)")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.anotacoes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let anotacao = anotacoes[indexPath.row]
        let textoRecuperado = anotacao.value(forKey: "texto") as? String
        let dataRecuperada = anotacao.value(forKey: "data") as! Date
        
        //Formatar data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        let dataFormatada = dateFormatter.string(from: dataRecuperada)
        
        celula.textLabel?.text = textoRecuperado
        celula.detailTextLabel?.text = String(describing: dataFormatada)

        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let anotacao = self.anotacoes[indexPath.row]
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let anotacao = anotacoes[indexPath.row]
            context.delete(anotacao)
            anotacoes.remove(at: indexPath.row)
            do{
                try context.save()
            } catch{
                print("Erro: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verAnotacao"{
            let viewDestino = segue.destination as! AnotacaoViewController
            viewDestino.anotacao = sender as? NSManagedObject
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
