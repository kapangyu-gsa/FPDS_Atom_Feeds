<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.w3.org/2005/Atom" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:output method="text" />
    <xsl:variable name="delimiter" select="','"/>
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