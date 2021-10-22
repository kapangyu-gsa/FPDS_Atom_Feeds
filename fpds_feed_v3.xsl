<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:output method="text" />
    <xsl:variable name="delimiter" select="','" />
 
    <xsl:template match="/">
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID" mode="do-field">
                <xsl:with-param name="fieldname">agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name" mode="do-field">
                <xsl:with-param name="fieldname">agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:PIID" mode="do-field">
            <xsl:with-param name="fieldname">PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:modNumber" mode="do-field">
            <xsl:with-param name="fieldname">modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:transactionNumber" mode="do-field">
            <xsl:with-param name="fieldname">transactionNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID" mode="do-field">
            <xsl:with-param name="fieldname">ref_agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name" mode="do-field">
            <xsl:with-param name="fieldname">ref_agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:PIID" mode="do-field">
            <xsl:with-param name="fieldname">ref_PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:modNumber" mode="do-field">
            <xsl:with-param name="fieldname">ref_modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:agencyID" mode="do-field">
            <xsl:with-param name="fieldname">other_agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name" mode="do-field">
            <xsl:with-param name="fieldname">other_agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:PIID" mode="do-field">
            <xsl:with-param name="fieldname">other_PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:modNumber" mode="do-field">
            <xsl:with-param name="fieldname">other_modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:transactionNumber" mode="do-field">
            <xsl:with-param name="fieldname">other_transactionNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:agencyID" mode="do-field">
            <xsl:with-param name="fieldname">other_ref_agencyID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name" mode="do-field">
            <xsl:with-param name="fieldname">other_ref_agencyName</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:PIID" mode="do-field">
            <xsl:with-param name="fieldname">other_ref_PIID</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:modNumber" mode="do-field">
            <xsl:with-param name="fieldname">other_ref_modNumber</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:signedDate" mode="do-field">
            <xsl:with-param name="fieldname">signedDate</xsl:with-param></xsl:apply-templates>
        <xsl:apply-templates select="//ns1:obligatedAmount" mode="do-field">
            <xsl:with-param name="fieldname">obligatedAmount</xsl:with-param></xsl:apply-templates>
        <!-- TODO: add the other fields -->
    </xsl:template>

    <xsl:template match="node() | @*" mode="do-field">
        <xsl:param name="fieldname"/>
        <!-- check if matching node exists -->
        <xsl:if test="current()">
            <xsl:if test="position() = 1">
                <xsl:value-of select="$fieldname"/>
            </xsl:if>
            <xsl:value-of select="$delimiter"/>
            <!-- output current node value -->
            <xsl:value-of select="." />
            <xsl:if test="position() = last()">
                <!-- output newline -->
                <xsl:text>&#xa;</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>