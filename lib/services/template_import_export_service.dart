import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sartor_order_management/models/measurement_template.dart';

class TemplateImportExportService {
  Future<void> exportTemplates(List<MeasurementTemplate> templates) async {
    final List<List<dynamic>> rows = [];
    rows.add(templates.first.toJson().keys.toList());
    for (final template in templates) {
      rows.add(template.toJson().values.toList());
    }

    final String csv = const ListToCsvConverter().convert(rows);

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Templates',
      fileName: 'measurement_templates.csv',
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsString(csv);
    }
  }

  Future<List<MeasurementTemplate>> importTemplates() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final input = await file.readAsString();
      final List<List<dynamic>> rows = const CsvToListConverter().convert(input);
      final headers = rows.first.map((e) => e.toString()).toList();
      final List<MeasurementTemplate> templates = [];

      for (int i = 1; i < rows.length; i++) {
        final Map<String, dynamic> json = {};
        for (int j = 0; j < headers.length; j++) {
          json[headers[j]] = rows[i][j];
        }
        templates.add(MeasurementTemplate.fromJson(json));
      }
      return templates;
    }
    return [];
  }
}
