<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output omit-xml-declaration="yes" indent="yes" encoding="iso-8859-1"/>

    <!-- the starting point -->
    <xsl:template match="/">
        <root>
        <xsl:apply-templates select="/html/body/div"/>
        </root>
    </xsl:template>

    <!-- a div is a dictionary entry -->
    <xsl:template match="div">
        <entry>
            <xsl:apply-templates select="p[@class='p']" />
        </entry>
    </xsl:template>

    <!-- a title -->
    <xsl:template match="p[@class='p']">
        <definition>
            <xsl:variable name="t" select="generate-id(current())" />
            <xsl:choose>
                <!-- this title is about an expression -->
                <xsl:when test="a[@name]">
                    <expression>
                        <xsl:apply-templates select="a[@name]" />
                    </expression>
                </xsl:when>
            </xsl:choose>
            <!-- this is the tricky part: iterate over the sibling sections related to this one -->
            <xsl:for-each select="following-sibling::p[@class='q']">
                <xsl:if test="generate-id(preceding-sibling::p[@class='p'][1]) = $t">
                    <xsl:apply-templates select="." />
                </xsl:if>
            </xsl:for-each>
        </definition>
    </xsl:template>

    <!-- a definition -->
    <xsl:template match="p[@class = 'q']">
        <xsl:choose>
            <!-- explaining the origin of the word -->
            <xsl:when test="span[@class='a']">
                <origin>
                    <xsl:apply-templates select="span[@class='a']" />
                </origin>
            </xsl:when>
            <!-- a see also reference -->
            <xsl:when test="a[@href != '' and @target != '']">
                <see>
                    <xsl:value-of select="." />
                </see>
            </xsl:when>
            <!-- a generic definition -->
            <xsl:otherwise>
                <p>
                    <!-- a usage section -->
                    <xsl:if test=".//span[@title]">
                        <usage>
                            <xsl:apply-templates select=".//span[@title]" />
                        </usage>
                    </xsl:if>
                    <!-- the definition itself -->
                    <xsl:apply-templates select="span[@class = 'b' or @class = 'c']" />
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- extract text from a 'origin' span -->
    <xsl:template match="span[@class = 'a']">
        <xsl:value-of select="." />
    </xsl:template>

    <!-- extract text from an 'expression' span -->
    <xsl:template match="a[@name]">
        <xsl:value-of select="../span[@class='k']" />
    </xsl:template>

    <!-- extract text from a 'definition itself' span -->
    <xsl:template match="span[@class = 'b']">
        <text>
            <xsl:value-of select=".//span[@class = 'c']" />
            <xsl:value-of select="." />
        </text>
        <xsl:apply-templates select="span[@class = 'h']" />
    </xsl:template>

    <!-- extract text from an 'example' span -->
    <xsl:template match="span[@class = 'h']">
        <example>
            <xsl:value-of select="." />
        </example>
    </xsl:template>

    <!-- extract text from a 'use' span -->
    <xsl:template match="span[@title]">
        <use>
            <xsl:value-of select="@title" />
        </use>
    </xsl:template>
</xsl:stylesheet>