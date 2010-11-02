<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:llrp="http://www.llrp.org/ltk/schema/core/encoding/binary/1.0"
  xmlns:h="http://www.w3.org/1999/xhtml">
  <xsl:output omit-xml-declaration='yes' method='text' indent='no'/>
  
  <xsl:template match="/llrp:llrpdef">
    /*
    ***************************************************************************
    *  Copyright 2007 Impinj, Inc.
    *
    *  Licensed under the Apache License, Version 2.0 (the "License");
    *  you may not use this file except in compliance with the License.
    *  You may obtain a copy of the License at
    *
    *      http://www.apache.org/licenses/LICENSE-2.0
    *
    *  Unless required by applicable law or agreed to in writing, software
    *  distributed under the License is distributed on an "AS IS" BASIS,
    *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    *  See the License for the specific language governing permissions and
    *  limitations under the License.
    *
    ***************************************************************************
    */


    /*
    ***************************************************************************
    *
    *  This code is generated by Impinj LLRP .Net generator. Modification is
    *  not recommended.
    *
    ***************************************************************************
    */

    /*
    ***************************************************************************
    * File Name:       LLRPParam.cs
    *
    * Version:         1.0
    * Author:          Impinj
    * Organization:    Impinj
    * Date:            Jan. 18, 2008
    *
    * Description:     This file contains LLRP parameter definitions
    ***************************************************************************
    */

    using System;
    using System.IO;
    using System.Text;
    using System.Collections;
    using System.ComponentModel;
    using System.Xml;
    using System.Xml.Serialization;
    using System.Xml.Schema;
    using System.Runtime.InteropServices;

    using LLRP.DataType;

    namespace LLRP
    {
    #region Custom Parameter Interface
    <xsl:for-each select ="llrp:parameterDefinition">
      <xsl:variable name="custom_param_name">
        <xsl:value-of select="@name"/>
      </xsl:variable>
      <xsl:for-each select="llrp:parameter">
        <xsl:if test="@type='Custom'">
    public interface I<xsl:copy-of select="$custom_param_name"/>_Custom_Param : ICustom_Parameter {}
      </xsl:if>
      </xsl:for-each>     
    </xsl:for-each>
    #endregion

    <!--This portion defines the choice parameters in the LLRP xml file-->
    <xsl:for-each select="llrp:choiceDefinition">
      ///<xsl:text disable-output-escaping="yes">&lt;</xsl:text>summary<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
      ///Allowed types: <xsl:for-each select="parameter">PARAM_<xsl:value-of select="@type"/>,</xsl:for-each>
      ///<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/summary<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
      public class UNION_<xsl:value-of select="@name"/> : ParamArrayList{}
    </xsl:for-each>
    <xsl:for-each select="llrp:parameterDefinition">
      <xsl:if test="@name!='Custom'">
      <xsl:variable name="parameter_name">
        <xsl:value-of select="@name"/>
      </xsl:variable>
        /// <xsl:text disable-output-escaping="yes">&lt;summary</xsl:text><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        /// <xsl:for-each select ="llrp:annotation/llrp:description/h:p"><xsl:value-of select="."/></xsl:for-each>
        /// <xsl:text disable-output-escaping="yes">&lt;/summary</xsl:text><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
      public class PARAM_<xsl:value-of select="@name"/> : Parameter
      {
      public PARAM_<xsl:value-of select="@name"/>()
      {
      typeID = <xsl:value-of select="@typeNum"/>;
      <xsl:if test="@typeNum &lt; 100">tvCoding = true;</xsl:if>
      }

      <xsl:for-each select="*">
        <xsl:if test="name()='field'">
          public <xsl:call-template name='DefineDataType'/><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:call-template name='DefineDefaultValue'/>
          <xsl:call-template name="DefineDataLength"/>
        </xsl:if>
        <xsl:if test="name()='reserved'">
          private const UInt16 param_reserved_len = <xsl:value-of select="@bitCount"/>;
        </xsl:if>
        <xsl:if test="name()='parameter'">
          <xsl:choose>
            <xsl:when test="@type='Custom'">
          <xsl:choose>
          <xsl:when test="contains(@repeat, '0-N') or contains(@repeat, '1-N')">
          public readonly CustomParameterArrayList <xsl:call-template name='DefineParameterName'/> = new CustomParameterArrayList();
          public void AddCustomParameter(I<xsl:copy-of select='$parameter_name'/>_Custom_Param param)
          {          
          <xsl:call-template name='DefineParameterName'/>.Add(param);
          }
          private void AddCustomParameter(ICustom_Parameter param)
          {
          <xsl:call-template name='DefineParameterName'/>.Add(param);
          }
          
          </xsl:when>
          <xsl:otherwise>
          public readonly I<xsl:copy-of select='$parameter_name'/>_Custom_Param <xsl:call-template name='DefineParameterName'/>;
          </xsl:otherwise>
          </xsl:choose>
            </xsl:when>
            <xsl:otherwise>  
              <xsl:choose>
              <xsl:when test="contains(@repeat, '0-N') or contains(@repeat, '1-N')">
              public PARAM_<xsl:value-of select="@type"/>[] <xsl:call-template name='DefineParameterName'/>;
            </xsl:when>
            <xsl:otherwise>
              public PARAM_<xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:call-template name='DefineParameterName'/>;   
            </xsl:otherwise>            
          </xsl:choose>            
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="name()='choice'">
          <xsl:variable name="choiceParameterName">
            <xsl:call-template name='DefineParameterName'/>
          </xsl:variable>
          public UNION_<xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:call-template name='DefineParameterName'/> = new UNION_<xsl:value-of select="@type"/>();
        </xsl:if>
      </xsl:for-each>

      <xsl:call-template name="EncodeToBitArray"/>
      <xsl:call-template name="DecodeFromBitArray"/>
      <xsl:call-template name="ToString"/>
      <xsl:call-template name="FromXmlNode"/>
      }
      </xsl:if>
    </xsl:for-each>
    }
  </xsl:template>

  <xsl:include href="templates.xslt"/>
  <xsl:template name="ToString">
    public override string ToString()
    {
    int len;
    string xml_str = "<xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
    <xsl:for-each select="*">
      <xsl:choose>
        <xsl:when test="name()='field'">
          if(<xsl:value-of select="@name"/>!=null)
          {
          <xsl:choose>
            <xsl:when test ="@format='Hex'">
              xml_str +="<xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>" + <xsl:value-of select="@name"/>.ToHexString() + "<xsl:text disable-output-escaping="yes">&lt;/</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
            </xsl:when>
            <xsl:otherwise>
              xml_str +="<xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>" + <xsl:value-of select="@name"/>.ToString() + "<xsl:text disable-output-escaping="yes">&lt;/</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
            </xsl:otherwise>
          </xsl:choose>
          }
        </xsl:when>
        <xsl:when test="name()='parameter'">
          if(<xsl:call-template name='DefineParameterName'/>!= null)
          {
          <xsl:choose>
            <xsl:when test="@type='Custom'">
              <!--xml_str += "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>Custom<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";-->
              <xsl:choose>
                <xsl:when test="@repeat = '0-N' or @repeat = '1-N'">
                  len = <xsl:call-template name='DefineParameterName'/>.Length;
                  for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>len;i++)
                  xml_str += <xsl:call-template name='DefineParameterName'/>[i].ToString();
                </xsl:when>
                <xsl:otherwise>
                  xml_str += <xsl:call-template name='DefineParameterName'/>.ToString();
                </xsl:otherwise>
              </xsl:choose>
              <!--xml_str += "<xsl:text disable-output-escaping="yes">&lt;</xsl:text>/Custom<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";-->
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@repeat = '0-N' or @repeat = '1-N'">
                  len = <xsl:call-template name='DefineParameterName'/>.Length;
                  for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>len;i++)
                  xml_str += <xsl:call-template name='DefineParameterName'/>[i].ToString();
                </xsl:when>
                <xsl:otherwise>
                  xml_str += <xsl:call-template name='DefineParameterName'/>.ToString();
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          }
        </xsl:when>
        <xsl:when test="name()='choice'">
          <xsl:variable name="choiceParameterName">
            <xsl:call-template name='DefineParameterName'/>
          </xsl:variable>
          if(<xsl:call-template name='DefineParameterName'/>!= null)
          {
          len = <xsl:copy-of select='$choiceParameterName'/>.Count;
          for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>len;i++)xml_str += <xsl:copy-of select='$choiceParameterName'/>[i].ToString();
          }
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    xml_str += "<xsl:text disable-output-escaping="yes">&lt;/</xsl:text><xsl:value-of select="@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
    return xml_str;
    }
  </xsl:template>
  <xsl:template name="FromXmlNode">
    public static PARAM_<xsl:value-of select="@name"/>  FromXmlNode(XmlNode node)
    {
    string val;
    PARAM_<xsl:value-of select="@name"/> param = new PARAM_<xsl:value-of select="@name"/>();

    <xsl:for-each select="*">
      <xsl:choose>
        <xsl:when test="name()='field'">
          val = XmlUtil.GetNodeValue(node, "<xsl:value-of select="@name"/>");
          <xsl:choose>
            <xsl:when test="@enumeration">
              param.<xsl:value-of select="@name"/> = (<xsl:call-template name='DefineDataType'/>)Enum.Parse(typeof(<xsl:call-template name='DefineDataType'/>), val);
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="@type='u1v' or @type='u2' or @type='u8v' or @type='u16v' or @type='u32v' or @type='u96' or @type='bytesToEnd'">
                param.<xsl:value-of select="@name"/> = <xsl:call-template name='DefineDataType'/>.FromString(val);
              </xsl:if>
              <xsl:if test="@type='u1'">
                param.<xsl:value-of select="@name"/> = Convert.ToBoolean(val);
              </xsl:if>
              <xsl:if test="@type='u8'">
                param.<xsl:value-of select="@name"/> = Convert.ToByte(val);
              </xsl:if>
              <xsl:if test="@type='s8'">
                param.<xsl:value-of select="@name"/> = Convert.ToSByte(val);
              </xsl:if>
              <xsl:if test="@type='u16'">
                param.<xsl:value-of select="@name"/> = Convert.ToUInt16(val);
              </xsl:if>
              <xsl:if test="@type='s16'">
                param.<xsl:value-of select="@name"/> = Convert.ToInt16(val);
              </xsl:if>
              <xsl:if test="@type='u32'">
                param.<xsl:value-of select="@name"/> = Convert.ToUInt32(val);
              </xsl:if>
              <xsl:if test="@type='u64'">
                param.<xsl:value-of select="@name"/> = Convert.ToUInt64(val);
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="name()='parameter'">
          try
          {
          <xsl:choose>
            <xsl:when test="@type='Custom'">
              <xsl:choose>
                <xsl:when test="@repeat = '0-N' or @repeat = '1-N'">
                  ArrayList xnl = XmlUtil.GetXmlNodeCustomChildren(node);
                  if(xnl!=null)
                  {
                  if(xnl.Count!=0)
                  {
                  for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>xnl.Count; i++)
                  {
                  ICustom_Parameter custom = CustomParamDecodeFactory.DecodeXmlNodeToCustomParameter((XmlNode)xnl[i]);
                  if(custom!=null)param.AddCustomParameter(custom);
                  }
                  }
                  }
                </xsl:when>
                <xsl:otherwise>
                  ArrayList xnl = XmlUtil.GetXmlNodeCustomChildren(node);
                  if(xnl!=null)
                  {
                  if(xnl.Count!=0)
                  param.<xsl:call-template name='DefineParameterName'/> = CustomParamDecodeFactory.DecodeXmlNodeToCustomParameter((XmlNode)xnl[0]);
                  }
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@repeat = '0-N' or @repeat = '1-N'">
                  XmlNodeList xnl = XmlUtil.GetXmlNodes(node, "<xsl:call-template name='DefineParameterName'/>");
                  if(xnl!=null)
                  {
                  if(xnl.Count!=0)
                  {
                  param.<xsl:call-template name='DefineParameterName'/> = new PARAM_<xsl:value-of select="@type"/>[xnl.Count];
                  for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>xnl.Count; i++)
                  param.<xsl:call-template name='DefineParameterName'/>[i] = PARAM_<xsl:value-of select="@type"/>.FromXmlNode(xnl[i]);
                  }
                  }
                </xsl:when>
                <xsl:otherwise>
                  XmlNodeList xnl = XmlUtil.GetXmlNodes(node, "<xsl:call-template name='DefineParameterName'/>");
                  if(null!=xnl)
                  {
                  if(xnl.Count!=0)
                  param.<xsl:call-template name='DefineParameterName'/> = PARAM_<xsl:value-of select="@type"/>.FromXmlNode(xnl[0]);
                  }
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          }catch{}
        </xsl:when>
        <xsl:when test="name()='choice'">
          {
          <xsl:variable name="choiceParameterName">
            <xsl:call-template name='DefineParameterName'/>
          </xsl:variable>
          param.<xsl:copy-of select='$choiceParameterName'/> = new UNION_<xsl:value-of select="@type"/>();
          <xsl:for-each select='../../llrp:choiceDefinition'>
            <xsl:if test='@name=$choiceParameterName'>
              try
              {
              <xsl:for-each select='*'>
                <xsl:choose>
                  <xsl:when test="@type='Custom'">
                    {
                    XmlNodeList xnl = XmlUtil.GetXmlNodes(node, "<xsl:call-template name='DefineParameterName'/>");
                    if(xnl.Count!=0)
                    {
                    for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>xnl.Count; i++)
                    {
                    ICustom_Parameter custom = CustomParamDecodeFactory.DecodeXmlNodeToCustomParameter(xnl[i]);
                    if(custom!=null)param.<xsl:copy-of select='$choiceParameterName'/>.Add(custom);
                    }
                    }
                    }
                  </xsl:when>
                  <xsl:otherwise>
                    {
                    XmlNodeList xnl = XmlUtil.GetXmlNodes(node, "<xsl:call-template name='DefineParameterName'/>");
                    if(xnl.Count!=0)
                    {
                    for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>xnl.Count; i++)
                    param.<xsl:copy-of select='$choiceParameterName'/>.Add(PARAM_<xsl:value-of select='@type'/>.FromXmlNode(xnl[i]));
                    }
                    }
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              }catch{}
            </xsl:if>
          </xsl:for-each>
          }
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    return param;
    }
  </xsl:template>
  <xsl:template name="EncodeToBitArray">
    public override void ToBitArray(ref bool[] bit_array, ref int cursor)
    {
    int len;
    int cursor_old = cursor;
    BitArray bArr;

    if(tvCoding)
    {
    bit_array[cursor] = true;
    cursor++;

    bArr = Util.ConvertIntToBitArray(typeID, 7);
    bArr.CopyTo(bit_array, cursor);

    cursor+=7;
    }
    else
    {
    cursor += 6;
    bArr = Util.ConvertIntToBitArray(typeID, 10);
    bArr.CopyTo(bit_array, cursor);

    cursor+=10;
    cursor+=16;     //Omit the parameter length, will be added at the end.
    }

    <xsl:for-each select="*">
      <xsl:if test="name()='field'">
        if(<xsl:value-of select="@name"/>!=null)
        {
        <xsl:choose>
          <xsl:when test="@type='u1v' or @type='u8v' or @type='u16v' or @type='u32v' or @type='utf8v' or @type='u96' or @type='bytesToEnd'">
            try
            {
            int temp_cursor = cursor;
            <xsl:choose>
              <xsl:when test="@type='utf8v'">
                BitArray tempBitArr = Util.ConvertIntToBitArray((UInt32)(<xsl:value-of select="@name"/>.Length), 16);
              </xsl:when>
              <xsl:otherwise>
                BitArray tempBitArr = Util.ConvertIntToBitArray((UInt32)(<xsl:value-of select="@name"/>.Count), 16);
              </xsl:otherwise>
            </xsl:choose>
            tempBitArr.CopyTo(bit_array, cursor);
            cursor+=16;

            tempBitArr = Util.ConvertObjToBitArray(<xsl:value-of select="@name"/>, <xsl:value-of select="@name"/>_len);
            tempBitArr.CopyTo(bit_array, cursor);
            cursor += tempBitArr.Length;
            }
            catch
            {
            }
          </xsl:when>
          <xsl:otherwise>
            try
            {
            BitArray tempBitArr = Util.ConvertObjToBitArray(<xsl:value-of select="@name"/>, <xsl:value-of select="@name"/>_len);
            tempBitArr.CopyTo(bit_array, cursor);
            cursor += tempBitArr.Length;
            }
            catch{}
          </xsl:otherwise>
        </xsl:choose>
        }
      </xsl:if>
      <xsl:if test="name()='reserved'">
        cursor += param_reserved_len;
      </xsl:if>
      <xsl:if test="name()='parameter'">
        if(<xsl:call-template name='DefineParameterName'/> != null)
        {
        <xsl:choose>
          <xsl:when test="@repeat = '0-N' or @repeat = '1-N'">
            len = <xsl:call-template name='DefineParameterName'/>.Length;
            for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>len;i++)
            <xsl:call-template name='DefineParameterName'/>[i].ToBitArray(ref bit_array, ref cursor);
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name='DefineParameterName'/>.ToBitArray(ref bit_array, ref cursor);
          </xsl:otherwise>
        </xsl:choose>
        }
      </xsl:if>
      <xsl:if test="name()='choice'">
        <xsl:variable name="choiceParameterName">
          <xsl:call-template name='DefineParameterName'/>
        </xsl:variable>
        len = <xsl:copy-of select='$choiceParameterName'/>.Count;
        for(int i=0; i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>len;i++)<xsl:copy-of select='$choiceParameterName'/>[i].ToBitArray(ref bit_array, ref cursor);
      </xsl:if>
    </xsl:for-each>

    if(!tvCoding)
    {
    UInt32 param_len = (UInt32)(cursor-cursor_old)/8;
    bArr = Util.ConvertIntToBitArray(param_len,16);
    bArr.CopyTo(bit_array, cursor_old+16);
    }
    }
  </xsl:template>
  <xsl:template name="DecodeFromBitArray">
    public new static PARAM_<xsl:value-of select="@name"/> FromBitArray(ref BitArray bit_array, ref int cursor, int length)
    {
    if(cursor<xsl:text disable-output-escaping="yes">&gt;=</xsl:text>length)return null;

    int field_len = 0;
    object obj_val;
    int parameter_len = 0;
    ArrayList param_list = new ArrayList();

    PARAM_<xsl:value-of select="@name"/> param = new PARAM_<xsl:value-of select="@name"/>();

    int param_type = 0;

    if(bit_array[cursor])param.tvCoding = true;
    if(param.tvCoding)
    {
    cursor ++;
    param_type = (int)(UInt64)Util.CalculateVal(ref bit_array, ref cursor, 7);

    if(param_type!= param.TypeID)
    {
    cursor -=8;
    return null;
    }
    }
    else
    {
    cursor += 6;
    param_type = (int)(UInt64)Util.CalculateVal(ref bit_array, ref cursor, 10);

    if(param_type!=param.TypeID)
    {
    cursor -=16;
    return null;
    }
    param.length = (UInt16)(int)Util.DetermineFieldLength(ref bit_array, ref cursor);
    }

    <xsl:for-each select="*">
      <xsl:if test="name()='field'">
        if(cursor<xsl:text disable-output-escaping="yes">&gt;</xsl:text>length)throw new Exception("Input data is not complete message");
        <xsl:if test="@type='u1v' or @type='u8v' or @type='u16v' or @type='u32v' or @type='utf8v'">
          field_len = Util.DetermineFieldLength(ref bit_array, ref cursor);
        </xsl:if>
        <xsl:if test="@type='bytesToEnd'">
          field_len = (bit_array.Length - cursor)/8;
        </xsl:if>
        <xsl:if test="@type='u96'">
          field_len = 96;
        </xsl:if>
        <xsl:if test="@type='u2'">
          field_len = 2;
        </xsl:if>
        <xsl:if test="@type='u1'">
          field_len = 1;
        </xsl:if>
        <xsl:if test="@type='u8' or @type='s8'">
          field_len = 8;
        </xsl:if>
        <xsl:if test="@type='u16' or @type='s16'">
          field_len = 16;
        </xsl:if>
        <xsl:if test="@type='u32'">
          field_len = 32;
        </xsl:if>
        <xsl:if test="@type='u64'">
          field_len = 64;
        </xsl:if>
        <xsl:choose>
          <xsl:when test="@enumeration and @type!='u8v'">
            Util.ConvertBitArrayToObj(ref bit_array, ref cursor, out obj_val, typeof(UInt32), field_len);
            param.<xsl:value-of select="@name"/> = (<xsl:call-template name='DefineDataType'/>)(UInt32)obj_val;
          </xsl:when>
          <xsl:otherwise>
            Util.ConvertBitArrayToObj(ref bit_array, ref cursor, out obj_val, typeof(<xsl:call-template name='DefineDataType'/>), field_len);
            param.<xsl:value-of select="@name"/> = (<xsl:call-template name='DefineDataType'/>)obj_val;
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name()='reserved'">
        cursor += param_reserved_len;
      </xsl:if>
      <xsl:if test="name()='parameter'">
        <xsl:choose>
          <xsl:when test="@type='Custom'">
            <xsl:if test="@repeat = '1-N' or @repeat = '0-N'">
              ICustom_Parameter custom = CustomParamDecodeFactory.DecodeCustomParameter(ref bit_array, ref cursor, length);
              if(custom!=null)
              {
              param.<xsl:call-template name='DefineParameterName'/>.Add(custom);
              while((custom = CustomParamDecodeFactory.DecodeCustomParameter(ref bit_array, ref cursor, length))!=null)param.<xsl:call-template name='DefineParameterName'/>.Add(custom);
              }
            </xsl:if>
            <xsl:if test="@repeat = '1' or @repeat='0-1'">
              param.<xsl:call-template name='DefineParameterName'/> = CustomParamDecodeFactory.DecodeCustomParameter(ref bit_array, ref cursor, length);
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@repeat = '1-N' or @repeat = '0-N'">
              param_list = new ArrayList();
              PARAM_<xsl:value-of select="@type"/> _param_<xsl:value-of select="@type"/> =  PARAM_<xsl:value-of select="@type"/>.FromBitArray(ref bit_array, ref cursor, length);
              if(_param_<xsl:value-of select="@type"/>!=null)
              {param_list.Add(_param_<xsl:value-of select="@type"/>);
              while((_param_<xsl:value-of select="@type"/>=PARAM_<xsl:value-of select="@type"/>.FromBitArray(ref bit_array, ref cursor, length))!=null)param_list.Add(_param_<xsl:value-of select="@type"/>);
              if(param_list.Count<xsl:text disable-output-escaping="yes">&gt;</xsl:text>0)
              {
              param.<xsl:call-template name='DefineParameterName'/> = new PARAM_<xsl:value-of select="@type"/>[param_list.Count];
              for(int i=0;i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>param_list.Count;i++)
              param.<xsl:call-template name='DefineParameterName'/>[i] = (PARAM_<xsl:value-of select="@type"/>)param_list[i];
              }
              }
            </xsl:if>
            <xsl:if test="@repeat = '1' or @repeat='0-1'">
              param.<xsl:call-template name='DefineParameterName'/> = PARAM_<xsl:value-of select="@type"/>.FromBitArray(ref bit_array, ref cursor, length);
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="name()='choice'">
        <xsl:variable name="choiceParameterName">
          <xsl:call-template name='DefineParameterName'/>
        </xsl:variable>
        <xsl:for-each select='../../llrp:choiceDefinition'>
          <xsl:if test='@name=$choiceParameterName'>
            <xsl:for-each select='*'>
              <xsl:choose>
                <xsl:when test="@type='Custom'">
                  ICustom_Parameter sub_custom = CustomParamDecodeFactory.DecodeCustomParameter(ref bit_array, ref cursor, length);
                  if(sub_custom!=null)
                  {
                  param.<xsl:copy-of select='$choiceParameterName'/>.Add(sub_custom);
                  while((sub_custom = CustomParamDecodeFactory.DecodeCustomParameter(ref bit_array, ref cursor, length))!=null)
                  param.<xsl:copy-of select='$choiceParameterName'/>.Add(sub_custom);
                  }
                </xsl:when>
                <xsl:otherwise>
                  PARAM_<xsl:value-of select='@type'/> _param_<xsl:value-of select='@type'/> = PARAM_<xsl:value-of select='@type'/>.FromBitArray(ref bit_array, ref cursor, length);
                  if(_param_<xsl:value-of select='@type'/>!=null)
                  {
                  param.<xsl:copy-of select='$choiceParameterName'/>.Add(_param_<xsl:value-of select='@type'/>);
                  while((_param_<xsl:value-of select='@type'/> = PARAM_<xsl:value-of select='@type'/>.FromBitArray(ref bit_array, ref cursor, length))!=null)
                  param.<xsl:copy-of select='$choiceParameterName'/>.Add(_param_<xsl:value-of select='@type'/>);
                  }
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
    return param;
    }
  </xsl:template>
</xsl:stylesheet>