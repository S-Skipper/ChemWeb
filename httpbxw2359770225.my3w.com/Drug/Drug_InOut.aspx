<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Drug.master" AutoEventWireup="true" CodeFile="Drug_InOut.aspx.cs" Inherits="Drug_Drug_InOut" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>药品出入库查询</title>
    <link rel="stylesheet" href="../CSS/drugInOut.css">
    <script type="text/javascript">
        var id = "<%=GetSession("ID")%>";
        var pw = "<%=GetSession("PW")%>";
    </script>
    <script src="../js/drugInOut.js"></script>
     <script type="text/javascript">
        //  function GetByName() {
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("txtname").value;
        //      Webservice_Drug.GetDrugInOutByName(ID, PW, a, GetValue);
        //  }
         //
        //  function GetByTime() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("time1").value;
        //      b = document.getElementById("time2").value;
        //      Webservice_Drug.GetDrugInOutByTime(ID, PW, a, b, GetValue);
        //  }
         //
         //
        //  function GetValue(result) {
         //
         //
        //      document.getElementById("TextArea1").value = result;
        //  }



</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="../Webservice_Drug.asmx" />
        </Services>
    </asp:ScriptManagerProxy>

    <nav>
        <a href="javascript:void(0)">药品库</a>
        <a href="javascript:void(0)">药品出入库查询</a>
    </nav>
    <div id="keyTime">
        <label>
            <input type="text" id="keyword" placeholder="输入药品名称">
            <select>
                <option value="all">全部操作</option>
                <option value="in">存入</option>
                <option value="out">取出</option>
            </select>
            <input type="date" id="startTime">
            <input type="date" id="endTime">
        </label>
        <button id="btnSearch">搜索</button>
    </div>
    <table id="result">
        <thead>
            <tr>
                <th>药品名</th>
                <th>操作</th>
                <th>位置信息</th>
                <th>修改人</th>
                <th>修改时间</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <ul id="page">
    </ul>

         <!-- <br />
      根据药品名或者起止时间得到出入库记录<br />
      药品名<input type="text" id="txtname" />
                     <br />
    起始时间
     <input type="text" id="time1" value ="2016-05-14"/>
    <br />
    终止时间
     <input type="text" id="time2" value="2016-05-18" />
                  <br />
                <textarea id="TextArea1" cols="20" rows="5" name="S1"></textarea>

                  <br />

                <input id ="b2" type="button" value="药品名搜索" onclick="GetByName()" />
            <input id ="b3" type="button" value="日期搜索" onclick="GetByTime()" />
 -->

</asp:Content>
