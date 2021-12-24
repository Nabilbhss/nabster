trigger OppoClose on Opportunity (After insert) {
        OpportunityTrigger_Handler.OpporunityTriggerLogic(trigger.new);
        //Alpasslan
}