// Converts two single space separated string collections - Assumes values are "numeric" stings

public with sharing class CollectionComparator {
    @InvocableMethod(label='Compare Collections' description='Compares two string collections for uniqueness and matching elements.')
    public static List<ComparisonResult> compareCollections(List<Inputs> inputList) {
        
        Inputs inputs = inputList[0];

       
        Set<Integer> collection1Set = new Set<Integer>();
        Set<Integer> collection2Set = new Set<Integer>();

        try {
            System.debug('Starting integer conversion for collection1');
           
            if (inputs.collection1.size() == 1) {
                inputs.collection1 = inputs.collection1[0].split('\\s+'); 
            }

            for (String item : inputs.collection1) {
                String trimmedItem = item != null ? item.trim() : '';
                if (trimmedItem.length() > 0) {
                    Integer convertedItem = Integer.valueOf(trimmedItem);
                    collection1Set.add(convertedItem);
                    System.debug('Added to collection1Set: ' + convertedItem);
                }
            }

           
            
            if (inputs.collection2.size() == 1) {
                inputs.collection2 = inputs.collection2[0].split('\\s+'); // Split by any whitespace
            }

            // Parse each item in collection2 to integer and add to the set
            for (String item : inputs.collection2) {
                String trimmedItem = item != null ? item.trim() : '';
                if (trimmedItem.length() > 0) {
                    Integer convertedItem = Integer.valueOf(trimmedItem);
                    collection2Set.add(convertedItem);
                    System.debug('Added to collection2Set: ' + convertedItem);
                }
            }
        } catch (Exception e) {
            System.debug('Error converting string to integer: ' + e.getMessage());
         
            return new List<ComparisonResult>();
        }

        System.debug('Collection1 Set: ' + collection1Set);
        System.debug('Collection2 Set: ' + collection2Set);

     
        Set<Integer> matchingStringsSet = new Set<Integer>();
        Set<Integer> uniqueStringsSet = new Set<Integer>();

      
        for (Integer item : collection1Set) {
            if (collection2Set.contains(item)) {
                matchingStringsSet.add(item);
                System.debug('Matching item found: ' + item);
            } else {
                uniqueStringsSet.add(item);
                System.debug('Unique to collection1Set: ' + item);
            }
        }

  
        for (Integer item : collection2Set) {
            if (!collection1Set.contains(item)) {
                uniqueStringsSet.add(item);
                System.debug('Unique to collection2Set: ' + item);
            }
        }

        
        Boolean allMatch = uniqueStringsSet.isEmpty();
        System.debug('All match: ' + allMatch);

        
        ComparisonResult result = new ComparisonResult();
        result.matchingStrings = new List<String>();
        result.uniqueStrings = new List<String>();

        
        for (Integer item : matchingStringsSet) {
            result.matchingStrings.add(String.valueOf(item));
        }
        for (Integer item : uniqueStringsSet) {
            result.uniqueStrings.add(String.valueOf(item));
        }

        result.allMatch = allMatch;

        System.debug('Result - Matching Strings: ' + result.matchingStrings);
        System.debug('Result - Unique Strings: ' + result.uniqueStrings);
        System.debug('Result - All Match: ' + result.allMatch);

        return new List<ComparisonResult>{ result };
    }

   
    public class Inputs {
        @InvocableVariable(required=true label='Collection 1' description='First collection of strings')
        public List<String> collection1;

        @InvocableVariable(required=true label='Collection 2' description='Second collection of strings')
        public List<String> collection2;
    }

    
    public class ComparisonResult {
        @InvocableVariable(label='Matching Strings' description='Strings found in both collections')
        public List<String> matchingStrings;

        @InvocableVariable(label='Unique Strings' description='Strings unique to either collection')
        public List<String> uniqueStrings;

        @InvocableVariable(label='All Match' description='True if all strings match between the two collections')
        public Boolean allMatch;
    }
}