<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="https://www.fpds.gov/FPDS">
  <xsl:output method="text" />
 
  <xsl:variable name="delimiter" select="','" />
 
   <xsl:variable name="fieldArray_1">
    <field prefix="">agencyID</field>
    <field prefix="">PIID</field>
    <field prefix="">modNumber</field>
    <field prefix="">transactionNumber</field>
  </xsl:variable>
  <xsl:variable name="fieldArray_2">
    <field prefix="ref-">agencyID</field>
    <field prefix="ref-">PIID</field>
    <field prefix="ref-">modNumber</field>
  </xsl:variable>
  <!-- define an array containing the fields we are interested in -->
  <xsl:variable name="fieldArray">
    <field prefix="">agencyID</field>
    <field prefix="">PIID</field>
    <field prefix="">modNumber</field>
    <field prefix="">transactionNumber</field>
    <field prefix="ref-">agencyID</field>
    <field prefix="ref-">PIID</field>
    <field prefix="ref-">modNumber</field>
  </xsl:variable>


  <xsl:param name="fields" select="document('')/*/xsl:variable[@name='fieldArray']/*" />
  <xsl:param name="fields_1" select="document('')/*/xsl:variable[@name='fieldArray_1']/*" />
  <!-- <xsl:param name="fields_2" select="document('')/*/xsl:variable[@name='fieldArray_2']/*" /> -->
 
  <xsl:template match="/">
 
    <!-- output the header row -->
    <xsl:for-each select="$fields">
      <xsl:if test="position() != 1">
        <xsl:value-of select="$delimiter"/>
      </xsl:if>
      <xsl:for-each select=".">
        <xsl:value-of select="concat(@prefix, text())" />
      </xsl:for-each>
    </xsl:for-each>
 
    <!-- output newline -->
    <xsl:text>&#xa;</xsl:text>
 
    <xsl:apply-templates select="//ns1:awardID/ns1:awardContractID" >
      <xsl:with-param name="myfields" select="document('')/*/xsl:variable[@name='fieldArray_1']/*" />
    </xsl:apply-templates>
    <xsl:apply-templates select="//ns1:awardID/ns1:referencedIDVID" />

    <!-- output newline -->
    <xsl:text>&#xa;</xsl:text>

  </xsl:template>
 
  <xsl:template match="ns1:awardContractID | ns1:referencedIDVID">
    <xsl:param name="myfields" />
    <xsl:text select="$fieldArray1" />
    <xsl:variable name="currNode" select="." />
    <!-- output the data row -->
    <!-- loop over the field names and find the value of each one in the xml -->
    <!-- <xsl:for-each select="$fields">
      <xsl:if test="position() != 1">
        <xsl:value-of select="$delimiter"/>
      </xsl:if> -->
      <!-- use substring() to skip the namespace prefix ns1: -->
      <!-- <xsl:value-of select="$currNode/*[substring(name(), 5) = current()]" />
    </xsl:for-each> -->
 
    <!-- output newline -->
    <!-- <xsl:text>&#xa;</xsl:text> -->
  
  </xsl:template>
</xsl:stylesheet>