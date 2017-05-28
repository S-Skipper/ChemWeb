<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Experment.master" AutoEventWireup="true" CodeFile="Experment_Inf.aspx.cs" Inherits="Experment_Experment_Inf" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>实验信息查询</title>
     <script type="text/javascript">
         function GetExperience() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("experment").value;
             WebService_Exper.GetExperience(ID, PW, a, GetValue1_1);
            
         }
         function GetExpDetail() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("experment").value;
             WebService_Exper.GetExperience(ID, PW, a, GetValue1_2);
             WebService_Exper.GetExp_Drug(ID, PW, a, GetValue2_2);
             WebService_Exper.GetExp_Mix(ID, PW, a, GetValue3_2);
             WebService_Exper.GetExp_Room(ID, PW, a, GetValue4_2);
             WebService_Exper.GetExp_AllDrug(ID, PW, a, GetValue4_3);
         }
         function Insert_Update() {

             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("TextArea1_2").value;
             b = document.getElementById("TextArea2_2").value;
             c = document.getElementById("TextArea3_2").value;
             d = document.getElementById("TextArea4_2").value;
             experment1 = document.getElementById("experment1").value;
             WebService_Exper.Exper_Insert_Update(ID, PW, a, b, c, d, experment1, GetValue1_1);
         }
         function Delete() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("experment").value;
             WebService_Exper.Exper_Delete(ID, PW, a, GetValue1_1)
         }
         function GetExperPrivate() {
             //设置参数，并帮定脚本事件
             var ID = "13354442"; //"<%=GetSession("ID")%>";
             var PW = "13354442"; //"<%=GetSession("PW")%>";
             WebService_Exper.Exper_LoginByID(ID, PW,GetValue41);

         }
         function GetExperGetLogin() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("name").value;
             WebService_Exper.Exper_LoginByName(ID, PW, a, GetValue43);

         }
         function Insert_Update_Login() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("TextArea43").value;
             b = document.getElementById("name").value;
             WebService_Exper.Exper_LoginInsert_Update(ID, PW, a,b, GetValue43);

         }
         function Exper_Check() {
             //判断某个一般用户是否有添加用户的权限
             //b 为输入的实验的名字
             var ID = "13354442"; //"<%=GetSession("ID")%>";
             var PW = "13354442"; //"<%=GetSession("PW")%>";
             b = document.getElementById("name").value;
             WebService_Exper.Exper_Check(ID, PW, b, GetValue43);

         }

         function GetValue1_1(result) {
             //显示返回的值

             document.getElementById("TextArea1_1").value = result;
         }
         function GetValue1_2(result) {
             //显示返回的值

             document.getElementById("TextArea1_2").value = result;
         }
         function GetValue2_1(result) {
             //显示返回的值

             document.getElementById("TextArea2_1").value = result;
         }
         function GetValue2_2(result) {
             //显示返回的值

             document.getElementById("TextArea2_2").value = result;
         }
         function GetValue3_1(result) {
             //显示返回的值

             document.getElementById("TextArea3_1").value = result;
         }
         function GetValue3_2(result) {
             //显示返回的值

             document.getElementById("TextArea3_2").value = result;
         }
         function GetValue4_1(result) {
             //显示返回的值

             document.getElementById("TextArea4_1").value = result;
         }
         function GetValue4_2(result) {
             //显示返回的值

             document.getElementById("TextArea4_2").value = result;
         }
         function GetValue4_3(result) {
             //显示返回的值

             document.getElementById("TextArea4_3").value = result;
         }
         function GetValue41(result) {
             //显示返回的值

             document.getElementById("TextArea41").value = result;
         }
         function GetValue42(result) {
             //显示返回的值

             document.getElementById("TextArea42").value = result;
         }
         function GetValue43(result) {
             //显示返回的值

             document.getElementById("TextArea43").value = result;
         }
         function GetDrug() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("drugname").value;
             Webservice_Drug.GetDrug(ID, PW, a, GetValue2_1);
         }
         function GetDrugDetail() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
              var PW = "1111"; //"<%=GetSession("PW")%>";
              a = document.getElementById("drugname").value;
              Webservice_Drug.GetDrugDetail(ID, PW, a, GetValue2_1);
         }
         function GetDrugMix() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("drugmixname").value;
             Webservice_Drug.GetDrugMix(ID, PW, a, GetValue3_1);
         }
         function GetRoom() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
              var PW = "1111"; //"<%=GetSession("PW")%>";
             WebService_Exper.GetRoom(ID, PW, GetValue4_1);
         }
         function GetUser() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
              var PW = "1111"; //"<%=GetSession("PW")%>";
             WebService_login.GetUserByRank(ID, PW, "rank_experment","一般权限",GetValue42);
             
          }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
          <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
       
         <Services>
                    <asp:ServiceReference Path="../Webservice_Exper.asmx" />
                    <asp:ServiceReference Path="../Webservice_Drug.asmx" />
                    <asp:ServiceReference Path="../WebService_login.asmx" />
          </Services>
    </asp:ScriptManagerProxy> 
    实验管理 1.实验的模糊查询： 使用 GetExperience()得到实验的基本情况（名称以及概述） 模糊搜索实验名称 <br />
           2.实验的详细信息： GetExpDetail()需要模糊查找得到的某个实验名去精确查询 看到的基本信息和各类信息（药品试剂及房间位置） <br />
           3.插入和更新：Insert_Update() TextArea1_2拿到基本信息的json TextArea2_2拿到药品json
           TextArea3_2拿到试剂json TextArea4_2拿到位置json TextArea1_1 TextArea2_1 TextArea3_1 TextArea4_1  分别是各类查询<br />
           4.删除实验以及其他所有信息 Delete()
            
      
    大概看一下js函数 我觉得你应该能懂
 <br />  
         实验名称查询：<input type="text" id="experment" />
            <input id ="b2" type="button" value="搜索实验" onclick="GetExperience()" /> 
            <br />
  
                实验基本信息<textarea id="TextArea1_1" cols="20" rows="5" name="S1"></textarea>
                    
                实验修改信息填写：<textarea id="TextArea1_2" cols="20" rows="5" name="S1"></textarea>
          <br />
                    药品名称输入：<input type="text" id="drugname" />   
            <input id ="b6" type="button" value="搜索药品" onclick="GetDrug()" /> 
            <input id ="b7" type="button" value="搜索药品详细信息" onclick="GetDrugDetail()" /> 
                     <br />
                    显示药品列表：<textarea id="TextArea2_1" cols="20" rows="5" name="S1"></textarea>
                    
                    药品情况显示填写：<textarea id="TextArea2_2" cols="20" rows="5" name="S1"></textarea>
                  <br />
                试剂名称输入：<input type="text" id="drugmixname" /> 
                <input id ="b8" type="button" value="搜索试剂" onclick="GetDrugMix()" /> 
               
                     <br />
                    显示试剂列表：<textarea id="TextArea3_1" cols="20" rows="5" name="S1"></textarea>
                    
                    试剂情况显示填写：<textarea id="TextArea3_2" cols="20" rows="5" name="S1"></textarea>
                  <br />
                  
                 
                <input id ="b10" type="button" value="搜索位置" onclick="GetRoom()" /> 
                     <br />
                    显示位置列表：<textarea id="TextArea4_1" cols="20" rows="5" name="S1"></textarea>
                    
                    位置情况显示填写：<textarea id="TextArea4_2" cols="20" rows="5" name="S1"></textarea>
                  实验转换为药品量：<textarea id="TextArea4_3" cols="20" rows="5" name="S2"></textarea>
                  <br />
            <br />

             <input id ="b3" type="button" value="实验详细资料" onclick="GetExpDetail()" /> 
         <br />
           此按钮对管理员有效其他隐藏 或者是打开个人管理实验界面后一般权限用户可用
               <input type="text" id="experment1" /> <input id ="b4" type="button" value="添加或更新" onclick="Insert_Update()" /> 
     <br />
            此按钮对管理员有效其他隐藏 
             <input id ="b5" type="button" value="删除" onclick="Delete()" /> 
    
     <br />
           此按钮对一般权限用户有效其他隐藏
              <input id ="b454" type="button" value="查看个人管理实验" onclick="GetExperPrivate()" /> 
     可管理界面显示：<textarea id="TextArea41" cols="20" rows="5" name="S1"></textarea>
     <br />
     此按钮对管理员有效其他隐藏 用于查看某个实验对应的管理人员 或者是打开个人管理实验界面后一般权限用户可用
       需要管理的实验名输入：<input type="text" id="name" /> 
    <input id ="b555" type="button" value="人员管理" onclick="GetExperGetLogin()" /> 
    <br />
    <input id ="b525" type="button" value="判断是否有人员管理的权限" onclick="Exper_Check()" /> 
    <br />
    GetUser
     <input id ="b553" type="button" value="人员查看" onclick="GetUser()" /> 
     人员搜索：<textarea id="TextArea42" cols="20" rows="5" name="S1"></textarea>
    可管理人员界面显示：<textarea id="TextArea43" cols="20" rows="5" name="S1"></textarea>
     <br />
           需要输入 需要管理的实验名 以及可管理人员页面后点击按钮
             <input id ="b55" type="button" value="人员管理提交" onclick="Insert_Update_Login()" /> 
</asp:Content>

