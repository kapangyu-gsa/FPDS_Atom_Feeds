<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.w3.org/2005/Atom" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:output method="text" />
    <!-- use TAB as the delimiter as commas exist in the data -->
    <xsl:variable name="delimiter" select="'&#x9;'"/>
    <xsl:variable name="newline" select="'&#xa;'"/>
    <!-- use the feed/entry node-set to create a blank column in the output file for a path not found in source data -->
    <xsl:variable name="dummy-nodeset" select="/f:feed/f:entry"/>
 
    <xsl:template match="/">
        <!-- awardID -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">agencyID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">agencyName</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">PIID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:PIID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">modNumber</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:modNumber"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">transactionNumber</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:transactionNumber"/></xsl:apply-templates>
        <!-- reference awardID -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">ref-agencyID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">ref-agencyName</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">ref-PIID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:PIID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">ref-modNumber</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:modNumber"/></xsl:apply-templates>
        <!-- other awardID -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-agencyID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:agencyID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-agencyName</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-PIID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:PIID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-modNumber</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:modNumber"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-transactionNumber</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:transactionNumber"/></xsl:apply-templates>
        <!-- other reference awardID -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-ref-agencyID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:agencyID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-ref-agencyName</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-ref-PIID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:PIID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">other-ref-modNumber</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:modNumber"/></xsl:apply-templates>
        <!-- relevantContractDates -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">signedDate</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:signedDate"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">effectiveDate</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:effectiveDate"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">currentCompletionDate</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:currentCompletionDate"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">ultimateCompletionDate</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:ultimateCompletionDate"/></xsl:apply-templates>
        <!-- dollarValues -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">obligatedAmount</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:obligatedAmount"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">baseAndExercisedOptionsValue</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:baseAndExercisedOptionsValue"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">baseAndAllOptionsValue</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:baseAndAllOptionsValue"/></xsl:apply-templates>
        <!-- totalDollarValues -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">totalObligatedAmount</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:totalObligatedAmount"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">totalBaseAndExercisedOptionsValue</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:totalBaseAndExercisedOptionsValue"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">totalBaseAndAllOptionsValue</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:totalBaseAndAllOptionsValue"/></xsl:apply-templates>
        <!-- purchaserInformation -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOfficeAgencyID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeAgencyID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOfficeAgency-name</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeAgencyID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOfficeAgency-departmentID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeAgencyID/@departmentID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOfficeAgency-departmentName</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeAgencyID/@departmentName"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOfficeID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOffice-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeID/@Description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOffice-regionCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeID/@regionCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractingOffice-country</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractingOfficeID/@country"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">fundingRequestingAgencyID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:fundingRequestingAgencyID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">fundingRequestingAgency-name</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:fundingRequestingAgencyID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">fundingRequestingAgency-departmentID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:fundingRequestingAgencyID/@departmentID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">fundingRequestingAgency-departmentName</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:fundingRequestingAgencyID/@departmentName"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">fundingRequestingOfficeID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:fundingRequestingOfficeID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">fundingRequestingOffice-name</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:fundingRequestingOfficeID/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">foreignFunding</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:foreignFunding"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">foreignFunding-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:foreignFunding/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">purchaseReason</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:purchaseReason"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">purchaseReason-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:purchaseReason/@description"/></xsl:apply-templates>
        <!-- contractMarketingData -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">feePaidForUseOfService</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:feePaidForUseOfService"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">totalEstimatedOrderValue</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:totalEstimatedOrderValue"/></xsl:apply-templates>
        <!-- contractData -->
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractActionType</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractActionType"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractActionType-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractActionType/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractActionType-part8OrPart13</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractActionType/@part8OrPart13"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">typeOfContractPricing</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:typeOfContractPricing"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">typeOfContractPricing-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:typeOfContractPricing/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">reasonForModification</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:reasonForModification"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">reasonForModification-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:reasonForModification/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">majorProgramCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:majorProgramCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">nationalInterestActionCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:nationalInterestActionCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">nationalInterestActionCode-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:nationalInterestActionCode/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">costOrPricingData</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:costOrPricingData"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">costOrPricingData-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:costOrPricingData/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">solicitationID</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:solicitationID"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">costAccountingStandardsClause</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:costAccountingStandardsClause"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">costAccountingStandardsClause-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:costAccountingStandardsClause/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">descriptionOfContractRequirement</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:descriptionOfContractRequirement"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">inherentlyGovernmentalFunction</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:inherentlyGovernmentalFunction"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">inherentlyGovernmentalFunction-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:inherentlyGovernmentalFunction/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">GFE-GFP</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:GFE-GFP"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">GFE-GFP-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:GFE-GFP/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">seaTransportation</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:seaTransportation"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">seaTransportation-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:seaTransportation/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">undefinitizedAction</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:undefinitizedAction"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">undefinitizedAction-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:undefinitizedAction/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">consolidatedContract</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:consolidatedContract"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">consolidatedContract-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:consolidatedContract/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">performanceBasedServiceContract</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:performanceBasedServiceContract"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">performanceBasedServiceContract-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:performanceBasedServiceContract/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">multiYearContract</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:multiYearContract"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">multiYearContract-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:multiYearContract/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">subLevelPrefixCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:subLevelPrefixCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">allocationTransferAgencyIdentifier</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:allocationTransferAgencyIdentifier"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">agencyIdentifier</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:agencyIdentifier"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">agencyIdentifier-name</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:agencyIdentifier/@name"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">beginningPeriodOfAvailability</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:beginningPeriodOfAvailability"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">endingPeriodOfAvailability</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:endingPeriodOfAvailability"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">availabilityTypeCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:availabilityTypeCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">availabilityTypeCode-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:availabilityTypeCode/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">mainAccountCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:mainAccountCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">subAccountCode</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:subAccountCode"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">initiative</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:initiative"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">initiative-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:initiative/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">obligatedAmount</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:obligatedAmount"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">referencedIDVPart8OrPart13</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:referencedIDVPart8OrPart13"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">referencedIDVMultipleOrSingle</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:referencedIDVMultipleOrSingle"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">referencedIDVType</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:referencedIDVType"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contingencyHumanitarianPeacekeepingOperation</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contingencyHumanitarianPeacekeepingOperation"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contingencyHumanitarianPeacekeepingOperation-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contingencyHumanitarianPeacekeepingOperation/@description"/></xsl:apply-templates>        
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractFinancing</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractFinancing"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">contractFinancing-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:contractFinancing/@description"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">purchaseCardAsPaymentMethod</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:purchaseCardAsPaymentMethod"/></xsl:apply-templates>
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">purchaseCardAsPaymentMethod-description</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:purchaseCardAsPaymentMethod/@description"/></xsl:apply-templates>        
        <xsl:apply-templates name="do-field" mode="check-field" >
            <xsl:with-param name="fieldname">numberOfActions</xsl:with-param>
            <xsl:with-param name="path" select="//ns1:numberOfActions"/></xsl:apply-templates>

        <!-- TODO: add the other fields -->
    </xsl:template>

    <xsl:template match="node()|@*" mode="check-field" >
        <xsl:param name="fieldname"/>
        <xsl:param name="path"/>
        <xsl:value-of select="$fieldname"/>
        <xsl:if test="$path">
            <xsl:apply-templates select="$path" mode="do-field">
                <xsl:with-param name="output-node-value" select="true()"/>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="not($path)">
            <xsl:apply-templates select="$dummy-nodeset" mode="do-field">
                <!-- do not output node value for dummy node-set -->
                <xsl:with-param name="output-node-value" select="false()"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="node()|@*" mode="do-field">
        <xsl:param name="output-node-value"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:if test="$output-node-value">
            <xsl:value-of select="." />
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

</xsl:stylesheet>