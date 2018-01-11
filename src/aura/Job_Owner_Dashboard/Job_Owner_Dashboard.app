<aura:application extends="force:slds" implements="force:appHostable,flexipage:availableForAllPageTypes" access="global" >
    <aura:attribute name="currentUser" type="String"/>
    <aura:attribute name="isCollpased" type="Boolean" default="true" />
    <aura:dependency resource="markup://force:*" type="EVENT"/>
    <aura:registerEvent name="evntCollapse" type="c:JO_CollapseEvent" />
    <aura:handler event="c:JO_CollapseEvent"  action="{!c.collpasePortfolio}"/>
    <div class="slds-grid slds-grid--vertical-stretch slds-wrap slds-p-around_xx-small">
        <div class="slds-col slds-size_1-of-1 "><c:JO_Header /></div>
        <div class="slds-col slds-size_1-of-1 slds-border_top slds-border_bottom slds-border_left slds-border_right slds-p-around_xx-small globalFilterCLS">
           <c:JO_GlobalFilters />
        </div>
        <!-- <aura:if isTrue="{!v.isCollpased}"> -->
        <div aura:id="isCollpased" class="slds-col slds-box slds-box_xx-small slds-is-relative graphAreaCLS">
            <c:JO_GraphData />
        </div>
        
        <div aura:id="isCollpased1" class="slds-col slds-box slds-box_xx-small slds-is-relative taskActionsCLS">
           <c:JO_Tasks />
        </div>
        <!-- </aura:if> -->
        <div class="slds-col  slds-box slds-box_xx-small slds-is-relative portfolioCLS">
            <c:JO_Portfolio />
        </div>
        <!-- <div class="slds-col  slds-box slds-box_xx-small slds-is-relative portfolioCLS">
            <c:JO_Portfolio1 />
        </div> -->
        <!--<lightning:button label="test" onclick="{!c.executeTest}"/>-->
    </div>
    
</aura:application>