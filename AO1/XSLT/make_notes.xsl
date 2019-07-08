<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni ../AO1.XML oz. ../../AO2/AO2.xml -->
    <!-- združim kazalke na opombe (med besedilom) in besedilo opomb (na koncu poglavij) -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:ref[matches(@target,'^#ftn\.')]">
        <xsl:variable name="noteID" select="substring-after(@target, '#')"/>
        <note place="end" xml:id="{$noteID}" n="{tei:hi[@rend='superscript']}">
            <xsl:apply-templates select="//tei:note/tei:p[@xml:id=$noteID]" mode="note"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:note[tei:p[matches(@xml:id,'^ftn\.')]]">
        <!-- ne procesiram: odstranim -->
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="note">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="note"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p[matches(@xml:id,'^ftn\.')]" mode="note">
        <xsl:apply-templates mode="note"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='superscript']" mode="note">
        <!-- ne procesiram -->
    </xsl:template>
    
</xsl:stylesheet>