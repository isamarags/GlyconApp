import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onDeleteConfirmed;

  DeleteConfirmationDialog({required this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmar exclusão"),
      content: Text("Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita."),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo
          },
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            onDeleteConfirmed();
            Navigator.of(context).pop(); // Fecha o diálogo
          },
          child: Text(
            "Excluir",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
