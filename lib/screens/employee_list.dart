import 'package:flutter/material.dart';
import 'package:flutter_app/screens/add_employee.dart';
import 'package:flutter_app/services/employee_service.dart';
import '../utils/snackbar_helper.dart';
import '../widget/employee_card.dart';

class ListEmployeePage extends StatefulWidget {
  const ListEmployeePage({Key? key}) : super(key: key);

  @override
  State<ListEmployeePage> createState() => _ListEmployeePageState();
}

class _ListEmployeePageState extends State<ListEmployeePage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchEmployee,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No Employee",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return EmployeeCard(
                    index: index,
                    deleteById: deleteById,
                    item: item,
                    navigateEdit: navigateToEditEmployeePage,
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (navigateAddEmployeePage),
          label: const Text("Add Employee")),
    );
  }

  Future<void> navigateToEditEmployeePage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddEmployeePage(
              employee: item,
            ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchEmployee();
  }

  Future<void> navigateAddEmployeePage() async {
    final route = MaterialPageRoute(builder: (context) => const AddEmployeePage());
    Navigator.push(context, route);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchEmployee();
  }

  Future<void> deleteById(String id) async {
    //Delete the item
    final isSuccess = await EmployeeService.deleteById(id);
    if (isSuccess) {
      //Remove the from list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //Show error
      showErrorMessage(context, message: "Unable to Delete'");
    }
  }

  Future<void> fetchEmployee() async {
    final response = await EmployeeService.fetchEmployees();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: "Something wentto wrong!");
    }

    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
