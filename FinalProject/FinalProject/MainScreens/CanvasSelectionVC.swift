//
//  CanvasSelectionVC.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

protocol FileGroupDelegate: AnyObject {
    func didSelect(group option: BasicTableCellModel)
}

class CanvasSelectionVC: UIViewController {
    
    let defaultScreenTitle = "All Notes"
    let persistenceManager = PersistenceManager.shared

    var collectionView: CanvasCollectionView!

    var canvasFiles: [DrawingModelDTO] = []
    var allFiles: [DrawingModelDTO] = []

    var filterOption: FileGroupOption = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCanvasFiles()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // Use collectionView.bounds to get the current available width
            let updatedLayout = Helper.collectionViewLayout(in: collectionView, with: 3)
            flowLayout.itemSize = updatedLayout.itemSize
            flowLayout.invalidateLayout()
        }
    }

    private func configureCollectionView() {
        collectionView = CanvasCollectionView(in: view)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setUpConstraints(in: view)
    }

    private func configureNavigationBar() {
        navigationItem.title = defaultScreenTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = newCanvasBTN()
        customizeNavBarAppearance()
    }

    private func customizeNavBarAppearance(_ color: UIColor? = nil) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        if let color {
            appearance.backgroundColor = color.withAlphaComponent(0.3)
        }
        else {
            appearance.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        }

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func newCanvasBTN() -> UIBarButtonItem {
        let newCanvasBTN = BasicNotesBTN(color: .systemBlue, title: "New", systemImage: "plus")
        newCanvasBTN.addTarget(self, action: #selector(createNewCanvas), for: .touchUpInside)
        return UIBarButtonItem(customView: newCanvasBTN)
    }

    @objc
    private func createNewCanvas() {
        let newDrawingModel = DrawingModelDTO()
        canvasFiles.append(newDrawingModel)
        let newCanvasVC = CanvasVC(drawingModel: newDrawingModel)
        newCanvasVC.modalPresentationStyle = .fullScreen
        present(newCanvasVC, animated: true)
    }

    private func loadCanvasFiles() {
        if let savedCanvasFiles = PersistenceManager.shared.getAllDrawings() {
            allFiles = savedCanvasFiles
            filterCanvasFiles()
        }

        refreshCollectionView()
    }

    private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func filterCanvasFiles() {
        if filterOption != .none {
            canvasFiles = allFiles.filter{ $0.group.color == filterOption.color }
            self.title = "\(filterOption.rawValue) Notes"
        }
        else {
            // All Selected - could be more robust...
            canvasFiles = allFiles
            self.title = defaultScreenTitle
        }
        customizeNavBarAppearance(filterOption.color)
    }
}

extension CanvasSelectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canvasFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let canvasFileCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CanvasFileCell.identifier,
            for: indexPath) as? CanvasFileCell
        else { return UICollectionViewCell() }

        canvasFileCell.updateCell(with: canvasFiles[indexPath.item])
        return canvasFileCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCanvasVC = CanvasVC(drawingModel: canvasFiles[indexPath.item])
        selectedCanvasVC.modalPresentationStyle = .fullScreen
        present(selectedCanvasVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let indexPath = indexPaths[0]
        let drawingModel = canvasFiles[indexPath.item]
        return UIContextMenuConfiguration(actionProvider: { suggestedActions in
            // Edit Name
            let editNameAction = UIAction(title: "Edit Name") { _ in
                let alertController = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)

                alertController.addTextField { textField in
                    textField.placeholder = "Enter new name"
                    textField.text = drawingModel.drawingName
                    textField.clearsOnBeginEditing = true
                }

                let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                    if let newName = alertController.textFields?.first?.text, !newName.isEmpty {
                        DispatchQueue.main.async {
                            drawingModel.drawingName = newName
                            collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true)
            }

            // Edit File Group
            let fileGroupMenu = UIMenu(title: "Group", children: FileGroupOption.allCases.map { option in
                UIAction(title: option.rawValue) { [weak self] _ in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        drawingModel.group = option
                        self.persistenceManager.updateDrawing(drawingModel)
                        if self.filterOption == .none || self.filterOption == option {
                            collectionView.reloadItems(at: [indexPath])
                        }
                        else {
                            self.filterCanvasFiles()
                            collectionView.reloadData()
                        }
                    }
                }
            })

            // Delete
            let deleteAction = UIAction(title: "Delete", attributes: .destructive) { _ in
                guard let drawingIdToDelete = drawingModel.id else { return }
                let alertController = UIAlertController(title: "Warning!",
                                                        message: "Deleting files cannot be reversed.",
                                                        preferredStyle: .alert)

                let saveAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                    guard let self else { return }
                    persistenceManager.deleteDrawing(with: drawingIdToDelete)
                    DispatchQueue.main.async {
                        self.allFiles.removeAll { $0.id == drawingIdToDelete }
                        self.filterCanvasFiles()
                        collectionView.reloadData()
                    }
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true)
            }

            return UIMenu(children: [editNameAction, fileGroupMenu, deleteAction])
        })
    }
}

extension CanvasSelectionVC: FileGroupDelegate {
    func didSelect(group option: BasicTableCellModel) {
        if let group = option.group {
            self.filterOption = group
            filterCanvasFiles()
            refreshCollectionView()
        }
        else {
            self.filterOption = .none
            filterCanvasFiles()
            refreshCollectionView()
        }
    }
}
