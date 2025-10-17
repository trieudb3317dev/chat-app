import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  List<Map<String, String>> _selectedMembers = [];

  // Dummy list of users to select from
  final List<Map<String, String>> _users = [
    {"name": "David Wayne", "id": "1", "phone": "(+44) 50 9285 3022", "avatar": "https://i.pravatar.cc/150?u=davidwayne"},
    {"name": "Edward Mint", "id": "2", "phone": "(+44) 50 9285 2090", "avatar": "https://i.pravatar.cc/150?u=edwardmint"},
    {"name": "May HG. Kang", "id": "3", "phone": "(+44) 50 9285 2214", "avatar": "https://i.pravatar.cc/150?u=maykang"},
    {"name": "Lily Dare", "id": "4", "phone": "(+44) 50 9285 5530", "avatar": "https://i.pravatar.cc/150?u=lilydare"},
    {"name": "Dennis Dang", "id": "5", "phone": "(+44) 50 9285 2225", "avatar": "https://i.pravatar.cc/150?u=dennisdang"},
  ];

  void _showAddMembersPage() async {
    final selected = await Navigator.of(context).push<List<Map<String, String>>>(
      MaterialPageRoute(
        builder: (context) => AddMembersScreen(users: _users, selectedMembers: _selectedMembers),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedMembers = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
          title: const Text('Create Group', style: TextStyle(fontWeight: FontWeight.bold)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Name Group',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Members', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _showAddMembersPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Add members to group', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedMembers.length,
                      itemBuilder: (context, index) {
                        final user = _selectedMembers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['avatar']!),
                          ),
                          title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user['phone']!),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedMembers.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Create group logic
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: const Text('Create Group', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddMembersScreen extends StatefulWidget {
  final List<Map<String, String>> users;
  final List<Map<String, String>> selectedMembers;

  const AddMembersScreen({
    Key? key,
    required this.users,
    required this.selectedMembers,
  }) : super(key: key);

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  late List<Map<String, String>> _tempSelectedMembers;
  List<Map<String, String>> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempSelectedMembers = List.from(widget.selectedMembers);
    _filteredUsers = widget.users;
    _searchController.addListener(() {
      filterUsers();
    });
  }
  
  void filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = widget.users.where((user) {
        return user['name']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add members to group'),
      ),
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                final isSelected = _tempSelectedMembers.any((element) => element['id'] == user['id']);

                return CheckboxListTile(
                  title: Text(user['name']!),
                  subtitle: Text(user['phone']!),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _tempSelectedMembers.add(user);
                      } else {
                        _tempSelectedMembers.removeWhere((element) => element['id'] == user['id']);
                      }
                    });
                  },
                  secondary: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar']!),
                  ),
                );
              },
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                     style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_tempSelectedMembers);
                    },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
