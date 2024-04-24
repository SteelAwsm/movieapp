import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movieapp/db/movie_database.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/page/edit_film_page.dart';
import 'package:movieapp/page/movie_detail_page.dart';
import 'package:movieapp/widget/movie_card_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold (
    appBar: AppBar(
      title: const Text(
        'Movie List',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold, // Make the text bold
          color: Colors.white,
          letterSpacing: 1.5,// Change the text color to blue (you can choose any color)
        ),
      ),
      actions: const [Icon(Icons.search, color: Colors.white), SizedBox(width: 15)],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : notes.isEmpty
          ? const Text(
        'No Movies Detected',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          :buildNotes(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black12,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditNotePage()),
        );

        refreshNotes();
      },
    ),
  );
  Widget buildNotes() => StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        notes.length,
            (index) {
          final note = notes[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));

                refreshNotes();
              },
              child:NoteCardWidget(note: note, index: index),
            ),
          );
        },
      )
  );
}