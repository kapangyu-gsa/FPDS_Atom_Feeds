<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.w3.org/2005/Atom" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:include href="fpds_feed_util.xsl" />

    <xsl:template match="/">

        <!-- awardID -->
        <xsl:apply-templates select="$content-nodeset" mode="agencyID">
            <xsl:with-param name="fieldname">agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="agencyName">
            <xsl:with-param name="fieldname">agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="PIID">
            <xsl:with-param name="fieldname">PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="modNumber">
            <xsl:with-param name="fieldname">modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="transactionNumber">
            <xsl:with-param name="fieldname">transactionNumber</xsl:with-param></xsl:apply-templates>

        <!-- reference awardID -->
        <xsl:apply-templates select="$content-nodeset" mode="ref-agencyID">
            <xsl:with-param name="fieldname">ref-agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="ref-agencyName">
            <xsl:with-param name="fieldname">ref-agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="ref-PIID">
            <xsl:with-param name="fieldname">ref-PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="ref-modNumber">
            <xsl:with-param name="fieldname">ref-modNumber</xsl:with-param></xsl:apply-templates>

        <!-- other awardID -->
        <xsl:apply-templates select="$content-nodeset" mode="other-agencyID">
            <xsl:with-param name="fieldname">other-agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-agencyName">
            <xsl:with-param name="fieldname">other-agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-PIID">
            <xsl:with-param name="fieldname">other-PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-modNumber">
            <xsl:with-param name="fieldname">other-modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-transactionNumber">
            <xsl:with-param name="fieldname">other-transactionNumber</xsl:with-param></xsl:apply-templates>

        <!-- other reference awardID -->
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-agencyID">
            <xsl:with-param name="fieldname">other-ref-agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-agencyName">
            <xsl:with-param name="fieldname">other-ref-agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-PIID">
            <xsl:with-param name="fieldname">other-ref-PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="other-ref-modNumber">
            <xsl:with-param name="fieldname">other-ref-modNumber</xsl:with-param></xsl:apply-templates>

        <!-- relevantContractDates -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">signedDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">effectiveDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">currentCompletionDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">ultimateCompletionDate</xsl:with-param></xsl:apply-templates>

        <!-- dollarValues -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">obligatedAmount</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">baseAndExercisedOptionsValue</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">baseAndAllOptionsValue</xsl:with-param></xsl:apply-templates>

        <!-- totalDollarValues -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalObligatedAmount</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalBaseAndExercisedOptionsValue</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalBaseAndAllOptionsValue</xsl:with-param></xsl:apply-templates>

        <!-- purchaserInformation -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">departmentID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="attrname">departmentName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
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
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>

        <!-- contractMarketingData -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">feePaidForUseOfService</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">totalEstimatedOrderValue</xsl:with-param></xsl:apply-templates>

        <!-- contractData -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
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
            <xsl:with-param name="fieldname">numberOfActions</xsl:with-param></xsl:apply-templates>

        <!-- legislativeMandates -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
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
            <xsl:with-param name="fieldname">otherStatutoryAuthority</xsl:with-param></xsl:apply-templates>  
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">additionalReportingValue</xsl:with-param></xsl:apply-templates>            

        <!-- productOrServiceInformation -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">productOrServiceCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">productOrServiceCode</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">productOrServiceCode</xsl:with-param>
            <xsl:with-param name="attrname">productOrServiceType</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractBundling</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractBundling</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">claimantProgramCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">claimantProgramCode</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">principalNAICSCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">principalNAICSCode</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">recoveredMaterialClauses</xsl:with-param></xsl:apply-templates> 
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">recoveredMaterialClauses</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">manufacturingOrganizationType</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">manufacturingOrganizationType</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">systemEquipmentCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">systemEquipmentCode</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">informationTechnologyCommercialItemCategory</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">informationTechnologyCommercialItemCategory</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">useOfEPADesignatedProducts</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">useOfEPADesignatedProducts</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">countryOfOrigin</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">countryOfOrigin</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>

        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">placeOfManufacture</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">placeOfManufacture</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <!-- WARNING: the field name in data may be different in terms of cases, e.g. idvNaics -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">IDVNAICS</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">IDVNAICS</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">NAICSSource</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">NAICSSource</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>

        <!-- vendor -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorAlternateName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorLegalOrganizationName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorDoingAsBusinessName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorEnabled</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isAlaskanNativeOwnedCorporationOrFirm</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isAmericanIndianOwned</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isIndianTribe</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isNativeHawaiianOwnedOrganizationOrFirm</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isVeteranOwned</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isServiceRelatedDisabledVeteranOwnedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isWomenOwned</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isWomenOwnedSmallBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isEconomicallyDisadvantagedWomenOwnedSmallBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isJointVentureWomenOwnedSmallBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isJointVentureEconomicallyDisadvantagedWomenOwnedSmallBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isMinorityOwned</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSubContinentAsianAmericanOwnedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isAsianPacificAmericanOwnedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isBlackAmericanOwnedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isHispanicAmericanOwnedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isNativeAmericanOwnedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isOtherMinorityOwned</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isVerySmallBusiness</xsl:with-param></xsl:apply-templates> 
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCommunityDevelopedCorporationOwnedFirm</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isLaborSurplusAreaFirm</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isFederalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isFederallyFundedResearchAndDevelopmentCorp</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isFederalGovernmentAgency</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isStateGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCityLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCountyLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isInterMunicipalLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isLocalGovernmentOwned</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isMunicipalityLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSchoolDistrictLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isTownshipLocalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isTribalGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isForeignGovernment</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCorporateEntityNotTaxExempt</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCorporateEntityTaxExempt</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isPartnershipOrLimitedLiabilityPartnership</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSolePropreitorship</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSmallAgriculturalCooperative</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isInternationalOrganization</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isUSGovernmentEntity</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCommunityDevelopmentCorporation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isDomesticShelter</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isEducationalInstitution</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isFoundation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isHospital</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isManufacturerOfGoods</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isVeterinaryHospital</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isHispanicServicingInstitution</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">receivesContracts</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">receivesGrants</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">receivesContractsAndGrants</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isAirportAuthority</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isCouncilOfGovernments</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isHousingAuthoritiesPublicOrTribal</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isInterstateEntity</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isPlanningCommission</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isPortAuthority</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isTransitAuthority</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSubchapterSCorporation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isLimitedLiabilityCorporation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isForeignOwnedAndLocated</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isForProfitOrganization</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isNonprofitOrganization</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isOtherNotForProfitOrganization</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isShelteredWorkshop</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">stateOfIncorporation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">stateOfIncorporation</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">countryOfIncorporation</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">countryOfIncorporation</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">organizationalType</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">is1862LandGrantCollege</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">is1890LandGrantCollege</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">is1994LandGrantCollege</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isHistoricallyBlackCollegeOrUniversity</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isMinorityInstitution</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isPrivateUniversityOrCollege</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSchoolOfForestry</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isStateControlledInstitutionofHigherLearning</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isTribalCollege</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isVeterinaryCollege</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isAlaskanNativeServicingInstitution</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isNativeHawaiianServicingInstitution</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isDOTCertifiedDisadvantagedBusinessEnterprise</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSelfCertifiedSmallDisadvantagedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSBACertifiedSmallDisadvantagedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSBACertified8AProgramParticipant</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSelfCertifiedHUBZoneJointVenture</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSBACertifiedHUBZone</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">isSBACertified8AJointVenture</xsl:with-param></xsl:apply-templates> 
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">streetAddress</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">streetAddress2</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">streetAddress3</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">city</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">state</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">state</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">province</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">ZIPCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="vendor-countryCode">
            <xsl:with-param name="fieldname">vendor-countryCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="vendor-countryName">
            <xsl:with-param name="fieldname">vendor-countryName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">phoneNo</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">faxNo</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">congressionalDistrictCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorLocationDisabledFlag</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">entityDataSource</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorSiteCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">vendorAlternateSiteCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">DUNSNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">parentDUNSNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">parentDUNSName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">domesticParentDUNSNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">domesticParentDUNSName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">globalParentDUNSNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">globalParentDUNSName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">UEI</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">UEILegalBusinessName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">immediateParentUEI</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">immediateParentUEIName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">domesticParentUEI</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">domesticParentUEIName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">ultimateParentUEI</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">ultimateParentUEIName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">cageCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">divisionName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">divisionNumberOrOfficeCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">registrationDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">renewalDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">CCRException</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">CCRException</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">contractingOfficerBusinessSizeDetermination</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">contractingOfficerBusinessSizeDetermination</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">locationCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">stateCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">stateCode</xsl:with-param>
            <xsl:with-param name="attrname">name</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="performance-countryCode">
            <xsl:with-param name="fieldname">performance-countryCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="performance-countryName">
            <xsl:with-param name="fieldname">performance-countryName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">placeOfPerformanceZIPCode</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">placeOfPerformanceZIPCode</xsl:with-param>
            <xsl:with-param name="attrname">county</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">placeOfPerformanceZIPCode</xsl:with-param>
            <xsl:with-param name="attrname">city</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">placeOfPerformanceCongressionalDistrict</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">extentCompeted</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">extentCompeted</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">competitiveProcedures</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">solicitationProcedures</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">solicitationProcedures</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">typeOfSetAside</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">typeOfSetAside</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">evaluatedPreference</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">evaluatedPreference</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">research</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">research</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">statutoryExceptionToFairOpportunity</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">statutoryExceptionToFairOpportunity</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">reasonNotCompeted</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">reasonNotCompeted</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">numberOfOffersReceived</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">commercialItemAcquisitionProcedures</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">commercialItemAcquisitionProcedures</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">commercialItemTestProgram</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">commercialItemTestProgram</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">smallBusinessCompetitivenessDemonstrationProgram</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">A76Action</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">A76Action</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">fedBizOpps</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">fedBizOpps</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">localAreaSetAside</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">localAreaSetAside</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">preAwardSynopsisRequirement</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">priceEvaluationPercentDifference</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">synopsisWaiverException</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">alternativeAdvertising</xsl:with-param></xsl:apply-templates>
        <!-- WARNING: the specification uses different cases for the field below -->
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">idvTypeOfSetAside</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">idvTypeOfSetAside</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">typeOfSetAsideSource</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">typeOfSetAsideSource</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">idvNumberOfOffersReceived</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">idvNumberOfOffersReceived</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">numberOfOffersSource</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">numberOfOffersSource</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">subcontractPlan</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">subcontractPlan</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">reasonNotAwardedToSmallDisadvantagedBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">reasonNotAwardedToSmallDisadvantagedBusiness</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">reasonNotAwardedToSmallBusiness</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">reasonNotAwardedToSmallBusiness</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">createdBy</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">createdDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">lastModifiedBy</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">lastModifiedDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">status</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-attr">
            <xsl:with-param name="fieldname">status</xsl:with-param>
            <xsl:with-param name="attrname">description</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">approvedBy</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">approvedDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">closedStatus</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">closedBy</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">closedDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString01</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString02</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString03</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString04</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString05</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString06</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString07</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString08</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString09</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericString10</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean01</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean02</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean03</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean04</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean05</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean06</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean07</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean08</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean09</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericBoolean10</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericFloat01</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericFloat02</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericInteger01</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="$content-nodeset" mode="generic-node">
            <xsl:with-param name="fieldname">genericInteger02</xsl:with-param></xsl:apply-templates>
    </xsl:template>

</xsl:stylesheet>