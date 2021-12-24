public class OpportunityTrigger_Handler {
    
        public static void OpporunityTriggerLogic(List<Opportunity> TriggerList){
             List<opportunitylineitem> OLI = new List<opportunitylineitem>();
             OLI = [Select Quantity,UnitPrice,PricebookEntry.Product2Id, PricebookEntry.Product2.Name, Description from opportunitylineitem 
                   where opportunityId IN: TriggerList AND Opportunity.iswon = true AND Opportunity.hasOpportunitylineitem = true];
             Map<Id,String> mapPrefixByOppy = new Map<Id,String>();
             Map<String,AssetPrefixMapping__mdt> mapPrefix = AssetPrefixMapping__mdt.getAll();
            
              // Mapp opportunity with Name of record so I get prefix => take opp and get me the prefix to store in Asset
              for(opportunitylineitem opp : OLI){
              mapPrefixByOppy.put(opp.OpportunityId , String.valueOf(mapPrefix.get(opp.PricebookEntry.Product2.RecordType.Name)));
              }
        
            List<Asset> assetList = new List<Asset>();        
            for(opportunitylineitem ol:OLI){
            asset a = new asset();
            a.AccountId=ol.opportunity.AccountID;
            a.Quantity=ol.quantity;     
            a.Product2Id=ol.PricebookEntry.Product2Id;
            a.price=ol.UnitPrice;
            a.Description=ol.Description;
            a.name=ol.PricebookEntry.Product2.Name;
            a.opportunity__r.id=ol.opportunity.id;
            a.Opportunity_Product__c=ol.id;
            a.RecordType.Name=mapPrefixByOppy.get(ol.opportunity.id);
            a.price=ol.UnitPrice;
            a.PurchaseDate=ol.opportunity.CloseDate;
            PageHelper op = new PageHelper(mapPrefixByOppy.get(ol.opportunity.id),ol.PricebookEntry.Product2.ProductCode);
            a.External_Id__c=op.GenerateExternalId();
            assetList.add(a);   
        }       
           insert assetList; 
        }
            
    }