<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Drug.master" AutoEventWireup="true" CodeFile="Drug_Info.aspx.cs" Inherits="Drug_Drug_Info" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>药品信息查询</title>
<link rel="stylesheet" href="../CSS/drugSearch.css">
<script type="text/javascript">
    var id = "<%=GetSession("ID")%>";
    var pw = "<%=GetSession("PW")%>";
    var manager = "<%=GetSession("rank_drug")%>";
</script>
<script src="../js/drugSearch.js"></script>
<script>

        //  function GetDrug() {
        //      //设置参数，并帮定脚本事件
        //      a = document.getElementById("txtname").value;
        //      Webservice_Drug.GetDrug(ID, PW, a, GetValue);
         //
        //  }
         // function a() {
             //设置参数，并帮定脚本事件
          //    var ID = "1111"; //"<%=GetSession("ID")%>";
           //   var PW = "1111"; //"<%=GetSession("PW")%>";
            // a = document.getElementById("txtname").value;
             //  Webservice_Drug.GetDrugLoc(ID, PW, a, GetValue);

          //}
         //
        //  function GetDrugDetail() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("txtname").value;
        //      Webservice_Drug.GetDrugDetail(ID,PW,a,GetValue);
        //  }
        //  function GetDrugDetailLoc() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //       var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("pos").value;
         //
        //      Webservice_Drug.GetDrugLocDetail(ID, PW, a, GetValue);
        //   }
        //  function Insert_Update() {
        //      //此处用于插入或更新数据，传入药品名。
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("TextArea1").value;
        //      drug_name  = document.getElementById("drug_name").value;
         //
        //      Webservice_Drug.Drug_Insert_Update(ID, PW, a,drug_name, GetValue);
        //  }
         //
         // function b() {
              //此处用于插入或更新数据，传入药品名。如果更新数据且存储量发生变化，变化值存入变量change
           //   var ID = "1111"; //"<%=GetSession("ID")%>";
            //   var PW = "1111"; //"<%=GetSession("PW")%>";
             // a = document.getElementById("TextArea1").value;
              // var change = 1;
             //  Webservice_Drug.Drug_Insert_UpdateLocAll(ID, PW, a, GetValue);
          //}
        //  function Delete() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //        var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("txtname").value;
        //        change = 1;
        //        Webservice_Drug.Drug_Delete(ID, PW, a, GetValue)
        //    }
        //  function DeleteLoc() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //       var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("pos").value;
        //      change = 1;
        //      Webservice_Drug.Drug_DeleteLoc(ID, PW, a,change, GetValue)
        //   }
        //  function GetValue(result) {
              //显示返回的值

          //    document.getElementById("TextArea1").value = result;
          //}
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
        <a href="javascript:void(0)">药品查询</a>
    </nav>
    <label>
        <input id="keyword" type="text" placeholder="输入药品名称"><button id="btnSearch">搜索</button>
    </label>
    <table id="result">
        <thead>
            <tr>
                <th>药品名</th>
                <th>化学式</th>
                <th>药品别名</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <ul id="page">
    </ul>
    <div id="detailModal" class="modal">
        <div class="modal_container">
            <div class="modal_header">
                <ul>
                    <li class="active" data-id="basePane">基本信息</li>
                    <li data-id="locPane">位置信息</li>
                </ul>
                <button class="close">X</button>
            </div>
            <div class="modal_main active" id="basePane">
                <div class="half">
                    <span>药品名</span><input maxlength="40" type="text" disabled="disabled">
                </div>
                <div class="half">
                    <span>药品别名</span><input maxlength="200" type="text" disabled="disabled">
                </div>
                <div class="half">
                    <span>药品英文名</span><input maxlength="40" type="text" disabled="disabled">
                </div>
                <div class="half">
                    <span>CAS</span><input maxlength="30" type="text" disabled="disabled">
                </div>
                <div class="half">
                    <span>分子式</span><input maxlength="100" type="text" disabled="disabled">
                </div>
                <div class="half">
                    <span>分子量</span><input maxlength="40" type="text" disabled="disabled">
                </div>
                <div class="half">
                    <span>危险性</span><input maxlength="10" type="text" disabled="disabled">
                </div>
                <div class="full">
                    <label>注意事项</label>
                    <textarea maxlength="100" type="text" disabled="disabled"></textarea>
                </div>
            </div>
            <div class="modal_main" id="locPane"></div>
        </div>
    </div>

    <!-- 药品库包含功能：<br />
      1：模糊查找药品 GetDrug（）<br />
      2：通过模糊查找找到药品名后 精确查找该药品的详细信息（药品名一字不差为精确查找）GetDrugDetail()<br />
      3.修改删除药品 Insert_Update() Delete() 修改药品时候的输入变量需要注意下<br />
         药品名或位置id：<input type="text" id="txtname" />
                     <br />
                  <br />
                <textarea id="TextArea1" cols="20" rows="5" name="S1"></textarea>

                  <br />

                <input id ="b2" type="button" value="搜索药品" onclick="GetDrug()" />
            <br />

             请输入账户密码，均为空或者错误均返回一般用户


             <input id ="b3" type="button" value="搜索药品详细资料" onclick="GetDrugDetail()" />
         <br />
            在第二个输入框输入json格式信息 返回情况 输入框输入的修改前的药品名 用于定位
    <br />（在更新的时候你可以用个hidden控件 在填数据时候给hidden赋值就好，对于插入 那个值就是插入的药品名）
             <input type="text" id="drug_name" />  <input id ="b4" type="button" value="添加或更新" onclick="Insert_Update()" />
     <br />
            删除 在第一个输入框输入药品名 返回情况
             <input id ="b51" type="button" value="删除" onclick="Delete()" />

      <br />
            查看药品位置信息列表 在第一个输入框输入药品名 返回情况
             <input id ="b52" type="button" value="位置" onclick="a()" />  <br />
     <input type="text" id="pos" />
      <br />
            查看药品具体细信息在第三个输入框输入位置id 返回情况
             <input id ="b53" type="button" value="详细位置" onclick="GetDrugDetailLoc()" />
      <br />


         用于删除药品位置 在第三个输入框输入位置id 返回情况
    <input id ="b54" type="button" value="删除" onclick="DeleteLoc()" />
     <br />

             用于修改药品位置 在第二个输入框输入位置id 返回情况<br />
            <input id ="b55" type="button" value="修改位置" onclick="b()" /> -->


</asp:Content>
