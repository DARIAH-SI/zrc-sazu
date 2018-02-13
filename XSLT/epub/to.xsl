<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:iso="http://www.iso.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
  xmlns:m="http://www.w3.org/1998/Math/MathML" version="2.0" exclude-result-prefixes="#all"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <!-- import https://raw.githubusercontent.com/TEIC/Stylesheets/dev/epub3/tei-to-epub3.xsl -->
  <xsl:import href="../../../publikacije-XSLT/Stylesheets-master/epub3/tei-to-epub3.xsl"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p>This software is dual-licensed: 1. Distributed under a Creative Commons
        Attribution-ShareAlike 3.0 Unported License http://creativecommons.org/licenses/by-sa/3.0/
        2. http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and
        binary forms, with or without modification, are permitted provided that the following
        conditions are met: * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer. * Redistributions in binary form must
        reproduce the above copyright notice, this list of conditions and the following disclaimer
        in the documentation and/or other materials provided with the distribution. This software is
        provided by the copyright holders and contributors "as is" and any express or implied
        warranties, including, but not limited to, the implied warranties of merchantability and
        fitness for a particular purpose are disclaimed. In no event shall the copyright holder or
        contributors be liable for any direct, indirect, incidental, special, exemplary, or
        consequential damages (including, but not limited to, procurement of substitute goods or
        services; loss of use, data, or profits; or business interruption) however caused and on any
        theory of liability, whether in contract, strict liability, or tort (including negligence or
        otherwise) arising in any way out of the use of this software, even if advised of the
        possibility of such damage. </p>
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
  <xsl:param name="numberBackHeadings"/>
  <xsl:param name="numberFrontFigures">false</xsl:param>
  <xsl:param name="numberFrontHeadings"/>
  <xsl:param name="numberFrontTables">false</xsl:param>
  <xsl:param name="numberFigures">false</xsl:param>
  <xsl:param name="numberTables">false</xsl:param>
  <xsl:param name="numberParagraphs">false</xsl:param>
  <xsl:param name="autoToc">false</xsl:param>
  <xsl:param name="footnoteBackLink">true</xsl:param>

  <!-- css datoteke daj v direktorij, ki je relativno na XSLT in ne na XML -->
  <xsl:param name="cssFile">../../../zrc-sazu/zrc-sazu-tei.css</xsl:param>
  <xsl:param name="cssPrintFile">../../../zrc-sazu/zrc-sazu-epub-print.css</xsl:param>

  <xsl:param name="STDOUT">false</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Spremembe v prikazovanju glavne naslovne strani</desc>
  </doc>
  <xsl:template match="tei:p[@rend = 'CIP']">
    <p class="CIP">
      <xsl:value-of select="." disable-output-escaping="yes"/>
    </p>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc/>
  </doc>
  <xsl:template match="tei:publisher[parent::tei:docImprint]">
    <span class="publisher">
      <xsl:apply-templates/>
    </span>
    <br/>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc/>
  </doc>
  <xsl:template match="tei:placeName[parent::tei:docImprint]">
    <span class="placeName">
      <xsl:apply-templates/>
    </span>
    <br/>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc/>
  </doc>
  <xsl:template match="tei:date[parent::tei:docImprint]">
    <span class="date">
      <xsl:apply-templates/>
    </span>
    <br/>
  </xsl:template>

  <!-- če hočemo, da div nimajo naslovov, potem jih moramo skonstrurirati (prazne) naslove,
    saj drugače toc.ncx ne more prikazati teh delov vsebine -->
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings" type="boolean">
    <desc>Whether to construct a heading for &lt;div&gt; elements with no &lt;head&gt; - by default,
      not.</desc>
  </doc>
  <xsl:param name="autoHead">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings">
    <desc>[common] How to make a heading for section if there is no &lt;head&gt;</desc>
    <param name="display"/>
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
    <desc>[epub] Override of top-level template. This does most of the work: performing the normal
      transformation, fixing the links to graphics files so that they are all relative, creating the
      extra output files, etc</desc>
  </doc>
  <xsl:template name="processTEI">
    <xsl:variable name="stage1">
      <xsl:apply-templates mode="preflight"/>
    </xsl:variable>
    <xsl:for-each select="$stage1">
      <xsl:call-template name="processTEIHook"/>
      <xsl:variable name="coverImageOutside">
        <xsl:choose>
          <xsl:when test="/tei:TEI/tei:text/tei:front/tei:titlePage[@facs]">
            <xsl:for-each select="/tei:TEI/tei:text/tei:front/tei:titlePage[@facs][1]">
              <xsl:for-each select="id(substring(@facs, 2))">
                <xsl:choose>
                  <xsl:when test="count(tei:graphic) = 1">
                    <xsl:value-of select="tei:graphic/@url"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="tei:graphic[2]/@url"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="not($coverimage = '')">
            <xsl:value-of select="tokenize($coverimage, '/')[last()]"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="coverImageInside">
        <xsl:choose>
          <xsl:when test="/tei:TEI/tei:text/tei:front/tei:titlePage[@facs]">
            <xsl:for-each select="/tei:TEI/tei:text/tei:front/tei:titlePage[@facs][1]">
              <xsl:for-each select="id(substring(@facs, 2))">
                <xsl:value-of select="tei:graphic[1]/@url"/>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="not($coverimage = '')">
            <xsl:value-of select="tokenize($coverimage, '/')[last()]"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$splitLevel = '-1'">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="split"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="*">
        <xsl:variable name="TOC">
          <TOC xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="mainTOC"/>
          </TOC>
        </xsl:variable>
        <!--
	    <xsl:result-document href="/tmp/TOC">
	    <xsl:copy-of select="$TOC"/>
	    </xsl:result-document>
-->
        <xsl:for-each select="tokenize($javascriptFiles, ',')">
          <xsl:variable name="file" select="normalize-space(.)"/>
          <xsl:variable name="name" select="tokenize($file, '/')[last()]"/>
          <xsl:if test="$verbose = 'true'">
            <xsl:message>write Javascript file <xsl:value-of select="$name"/></xsl:message>
          </xsl:if>
          <xsl:result-document method="text" href="{concat($directory,'/OPS/',$name)}">
            <xsl:for-each select="unparsed-text($file)">
              <xsl:copy-of select="."/>
            </xsl:for-each>
          </xsl:result-document>
        </xsl:for-each>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file OPS/stylesheet.css</xsl:message>
        </xsl:if>

        <xsl:result-document method="text" href="{concat($directory,'/OPS/stylesheet.css')}">
          <xsl:if test="not($cssFile = '')">
            <xsl:if test="$verbose = 'true'">
              <xsl:message>reading file <xsl:value-of select="$cssFile"/></xsl:message>
            </xsl:if>
            <xsl:for-each select="tokenize(unparsed-text($cssFile), '\r?\n')">
              <xsl:call-template name="purgeCSS"/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="not($cssSecondaryFile = '')">
            <xsl:if test="$verbose = 'true'">
              <xsl:message>reading secondary file <xsl:value-of select="$cssSecondaryFile"
                /></xsl:message>
            </xsl:if>
            <xsl:for-each select="tokenize(unparsed-text($cssSecondaryFile), '\r?\n')">
              <xsl:call-template name="purgeCSS"/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$odd = 'true'">
            <xsl:if test="$verbose = 'true'">
              <xsl:message>reading file <xsl:value-of select="$cssODDFile"/></xsl:message>
            </xsl:if>
            <xsl:for-each select="tokenize(unparsed-text($cssODDFile), '\r?\n')">
              <xsl:call-template name="purgeCSS"/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$odd = 'true'">
            <xsl:if test="$verbose = 'true'">
              <xsl:message>reading file <xsl:value-of select="$cssODDFile"/></xsl:message>
            </xsl:if>
            <xsl:for-each select="tokenize(unparsed-text($cssODDFile), '\r?\n')">
              <xsl:call-template name="purgeCSS"/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$filePerPage = 'true'">
            <xsl:text>body { width: </xsl:text>
            <xsl:value-of select="number($viewPortWidth) - 100"/>
            <xsl:text>px;
 height: </xsl:text>
            <xsl:value-of select="$viewPortHeight"/>
            <xsl:text>px;
}
img.fullpage {
position: absolute;
height: </xsl:text>
            <xsl:value-of select="$viewPortHeight"/>
            <xsl:text>px; left:0px; top:0px;}
</xsl:text>
          </xsl:if>
        </xsl:result-document>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file OPS/print.css</xsl:message>
        </xsl:if>
        <xsl:result-document method="text" href="{concat($directory,'/OPS/print.css')}">
          <xsl:if test="$verbose = 'true'">
            <xsl:message>reading file <xsl:value-of select="$cssPrintFile"/></xsl:message>
          </xsl:if>
          <xsl:for-each select="tokenize(unparsed-text($cssPrintFile), '\r?\n')">
            <xsl:call-template name="purgeCSS"/>
          </xsl:for-each>
        </xsl:result-document>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file mimetype</xsl:message>
        </xsl:if>
        <xsl:result-document method="text" href="{concat($directory,'/mimetype')}">
          <xsl:value-of select="$epubMimetype"/>
        </xsl:result-document>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file META-INF/container.xml</xsl:message>
        </xsl:if>
        <xsl:result-document doctype-public="" doctype-system="" method="xml"
          href="{concat($directory,'/META-INF/container.xml')}">
          <container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
            <rootfiles>
              <rootfile full-path="OPS/package.opf" media-type="application/oebps-package+xml"/>
            </rootfiles>
          </container>
        </xsl:result-document>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file OPS/package.opf</xsl:message>
        </xsl:if>
        <xsl:variable name="A">
          <xsl:sequence select="tei:generateAuthor(.)"/>
        </xsl:variable>
        <xsl:variable name="printA">
          <xsl:analyze-string select="$A" regex="([^,]+), ([^,]+), (.+)">
            <xsl:matching-substring>
              <xsl:value-of select="regex-group(1)"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:value-of select="."/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:variable>
        <xsl:result-document href="{concat($directory,'/OPS/package.opf')}" method="xml"
          indent="yes">
          <package xmlns="http://www.idpf.org/2007/opf" unique-identifier="pub-id"
            version="{$opfPackageVersion}">
            <xsl:call-template name="opfmetadata">
              <xsl:with-param name="author" select="$A"/>
              <xsl:with-param name="printAuthor" select="$printA"/>
              <xsl:with-param name="coverImageOutside" select="$coverImageOutside"/>
            </xsl:call-template>
            <manifest>
              <!-- deal with intricacies of overlay files -->
              <xsl:variable name="TL" select="key('Timeline', 1)"/>
              <xsl:if test="$mediaoverlay = 'true' and key('Timeline', 1)">
                <xsl:if test="$verbose = 'true'">
                  <xsl:message>write file SMIL files</xsl:message>
                </xsl:if>
                <xsl:for-each select="key('Timeline', 1)">
                  <xsl:variable name="TLnumber">
                    <xsl:number level="any"/>
                  </xsl:variable>
                  <xsl:variable name="audio">
                    <xsl:text>media/audio</xsl:text>
                    <xsl:number level="any"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="tokenize(@corresp, '\.')[last()]"/>
                  </xsl:variable>
                  <item id="timeline-audio{$TLnumber}" href="{$audio}">
                    <xsl:attribute name="media-type">
                      <xsl:choose>
                        <xsl:when test="contains($audio, '.m4a')">audio/m4a</xsl:when>
                        <xsl:otherwise>audio/m4a</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </item>
                  <xsl:for-each select="key('PB', 1)">
                    <xsl:variable name="page">
                      <xsl:value-of select="generate-id()"/>
                    </xsl:variable>
                    <xsl:variable name="target">
                      <xsl:apply-templates select="." mode="ident"/>
                    </xsl:variable>
                    <xsl:if test="count(key('objectOnPage', $page)) &gt; 0">
                      <item id="{$target}-audio" href="{$target}-overlay.smil"
                        media-type="application/smil+xml"/>
                      <xsl:result-document
                        href="{concat($directory,'/OPS/',$target,'-overlay.smil')}" method="xml">
                        <smil xmlns="http://www.w3.org/ns/SMIL" version="3.0"
                          profile="http://www.ipdf.org/epub/30/profile/content/">
                          <body>
                            <xsl:for-each select="key('objectOnPage', $page)">
                              <xsl:variable name="object" select="@xml:id"/>
                              <xsl:for-each select="$TL">
                                <xsl:for-each select="key('Object', $object)">
                                  <par id="{@xml:id}">
                                    <text src="{$target}.html{@corresp}"/>
                                    <audio src="{$audio}" clipBegin="{@from}{../@unit}"
                                      clipEnd="{@to}{../@unit}"/>
                                  </par>
                                </xsl:for-each>
                              </xsl:for-each>
                            </xsl:for-each>
                          </body>
                        </smil>
                      </xsl:result-document>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="not($coverImageOutside = '')">
                <item href="{$coverImageOutside}" id="cover-image" properties="cover-image"
                  media-type="image/jpeg"/>
              </xsl:if>
              <xsl:for-each select="tokenize($javascriptFiles, ',')">
                <xsl:variable name="name" select="tokenize(normalize-space(.), '/')[last()]"/>
                <item href="{$name}" id="javascript{position()}" media-type="text/javascript"/>
              </xsl:for-each>
              <item id="css" href="stylesheet.css" media-type="text/css"/>
              <item id="print.css" href="print.css" media-type="text/css"/>
              <item href="titlepage.html" id="titlepage" media-type="application/xhtml+xml"/>
              <xsl:if test="$filePerPage = 'true'">
                <item href="titlepageverso.html" id="titlepageverso"
                  media-type="application/xhtml+xml"/>
              </xsl:if>
              <xsl:for-each select="tei:text/tei:front/tei:titlePage">
                <xsl:variable name="N" select="position()"/>
                <item href="titlepage{$N}.html" id="titlepage{$N}"
                  media-type="application/xhtml+xml"/>
              </xsl:for-each>
              <item href="titlepageback.html" id="titlepageback" media-type="application/xhtml+xml"/>
              <item id="toc" properties="nav" href="toc.html" media-type="application/xhtml+xml"/>
              <item id="start" href="index.html" media-type="application/xhtml+xml">
                <xsl:call-template name="epub-start-properties"/>
              </item>
              <xsl:choose>
                <xsl:when test="$filePerPage = 'true'">
                  <xsl:for-each select="key('PB', 1)">
                    <xsl:variable name="target">
                      <xsl:apply-templates select="." mode="ident"/>
                    </xsl:variable>
                    <xsl:if test="@facs">
                      <xsl:variable name="facstarget">
                        <xsl:apply-templates select="." mode="ident"/>
                        <xsl:text>-facs.html</xsl:text>
                      </xsl:variable>
                      <item href="{$facstarget}" media-type="application/xhtml+xml">
                        <xsl:attribute name="id">
                          <xsl:text>pagefacs</xsl:text>
                          <xsl:number level="any"/>
                        </xsl:attribute>
                      </item>
                    </xsl:if>
                    <item href="{$target}.html" media-type="application/xhtml+xml">
                      <xsl:if test="$mediaoverlay = 'true' and key('Timeline', 1)">
                        <xsl:attribute name="media-overlay">
                          <xsl:value-of select="$target"/>
                          <xsl:text>-audio</xsl:text>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:attribute name="id">
                        <xsl:text>page</xsl:text>
                        <xsl:number level="any"/>
                      </xsl:attribute>
                    </item>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$TOC/html:TOC/html:ul/html:li">
                    <xsl:choose>
                      <xsl:when test="not(html:a)"/>
                      <xsl:when test="starts-with(html:a/@href, '#')"/>
                      <xsl:otherwise>
                        <item href="{html:a[1]/@href}" media-type="application/xhtml+xml">
                          <xsl:if test="contains(@class, 'contains-mathml')">
                            <xsl:attribute name="properties">mathml</xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="id">
                            <xsl:text>section</xsl:text>
                            <xsl:number count="html:li" level="any"/>
                          </xsl:attribute>
                        </item>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="html:ul">
                      <xsl:for-each
                        select="html:ul//html:li[html:a and not(contains(html:a/@href, '#'))]">
                        <item href="{html:a[1]/@href}" media-type="application/xhtml+xml">
                          <xsl:attribute name="id">
                            <xsl:text>section</xsl:text>
                            <xsl:number count="html:li" level="any"/>
                          </xsl:attribute>
                        </item>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
              <!-- images -->
              <xsl:for-each select="key('GRAPHICS', 1)">
                <xsl:variable name="img" select="@url | @facs"/>
                <xsl:if test="not($img = $coverImageOutside)">
                  <xsl:variable name="ID">
                    <xsl:number level="any"/>
                  </xsl:variable>
                  <item href="{$img}" id="image-{$ID}"
                    media-type="{tei:generateMimeType($img,@mimeType)}"/>
                </xsl:if>
              </xsl:for-each>
              <!-- page images -->
              <xsl:for-each select="key('PBGRAPHICS', 1)">
                <xsl:choose>
                  <xsl:when test="tei:match(@rend, 'none')"/>
                  <xsl:otherwise>
                    <xsl:variable name="img" select="@facs"/>
                    <xsl:variable name="ID">
                      <xsl:number level="any"/>
                    </xsl:variable>
                    <item href="{$img}" id="pbimage-{$ID}"
                      media-type="{tei:generateMimeType($img,@mimeType)}"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:for-each select="tokenize($extraGraphicsFiles, ',')">
                <item href="{.}" id="graphic-{.}" media-type="{tei:generateMimeType(.,'')}"/>
              </xsl:for-each>
              <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
              <xsl:call-template name="epubManifestHook"/>
            </manifest>
            <spine toc="ncx">
              <itemref idref="titlepage" linear="yes"/>
              <xsl:if test="$filePerPage = 'true'">
                <itemref idref="titlepageverso" linear="yes"/>
              </xsl:if>
              <xsl:for-each select="tei:text/tei:front/tei:titlePage">
                <xsl:variable name="N" select="position()"/>
                <itemref idref="titlepage{$N}" linear="yes"/>
              </xsl:for-each>
              <itemref idref="start" linear="yes"/>
              <xsl:choose>
                <xsl:when test="$filePerPage = 'true'">
                  <xsl:for-each select="key('PB', 1)">
                    <xsl:if test="@facs">
                      <itemref>
                        <xsl:attribute name="idref">
                          <xsl:text>pagefacs</xsl:text>
                          <xsl:number level="any"/>
                        </xsl:attribute>
                        <xsl:attribute name="linear">yes</xsl:attribute>
                      </itemref>
                    </xsl:if>
                    <itemref>
                      <xsl:attribute name="idref">
                        <xsl:text>page</xsl:text>
                        <xsl:number level="any"/>
                      </xsl:attribute>
                      <xsl:attribute name="linear">yes</xsl:attribute>
                    </itemref>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$TOC/html:TOC/html:ul/html:li">
                    <xsl:choose>
                      <xsl:when test="not(html:a)"/>
                      <xsl:when test="starts-with(html:a/@href, '#')"/>
                      <xsl:otherwise>
                        <itemref>
                          <xsl:attribute name="idref">
                            <xsl:text>section</xsl:text>
                            <xsl:number count="html:li" level="any"/>
                          </xsl:attribute>
                          <xsl:attribute name="linear">yes</xsl:attribute>
                        </itemref>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="html:ul">
                      <xsl:for-each
                        select="html:ul//html:li[html:a and not(contains(html:a/@href, '#'))]">
                        <itemref>
                          <xsl:attribute name="idref">
                            <xsl:text>section</xsl:text>
                            <xsl:number count="html:li" level="any"/>
                          </xsl:attribute>
                          <xsl:attribute name="linear">yes</xsl:attribute>
                        </itemref>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
              <itemref idref="titlepageback">
                <!-- titlepageback vedno prikaže -->
                <xsl:attribute name="linear">yes</xsl:attribute>
                <!--<xsl:attribute name="linear">
                  <xsl:choose>
                    <xsl:when test="$filePerPage = 'true'">yes</xsl:when>
                    <xsl:otherwise>no</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>-->
              </itemref>
              <xsl:call-template name="epubSpineHook"/>
            </spine>
            <guide>
              <reference type="text" href="titlepage.html" title="Cover"/>
              <reference type="text" title="Start" href="index.html"/>
              <xsl:choose>
                <xsl:when test="$filePerPage = 'true'"> </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$TOC/html:TOC/html:ul/html:li">
                    <xsl:if test="html:a and not(starts-with(html:a[1]/@href, '#'))">
                      <reference type="text" href="{html:a[1]/@href}">
                        <xsl:attribute name="title">
                          <xsl:value-of select="normalize-space(html:a[1])"/>
                        </xsl:attribute>
                      </reference>
                    </xsl:if>
                    <xsl:if test="contains(parent::html:ul/@class, 'group')">
                      <xsl:for-each select="html:ul//html:li">
                        <xsl:choose>
                          <xsl:when test="not(html:a)"/>
                          <xsl:when test="contains(html:a/@href, '#')"/>
                          <xsl:otherwise>
                            <reference type="text" href="{html:a/@href}">
                              <xsl:attribute name="title">
                                <xsl:value-of select="normalize-space(html:a[1])"/>
                              </xsl:attribute>
                            </reference>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
              <reference href="titlepageback.html" type="text" title="About this book"/>
            </guide>
          </package>
        </xsl:result-document>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file OPS/titlepage.html</xsl:message>
        </xsl:if>
        <xsl:result-document href="{concat($directory,'/OPS/titlepage.html')}" method="xml">
          <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
            <head>
              <xsl:call-template name="metaHTML">
                <xsl:with-param name="title">Title page</xsl:with-param>
              </xsl:call-template>
              <title>Title page</title>
              <style type="text/css" title="override_css">
                @page {
                    padding: 0pt;
                    margin: 0pt
                }
                body {
                    text-align: center;
                    padding: 0pt;
                    margin: 0pt;
                }</style>
            </head>
            <body>
              <xsl:choose>
                <xsl:when test="$coverImageInside = ''">
                  <div class="EpubCoverPage">
                    <xsl:sequence select="tei:generateTitle(.)"/>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <div>
                    <img width="{$viewPortWidth}" height="{$viewPortHeight}" alt="cover picture"
                      src="{$coverImageInside}"/>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </body>
          </html>
        </xsl:result-document>
        <xsl:for-each select="tei:text/tei:front/tei:titlePage">
          <xsl:variable name="N" select="position()"/>
          <xsl:if test="$verbose = 'true'">
            <xsl:message>write file OPS/titlepage<xsl:value-of select="$N"/>.html</xsl:message>
          </xsl:if>
          <xsl:result-document href="{concat($directory,'/OPS/titlepage',$N,'.html')}" method="xml">
            <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
              <head>
                <xsl:call-template name="metaHTML">
                  <xsl:with-param name="title">Title page</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="linkCSS">
                  <xsl:with-param name="file">stylesheet.css</xsl:with-param>
                </xsl:call-template>
                <title>Title page</title>
              </head>
              <body>
                <div class="titlePage">
                  <xsl:apply-templates/>
                </div>
              </body>
            </html>
          </xsl:result-document>
        </xsl:for-each>
        <xsl:if test="$filePerPage = 'true'">
          <xsl:if test="$verbose = 'true'">
            <xsl:message>write file OPS/titlepageverso.html</xsl:message>
          </xsl:if>
          <xsl:result-document href="{concat($directory,'/OPS/titlepageverso.html')}" method="xml">
            <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
              <head>
                <xsl:call-template name="metaHTML">
                  <xsl:with-param name="title">title page verso</xsl:with-param>
                </xsl:call-template>
                <title>title page verso</title>
              </head>
              <body>
                <p/>
              </body>
            </html>
          </xsl:result-document>
        </xsl:if>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file OPS/titlepageback.html</xsl:message>
        </xsl:if>
        <xsl:result-document href="{concat($directory,'/OPS/titlepageback.html')}" method="xml">
          <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
            <head>
              <xsl:call-template name="metaHTML">
                <xsl:with-param name="title">About this book</xsl:with-param>
              </xsl:call-template>
              <title>About this book</title>
            </head>
            <body>
              <div style="text-align: left; font-size: larger">
                <h2>Information about this book</h2>
                <xsl:for-each select="/*/tei:teiHeader/tei:fileDesc">
                  <xsl:apply-templates mode="metadata"/>
                </xsl:for-each>
                <xsl:for-each select="/*/tei:teiHeader/tei:encodingDesc">
                  <xsl:apply-templates mode="metadata"/>
                </xsl:for-each>
              </div>
            </body>
          </html>
        </xsl:result-document>
        <xsl:if test="$verbose = 'true'">
          <xsl:message>write file OPS/toc.ncx</xsl:message>
        </xsl:if>
        <xsl:result-document href="{concat($directory,'/OPS/toc.ncx')}" method="xml">
          <ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
            <head>
              <meta name="dtb:uid">
                <xsl:attribute name="content">
                  <xsl:call-template name="generateID"/>
                </xsl:attribute>
              </meta>
              <meta name="dtb:totalPageCount" content="0"/>
              <meta name="dtb:maxPageNumber" content="0"/>
            </head>
            <docTitle>
              <text>
                <xsl:sequence select="tei:generateSimpleTitle(.)"/>
              </text>
            </docTitle>
            <navMap>
              <xsl:variable name="navPoints">
                <navPoint>
                  <navLabel>
                    <text>[Cover]</text>
                  </navLabel>
                  <content src="titlepage.html"/>
                </navPoint>
                <xsl:for-each select="tei:text/tei:front/tei:titlePage[1]">
                  <xsl:variable name="N" select="position()"/>
                  <navPoint>
                    <navLabel>
                      <text>[Title page]</text>
                    </navLabel>
                    <content src="titlepage{$N}.html"/>
                  </navPoint>
                </xsl:for-each>
                <xsl:choose>
                  <xsl:when test="not($TOC/html:TOC/html:ul[@class = 'toc toc_body']/html:li)">
                    <xsl:for-each select="$TOC/html:TOC/html:ul[@class = 'toc toc_front']">
                      <xsl:apply-templates select="html:li"/>
                    </xsl:for-each>
                    <navPoint>
                      <navLabel>
                        <text>[The book]</text>
                      </navLabel>
                      <content src="index.html"/>
                    </navPoint>
                    <xsl:for-each select="$TOC/html:TOC/html:ul[contains(@class, 'group')]">
                      <xsl:apply-templates select=".//html:li[not(contains(html:a/@href, '#'))]"/>
                    </xsl:for-each>
                    <xsl:for-each select="$TOC/html:TOC/html:ul[@class = 'toc toc_back']">
                      <xsl:apply-templates select="html:li"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="$TOC/html:TOC/html:ul">
                      <xsl:apply-templates select="html:li"/>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
                <navPoint>
                  <navLabel>
                    <text>[About this book]</text>
                  </navLabel>
                  <content src="titlepageback.html"/>
                </navPoint>
              </xsl:variable>
              <xsl:for-each select="$navPoints/ncx:navPoint">
                <xsl:variable name="pos" select="position()"/>
                <navPoint id="navPoint-{$pos}" playOrder="{$pos}">
                  <xsl:copy-of select="*"/>
                </navPoint>
              </xsl:for-each>
            </navMap>
          </ncx>
        </xsl:result-document>
        <xsl:if test="$filePerPage = 'true'">
          <xsl:if test="$verbose = 'true'">
            <xsl:message>write file META-INF/com.apple.ibooks.display-options.xml</xsl:message>
          </xsl:if>
          <xsl:result-document
            href="{concat($directory,'/META-INF/com.apple.ibooks.display-options.xml')}">
            <display_options xmlns="">
              <platform name="*">
                <option name="fixed-layout">true</option>
              </platform>
            </display_options>
          </xsl:result-document>
        </xsl:if>
        <xsl:if test="$debug = 'true'">
          <xsl:message>write file OPS/toc.html</xsl:message>
        </xsl:if>
        <xsl:result-document href="{concat($directory,'/OPS/toc.html')}" method="xml"
          doctype-system="">
          <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
            <head>
              <title>
                <xsl:sequence select="tei:generateSimpleTitle(.)"/>
              </title>
              <xsl:call-template name="linkCSS">
                <xsl:with-param name="file">stylesheet.css</xsl:with-param>
              </xsl:call-template>
            </head>
            <body>
              <section class="TableOfContents">
                <header>
                  <h1>Contents</h1>
                </header>
                <nav xmlns:epub="http://www.idpf.org/2007/ops" epub:type="toc" id="toc">
                  <ol>
                    <!-- dodam:
                           - gre še dve dodatni stopnji v globino
                           - če je samo poglavje brez head (oziroma enim znakom), ki nima podpoglavij s head, potem ne prikažem
                    -->
                    <xsl:for-each select="$TOC/html:TOC/html:ul/html:li">
                      <xsl:choose>
                        <xsl:when test="not(html:a)"/>
                        <xsl:when test="starts-with(html:a/@href, '#')"/>
                        <xsl:when test="contains(@class, 'headless')"/>
                        <!-- dodal spodnji when -->
                        <xsl:when test="string-length(html:a) = 1 and (not(html:ul/html:li) or string-length(html:ul/html:li/html:a) = 1)"/>
                        <xsl:otherwise>
                          <li>
                            <a href="{html:a/@href}">
                              <xsl:value-of select="html:span[@class = 'headingNumber']"/>
                              <xsl:value-of select="normalize-space(html:a[1])"/>
                            </a>
                            <!-- dodam nadaljno procesiranje (še dve stopnji) -->
                            <xsl:for-each select="html:ul">
                              <ol>
                                <xsl:for-each select="html:li">
                                  <li>
                                    <a href="{html:a/@href}">
                                      <xsl:value-of select="html:span[@class = 'headingNumber']"/>
                                      <xsl:value-of select="normalize-space(html:a[1])"/>
                                    </a>
                                    <xsl:for-each select="html:ul">
                                      <ol>
                                        <xsl:for-each select="html:li">
                                          <li>
                                            <a href="{html:a/@href}">
                                              <xsl:value-of select="html:span[@class = 'headingNumber']"/>
                                              <xsl:value-of select="normalize-space(html:a[1])"/>
                                            </a>
                                          </li>
                                        </xsl:for-each>
                                      </ol>
                                    </xsl:for-each>
                                  </li>
                                </xsl:for-each>
                              </ol>
                            </xsl:for-each>
                          </li>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                    <li>
                      <a href="titlepageback.html">[About this book]</a>
                    </li>
                  </ol>
                </nav>
                <nav xmlns:epub="http://www.idpf.org/2007/ops" epub:type="landmarks" id="guide">
                  <h2>Guide</h2>
                  <ol>
                    <li>
                      <a epub:type="titlepage" href="titlepage.html">[Title page]</a>
                    </li>
                    <li>
                      <a epub:type="bodymatter" href="index.html">[The book]</a>
                    </li>
                    <li>
                      <a epub:type="colophon" href="titlepageback.html">[About this book]</a>
                    </li>
                  </ol>
                </nav>
              </section>
            </body>
          </html>
        </xsl:result-document>

      </xsl:for-each>
    </xsl:for-each>
    <xsl:call-template name="getgraphics"/>

  </xsl:template>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>V pagebrake odstranim oblikovanje: dodano besedilo [page ]</desc>
  </doc>
  <xsl:template match="tei:pb | tei:gb">
    <xsl:choose>
      <xsl:when test="$filePerPage = 'true'">
        <PAGEBREAK>
          <xsl:attribute name="name">
            <xsl:apply-templates select="." mode="ident"/>
          </xsl:attribute>
          <xsl:copy-of select="@facs"/>
        </PAGEBREAK>
      </xsl:when>
      <xsl:when test="$pagebreakStyle = 'active'">
        <div>
          <xsl:call-template name="makeRendition">
            <xsl:with-param name="default" select="'pagebreak'"/>
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:when test="$pagebreakStyle = 'none'"/>
      <xsl:otherwise>
        <xsl:element
          name="{if (parent::tei:body or parent::tei:front
          or parent::tei:div  or parent::tei:back or
          parent::tei:lg or parent::tei:group) then 'div' else 'span'}">
          <xsl:call-template name="makeRendition">
            <xsl:with-param name="default" select="'pagebreak'"/>
          </xsl:call-template>
          <xsl:call-template name="makeAnchor"/>
          <xsl:variable name="Words">
            <xsl:text> [</xsl:text>
            <!-- odstranim -->
            <!--<xsl:sequence select="if (self::tei:gb) then tei:i18n('gathering') else tei:i18n('page')"/>-->
            <xsl:if test="@n">
              <!--<xsl:text> </xsl:text>-->
              <xsl:value-of select="@n"/>
            </xsl:if>
            <xsl:text>] </xsl:text>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$pagebreakStyle = 'simple'">
              <xsl:copy-of select="$Words"/>
            </xsl:when>
            <xsl:when test="rend = 'none'"/>
            <xsl:when test="$pagebreakStyle = 'display' and @facs">
              <div class="facsimage">
                <img src="{@facs}"/>
              </div>
            </xsl:when>
            <xsl:when test="starts-with(@facs, 'unknown:')">
              <xsl:copy-of select="$Words"/>
            </xsl:when>
            <xsl:when test="@facs">
              <xsl:variable name="IMG">
                <xsl:choose>
                  <xsl:when test="starts-with(@facs, '#')">
                    <xsl:for-each select="id(substring(@facs, 2))">
                      <xsl:value-of select="tei:graphic[1]/tei:resolveURI(., @url)"/>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="tei:resolveURI(., @facs)"/>
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
    <desc>[html] produce all the notes: Odstranim $noteHeading, preko katerega se za sezname opomb
      napiše naslov Notes oz. Opombe, če je dokumentacija v Slovenščini </desc>
  </doc>
  <xsl:template name="printNotes">
    <xsl:if
      test="
        key('FOOTNOTES', 1) or
        key('ENDNOTES', 1) or
        ($autoEndNotes = 'true' and key('ALLNOTES', 1))
        or (self::tei:floatingText and .//tei:note)">
      <xsl:choose>
        <xsl:when test="$footnoteFile = 'true'">
          <xsl:variable name="BaseFile">
            <xsl:value-of select="$masterFile"/>
            <xsl:call-template name="addCorpusID"/>
          </xsl:variable>
          <xsl:variable name="outName">
            <xsl:call-template name="outputChunkName">
              <xsl:with-param name="ident">
                <xsl:value-of select="concat($BaseFile, '-notes')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$verbose = 'true'">
            <xsl:message>Opening file <xsl:value-of select="$outName"/>
            </xsl:message>
          </xsl:if>
          <xsl:result-document doctype-public="{$doctypePublic}" doctype-system="{$doctypeSystem}"
            encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}">
            <html>
              <xsl:call-template name="addLangAtt"/>
              <xsl:variable name="pagetitle">
                <xsl:sequence select="tei:generateTitle(.)"/>
                <!--<xsl:text>: </xsl:text>
                <xsl:sequence select="tei:i18n('noteHeading')"/>-->
              </xsl:variable>
              <xsl:sequence select="tei:htmlHead($pagetitle, 1)"/>
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
                    <xsl:when test="$autoEndNotes = 'true'">
                      <!--<div class="noteHeading">
                        <xsl:sequence select="tei:i18n('noteHeading')"/>
                      </div>-->
                      <xsl:apply-templates mode="printnotes" select="key('ALLNOTES', 1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="key('FOOTNOTES', 1)">
                        <!--<div class="noteHeading footnotes">
                          <xsl:sequence select="tei:i18n('noteHeading')"/>
                        </div>-->
                        <xsl:apply-templates mode="printnotes" select="key('FOOTNOTES', 1)"/>
                      </xsl:if>
                      <xsl:if test="key('ENDNOTES', 1)">
                        <!--<div class="noteHeading endnotes">
                          <xsl:sequence select="tei:i18n('noteHeading')"/>
                        </div>-->
                        <xsl:apply-templates mode="printnotes" select="key('ENDNOTES', 1)"/>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <xsl:call-template name="stdfooter"/>
                <xsl:call-template name="bodyEndHook"/>
              </body>
            </html>
          </xsl:result-document>
          <xsl:if test="$verbose = 'true'">
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
                <xsl:for-each
                  select="
                    .//tei:note[tei:isEndNote(.) or
                    tei:isFootNote(.)]">
                  <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:floatingText) = 1">
                      <xsl:call-template name="makeaNote"/>
                    </xsl:when>
                    <xsl:when test="generate-id(ancestor-or-self::tei:floatingText[1]) = $outer">
                      <xsl:call-template name="makeaNote"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="self::tei:TEI">
                <xsl:choose>
                  <xsl:when test="$autoEndNotes = 'true'">
                    <!--<div class="noteHeading">
                      <xsl:sequence select="tei:i18n('noteHeading')"/>
                    </div>-->
                    <xsl:apply-templates mode="printallnotes" select="key('ALLNOTES', 1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="key('FOOTNOTES', 1)">
                      <!--<div class="noteHeading">
                        <xsl:sequence select="tei:i18n('noteHeading')"/>
                      </div>-->
                      <xsl:apply-templates mode="printallnotes" select="key('FOOTNOTES', 1)"/>
                    </xsl:if>
                    <xsl:if test="key('ENDNOTES', 1)">
                      <!--<div class="noteHeading">
                        <xsl:sequence select="tei:i18n('noteHeading')"/>
                      </div>-->
                      <xsl:apply-templates mode="printallnotes" select="key('ENDNOTES', 1)"/>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="self::tei:text and $splitLevel = 0">
                <!--<div class="noteHeading">
                  <xsl:sequence select="tei:i18n('noteHeading')"/>
                </div>-->
                <xsl:for-each select="tei:front | tei:body | tei:back">
                  <xsl:for-each
                    select="
                      .//tei:note[tei:isEndNote(.) or
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
              <xsl:when test="parent::tei:group and tei:group"> </xsl:when>
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
            <xsl:if test="html:div[@class = 'note']">
              <xsl:comment>Notes in [<xsl:value-of select="$where"/>]</xsl:comment>
              <div class="notes">
                <xsl:copy-of select="* | comment()"/>
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
    <desc>Process display-style note: Odstranil sem notelbel</desc>
  </doc>
  <xsl:template name="displayNote">
    <xsl:variable name="identifier">
      <xsl:call-template name="noteID"/>
    </xsl:variable>
    <xsl:element name="{if (tei:isInline(.)) then 'span' else 'div'}">
      <xsl:attribute name="class">note</xsl:attribute>
      <xsl:call-template name="makeRendition">
        <xsl:with-param name="auto">note</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="makeAnchor">
        <xsl:with-param name="name" select="$identifier"/>
      </xsl:call-template>
      <!--<span class="noteLabel">
        <xsl:choose>
          <xsl:when test="@n">
            <xsl:value-of select="@n"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="tei:i18n('Note')"/>
            <xsl:text>: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </span>-->
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process plain note without any @place attribute</desc>
  </doc>
  <xsl:template name="plainNote">
    <xsl:variable name="identifier">
      <xsl:call-template name="noteID"/>
    </xsl:variable>
    <span>
      <xsl:call-template name="makeRendition">
        <xsl:with-param name="auto">note</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="makeAnchor">
        <xsl:with-param name="name" select="$identifier"/>
      </xsl:call-template>
      <!--<span class="noteLabel">
        <xsl:choose>
          <xsl:when test="@n">
            <xsl:value-of select="@n"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="tei:i18n('Note')"/>
            <xsl:text>: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </span>-->
      <xsl:apply-templates/>
    </span>
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
