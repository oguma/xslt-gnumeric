<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:gnm="http://www.gnumeric.org/v10.dtd"
    exclude-result-prefixes="exsl gnm"
    version="1.0">
    
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:param name="sheetname"/>
    
    <xsl:variable name="sheet">
        <xsl:choose>
            <xsl:when test="$sheetname">
                <xsl:copy-of select="/gnm:Workbook/gnm:Sheets/gnm:Sheet[gnm:Name=$sheetname]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="/gnm:Workbook/gnm:Sheets/gnm:Sheet[1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="maxrow">
        <xsl:for-each select="exsl:node-set($sheet)/gnm:Sheet/gnm:Cells/gnm:Cell/@Row">
            <xsl:sort data-type="number" order="descending"/>
            <xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="maxcol">
        <xsl:for-each select="exsl:node-set($sheet)/gnm:Sheet/gnm:Cells/gnm:Cell/@Col">
            <xsl:sort data-type="number" order="descending"/>
            <xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/">
        <table>
            <tr>
                <xsl:for-each select="exsl:node-set($sheet)/gnm:Sheet/gnm:Cells/gnm:Cell[@Row=0]">
                    <th><xsl:value-of select="."/></th>
                </xsl:for-each>
            </tr>
            <xsl:call-template name="tr"/>
        </table>
    </xsl:template>
    
    <xsl:template name="tr">
        <xsl:param name="index" select="1"/>
        <xsl:param name="maxValue" select="$maxrow"/>
        <tr>
            <xsl:call-template name="td">
                <xsl:with-param name="row" select="$index"/>
            </xsl:call-template>
        </tr>
        <xsl:if test="$maxValue > $index">
            <xsl:call-template name="tr">
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="total" select="$maxValue"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="td">
        <xsl:param name="index" select="0"/>
        <xsl:param name="maxValue" select="$maxcol"/>
        <xsl:param name="row"/>
        <td><xsl:value-of select="exsl:node-set($sheet)/gnm:Sheet/gnm:Cells/gnm:Cell[@Row=$row and @Col=$index]"/></td>
        <xsl:if test="$maxValue > $index">
            <xsl:call-template name="td">
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="total" select="$maxValue"/>
                <xsl:with-param name="row" select="$row"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
