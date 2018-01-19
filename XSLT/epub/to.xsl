<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:iso="http://www.iso.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  version="2.0" exclude-result-prefixes="#all"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <!-- import https://raw.githubusercontent.com/TEIC/Stylesheets/dev/epub3/tei-to-epub3.xsl -->  
  <xsl:import href="../../../publikacije-XSLT/Stylesheets-master/epub3/tei-to-epub3.xsl"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: See AUTHORS</p>
         <p>Author: Andrej Pančur</p>
         
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>
  
  <!-- Če določimo naslovnico v titlePage/@fasc, potem ni potrebno, da dodamo coverimage parameter.
       Če pa tega ne storimo, lahko tukaj dodamo samo ime datoteke naslovnice (ne pot) in 
       moramo zato sliko shraniti v istem direktoriju kot titlepage.html
  -->
  <!--<xsl:param name="coverimage">PREKMURJEcolor.jpg</xsl:param>-->
  
  <xsl:param name="documentationLanguage">sl</xsl:param>
  <xsl:param name="directory">out</xsl:param>
  
  <xsl:param name="numberHeadings">false</xsl:param>
  <xsl:param name="numberBackFigures">false</xsl:param>
  <xsl:param name="numberBackTables">false</xsl:param>
  <xsl:param name="numberBackHeadings"></xsl:param>
  <xsl:param name="numberFrontFigures">false</xsl:param>
  <xsl:param name="numberFrontHeadings"/>
  <xsl:param name="numberFrontTables">false</xsl:param>
  <xsl:param name="numberFigures">false</xsl:param>
  <xsl:param name="numberTables">false</xsl:param>
  <xsl:param name="numberParagraphs">false</xsl:param>
  <xsl:param name="autoToc">false</xsl:param>
  <xsl:param name="footnoteBackLink">true</xsl:param>
  
  <!-- css datoteke daj v direktorij, ki je relativno na XSLT in ne na XML -->
  <xsl:param name="cssFile">../../zrc-sazu-tei.css</xsl:param>
  <xsl:param name="cssPrintFile">../../zrc-sazu-epub-print.css</xsl:param>
  
  <xsl:param name="STDOUT">false</xsl:param>
  
  <!-- če hočemo, da div nimajo naslovov, potem jih moramo skonstrurirati (prazne) naslove,
    saj drugače toc.ncx ne more prikazati teh delov vsebine -->
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings" type="boolean">
    <desc>Whether to  construct a heading 
      for &lt;div&gt; elements with no &lt;head&gt; - by default, not.</desc>
  </doc>
  <xsl:param name="autoHead">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings">
    <desc>[common] How to make a heading for section if there is no
      &lt;head&gt;</desc>
    <param name="display"></param>
  </doc>
  <xsl:template name="autoMakeHead">
    <xsl:param name="display"/>
    <xsl:choose>
      <!--<xsl:when test="@n">
        <xsl:value-of select="@n"/>
      </xsl:when>-->
      <!-- lahko npr. dodam type v oklepajih -->
      <!--<xsl:when test="@type">
        <xsl:value-of select="concat('[',@type,']')"/>
      </xsl:when>-->
      <xsl:when test="tei:docDate">
        <xsl:apply-templates select="tei:docDate" mode="plain"/>
      </xsl:when>
      <xsl:otherwise>
        <!--<xsl:text>§</xsl:text>-->
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>V pagebrake odstranim oblikovanje: dodano besedilo [page ]</desc>
  </doc>
  <xsl:template match="tei:pb|tei:gb">
    <xsl:choose>
      <xsl:when test="$filePerPage='true'">
        <PAGEBREAK>
          <xsl:attribute name="name">
            <xsl:apply-templates select="." mode="ident"/>
          </xsl:attribute>
          <xsl:copy-of select="@facs"/>
        </PAGEBREAK>
      </xsl:when>
      <xsl:when test="$pagebreakStyle='active'">
        <div>
          <xsl:call-template name="makeRendition">
            <xsl:with-param  name="default" select="'pagebreak'"/>
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:when test="$pagebreakStyle='none'"/>
      <xsl:otherwise>
        <xsl:element name="{if (parent::tei:body or parent::tei:front
          or parent::tei:div  or parent::tei:back or
          parent::tei:lg or parent::tei:group) then 'div' else 'span'}">
          <xsl:call-template name="makeRendition">
            <xsl:with-param  name="default" select="'pagebreak'"/>
          </xsl:call-template>
          <xsl:call-template name="makeAnchor"/>
          <xsl:variable name="Words">
            <!--<xsl:text>[</xsl:text>-->
            <!-- odstranim -->
            <!--<xsl:sequence select="if (self::tei:gb) then tei:i18n('gathering') else tei:i18n('page')"/>-->
            <xsl:if test="@n">
              <!--<xsl:text> </xsl:text>-->
              <xsl:value-of select="@n"/>
            </xsl:if>
            <!--<xsl:text>]</xsl:text>-->
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$pagebreakStyle='simple'">
              <xsl:copy-of select="$Words"/>
            </xsl:when>
            <xsl:when test="rend='none'"/>
            <xsl:when test="$pagebreakStyle='display' and @facs">
              <div class="facsimage">
                <img src="{@facs}"/>
              </div>
            </xsl:when>
            <xsl:when test="starts-with(@facs,'unknown:')">
              <xsl:copy-of select="$Words"/>
            </xsl:when>
            <xsl:when test="@facs">
              <xsl:variable name="IMG">
                <xsl:choose>
                  <xsl:when test="starts-with(@facs,'#')">
                    <xsl:for-each select="id(substring(@facs,2))">
                      <xsl:value-of select="tei:graphic[1]/tei:resolveURI(.,@url)"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="tei:resolveURI(.,@facs)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <a href="{$IMG}">
                <xsl:copy-of select="$Words"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$Words"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] produce all the notes: Odstranim $noteHeading, 
      preko katerega se za sezname opomb napiše naslov Notes oz. Opombe, če je dokumentacija v Slovenščini </desc>
  </doc>
  <xsl:template name="printNotes">
    <xsl:if test="key('FOOTNOTES',1) or
      key('ENDNOTES',1) or  
      ($autoEndNotes='true' and key('ALLNOTES',1))
      or (self::tei:floatingText and .//tei:note)">
      <xsl:choose>
        <xsl:when test="$footnoteFile='true'">
          <xsl:variable name="BaseFile">
            <xsl:value-of select="$masterFile"/>
            <xsl:call-template name="addCorpusID"/>
          </xsl:variable>
          <xsl:variable name="outName">
            <xsl:call-template name="outputChunkName">
              <xsl:with-param name="ident">
                <xsl:value-of select="concat($BaseFile,'-notes')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$verbose='true'">
            <xsl:message>Opening file <xsl:value-of select="$outName"/>
            </xsl:message>
          </xsl:if>
          <xsl:result-document doctype-public="{$doctypePublic}" doctype-system="{$doctypeSystem}" encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}">
            <html>
              <xsl:call-template name="addLangAtt"/>
              <xsl:variable name="pagetitle">
                <xsl:sequence select="tei:generateTitle(.)"/>
                <!--<xsl:text>: </xsl:text>
                <xsl:sequence select="tei:i18n('noteHeading')"/>-->
              </xsl:variable>
              <xsl:sequence select="tei:htmlHead($pagetitle,1)"/>
              <body>
                <xsl:call-template name="bodyMicroData"/>
                <xsl:call-template name="bodyJavascriptHook"/>
                <xsl:call-template name="bodyHook"/>
                <div class="stdheader autogenerated">
                  <xsl:call-template name="stdheader">
                    <xsl:with-param name="title">
                      <xsl:sequence select="tei:generateTitle(.)"/>
                      <!--<xsl:text>: </xsl:text>
                      <xsl:sequence select="tei:i18n('noteHeading')"/>-->
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
                <div class="notes">
                  <xsl:choose>
                    <xsl:when test="$autoEndNotes='true'">
                      <!--<div class="noteHeading">
                        <xsl:sequence select="tei:i18n('noteHeading')"/>
                      </div>-->
                      <xsl:apply-templates mode="printnotes" select="key('ALLNOTES',1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="key('FOOTNOTES',1)">
                        <!--<div class="noteHeading footnotes">
                          <xsl:sequence select="tei:i18n('noteHeading')"/>
                        </div>-->
                        <xsl:apply-templates mode="printnotes" select="key('FOOTNOTES',1)"/>
                      </xsl:if>
                      <xsl:if test="key('ENDNOTES',1)">
                        <!--<div class="noteHeading endnotes">
                          <xsl:sequence select="tei:i18n('noteHeading')"/>
                        </div>-->
                        <xsl:apply-templates mode="printnotes" select="key('ENDNOTES',1)"/>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <xsl:call-template name="stdfooter"/>
                <xsl:call-template name="bodyEndHook"/>
              </body>
            </html>
          </xsl:result-document>
          <xsl:if test="$verbose='true'">
            <xsl:message>Closing file <xsl:value-of select="$outName"/>
            </xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="me">
            <xsl:apply-templates select="." mode="ident"/>
          </xsl:variable>
          <xsl:variable name="NOTES">
            <xsl:choose>
              <xsl:when test="self::tei:floatingText">
                <xsl:variable name="outer" select="generate-id(.)"/>
                <xsl:for-each select=".//tei:note[tei:isEndNote(.) or
                  tei:isFootNote(.)]">
                  <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:floatingText)=1">
                      <xsl:call-template name="makeaNote"/>
                    </xsl:when>
                    <xsl:when test="generate-id(ancestor-or-self::tei:floatingText[1])=$outer">
                      <xsl:call-template name="makeaNote"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="self::tei:TEI">
                <xsl:choose>
                  <xsl:when test="$autoEndNotes='true'">
                    <!--<div class="noteHeading">
                      <xsl:sequence select="tei:i18n('noteHeading')"/>
                    </div>-->
                    <xsl:apply-templates mode="printallnotes" select="key('ALLNOTES',1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="key('FOOTNOTES',1)">
                      <!--<div class="noteHeading">
                        <xsl:sequence select="tei:i18n('noteHeading')"/>
                      </div>-->
                      <xsl:apply-templates mode="printallnotes" select="key('FOOTNOTES',1)"/>
                    </xsl:if>
                    <xsl:if test="key('ENDNOTES',1)">
                      <!--<div class="noteHeading">
                        <xsl:sequence select="tei:i18n('noteHeading')"/>
                      </div>-->
                      <xsl:apply-templates mode="printallnotes" select="key('ENDNOTES',1)"/>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="self::tei:text and $splitLevel=0">
                <!--<div class="noteHeading">
                  <xsl:sequence select="tei:i18n('noteHeading')"/>
                </div>-->
                <xsl:for-each select="tei:front|tei:body|tei:back">
                  <xsl:for-each
                    select=".//tei:note[tei:isEndNote(.) or
                    tei:isFootNote(.)]">
                    <xsl:choose>
                      <xsl:when test="ancestor::tei:floatingText"/>
                      <xsl:otherwise>
                        <xsl:call-template name="makeaNote"/>
                      </xsl:otherwise>
                    </xsl:choose>		      
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="parent::tei:group and tei:group">
              </xsl:when>
              <xsl:otherwise>
                <!--<div class="noteHeading">
                  <xsl:sequence select="tei:i18n('noteHeading')"/>
                </div>-->
                <xsl:apply-templates mode="printnotes" select=".//tei:note">
                  <xsl:with-param name="whence" select="$me"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="where" select="name()"/>
          <xsl:for-each select="$NOTES">
            <xsl:if test="html:div[@class='note']">
              <xsl:comment>Notes in [<xsl:value-of select="$where"/>]</xsl:comment>
              <div class="notes">
                <xsl:copy-of select="*|comment()"/>
              </div>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="ancestor-or-self::tei:TEI/tei:text/descendant::tei:app">
      <div class="appcrit">
        <xsl:apply-templates mode="printnotes" select="descendant::tei:app"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Rodered list ol/li spremenim v samostojne odstavke</desc>
  </doc>
  <xsl:template match="tei:listBibl">
    <xsl:if test="tei:head">
      <xsl:element name="{if (not(tei:isInline(.))) then 'div' else 'span' }">
        <xsl:attribute name="class">listhead</xsl:attribute>
        <xsl:apply-templates select="tei:head"/>
      </xsl:element>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="tei:biblStruct and $biblioStyle = 'mla'">
        <div type="listBibl" xmlns="http://www.w3.org/1999/xhtml">
          <xsl:for-each select="tei:biblStruct">
            <p class="hang" xmlns="http://www.w3.org/1999/xhtml">
              <xsl:apply-templates select="tei:analytic" mode="mla"/>
              <xsl:apply-templates select="tei:monogr" mode="mla"/>
              <xsl:apply-templates select="tei:relatedItem" mode="mla"/>
              <xsl:choose>
                <xsl:when test="tei:note">
                  <xsl:apply-templates select="tei:note"/>
                </xsl:when>
                <xsl:when test="*//tei:ref/@target and not(contains(*//tei:ref/@target, '#'))">
                  <xsl:text>Web.&#10;</xsl:text>
                  <xsl:if test="*//tei:imprint/tei:date/@type = 'access'">
                    <xsl:value-of select="*//tei:imprint/tei:date[@type = 'access']"/>
                    <xsl:text>.</xsl:text>
                  </xsl:if>
                </xsl:when>
                <xsl:when
                  test="tei:analytic/tei:title[@level = 'u'] or tei:monogr/tei:title[@level = 'u']"/>
                <xsl:otherwise>Print.&#10;</xsl:otherwise>
              </xsl:choose>
              <xsl:if test="tei:monogr/tei:imprint/tei:extent"><xsl:value-of
                select="tei:monogr/tei:imprint/tei:extent"/>. </xsl:if>
              <xsl:if test="tei:series/tei:title[@level = 's']">
                <xsl:apply-templates select="tei:series/tei:title[@level = 's']"/>
                <xsl:text>. </xsl:text>
              </xsl:if>
            </p>
          </xsl:for-each>
        </div>
      </xsl:when>
      <xsl:when test="tei:biblStruct and not(tei:bibl)">
        <ol class="listBibl {$biblioStyle}">
          <xsl:for-each select="tei:biblStruct">
            <xsl:sort
              select="
              lower-case(normalize-space((@sortKey,
              tei:*[1]/tei:author/tei:surname
              ,
              tei:*[1]/tei:author/tei:orgName
              ,
              tei:*[1]/tei:author/tei:name
              ,
              tei:*[1]/tei:author
              ,
              tei:*[1]/tei:editor/tei:surname
              ,
              tei:*[1]/tei:editor/tei:name
              ,
              tei:*[1]/tei:editor
              ,
              tei:*[1]/tei:title[1])[1]))"/>
            <xsl:sort
              select="
              lower-case(normalize-space((
              tei:*[1]/tei:author/tei:forename
              ,
              tei:*[1]/tei:editor/tei:forename
              ,
              '')[1]))"/>
            <xsl:sort select="tei:monogr/tei:imprint/tei:date"/>
            <li>
              <xsl:call-template name="makeAnchor"/>
              <xsl:apply-templates select="."/>
            </li>
          </xsl:for-each>
        </ol>
      </xsl:when>
      <xsl:when test="tei:msDesc">
        <xsl:for-each select="*[not(self::tei:head)]">
          <div class="msDesc">
            <xsl:apply-templates/>
          </div>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- tukaj sprememba -->
        <!--<ul class="listBibl">-->
          <xsl:for-each select="*[not(self::tei:head)]">
            <!-- namesto li je p -->
            <p>
              <xsl:call-template name="makeAnchor">
                <xsl:with-param name="name">
                  <xsl:apply-templates mode="ident" select="."/>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:apply-templates select="."/>
            </p>
          </xsl:for-each>
        <!--</ul>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
