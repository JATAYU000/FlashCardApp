import 'dart:convert';
// import 'package:swipe_widget/swipe_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/flashcard.dart';
import 'package:testapp/flashcard_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(MaterialApp(
    title: 'Formulizer',
    // ignore: prefer_const_constructors
    home: NoteHomePage(),
  ));
}


// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.test});
  
  final String test;
  @override
  State<StatefulWidget> createState() => _MyAppState();
  print(test) {
    throw UnimplementedError();
  }  
}

class _MyAppState extends State<MyApp> {
  
  List<FlashCard> flashcards = List.empty(growable: true);

  //$$F_{e n}=-\frac{4}{3} E \sqrt{r \delta_n^{3 / 2} n}$$  
  //$$\sum_i \vec{F}_i=m \frac{d \vec{v}}{d t}$$
  //$$x=\frac{-b \pm \sqrt{b^2-4 a c}}{2 a}$$
  //$$D=\sqrt{\left(x_2-x_1\right)^2-\left(y_2-y_1\right)^2}$$

  List<FlashCard> filteredcards = List.empty(growable: true);
  int _currentIndex = 0;
  final eqController = TextEditingController();
  final frmController = TextEditingController();
  late SharedPreferences sp;
  int a =1;
  bool condition = true;
  final List<String> _notes = [];
  @override
  void initState() {
    super.initState();
    readFromSp();
    setState(() {
      
      
    });
  }
  getSharedPref() async {
    sp = await SharedPreferences.getInstance();
  }
  saveIntoSp() async{
    sp = await SharedPreferences.getInstance();
    List<String> flashcardstring = flashcards.map((cardz)=> jsonEncode(cardz.toJson())).toList();
    sp.setStringList('mydata',flashcardstring);
    readFromSp();
  }
  readFromSp() async{
    sp = await SharedPreferences.getInstance();
    List<String>? cardread = sp.getStringList('mydata');
    
    if (cardread!=null){
      flashcards = cardread.map((cardz)=> FlashCard.fromJson(json.decode(cardz))).toList();
    }
    // debugPrint("flash List: ${flashcards[0].topic}");
    setState(() {
      filteredcards = flashcards.where((card) =>card.topic==widget.test).toList();
      // debugPrint("Custom List: ${jsonEncode(filteredcards)}");
    });
  }
  _loadNotes({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes.addAll(prefs.getStringList(key) ?? []);
    });
  }
  @override
  Widget build(BuildContext context) {
    // debugPrint("Custom List: ${jsonEncode(filteredcards)}");
    // debugPrint("flash List: ${flashCardToJson(flashcards)}");
    return Scaffold(
        body: filteredcards.isEmpty
            // ignore: prefer_const_constructors
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const  Text('No flash cards available.'),
                    OutlinedButton.icon(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.abc),
                label: const Text("data")
                ),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Card(
                    elevation: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("Equation of:"),
                          TextField(
                            controller: eqController,
                            decoration: const InputDecoration(
                              hintText: 'Enter the statement',
                            ),
                          ),
                          const Text("Formula:"),
                          TextField(
                            controller: frmController,
                            decoration: const InputDecoration(
                              hintText: 'Enter with or without latex',
                            ),

                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              String equation = eqController.text;
                              String formula = frmController.text;
                              if (equation.isNotEmpty) {
                                if (formula.isNotEmpty) {
                                  eqController.clear();
                                  frmController.clear();
                                  setState(() {
                                    flashcards.add(FlashCard(topic: widget.test,question: equation, answer: formula));
                                });
                                saveIntoSp();
                                }
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                          ),
                      ]
                      )       
                    )
                    ),
                  ),
                  ],
                )
                
                
              )
            :Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 250,
                  height: 250,
                  child: GestureDetector(
                    onPanUpdate: (details) {

                      // Swiping in right direction.
                      if(a==1){
                      if (details.delta.dx > 0) {
                        a=0;
                        print("next swipe");
                        showNextCard();}

                      // Swiping in left direction.
                      if (details.delta.dx < 0) {
                        a=0;
                        print("prev swipe");
                        showPreviousCard();}
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                        // a=1;
                        print(details);
                    },
                    onTap: () {
                      //  a=1;
                        print("cancelledR");
                    },
    
                  child: FlipCard(
                    
                      front: FlashcardView(
                        text: filteredcards[_currentIndex].question,
                      ),
                      back: FlashcardView(
                        text: filteredcards[_currentIndex].answer,
                      )
                      )
                      ),),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                      onPressed: showPreviousCard,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Prev')),
                  OutlinedButton.icon(
                      onPressed: showNextCard,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Next')),
                  OutlinedButton.icon(
                    onPressed: deleteCard,
                    // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ],
              ),
              Column(children: [const Text("Make a new flash card down below:")],),
              SizedBox(
                  width: 250,
                  height: 250,
                  child: Card(
                    elevation: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("Equation of:"),
                          TextField(
                            controller: eqController,
                            decoration: const InputDecoration(
                              hintText: 'Enter the statement',
                            ),
                          ),
                          const Text("Formula:"),
                          TextField(
                            controller: frmController,
                            decoration: const InputDecoration(
                              hintText: 'Enter with or without latex',
                            ),

                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              String equation = eqController.text;
                              String formula = frmController.text;
                              if (equation.isNotEmpty) {
                                if (formula.isNotEmpty) {
                                  eqController.clear();
                                  frmController.clear();
                                  setState(() {
                                    flashcards.add(FlashCard(topic: widget.test,question: equation, answer: formula));
                                });
                                saveIntoSp();
                                }
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                          ),
                      ]
                      )       
                    )
                    ),
                  ),
              Column( 
                children: [OutlinedButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoteHomePage()),
                  );
                
                },
                icon: const Icon(Icons.groups_3_outlined),
                label: const Text("back")
                )]
              ),
            ],
            
          ),
        ),
      );
    
  }
  
  void showNextCard() {
    setState(() {
      _currentIndex =
          (_currentIndex + 1 < filteredcards.length) ? _currentIndex + 1 : 0;
      
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 >= 0) ? _currentIndex - 1 : filteredcards.length - 1;
        
    });
  }
  void deleteCard() {
    // debugPrint("Custom before: ${jsonEncode(filteredcards)}");
    // debugPrint("flash befoire: ${jsonEncode(flashcards)}");
    // debugPrint("remove flash: ${filteredcards[_currentIndex].question}");
    setState(() {
      filteredcards = flashcards.where((card) =>card!=filteredcards[_currentIndex]).toList();
      flashcards = filteredcards;
    });
    saveIntoSp();
    // debugPrint("Custom after: ${jsonEncode(filteredcards)}");
    // debugPrint("flash after: ${jsonEncode(flashcards)}");
    
  }

}

class NoteHomePage extends StatefulWidget {
  @override
 _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _notes = [];
  final List<FlashCard> flashcards= List.empty(growable: true);
  
  late SharedPreferences sp;
  @override
  void initState() {
    super.initState();
    // _addNote(text: );
    _loadNotes(key: 'notes');
  }
  getSharedPref() async {
    sp = await SharedPreferences.getInstance();
  }
  saveIntoSp() {
    List<String> flashcardstring = flashcards.map((cardz)=> jsonEncode(cardz.toJson())).toList();
    sp.setStringList('mydata',flashcardstring);
  }
  readFromSp(){

  }
  _loadNotes({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes.addAll(prefs.getStringList(key) ?? []);
    });
  }
  _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }
  _addNote() {
    String newNote = _noteController.text;
    if (newNote.isNotEmpty) {
      setState(() {
        _notes.add(newNote);
      });
      _noteController.clear();
      _saveNotes();
    }
  }
  _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);   
    });
    _saveNotes();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Formulazier'),
    ),
    body: Column(
      
      children: <Widget>[
        Column(children: [Text("Make your chapter wise organised boxes here"),]),
        Expanded(
          child: ListView.builder(
            
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: ()  {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp(test: _notes[index])),
                  );
                },
                title: Text(_notes[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNote(index),
                ),
              );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                  labelText: 'Add a new Subject box',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNote,
                  ),
                ),
              ),
        ),
      ],
    ),
  );
  }
}
