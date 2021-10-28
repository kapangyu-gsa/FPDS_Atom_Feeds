<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.w3.org/2005/Atom" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:include href="fpds_feed_util.xsl" />

    <xsl:template match="/">

        <!-- awardID -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="agencyID">
            <xsl:with-param name="fieldname">agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="agencyName">
            <xsl:with-param name="fieldname">agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="PIID">
            <xsl:with-param name="fieldname">PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="modNumber">
            <xsl:with-param name="fieldname">modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="transactionNumber">
            <xsl:with-param name="fieldname">transactionNumber</xsl:with-param></xsl:apply-templates> -->

        <!-- reference awardID -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="ref-agencyID">
            <xsl:with-param name="fieldname">ref-agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="ref-agencyName">
            <xsl:with-param name="fieldname">ref-agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="ref-PIID">
            <xsl:with-param name="fieldname">ref-PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="ref-modNumber">
            <xsl:with-param name="fieldname">ref-modNumber</xsl:with-param></xsl:apply-templates> -->

        <!-- other awardID -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="other-agencyID">
            <xsl:with-param name="fieldname">other-agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-agencyName">
            <xsl:with-param name="fieldname">other-agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-PIID">
            <xsl:with-param name="fieldname">other-PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-modNumber">
            <xsl:with-param name="fieldname">other-modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-transactionNumber">
            <xsl:with-param name="fieldname">other-transactionNumber</xsl:with-param></xsl:apply-templates> -->

        <!-- other reference awardID -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="other-ref-agencyID">
            <xsl:with-param name="fieldname">other-ref-agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-agencyName">
            <xsl:with-param name="fieldname">other-ref-agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-PIID">
            <xsl:with-param name="fieldname">other-ref-PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-modNumber">
            <xsl:with-param name="fieldname">other-ref-modNumber</xsl:with-param></xsl:apply-templates> -->

        <!-- relevantContractDates -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">signedDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">effectiveDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">currentCompletionDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">ultimateCompletionDate</xsl:with-param></xsl:apply-templates> -->

        <!-- dollarValues -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">obligatedAmount</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">baseAndExercisedOptionsValue</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">baseAndAllOptionsValue</xsl:with-param></xsl:apply-templates> -->

        <!-- totalDollarValues -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalObligatedAmount</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalBaseAndExercisedOptionsValue</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalBaseAndAllOptionsValue</xsl:with-param></xsl:apply-templates> -->

        <!-- purchaserInformation -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">departmentID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">departmentName</xsl:with-param></xsl:apply-templates> -->

        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractingOfficeID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeID</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeID</xsl:with-param>
            <xsl:with-param name="attrname">regionCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeID</xsl:with-param>
            <xsl:with-param name="attrname">country</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">fundingRequestingAgencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">fundingRequestingAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">fundingRequestingAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">departmentID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">fundingRequestingAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">departmentName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">fundingRequestingOfficeID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">fundingRequestingOfficeID</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">foreignFunding</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">foreignFunding</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">purchaseReason</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">purchaseReason</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates> -->

        <!-- contractMarketingData -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">feePaidForUseOfService</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalEstimatedOrderValue</xsl:with-param></xsl:apply-templates> -->

        <!-- contractData -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractActionType</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractActionType</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractActionType</xsl:with-param>
            <xsl:with-param name="attrname">part8OrPart13</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">typeOfContractPricing</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">typeOfContractPricing</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">reasonForModification</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">reasonForModification</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">majorProgramCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">nationalInterestActionCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">nationalInterestActionCode</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">costOrPricingData</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">costOrPricingData</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">solicitationID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">costAccountingStandardsClause</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">costAccountingStandardsClause</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">descriptionOfContractRequirement</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">inherentlyGovernmentalFunction</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">inherentlyGovernmentalFunction</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">GFE-GFP</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">GFE-GFP</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">seaTransportation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">seaTransportation</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">undefinitizedAction</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">undefinitizedAction</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">consolidatedContract</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">consolidatedContract</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">performanceBasedServiceContract</xsl:with-param></xsl:apply-templates> 
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">performanceBasedServiceContract</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">multiYearContract</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">multiYearContract</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">subLevelPrefixCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">allocationTransferAgencyIdentifier</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">agencyIdentifier</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">agencyIdentifier</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">beginningPeriodOfAvailability</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">endingPeriodOfAvailability</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">availabilityTypeCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">availabilityTypeCode</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">mainAccountCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">subAccountCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">initiative</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">initiative</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">obligatedAmount</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">referencedIDVPart8OrPart13</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">referencedIDVMultipleOrSingle</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">referencedIDVType</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contingencyHumanitarianPeacekeepingOperation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contingencyHumanitarianPeacekeepingOperation</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>        
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractFinancing</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractFinancing</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">purchaseCardAsPaymentMethod</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">purchaseCardAsPaymentMethod</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>        
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">numberOfActions</xsl:with-param></xsl:apply-templates> -->

        <!-- legislativeMandates -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">ClingerCohenAct</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">ClingerCohenAct</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">materialsSuppliesArticlesEquipment</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">materialsSuppliesArticlesEquipment</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">laborStandards</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">laborStandards</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">constructionWageRateRequirements</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">constructionWageRateRequirements</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">interagencyContractingAuthority</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">interagencyContractingAuthority</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>            
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">otherStatutoryAuthority</xsl:with-param></xsl:apply-templates>  -->
        <!-- TODO: to handle possible multiple entries of additionalReportingValue -->
        <!-- <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">additionalReportingValue</xsl:with-param></xsl:apply-templates>             -->

        <!-- TODO: add the other fields -->
    </xsl:template>

</xsl:stylesheet>