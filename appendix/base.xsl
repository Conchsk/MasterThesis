<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common">
  <!-- 请不要轻易格式化此文件 -->
  <!-- ##### Basic ##### -->
  <!-- resource -->
  <xsl:template match="*" mode="resource">
    <link href="http://matdata.shu.edu.cn/XSLTransform/base.css" rel="stylesheet" type="text/css" />
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({ tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]} });
    </script>
    <script src="http://matdata.shu.edu.cn/XSLTransform/MathJax/MathJax.js?config=TeX-MML-AM_CHTML">0==0</script>
    <script>
      function linkHandler(id) {
        let oldUrl = location.href.toString();
        let newUrl = oldUrl.replace(/id=[^&amp;]*/, `id=${id}`);
        location.href = newUrl;
      }
    </script>
  </xsl:template>

  <!-- key -->
  <xsl:template match="*" mode="key-param">
    <xsl:param name="key" />
    <xsl:value-of select="document($lang-file)//*[@key=$key]/@*[name()=$lang]" />
  </xsl:template>

  <xsl:template match="*" mode="key">
    <xsl:apply-templates mode="key-param" select=".">
      <xsl:with-param name="key" select="name(.)" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="key-2">
    <xsl:apply-templates mode="key-param" select=".">
      <xsl:with-param name="key" select="name(..)" />
    </xsl:apply-templates>/
    <xsl:apply-templates mode="key-param" select=".">
      <xsl:with-param name="key" select="name(.)" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- file -->
  <xsl:template match="*" mode="file">
    <xsl:choose>
      <xsl:when test="contains(child::name/text(), 'jpg')
                          or contains(child::name/text(), 'JPG')
                          or contains(child::name/text(), 'png')
                          or contains(child::name/text(), 'PNG')">
        <img style="width: 80%; max-width: 480px;">
          <xsl:attribute name="src">
            <xsl:choose>
              <xsl:when test="$flag=0"><xsl:value-of select="url" /></xsl:when>
              <xsl:when test="$flag=1">/api/computation/file?id=<xsl:value-of select="url" />&amp;name=<xsl:value-of select="name" /></xsl:when>
            </xsl:choose>
          </xsl:attribute>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href">
            <xsl:choose>
              <xsl:when test="$flag=0"><xsl:value-of select="url" /></xsl:when>
              <xsl:when test="$flag=1">/api/computation/file?id=<xsl:value-of select="url" />&amp;name=<xsl:value-of select="name" /></xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="name" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <br />
  </xsl:template>

  <!-- link -->
  <xsl:template match="*" mode="link">
    <a href="javascript:void(0)">
      <xsl:attribute name="onclick">linkHandler("<xsl:value-of select="url" />")</xsl:attribute>
      <xsl:value-of select="description" />
    </a>
  </xsl:template>

  <!-- value -->
  <xsl:template match="*" mode="value">
    <xsl:choose>
      <xsl:when test="child::value and child::unit">
        <xsl:value-of select="child::value" />
        $
        <xsl:choose>
          <xsl:when test="child::unit='%'">\%</xsl:when>
          <xsl:otherwise><xsl:value-of select="child::unit" /></xsl:otherwise>
        </xsl:choose>
        $
      </xsl:when>
      <xsl:when test="child::file">
        <xsl:for-each select="child::file">
          <xsl:apply-templates select="." mode="file" />
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="child::link">
        <xsl:for-each select="child::link">
          <xsl:apply-templates select="." mode="link" />
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="child::*[contains(name(), 'record')]">
        <xsl:for-each select="child::*">
          <xsl:value-of select="." />;
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- table -->
  <xsl:template match="*" mode="table-param">
    <xsl:param name="th" />
    <table>
      <thead>
        <xsl:for-each select="exslt:node-set($th)//th">
          <th>
            <xsl:apply-templates mode="key-param" select=".">
              <xsl:with-param name="key" select="." />
            </xsl:apply-templates>
          </th>
        </xsl:for-each>
      </thead>
      <tbody>
        <xsl:for-each select="child::*">
          <xsl:variable name="record" select="." />
          <tr>
            <xsl:for-each select="exslt:node-set($th)//th">
              <xsl:variable name="name" select="." />
              <td>
                <xsl:apply-templates select="$record/child::*[name()=$name]" mode="value" />
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <!-- common -->
  <xsl:template match="*" mode="common">
    <xsl:param name="level" select="1" />
    <xsl:param name="table" />
    <xsl:for-each select="child::*">
      <xsl:choose>
        <xsl:when test="child::*[contains(name(), 'record')]">
          <xsl:variable name="name" select="name()" />
          <xsl:choose>
            <xsl:when test="count(child::*[1]/child::*) &lt; 4">
              <div class="my-half">
                <div>
                  <xsl:choose>
                    <xsl:when test="$level=1">
                      <xsl:apply-templates select="." mode="key" />
                    </xsl:when>
                    <xsl:when test="$level=2">
                      <xsl:apply-templates select="." mode="key-2" />
                    </xsl:when>
                  </xsl:choose>:
                </div>
                <div>
                  <xsl:apply-templates select="." mode="table-param">
                    <xsl:with-param name="th" select="exslt:node-set($table)//*[name()=$name]" />
                  </xsl:apply-templates>
                </div>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div class="my-full">
                <div>
                  <xsl:choose>
                    <xsl:when test="$level=1">
                      <xsl:apply-templates select="." mode="key" />
                    </xsl:when>
                    <xsl:when test="$level=2">
                      <xsl:apply-templates select="." mode="key-2" />
                    </xsl:when>
                  </xsl:choose>:
                </div>
                <div>
                  <xsl:apply-templates select="." mode="table-param">
                    <xsl:with-param name="th" select="exslt:node-set($table)//*[name()=$name]" />
                  </xsl:apply-templates>
                </div>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="child::* and not(child::value and child::unit) and not(child::file) and not(child::link)">
          <xsl:variable name="name" select="name()" />
          <xsl:if test="$level=1">
            <xsl:apply-templates select="." mode="common">
              <xsl:with-param name="level" select="2" />
              <xsl:with-param name="table" select="exslt:node-set($table)//*[name()=$name]" />
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <div class="my-half">
            <div>
              <xsl:choose>
                <xsl:when test="$level=1">
                  <xsl:apply-templates select="." mode="key" />
                </xsl:when>
                <xsl:when test="$level=2">
                  <xsl:apply-templates select="." mode="key-2" />
                </xsl:when>
              </xsl:choose>:
            </div>
            <div>
              <xsl:apply-templates select="." mode="value" />
            </div>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- ##### Extended ##### -->
  <!-- key -->
  <xsl:template match="*" mode="key-3">
    <xsl:apply-templates mode="key-param" select=".">
      <xsl:with-param name="key" select="name(../..)" />
    </xsl:apply-templates>
    /
    <xsl:apply-templates mode="key-param" select=".">
      <xsl:with-param name="key" select="name(..)" />
    </xsl:apply-templates>
    /
    <xsl:apply-templates mode="key-param" select=".">
      <xsl:with-param name="key" select="name(.)" />
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
