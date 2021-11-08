import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_o_app/models.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String activePlayer = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child:
        // MediaQuery.of(context).orientation==Orientation.portrait?
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SwitchListTile.adaptive(
                title: Text(
                  "Turn on/off two players",
                  style: Theme.of(context).textTheme.headline5,
                ),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ),
            Text(
              "IT'S $activePlayer TURN",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.white),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(16),
                children: List.generate(
                    9,
                    (index) => InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: gameOver ? null : () => onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                              Player.playerX.contains(index)
                                  ? "X"
                                  : Player.playerO.contains(index)
                                      ? "O"
                                      : "",
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Player.playerX.contains(index)
                                      ? Colors.blue
                                      : Colors.red),
                            )),
                          ),
                        )),
              ),
            ),
            Text(
              result,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  Player.playerO = [];
                  Player.playerX = [];
                  activePlayer = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text("Repeat the game"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).splashColor)),
            )
          ],
        )
            //   :
            // Row(
            //   children: [
            //     Expanded(
            //       child: Column(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: SwitchListTile.adaptive(
            //               title: Text(
            //                 "Turn on/off two players",
            //                 style: Theme.of(context).textTheme.headline5,
            //               ),
            //               value: isSwitched,
            //               onChanged: (value) {
            //                 setState(() {
            //                   isSwitched = value;
            //                 });
            //               },
            //             ),
            //           ),
            //           Text(
            //             "IT'S $activePlayer TURN",
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 50,
            //                 color: Colors.white),
            //           ),
            //           Text(
            //             result,
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 40,
            //                 color: Colors.white),
            //           ),
            //           ElevatedButton.icon(
            //             onPressed: () {
            //               setState(() {
            //                 Player.playerO = [];
            //                 Player.playerX = [];
            //                 activePlayer = "X";
            //                 gameOver = false;
            //                 turn = 0;
            //                 result = "";
            //               });
            //             },
            //             icon: const Icon(Icons.replay),
            //             label: const Text("Repeat the game"),
            //             style: ButtonStyle(
            //                 backgroundColor:
            //                 MaterialStateProperty.all(Theme.of(context).splashColor)),
            //           )
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //       child: GridView.count(
            //         crossAxisCount: 3,
            //         mainAxisSpacing: 8.0,
            //         crossAxisSpacing: 8.0,
            //         childAspectRatio: 1.0,
            //         padding: const EdgeInsets.all(16),
            //         children: List.generate(
            //             9,
            //                 (index) => InkWell(
            //               borderRadius: BorderRadius.circular(10),
            //               onTap: gameOver ? null : () => onTap(index),
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   color: Theme.of(context).shadowColor,
            //                   borderRadius: BorderRadius.circular(10),
            //                 ),
            //                 child: Center(
            //                     child: Text(
            //                       Player.playerX.contains(index)
            //                           ? "X"
            //                           : Player.playerO.contains(index)
            //                           ? "O"
            //                           : "",
            //                       style: TextStyle(
            //                           fontSize: 50,
            //                           color: Player.playerX.contains(index)
            //                               ? Colors.blue
            //                               : Colors.red),
            //                     )),
            //               ),
            //             )),
            //       ),
            //     ),
            //
            //   ],
            // )
      ),
    );
  }

  onTap(int index) async{
    if ((Player.playerO.isEmpty || !Player.playerO.contains(index)) &&
        (Player.playerX.isEmpty || !Player.playerX.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
    }
    if(!isSwitched&&!gameOver && turn !=9){
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == "X") ? "O" : "X";
      turn++;

      String winnerPlayer=game.checkWinner();

      if(winnerPlayer !=''){
        gameOver=true;
        result='$winnerPlayer is a winner';
      }
      else if (!gameOver && turn==9){
        result='it\'s draw!';
      }

    });
  }
}
