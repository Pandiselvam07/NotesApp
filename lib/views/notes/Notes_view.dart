import 'package:flutter/material.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/enums/Menu_action.dart';
import 'package:pratice/main.dart';
import 'package:pratice/services/auth/Auth_service.dart';
import 'package:pratice/services/auth/bloc/Auth_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_event.dart';
import 'package:pratice/services/cloud/Cloud_note.dart';
import 'package:pratice/services/cloud/Firebase_cloud_storage.dart';
import 'package:pratice/utilities/dialogs/Logout_dialog.dart';
import 'package:pratice/views/add_image_page.dart';
import 'package:pratice/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your notes",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createupdatenoteroute);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddImagePage(
                        userId: userId,
                      )));
            },
            icon: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          PopupMenuButton<MenuAction>(
            iconColor: Colors.white,
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("LogOut"),
                ),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createupdatenoteroute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
