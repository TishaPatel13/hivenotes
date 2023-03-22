import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'boxes/boxes.dart';
import 'models/note_models.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  TextEditingController nameC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),

          builder: (context, box, _){
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString()),
                              const Spacer(),
                              InkWell(
                                  onTap: (){
                                    _editDialog(data[index], data[index].title.toString() , data[index].destription.toString());
                                  },
                                  child: const Icon(Icons.edit)),
                              const SizedBox(width: 15),
                              InkWell(
                                  onTap: (){
                                    delete(data[index]);
                                  },
                                  child: const Icon(Icons.delete))
                            ],
                          ),
                          Text(data[index].destription.toString()),
                        ],
                      ),
                    ),
                  );
                });
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showDialog();
        },
        child: const Icon(Icons.note_add_sharp),
      ),
    );


  }
  void delete(NotesModel notesModel)async{
    await notesModel.delete();
  }

  Future<void> _editDialog(NotesModel notesModel, String title, String description)async{

    nameC.text = title;
    descriptionC.text = description;

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Edit'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(
                    labelText: 'Enter Name',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionC,
                decoration: const InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder()
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: const Text('Cancel')),

          TextButton(onPressed: (){
            notesModel.title = nameC.text.toString();
            notesModel.destription = descriptionC.text.toString();
            notesModel.save();
            Navigator.pop(context);
            nameC.clear();
            descriptionC.clear();
          },
              child: const Text('Edit'))
        ],
      );
    });
  }

  Future<void> _showDialog()async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Add NOTES'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(
                    labelText: 'Enter Name',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionC,
                decoration: const InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder()
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: const Text('Cancel')),

          TextButton(onPressed: (){
            Navigator.pop(context);
            final data = NotesModel(title: nameC.text, destription: descriptionC.text);

            final box = Boxes.getData();
            box.add(data);
            data.save();
            nameC.clear();
            descriptionC.clear();
          },
              child: const Text('Add'))
        ],
      );
    });
  }
}

