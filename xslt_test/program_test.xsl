<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output indent="no" method="text"/>

    <xsl:template match="/">
        <xsl:variable name="headers" select="//Event//@channel[not(.=../../preceding-sibling::Event//@channel)]"/>
        <xsl:call-template name="do-header">
            <xsl:with-param name="headers" select="$headers"/>
        </xsl:call-template>
        <xsl:text>&#xa;</xsl:text>

        <xsl:apply-templates select="Program/Event" mode="do-event">
            <xsl:with-param name="headers" select="$headers"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="do-header">
        <xsl:param name="headers"/>
        <xsl:text>Time,</xsl:text>
        <xsl:for-each select="$headers">
            <xsl:value-of select="."/>
            <xsl:text>,</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="Event" mode="do-event">
        <xsl:param name="headers"/>
        <xsl:variable name="thisevent" select="."/>
        <xsl:value-of select="StartTime/text()"/>
        <xsl:value-of select="StartTime/@units"/>
        <xsl:text>,</xsl:text>

        <xsl:for-each select="$headers">
            <xsl:variable name="thischan" select="."/>
            <xsl:for-each select="$thisevent/*[@channel=$thischan]">
                <xsl:value-of select="substring(name(),6)"/>
            </xsl:for-each>
            <xsl:text>,</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
