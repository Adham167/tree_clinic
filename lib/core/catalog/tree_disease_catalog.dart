class TreeDiseaseEntry {
  const TreeDiseaseEntry({
    required this.treeName,
    required this.diseases,
  });

  final String treeName;
  final List<String> diseases;
}

class TreeDiseaseCatalog {
  static const String otherOption = 'Other';

  static const List<TreeDiseaseEntry> _entries = [
    TreeDiseaseEntry(
      treeName: 'Apple',
      diseases: ['Scab', 'Black rot', 'Cedar rust'],
    ),
    TreeDiseaseEntry(
      treeName: 'Banana',
      diseases: ['cordana', 'pestalotiopsis', 'sigatoka'],
    ),
    TreeDiseaseEntry(
      treeName: 'Guava',
      diseases: ['Canker', 'Leaf Spot (Cercospora)', 'Mummification', 'Rust'],
    ),
    TreeDiseaseEntry(
      treeName: 'Mango',
      diseases: [
        'Anthracnose',
        'Bacterial Canker',
        'Cutting Weevil',
        'Die Back',
        'Gall Midge',
        'Powdery Mildew',
        'Sooty Mould',
      ],
    ),
  ];

  static List<TreeDiseaseEntry> get entries => List.unmodifiable(_entries);

  static List<String> get treeNames =>
      _entries.map((entry) => entry.treeName).toList(growable: false);

  static bool containsTree(String value) {
    final normalizedValue = normalize(value);
    return _entries.any((entry) => normalize(entry.treeName) == normalizedValue);
  }

  static bool containsDiseaseForTree(String treeName, String diseaseName) {
    final entry = findTree(treeName);
    if (entry == null) return false;

    final normalizedDisease = normalize(diseaseName);
    return entry.diseases.any(
      (disease) => normalize(disease) == normalizedDisease,
    );
  }

  static TreeDiseaseEntry? findTree(String treeName) {
    final normalizedTreeName = normalize(treeName);
    for (final entry in _entries) {
      if (normalize(entry.treeName) == normalizedTreeName) {
        return entry;
      }
    }
    return null;
  }

  static List<String> diseasesFor(String treeName) {
    final entry = findTree(treeName);
    return entry == null ? const [] : List.unmodifiable(entry.diseases);
  }

  static String normalize(String value) {
    return value.trim().toLowerCase();
  }
}
