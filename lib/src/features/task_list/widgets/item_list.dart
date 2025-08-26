import 'package:flutter/material.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';
import 'package:simple_beautiful_checklist_exercise/data/shared_preference_repository.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.repository,
    required this.items,
    required this.updateOnChange,
  });

  final DatabaseRepository repository;
  final List<String> items;
  final void Function() updateOnChange;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Checkbox(
            value: false, // immer un-checked beim Rendern
            onChanged: (checked) async {
              if (checked == true) {
                // Task löschen
                await repository.deleteItem(index);

                // Done-Zähler hochzählen
                if (repository is SharedPreferencesRepository) {
                  await (repository as SharedPreferencesRepository)
                      .incrementCounter(SharedPreferencesRepository.doneKey);
                }

                // UI aktualisieren
                updateOnChange();
              }
            },
          ),
          title: Text(items[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  TextEditingController editController = TextEditingController(
                    text: items[index],
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Task bearbeiten'),
                        content: TextField(
                          autofocus: true,
                          controller: editController,
                          decoration: const InputDecoration(
                            hintText: "Task bearbeiten",
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Abbrechen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Speichern'),
                            onPressed: () {
                              repository.editItem(index, editController.text);
                              updateOnChange();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  repository.deleteItem(index);

                  // Done-Zähler hochzählen
                  if (repository is SharedPreferencesRepository) {
                    await (repository as SharedPreferencesRepository)
                        .incrementCounter(
                          SharedPreferencesRepository.deleteKey,
                        );
                  }

                  updateOnChange();
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        color: Colors.white10,
      ),
    );
  }
}
