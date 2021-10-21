<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://www.w3.org/2005/Atom" xmlns:ns1="https://www.fpds.gov/FPDS">
    <xsl:output method="text" />

    <xsl:variable name="delimiter" select="','" />
 
    <xsl:variable name="fieldArray">
        <field prefix="">agencyID</field>
        <!-- <field prefix="agency_">name</field> -->
        <field prefix="">PIID</field>
        <field prefix="">modNumber</field>
        <field prefix="">transactionNumber</field>
        <field prefix="ref-">agencyID</field>
        <field prefix="ref-">PIID</field>
        <field prefix="ref-">modNumber</field>
    </xsl:variable>
    <xsl:param name="fields" select="document('')/*/xsl:variable[@name='fieldArray']/*" />

    <xsl:template match="/">
        <!-- output the header row -->
        <!-- <xsl:for-each select="$fields">
            <xsl:if test="position() != 1">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
            <xsl:for-each select=".">
                <xsl:value-of select="concat(@prefix, text())" />
            </xsl:for-each>
        </xsl:for-each> -->
    
        <!-- output newline -->
        <!-- <xsl:text>&#xa;</xsl:text> -->
    
        <xsl:apply-templates select="/f:feed" />


    </xsl:template>
 
    <xsl:template match="f:feed">
        <xsl:text>agencyID,</xsl:text>
        <xsl:apply-templates select="//ns1:awardContractID/ns1:agencyID" mode="general"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>agencyName,</xsl:text>
        <xsl:apply-templates select="//ns1:awardContractID/ns1:agencyID/@name" mode="general"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>PIID,</xsl:text>
        <xsl:apply-templates select="//ns1:awardID/ns1:awardContractID/ns1:PIID" mode="general" />
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>ref_agencyID,</xsl:text>
        <xsl:apply-templates select="//ns1:referencedIDVID/ns1:agencyID" mode="general"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>ref_PIID,</xsl:text>
        <xsl:apply-templates select="//ns1:awardID/ns1:referencedIDVID/ns1:PIID" mode="general"/>
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>signedDate,</xsl:text>
        <xsl:apply-templates select="//ns1:signedDate" mode="general"/>
        <xsl:text>&#xa;</xsl:text>


    </xsl:template>

    <xsl:template match="node() | @*" mode="general">
        <xsl:value-of select="." />
        <xsl:if test="position() != last()">
            <xsl:value-of select="$delimiter"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>