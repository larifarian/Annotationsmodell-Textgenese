<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:test="http://www.hans.de" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:decimal-format name="d" decimal-separator="," grouping-separator="."/>

    <!-- Variable für alles -->
    <xsl:variable name="Alles">
        <xsl:copy-of select="/"/>
    </xsl:variable>

    <!-- Variable Split -->
    <xsl:variable name="Split">
        <xsl:for-each select="//taxonomy[@xml:id = 'split']/category/catDesc">
            <xsl:value-of select="."/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
    </xsl:variable>

    <!-- Farbtafel -->
    <xsl:variable name="Farbtafel">
        <farben>
            <farbe n="IN">#2A5A6F</farbe>
            <farbe n="DL">#343E79</farbe>
            <farbe n="TF">#B0903E</farbe>
            <farbe n="RP">#8D3165</farbe>
            <farbe n="RO">#B07A3E</farbe>
        </farben>
    </xsl:variable>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Transkription UBG Ms 781</title>
                <!-- CSS -->
                <style>
                    body{
                    
                        margin-left: auto;
                        margin-right: auto;
                    }
                    span.active_Link{
                        background-color: yellow
                    }
                    .mod:hover{
                        background-color: yellow
                    }
                    /* Tooltip container */
                    .tooltip{
                        position: relative;
                        display: inline-block;
                        /*border-bottom: 1px dotted black;  If you want dots under the hoverable text */
                    }
                    
                    /* Tooltip text */
                    .tooltip .tooltiptext{
                        visibility: hidden;
                        width: 120px;
                        background-color: #555;
                        color: #fff;
                        text-align: center;
                        padding: 5px 0;
                        border-radius: 6px;
                    
                        /* Position the tooltip text */
                        position: absolute;
                        z-index: 1;
                        bottom: 125%;
                        left: 50%;
                        margin-left: -60px;
                    
                        /* Fade in tooltip */
                        opacity: 0;
                        transition: opacity 0s;
                    }
                    
                    /* Tooltip arrow */
                    .tooltip .tooltiptext::after{
                        content: "";
                        position: absolute;
                        top: 100%;
                        left: 50%;
                        margin-left: -5px;
                        border-width: 5px;
                        border-style: solid;
                        border-color: #555 transparent transparent transparent;
                    }
                    
                    /* Show the tooltip text when you mouse over the tooltip container */
                    .tooltip:hover .tooltiptext{
                        visibility: visible;
                        opacity: 1;
                    }</style>

                <!-- JavaScript -->

                <script language="javascript" type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.slim.min.js"/>
                <script language="javascript" type="text/javascript" src="js/scrollToFixed.js"/>
                <script language="javascript" type="text/javascript" src="js/box.js"/>
            </head>
            <body>
                <table border="0" width="100%" style="padding:50px">
                    <tr>
                        <td style="vertical-align:top; width:60%">
                            <h1>
                                <xsl:value-of select="'UBG Ms 781'"/>
                            </h1>
                            <ul id="start" style="list-style-type:none;text-indent:-2em">
                                <xsl:for-each select="TEI/text/body/div">
                                    <li>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('#', @type)"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="@type"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                            <xsl:apply-templates select="TEI/text/body/div"/>
                        </td>
                        <td style="vertical-align:top; width:40%">
                            <div class="OuterBox" style="position:relative">
                                <div id="InfoBox"/>
                                <div>
                                    <xsl:for-each select="//category">
                                        <img src="{concat('images/',@xml:id,'.png')}" id="{@xml:id}"
                                            style="position:absolute !important; visibility:hidden; width:200px; height:100px"
                                        />
                                    </xsl:for-each>
                                </div>
                            </div>


                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>

    <!-- Template div -->
    <xsl:template match="div">
        <div style="margin-bottom:50px; margin-top: 50px">
            <xsl:attribute name="id">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <a href="#start">zurück</a>


            <!-- Variable Liste Typen -->
            <xsl:variable name="Liste">
                <xsl:for-each select=".//mod">
                    <!-- Variable Typ der Modifikation -->
                    <!-- Zusammensetzen der @ana Attribute -->
                    <xsl:variable name="TypeMod">
                        <xsl:if test="@ana">
                            <xsl:value-of select="@ana"/>
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="*[not(self::mod)]" mode="type"/>
                    </xsl:variable>
                    <!-- Normalisieren der Variable -->
                    <xsl:variable name="Type_normalized">
                        <xsl:choose>
                            <xsl:when test="ends-with($TypeMod, '.')">
                                <xsl:value-of
                                    select="substring-after(substring($TypeMod, 1, string-length($TypeMod) - 1), '.')"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(., '.')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <test:knoten>
                        <xsl:value-of select="$Type_normalized"/>
                    </test:knoten>
                </xsl:for-each>
            </xsl:variable>
            <table border="0" width="50%" id="2">
                <tr style="background-color:black; color: white">
                    <td align="right" width="10%">Rang</td>
                    <td align="left" width="55%">Typ</td>
                    <td align="right" width="15%">abs.</td>
                    <td align="right" width="15%">in %</td>
                    <td align="right" width="5%"/>
                </tr>
                <xsl:for-each-group select="$Liste//test:knoten" group-by="substring(., 1, 2)">
                    <xsl:sort select="count(current-group())" order="descending"/>
                    <xsl:variable name="typ" select="current-grouping-key()"/>
                    <xsl:variable name="color">
                        <xsl:value-of select="$Farbtafel/*/*[@n = $typ]"/>
                    </xsl:variable>
                    <tr style="; font-size:8pt;background-color:{$color}; opacity:1; color:white">
                        <td>
                            <span style="float:right">
                                <xsl:value-of select="position()"/>
                            </span>
                        </td>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>
                            <xsl:value-of
                                select="concat(' (', $Alles//category[@xml:id = current-grouping-key()]/catDesc[2]/title, ')')"
                            />
                        </td>
                        <td>
                            <span style="float:right">
                                <xsl:value-of select="count(current-group())"/>
                            </span>
                        </td>
                        <td>
                            <span style="float:right">
                                <xsl:value-of
                                    select="format-number((count(current-group()) div count($Liste//test:knoten) * 100), '#.##0,00', 'd')"
                                />
                            </span>
                        </td>
                        <td>
                            <input type="checkbox" class="{$typ}"/>
                        </td>
                    </tr>
                </xsl:for-each-group>


            </table>

            <hr/>

            <table border="0" width="50%" id="2">
                <tr style="background-color:black; color: white">
                    <td align="right" width="10%">Rang</td>
                    <td align="left" width="60%">Typ</td>
                    <td align="right" width="15%">abs.</td>
                    <td align="right" width="15%">in %</td>

                </tr>
                <xsl:for-each-group select="$Liste//test:knoten" group-by=".">
                    <xsl:sort select="count(current-group())" order="descending"/>
                    <xsl:variable name="typ" select="current-grouping-key()"/>
                    <xsl:variable name="color">
                        <xsl:value-of select="$Farbtafel/*/*[@n = $typ]"/>
                    </xsl:variable>
                    <tr>
                        <td>
                            <span style="float:right">
                                <xsl:value-of select="position()"/>
                            </span>
                        </td>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>

                        </td>
                        <td>
                            <span style="float:right">
                                <xsl:value-of select="count(current-group())"/>
                            </span>
                        </td>
                        <td>
                            <span style="float:right">
                                <xsl:value-of
                                    select="format-number((count(current-group()) div count($Liste//test:knoten) * 100), '#.##0,00', 'd')"
                                />
                            </span>
                        </td>

                    </tr>
                </xsl:for-each-group>


            </table>



            <h1>
                <xsl:value-of select="replace(@type, '_', ' ')"/>
            </h1>
            <xsl:apply-templates select="lg/l"/>
        </div>
        <hr/>
    </xsl:template>

    <!-- Template l -->
    <xsl:template match="l">
        <xsl:choose>
            <xsl:when test=".//mod">
                <p class="color"
                    style="border-width: 0px 0px 0px 5px; border-left-style:solid; border-color:red; text-indent: 5px; margin: 0px; padding:5px">
                    <span style="color:blue;">
                        <xsl:value-of select="concat(substring-after(@xml:id, '_'), ': ')"/>
                    </span>
                    <xsl:apply-templates select="text() | *"/>
                </p>
            </xsl:when>
            <xsl:when test="not(.//mod)">
                <p class="color"
                    style="border-width: 0px 0px 0px 5px; border-left-style:solid;border-color: white;  text-indent: 5px; margin: 0px; padding:5px">
                    <span style="color:blue;">
                        <xsl:value-of select="concat(substring-after(@xml:id, '_'), ': ')"/>
                    </span>
                    <xsl:apply-templates select="text() | *"/>
                </p>
            </xsl:when>
        </xsl:choose>
        <xsl:call-template name="table"/>
    </xsl:template>

    <!-- Template text() -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Template mod -->
    <xsl:template match="mod">

        <!-- Variable Typ der Modifikation -->
        <!-- Zusammensetzen der @ana Attribute -->
        <xsl:variable name="TypeMod">
            <xsl:if test="@ana">
                <xsl:value-of select="@ana"/>
                <xsl:text>.</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="*[not(self::mod)]" mode="type"/>
        </xsl:variable>
        <!-- Normalisieren der Variable -->
        <xsl:variable name="Type_normalized">
            <xsl:choose>
                <xsl:when test="ends-with($TypeMod, '.')">
                    <xsl:value-of
                        select="substring-after(substring($TypeMod, 1, string-length($TypeMod) - 1), '.')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(., '.')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>



        <xsl:variable name="typ">
            <xsl:value-of select="substring($Type_normalized, 1, 2)"/>
        </xsl:variable>

        <!-- Variable id -->
        <xsl:variable name="id" select="generate-id()"/>
        <span style="color:red; cursor:pointer;" onclick="infobox('{$id}')" id="{$id}"
            class="{$typ} mod">
            <xsl:apply-templates select="* | text()"/>
        </span>

        <!-- Variablen Typ der Modifikation -->

        <!-- Zusammensetzen der @ana Attribute 1. -->
        <xsl:variable name="TypeMod">
            <xsl:if test="@ana">
                <xsl:value-of select="@ana"/>
                <xsl:text>.</xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="*[contains($Split, @ana)]">
                    <xsl:value-of select="*/@ana"/>
                    <xsl:text>.</xsl:text>
                    <xsl:apply-templates select="*/*[not(self::mod)][@ana][1]" mode="type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[not(self::mod)]" mode="type"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <!-- Normalisieren der Variable 1. -->
        <xsl:variable name="Type_normalized">
            <xsl:choose>
                <xsl:when test="ends-with($TypeMod, '.')">
                    <xsl:value-of
                        select="substring-after(substring($TypeMod, 1, string-length($TypeMod) - 1), '.')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(., '.')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Zusammensetzen der @ana Attribute 2. -->
        <xsl:variable name="TypeMod2">
            <xsl:if test="@ana">
                <xsl:value-of select="@ana"/>
                <xsl:text>.</xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="*[contains($Split, @ana)]">
                    <xsl:value-of select="*/@ana"/>
                    <xsl:text>.</xsl:text>
                    <xsl:apply-templates select="*/*[not(self::mod)][@ana][2]" mode="type"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>


        <!-- Normalisieren der Variable 2. -->
        <xsl:variable name="Type_normalized2">
            <xsl:choose>
                <xsl:when test="ends-with($TypeMod2, '.')">
                    <xsl:value-of
                        select="substring-after(substring($TypeMod2, 1, string-length($TypeMod2) - 1), '.')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(., '.')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <!-- Box Typ der Modifikation -->
        <table style="border: 1px solid #000000; display:none; margin-top: 25px; color:red"
            id="{$id}">

            <!-- 1. Variable -->
            <xsl:for-each select="tokenize($Type_normalized, '\.')">
                <xsl:variable name="aktueller1" select="position()"/>
                <tr>
                    <xsl:for-each select="tokenize($Type_normalized, '\.')">
                        <xsl:variable name="aktueller2" select="position()"/>
                        <td>
                            <xsl:if test="$aktueller1 = $aktueller2">
                                <div class="tooltip" id="{current()}">
                                    <xsl:value-of
                                        select="$Alles//category[@xml:id = current()]/catDesc[2]/title"/>
                                    <span class="tooltiptext">
                                        <xsl:value-of
                                            select="$Alles//category[@xml:id = current()]/catDesc[2]/text()"
                                        />
                                    </span>
                                </div>

                            </xsl:if>
                            <xsl:if test="$aktueller1 - 1 = $aktueller2">
                                <xsl:attribute name="align" select="'right'"> </xsl:attribute>
                                <xsl:text>&#x21B3;</xsl:text>
                            </xsl:if>
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>




            <!-- 2. Variable -->
            <xsl:for-each select="tokenize($Type_normalized2, '\.')">
                <xsl:variable name="aktueller1" select="position()"/>
                <tr>
                    <xsl:for-each select="tokenize($Type_normalized2, '\.')">
                        <xsl:variable name="aktueller2" select="position()"/>
                        <td>
                            <xsl:if test="$aktueller1 = $aktueller2">

                                <xsl:if
                                    test="not(tokenize($Type_normalized, '\.')[position() = $aktueller2] = current())">
                                    <div class="tooltip" id="{current()}">
                                        <xsl:value-of
                                            select="$Alles//category[@xml:id = current()]/catDesc[2]/title"/>
                                        <span class="tooltiptext">
                                            <xsl:value-of
                                                select="$Alles//category[@xml:id = current()]/catDesc[2]/text()"
                                            />
                                        </span>
                                    </div>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="$aktueller1 - 1 = $aktueller2">
                                <xsl:attribute name="align" select="'right'"> </xsl:attribute>
                                <xsl:text>&#x21B3;</xsl:text>
                            </xsl:if>
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>


        </table>


    </xsl:template>

    <!-- Ausgabe Elemente -->
    <xsl:template match="*">
        <xsl:apply-templates select="text() | *"/>
    </xsl:template>

    <!-- Ausgabe @ana für Variable Typ der Modifikation -->
    <xsl:template mode="type" match="*">
        <xsl:if test="@ana">
            <xsl:value-of select="@ana"/>
            <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="*[not(self::mod)]" mode="type"/>
    </xsl:template>

    <!-- Tabelle -->
    <xsl:template name="table">
        <hr/>
        <xsl:for-each select="//mod">
            <xsl:variable name="ID">
                <xsl:for-each
                    select="descendant::*[not(ancestor-or-self::mod[self::* != current()])]">
                    <xsl:variable name="row">
                        <xsl:value-of select="count(ancestor::*[@ana] | preceding-sibling::*[@ana])"/>



                    </xsl:variable>
                    <xsl:variable name="col">
                        <xsl:value-of
                            select="count(ancestor::*[@ana] | ancestor::*/preceding-sibling::*[@ana] | ancestor::*/following-sibling::*[@ana]) - 1"/>

                    </xsl:variable>
                    <xsl:for-each select="tokenize(@ana, '\.')">
                        <test:knoten>
                            <xsl:attribute name="test">
                                <xsl:value-of select="$row"/>
                                <xsl:text>:</xsl:text>
                                <xsl:value-of select="position() + $col"/>
                            </xsl:attribute>
                            <xsl:value-of select="current()"/>
                        </test:knoten>


                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="anzahl_td">
                <xsl:for-each
                    select="descendant::*[not(ancestor-or-self::mod[self::* != current()])][string-length(@ana) > string-length(following-sibling::*/@ana) and string-length(@ana) > string-length(preceding-sibling::*/@ana)]">
                    <xsl:for-each select="tokenize(@ana, '\.')">
                        <test:knoten/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="anzahl_tr">
                <xsl:for-each
                    select="descendant::*[not(ancestor-or-self::mod[self::* != current()])]">
                    <xsl:for-each select="tokenize(@ana, '\.')">
                        <test:knoten/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>



            <!-- <xsl:text>Spalten: </xsl:text> <xsl:value-of select="sum($anzahl_td/test:knoten)"/><xsl:text>; </xsl:text>
        <xsl:text>Zeilen: </xsl:text> <xsl:value-of select="sum($anzahl_tr/test:knoten)"/><xsl:text>; </xsl:text>-->
            <table border="1">
                <xsl:for-each select="$anzahl_tr/test:knoten">
                    <xsl:variable name="row">
                        <xsl:value-of select="position()"/>
                    </xsl:variable>
                    <tr>
                        <xsl:for-each select="$anzahl_td/test:knoten">
                            <td>
                                <xsl:variable name="id">
                                    <xsl:value-of select="concat($row, ':', position())"/>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$id = $ID/test:knoten/@test">
                                        <span style="color:blue">
                                            <xsl:value-of select="$ID/test:knoten[@test = $id]"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$id"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </table>
            
            <hr/>
            <xsl:for-each select="$ID/test:knoten">
                <xsl:value-of select="concat(@test, ':', ., ' ;')"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
