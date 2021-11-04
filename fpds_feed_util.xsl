<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.w3.org/2005/Atom" xmlns:ns1="https://www.fpds.gov/FPDS">

    <xsl:output method="text" />
    <!-- use TAB as the delimiter as commas exist in the data -->
    <xsl:variable name="delimiter" select="'&#x9;'"/>
    <xsl:variable name="newline" select="'&#xa;'"/>
    <!-- use semicolon to separate the multiple entries of the target node or field -->
    <xsl:variable name="rec-delimiter" select="'&#x3b;'"/>

    <!-- use the feed/entry node-set to create a blank column in the output file for a path not found in source data -->
    <xsl:variable name="content-nodeset" select="/f:feed/f:entry/f:content"/>
 
    <xsl:template match="f:content" mode="generic-node">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//*[local-name() = $fieldname]"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="f:content" mode="generic-attr">
        <xsl:param name="fieldname"/>
        <xsl:param name="attrname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="concat($fieldname,'-',$attrname)"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//*[local-name()=$fieldname]/attribute::*[local-name()=$attrname]"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="agencyID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID | .//ns1:IDV/ns1:contractID/ns1:IDVID/ns1:agencyID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="agencyName">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name | .//ns1:IDV/ns1:contractID/ns1:IDVID/ns1:agencyID/@name"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="PIID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:awardContractID/ns1:PIID | .//ns1:IDV/ns1:contractID/ns1:IDVID/ns1:PIID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="modNumber">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:awardContractID/ns1:modNumber | .//ns1:IDV/ns1:contractID/ns1:IDVID/ns1:modNumber"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="transactionNumber">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:awardContractID/ns1:transactionNumber"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="ref-agencyID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID | .//ns1:IDV/ns1:contractID/ns1:referencedIDVID/ns1:agencyID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="ref-agencyName">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name | .//ns1:IDV/ns1:contractID/ns1:referencedIDVID/ns1:agencyID/@name"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="ref-PIID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:PIID | .//ns1:IDV/ns1:contractID/ns1:referencedIDVID/ns1:PIID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="ref-modNumber">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:awardID/ns1:referencedIDVID/ns1:modNumber | .//ns1:IDV/ns1:contractID/ns1:referencedIDVID/ns1:modNumber"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-agencyID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:agencyID | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:IDVID/ns1:agencyID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-agencyName">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:agencyID/@name | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:IDVID/ns1:agencyID/@name"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-PIID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:PIID | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:IDVID/ns1:PIID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-modNumber">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:modNumber | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:IDVID/ns1:modNumber"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-transactionNumber">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:awardContractID/ns1:transactionNumber"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-ref-agencyID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:agencyID | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:referencedIDVID/ns1:agencyID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-ref-agencyName">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:agencyID/@name | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:referencedIDVID/ns1:agencyID/@name"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-ref-PIID">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:PIID | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:referencedIDVID/ns1:PIID"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="other-ref-modNumber">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:award/ns1:listOfOtherIDsForThisAward/ns1:awardID/ns1:referencedIDVID/ns1:modNumber | .//ns1:IDV/ns1:listOfOtherIDsForThisIDV/ns1:referencedIDVID/ns1:modNumber"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
     </xsl:template>

    <xsl:template match="f:content" mode="vendor-countryCode">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:vendorLocation/ns1:countryCode"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="f:content" mode="vendor-countryName">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:vendorLocation/ns1:countryCode/@name"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="f:content" mode="performance-countryCode">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:principalPlaceOfPerformance/ns1:countryCode"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="f:content" mode="performance-countryName">
        <xsl:param name="fieldname"/>
        <xsl:if test="position() = 1">
            <xsl:value-of select="$fieldname"/>
        </xsl:if>
        <xsl:value-of select="$delimiter"/>
        <xsl:variable name="targetnodes" select=".//ns1:principalPlaceOfPerformance/ns1:countryCode/@name"/>
        <xsl:variable name="nodecount" select="count($targetnodes)"/>
        <xsl:for-each select="$targetnodes">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="$nodecount > 1 and not(position() = last())">
                <xsl:value-of select="$rec-delimiter"/>
            </xsl:if>
        </xsl:for-each> 
        <xsl:if test="position() = last()">
            <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>