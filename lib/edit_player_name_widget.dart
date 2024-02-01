import 'package:flutter/material.dart';
import 'components/applocal.dart';
import 'components/shared_pref_helper.dart';

class EditPlayerName extends StatelessWidget {
  EditPlayerName({
    super.key,
  });
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            Text("${getLang(context, "players_name")}",
                style: Theme.of(context).textTheme.displaySmall),
            TextField(
              controller: player1Controller,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: "${getLang(context, "player1")}",
              ),
            ),
            TextField(
              controller: player2Controller,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                labelText: "${getLang(context, "player2")}",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await SharedPreferencesHelper.savePlayer1Name(
                    player1Controller.text);
                await SharedPreferencesHelper.savePlayer2Name(
                    player2Controller.text);
              },
              child: Text("${getLang(context, "Save_names")}"),
            ),
          ],
        ),
      ),
    );
  }
}
