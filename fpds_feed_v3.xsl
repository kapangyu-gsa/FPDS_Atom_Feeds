<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:output method="text" />
    <xsl:variable name="delimiter" select="','" />
 
    <xsl:template match="/">
        <xsl:text>agencyID</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID" mode="do-field"/>
        <xsl:text>agencyName</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name" mode="do-field"/>
        <xsl:text>PIID</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:PIID" mode="do-field" />
        <xsl:text>modNumber</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:modNumber" mode="do-field" />
        <xsl:text>transactionNumber</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:awardContractID/ns1:transactionNumber" mode="do-field" />
        <xsl:text>ref_agencyID</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID" mode="do-field"/>
        <xsl:text>ref_agencyName</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name" mode="do-field"/>
        <xsl:text>ref_PIID</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:PIID" mode="do-field"/>
        <xsl:text>ref_modNumber</xsl:text>
            <xsl:apply-templates select="//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:modNumber" mode="do-field" />
        <xsl:text>signedDate</xsl:text>
            <xsl:apply-templates select="//ns1:signedDate" mode="do-field"/>
        <xsl:text>obligatedAmount</xsl:text>
            <xsl:apply-templates select="//ns1:obligatedAmount" mode="do-field"/>
        <!-- TODO: add the other fields -->
    </xsl:template>

    <xsl:template match="node() | @*" mode="do-field">
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="." />
        <xsl:if test="position() = last()">
            <!-- output newline -->
            <xsl:text>&#xa;</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>