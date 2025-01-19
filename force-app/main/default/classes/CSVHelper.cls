public with sharing class CSVHelper {
    @InvocableMethod
    public static List<String> blobToText(List<Id> contentVersionIds) {
        
        String result = '';

        
        if (Schema.sObjectType.ContentVersion.isAccessible()) {
            
            List<ContentVersion> contentVersions = [
                SELECT VersionData 
                FROM ContentVersion 
                WHERE Id IN :contentVersionIds
            ];

            
            for (ContentVersion contentVersion : contentVersions) {
                
                if (contentVersion.VersionData != null) {
                    result += contentVersion.VersionData.toString() + ',';
                }
            }

            
            result = result.trim();
        } else {
            
            System.debug('User does not have access to the uploaded file (ContentVersion)');
        }

        
        return new List<String>{ result };
    }
}
