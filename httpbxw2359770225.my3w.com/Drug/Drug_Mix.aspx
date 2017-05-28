<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Drug.master" AutoEventWireup="true" CodeFile="Drug_Mix.aspx.cs" Inherits="Drug_Drug_Mix" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>试剂信息查询</title>
    <link rel="stylesheet" href="../CSS/drugMix.css">
    <script type="text/javascript">
        var id = "<%=GetSession("ID")%>";
        var pw = "<%=GetSession("PW")%>";
        var manager = "<%=GetSession("rank_drug")%>";
    </script>
    <script src="../js/drugMix.js"></script>
     <script type="text/javascript">

        //  function GetDrugMix() {
        //      //通过试剂名称模糊查找 a 为试剂名字 非json
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("drugmixname").value;
        //      Webservice_Drug.GetDrugMix(ID, PW, a, GetValue);
        //  }
        //  function GetDrugMix1() {
        //      //通过试剂名称精确查找 a 为试剂名字 非json
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("drugmixname").value;
        //      Webservice_Drug.GetDrugMixByName(ID, PW, a, GetValue);
        //  }
        //  function GetDrugMixDetail() {
        //      // a 为试剂名字 非json 得到该试剂对应的药品信息
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("drugmixname").value;
        //      Webservice_Drug.GetDrugMix_Struct(ID, PW, a, GetValue2);
        //  }
        //  function Insert_Update_MixDrug() {
        //      //对试剂基本信息添加或修改操作 a为试剂基本信息json  drugmixname1为试剂原来的名字 需要一个hidden存原试剂名 当试剂名修改时 作为查找依据   如果添加试剂名存在则为更新操作 不存在则为添加操作
        //      //json 示例      [{"drug_mix":"试剂1","attention":"试剂11"}]
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      drugmixname1
        //      a = document.getElementById("TextArea1").value;
        //      b = document.getElementById("TextArea2").value;
        //      c = document.getElementById("TextArea4").value;
        //      drugmixname = document.getElementById("drugmixname1").value;
        //      Webservice_Drug.DrugMix_Insert_Update(ID, PW, a, drugmixname, GetValue);
        //  }
        //  function Insert_Update_Drug_MixDrug() {
        //      //将修改好的试剂对应药品配方json b 和试剂对应试剂配方 json c 一起传入 完成添加修改 drugmixname1为试剂名
        //      //b示例  [{"drug_mix":"试剂1","drug_name":"30%乙醇","num":"4","standard":"g"},{"drug_mix":"试剂1","drug_name":"98%己醇","num":"5","standard":"g"}]
        //      //c 示例  [{"drug_mix":"试剂2","num":"5"}]
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //       var PW = "1111"; //"<%=GetSession("PW")%>";
        //       b = document.getElementById("TextArea2").value;
        //       c = document.getElementById("TextArea4").value;
        //       drugmixname = document.getElementById("drugmixname1").value;
        //       Webservice_Drug.DrugMixDrug_Insert_Update(ID, PW, b, c,drugmixname, GetValue);
        //   }
        //  function Delete() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //      var PW = "1111"; //"<%=GetSession("PW")%>";
        //      a = document.getElementById("drugmixname").value;
        //      Webservice_Drug.DrugMix_Delete(ID, PW, a, GetValue)
        //  }
        //  function GetValue(result) {
        //      //显示返回的值
         //
        //      document.getElementById("TextArea1").value = result;
        //  }
        //  function GetValue2(result) {
        //      //显示返回的值
         //
        //      document.getElementById("TextArea2").value = result;
        //  }
        //  function GetDrug() {
        //      //设置参数，并帮定脚本事件
        //      var ID = "1111"; //"<%=GetSession("ID")%>";
        //       var PW = "1111"; //"<%=GetSession("PW")%>";
        //       a = document.getElementById("drugname").value;
        //       Webservice_Drug.GetDrug(ID, PW, a, GetValue3);
        //   }
        //  function GetValue3(result) {
        //      //显示返回的值
         //
        //      document.getElementById("TextArea3").value = result;
        //  }
        //  function GetValue5(result) {
        //      //显示返回的值
         //
        //      document.getElementById("TextArea5").value = result;
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
        <a href="javascript:void(0)">试剂信息查询</a>
    </nav>
    <label>
        <input id="keyword" type="text" placeholder="输入试剂名称"><button id="btnSearch">搜索</button>
    </label>
    <table id="result">
        <thead>
            <tr>
                <th>试剂名</th>
                <th>注意事项</th>
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
                    <li data-id="recipePane">配方表</li>
                    <li data-id="countPane">计算用量</li>
                </ul>
                <button class="close">X</button>
            </div>
            <div class="modal_main active" id="basePane">
                <div>
                    <span>试剂名称</span><input type="text" disabled="disabled" placeholder="请输入试剂名称">
                </div>
                <div>
                    <span>单位</span><input type="text" disabled="disabled">
                </div>
                <div class="full">
                    <label>注意事项</label>
                    <textarea id="baseAttention" disabled="disabled" placeholder="请输入相关注意事项"></textarea>
                </div>
            </div>
            <div class="modal_main" id="recipePane">
                <section id="recipeSearch">
                    <article id="recipeDrug">
                        <input id="inRecipeDrug" type="text" placeholder="药品名称"><button id="btnRecipeDrug">搜索</button>
                        <ul>
                            <li><span>111111111111111111111111111111111111111111</span> <i>g</i><input type="text"></li>
                            <li>2 <i>ml</i><input type="text"></li>
                            <li>3 <input type="text"></li>
                        </ul>
                        <div class="btns">
                            <button id="btnAddDrug">添加药品</button>
                            <button id="btnDrugDetail">药品详情</button>
                            <button id="btnFindMix">查找试剂</button>
                        </div>
                    </article>
                    <article id="recipeMix">
                        <input id="inRecipeMix" type="text" placeholder="试剂名称"><button id="btnRecipeMix">搜索</button>
                        <ul>
                            <li>1 <input type="text"></li>
                            <li>2 <input type="text"></li>
                            <li>3 <input type="text"></li>
                        </ul>
                        <div class="btns">
                            <button id="btnAddMix">添加试剂</button>
                            <button id="btnMixDetail">试剂详情</button>
                            <button id="btnFindDrug">查找药品</button>
                        </div></article>
                </section>
                <section id="recipeInfo">
                    <label>药品信息</label>
                    <ul id="recipeDrugInfo">
                    </ul>
                    <label>试剂信息</label>
                    <ul id="recipeMixInfo">
                    </ul>
                </section>
            </div>
            <div class="modal_main" id="countPane">
                <div id="calculator">
                    <span>XXX药品</span><input type="text"><i>g</i>
                </div>
                <div id="drug_container">
                    <div class="drug_item">ABC <span></span>g<button>详情</button></div>
                    <div class="drug_item">DEF <span></span>ml</div>
                    <div class="drug_item">GHI <span></span>mg</div>
                    <div class="drug_item">JKL <span></span>kg</div>
                    <div class="drug_item">MNO <span></span>l</div>
                    <div class="drug_item">PQR <span></span>nl</div>
                    <div class="drug_item">ABC <span></span>g</div>
                    <div class="drug_item">DEF <span></span>ml</div>
                    <div class="drug_item">GHI <span></span>mg</div>
                    <div class="drug_item">JKL <span></span>kg</div>
                    <div class="drug_item">MNO <span></span>l</div>
                    <div class="drug_item">PQR <span></span>nl</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 试剂库 1.试剂的模糊查询： 使用 GetDrugMix()得到试剂的基本情况 包括名称和注意事项 <br />
           2.试剂的详细信息： GetDrugMixDetail()需要模糊查找得到的某个试剂名去详细查询 得到试剂的基本信息和配方 <br />
           3.试剂的插入和更新：Insert_Update() TextArea1拿到基本信息的json TextArea2拿到配方json 但配方的药品一定是药品库有的<br />
             我把药品库那边的查询函数也放过来了 你直接查然后拖动  <br />
           4.删除就是直接删掉了 Delete()

    <br />
    大概看一下js函数 我觉得你应该能懂

    <br />
         试剂名称查询：<input type="text" id="drugmixname" />
                     <br />
            <input id ="b2" type="button" value="搜索试剂" onclick="GetDrugMix()" />
            <br />
                  <br />
                试剂基本信息<textarea id="TextArea1" cols="20" rows="5" name="S1"></textarea>
                    <br />
                    药品名称输入：<input type="text" id="drugname" />
    <input id ="b6" type="button" value="搜索药品" onclick="GetDrug()" />
                     <br />
                    查询药品列表：<textarea id="TextArea3" cols="20" rows="5" name="S1"></textarea>

                    <br />
      试剂查询输入：<input type="text" id="drugmix" />
    <input id ="b66" type="button" value="搜索试剂用来加入配方" onclick="GetDrugMix()" />&nbsp;
                     <br />
                    查询试剂的列表：<textarea id="TextArea5" cols="20" rows="5" name="S1"></textarea>

                    <br />
      <br />

                    显示试剂的药品配方：<textarea id="TextArea2" cols="20" rows="5" name="S1"></textarea>
                  <br />
            显示试剂的试剂配方（仅作为修改试剂信息时候的输入 之后转换成对应药品储存）：<textarea id="TextArea4" cols="20" rows="5" name="S1"></textarea>
                  <br />


            <br />

     <input id ="b23" type="button" value="准确搜索试剂基本信息" onclick="GetDrugMix1()" />
     <input id ="b3" type="button" value="试剂配方" onclick="GetDrugMixDetail()" />
         <br />

               <input type="text" id="drugmixname1" /> <input id ="b4" type="button" value="添加或更新基本信息" onclick="Insert_Update_MixDrug()" />
    <input id ="b41" type="button" value="添加或更新配方信息" onclick="Insert_Update_Drug_MixDrug()" />
     <br />

             <input id ="b5" type="button" value="删除" onclick="Delete()" /> -->


</asp:Content>
