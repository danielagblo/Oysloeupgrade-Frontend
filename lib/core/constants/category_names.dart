/// Known category display names keyed by backend category ID.
/// These can be adjusted to match server-configured IDs.
///
/// Note: 'Services' is intentionally included so that logic can exclude it
/// from stats when present.
const Map<int, String> kCategoryNames = <int, String>{
  1: 'Vehicle',
  2: 'Electronics',
  3: 'Furniture',
  4: 'Fashion',
  5: 'Grocery',
  6: 'Games',
  7: 'Cosmetics',
  8: 'Property',
  9: 'Industry',
  10: 'Services',
};
